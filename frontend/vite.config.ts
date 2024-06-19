import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react-swc';

export default defineConfig({
  plugins: [react()],
  test: {
    setupFiles: ["./tests/setup.ts"],
    clearMocks: true,
    include: ["**/tests/**/*.test.tsx"],
    environment: "jsdom",
    globals: true,
    coverage: {
      reporter: ['text', 'json', 'html'],
    },
  },
});
