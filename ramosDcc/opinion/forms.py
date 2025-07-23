# forms.py
from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.core.exceptions import ValidationError
from .models import User

class CustomUserCreationForm(UserCreationForm):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # Customize labels
        self.fields['username'].label = "Nombre de usuario"
        self.fields['email'].label = "Correo electrónico"
        self.fields['name'].label = "Nombre(s)"
        self.fields['last_name'].label = "Apellidos"
        self.fields['password1'].label = "Contraseña"
        self.fields['password2'].label = "Confirmar contraseña"

        self.fields['password1'].help_text = "Mínimo 8 caracteres."
        self.fields['username'].help_text = "Este nombre de usuario ya está registrado"
        
    # Add additional fields to the form
    name = forms.CharField(max_length=50, required=True)
    last_name = forms.CharField(max_length=50, required=True)
    email = forms.EmailField(required=True, help_text='Obligatorio, ingrese un email válido')

    class Meta:
        model = User
        fields = ('username', 'email', 'name', 'last_name', 'password1', 'password2')
    
    def clean_email(self):
        """Ensure email is unique"""
        email = self.cleaned_data.get('email')
        if User.objects.filter(email=email).exists():
            raise ValidationError("Este email ya está registrado")
        return email
    
    def clean_username(self):
        username = self.cleaned_data.get('username')
        if User.objects.filter(username=username).exists():
            raise ValidationError(("Este nombre de usuario ya está tomado"),
                                    code='duplicate_username'
                                 )
        return username
    
    def save(self, commit=True):
        """Save the user with all fields"""
        user = super().save(commit=False)
        user.email = self.cleaned_data['email']
        user.name = self.cleaned_data['name']
        user.last_name = self.cleaned_data['last_name']
        if commit:
            user.save()
        return user