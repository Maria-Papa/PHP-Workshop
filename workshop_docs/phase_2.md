## Phase 2: Order Management & Advanced Patterns (REST APIs, Design Patterns, Redis, Postgres)

**Objective:** Implement order placement and status updates, integrating Redis for caching and applying more advanced design patterns.

**Keywords Targeted:** REST APIs, Software Sesign Patterns, Redis, Postgres, High Quality Software, Scalability, Problem Solver.

### Instructions
1. **Database Migrations (Postgres):**
    - Create `orders` table (id, user_id, restaurant_id, total_amount, status, created_at, updated_at).
    - Create `order_items` table (id, order_id, menu_item_id, quantity, price_at_purchase).
2. **Order Placement API:**
    - **Controller:** `OrderController` with a `store` method.
    **Business Logic:**
        - When an order is placed, validate that menu items belong to the specified restaurant and are available.
        - Calculate the total amount.
        - Atomically create the `order` and `order_items` entries (use database transactions).
    - **Factory Method Pattern:** Implement a `OrderFactory` (or similar) to encapsulate the creation of `Order` and `OrderItem` objects, ensuring they are correctly instantiated and associated.
    - **Observer Pattern (Conceptual/Lightweight Implementation):** Consider how you would use an Observer pattern (e.g., Laravel Events) to trigger actions when an order status changes (e.g., notify restaurant, send user confirmation). You don't need a full notification system, just demonstrate the event firing and a listener.
3. **Order Status Update API:**
    - **Controller:** Add an `updateStatus` method to `OrderController`.
    - **Strategy Pattern:** Implement a Strategy Pattern for order status transitions.
        - Define an `OrderStatusTransitionInterface` with a `canTransition(Order $order, string $newStatus): bool` and `transition(Order $order): void` method.
        - Create concrete strategy classes for valid transitions (e.g., `PendingToPreparing`, `PreparingToDelivered`, `CanceledOrder`).
        - Your controller will receive the desired new status and use a `OrderStatusTransitionResolver` (or similar) to select the correct strategy.
        - This ensures that only valid status changes are allowed.
4. **Redis Integration - Caching:**
    - **Restaurant/Menu Item Caching:**
        - When retrieving a restaurant or menu item (e.g., `RestaurantController::show` or `MenuItemController::index`), attempt to fetch it from Redis first.
        - If not found, fetch from Postgres, store in Redis, and then return.
        - Consider cache invalidation strategies (e.g., when a restaurant or menu item is updated, remove it from the cache).
    - **Order Caching (Conceptual/Simple):** Think about how you might cache recent orders or popular order combinations.

### Self-Check/Reflection
    - Are your API endpoints for orders working correctly?
    - Can you explain why you chose to use transactions for order placement?
    - How does the Strategy Pattern improve the maintainability and extensibility of your order status logic?
    - What are the benefits of using Redis for caching in this scenario? - What are its limitations?
    - How would you handle race conditions if multiple users tried to order the same item and stock was low? (Hint: Database locks, queues).
    
[← Back to Workshop](/README.md#workshop)

[← Back to Phase 1](/workshop_docs/phase_1.md)

[Next to Phase 3 →](/workshop_docs/phase_3.md)
