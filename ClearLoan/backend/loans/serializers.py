from rest_framework import serializers
from .models import (
    LoanOffer,
    ActiveLoan,
    LoanRequest,
    CreditHistoryEntry,
    Bank,
    BankBranch,
    LoanProduct,
    LoanApplication,
)

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


class BankBranchSerializer(serializers.ModelSerializer):
    class Meta:
        model = BankBranch
        fields = ['id', 'city', 'address_en', 'address_ru', 'address_ky', 'hours']


class LoanProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = LoanProduct
        fields = [
            'id',
            'loan_type',
            'title_en', 'title_ru', 'title_ky',
            'min_amount', 'max_amount',
            'min_months', 'max_months',
            'rate_from', 'rate_to',
            'collateral',
            'is_islamic',
            'desc_en', 'desc_ru', 'desc_ky',
        ]


class LoanProductWithBankSerializer(serializers.ModelSerializer):
    bank_code = serializers.CharField(source='bank.code', read_only=True)
    bank_name_en = serializers.CharField(source='bank.name_en', read_only=True)
    bank_name_ru = serializers.CharField(source='bank.name_ru', read_only=True)
    bank_name_ky = serializers.CharField(source='bank.name_ky', read_only=True)

    class Meta:
        model = LoanProduct
        fields = LoanProductSerializer.Meta.fields + [
            'bank_code',
            'bank_name_en', 'bank_name_ru', 'bank_name_ky',
        ]


class BankSerializer(serializers.ModelSerializer):
    class Meta:
        model = Bank
        fields = [
            'id', 'code',
            'name_en', 'name_ru', 'name_ky',
            'website', 'support_phone',
            'hq_address_en', 'hq_address_ru', 'hq_address_ky',
            'about_en', 'about_ru', 'about_ky',
        ]


class BankDetailSerializer(serializers.ModelSerializer):
    branches = BankBranchSerializer(many=True, read_only=True)
    products = LoanProductSerializer(many=True, read_only=True)

    class Meta:
        model = Bank
        fields = BankSerializer.Meta.fields + ['branches', 'products']


class LoanApplicationSerializer(serializers.ModelSerializer):
    bank_code = serializers.CharField(source='product.bank.code', read_only=True)
    bank_name_en = serializers.CharField(source='product.bank.name_en', read_only=True)
    bank_name_ru = serializers.CharField(source='product.bank.name_ru', read_only=True)
    bank_name_ky = serializers.CharField(source='product.bank.name_ky', read_only=True)
    product_title_en = serializers.CharField(source='product.title_en', read_only=True)
    product_title_ru = serializers.CharField(source='product.title_ru', read_only=True)
    product_title_ky = serializers.CharField(source='product.title_ky', read_only=True)
    loan_type = serializers.CharField(source='product.loan_type', read_only=True)

    class Meta:
        model = LoanApplication
        fields = [
            'id',
            'amount',
            'months',
            'monthly_payment',
            'decision_status',
            'approval_probability',
            'created_at',
            'bank_code',
            'bank_name_en', 'bank_name_ru', 'bank_name_ky',
            'product_title_en', 'product_title_ru', 'product_title_ky',
            'loan_type',
            'product',
        ]
        extra_kwargs = {'product': {'write_only': True}}
