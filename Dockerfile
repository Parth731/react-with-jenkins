FROM mcr.microsoft.com/playwright:v1.48.1-noble

RUN npm install -g netlify-cli
RUN npm install -g node-jq