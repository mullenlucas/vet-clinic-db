/* Queries */

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN DATE '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = 'true' AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = 'true';
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- # TRANSACTIONS #

-- #1
BEGIN;
-- setting the species column to unspecified
UPDATE animals SET species = 'unspecified';
SELECT species from animals;

-- rollback species column
ROLLBACK;
SELECT species from animals;

-- #2
BEGIN;
-- setting the species column to digimon for all animals that have a name ending in mon
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

-- setting the species column to pokemon for all animals that don't have species already set.
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

-- commit transaction
COMMIT;

SELECT * FROM animals;

-- #3
BEGIN;

-- delete all records in the animals table
DELETE FROM animals;
SELECT * FROM animals;

-- roll back the transaction
ROLLBACK;
SELECT * FROM animals;

-- #4
BEGIN;

-- Delete all animals born after Jan 1st, 2022
DELETE FROM animals WHERE date_of_birth > '2022-01-01';

-- Create a savepoint for the transaction
SAVEPOINT db_before2022;

-- Update all animals' weight to be their weight multiplied by -1
UPDATE animals SET weight_kg = weight_kg * -1;
SELECT * FROM animals;

-- Rollback to the savepoint
ROLLBACK TO SAVEPOINT db_before2022;
SELECT * FROM animals;

-- Update all animals' weights that are negative to be their weight multiplied by -1
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

-- Commit transaction
COMMIT;
SELECT * FROM animals;

-- # QUERIES #

-- Tuesday Queries

\echo Count how many animals are there:
SELECT COUNT(*) FROM animals;

\echo Count how many animals have never tried to escape:
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

\echo What is the average weight of animals:
SELECT ROUND(AVG(weight_kg)) FROM animals;

\echo Who escapes the most, neutered or not neutered animals:
SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;

\echo What is the minimum and maximum weight of each type of animal:
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

\echo What is the average number of escape attempts per animal type of those born between 1990 and 2000:
SELECT species, ROUND(AVG(escape_attempts)) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

-- Wednesday Queries
\echo Animals belonging to Melody Pond:
SELECT name FROM animals JOIN owners ON owner_id = owners.id WHERE full_name = 'Melody Pond';

\echo List all pokemon animals:
SELECT animals.name FROM animals JOIN species ON species_id = species.id WHERE species.name = 'Pokemon';

\echo List all owners and their animals:
SELECT owners.full_name, animals.name FROM owners JOIN animals ON owner_id = owners.id;

\echo How many animals are there per species:
SELECT species.name, COUNT(*) FROM animals JOIN species ON species_id = species.id GROUP BY species.name;

\echo List all Digimon owned by Jennifer Orwell:
SELECT animals.name FROM animals JOIN species ON species_id = species.id JOIN owners ON owner_id = owners.id WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

\echo List all animals owned by Dean Winchester that havent tried to escape:
SELECT animals.name FROM animals JOIN owners ON owner_id = owners.id WHERE owners.full_name = 'Dean Winchester' AND escape_attempts = 0;

\echo Who owns the most animals:
SELECT owners.full_name, COUNT(*) FROM owners JOIN animals ON owner_id = owners.id GROUP BY owners.full_name ORDER BY COUNT(*) DESC LIMIT 1;
