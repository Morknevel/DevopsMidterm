import unittest
import sys
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import create_app

class FlaskAppTestCase(unittest.TestCase):
    def setUp(self):
        self.app = create_app()
        self.app.config['TESTING'] = True
        self.client = self.app.test_client()

    def test_home_page(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Welcome to my DevOps Demo', response.data)

    def test_submit_message(self):
        response = self.client.post('/submit', data={'message': 'Test Message'})
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Test Message', response.data)
        
    def test_health_check(self):
        response = self.client.get('/health')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json, {'status': 'healthy'})

if __name__ == '__main__':
    unittest.main()