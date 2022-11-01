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

-- Thursday Queries

\echo Who was the last animal seen by William Tatcher:
SELECT animals.name AS animals_seen, vets.name AS vet, visits.visit_date AS date FROM animals
JOIN visits ON animal_id = visits.animal_id 
JOIN vets ON visits.vet_id = vets.id 
WHERE vets.name = 'William Tatcher' 
ORDER BY visits.visit_date 
DESC LIMIT 1;

\echo How many different animals did Stephanie Mendez see
SELECT COUNT(DISTINCT animals.name) AS total_animals, 
COUNT(DISTINCT animals.species_id) AS types_seen, vets.name AS vet FROM animals
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez' 
GROUP BY vets.name;

\echo List all vets and their specialties, including vets with no specialties
SELECT vets.name AS vet_name, species.name FROM vets 
LEFT JOIN specializations ON specializations.vet_id = vets.id 
LEFT JOIN species ON specializations.species_id = species.id;

\echo List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020
SELECT animals.name AS animals, vets.name As vet_name FROM animals 
JOIN visits ON visits.animal_id = animals.id 
JOIN vets ON visits.vet_id = vets.id 
WHERE visit_date BETWEEN DATE '2020-04-01' AND '2020-08-30' AND vets.name = 'Stephanie Mendez';

\echo What animal has the most visits to vets
SELECT animals.name, COUNT(visit_date) AS number_of_visits FROM visits 
JOIN animals ON visits.animal_id = animals.id 
GROUP BY animals.name 
ORDER BY number_of_visits 
DESC LIMIT 1;

\echo Who was Maisy Smiths first visit
SELECT animals.name AS animal, visits.visit_date AS v_date FROM animals 
JOIN visits ON visits.animal_id = animals.id 
JOIN vets ON visits.vet_id = vets.id WHERE vets.name = 'Maisy Smith' 
ORDER BY visit_date 
ASC LIMIT 1;

\echo Details for most recent visit animal information, vet information, and date of visit
SELECT animals.name, vets.name, visit_date FROM animals 
JOIN visits ON animal_id = animals.id 
JOIN vets ON vet_id = vets.id 
ORDER BY visit_date 
DESC LIMIT 1;

\echo How many visits were with a vet that did not specialize in that animals species
SELECT COUNT(*) FROM visits JOIN animals 
ON animals.id = visits.animal_id
JOIN vets ON vets.id = visits.vet_id
WHERE animals.species_id NOT IN (
    SELECT species_id FROM specializations 
    WHERE vet_id = vets.id
    );

\echo What specialty should Maisy Smith consider getting? Look for the species she gets the most
SELECT species.name, COUNT(*) FROM visits
JOIN animals ON animals.id = visits.animal_id
JOIN species ON species.id = animals.species_id
JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY COUNT(*) 
DESC LIMIT 1;

-- Performance queries
\echo Performance queries:

SELECT COUNT(*) FROM visits where animals_id = 4;

SELECT * FROM visits WHERE vets_id = 2;

SELECT * FROM owners WHERE email = 'owner_18327@mail.com';
