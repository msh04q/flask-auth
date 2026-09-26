import pytest

from main import app, db


@pytest.fixture
def client():
    app.config["TESTING"] = True
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///:memory:"
    app.config["WTF_CSRF_ENABLED"] = False

    with app.app_context():
        db.create_all()
        with app.test_client() as client:
            yield client
        db.drop_all()


def test_health(client):
    r = client.get("/health")
    assert r.status_code == 200


def test_home(client):
    r = client.get("/")
    assert r.status_code == 200
