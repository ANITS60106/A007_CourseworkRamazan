from rest_framework import serializers
from .models import User

class UserSerializer(serializers.ModelSerializer):
    passport_id_masked = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            'id',
            'phone',
            'full_name',
            'passport_id_masked',
            'workplace',
            'occupation',
            'monthly_income',
            'user_type',
            'company_name',
        ]

    def get_passport_id_masked(self, obj):
        pid = obj.passport_id or ''
        if len(pid) <= 3:
            return '***'
        return pid[:2] + '***' + pid[-2:]


class RegisterSerializer(serializers.Serializer):
    phone = serializers.CharField()
    password = serializers.CharField()
    passport_id = serializers.CharField(required=False, allow_blank=True)
    full_name = serializers.CharField(required=False, allow_blank=True)
    workplace = serializers.CharField(required=False, allow_blank=True)
    occupation = serializers.CharField(required=False, allow_blank=True)
    monthly_income = serializers.IntegerField(required=False, default=0)

    user_type = serializers.ChoiceField(choices=['individual', 'legal'], required=False, default='individual')

    company_name = serializers.CharField(required=False, allow_blank=True)
    company_inn = serializers.CharField(required=False, allow_blank=True)
    company_address = serializers.CharField(required=False, allow_blank=True)
    company_phone = serializers.CharField(required=False, allow_blank=True)
    company_fax = serializers.CharField(required=False, allow_blank=True)
    company_director = serializers.CharField(required=False, allow_blank=True)
    company_profit_monthly = serializers.IntegerField(required=False, default=0)


class LoginSerializer(serializers.Serializer):
    phone = serializers.CharField()
    password = serializers.CharField()
