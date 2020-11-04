from django.contrib.auth.models import User, Group
from rest_framework import viewsets
from rest_framework import permissions
from rest_framework.views import APIView
from api.coins.serializers import UserSerializer, GroupSerializer
from django.http import HttpResponse
from django.http import HttpRequest

import json
import imghdr
from django.core.handlers.wsgi import WSGIRequest
from coin_counter.analyzer import count_coins


class UserViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """
    queryset = User.objects.all().order_by('-date_joined')
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]


class GroupViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows groups to be viewed or edited.
    """
    queryset = Group.objects.all()
    serializer_class = GroupSerializer
    permission_classes = [permissions.IsAuthenticated]


def res(message, error=None, status=200, content_type='application/json'):
    if error:
        content = {
            'result': message,
            'error': {
                'message': error[0],
                'code': error[1],
            },
        }
    else:
        content = {
            'result': message,
            'error': None,
        }

    return HttpResponse(json.dumps(content), status=status, content_type=content_type)

class CoinCounterView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        # check if req.body is an image (https://docs.python.org/2/library/imghdr.html#imghdr.what)
        image_type = imghdr.what('upload', request.body)
        if not image_type:
            return res(None, error=('No image or wrong format submitted.', 1), status=400)
        else:
            return res(count_coins(request.body))
