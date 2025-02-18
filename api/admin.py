from django.contrib import admin
from .models import Empleado, Permiso, RegistroAcceso ,Pagos # Importar modelos personalizados

# Registrar modelos personalizados en Django Admin
@admin.register(Empleado)
class EmpleadoAdmin(admin.ModelAdmin):
    list_display = ('id_empleados','cedula','nombre','direccion','fecha_ingreso','id_roles','departamento')

@admin.register(Permiso)
class PermisoAdmin(admin.ModelAdmin):
    list_display = ('id_permisos', 'id_roles', 'tabla', 'tipo_permiso')

@admin.register(RegistroAcceso)
class RegistroAccesoAdmin(admin.ModelAdmin):
    list_display = ('id_registros', 'id_usuarios', 'id_roles', 'fecha_acceso', 'tabla', 'tipo_permiso')
    

@admin.register(Pagos)
class PagosAdmin(admin.ModelAdmin):
    list_display = ('id_pagos','id_empleados','cantidad','fecha_pago')
