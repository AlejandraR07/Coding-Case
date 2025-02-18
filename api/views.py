from django.db import connection, DatabaseError
from rest_framework.response import Response
from django.http import JsonResponse
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated  # <-- Agregado para permisos
import logging
    
class RegistrosAccesoView(APIView):
    permission_classes = [IsAuthenticated]  # Solo usuarios autenticados pueden ver los registros

    def get(self, request):
        with connection.cursor() as cursor:
            cursor.execute("SELECT Id_Registros, Id_Usuarios, Id_Roles, Fecha_Acceso, Tabla, Tipo_Permiso FROM TbRegistros")
            rows = cursor.fetchall()

        registros = [{"id_registros": row[0], "id_usuarios": row[1], "id_roles": row[2], 
                      "fecha_acceso": row[3], "tabla": row[4], "Tipo_Permiso": row[5]} for row in rows]
        return Response(registros)
    

class EmpleadosView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        usuario_id = request.user.id

        with connection.cursor() as cursor:
            # Llamar al procedimiento almacenado para registrar el acceso
            cursor.execute("EXEC sp_RegistrarAcceso @usuario_id=%s, @tabla=%s", [usuario_id, 'vw_Empleados_Con_Permisos'])

            # Obtener empleados con permisos
            cursor.execute("EXEC sp_ObtenerEmpleados @usuario_id=%s", [usuario_id])
            rows = cursor.fetchall()

        empleados = [{"id_empleados": row[0], "cedula": row[1], "nombre": row[2], "direccion": row[3], "fecha_ingreso": row[4], 
                      "id_roles": row[5], "departamento": row[6]} for row in rows]
        return Response(empleados)

logger = logging.getLogger(__name__)

class PagosView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        usuario_id = request.user.id

        with connection.cursor() as cursor:
            # Llamar al procedimiento almacenado para registrar el acceso
            cursor.execute("EXEC sp_RegistrarAcceso @usuario_id=%s, @tabla=%s", [usuario_id, 'vw_pagos'])

            # Obtener pagos con permisos
            cursor.execute("EXEC sp_ObtenerPagos @usuario_id=%s", [usuario_id])
            rows = cursor.fetchall()
            if not rows:
                return Response({"message": "No se encontraron pagos para este usuario."}, status=204)

        pagos = [{"PERMISO": row[0]} for row in rows]
        return Response(pagos)

