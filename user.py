from database import CursorFromConnectionFromPool
class User:
    def __init__(self, username, id):
        self.username = username
        self.id = id
        pass

    def __repr__(self):
        return "<User {}>".format(self.username)

    @classmethod
    def create_user_regular(cls, username, email, password):
        with CursorFromConnectionFromPool() as cursor:
            cursor.execute('SELECT create_user_regular'
                           '(%s, %s, crypt(%s, gen_salt(\'bf\', 8)))',
                           (username, email, password))
            data = cursor.fetchone()
            if data:
                return cls(username=username, id=data[0])
        return None

    @classmethod
    def load_user_regular(cls, username, password):
        with CursorFromConnectionFromPool() as cursor:
            cursor.execute('SELECT load_user_regular (%s, %s)',
                           (username, password))
            data = cursor.fetchone()
            if data:
                return cls(username=username, id=data[0])
        return None