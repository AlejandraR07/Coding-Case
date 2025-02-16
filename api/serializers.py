from rest_framework import serializers

class EmpleadoSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    cedula = serializers.IntegerField()
    nombre = serializers.CharField(max_length=300)
    direccion = serializers.CharField(max_length=150)
    fecha_ingreso = serializers.DateField()
    rol_id = serializers.IntegerField()

class PagoSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    empleado_id = serializers.IntegerField()
    cantidad = serializers.DecimalField(max_digits=16, decimal_places=6)
    fecha_pago = serializers.DateField()
