# Install Instructions
1. Clone this repository
2. `cd` into the base repository directory
3. Run `docker-compose -f docker/dev.yml run infra-wait`
4. Run `docker-compose -f docker/dev.yml run load-script`
5. Data is loaded! Can access postgres shell by running `docker-compose -f docker/dev.yml exec postgres sh ` and then running `psql -U postgres` from the CMD line or on `localhost:5432`
