FROM mcr.microsoft.com/playwright:v1.48.1-noble

RUN npm ci
RUN npm install -g netlify-cli
RUN npm install -g serve
RUN apt update
RUN apt install jq -y