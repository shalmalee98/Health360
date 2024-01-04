# set the base image to build from 
FROM nikolaik/python-nodejs

WORKDIR /app

COPY package*.json .

RUN npm install

COPY . .

# RUN pip3 install -r python_scripts/requirements.txt


EXPOSE 3000

# Define the command to run your Node.js application
CMD ["node", "server.js"]