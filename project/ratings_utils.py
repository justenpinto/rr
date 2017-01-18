from project.database import CursorFromConnectionFromPool

def execute_and_return_cursor_data(query, args=None):
    with CursorFromConnectionFromPool() as cursor:
        cursor.execute(query, args)
    data = cursor.fetchall()
    if data:
        return data
    return None

def create_recruiter(first_name, last_name, email, phone_number):
    return execute_and_return_cursor_data(('SELECT create_recruiter(%s, %s, %s, %s)',
                                           (first_name, last_name, email, phone_number)))

def get_all_recruiters():
    return execute_and_return_cursor_data('SELECT * FROM recruiter_ratings_view')

def load_recruiter(recruiter_id):
    return execute_and_return_cursor_data('SELECT * FROM load_recruiter(%s)', (recruiter_id,))

def search_recruiters(first_name, last_name):
    return execute_and_return_cursor_data('SELECT * FROM search_recruiters(%s, %s)', (first_name, last_name))

def find_recruiters_associated_with_agency(agency_id):
    return execute_and_return_cursor_data('SELECT * FROM find_recruiters_associated_with_agency(%s)', (agency_id,))

def create_agency(agency_name, website, address, phone_number):
    return execute_and_return_cursor_data('SELECT create_agency(%s, %s, %s, %s)',
                                          (agency_name, website, address, phone_number))

def get_all_agencies():
    return execute_and_return_cursor_data('SELECT * FROM agency_ratings_view')

def load_agency(agency_id):
    return execute_and_return_cursor_data('SELECT * FROM load_agency(%s)', (agency_id,))

def search_agencies(agency_name):
    return execute_and_return_cursor_data('SELECT * FROM search_recruiters(%s)', (agency_name,))

def find_agencies_associated_with_recruiter(recruiter_id):
    return execute_and_return_cursor_data('SELECT * FROM find_agencies_associated_with_recruiter(%s)', (recruiter_id,))

def rate_recruiter(user_id, recruiter_id, rating, comment, anonymous=False):
    # Validate values
    with CursorFromConnectionFromPool() as cursor:
        cursor.execute('SELECT rate_recruiter(%s, %s, %s, %s, %s)',
                       (user_id, recruiter_id, rating, comment, anonymous))

def rate_agency(user_id, agency_id, rating, comment, anonymous=False):
    #Validate values
    with CursorFromConnectionFromPool() as cursor:
        cursor.execute('SELECT rate_agency(%s, %s, %s, %s, %s)',
                       (user_id, agency_id, rating, comment, anonymous))