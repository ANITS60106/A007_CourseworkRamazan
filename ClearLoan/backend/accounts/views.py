from django.contrib.auth import authenticate
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import permissions, status
from rest_framework.authtoken.models import Token

from .models import User
from .serializers import UserSerializer, RegisterSerializer, LoginSerializer

class RegisterView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        s = RegisterSerializer(data=request.data)
        s.is_valid(raise_exception=True)
        data = s.validated_data

        if User.objects.filter(phone=data['phone'].strip()).exists():
            return Response({'detail': 'User already exists'}, status=status.HTTP_400_BAD_REQUEST)

        user = User.objects.create_user(
            phone=data['phone'],
            password=data['password'],
            passport_id=data.get('passport_id', ''),
            full_name=data.get('full_name', ''),
            workplace=data.get('workplace', ''),
            occupation=data.get('occupation', ''),
            monthly_income=data.get('monthly_income', 0),
            user_type=data.get('user_type','individual'),
            company_name=data.get('company_name',''),
            company_inn=data.get('company_inn',''),
            company_address=data.get('company_address',''),
            company_phone=data.get('company_phone',''),
            company_fax=data.get('company_fax',''),
            company_director=data.get('company_director',''),
            company_profit_monthly=data.get('company_profit_monthly',0),
        )
        token, _ = Token.objects.get_or_create(user=user)
        return Response({'token': token.key, 'user': UserSerializer(user).data})

class LoginView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        s = LoginSerializer(data=request.data)
        s.is_valid(raise_exception=True)
        phone = s.validated_data['phone'].strip()
        password = s.validated_data['password']

        user = authenticate(request, phone=phone, password=password)
        if user is None:
            # authenticate() may not work with phone unless backend supports it;
            # do a manual check for this prototype.
            try:
                u = User.objects.get(phone=phone)
            except User.DoesNotExist:
                return Response({'detail': 'Invalid credentials'}, status=status.HTTP_400_BAD_REQUEST)
            if not u.check_password(password):
                return Response({'detail': 'Invalid credentials'}, status=status.HTTP_400_BAD_REQUEST)
            user = u

        token, _ = Token.objects.get_or_create(user=user)
        return Response({'token': token.key, 'user': UserSerializer(user).data})
