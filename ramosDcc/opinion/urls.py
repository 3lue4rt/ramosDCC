from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='home'),
    path('registro', views.register_user, name='registro'),
    path('login',views.login_user, name='login'),
    path('logout',views.logout_user, name='logout'),
    path('ramos', views.courses, name='courses_list'),
    path('ramos/<str:code>', views.ramo, name='ramo'),
    path('agregar-ramo', views.addRamo, name='addRamo'),
    path('profile',views.profile, name='profile'),
    path('like_opinion/', views.like_opinion, name='like_opinion')
] 