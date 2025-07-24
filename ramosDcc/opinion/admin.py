from django.contrib import admin

# Register your models here.
from opinion.models import User, Ramo, Opinion

admin.site.register(User)
admin.site.register(Ramo)
admin.site.register(Opinion)