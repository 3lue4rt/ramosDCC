import numpy as np

from django.db import models
from django.utils import timezone
from django.contrib.auth.models import AbstractUser
from django.core.validators import MinValueValidator, MaxValueValidator


class User(AbstractUser):
  name = models.CharField(max_length=50)
  last_name = models.CharField(max_length=50)
  email = models.EmailField(unique=True)

  def __str__(self):
        return self.username

class Opinion(models.Model):
  ramo_code = models.CharField(max_length=50) 
  rate_dificulty = models.IntegerField(
        validators=[
            MinValueValidator(1),
            MaxValueValidator(5)
        ]
    )
  rate_time = models.IntegerField(
        validators=[
            MinValueValidator(1),
            MaxValueValidator(5)
        ]
    )

  user = models.ForeignKey(
        User, 
        on_delete=models.CASCADE,
        related_name='opinions',  # user.opinions.all()
        verbose_name="Autor"
    )
  opinion_text = models.CharField(max_length=400) 
  #likes = models.IntegerField(default=0) 
  

  date = models.DateField(auto_now=True)
  approved = models.BooleanField(default=False)
  
  def approve(self):
    self.approved = True
    self.save()
    
  def disapprove(self):
    self.delete()

class Ramo(models.Model):
  name = models.CharField(max_length=50) 
  code = models.CharField(max_length=8)
  descripción = models.CharField(max_length=1500) 
  requisitos = models.CharField(max_length=50, default="") 
  semestre = models.CharField(max_length=50) 
  credits = models.IntegerField()
  program_id = models.IntegerField(default=0)

  def __str__(self):
    return self.name

  @property
  def opinions(self):
    return Opinion.objects.filter(ramo_code=self.code)
  
  def rate_dificulty(self):
    rate = 0
    opinions = self.opinions
    for opinion in opinions:
      if opinion.approved:
        rate += opinion.rate_dificulty
    if rate == 0:
      return 0
    
    return  round(rate/len(opinions), 1)
  
  def rate_time(self):
    rate = 0
    opinions = self.opinions
    for opinion in opinions:
      if opinion.approved:
        rate += opinion.rate_time
    if rate == 0:
      return 0
    
    return  round(rate/len(opinions), 1)