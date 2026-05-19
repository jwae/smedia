import { defineConfig, loadEnv } from "vite";
import vue from "@vitejs/plugin-vue";
import { fileURLToPath } from "node:url";

const frontendRoot = fileURLToPath(new URL(".", import.meta.url));

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, frontendRoot, "");

  return {
    root: frontendRoot,
    plugins: [vue()],
    server: {
      host: "0.0.0.0",
      port: Number(env.FRONTEND_DEV_PORT || 5173),
      proxy: {
        "/api": {
          target: env.VITE_API_PROXY_TARGET || "http://localhost:3001",
          changeOrigin: true
        }
      }
    },
    preview: {
      host: "0.0.0.0",
      port: 4173
    },
    build: {
      outDir: "dist",
      emptyOutDir: true
    }
  };
});
