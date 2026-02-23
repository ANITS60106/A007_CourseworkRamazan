from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User

@admin.register(User)
class UserAdmin(BaseUserAdmin):
    model = User
    list_display = ('phone', 'full_name', 'workplace', 'occupation', 'monthly_income', 'is_staff')
    ordering = ('phone',)
    fieldsets = (
        (None, {'fields': ('phone', 'password')}),
        ('Profile', {'fields': ('full_name', 'passport_id', 'workplace', 'occupation', 'monthly_income')}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
    )
    add_fieldsets = (
        (None, {'classes': ('wide',), 'fields': ('phone', 'password1', 'password2', 'is_staff', 'is_superuser')}),
    )
    search_fields = ('phone', 'full_name')
    filter_horizontal = ('groups', 'user_permissions')
