## Phase 1: Restaurant & Menu Management (REST APIs, SOLID, Design Patterns, Postgres)

**Objective:** Implement CRUD APIs for restaurants and menu items, focusing on clean architecture and applying SOLID principles and common design patterns.

**Keywords Targeted:** PHP, REST APIs, SOLID Principles, Software Design Patterns, Postgres, High Quality Software, Problem Solver.

### Instructions
1. **Database Migrations (Postgres):**
    - Create migrations for `restaurants` table (id, name, address, cuisine_type, status - e.g., 'open', 'closed').
    - Create migrations for `menu_items` table (id, restaurant_id, name, description, price, is_available). Ensure `restaurant_id` is a foreign key.
    - Run migrations.
2. **Restaurant API:**
    - **Resource Controller:** Create `RestaurantController` with `index`, `show`, `store`, `update`, `destroy` methods.
    - **Request Validation:** Implement Laravel Form Requests for `store` and `update` methods to ensure data integrity.
    - **Repository Pattern:**
        - Create a `Contracts/RestaurantRepositoryInterface.php`.
        - Create an `EloquentRestaurantRepository.php` that implements the interface.
        - Use Dependency Injection in your `RestaurantController` to receive `RestaurantRepositoryInterface`.
        - Bind the interface to your Eloquent implementation in a Service Provider.
    - **Testing (Optional but Recommended):** Write basic feature tests for the Restaurant API endpoints.
3. **Menu Item API:**
    - **Resource Controller:** Create `MenuItemController` with similar CRUD methods.
    - **Relationship:** Ensure menu items are correctly associated with restaurants. When creating a menu item, it must belong to an existing restaurant.
    - **SOLID Principle - Single Responsibility:** Ensure your controller focuses on handling HTTP requests and delegates business logic to a dedicated service or the repository.
    - **Strategy Pattern (Conceptual/Optional Implementation):** Consider how you might implement different pricing strategies for menu items (e.g., discount, tiered pricing) using a Strategy pattern, even if you don't fully implement the logic. Just sketch out the classes.

### Self-Check/Reflection
- Can you create, retrieve, update, and delete restaurants and menu items via your API?
- Have you correctly applied the Repository Pattern and understood its benefits (e.g., testability, decoupling)?
- Where else in this phase could you apply SOLID principles (e.g., separating validation logic, transforming response data)?
- What are the benefits of using Laravel's request validation?

[← Back to Workshop](/README.md#workshop)

[Next to Phase 2 →](/workshop_docs/phase_2.md)
