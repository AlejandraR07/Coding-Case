from django.contrib import admin
from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from api.views import EmpleadosView, PagosView, RegistrosAccesoView

urlpatterns = [
    path('empleados/', EmpleadosView.as_view(), name='empleados'),
    path('pagos/', PagosView.as_view(), name='pagos'),
    path('registros/', RegistrosAccesoView.as_view(), name='registros'),
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]

