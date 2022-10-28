/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(100),
    date_of_birth DATE NOT NULL,
    escape_attempts INT NOT NULL,
    neutered BOOLEAN NOT NULL,
    weight_kg DECIMAL NOT NULL
);

-- Add a column species of type string to your animals table
ALTER TABLE animals ADD species VARCHAR(60);

-- Create 'owners' table
CREATE TABLE owners (
    id SERIAL NOT NULL PRIMARY KEY,
    full_name VARCHAR(150),
    age INT NOT NULL
);

-- Create 'species' table
CREATE TABLE species (
    id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(60)
);

-- Delete species column from 'animals' table
ALTER TABLE animals DROP COLUMN species;

-- Add species_id column to 'animals' table
ALTER TABLE animals ADD species_id INT;
-- Add foreign key to 'animals' table
ALTER TABLE animals ADD FOREIGN KEY(species_id) REFERENCES species(id);

-- Add owner_id column to 'animals' table
ALTER TABLE animals ADD owner_id INT;
-- Add foreign key to 'animals' table
ALTER TABLE animals ADD FOREIGN KEY(owner_id) REFERENCES owners(id);

-- Create vets table:
CREATE TABLE vets (
    id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(100),
    age INT NOT NULL,
    date_of_graduation DATE NOT NULL
);

-- Create many-to-many relationship between 'species' and 'vets' tables
CREATE TABLE specializations (
    species_id INT NOT NULL REFERENCES species(id),
    vet_id INT NOT NULL REFERENCES vets(id),
    PRIMARY KEY (species_id, vet_id)
);

-- Create many-to-many relationship between 'animals' and 'vets' tables
CREATE TABLE visits (
    animal_id INT NOT NULL REFERENCES animals(id),
    vet_id INT NOT NULL REFERENCES vets(id),
    visit_date DATE NOT NULL
);
