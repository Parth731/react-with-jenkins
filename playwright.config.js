// playwright.config.js
import { defineConfig } from "@playwright/test";

export default defineConfig({
  webServer: {
    command: "npm run serve",
    port: 3000, // Adjust to your server's port
  },
  use: {
    baseURL: "http://localhost:3000",
  },
});
