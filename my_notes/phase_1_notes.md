## Phase 1 Notes: Restaurant & Menu Management (REST APIs, SOLID, Design Patterns, Postgres)

### Steps

1. **Database Migrations (Postgres):**

    #### A. Decide column data types

    `cuisine_types` Table

    | Column Name    | Data Type   | Constraints / Description                     |
    | :------------- | :---------- | :-------------------------------------------- |
    | `id`           | INTEGER     | Primary Key (PK), Auto-Increment (AI), Unique |
    | `name`         | VARCHAR(255)| NOT NULL, Name of the cuisine type            |

    > **Note:** Do a case-insensitive uniqueness check for the cuisine type name.

    <br>

    `restaurants` Table

    | Column Name       | Data Type   | Constraints / Description                                                           |
    | :---------------- | :---------- | :---------------------------------------------------------------------------------- |
    | `id`              | INTEGER     | Primary Key (PK), Auto-Increment (AI), Unique                                       |
    | `name`            | VARCHAR(255)| NOT NULL, Name of the restaurant                                                    |
    | `address`         | VARCHAR(255)| NOT NULL, Physical address of the restaurant                                        |
    | `cuisine_type_id` | INTEGER     | Foreign Key (FK) referencing `cuisine_types.id`, NOT NULL                              |
    | `status`          | ENUM        | NOT NULL, Current operational status (e.g., 'open', 'closed', 'temporarily_closed') |

    <br>

    `menu_items` Table

    | Column Name    | Data Type    | Constraints / Description                                           |
    | :------------- | :----------- | :------------------------------------------------------------------ |
    | `id`           | INTEGER      | Primary Key (PK), Auto-Increment (AI), Unique                       |
    | `restaurant_id`| INTEGER      | Foreign Key (FK) referencing `restaurants.id`, NOT NULL             |
    | `name`         | VARCHAR(255) | NOT NULL, Name of the menu item                                     |
    | `description`  | TEXT         | Optional, Detailed description of the menu item                     |
    | `price`        | DECIMAL(10,2)| NOT NULL, Price of the menu item, positive value                    |
    | `is_available` | BOOLEAN      | NOT NULL, Indicates if the item is currently available (TRUE/FALSE) |

    #### B. Make Migrations

    ```bash
    make artisan make:migration create_cuisine_types_table
    make artisan make:migration create_restaurants_table
    make artisan make:migration create_menu_items_table
    ```

    Open the created migration files, and adjust the up and down functions as needed.

    #### C. Run Migrations

    ```bash
    make migrate
    ```

    #### D. View PostgreSQL Tables

    Install [PostgreSQL](https://marketplace.visualstudio.com/items?itemName=ms-ossdata.vscode-pgsql) VS Code extension to view PostgreSQL database.

    Connection String:
    ```
    postgresql://laravel:secret@localhost:5432/laravel
    ```
    
    Breakdown of the connection string:
    - **postgresql://:** The scheme indicating it's a PostgreSQL connection.
    - **laravel:secret:** The username (`laravel`) and password (`secret`), separated by a colon.
    - **@localhost:** The host address.
    - **:5432:** The port number.
    - **/laravel:** The database name.

2. **Cuisine Type API:**

    #### A. Write a RED Test (TDD)

    **Red Test:** A test that describes the desired API behavior. It should fail, because no controller or api route exists yet.

    Create Test:
    ```bash
    make artisan ARGS="make:test CuisineTypeApiTest"
    ```

    Run Test (and watch it fail):
    ```bash
    make test ARGS="--filter getCuisineTypes"
    ```

    #### B. Build Just Enough to Pass (Green Test)

    **Green Test:** The minimum code to make the test pass.

    Enable API routing by using the `install:api` Artisan command:
    ```bash
    make artisan ARGS="install:api"
    ```

    Create a model and a factory:
    ```bash
    make artisan ARGS="make:model CuisineType --factory"
    ```

    Create the api controller and make the index function:
    ```bash
    make artisan ARGS="make:controller Api/CuisineTypeController"
    ```

    Add the route for the Controller request to `src/routes/api.php`.

    Run the test again (it should pass).

    #### C. Refactor

    Add resource formatting:
    ```bash
    make artisan ARGS="make:resource CuisineTypeResource"
    ```

    Change index function inside CuisineTypeController.

    ```bash
    make artisan ARGS="make:rule UniqueCuisineName"
    ```

## Reassignment Before Deletion (Keep in Mind)

When you have a `parent record` (like a `cuisine_type`) that is referenced by child records (like `restaurants` via a foreign key), and you want to delete the parent without deleting the children, here's the typical application logic flow:

1. **Check for Child Dependencies:** Before allowing the deletion, your application should query the `child table(s)` to see if any records are currently linked to the specific parent record you're trying to delete.
2. **If Child Dependencies Exist:**
    - **Prompt the User:** Clearly inform the user that deleting this `parent record` will affect associated `child records`.
    - **Offer Reassignment:** Provide a clear mechanism (e.g., a dropdown, a search field) for the user to select an alternative existing `parent record` to which all the affected `child records` should be reassigned.
    - **Perform Update:** Once the user makes a selection, update all the `child records`, changing their foreign key value from the old `parent's ID` to the new parent's ID.
    - **Then Delete:** Only after successfully reassigning all `child records` (or if no `child records` were linked initially), proceed with the deletion of the original `parent record`.
3. **If No Child Dependencies Exist:** Allow the deletion of the `parent record` immediately, as there are no associated `children` to worry about.

## Sources

### Laravel
- [Generating Migrations](https://laravel.com/docs/12.x/migrations#generating-migrations)
- [Migration Structure](https://laravel.com/docs/12.x/migrations#migration-structure)
- [Available Column Types](https://laravel.com/docs/12.x/migrations#available-column-types)
- [Foreign Key Constraints](https://laravel.com/docs/12.x/migrations#foreign-key-constraints)
- [Dropping Foreign Keys](https://laravel.com/docs/12.x/migrations#dropping-foreign-keys)
- [Basic Controllers](https://laravel.com/docs/12.x/controllers#basic-controllers)
- [Generating Model Classes](https://laravel.com/docs/12.x/eloquent#generating-model-classes)
- [Creating Tests](https://laravel.com/docs/12.x/testing#creating-tests)
- [API Routes](https://laravel.com/docs/12.x/routing#api-routes)

### PostgreSQL
- [Connection URIs](https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING-URIS)
