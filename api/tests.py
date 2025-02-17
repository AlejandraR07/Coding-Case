from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status

class EmpleadoAPITest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.url = '/api/empleados/'

    def test_obtener_empleados(self):
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
