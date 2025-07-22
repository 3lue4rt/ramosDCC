from django.contrib import admin

# Register your models here.
from opinion.models import User, Ramo

admin.site.register(User)
admin.site.register(Ramo)