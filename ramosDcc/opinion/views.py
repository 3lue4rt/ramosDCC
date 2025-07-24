from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login,logout
from django.shortcuts import get_object_or_404, redirect
from django.http import JsonResponse
from django.http import HttpResponseRedirect
from opinion.models import User, Opinion, Ramo
from django.contrib import messages
from django.contrib.auth.decorators import user_passes_test
from .forms import CustomUserCreationForm
from django.contrib.auth.decorators import login_required

semestres = ["V Semestre", "VI Semestre", "VII Semestre", "VIII Semestre", "IX Semestre", "X Semestre", "XI Semestre"]
semestres_electivo = semestres + ["Electivo"]
ramos = Ramo.objects.all()

def index(request):
    # Method to get the home page
    if request.user.is_authenticated:
        return redirect("/ramos")

    if request.method == "GET":
        return render(request, "index.html")
    
    elif request.method == "POST":
        return login_user(request)

def register_user(request):
    # Method to register an user
    if request.method == 'POST':
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect("/")
    else:
        form = CustomUserCreationForm()
    
    return render(request, "auth/register_user.html", {'form': form})
    
        
def login_user(request):
    # Method to login
    if request.method == 'GET':
        return render(request,"auth/login.html")
    
    elif request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        usuario = authenticate(username=username,password=password)

        if usuario is not None:
            login(request,usuario)
            messages.error(request, 'Bienvenide ' + username)
            return redirect('/ramos')
        else:
            messages.error(request, 'Usuario y/o contraseña incorrectos')
            return redirect('/login')
        
        
def logout_user(request):
    # Method to logout
    logout(request)
    return HttpResponseRedirect('/')
        
def courses(request):
    ramos = Ramo.objects.all()
    # Method to get the courses list page
    if request.method == "GET":
        return render(request, "courses/courses_list.html", {"semestres": semestres, "ramos": ramos})
    

def ramo(request, code):
    ramo = Ramo.objects.get(code=code)
    rates = ["Dificultad de evaluaciones", "Tiempo necesario"]
    
    user_opinion     = Opinion.objects.filter(user=request.user.pk, ramo_code=code)
    opinion_given    = user_opinion.exists()
    opinion_approved = opinion_given and user_opinion[0].approved
    
    if request.method == "POST":
        opinion_text = request.POST['opinion_text']
        rate_dificulty = request.POST['rate_dificulty']
        rate_time = request.POST['rate_time']
        
        if not opinion_given:
            opinion = Opinion(
                ramo_code=code,
                opinion_text=opinion_text,
                rate_dificulty=rate_dificulty,
                rate_time=rate_time,
                user=request.user
            )
            opinion.save()

        return redirect('ramo', code=code)

    return render(request, "courses/ramo_template.html", {"ramo": ramo, "rates": rates, "given": opinion_given, "approved": opinion_approved})

def addRamo(request):
    ramos = Ramo.objects.all()
    if request.method == "GET":
        return render(request, "courses/add_ramo.html", {"semestres": semestres_electivo, "ramos": ramos})
    
    elif request.method == "POST":
        name = request.POST['nombre']
        code = request.POST['codigo']
        semestre = request.POST['semestres']
        credits = request.POST['creditos']
        description = request.POST['description']
        program_id = request.POST['id_programa']

        # course could not have any requirements
        try:
            requisitos = request.POST.getlist('requisitos')
        except:
            requisitos = ""
            
        new_ramo = Ramo(name=name, 
                        code=code, 
                        credits=credits, 
                        semestre=semestre, 
                        requisitos=requisitos, 
                        descripción=description, 
                        program_id=program_id)
        new_ramo.save()

        return redirect('courses_list')
    
def profile(request):
    if request.method == "GET":
        return render(request, "auth/editar_perfil.html")

def like_opinion(request):
    if request.method == 'POST':
        opinion_id = request.POST.get('opinion_id')
        curr_likes = int(request.POST.get('curr_likes'))
        
        opinion = Opinion.objects.get(id=opinion_id)
        
        if opinion.likes.filter(pk=request.user.pk).exists():
            opinion.likes.remove(request.user)
            curr_likes -= 1
        
        else:
            opinion.likes.add(request.user)
            curr_likes += 1
        
        return JsonResponse({'likes': curr_likes}, status=200)
    return JsonResponse({'error': 'Método no permitido'}, status=400)


def is_superuser(user):
    return user.is_superuser

@user_passes_test(is_superuser)
def opinion_requests(request):
    if request.method == 'POST':
        id = request.POST.get('id')
        action = request.POST.get('action')
        
        opinion = Opinion.objects.get(id=id)
        
        if action == "approve":
            opinion.approve()
        elif action == "disapprove":
            opinion.disapprove()
    
    requests = Opinion.objects.filter(approved=False)
    return render(request, 'courses/opinion_requests.html', {"requests": requests})
