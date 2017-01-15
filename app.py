from flask import Flask

app = Flask(__name__)
app.secret_key = '1234'

@app.route('/')
@app.route('/home')
def home():
    # Display login, search, and most recent updates
    pass

@app.route('/login')
def login():
    # If user is logged in:
    #   Redirect user to home page, with login passed as a parameter
    # Else:
    #   Attempt to authenticate user. If fail, display error. If pass, redirect to home
    pass

@app.route('/search')
def search():
    # Display top results for search.
    # Dispay most recent comment and rating, as well as the average rating for each result
    pass

@app.route('/recruiter')
def recruiter():
    # Display selected recruiter. Also display any associated agencies.
    # Authenticated users should have the option to rate the recruiter
    pass

@app.route('/agency')
def agency():
    # Display selected agency. Also display any associated recruiters.
    # Authenticated users should have the option to rate the recruiter
    pass

@app.route('/rate_recruiter')
def rate_recruiter():
    # User should only be able to rate if they are authenticated
    # Execute database call to update user_recruiter_ratings table
    pass

@app.route('/rate_agency')
def rate_agency():
    # User should only be able to rate if they are authenticated
    # Execute database call to update user_agency_ratings table
    pass

@app.route('/remove_rating_recruiter')
def remove_rating_recruiter():
    # If user is authenticated, delete selected rating from user_recruiter_ratings
    pass

@app.route('/remove_rating_agency')
def remove_rating_agency():
    # If user is authenticated, delete selected rating from user_agency_ratings
    pass

app.run(port=1234, debug=True)