from django.contrib.auth.backends import ModelBackend
from .models import User

class PhoneBackend(ModelBackend):
    def authenticate(self, request, phone=None, password=None, **kwargs):
        if phone is None:
            phone = kwargs.get(User.USERNAME_FIELD)
        if phone is None or password is None:
            return None
        try:
            user = User.objects.get(phone=phone.strip())
        except User.DoesNotExist:
            return None
        if user.check_password(password) and self.user_can_authenticate(user):
            return user
        return None
