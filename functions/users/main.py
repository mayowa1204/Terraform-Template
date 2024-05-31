def main(request):
    path = request.path
    user_id = request.args.get("user_id")
    print(f"{request=}")

    if path == "/users" and "user_id" not in request.args:
        return post_user(request)
    elif path == "/users" and user_id in request.args:
        return delete_user(request)
    elif path == "/users/delete" and user_id in request.args:
        return delete_user(request)
    else:   
        return ("Notfound", 404)

def post_user(request):
    data = request.json
    message = f"Hello from post user {data}"
    return (message, 200)

def get_user(request):
    message = f"Hello from get user with id {request.args.get('user_id')}"
    return (message, 200)

def delete_user(request):
    message = f"Hello from delete user with id {request.args.get('user_id')}"
    return (message, 200)


