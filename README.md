# lenix_criminaltask
A fun task for criminal characters

# About
### Introduction
Welcome to Criminal Task.

This script is designed to enhance your server's gameplay by:
* Adding a fun task that makes the player search for a random NPC and request a task from him, then a location'll be mark on the map to the unknown box so he pick it up and goes to the next task

### Instructions
* Installation: configure your [client api](./client/api/index.ts) and [server api](./server/api/index.ts)
 * Node.js: make sure you have the Node.js installed on your device, to do so run: 
  ```bash
  node -v
  ```
  1. run: npm i
  2. run: npm run build
* Environment: QBox
* Support: available

> Enjoy your improved gaming experience with Criminal Task!

### Configuration
```ts
const config = {
  items: {
    ['string']: { /**@field itemName here you put the item name that you want to receive*/
      percentage: number, /**@field here you put the percentage of getting this item*/
      amount: number /**@field here you put the amount of items you want to receive of this item*/
    },
    /** examples */
    ['water']: {
      percentage: 25,
      amount: 2
    },
    ['weapon-pistol']: {
      percentage: 75,
      amount: 1
    }
  }
}
```
