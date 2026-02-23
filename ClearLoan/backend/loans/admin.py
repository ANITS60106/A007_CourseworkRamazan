from django.contrib import admin
from .models import LoanOffer, ActiveLoan, LoanRequest

admin.site.register(LoanOffer)
admin.site.register(ActiveLoan)
admin.site.register(LoanRequest)
