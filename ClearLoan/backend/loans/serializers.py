from rest_framework import serializers
from .models import LoanOffer, ActiveLoan, LoanRequest, CreditHistoryEntry

class LoanOfferSerializer(serializers.ModelSerializer):
    class Meta:
        model = LoanOffer
        fields = ['id', 'provider_name', 'rate', 'months', 'max_amount']

class ActiveLoanSerializer(serializers.ModelSerializer):
    class Meta:
        model = ActiveLoan
        fields = ['id', 'provider_name', 'amount', 'months', 'rate', 'monthly_payment', 'status']

class LoanRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = LoanRequest
        fields = ['id', 'loan_type', 'amount', 'months', 'purpose', 'created_at']


class CreditHistoryEntrySerializer(serializers.ModelSerializer):
    class Meta:
        model = CreditHistoryEntry
        fields = [
            'id',
            'provider_name',
            'original_amount',
            'opened_at',
            'closed_at',
            'status',
            'late_payments',
            'note',
            'created_at',
        ]
