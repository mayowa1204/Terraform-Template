def main(request):
    path = request.path
    print(f"{request=}")

    if path == "/auth/create":
        return create(request)
    elif path == "/auth/login":
        return login(request)
    elif path == "/auth/logout":
        return logout(request)
    elif path == "/auth/refresh":
        return refresh(request)
    else:   
        return ("Notfound", 404)


def create(request):
    data = request.json
    message = f"Hello from create, data: [{data}]"
    return (message, 200)

def login(request):
    data = request.json
    message = f"Hello from login, data: [{data}]"
    return (message, 200)
 
def logout(request):
    data = request.json
    message = f"Hello from logout, data:[{data}]"
    return (message, 200)

def refresh(request):
    data = request.json
    message = f"Hello from refresh, data: [{data}]"
    return (message, 200)
