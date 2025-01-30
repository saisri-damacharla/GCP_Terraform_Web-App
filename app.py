from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <title>Terraform Resources</title>
    </head>
    <body>
        <h1>Hello Terraformers,</h1>
        <p>The resources that I followed to get <b>TERRAFIED</b></p>
        <p>
            <a href="https://www.youtube.com/playlist?list=PLdpzxOOAlwvI0O4PeKVV1-yJoX2AqIWuf" target="_blank">Concept Learning Youtube Playlist</a>
        </p>
        <p>
            <a href="https://www.udemy.com/course/terraform-beginner-to-advanced/?kw=terraform&src=sac" target="_blank">Getting Certified Udemy Course</a>
        </p>
        <h2>Get TERRAFIED today!!!</h2>
    </body>
    </html>
    '''

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
