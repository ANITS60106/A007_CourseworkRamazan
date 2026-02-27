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


class Bank(models.Model):
    code = models.SlugField(max_length=50, unique=True)
    name_en = models.CharField(max_length=120)
    name_ru = models.CharField(max_length=120)
    name_ky = models.CharField(max_length=120)

    website = models.URLField(blank=True)
    support_phone = models.CharField(max_length=80, blank=True)

    hq_address_en = models.CharField(max_length=220, blank=True)
    hq_address_ru = models.CharField(max_length=220, blank=True)
    hq_address_ky = models.CharField(max_length=220, blank=True)

    about_en = models.TextField(blank=True)
    about_ru = models.TextField(blank=True)
    about_ky = models.TextField(blank=True)

    def __str__(self):
        return self.name_en


class BankBranch(models.Model):
    bank = models.ForeignKey(Bank, on_delete=models.CASCADE, related_name='branches')
    city = models.CharField(max_length=120, blank=True)
    address_en = models.CharField(max_length=220)
    address_ru = models.CharField(max_length=220)
    address_ky = models.CharField(max_length=220)
    hours = models.CharField(max_length=120, blank=True)

    def __str__(self):
        return f"{self.bank.code}: {self.city}"


class LoanProduct(models.Model):
    LOAN_TYPE_CHOICES = LoanRequest.TYPE_CHOICES

    bank = models.ForeignKey(Bank, on_delete=models.CASCADE, related_name='products')
    loan_type = models.CharField(max_length=20, choices=LOAN_TYPE_CHOICES, default='consumer')

    title_en = models.CharField(max_length=160)
    title_ru = models.CharField(max_length=160)
    title_ky = models.CharField(max_length=160)

    min_amount = models.IntegerField(default=0)
    max_amount = models.IntegerField(default=0)
    min_months = models.IntegerField(default=3)
    max_months = models.IntegerField(default=60)

    rate_from = models.FloatField(default=0)
    rate_to = models.FloatField(default=0)

    collateral = models.CharField(max_length=120, blank=True)  # e.g. none / pledge / guarantor
    is_islamic = models.BooleanField(default=False)

    desc_en = models.TextField(blank=True)
    desc_ru = models.TextField(blank=True)
    desc_ky = models.TextField(blank=True)

    def __str__(self):
        return f"{self.bank.code} {self.loan_type} {self.title_en}"


class LoanApplication(models.Model):
    STATUS_CHOICES = [
        ('approved', 'Approved'),
        ('alternative', 'Alternative'),
        ('rejected', 'Rejected'),
        ('pending', 'Pending'),
    ]
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='applications')
    product = models.ForeignKey(LoanProduct, on_delete=models.CASCADE, related_name='applications')
    amount = models.IntegerField()
    months = models.IntegerField()
    monthly_payment = models.IntegerField(default=0)
    decision_status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    approval_probability = models.FloatField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']
