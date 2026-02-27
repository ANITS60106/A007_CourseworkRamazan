from django.db import models
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager

class UserManager(BaseUserManager):
    def create_user(self, phone: str, password: str = None, **extra_fields):
        if not phone:
            raise ValueError("Phone is required")
        phone = phone.strip()
        user = self.model(phone=phone, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, phone: str, password: str, **extra_fields):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)
        extra_fields.setdefault("is_active", True)
        return self.create_user(phone=phone, password=password, **extra_fields)

class User(AbstractBaseUser, PermissionsMixin):
    phone = models.CharField(max_length=32, unique=True)
    full_name = models.CharField(max_length=120, blank=True)
    passport_id = models.CharField(max_length=40, blank=True)  # collected only at registration
    workplace = models.CharField(max_length=120, blank=True)
    occupation = models.CharField(max_length=120, blank=True)
    monthly_income = models.IntegerField(default=0)


    USER_TYPE_CHOICES = [
        ('individual', 'Individual'),
        ('legal', 'Legal entity'),
    ]
    user_type = models.CharField(max_length=20, choices=USER_TYPE_CHOICES, default='individual')

    # Legal entity (company) fields (used only when user_type == 'legal')
    company_name = models.CharField(max_length=200, blank=True)
    company_inn = models.CharField(max_length=32, blank=True)
    company_address = models.CharField(max_length=250, blank=True)
    company_phone = models.CharField(max_length=64, blank=True)
    company_fax = models.CharField(max_length=64, blank=True)
    company_director = models.CharField(max_length=120, blank=True)
    company_profit_monthly = models.IntegerField(default=0)


    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = UserManager()

    USERNAME_FIELD = "phone"
    REQUIRED_FIELDS = []

    def __str__(self):
        return self.phone

    @property
    def passport_id_masked(self) -> str:
        p = self.passport_id or ""
        if len(p) <= 3:
            return "***"
        return f"{p[:2]}***{p[-2:]}"
