-- ========================================
-- 1. Création de la table Trottinette
-- ========================================
CREATE TABLE Trottinette (
    id INT PRIMARY KEY AUTO_INCREMENT,
    modele VARCHAR(50),
    sante_batterie INT CHECK (sante_batterie BETWEEN 0 AND 100),
    statut VARCHAR(20) DEFAULT 'En Utilisation'
);

-- ========================================
-- 2. Ajouter la colonne nb_batteries
-- ========================================
ALTER TABLE Trottinette
ADD nb_batteries INT NOT NULL DEFAULT 0;

-- ========================================
-- 3. Trigger TR1 - Vérifie que sante_batterie est entre 0 et 100
-- ========================================
DELIMITER $$

CREATE TRIGGER TR1
BEFORE INSERT ON Trottinette
FOR EACH ROW
BEGIN
    IF NEW.sante_batterie < 0 OR NEW.sante_batterie > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La santé de la batterie doit être entre 0 et 100.';
    END IF;
END$$

DELIMITER ;

-- ========================================
-- 4. Trigger TR2 - Modifie le statut à "Retiré" après ajout dans Remplacement
-- ========================================
DELIMITER $$

CREATE TRIGGER TR2
AFTER INSERT ON Remplacement
FOR EACH ROW
BEGIN
    UPDATE Trottinette
    SET statut = 'Retiré'
    WHERE id = NEW.id_trottinette;
END$$

DELIMITER ;

-- ========================================
-- 5. Fonction FCT1 - Retourne le total de batteries consommées pour une trottinette
-- ========================================
DELIMITER $$

CREATE FUNCTION FCT1(id_trot INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT SUM(nb_batteries) INTO total
    FROM Trottinette
    WHERE id = id_trot;

    RETURN IFNULL(total, 0);
END$$

DELIMITER ;

-- ========================================
-- 6. Gestion des utilisateurs et rôles
-- ========================================

-- a. Créer le rôle 'RoleReparateur'
CREATE ROLE 'RoleReparateur';

-- b. Donner les droits à 'RoleReparateur' sur Trottinette et Remplacement
GRANT INSERT, UPDATE, DELETE ON Trottinette TO 'RoleReparateur';
GRANT INSERT, UPDATE, DELETE ON Remplacement TO 'RoleReparateur';

-- c. Créer l'utilisateur Fatima avec mot de passe 1111
CREATE USER 'Fatima'@'localhost' IDENTIFIED BY '1111';

-- d. Attribuer le rôle à l'utilisateur
GRANT 'RoleReparateur' TO 'Fatima'@'localhost';
