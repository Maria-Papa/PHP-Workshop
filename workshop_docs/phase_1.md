## Phase 1: Restaurant & Menu Management (REST APIs, SOLID, Design Patterns, Postgres)

**Objective:** Implement CRUD APIs for restaurants and menu items, focusing on clean architecture and applying SOLID principles and common design patterns.

**Keywords Targeted:** PHP, REST APIs, SOLID Principles, Software Design Patterns, Postgres, High Quality Software, Problem Solver.

### Instructions

1. **Database Migrations (Postgres):**
    - Create migrations for `cuisine_types` table (id, name).
    - Create migrations for `restaurants` table (id, name, address, cuisine_type_id, status - e.g., 'open', 'closed'). Ensure cuisine_type_id is a **foreign key** referencing the `cuisine_types` table.
    - Create migrations for `menu_items` table (id, restaurant_id, name, description, price, is_available). Ensure restaurant_id is a **foreign key** referencing the `restaurants` table.
    - Run migrations.

2. **Cuisine Type API:**
    - **Resource Controller:** Create `CuisineTypeController` with `index`, `show`, `store`, `update`, `destroy` methods.
    - **Request Validation:** Implement Laravel Form Requests for `store` and `update` methods. Ensure the `name` is required and unique.
    - **Repository Pattern:**
        - Create a `Contracts/CuisineTypeRepositoryInterface.php`.
        - Create an `EloquentCuisineTypeRepository.php` that implements the interface.
        - Use Dependency Injection in your `CuisineTypeController` to receive `CuisineTypeRepositoryInterface`.
        - Bind the interface to your Eloquent implementation in a Service Provider.
    - **Testing (Optional but Recommended):** Write basic feature tests for the Cuisine Type API endpoints.

3. **Restaurant API:**
    - **Resource Controller:** Create `RestaurantController` with `index`, `show`, `store`, `update`, `destroy` methods.
    - **Request Validation:** Implement Laravel Form Requests for `store` and `update` methods to ensure data integrity. It is crucial to validate that `cuisine_type_id` is present and refers to an existing `cuisine_types` in your database.
    - **Repository Pattern:**
        - Create a `Contracts/RestaurantRepositoryInterface.php`.
        - Create an `EloquentRestaurantRepository.php` that implements the interface.
        - Use Dependency Injection in your `RestaurantController` to receive `RestaurantRepositoryInterface`.
        - Bind the interface to your Eloquent implementation in a Service Provider.
    - **Testing (Optional but Recommended):** Write basic feature tests for the Restaurant API endpoints.

4. **Menu Item API:**
    - **Resource Controller:** Create `MenuItemController` with similar CRUD methods.
    - **Relationship & Validation:** Ensure menu items are correctly associated with restaurants. When creating or updating a menu item, you must validate that `restaurant_id` is present and refers to an existing `restaurant` in your database.
    - **SOLID Principle - Single Responsibility:** Ensure your controller focuses on handling HTTP requests and delegates business logic to a dedicated service or the repository.
    - **Strategy Pattern (Conceptual/Optional Implementation):** Consider how you might implement different pricing strategies for menu items (e.g., discount, tiered pricing) using a Strategy pattern, even if you don't fully implement the logic. Just sketch out the classes.

### Self-Check/Reflection
- Can you create, retrieve, update, and delete cuisine types, restaurants, and menu items via your API?
- Have you correctly applied the Repository Pattern across all relevant resources and understood its benefits (e.g., testability, decoupling)?
- How does the `cuisine_types` table improve data integrity and flexibility compared to a direct string field, and how does its dedicated API support this?
- Where else in this phase could you apply SOLID principles (e.g., separating validation logic, transforming response data)?
- What are the benefits of using Laravel's request validation for robust API development?

[← Back to Workshop](/README.md#workshop)

[Next to Phase 2 →](/workshop_docs/phase_2.md)
