from django.contrib import admin
from django.urls import path
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView
)
from api.views import EmpleadosView, PagosView, RegistrosAccesoView  # Asegúrate de importar correctamente las vistas

urlpatterns = [
    path('api/empleados/', EmpleadosView.as_view(), name='empleados'),
    path('api/pagos/', PagosView.as_view(), name='pagos'),
    path('api/registros/', RegistrosAccesoView.as_view(), name='registros'),
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]
