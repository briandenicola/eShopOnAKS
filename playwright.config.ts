import { defineConfig, devices } from '@playwright/test';
require("dotenv").config({ path: "./.env" });
import path from 'path';

export const STORAGE_STATE = path.join(__dirname, 'playwright/.auth/user.json');

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,  
  workers: process.env.CI ? 1 : undefined,
  
  reporter: 'html',
  
  use: {
    baseURL: process.env["APPLICATION_URI"]. //'http://localhost:5045',

    trace: 'on-first-retry',
    ...devices['Desktop Chrome'],
  },

  projects: [
    {
      name: 'setup',
      testMatch: '**/*.setup.ts',
    },
    {
      name: 'e2e tests logged in',
      testMatch: ['**/AddItemTest.spec.ts', '**/RemoveItemTest.spec.ts'],
      dependencies: ['setup'],
      use: {
        storageState: STORAGE_STATE,
      },
    },
    {
      name: 'e2e tests without logged in',
      testMatch: ['**/BrowseItemTest.spec.ts'],
    }
  ]
});
