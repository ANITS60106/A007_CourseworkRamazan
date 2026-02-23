from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.authentication import TokenAuthentication

from .models import LoanOffer, ActiveLoan, LoanRequest, CreditHistoryEntry
from .serializers import (
    LoanOfferSerializer,
    ActiveLoanSerializer,
    LoanRequestSerializer,
    CreditHistoryEntrySerializer,
)

class OffersListView(generics.ListAPIView):
    queryset = LoanOffer.objects.all().order_by('rate')
    serializer_class = LoanOfferSerializer
    permission_classes = [permissions.AllowAny]


def _compute_score(user) -> int:
    """A tiny heuristic credit score for a prototype.

    Score range roughly 300..850 (like many real bureaus), but this is NOT real.
    """
    history = CreditHistoryEntry.objects.filter(user=user)
    if not history.exists():
        base = 520
    else:
        base = 600

    for e in history:
        if e.status == 'ontime':
            base += 18
        elif e.status == 'late':
            base -= 45
        elif e.status == 'default':
            base -= 200
        base -= min(e.late_payments, 10) * 4

    # Debt-to-income proxy using active loans
    income = max(int(getattr(user, 'monthly_income', 0) or 0), 1)
    active = ActiveLoan.objects.filter(user=user, status='active')
    monthly = sum(int(a.monthly_payment or 0) for a in active)
    dti = monthly / income
    if dti > 0.6:
        base -= 120
    elif dti > 0.4:
        base -= 60
    elif dti < 0.25:
        base += 20

    return max(300, min(850, base))


class ScoredOffersView(APIView):
    """Return offers with a status (Approved / Alternative / Rejected) based on a prototype scoring."""

    authentication_classes = [TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        amount = int(request.query_params.get('amount', '0') or 0)
        months = int(request.query_params.get('months', '0') or 0)

        score = _compute_score(request.user)

        income = max(int(getattr(request.user, 'monthly_income', 0) or 0), 1)
        active = ActiveLoan.objects.filter(user=request.user, status='active')
        monthly_existing = sum(int(a.monthly_payment or 0) for a in active)

        offers = LoanOffer.objects.all().order_by('rate')
        data = []
        for o in offers:
            # quick payment estimate
            est_payment = 0
            if amount > 0 and months > 0:
                est_payment = int((amount * (1 + (o.rate / 100))) / months)

            dti = (monthly_existing + est_payment) / income

            if amount > o.max_amount and o.max_amount > 0:
                status_lbl = 'alternative'
                recommended_amount = o.max_amount
            else:
                recommended_amount = amount

                if score >= 660 and dti <= 0.45:
                    status_lbl = 'approved'
                elif score >= 600 and dti <= 0.60:
                    status_lbl = 'alternative'
                else:
                    status_lbl = 'rejected'

            data.append({
                'provider_name': o.provider_name,
                'rate': o.rate,
                'months': o.months,
                'max_amount': o.max_amount,
                'status': status_lbl,
                'recommended_amount': recommended_amount,
                'estimated_payment': est_payment,
                'score': score,
            })

        return Response({'score': score, 'offers': data})

class ActiveLoansView(generics.ListCreateAPIView):
    serializer_class = ActiveLoanSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return ActiveLoan.objects.filter(user=self.request.user).order_by('-id')

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class LoanRequestsView(generics.ListCreateAPIView):
    serializer_class = LoanRequestSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return LoanRequest.objects.filter(user=self.request.user).order_by('-id')

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class SeedOffersView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        # Simple seed for demo (idempotent-ish)
        defaults = [
            # Banks
            ('Aiyl Bank', 18.0, 36, 800000),
            ('Optima Bank', 20.0, 36, 600000),
            ('DemirBank', 19.5, 36, 700000),
            ('KICB', 18.9, 48, 900000),
            ('Bakai Bank', 22.5, 24, 500000),
            ('MBank', 23.0, 18, 300000),
            ('Dos-Kredobank', 21.0, 36, 550000),
            ('Keremet Bank', 20.5, 36, 500000),
            ('Capital Bank', 21.5, 24, 450000),
            ('Eco Islamic Bank', 19.9, 36, 600000),
            # MFIs (prototype)
            ('Bai Tushum', 26.0, 18, 250000),
            ('Kompanion', 27.0, 18, 250000),
            ('FINCA Bank', 25.0, 24, 300000),
            ('Elet-Capital', 29.0, 12, 150000),
        ]
        for name, rate, months, max_amount in defaults:
            LoanOffer.objects.get_or_create(
                provider_name=name,
                rate=rate,
                months=months,
                max_amount=max_amount,
            )
        return Response({'detail': 'seeded'})


class CreditHistoryView(generics.ListCreateAPIView):
    serializer_class = CreditHistoryEntrySerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return CreditHistoryEntry.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class CreditHistorySummaryView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        score = _compute_score(request.user)
        history = CreditHistoryEntry.objects.filter(user=request.user)
        counts = {
            'ontime': history.filter(status='ontime').count(),
            'late': history.filter(status='late').count(),
            'default': history.filter(status='default').count(),
        }
        return Response({'score': score, 'counts': counts})
