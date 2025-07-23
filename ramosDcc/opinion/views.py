from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login,logout
from django.shortcuts import get_object_or_404, redirect
from django.http import JsonResponse
from django.http import HttpResponseRedirect
from opinion.models import User, Opinion, Ramo
from django.contrib import messages
from django.contrib.auth.decorators import user_passes_test

semestres = ["V Semestre", "VI Semestre", "VII Semestre", "VIII Semestre"]
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
    if request.method == "GET":
        return render(request, "auth/register_user.html")
    
    elif request.method == "POST":
        if "register" in request.POST:
            username = request.POST["username"]
            password = request.POST["password"]
            name = request.POST["nombres"]
            last_name = request.POST["apellidos"]
            email = request.POST["email"]

            # Create new user
            user = User.objects.create_user(username=username, password=password, name=name+last_name,
                                            email=email)
            usuario = authenticate(username=username,password=password)
            login(request,usuario)
            return redirect("/")
        
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

    if request.method == "POST":
        opinion_text = request.POST['opinion_text']
        rate_dificulty = request.POST['rate_dificulty']
        rate_time = request.POST['rate_time']

        opinion = Opinion(
            ramo_code=code,
            opinion_text=opinion_text,
            rate_dificulty=rate_dificulty,
            rate_time=rate_time
        )
        opinion.save()

        return redirect('ramo', code=code)

    return render(request, "courses/ramo_template.html", {"ramo": ramo, "rates": rates})

def addRamo(request):
    ramos = Ramo.objects.all()
    if request.method == "GET":
        return render(request, "courses/add_ramo.html", {"semestres": semestres, "ramos": ramos})
    
    elif request.method == "POST":
        name = request.POST['nombre']
        code = request.POST['codigo']
        semestre = request.POST['semestres']
        credits = request.POST['creditos']
        requisitos = request.POST['requisitos']
        description = request.POST['description']
        
        new_ramo = Ramo(name=name, code=code, credits=credits, semestre=semestre, requisitos=requisitos, descripción=description)
        new_ramo.save()

        return redirect('courses_list')
    
def profile(request):
    if request.method == "GET":
        return render(request, "auth/editar_perfil.html")

def like_opinion(request):
    if request.method == 'POST':
        opinion_id = request.POST.get('opinion_id')
        opinion = Opinion.objects.get(id=opinion_id)
        opinion.likes += 1
        opinion.save()
        return JsonResponse({'likes': opinion.likes})
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