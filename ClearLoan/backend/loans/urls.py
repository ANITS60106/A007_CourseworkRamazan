from django.urls import path
from .views import (
    OffersListView,
    BanksListView,
    BankDetailView,
    LoanProductsListView,
    ScoredBankOptionsView,
    ApplyForLoanView,
    LoanApplicationsView,
    ActiveLoansView,
    LoanRequestsView,
    CreditHistoryView,
    CreditHistorySummaryView,
    SeedDemoDataView,
)

urlpatterns = [
    path('offers/', OffersListView.as_view()),
    path('banks/', BanksListView.as_view()),
    path('banks/<slug:code>/', BankDetailView.as_view()),
    path('products/', LoanProductsListView.as_view()),
    path('options/scored/', ScoredBankOptionsView.as_view()),
    path('applications/', LoanApplicationsView.as_view()),
    path('applications/apply/', ApplyForLoanView.as_view()),
    path('loans/', ActiveLoansView.as_view()),
    path('requests/', LoanRequestsView.as_view()),
    path('credit-history/', CreditHistoryView.as_view()),
    path('credit-history/summary/', CreditHistorySummaryView.as_view()),
    path('seed/', SeedDemoDataView.as_view()),
]
