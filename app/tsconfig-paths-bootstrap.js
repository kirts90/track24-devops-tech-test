// Fix for @/ imports in TypeScript
require('tsconfig-paths').register({
  baseUrl: '.',
  paths: { '@/*': ['src/*'] }
});