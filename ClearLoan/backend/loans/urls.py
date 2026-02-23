from django.urls import path
from .views import (
    OffersListView,
    ActiveLoansView,
    LoanRequestsView,
    SeedOffersView,
    ScoredOffersView,
    CreditHistoryView,
    CreditHistorySummaryView,
)

urlpatterns = [
    path('offers/', OffersListView.as_view()),
    path('offers/scored/', ScoredOffersView.as_view()),
    path('loans/', ActiveLoansView.as_view()),
    path('requests/', LoanRequestsView.as_view()),
    path('credit-history/', CreditHistoryView.as_view()),
    path('credit-history/summary/', CreditHistorySummaryView.as_view()),
    path('seed/', SeedOffersView.as_view()),
]
