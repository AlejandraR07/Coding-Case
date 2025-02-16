from django.db import models

class Empleado(models.Model):
    id_empleados = models.AutoField(db_column='Id_Empleados', primary_key=True)  # Clave primaria
    cedula = models.IntegerField(db_column='Cedula', null=True, blank=True)
    nombre = models.CharField(db_column='Nombre', max_length=300, null=True, blank=True)
    direccion = models.CharField(db_column='Direccion', max_length=150, null=True, blank=True)
    fecha_ingreso = models.DateField(db_column='Fecha_Ingreso', null=True, blank=True)
    id_roles = models.IntegerField(db_column='Id_Roles', null=True, blank=True)  # Clave foránea
    Departamento = models.IntegerField(db_column='Departamento', null=True, blank=True) 
    

    class Meta:
        managed = False  # Evita que Django intente modificar la tabla en SQL Server
        db_table = 'vw_Empleados_Con_Permisos'  # Nombre real de la tabla en SQL Server

    def __str__(self):
        return self.nombre


class Permiso(models.Model):
    id_permisos = models.AutoField(db_column='Id_Permisos', primary_key=True)
    id_roles = models.IntegerField(db_column='Id_Roles')
    tabla = models.CharField(db_column='Tabla', max_length=200)
    tipo_permiso = models.CharField(db_column='Tipo_Permiso', max_length=200)

    class Meta:
        managed = False  # No permitir que Django modifique la tabla
        db_table = 'TbPermisos'

    def __str__(self):
        return f"Rol {self.id_roles} - {self.tabla}: {self.tipo_permiso}"

class RegistroAcceso(models.Model):
    id_registros = models.AutoField(db_column='Id_Registros', primary_key=True)
    id_roles = models.IntegerField(db_column='Id_Roles', null=True, blank=True)
    fecha_acceso = models.DateField(db_column='Fecha_Acceso', null=True, blank=True)
    id_usuarios = models.IntegerField(db_column='Id_Usuarios', null=True, blank=True)
    tabla = models.CharField(db_column='Tabla', max_length=200, null=True, blank=True)

    class Meta:
        managed = False  # No modificar la tabla en SQL Server
        db_table = 'TbRegistros'

    def __str__(self):
        return f"Acceso {self.id_registros} - Usuario {self.id_usuarios} - Tabla {self.tabla}"
