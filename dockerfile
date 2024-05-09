# Defines the starting OS image. 
# Depending on Angular version, may need a later version of node.
# Stage 1: Build
FROM node:16.13-alpine AS build 
# Defines a working folder for COPY and some other commands.
WORKDIR /usr/src/app
# Places the app files into the container workdir.
COPY package.json ./
# Execute npm commands like install and ng build.
RUN npm install
COPY . .
RUN npm run build

# ↓
# Now the app is built into the working directory of the container image.
# ↓

# Serving with nginx
# Multi-stage docker builds
# You can take the output from one image used to build a project 
# and copy the output files into a new image that doesn't include all of the build output.
# Stage 2: Run
FROM nginx:1.17.1-alpine
COPY --from=build /usr/src/app/dist/docker-demo /usr/share/nginx/html

# '--from' command argument references tag build that was defined with the AS keyword on line 4.
# Build the image with docker's build command in the terminal.
# 'docker build -t nex-docker-ng .'