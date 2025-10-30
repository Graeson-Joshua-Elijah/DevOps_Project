from app import app

def test_home_route():
    """
    Simple test to ensure the home route returns a 200 OK.
    """
    with app.test_client() as client:
        response = client.get('/')
        assert response.status_code == 200
        assert b"Flask" in response.data or response.data
