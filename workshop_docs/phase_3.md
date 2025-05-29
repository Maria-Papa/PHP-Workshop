## Phase 3: Python Microservice & Inter-Service Communication (Microservices, Python, REST APIs, Scalability)

**Objective:** Build a small Python microservice and integrate it with your PHP application, simulating real-world microservice communication.

**Keywords Targeted:** Python, Microservices Development, REST APIs, Scalability, Communication, Learning Agility.

### Instructions
1. **Python Microservice - "Delivery Time Estimator":**
    - **Project Structure:** Create a new directory outside your main Laravel project (e.g., `delivery-estimator-service`).
    - **Python Setup:** Use `pipenv` or `venv` to create a virtual environment.
    - **Flask/FastAPI:** Build a simple REST API using Flask or FastAPI.
    - **Endpoint:** Create an endpoint `GET /estimate-time?restaurant_lat={lat}&restaurant_lon={lon}&user_lat={lat}&user_lon={lon}`.
    - **Logic:** The service should return a simulated delivery time (e.g., a random number between 15-60 minutes, or a very basic calculation based on distance).
    - **Dockerize the Python Service:** Create a `Dockerfile` for your Python application. Add this service to your `docker-compose.yml` to run alongside your PHP app and databases. Ensure it has a distinct port.
2. **PHP Integration:**
    - **Guzzle HTTP Client:** In your Laravel application, use a package like Guzzle HTTP Client to make requests to your Python microservice.
    - **Service Class:** Create a `DeliveryEstimatorService` in your Laravel app that encapsulates the Guzzle calls to the Python service. Inject this service where needed (e.g., in `OrderController`).
    - **Endpoint Enhancement:** Modify your `OrderController` (or create a new endpoint) to call the `DeliveryEstimatorService` and include the estimated delivery time in the order response.
3. **Communication & Scalability Discussion:**
    - Discuss the benefits and drawbacks of synchronous HTTP communication between microservices.
    - How would you handle potential failures of the Python service (e.g., timeouts, retries, circuit breakers)?
    - What other patterns could be used for inter-service communication (e.g., message queues like RabbitMQ or Kafka, gRPC)?

### Self-Check/Reflection
- Can your PHP application successfully call the Python microservice and get a response?
- Do you understand why you'd split this functionality into a separate service?
- What challenges do microservices introduce compared to a monolithic application?

[← Back to Workshop](/README.md#workshop)

[← Back to Phase 2](/workshop_docs/phase_2.md)

[Next to Phase 4 →](/workshop_docs/phase_4.md)
