/* 🔹 Partie Pratique – Dossier 1 : Gestion des données MySQL (12 pts)
1. Créer la table Vélo avec la colonne nb_batteries :  */

                                                                                                                                                                                        CREATE TABLE Vélo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matricule VARCHAR(20),
    date_maintenance DATE,
    date_prochaine_maintenance DATE,
    nb_batteries INT
);


-- 2. Modifier TR1 pour ajouter une batterie avec valeur 1 à nb_batteries :
UPDATE Vélo SET nb_batteries = 1 WHERE id = TR1;

-- 3. a. Ajouter une colonne sante_batterie dans la table Batteries :
ALTER TABLE Batteries ADD sante_batterie INT;
--  b. Modifier TR2 pour mettre la santé à 100 et ajouter une nouvelle batterie :
UPDATE Batteries SET sante_batterie = 100 WHERE id = TR2;
-- Ajout d'une nouvelle batterie
INSERT INTO Batteries (numero_serie, sante_batterie) VALUES ('XXX', 100);

-- 4. Changer statut d une batterie dans table Changement :
UPDATE Changement SET statut = 'Retirée' WHERE id_batterie = TR2;

--  5. Écrire une procédure CTR() pour total de batteries utilisées par vélo donné :
DELIMITER //
CREATE PROCEDURE CTR(IN idVelo INT)
BEGIN
    SELECT SUM(nb_batteries) AS total_batteries
    FROM Vélo
    WHERE id = idVelo;
END //
DELIMITER ;

-- 6. Gestion des rôles/utilisateurs :
-- a. Créer rôle RoleTechnicien :
CREATE ROLE 'RoleTechnicien';
--  b. Donner droits SELECT, INSERT, UPDATE sur Vélo et Changement :
GRANT SELECT, INSERT, UPDATE ON Vélo TO 'RoleTechnicien';
GRANT SELECT, INSERT, UPDATE ON Changement TO 'RoleTechnicien';
--  c. Créer utilisateur Ali avec mot de passe 0000 :
CREATE USER 'Ali'@'localhost' IDENTIFIED BY '0000';
--  d. Attribuer rôle RoleTechnicien à Ali :
GRANT 'RoleTechnicien' TO 'Ali';