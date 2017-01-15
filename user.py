from database import CursorFromConnectionFromPool
class User:
    def __init__(self, username, id):
        self.username = username
        self.id = id
        pass

    def __repr__(self):
        return "<User {}>".format(self.username)

    @classmethod
    def create_user_regular(self, username, password):
        with CursorFromConnectionFromPool() as cursor:
            cursor.execute('INSERT INTO users (username, password)'
                           'VALUES (%s, crypt(%s, gen_salt(\'bf\', 8)'
                           (username, password))
