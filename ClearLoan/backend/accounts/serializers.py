from rest_framework import serializers
from .models import User

class UserSerializer(serializers.ModelSerializer):
    passport_id_masked = serializers.CharField(read_only=True, source='passport_id_masked')

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
        ]

class RegisterSerializer(serializers.Serializer):
    phone = serializers.CharField()
    password = serializers.CharField(write_only=True)
    passport_id = serializers.CharField(required=False, allow_blank=True)
    full_name = serializers.CharField(required=False, allow_blank=True)
    workplace = serializers.CharField(required=False, allow_blank=True)
    occupation = serializers.CharField(required=False, allow_blank=True)
    monthly_income = serializers.IntegerField(required=False, default=0)

class LoginSerializer(serializers.Serializer):
    phone = serializers.CharField()
    password = serializers.CharField(write_only=True)
