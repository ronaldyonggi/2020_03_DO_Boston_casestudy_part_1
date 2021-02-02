FROM python:slim

# Set the directory for the app. In this case we set /usr/src/app
WORKDIR /usr/src/app

# Copy all the files to the container
COPY . .

# Install the dependencies listed in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Tell the port number the container will expose
EXPOSE 5000

# Run the app
CMD ["python","./web.py"]

