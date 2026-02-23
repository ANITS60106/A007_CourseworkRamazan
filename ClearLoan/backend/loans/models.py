from django.db import models
from django.conf import settings

class LoanOffer(models.Model):
    provider_name = models.CharField(max_length=120)
    rate = models.FloatField()
    months = models.IntegerField()
    max_amount = models.IntegerField(default=200000)

    def __str__(self):
        return f"{self.provider_name} ({self.rate}%)"

class ActiveLoan(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='active_loans')
    provider_name = models.CharField(max_length=120)
    amount = models.IntegerField()
    months = models.IntegerField()
    rate = models.FloatField(default=0)
    monthly_payment = models.IntegerField(default=0)
    status = models.CharField(max_length=20, default='active')  # active/completed

class LoanRequest(models.Model):
    TYPE_CHOICES = [
        ('mortgage', 'Mortgage'),
        ('consumer', 'Consumer'),
        ('auto', 'Auto'),
        ('business', 'Business'),
        ('education', 'Education'),
    ]
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='requests')
    loan_type = models.CharField(max_length=20, choices=TYPE_CHOICES, default='consumer')
    amount = models.IntegerField()
    months = models.IntegerField()
    purpose = models.CharField(max_length=200, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)


class CreditHistoryEntry(models.Model):
    """Prototype credit history entry.

    In real life this would come from a credit bureau / bank APIs.
    """

    STATUS_CHOICES = [
        ('ontime', 'On time'),
        ('late', 'Late'),
        ('default', 'Default'),
    ]

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='credit_history')
    provider_name = models.CharField(max_length=120)
    original_amount = models.IntegerField(default=0)
    opened_at = models.DateField(null=True, blank=True)
    closed_at = models.DateField(null=True, blank=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='ontime')
    late_payments = models.IntegerField(default=0)
    note = models.CharField(max_length=200, blank=True)

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']
