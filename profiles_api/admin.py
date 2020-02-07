from django.contrib import admin
# from .models import (Table1, Table2)


from profiles_api import models

# Register your models here.
admin.site.register(models.UserProfile)
