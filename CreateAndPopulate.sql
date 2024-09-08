DROP DATABASE IF EXISTS `cube_smasher`;

CREATE DATABASE IF NOT EXISTS `cube_smasher` DEFAULT CHARACTER SET = 'utf8' DEFAULT COLLATE 'utf8_general_ci';

USE `cube_smasher`;

# -------------------------------- TABLES CREATION ----------------------------------- #

CREATE TABLE IF NOT EXISTS `GENRE` (
	`genre_id` varchar(3) NOT NULL PRIMARY KEY,
    `genre_name` varchar(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS `DIRECTOR` (
	`director_id` varchar(3) NOT NULL PRIMARY KEY,
    `director_name` varchar(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS `MOVIE` (
	`movie_id` INTEGER AUTO_INCREMENT PRIMARY KEY,
    `name` varchar(50) NOT NULL,
    `director_id` varchar(3) NOT NULL,
    `release_date` date NOT NULL,
    `length` INTEGER NOT NULL,
    `content_rating_id` varchar(5) NOT NULL DEFAULT 'NR',
    CHECK (`length` > 0)
);

CREATE TABLE `MOVIE_GENRE` (
	`movie_id` INTEGER NOT NULL,
    `genre_id` varchar(3) NOT NULL,
    PRIMARY KEY (`movie_id`, `genre_id`)
);

CREATE TABLE IF NOT EXISTS `CONTENT_RATING` (
	`content_rating_id` varchar(5) NOT NULL PRIMARY KEY,
    `content_rating_description` varchar(40) NOT NULL
);

CREATE TABLE IF NOT EXISTS `COPY` (
	`copy_id` INTEGER NOT NULL,
    `movie_id` INTEGER NOT NULL,
    `store_id` varchar(5) NOT NULL,
    `condition_id` TINYINT NOT NULL DEFAULT 3,
    `available` BOOL NOT NULL DEFAULT TRUE,
    PRIMARY KEY (`copy_id`, `movie_id`)
);

CREATE TABLE IF NOT EXISTS `CONDITION` (
	`condition_id` TINYINT NOT NULL PRIMARY KEY,
    `condition_description` varchar(20) NOT NULL
);
# unusable - 0, major visible damage - 1, minor visible damage - 2, no visible damage - 3

CREATE TABLE IF NOT EXISTS `STATE` (
	`state_id` varchar(2) NOT NULL PRIMARY KEY,
    `state_name` varchar(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS `LOCATION` (
	`location_id` INTEGER NOT NULL PRIMARY KEY,
    `state_id` varchar(2) NOT NULL,
    `street_address` varchar(50) NOT NULL,
    `zip_code` varchar(12) NOT NULL,
    `city` varchar(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS `STORE` (
	`store_id` varchar(5) NOT NULL PRIMARY KEY,
    `location_id` INTEGER UNIQUE NOT NULL,
    `store_email` varchar(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS `STOCK` (
	`movie_id` INTEGER NOT NULL,
    `store_id` varchar(5) NOT NULL,
    `stock` TINYINT NOT NULL,
    PRIMARY KEY (`movie_id`, `store_id`)
);

CREATE TABLE IF NOT EXISTS `EMPLOYEE` (
	`employee_id` INTEGER NOT NULL PRIMARY KEY,
    `first_name` varchar(20) DEFAULT NULL,
    `last_name` varchar(25) NOT NULL,
    `phone_nr` varchar(20) NOT NULL,
    `email` varchar(40) DEFAULT NULL,
    `date_of_birth` date NOT NULL,
    `store_id` varchar(5) NOT NULL,
    `salary` INTEGER NOT NULL,
    `location_id` INTEGER NOT NULL,
    `manager_id` INTEGER DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS `CLIENT` (
	`client_id` INTEGER AUTO_INCREMENT PRIMARY KEY,
    `first_name` varchar(20) DEFAULT NULL,
    `last_name` varchar(25) NOT NULL,
    `phone_nr` varchar(20) NOT NULL,
    `email` varchar(40) DEFAULT NULL,
    `date_of_birth` date NOT NULL,
    `location_id` INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS `RENTAL` (
	`rental_id` INTEGER NOT NULL PRIMARY KEY,
    `employee_id` INTEGER NOT NULL,
    `client_id` INTEGER NOT NULL,
    `rental_date` date NOT NULL
);

CREATE TABLE IF NOT EXISTS `RENTAL_PRODUCT` (
	`rental_id` INTEGER NOT NULL,
    `copy_id` INTEGER NOT NULL,
    `movie_id` INTEGER NOT NULL,
    `return_date` date DEFAULT NULL,
    `rating` TINYINT DEFAULT NULL,
    `price` FLOAT NOT NULL,
    `fine` TINYINT DEFAULT NULL,
    `return_condition` TINYINT DEFAULT NULL, # isto estava not null
    PRIMARY KEY (`rental_id`, `copy_id`, `movie_id`)
);

CREATE TABLE `LOG`(
	`log_id` INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	`tstamp` DATETIME NOT NULL,
	`usr` varchar(63),
	`evt` varchar(15),
	`msg` varchar(255)
);

# -------------------------------- FOREIGN KEYS ----------------------------------- #

ALTER TABLE `MOVIE`
ADD CONSTRAINT `fk_movie_director`
  FOREIGN KEY (`director_id`)
  REFERENCES `DIRECTOR` (`director_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

ALTER TABLE `MOVIE`
ADD CONSTRAINT `fk_movie_content_rating`
  FOREIGN KEY (`content_rating_id`)
  REFERENCES `CONTENT_RATING` (`content_rating_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `MOVIE_GENRE`
ADD CONSTRAINT `fk_movie`
  FOREIGN KEY (`movie_id`)
  REFERENCES `MOVIE` (`movie_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `MOVIE_GENRE`
ADD CONSTRAINT `fk_genre`
  FOREIGN KEY (`genre_id`)
  REFERENCES `GENRE` (`genre_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `COPY`
ADD CONSTRAINT `fk_copy_movie`
  FOREIGN KEY (`movie_id`)
  REFERENCES `MOVIE` (`movie_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `COPY`
ADD CONSTRAINT `fk_copy_store`
  FOREIGN KEY (`store_id`)
  REFERENCES `STORE` (`store_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `COPY`
ADD CONSTRAINT `fk_copy_condition`
  FOREIGN KEY (`condition_id`)
  REFERENCES `CONDITION` (`condition_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `STOCK`
ADD CONSTRAINT `fk_stock_movie`
  FOREIGN KEY (`movie_id`)
  REFERENCES `MOVIE` (`movie_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `STOCK`
ADD CONSTRAINT `fk_stock_store`
  FOREIGN KEY (`store_id`)
  REFERENCES `STORE` (`store_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `STORE`
ADD CONSTRAINT `fk_store_location`
  FOREIGN KEY (`location_id`)
  REFERENCES `LOCATION` (`location_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `LOCATION`
ADD CONSTRAINT `fk_location_state`
  FOREIGN KEY (`state_id`)
  REFERENCES `STATE` (`state_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `EMPLOYEE`
ADD CONSTRAINT `fk_employee_store`
  FOREIGN KEY (`store_id`)
  REFERENCES `STORE` (`store_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `EMPLOYEE`
ADD CONSTRAINT `fk_employee_manager`
  FOREIGN KEY (`manager_id`)
  REFERENCES `EMPLOYEE` (`employee_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `EMPLOYEE`
ADD CONSTRAINT `fk_employee_location`
  FOREIGN KEY (`location_id`)
  REFERENCES `LOCATION` (`location_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

ALTER TABLE `CLIENT`
ADD CONSTRAINT `fk_client_location`
  FOREIGN KEY (`location_id`)
  REFERENCES `LOCATION` (`location_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

ALTER TABLE `RENTAL`
ADD CONSTRAINT `fk_rental_employee`
  FOREIGN KEY (`employee_id`)
  REFERENCES `EMPLOYEE` (`employee_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `RENTAL`
ADD CONSTRAINT `fk_rental_client`
  FOREIGN KEY (`client_id`)
  REFERENCES `CLIENT` (`client_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `RENTAL_PRODUCT`
ADD CONSTRAINT `fk_product_rental`
  FOREIGN KEY (`rental_id`)
  REFERENCES `RENTAL` (`rental_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `RENTAL_PRODUCT`
ADD CONSTRAINT `fk_rental_copy`
  FOREIGN KEY (`movie_id`, `copy_id`)
  REFERENCES `COPY` (`movie_id`, `copy_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

ALTER TABLE `RENTAL_PRODUCT`
ADD CONSTRAINT `fk_product_condition`
  FOREIGN KEY (`return_condition`)
  REFERENCES `CONDITION` (`condition_id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
# -------------------------------------- TRIGGERS ------------------------------------------ #
  
# ------------- Insert on RENTAL_PRODUCT -------------- #
DELIMITER $$

CREATE TRIGGER Rental_Product_Insert
BEFORE INSERT
ON RENTAL_PRODUCT
FOR EACH ROW
BEGIN
	
    DECLARE client_date_of_birth DATE;
    DECLARE client_age INT;
    DECLARE movie_age INT;
    DECLARE content_id varchar(5);
    DECLARE movie_release_date DATE;
    DECLARE copy_availability BOOL;
    
    # --------------- Check if copy is available for renting ------------ #
	SELECT c.available
	INTO copy_availability
	FROM COPY c
	WHERE NEW.copy_id = c.copy_id
	AND NEW.movie_id = c.movie_id;
	
	IF (copy_availability = FALSE) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Copy not available';
	END IF;
	
    
    # --------------- Check if minimum age is respected ------------ #
    
	# get movie content rating and release date
    SELECT m.content_rating_id, m.release_date
	INTO content_id, movie_release_date
	FROM MOVIE m
	WHERE NEW.movie_id = m.movie_id;
    
	# Content Rating -> G: general; NR: not rated (in both cases, everyone can see the movie)
    IF (content_id <> 'G' AND content_id <> 'NR') THEN 
    
        # get client's date of birth
		SELECT c.date_of_birth
		INTO client_date_of_birth
		FROM RENTAL r, `CLIENT` c
		WHERE NEW.rental_id = r.rental_id
		AND r.client_id = c.client_id;
		        
        # get client's age
        SELECT TIMESTAMPDIFF(YEAR, client_date_of_birth, CURDATE()) INTO client_age;
        
        # check if age follows minimum age required by content rating
        # Content Rating -> PG-13: +13; NC-17: +18
        IF (client_age < 13 AND content_id = 'PG-13') OR (client_age < 18 AND content_id = 'NC-17') THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Minimum age not respected';
        END IF;
    END IF;

    # --------------- Calculate price based on release date ------------ #
    # get movie's age to calculate price
    SELECT TIMESTAMPDIFF(YEAR, movie_release_date, CURDATE()) INTO movie_age;
    
    # define price based on how old the movie is
	# last year -> 15€, last 5 years exluding current year-> 10€, older than 5 years -> 5€
    IF (movie_age < 1) THEN
		SET NEW.price = 15.0;
	ELSEIF (movie_age < 6) THEN
		SET NEW.price = 10.0;
	ELSE
		SET NEW.price = 5.0;
	END IF;
	
	# --------------- Update movie's stock on the store ------------ #        
	UPDATE STOCK s
	JOIN COPY c ON c.copy_id = NEW.copy_id AND c.movie_id = NEW.movie_id
	SET s.stock = s.stock - 1
	WHERE s.movie_id = NEW.movie_id
	AND s.store_id = c.store_id;
	
	# --------------- Update copy's availability ------------ #
	UPDATE COPY c
	SET c.available = FALSE
	WHERE NEW.copy_id = c.copy_id
	AND NEW.movie_id = c.movie_id;    

END $$

DELIMITER ;


# ------------ Update RENTAL_PRODUCT = Copy is returned ------------------- #

DELIMITER $$

CREATE TRIGGER Rental_Product_Update
BEFORE UPDATE
ON RENTAL_PRODUCT
FOR EACH ROW
BEGIN
	DECLARE rent_date DATE;
    DECLARE weeks INTEGER;
	
	# Given that an update means that a copy is being returned, return date and condition need to be filled
	IF (NEW.return_date is NULL) OR (NEW.return_condition is NULL) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Return date and return condition required';
	END IF;
   
   # get date of rental
   SELECT rental_date
   INTO rent_date
   FROM RENTAL
   WHERE rental_id = NEW.rental_id;
   
	# -------------------- Calculate fine --------------------- #
    # rent_date + 30 -> limit date to return product
    # if condition is verified, return_date > limit date
    IF (SELECT TIMESTAMPDIFF(DAY, NEW.return_date, DATE_ADD(rent_date, INTERVAL 30 DAY))) < 0 THEN
		# get nr of weeks between return_date date and limit date
		SELECT TIMESTAMPDIFF(WEEK, DATE_ADD(rent_date, INTERVAL 30 DAY), NEW.return_date) INTO weeks;
        # for each week apply a fine of 5$
        IF weeks = 0 THEN
			SET NEW.fine = 5;
		ELSE
			SET NEW.fine = weeks * 5;
		END IF;
    ELSE
		SET NEW.fine = 0;
    END IF;
    
	# -------------------- Update stock --------------------- #
    UPDATE STOCK s
	JOIN COPY c ON c.copy_id = NEW.copy_id AND c.movie_id = NEW.movie_id
	SET s.stock = s.stock + 1
	WHERE s.movie_id = NEW.movie_id
	AND s.store_id = c.store_id;
    
	# -------------------- Update copy's availability --------------------- #
	UPDATE COPY c
	SET c.available = TRUE
	WHERE NEW.copy_id = c.copy_id
	AND NEW.movie_id = c.movie_id;
    
	# -------------------- Update copy's condition --------------------- #
    UPDATE COPY c
	SET c.condition_id = NEW.return_condition
	WHERE c.copy_id = NEW.copy_id AND c.movie_id = NEW.movie_id;

END $$

DELIMITER ;

# -------------------- LOG TABLE ----------------------------- #
# The log table registers actions performed on the CLIENT table
DELIMITER $$
CREATE TRIGGER client_add_log
AFTER INSERT
ON `CLIENT`
FOR EACH ROW
BEGIN
	INSERT INTO LOG(tstamp, usr, evt, msg) VALUES (NOW(), USER(), "add", CONCAT(NEW.first_name, ' ', NEW.last_name, ' ', NEW.phone_nr));
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER client_updt_log
AFTER UPDATE
ON `CLIENT`
FOR EACH ROW
BEGIN
	INSERT INTO LOG(tstamp, usr, evt, msg) VALUES (NOW(), USER(), "update", CONCAT(NEW.first_name, ' ', NEW.last_name, ' ', NEW.phone_nr));
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER client_del_log
AFTER DELETE
ON `CLIENT`
FOR EACH ROW
BEGIN
	INSERT INTO LOG(tstamp, usr, evt, msg) VALUES (NOW(), USER(), "delete", CONCAT(OLD.first_name, ' ', OLD.last_name, ' ', OLD.phone_nr));
END $$
DELIMITER ;

# -------------------------------------- INSERT DATA ------------------------------------------ #

INSERT INTO `CONTENT_RATING` (`content_rating_id`, `content_rating_description`) VALUES
('PG', 'Public General'),
('NR','Not Rated'),
('PG-13','13+'),
('NC-17','17+');

INSERT INTO `GENRE` (`genre_id`,`genre_name`) VALUES
('Act','Action'),
('Com','Comedy'),
('Thr','Thriller'),
('Hor','Horror'),
('Mys','Mystery'),
('Adv','Adventure'),
('Fan','Fantasy'),
('Dra','Drama'),
('Cri','Crime'),
('His','History'),
('Bio','Biography'),
('Sci','Sci-Fi'),
('Ani','Animation'),
('War','War'),
('Wes','Western');

INSERT INTO `DIRECTOR` (`director_id`,`director_name`) VALUES
('DL','David Leitch'),
('PF','Parker Finn'),
('JCS','Jaume Collet-Serra'),
('RZ','Robert Zemeckis'),
('JW','Jon Watts'),
('AF','Antoine Fuqua'),
('VS','Vaughn Stein'),
('AS','Aaron Schneider'),
('BJH','Bong Joon Ho'),
('TP','Todd Phillips'),
('DM','David Michôd'),
('JK','John Krasinski'),
('CE','Clint Eastwood'),
('NA','Noriyuki Abe'),
('FFC','Francis Ford Coppola'),
('MS','Martin Scorsese'),
('CN','Christopher Nolan'),
('QT','Quentin Tarantino'),
('KA','Kelly Asbury'),
('MG','Mike Gabriel');

INSERT INTO `MOVIE` (`movie_id`,`name`,`director_id`,`release_date`,`length`,`content_rating_id`) VALUES
(1,'Bullet Train','DL','2022-08-05',126,'NC-17'),
(2,'Smile','PF','2022-09-30',115,'NC-17'),
(3,'Black Adam','JCS','2022-10-21',125,'PG-13'),
(4,'Pinocchio','RZ','2022-09-08',105,'PG'),
(5,'Spider-Man: No Way Home','JW','2021-12-13',148,'PG-13'),
(6,'The Guilty','AF','2021-09-24',90,'NC-17'),
(7,'Inheritance','VS','2020-05-22',111,'NR'),
(8,'Greyhound','AS','2020-07-10',91,'PG-13'),
(9,'Parasite','BJH','2019-08-30',132,'PG-13'),
(10,'Joker','TP','2019-09-28',122,'PG-13'),
(11,'The King','DM','2019-10-03',140,'NC-17'),
(12,'A Quiet Place','JK','2018-04-02',90,'NC-17'),
(13,'The Mule','CE','2018-12-14',116,'PG-13'),
(14,'The Seven Deadly Sins: Prisoners of the Sky','NA','2018-08-18',99,'NR'),
(15,'The Godfather','FFC','1972-03-14',175,'NC-17'),
(16,'Goodfellas','MS','1990-09-17',145,'NC-17'),
(17,'Apocalypse Now','FFC','1979-08-15',147,'NC-17'),
(18,'The Dark Knight','CN','2008-08-14',152,'PG-13'),
(19,'Interstellar','CN','2014-10-26',169,'PG-13'),
(20,'Dunkirk','CN','2017-07-19',106,'PG-13'),
(21,'Taxi Driver','MS','1976-02-08',114,'NC-17'),
(22,'Pulp Fiction','QT','1994-09-23',154,'NC-17'),
(23,'Spirit: Stallion of the Cimarron','KA','2002-05-24',83,'PG'),
(24,'Pocahontas','MG','1995-06-15',81,'PG'),
(25,'Django Unchained','QT','2012-12-11',165,'NC-17');

INSERT INTO `MOVIE_GENRE` (`movie_id`, `genre_id`) VALUES
(1,'Act'),
(1,'Com'),
(1,'Thr'),
(2,'Thr'),
(2,'Hor'),
(2,'Mys'),
(3,'Act'),
(3,'Adv'),
(3,'Fan'),
(4,'Adv'),
(4,'Com'),
(4,'Dra'),
(5,'Act'),
(5,'Adv'),
(5,'Fan'),
(6,'Cri'),
(6,'Dra'),
(6,'Thr'),
(7,'Dra'),
(7,'Mys'),
(7,'Thr'),
(8,'Act'),
(8,'Dra'),
(8,'His'),
(9,'Dra'),
(9,'Thr'),
(10,'Cri'),
(10,'Dra'),
(10,'Thr'),
(11,'Bio'),
(11,'Dra'),
(11,'His'),
(12,'Dra'),
(12,'Hor'),
(12,'Sci'),
(13,'Cri'),
(13,'Dra'),
(13,'Thr'),
(14,'Ani'),
(14,'Act'),
(14,'Fan'),
(15,'Cri'),
(15,'Dra'),
(16,'Bio'),
(16,'Cri'),
(16,'Dra'),
(17,'War'),
(17,'Dra'),
(17,'Mys'),
(18,'Act'),
(18,'Cri'),
(18,'Dra'),
(19,'Adv'),
(19,'Dra'),
(19,'Sci'),
(20,'Act'),
(20,'Dra'),
(20,'His'),
(21,'Cri'),
(21,'Dra'),
(22,'Cri'),
(22,'Dra'),
(23,'Ani'),
(23,'Dra'),
(23,'Adv'),
(24,'Ani'),
(24,'Adv'),
(24,'Dra'),
(25,'Dra'),
(25,'Wes');


INSERT INTO `STATE` (`state_id`, `state_name`) VALUES
('CA', 'California'),
('TX', 'Texas'),
('FL', 'Florida'),
('NY', 'New York'),
('PA', 'Pennsylvania'),
('IL', 'Illinois'),
('OH', 'Ohio'),
('GA', 'Georgia');

INSERT INTO `LOCATION` (`location_id`, `state_id`, `street_address`, `zip_code`, `city`) VALUES
(1000, 'CA', '900 Folsom St', '94107', 'San Francisco'),
(1100, 'CA', '1200 S Broadway', '90015', 'Los Angeles'),
(1200, 'CA', '1399 10th St', '95814', 'Sacramento'),
(1300, 'TX', '1601 Leeland St', '77003', 'Houston'),
(1400, 'TX', '901 S Ervay St', '75201', 'Dallas'),
(1500, 'FL', '106 E Church St', '32801', 'Orlando'),
(1600, 'FL', '100 NW 11th St', '33136', 'Miami'),
(1700, 'NY', '170 E 70th St', '10021', 'New York'),
(1800, 'NY', '49-87 Bank St', '10014', 'New York'),
(1900, 'NY', '1224-1282 Union St', '11225', 'New York'),
(2000, 'PA', '2098-2000 Sansom St', '19103', 'Philadelphia'),
(2100, 'PA', '505 Smithfield St', '15222', 'Pittsburgh'),
(2200, 'IL', '1099-1001 W 18th Pl', '60608', 'Chicago'),
(2300, 'OH', '5927 W Capital St', '43215', 'Columbus'),
(2400, 'GA', '103-125 Piedmont Ave SE', '30303', 'Atlanta'),
(2500, 'CA', '3275 Woodstock Drive', '91731', 'El Monte'),
(2600, 'TX', '3030 Candlelight Drive', '77337', 'Tomball'),
(2700, 'FL', '4977 Ridenour Street', '33179', 'Miami'),
(2800, 'NY', '4455 Jarvisville Road', '11801', 'Hicksville'),
(2900,'PA', '2763 Conference Center Way', '17967', 'Ringtown'),
(3000, 'IL', '4370 Vesta Drive', '60148', 'Lombard'),
(3100, 'OH', '2828 Goldie Lane', '45202', 'Cincinnati'),
(3200, 'GA', '2133 Adonais Way', '30303', 'Atlanta'),
(3300, 'CA', '4301 Ocello Street', '92117', 'San Diego'),
(3400, 'TX', '1713 Worthington Drive', '75075', 'Plano'),
(3500, 'FL', '3194 Travis Street', '32960', 'Vero Beach'),
(3600, 'GA', '4732 Oakridge Lane', '31201', 'Macon'),
(3700, 'GA', '4517 Lilac Lane', '31401', 'Savannah'),
(3800, 'GA', '126 Locust Street', '31785', 'Sasser'),
(3900, 'GA', '3573 Pine Garden Lane', '30339', 'Atlanta'),
(4000, 'GA', '972 Clement Street', '30071', 'Norcross'),
(4100, 'TX', '654 Ersel Street', '75225', 'Dallas'),
(4200, 'TX', '3265 Mulberry Street', '77301', 'Conroe'),
(4300, 'OH', '4614 Harley Vincent Drive', '44141', 'Brecksville'),
(4400, 'OH', '2102 College Avenue', '45402', 'Dayton'),
(4500, 'NY', '4700 Jarvisville Road', '11501', 'Mineola'),
(4600, 'NY', '2100 Geneva Street', '11368', 'Corona'),
(4700, 'PA', '766 Carriage Lane', '17815', '766 Carriage Lane'),
(4800, 'FL', '4510 Oakdale Avenue', '33602', 'Tampa'),
(4900, 'TX', '4639 Grey Fox Farm Road', '77478', 'Sugar Land'),
(5000, 'CA', '4083 Davis Avenue', '94520', 'Concord'),
(5100, 'IL', '365 Kembery Drive', '60134', 'Geneva'),
(5200, 'OH', '2290 Sunny Glen Lane', '44115', 'Cleveland'),
(5300, 'GA', '3223 Davis Street', '30901', 'Augusta'),
(5400, 'IL', '1037 Pringle Drive', '60606', 'Chicago'),
(5500, 'CA', '251 Euclid Avenue', '90040', 'City Of Commerce'),
(5600, 'PA', '3799 Quincy Street', '19146', 'Philadelphia'),
(5700, 'CA', '2531 Hillhaven Drive', '90040', 'City Of Commerce'),
(5800, 'TX',  '3783 Short Street', '78759', 'Austin'),
(5900, 'FL',  '4007 Heavens Way', '33610', 'Tampa'),
(6000, 'NY',  '1917 Confederate Drive', '13350', 'Herkimer'),
(6100, 'PA',  '4824 High Meadow Lane', '18640', 'Pittston'),
(6200, 'IL', '2344 Cecil Street', '60605', 'Chicago'),
(6300, 'OH', '4612 Bingamon Road' , '44124', 'Mayfield Heights'),
(6400, 'GA', '4794 Yorkie Lane', '31501', 'Waycross'),
(6500, 'FL', '1511 Grand Avenue', '32809', 'Orlando'),
(6600, 'NY', '517 Bell Street', '10019', 'New York');

INSERT INTO `STORE` (`store_id`, `location_id`, `store_email`) VALUES
('1-CA', 1000, 'general_1-CA@cubesmasher.com'),
('2-CA', 1100, 'general_2-CA@cubesmasher.com'),
('3-CA', 1200, 'general_3-CA@cubesmasher.com'),
('1-TX', 1300, 'general_1-TX@cubesmasher.com'),
('2-TX', 1400, 'general_2-TX@cubesmasher.com'),
('1-FL', 1500, 'general_1-FL@cubesmasher.com'),
('2-FL', 1600, 'general_2-FL@cubesmasher.com'),
('1-NY', 1700, 'general_1-NY@cubesmasher.com'),
('2-NY', 1800, 'general_2-NY@cubesmasher.com'),
('3-NY', 1900, 'general_3-NY@cubesmasher.com'),
('1-PA', 2000, 'general_1-PA@cubesmasher.com'),
('2-PA', 2100, 'general_2-PA@cubesmasher.com'),
('1-IL', 2200, 'general_1-IL@cubesmasher.com'),
('1-OH', 2300, 'general_1-OH@cubesmasher.com'),
('1-GA', 2400, 'general_1-GA@cubesmasher.com');

INSERT INTO EMPLOYEE (employee_id, first_name, last_name, phone_nr, email, date_of_birth, store_id, salary, location_id, manager_id)
VALUES
(1, 'Andre', 'Cunha', '921435073', 'andrertgf3@gmail.com', '1999-05-24', '1-CA', 800, 5500, NULL), 
(2, 'Sonia', 'Mendes', '931435074', 'soniagf3@gmail.com', '1999-06-24', '2-CA', 800, 5600, NULL),
(3, 'Mariana', 'Palhinha', '961435075', 'marianaartgf3@gmail.com','2007-07-24', '3-CA', 800, 5700, NULL), 
(4, 'Francisco', 'Lavinha', '911435076', 'franciscortgf3@gmail.com', '1999-08-24', '1-TX', 800, 5800, NULL),
(5, 'Alexandra', 'Rodrigues', '921435077', 'alexatgf3@gmail.com', '1999-09-24', '2-TX', 800, 5900, NULL),
(6, 'Ines', 'Cruz', '931435078', 'ineziitgf3@gmail.com', '2010-10-24', '1-FL', 800, 6000, 1),
(7, 'Maria', 'Magessi', '961435079', 'maryartgf3@gmail.com', '1999-11-24', '2-FL', 800, 6100, 1),
(8, 'Catarina', 'Figueiredo', '911435072', 'catarinnrtgf3@gmail.com', '1999-12-24', '1-NY', 800, 6100, 2),
(9, 'Carolina', 'Moreira', '921435071', 'carolatgf3@gmail.com', '2002-04-24', '2-NY', 800, 6200, 2),
(10, 'Joao', 'Gonçalves', '932435073', 'joaogtgf3@gmail.com', '1999-03-24', '3-NY', 800, 6300, 2),
(11, 'Otavio', 'Martins', '963435073', 'oitavogf3@gmail.com', '1999-02-24', '1-PA', 800, 6400, 4),
(12, 'Pedro', 'Coelho', '914435073', 'peterctgf3@gmail.com', '1999-01-24', '2-PA', 800, 6500, 1),
(13, 'Fernando', 'Biltes', '925435073', 'nandobrtgf3@gmail.com', '2000-04-24', '1-IL', 800, 6600, 3),
(14, 'Julia', 'Vieira', '936435073', 'julyrtgf3@gmail.com', '1998-04-24', '1-OH', 800, 5400, 3),
(15, 'Julio', 'Matos', '967435073', 'juliomtgf3@gmail.com', '1997-04-24', '1-GA', 800, 4700, 5);


INSERT INTO `CLIENT` (first_name, last_name, phone_nr, email, date_of_birth, location_id)
VALUES
('Sabrina', 'Lavado', '918435073', 'saberrtgf3@gmail.com', '1999-04-24', 2500),
('Xavier', 'Roque', '929435073', 'xaviyytgf3@gmail.com', '2000-04-24', 2600),
('Rodrigo', 'Osorio', '931135073', 'rodassrtgf3@gmail.com', '2002-04-24', 2700),
('Gonçalo', 'Alegria', '961235073', 'goncasaertgf3@gmail.com', '1978-04-24', 2800),
('Martim', 'Bernardes', '911335073', 'martimbertgf3@gmail.com', '1992-04-24', 2900),
('Lourenço', 'Sismeiro', '921835073', 'lourencotgf3@gmail.com', '1989-07-21', 2900),
('Madalena', 'Mendes', '931535073', 'madasmotgf3@gmail.com', '1989-07-28', 3000),
('Vladimir', 'Rochinol', '961635073', 'vladdcotgf3@gmail.com', '1989-07-24', 3000),
('Nuria', 'Costa', '911735073', 'nuriatgf3@gmail.com', '1989-07-20', 3100),
('Rute', 'Marlene', '921935073', 'ruterdaoocotgf3@gmail.com', '1989-07-29', 3200),
('Paulo', 'Sousa', '931145073', 'paulocacotgf3@gmail.com', '1989-05-20', 3200),
('Angelo', 'Vigo', '961125073', 'angelvcotgf3@gmail.com', '1989-03-20', 3300),
('Fatima', 'Lopes', '911115073', 'fatimalotgf3@gmail.com', '1989-01-20', 3400),
('Olivia', 'Palito', '921155073', 'ollypcotgf3@gmail.com', '1989-09-20', 3500),
('Pablo', 'Rimenez', '931165073', 'pablitootgf3@gmail.com', '1989-02-20', 3600),
('Rolando', 'Pereira', '961175073', 'rolazztgf3@gmail.com', '1989-04-20', 3700),
('Beatriz', 'Machado', '911185073', 'beatrixmotgf3@gmail.com', '1989-06-20', 3800),
('Jose', 'Soares', '921195073', 'roseesgf3@gmail.com', '1989-08-20', 3900),
('Diogo', 'Oliveira', '931165173', 'diogoolycotgf3@gmail.com', '1979-11-13', 3900),
('Felix', 'Gayer', '961165273', 'felixarrencotgf3@gmail.com', '2000-11-12', 4000),
('Ana', 'Vasconcelos', '911165373', 'anitvotgf3@gmail.com', '1979-11-11', 4000),
('Margarida', 'Gerardo', '921165473', 'margercotgf3@gmail.com', '2003-11-10', 4100),
('Joaquim', 'Bras', '931165573', 'jocabrastgf3@gmail.com', '1979-11-09', 4200),
('Daniel', 'Kruk', '961165673', 'danikroka@gmail.com', '2002-11-16', 4300),
('Filipe', 'Ponte', '911165773', 'filiponti@gmail.com', '2000-11-17', 4400),
('Henrique', 'Lima', '921165873', 'henrytenrygf3@gmail.com', '2001-11-18', 4500),
('Flor', 'Assunçao', '931165973', 'florassungf3@gmail.com', '1979-11-19', 4600),
('Sebastiao', 'Carvalho', '961165913', 'sebascaargf3@gmail.com', '1979-11-20', 4700),
('Tomas', 'Nunes', '911165923', 'nunecmasf3@gmail.com', '1979-10-14', 4800),
('Joana', 'Monteiro', '921165933', 'jonanamontanatgf3@gmail.com', '1979-12-14', 4900),
('Marta', 'Rocha', '931165943', 'roxmartatgf3@gmail.com', '2004-01-14', 5000),
('Nuno', 'Tavares', '961165953', 'nunotavtgf3@gmail.com', '2005-04-14', 5100),
('Bruna', 'Pinheiro', '911165963', 'bruneirogf3@gmail.com', '2014-06-14', 5200),
('Filipa', 'Brito', '921165973', 'filipabri3@gmail.com', '2010-07-14', 5300),
('Constança', 'Nascimento', '931165983', 'conchanazare@gmail.com', '2007-05-14', 5400);

INSERT INTO `CONDITION` (condition_id, condition_description) VALUES 
(0, 'Unsusable'),
(1, 'Major visible damage'),
(2, 'Minor visible damage'),
(3, 'No visible damage');

INSERT INTO STOCK (movie_id, store_id, stock) VALUES
(1, '1-CA', 7),
(1, '2-CA', 7),
(1, '3-CA', 1),
(1, '1-TX', 5),
(1, '2-TX', 9),
(1, '1-FL', 8),
(1, '2-FL', 7),
(1, '1-NY', 5),
(1, '2-NY', 8),
(1, '3-NY', 6),
(1, '1-PA', 10),
(1, '2-PA', 4),
(1, '1-IL', 9),
(1, '1-OH', 3),
(1, '1-GA', 5),
(2, '1-CA', 3),
(2, '2-CA', 2),
(2, '3-CA', 10),
(2, '1-TX', 5),
(2, '2-TX', 9),
(2, '1-FL', 10),
(2, '2-FL', 3),
(2, '1-NY', 5),
(2, '2-NY', 2),
(2, '3-NY', 2),
(2, '1-PA', 6),
(2, '2-PA', 8),
(2, '1-IL', 9),
(2, '1-OH', 2),
(2, '1-GA', 6),
(3, '1-CA', 7),
(3, '2-CA', 6),
(3, '3-CA', 10),
(3, '1-TX', 4),
(3, '2-TX', 9),
(3, '1-FL', 8),
(3, '2-FL', 8),
(3, '1-NY', 9),
(3, '2-NY', 5),
(3, '3-NY', 1),
(3, '1-PA', 9),
(3, '2-PA', 1),
(3, '1-IL', 2),
(3, '1-OH', 7),
(3, '1-GA', 1),
(4, '1-CA', 10),
(4, '2-CA', 8),
(4, '3-CA', 6),
(4, '1-TX', 4),
(4, '2-TX', 6),
(4, '1-FL', 2),
(4, '2-FL', 4),
(4, '1-NY', 10),
(4, '2-NY', 4),
(4, '3-NY', 4),
(4, '1-PA', 3),
(4, '2-PA', 9),
(4, '1-IL', 8),
(4, '1-OH', 2),
(4, '1-GA', 2),
(5, '1-CA', 6),
(5, '2-CA', 9),
(5, '3-CA', 8),
(5, '1-TX', 2),
(5, '2-TX', 5),
(5, '1-FL', 9),
(5, '2-FL', 5),
(5, '1-NY', 2),
(5, '2-NY', 9),
(5, '3-NY', 6),
(5, '1-PA', 9),
(5, '2-PA', 4),
(5, '1-IL', 10),
(5, '1-OH', 9),
(5, '1-GA', 10),
(6, '1-CA', 5),
(6, '2-CA', 8),
(6, '3-CA', 2),
(6, '1-TX', 10),
(6, '2-TX', 7),
(6, '1-FL', 6),
(6, '2-FL', 10),
(6, '1-NY', 4),
(6, '2-NY', 5),
(6, '3-NY', 3),
(6, '1-PA', 4),
(6, '2-PA', 3),
(6, '1-IL', 1),
(6, '1-OH', 10),
(6, '1-GA', 5),
(7, '1-CA', 8),
(7, '2-CA', 2),
(7, '3-CA', 2),
(7, '1-TX', 3),
(7, '2-TX', 3),
(7, '1-FL', 1),
(7, '2-FL', 2),
(7, '1-NY', 9),
(7, '2-NY', 7),
(7, '3-NY', 9),
(7, '1-PA', 5),
(7, '2-PA', 9),
(7, '1-IL', 4),
(7, '1-OH', 4),
(7, '1-GA', 10),
(8, '1-CA', 7),
(8, '2-CA', 10),
(8, '3-CA', 5),
(8, '1-TX', 8),
(8, '2-TX', 8),
(8, '1-FL', 6),
(8, '2-FL', 2),
(8, '1-NY', 6),
(8, '2-NY', 10),
(8, '3-NY', 2),
(8, '1-PA', 8),
(8, '2-PA', 10),
(8, '1-IL', 6),
(8, '1-OH', 4),
(8, '1-GA', 4),
(9, '1-CA', 1),
(9, '2-CA', 5),
(9, '3-CA', 2),
(9, '1-TX', 4),
(9, '2-TX', 6),
(9, '1-FL', 3),
(9, '2-FL', 6),
(9, '1-NY', 7),
(9, '2-NY', 1),
(9, '3-NY', 2),
(9, '1-PA', 3),
(9, '2-PA', 4),
(9, '1-IL', 1),
(9, '1-OH', 10),
(9, '1-GA', 9),
(10, '1-CA', 10),
(10, '2-CA', 2),
(10, '3-CA', 1),
(10, '1-TX', 2),
(10, '2-TX', 4),
(10, '1-FL', 10),
(10, '2-FL', 10),
(10, '1-NY', 2),
(10, '2-NY', 7),
(10, '3-NY', 2),
(10, '1-PA', 6),
(10, '2-PA', 2),
(10, '1-IL', 1),
(10, '1-OH', 10),
(10, '1-GA', 1),
(11, '1-CA', 4),
(11, '2-CA', 3),
(11, '3-CA', 2),
(11, '1-TX', 8),
(11, '2-TX', 4),
(11, '1-FL', 1),
(11, '2-FL', 1),
(11, '1-NY', 9),
(11, '2-NY', 7),
(11, '3-NY', 10),
(11, '1-PA', 2),
(11, '2-PA', 5),
(11, '1-IL', 2),
(11, '1-OH', 4),
(11, '1-GA', 2),
(12, '1-CA', 5),
(12, '2-CA', 6),
(12, '3-CA', 7),
(12, '1-TX', 3),
(12, '2-TX', 1),
(12, '1-FL', 9),
(12, '2-FL', 8),
(12, '1-NY', 1),
(12, '2-NY', 10),
(12, '3-NY', 2),
(12, '1-PA', 7),
(12, '2-PA', 4),
(12, '1-IL', 5),
(12, '1-OH', 6),
(12, '1-GA', 8),
(13, '1-CA', 10),
(13, '2-CA', 3),
(13, '3-CA', 4),
(13, '1-TX', 1),
(13, '2-TX', 3),
(13, '1-FL', 3),
(13, '2-FL', 6),
(13, '1-NY', 9),
(13, '2-NY', 5),
(13, '3-NY', 2),
(13, '1-PA', 10),
(13, '2-PA', 8),
(13, '1-IL', 3),
(13, '1-OH', 1),
(13, '1-GA', 8),
(14, '1-CA', 7),
(14, '2-CA', 10),
(14, '3-CA', 9),
(14, '1-TX', 5),
(14, '2-TX', 6),
(14, '1-FL', 7),
(14, '2-FL', 5),
(14, '1-NY', 3),
(14, '2-NY', 9),
(14, '3-NY', 1),
(14, '1-PA', 8),
(14, '2-PA', 2),
(14, '1-IL', 6),
(14, '1-OH', 1),
(14, '1-GA', 9),
(15, '1-CA', 5),
(15, '2-CA', 3),
(15, '3-CA', 4),
(15, '1-TX', 8),
(15, '2-TX', 6),
(15, '1-FL', 10),
(15, '2-FL', 5),
(15, '1-NY', 6),
(15, '2-NY', 10),
(15, '3-NY', 10),
(15, '1-PA', 3),
(15, '2-PA', 5),
(15, '1-IL', 7),
(15, '1-OH', 7),
(15, '1-GA', 2),
(16, '1-CA', 1),
(16, '2-CA', 10),
(16, '3-CA', 4),
(16, '1-TX', 6),
(16, '2-TX', 3),
(16, '1-FL', 4),
(16, '2-FL', 4),
(16, '1-NY', 8),
(16, '2-NY', 7),
(16, '3-NY', 10),
(16, '1-PA', 7),
(16, '2-PA', 1),
(16, '1-IL', 7),
(16, '1-OH', 10),
(16, '1-GA', 7),
(17, '1-CA', 1),
(17, '2-CA', 3),
(17, '3-CA', 8),
(17, '1-TX', 2),
(17, '2-TX', 5),
(17, '1-FL', 3),
(17, '2-FL', 8),
(17, '1-NY', 9),
(17, '2-NY', 8),
(17, '3-NY', 9),
(17, '1-PA', 10),
(17, '2-PA', 1),
(17, '1-IL', 1),
(17, '1-OH', 8),
(17, '1-GA', 6),
(18, '1-CA', 5),
(18, '2-CA', 8),
(18, '3-CA', 1),
(18, '1-TX', 7),
(18, '2-TX', 4),
(18, '1-FL', 9),
(18, '2-FL', 2),
(18, '1-NY', 3),
(18, '2-NY', 1),
(18, '3-NY', 7),
(18, '1-PA', 7),
(18, '2-PA', 6),
(18, '1-IL', 1),
(18, '1-OH', 4),
(18, '1-GA', 1),
(19, '1-CA', 1),
(19, '2-CA', 9),
(19, '3-CA', 10),
(19, '1-TX', 2),
(19, '2-TX', 4),
(19, '1-FL', 2),
(19, '2-FL', 10),
(19, '1-NY', 4),
(19, '2-NY', 5),
(19, '3-NY', 5),
(19, '1-PA', 3),
(19, '2-PA', 2),
(19, '1-IL', 8),
(19, '1-OH', 7),
(19, '1-GA', 2),
(20, '1-CA', 1),
(20, '2-CA', 5),
(20, '3-CA', 8),
(20, '1-TX', 2),
(20, '2-TX', 5),
(20, '1-FL', 3),
(20, '2-FL', 9),
(20, '1-NY', 6),
(20, '2-NY', 2),
(20, '3-NY', 3),
(20, '1-PA', 5),
(20, '2-PA', 1),
(20, '1-IL', 1),
(20, '1-OH', 1),
(20, '1-GA', 4),
(21, '1-CA', 5),
(21, '2-CA', 9),
(21, '3-CA', 6),
(21, '1-TX', 6),
(21, '2-TX', 10),
(21, '1-FL', 1),
(21, '2-FL', 10),
(21, '1-NY', 8),
(21, '2-NY', 8),
(21, '3-NY', 7),
(21, '1-PA', 6),
(21, '2-PA', 9),
(21, '1-IL', 3),
(21, '1-OH', 4),
(21, '1-GA', 7),
(22, '1-CA', 10),
(22, '2-CA', 5),
(22, '3-CA', 1),
(22, '1-TX', 3),
(22, '2-TX', 3),
(22, '1-FL', 5),
(22, '2-FL', 6),
(22, '1-NY', 6),
(22, '2-NY', 6),
(22, '3-NY', 2),
(22, '1-PA', 6),
(22, '2-PA', 10),
(22, '1-IL', 1),
(22, '1-OH', 1),
(22, '1-GA', 5),
(23, '1-CA', 3),
(23, '2-CA', 3),
(23, '3-CA', 10),
(23, '1-TX', 5),
(23, '2-TX', 6),
(23, '1-FL', 7),
(23, '2-FL', 9),
(23, '1-NY', 3),
(23, '2-NY', 5),
(23, '3-NY', 2),
(23, '1-PA', 8),
(23, '2-PA', 4),
(23, '1-IL', 1),
(23, '1-OH', 5),
(23, '1-GA', 3),
(24, '1-CA', 9),
(24, '2-CA', 2),
(24, '3-CA', 5),
(24, '1-TX', 7),
(24, '2-TX', 6),
(24, '1-FL', 5),
(24, '2-FL', 7),
(24, '1-NY', 2),
(24, '2-NY', 2),
(24, '3-NY', 9),
(24, '1-PA', 8),
(24, '2-PA', 8),
(24, '1-IL', 6),
(24, '1-OH', 6),
(24, '1-GA', 2),
(25, '1-CA', 8),
(25, '2-CA', 2),
(25, '3-CA', 8),
(25, '1-TX', 7),
(25, '2-TX', 1),
(25, '1-FL', 5),
(25, '2-FL', 6),
(25, '1-NY', 3),
(25, '2-NY', 3),
(25, '3-NY', 10),
(25, '1-PA', 7),
(25, '2-PA', 2),
(25, '1-IL', 2),
(25, '1-OH', 2),
(25, '1-GA', 4);

INSERT INTO COPY (copy_id, movie_id, store_id, condition_id) VALUES
(1, 1, '1-CA', 3),
(2, 1, '1-CA', 1),
(3, 1, '1-CA', 1),
(4, 1, '1-CA', 2),
(5, 1, '1-CA', 1),
(6, 1, '1-CA', 1),
(7, 1, '1-CA', 2),
(8, 1, '2-CA', 3),
(9, 1, '2-CA', 3),
(10, 1, '2-CA', 2),
(11, 1, '2-CA', 2),
(12, 1, '2-CA', 2),
(13, 1, '2-CA', 3),
(14, 1, '2-CA', 3),
(15, 1, '3-CA', 3),
(16, 1, '1-TX', 1),
(17, 1, '1-TX', 2),
(18, 1, '1-TX', 1),
(19, 1, '1-TX', 2),
(20, 1, '1-TX', 1),
(21, 1, '2-TX', 2),
(22, 1, '2-TX', 3),
(23, 1, '2-TX', 1),
(24, 1, '2-TX', 2),
(25, 1, '2-TX', 1),
(26, 1, '2-TX', 2),
(27, 1, '2-TX', 1),
(28, 1, '2-TX', 1),
(29, 1, '2-TX', 3),
(30, 1, '1-FL', 1),
(31, 1, '1-FL', 3),
(32, 1, '1-FL', 2),
(33, 1, '1-FL', 3),
(34, 1, '1-FL', 1),
(35, 1, '1-FL', 1),
(36, 1, '1-FL', 2),
(37, 1, '1-FL', 2),
(38, 1, '2-FL', 2),
(39, 1, '2-FL', 1),
(40, 1, '2-FL', 3),
(41, 1, '2-FL', 1),
(42, 1, '2-FL', 1),
(43, 1, '2-FL', 3),
(44, 1, '2-FL', 1),
(45, 1, '1-NY', 1),
(46, 1, '1-NY', 1),
(47, 1, '1-NY', 2),
(48, 1, '1-NY', 2),
(49, 1, '1-NY', 2),
(50, 1, '2-NY', 3),
(51, 1, '2-NY', 1),
(52, 1, '2-NY', 1),
(53, 1, '2-NY', 3),
(54, 1, '2-NY', 2),
(55, 1, '2-NY', 1),
(56, 1, '2-NY', 3),
(57, 1, '2-NY', 2),
(58, 1, '3-NY', 3),
(59, 1, '3-NY', 3),
(60, 1, '3-NY', 2),
(61, 1, '3-NY', 3),
(62, 1, '3-NY', 2),
(63, 1, '3-NY', 3),
(64, 1, '1-PA', 2),
(65, 1, '1-PA', 2),
(66, 1, '1-PA', 2),
(67, 1, '1-PA', 3),
(68, 1, '1-PA', 3),
(69, 1, '1-PA', 1),
(70, 1, '1-PA', 3),
(71, 1, '1-PA', 3),
(72, 1, '1-PA', 1),
(73, 1, '1-PA', 1),
(74, 1, '2-PA', 2),
(75, 1, '2-PA', 3),
(76, 1, '2-PA', 3),
(77, 1, '2-PA', 2),
(78, 1, '1-IL', 2),
(79, 1, '1-IL', 1),
(80, 1, '1-IL', 3),
(81, 1, '1-IL', 1),
(82, 1, '1-IL', 2),
(83, 1, '1-IL', 3),
(84, 1, '1-IL', 1),
(85, 1, '1-IL', 2),
(86, 1, '1-IL', 3),
(87, 1, '1-OH', 2),
(88, 1, '1-OH', 3),
(89, 1, '1-OH', 3),
(90, 1, '1-GA', 2),
(91, 1, '1-GA', 1),
(92, 1, '1-GA', 1),
(93, 1, '1-GA', 3),
(94, 1, '1-GA', 1),
(1, 2, '1-CA', 1),
(2, 2, '1-CA', 1),
(3, 2, '1-CA', 1),
(4, 2, '2-CA', 1),
(5, 2, '2-CA', 2),
(6, 2, '3-CA', 1),
(7, 2, '3-CA', 2),
(8, 2, '3-CA', 2),
(9, 2, '3-CA', 1),
(10, 2, '3-CA', 1),
(11, 2, '3-CA', 3),
(12, 2, '3-CA', 2),
(13, 2, '3-CA', 2),
(14, 2, '3-CA', 3),
(15, 2, '3-CA', 2),
(16, 2, '1-TX', 3),
(17, 2, '1-TX', 3),
(18, 2, '1-TX', 1),
(19, 2, '1-TX', 3),
(20, 2, '1-TX', 1),
(21, 2, '2-TX', 3),
(22, 2, '2-TX', 3),
(23, 2, '2-TX', 3),
(24, 2, '2-TX', 1),
(25, 2, '2-TX', 3),
(26, 2, '2-TX', 2),
(27, 2, '2-TX', 1),
(28, 2, '2-TX', 2),
(29, 2, '2-TX', 3),
(30, 2, '1-FL', 3),
(31, 2, '1-FL', 2),
(32, 2, '1-FL', 2),
(33, 2, '1-FL', 2),
(34, 2, '1-FL', 3),
(35, 2, '1-FL', 3),
(36, 2, '1-FL', 1),
(37, 2, '1-FL', 1),
(38, 2, '1-FL', 3),
(39, 2, '1-FL', 1),
(40, 2, '2-FL', 3),
(41, 2, '2-FL', 1),
(42, 2, '2-FL', 2),
(43, 2, '1-NY', 3),
(44, 2, '1-NY', 3),
(45, 2, '1-NY', 2),
(46, 2, '1-NY', 2),
(47, 2, '1-NY', 1),
(48, 2, '2-NY', 2),
(49, 2, '2-NY', 2),
(50, 2, '3-NY', 2),
(51, 2, '3-NY', 2),
(52, 2, '1-PA', 2),
(53, 2, '1-PA', 2),
(54, 2, '1-PA', 1),
(55, 2, '1-PA', 1),
(56, 2, '1-PA', 3),
(57, 2, '1-PA', 1),
(58, 2, '2-PA', 1),
(59, 2, '2-PA', 2),
(60, 2, '2-PA', 3),
(61, 2, '2-PA', 2),
(62, 2, '2-PA', 1),
(63, 2, '2-PA', 1),
(64, 2, '2-PA', 2),
(65, 2, '2-PA', 2),
(66, 2, '1-IL', 1),
(67, 2, '1-IL', 2),
(68, 2, '1-IL', 3),
(69, 2, '1-IL', 3),
(70, 2, '1-IL', 1),
(71, 2, '1-IL', 3),
(72, 2, '1-IL', 3),
(73, 2, '1-IL', 1),
(74, 2, '1-IL', 2),
(75, 2, '1-OH', 2),
(76, 2, '1-OH', 1),
(77, 2, '1-GA', 3),
(78, 2, '1-GA', 2),
(79, 2, '1-GA', 2),
(80, 2, '1-GA', 2),
(81, 2, '1-GA', 1),
(82, 2, '1-GA', 1),
(1, 3, '1-CA', 2),
(2, 3, '1-CA', 1),
(3, 3, '1-CA', 1),
(4, 3, '1-CA', 1),
(5, 3, '1-CA', 3),
(6, 3, '1-CA', 3),
(7, 3, '1-CA', 1),
(8, 3, '2-CA', 3),
(9, 3, '2-CA', 2),
(10, 3, '2-CA', 1),
(11, 3, '2-CA', 3),
(12, 3, '2-CA', 3),
(13, 3, '2-CA', 3),
(14, 3, '3-CA', 2),
(15, 3, '3-CA', 1),
(16, 3, '3-CA', 2),
(17, 3, '3-CA', 2),
(18, 3, '3-CA', 1),
(19, 3, '3-CA', 1),
(20, 3, '3-CA', 3),
(21, 3, '3-CA', 3),
(22, 3, '3-CA', 2),
(23, 3, '3-CA', 3),
(24, 3, '1-TX', 3),
(25, 3, '1-TX', 2),
(26, 3, '1-TX', 3),
(27, 3, '1-TX', 1),
(28, 3, '2-TX', 3),
(29, 3, '2-TX', 3),
(30, 3, '2-TX', 3),
(31, 3, '2-TX', 2),
(32, 3, '2-TX', 1),
(33, 3, '2-TX', 2),
(34, 3, '2-TX', 2),
(35, 3, '2-TX', 3),
(36, 3, '2-TX', 3),
(37, 3, '1-FL', 1),
(38, 3, '1-FL', 3),
(39, 3, '1-FL', 1),
(40, 3, '1-FL', 1),
(41, 3, '1-FL', 2),
(42, 3, '1-FL', 2),
(43, 3, '1-FL', 2),
(44, 3, '1-FL', 1),
(45, 3, '2-FL', 2),
(46, 3, '2-FL', 2),
(47, 3, '2-FL', 3),
(48, 3, '2-FL', 1),
(49, 3, '2-FL', 1),
(50, 3, '2-FL', 1),
(51, 3, '2-FL', 2),
(52, 3, '2-FL', 2),
(53, 3, '1-NY', 1),
(54, 3, '1-NY', 3),
(55, 3, '1-NY', 3),
(56, 3, '1-NY', 3),
(57, 3, '1-NY', 3),
(58, 3, '1-NY', 1),
(59, 3, '1-NY', 1),
(60, 3, '1-NY', 1),
(61, 3, '1-NY', 3),
(62, 3, '2-NY', 3),
(63, 3, '2-NY', 3),
(64, 3, '2-NY', 3),
(65, 3, '2-NY', 2),
(66, 3, '2-NY', 3),
(67, 3, '3-NY', 2),
(68, 3, '1-PA', 1),
(69, 3, '1-PA', 1),
(70, 3, '1-PA', 2),
(71, 3, '1-PA', 3),
(72, 3, '1-PA', 2),
(73, 3, '1-PA', 1),
(74, 3, '1-PA', 1),
(75, 3, '1-PA', 2),
(76, 3, '1-PA', 1),
(77, 3, '2-PA', 1),
(78, 3, '1-IL', 2),
(79, 3, '1-IL', 1),
(80, 3, '1-OH', 3),
(81, 3, '1-OH', 1),
(82, 3, '1-OH', 2),
(83, 3, '1-OH', 2),
(84, 3, '1-OH', 3),
(85, 3, '1-OH', 2),
(86, 3, '1-OH', 1),
(87, 3, '1-GA', 2),
(1, 4, '1-CA', 2),
(2, 4, '1-CA', 3),
(3, 4, '1-CA', 2),
(4, 4, '1-CA', 1),
(5, 4, '1-CA', 2),
(6, 4, '1-CA', 1),
(7, 4, '1-CA', 1),
(8, 4, '1-CA', 2),
(9, 4, '1-CA', 3),
(10, 4, '1-CA', 1),
(11, 4, '2-CA', 2),
(12, 4, '2-CA', 2),
(13, 4, '2-CA', 1),
(14, 4, '2-CA', 1),
(15, 4, '2-CA', 1),
(16, 4, '2-CA', 2),
(17, 4, '2-CA', 1),
(18, 4, '2-CA', 3),
(19, 4, '3-CA', 1),
(20, 4, '3-CA', 1),
(21, 4, '3-CA', 1),
(22, 4, '3-CA', 1),
(23, 4, '3-CA', 3),
(24, 4, '3-CA', 3),
(25, 4, '1-TX', 3),
(26, 4, '1-TX', 1),
(27, 4, '1-TX', 3),
(28, 4, '1-TX', 1),
(29, 4, '2-TX', 2),
(30, 4, '2-TX', 2),
(31, 4, '2-TX', 3),
(32, 4, '2-TX', 1),
(33, 4, '2-TX', 3),
(34, 4, '2-TX', 1),
(35, 4, '1-FL', 1),
(36, 4, '1-FL', 1),
(37, 4, '2-FL', 2),
(38, 4, '2-FL', 1),
(39, 4, '2-FL', 2),
(40, 4, '2-FL', 2),
(41, 4, '1-NY', 3),
(42, 4, '1-NY', 2),
(43, 4, '1-NY', 1),
(44, 4, '1-NY', 1),
(45, 4, '1-NY', 1),
(46, 4, '1-NY', 2),
(47, 4, '1-NY', 2),
(48, 4, '1-NY', 2),
(49, 4, '1-NY', 2),
(50, 4, '1-NY', 2),
(51, 4, '2-NY', 3),
(52, 4, '2-NY', 3),
(53, 4, '2-NY', 2),
(54, 4, '2-NY', 1),
(55, 4, '3-NY', 3),
(56, 4, '3-NY', 1),
(57, 4, '3-NY', 1),
(58, 4, '3-NY', 3),
(59, 4, '1-PA', 3),
(60, 4, '1-PA', 2),
(61, 4, '1-PA', 1),
(62, 4, '2-PA', 2),
(63, 4, '2-PA', 1),
(64, 4, '2-PA', 1),
(65, 4, '2-PA', 1),
(66, 4, '2-PA', 2),
(67, 4, '2-PA', 3),
(68, 4, '2-PA', 1),
(69, 4, '2-PA', 1),
(70, 4, '2-PA', 1),
(71, 4, '1-IL', 2),
(72, 4, '1-IL', 2),
(73, 4, '1-IL', 2),
(74, 4, '1-IL', 3),
(75, 4, '1-IL', 1),
(76, 4, '1-IL', 1),
(77, 4, '1-IL', 3),
(78, 4, '1-IL', 1),
(79, 4, '1-OH', 2),
(80, 4, '1-OH', 1),
(81, 4, '1-GA', 3),
(82, 4, '1-GA', 1),
(1, 5, '1-CA', 1),
(2, 5, '1-CA', 2),
(3, 5, '1-CA', 2),
(4, 5, '1-CA', 3),
(5, 5, '1-CA', 2),
(6, 5, '1-CA', 3),
(7, 5, '2-CA', 1),
(8, 5, '2-CA', 3),
(9, 5, '2-CA', 2),
(10, 5, '2-CA', 2),
(11, 5, '2-CA', 3),
(12, 5, '2-CA', 2),
(13, 5, '2-CA', 1),
(14, 5, '2-CA', 1),
(15, 5, '2-CA', 2),
(16, 5, '3-CA', 3),
(17, 5, '3-CA', 2),
(18, 5, '3-CA', 3),
(19, 5, '3-CA', 3),
(20, 5, '3-CA', 1),
(21, 5, '3-CA', 2),
(22, 5, '3-CA', 2),
(23, 5, '3-CA', 1),
(24, 5, '1-TX', 2),
(25, 5, '1-TX', 3),
(26, 5, '2-TX', 2),
(27, 5, '2-TX', 2),
(28, 5, '2-TX', 1),
(29, 5, '2-TX', 2),
(30, 5, '2-TX', 2),
(31, 5, '1-FL', 2),
(32, 5, '1-FL', 1),
(33, 5, '1-FL', 1),
(34, 5, '1-FL', 1),
(35, 5, '1-FL', 2),
(36, 5, '1-FL', 1),
(37, 5, '1-FL', 3),
(38, 5, '1-FL', 3),
(39, 5, '1-FL', 3),
(40, 5, '2-FL', 1),
(41, 5, '2-FL', 3),
(42, 5, '2-FL', 2),
(43, 5, '2-FL', 2),
(44, 5, '2-FL', 1),
(45, 5, '1-NY', 2),
(46, 5, '1-NY', 2),
(47, 5, '2-NY', 1),
(48, 5, '2-NY', 1),
(49, 5, '2-NY', 2),
(50, 5, '2-NY', 2),
(51, 5, '2-NY', 3),
(52, 5, '2-NY', 1),
(53, 5, '2-NY', 2),
(54, 5, '2-NY', 2),
(55, 5, '2-NY', 3),
(56, 5, '3-NY', 3),
(57, 5, '3-NY', 1),
(58, 5, '3-NY', 2),
(59, 5, '3-NY', 1),
(60, 5, '3-NY', 2),
(61, 5, '3-NY', 1),
(62, 5, '1-PA', 3),
(63, 5, '1-PA', 2),
(64, 5, '1-PA', 3),
(65, 5, '1-PA', 2),
(66, 5, '1-PA', 1),
(67, 5, '1-PA', 1),
(68, 5, '1-PA', 2),
(69, 5, '1-PA', 1),
(70, 5, '1-PA', 3),
(71, 5, '2-PA', 2),
(72, 5, '2-PA', 3),
(73, 5, '2-PA', 3),
(74, 5, '2-PA', 1),
(75, 5, '1-IL', 2),
(76, 5, '1-IL', 3),
(77, 5, '1-IL', 2),
(78, 5, '1-IL', 1),
(79, 5, '1-IL', 3),
(80, 5, '1-IL', 2),
(81, 5, '1-IL', 1),
(82, 5, '1-IL', 3),
(83, 5, '1-IL', 2),
(84, 5, '1-IL', 2),
(85, 5, '1-OH', 3),
(86, 5, '1-OH', 1),
(87, 5, '1-OH', 1),
(88, 5, '1-OH', 2),
(89, 5, '1-OH', 3),
(90, 5, '1-OH', 1),
(91, 5, '1-OH', 1),
(92, 5, '1-OH', 2),
(93, 5, '1-OH', 2),
(94, 5, '1-GA', 3),
(95, 5, '1-GA', 3),
(96, 5, '1-GA', 3),
(97, 5, '1-GA', 2),
(98, 5, '1-GA', 2),
(99, 5, '1-GA', 1),
(100, 5, '1-GA', 3),
(101, 5, '1-GA', 2),
(102, 5, '1-GA', 2),
(103, 5, '1-GA', 2),
(1, 6, '1-CA', 3),
(2, 6, '1-CA', 1),
(3, 6, '1-CA', 3),
(4, 6, '1-CA', 1),
(5, 6, '1-CA', 1),
(6, 6, '2-CA', 1),
(7, 6, '2-CA', 2),
(8, 6, '2-CA', 2),
(9, 6, '2-CA', 3),
(10, 6, '2-CA', 2),
(11, 6, '2-CA', 1),
(12, 6, '2-CA', 3),
(13, 6, '2-CA', 1),
(14, 6, '3-CA', 1),
(15, 6, '3-CA', 1),
(16, 6, '1-TX', 2),
(17, 6, '1-TX', 2),
(18, 6, '1-TX', 2),
(19, 6, '1-TX', 3),
(20, 6, '1-TX', 1),
(21, 6, '1-TX', 3),
(22, 6, '1-TX', 3),
(23, 6, '1-TX', 3),
(24, 6, '1-TX', 1),
(25, 6, '1-TX', 3),
(26, 6, '2-TX', 1),
(27, 6, '2-TX', 2),
(28, 6, '2-TX', 3),
(29, 6, '2-TX', 3),
(30, 6, '2-TX', 2),
(31, 6, '2-TX', 3),
(32, 6, '2-TX', 2),
(33, 6, '1-FL', 2),
(34, 6, '1-FL', 2),
(35, 6, '1-FL', 2),
(36, 6, '1-FL', 3),
(37, 6, '1-FL', 3),
(38, 6, '1-FL', 1),
(39, 6, '2-FL', 1),
(40, 6, '2-FL', 1),
(41, 6, '2-FL', 3),
(42, 6, '2-FL', 1),
(43, 6, '2-FL', 2),
(44, 6, '2-FL', 2),
(45, 6, '2-FL', 3),
(46, 6, '2-FL', 2),
(47, 6, '2-FL', 1),
(48, 6, '2-FL', 3),
(49, 6, '1-NY', 3),
(50, 6, '1-NY', 2),
(51, 6, '1-NY', 2),
(52, 6, '1-NY', 3),
(53, 6, '2-NY', 2),
(54, 6, '2-NY', 3),
(55, 6, '2-NY', 2),
(56, 6, '2-NY', 1),
(57, 6, '2-NY', 2),
(58, 6, '3-NY', 2),
(59, 6, '3-NY', 3),
(60, 6, '3-NY', 3),
(61, 6, '1-PA', 2),
(62, 6, '1-PA', 2),
(63, 6, '1-PA', 3),
(64, 6, '1-PA', 1),
(65, 6, '2-PA', 2),
(66, 6, '2-PA', 2),
(67, 6, '2-PA', 1),
(68, 6, '1-IL', 3),
(69, 6, '1-OH', 2),
(70, 6, '1-OH', 1),
(71, 6, '1-OH', 3),
(72, 6, '1-OH', 1),
(73, 6, '1-OH', 1),
(74, 6, '1-OH', 2),
(75, 6, '1-OH', 2),
(76, 6, '1-OH', 2),
(77, 6, '1-OH', 1),
(78, 6, '1-OH', 3),
(79, 6, '1-GA', 1),
(80, 6, '1-GA', 3),
(81, 6, '1-GA', 1),
(82, 6, '1-GA', 3),
(83, 6, '1-GA', 3),
(1, 7, '1-CA', 3),
(2, 7, '1-CA', 2),
(3, 7, '1-CA', 1),
(4, 7, '1-CA', 2),
(5, 7, '1-CA', 1),
(6, 7, '1-CA', 1),
(7, 7, '1-CA', 3),
(8, 7, '1-CA', 1),
(9, 7, '2-CA', 2),
(10, 7, '2-CA', 3),
(11, 7, '3-CA', 3),
(12, 7, '3-CA', 2),
(13, 7, '1-TX', 3),
(14, 7, '1-TX', 1),
(15, 7, '1-TX', 1),
(16, 7, '2-TX', 3),
(17, 7, '2-TX', 2),
(18, 7, '2-TX', 1),
(19, 7, '1-FL', 1),
(20, 7, '2-FL', 2),
(21, 7, '2-FL', 2),
(22, 7, '1-NY', 3),
(23, 7, '1-NY', 2),
(24, 7, '1-NY', 2),
(25, 7, '1-NY', 1),
(26, 7, '1-NY', 2),
(27, 7, '1-NY', 2),
(28, 7, '1-NY', 3),
(29, 7, '1-NY', 3),
(30, 7, '1-NY', 2),
(31, 7, '2-NY', 1),
(32, 7, '2-NY', 2),
(33, 7, '2-NY', 3),
(34, 7, '2-NY', 1),
(35, 7, '2-NY', 3),
(36, 7, '2-NY', 2),
(37, 7, '2-NY', 1),
(38, 7, '3-NY', 1),
(39, 7, '3-NY', 1),
(40, 7, '3-NY', 2),
(41, 7, '3-NY', 2),
(42, 7, '3-NY', 2),
(43, 7, '3-NY', 2),
(44, 7, '3-NY', 2),
(45, 7, '3-NY', 2),
(46, 7, '3-NY', 3),
(47, 7, '1-PA', 1),
(48, 7, '1-PA', 1),
(49, 7, '1-PA', 2),
(50, 7, '1-PA', 1),
(51, 7, '1-PA', 3),
(52, 7, '2-PA', 3),
(53, 7, '2-PA', 1),
(54, 7, '2-PA', 2),
(55, 7, '2-PA', 1),
(56, 7, '2-PA', 1),
(57, 7, '2-PA', 3),
(58, 7, '2-PA', 1),
(59, 7, '2-PA', 1),
(60, 7, '2-PA', 2),
(61, 7, '1-IL', 1),
(62, 7, '1-IL', 3),
(63, 7, '1-IL', 3),
(64, 7, '1-IL', 3),
(65, 7, '1-OH', 1),
(66, 7, '1-OH', 1),
(67, 7, '1-OH', 3),
(68, 7, '1-OH', 2),
(69, 7, '1-GA', 3),
(70, 7, '1-GA', 1),
(71, 7, '1-GA', 3),
(72, 7, '1-GA', 3),
(73, 7, '1-GA', 2),
(74, 7, '1-GA', 2),
(75, 7, '1-GA', 2),
(76, 7, '1-GA', 2),
(77, 7, '1-GA', 1),
(78, 7, '1-GA', 3),
(1, 8, '1-CA', 3),
(2, 8, '1-CA', 3),
(3, 8, '1-CA', 3),
(4, 8, '1-CA', 3),
(5, 8, '1-CA', 3),
(6, 8, '1-CA', 3),
(7, 8, '1-CA', 2),
(8, 8, '2-CA', 3),
(9, 8, '2-CA', 2),
(10, 8, '2-CA', 2),
(11, 8, '2-CA', 2),
(12, 8, '2-CA', 3),
(13, 8, '2-CA', 2),
(14, 8, '2-CA', 1),
(15, 8, '2-CA', 2),
(16, 8, '2-CA', 2),
(17, 8, '2-CA', 1),
(18, 8, '3-CA', 1),
(19, 8, '3-CA', 1),
(20, 8, '3-CA', 1),
(21, 8, '3-CA', 2),
(22, 8, '3-CA', 1),
(23, 8, '1-TX', 2),
(24, 8, '1-TX', 3),
(25, 8, '1-TX', 1),
(26, 8, '1-TX', 1),
(27, 8, '1-TX', 1),
(28, 8, '1-TX', 2),
(29, 8, '1-TX', 3),
(30, 8, '1-TX', 1),
(31, 8, '2-TX', 3),
(32, 8, '2-TX', 2),
(33, 8, '2-TX', 3),
(34, 8, '2-TX', 1),
(35, 8, '2-TX', 2),
(36, 8, '2-TX', 1),
(37, 8, '2-TX', 2),
(38, 8, '2-TX', 3),
(39, 8, '1-FL', 1),
(40, 8, '1-FL', 3),
(41, 8, '1-FL', 1),
(42, 8, '1-FL', 2),
(43, 8, '1-FL', 2),
(44, 8, '1-FL', 3),
(45, 8, '2-FL', 2),
(46, 8, '2-FL', 2),
(47, 8, '1-NY', 2),
(48, 8, '1-NY', 1),
(49, 8, '1-NY', 3),
(50, 8, '1-NY', 1),
(51, 8, '1-NY', 1),
(52, 8, '1-NY', 2),
(53, 8, '2-NY', 1),
(54, 8, '2-NY', 1),
(55, 8, '2-NY', 3),
(56, 8, '2-NY', 2),
(57, 8, '2-NY', 1),
(58, 8, '2-NY', 1),
(59, 8, '2-NY', 2),
(60, 8, '2-NY', 3),
(61, 8, '2-NY', 3),
(62, 8, '2-NY', 3),
(63, 8, '3-NY', 2),
(64, 8, '3-NY', 2),
(65, 8, '1-PA', 3),
(66, 8, '1-PA', 2),
(67, 8, '1-PA', 2),
(68, 8, '1-PA', 2),
(69, 8, '1-PA', 2),
(70, 8, '1-PA', 3),
(71, 8, '1-PA', 1),
(72, 8, '1-PA', 1),
(73, 8, '2-PA', 2),
(74, 8, '2-PA', 3),
(75, 8, '2-PA', 1),
(76, 8, '2-PA', 1),
(77, 8, '2-PA', 2),
(78, 8, '2-PA', 2),
(79, 8, '2-PA', 3),
(80, 8, '2-PA', 2),
(81, 8, '2-PA', 1),
(82, 8, '2-PA', 2),
(83, 8, '1-IL', 2),
(84, 8, '1-IL', 2),
(85, 8, '1-IL', 2),
(86, 8, '1-IL', 1),
(87, 8, '1-IL', 1),
(88, 8, '1-IL', 1),
(89, 8, '1-OH', 1),
(90, 8, '1-OH', 1),
(91, 8, '1-OH', 1),
(92, 8, '1-OH', 2),
(93, 8, '1-GA', 1),
(94, 8, '1-GA', 2),
(95, 8, '1-GA', 3),
(96, 8, '1-GA', 1),
(1, 9, '1-CA', 2),
(2, 9, '2-CA', 3),
(3, 9, '2-CA', 2),
(4, 9, '2-CA', 1),
(5, 9, '2-CA', 1),
(6, 9, '2-CA', 1),
(7, 9, '3-CA', 2),
(8, 9, '3-CA', 1),
(9, 9, '1-TX', 1),
(10, 9, '1-TX', 2),
(11, 9, '1-TX', 2),
(12, 9, '1-TX', 2),
(13, 9, '2-TX', 2),
(14, 9, '2-TX', 1),
(15, 9, '2-TX', 3),
(16, 9, '2-TX', 2),
(17, 9, '2-TX', 3),
(18, 9, '2-TX', 3),
(19, 9, '1-FL', 1),
(20, 9, '1-FL', 3),
(21, 9, '1-FL', 2),
(22, 9, '2-FL', 2),
(23, 9, '2-FL', 3),
(24, 9, '2-FL', 3),
(25, 9, '2-FL', 2),
(26, 9, '2-FL', 3),
(27, 9, '2-FL', 3),
(28, 9, '1-NY', 2),
(29, 9, '1-NY', 2),
(30, 9, '1-NY', 1),
(31, 9, '1-NY', 1),
(32, 9, '1-NY', 1),
(33, 9, '1-NY', 3),
(34, 9, '1-NY', 3),
(35, 9, '2-NY', 1),
(36, 9, '3-NY', 1),
(37, 9, '3-NY', 3),
(38, 9, '1-PA', 2),
(39, 9, '1-PA', 1),
(40, 9, '1-PA', 1),
(41, 9, '2-PA', 2),
(42, 9, '2-PA', 3),
(43, 9, '2-PA', 3),
(44, 9, '2-PA', 1),
(45, 9, '1-IL', 3),
(46, 9, '1-OH', 3),
(47, 9, '1-OH', 3),
(48, 9, '1-OH', 2),
(49, 9, '1-OH', 1),
(50, 9, '1-OH', 1),
(51, 9, '1-OH', 2),
(52, 9, '1-OH', 3),
(53, 9, '1-OH', 2),
(54, 9, '1-OH', 1),
(55, 9, '1-OH', 3),
(56, 9, '1-GA', 3),
(57, 9, '1-GA', 2),
(58, 9, '1-GA', 1),
(59, 9, '1-GA', 3),
(60, 9, '1-GA', 3),
(61, 9, '1-GA', 3),
(62, 9, '1-GA', 3),
(63, 9, '1-GA', 3),
(64, 9, '1-GA', 2),
(1, 10, '1-CA', 1),
(2, 10, '1-CA', 3),
(3, 10, '1-CA', 1),
(4, 10, '1-CA', 1),
(5, 10, '1-CA', 3),
(6, 10, '1-CA', 2),
(7, 10, '1-CA', 3),
(8, 10, '1-CA', 2),
(9, 10, '1-CA', 1),
(10, 10, '1-CA', 2),
(11, 10, '2-CA', 3),
(12, 10, '2-CA', 2),
(13, 10, '3-CA', 2),
(14, 10, '1-TX', 3),
(15, 10, '1-TX', 1),
(16, 10, '2-TX', 1),
(17, 10, '2-TX', 1),
(18, 10, '2-TX', 3),
(19, 10, '2-TX', 3),
(20, 10, '1-FL', 2),
(21, 10, '1-FL', 2),
(22, 10, '1-FL', 3),
(23, 10, '1-FL', 3),
(24, 10, '1-FL', 1),
(25, 10, '1-FL', 1),
(26, 10, '1-FL', 2),
(27, 10, '1-FL', 1),
(28, 10, '1-FL', 1),
(29, 10, '1-FL', 3),
(30, 10, '2-FL', 1),
(31, 10, '2-FL', 1),
(32, 10, '2-FL', 1),
(33, 10, '2-FL', 2),
(34, 10, '2-FL', 3),
(35, 10, '2-FL', 3),
(36, 10, '2-FL', 1),
(37, 10, '2-FL', 1),
(38, 10, '2-FL', 3),
(39, 10, '2-FL', 1),
(40, 10, '1-NY', 1),
(41, 10, '1-NY', 2),
(42, 10, '2-NY', 2),
(43, 10, '2-NY', 3),
(44, 10, '2-NY', 3),
(45, 10, '2-NY', 1),
(46, 10, '2-NY', 3),
(47, 10, '2-NY', 2),
(48, 10, '2-NY', 1),
(49, 10, '3-NY', 3),
(50, 10, '3-NY', 1),
(51, 10, '1-PA', 3),
(52, 10, '1-PA', 3),
(53, 10, '1-PA', 2),
(54, 10, '1-PA', 2),
(55, 10, '1-PA', 2),
(56, 10, '1-PA', 2),
(57, 10, '2-PA', 1),
(58, 10, '2-PA', 1),
(59, 10, '1-IL', 3),
(60, 10, '1-OH', 3),
(61, 10, '1-OH', 1),
(62, 10, '1-OH', 3),
(63, 10, '1-OH', 2),
(64, 10, '1-OH', 3),
(65, 10, '1-OH', 2),
(66, 10, '1-OH', 3),
(67, 10, '1-OH', 2),
(68, 10, '1-OH', 3),
(69, 10, '1-OH', 1),
(70, 10, '1-GA', 2),
(1, 11, '1-CA', 1),
(2, 11, '1-CA', 3),
(3, 11, '1-CA', 2),
(4, 11, '1-CA', 3),
(5, 11, '2-CA', 1),
(6, 11, '2-CA', 2),
(7, 11, '2-CA', 2),
(8, 11, '3-CA', 2),
(9, 11, '3-CA', 1),
(10, 11, '1-TX', 1),
(11, 11, '1-TX', 1),
(12, 11, '1-TX', 2),
(13, 11, '1-TX', 3),
(14, 11, '1-TX', 3),
(15, 11, '1-TX', 1),
(16, 11, '1-TX', 2),
(17, 11, '1-TX', 2),
(18, 11, '2-TX', 3),
(19, 11, '2-TX', 3),
(20, 11, '2-TX', 3),
(21, 11, '2-TX', 3),
(22, 11, '1-FL', 1),
(23, 11, '2-FL', 2),
(24, 11, '1-NY', 2),
(25, 11, '1-NY', 3),
(26, 11, '1-NY', 1),
(27, 11, '1-NY', 2),
(28, 11, '1-NY', 1),
(29, 11, '1-NY', 2),
(30, 11, '1-NY', 3),
(31, 11, '1-NY', 3),
(32, 11, '1-NY', 1),
(33, 11, '2-NY', 3),
(34, 11, '2-NY', 3),
(35, 11, '2-NY', 1),
(36, 11, '2-NY', 2),
(37, 11, '2-NY', 1),
(38, 11, '2-NY', 2),
(39, 11, '2-NY', 3),
(40, 11, '3-NY', 1),
(41, 11, '3-NY', 1),
(42, 11, '3-NY', 1),
(43, 11, '3-NY', 1),
(44, 11, '3-NY', 1),
(45, 11, '3-NY', 1),
(46, 11, '3-NY', 3),
(47, 11, '3-NY', 2),
(48, 11, '3-NY', 1),
(49, 11, '3-NY', 1),
(50, 11, '1-PA', 2),
(51, 11, '1-PA', 3),
(52, 11, '2-PA', 2),
(53, 11, '2-PA', 1),
(54, 11, '2-PA', 1),
(55, 11, '2-PA', 2),
(56, 11, '2-PA', 2),
(57, 11, '1-IL', 1),
(58, 11, '1-IL', 2),
(59, 11, '1-OH', 2),
(60, 11, '1-OH', 1),
(61, 11, '1-OH', 3),
(62, 11, '1-OH', 2),
(63, 11, '1-GA', 3),
(64, 11, '1-GA', 3),
(1, 12, '1-CA', 2),
(2, 12, '1-CA', 2),
(3, 12, '1-CA', 1),
(4, 12, '1-CA', 2),
(5, 12, '1-CA', 2),
(6, 12, '2-CA', 3),
(7, 12, '2-CA', 3),
(8, 12, '2-CA', 3),
(9, 12, '2-CA', 3),
(10, 12, '2-CA', 3),
(11, 12, '2-CA', 2),
(12, 12, '3-CA', 1),
(13, 12, '3-CA', 3),
(14, 12, '3-CA', 1),
(15, 12, '3-CA', 2),
(16, 12, '3-CA', 2),
(17, 12, '3-CA', 1),
(18, 12, '3-CA', 1),
(19, 12, '1-TX', 3),
(20, 12, '1-TX', 1),
(21, 12, '1-TX', 3),
(22, 12, '2-TX', 3),
(23, 12, '1-FL', 3),
(24, 12, '1-FL', 3),
(25, 12, '1-FL', 3),
(26, 12, '1-FL', 1),
(27, 12, '1-FL', 1),
(28, 12, '1-FL', 2),
(29, 12, '1-FL', 1),
(30, 12, '1-FL', 1),
(31, 12, '1-FL', 1),
(32, 12, '2-FL', 1),
(33, 12, '2-FL', 1),
(34, 12, '2-FL', 3),
(35, 12, '2-FL', 3),
(36, 12, '2-FL', 3),
(37, 12, '2-FL', 1),
(38, 12, '2-FL', 3),
(39, 12, '2-FL', 1),
(40, 12, '1-NY', 2),
(41, 12, '2-NY', 3),
(42, 12, '2-NY', 1),
(43, 12, '2-NY', 3),
(44, 12, '2-NY', 3),
(45, 12, '2-NY', 2),
(46, 12, '2-NY', 3),
(47, 12, '2-NY', 1),
(48, 12, '2-NY', 3),
(49, 12, '2-NY', 3),
(50, 12, '2-NY', 1),
(51, 12, '3-NY', 2),
(52, 12, '3-NY', 2),
(53, 12, '1-PA', 3),
(54, 12, '1-PA', 3),
(55, 12, '1-PA', 2),
(56, 12, '1-PA', 1),
(57, 12, '1-PA', 3),
(58, 12, '1-PA', 1),
(59, 12, '1-PA', 2),
(60, 12, '2-PA', 1),
(61, 12, '2-PA', 2),
(62, 12, '2-PA', 2),
(63, 12, '2-PA', 3),
(64, 12, '1-IL', 1),
(65, 12, '1-IL', 2),
(66, 12, '1-IL', 1),
(67, 12, '1-IL', 3),
(68, 12, '1-IL', 2),
(69, 12, '1-OH', 1),
(70, 12, '1-OH', 3),
(71, 12, '1-OH', 2),
(72, 12, '1-OH', 2),
(73, 12, '1-OH', 2),
(74, 12, '1-OH', 2),
(75, 12, '1-GA', 2),
(76, 12, '1-GA', 1),
(77, 12, '1-GA', 2),
(78, 12, '1-GA', 3),
(79, 12, '1-GA', 2),
(80, 12, '1-GA', 3),
(81, 12, '1-GA', 2),
(82, 12, '1-GA', 1),
(1, 13, '1-CA', 3),
(2, 13, '1-CA', 3),
(3, 13, '1-CA', 3),
(4, 13, '1-CA', 2),
(5, 13, '1-CA', 3),
(6, 13, '1-CA', 1),
(7, 13, '1-CA', 2),
(8, 13, '1-CA', 2),
(9, 13, '1-CA', 3),
(10, 13, '1-CA', 1),
(11, 13, '2-CA', 2),
(12, 13, '2-CA', 2),
(13, 13, '2-CA', 2),
(14, 13, '3-CA', 1),
(15, 13, '3-CA', 1),
(16, 13, '3-CA', 2),
(17, 13, '3-CA', 3),
(18, 13, '1-TX', 1),
(19, 13, '2-TX', 2),
(20, 13, '2-TX', 3),
(21, 13, '2-TX', 3),
(22, 13, '1-FL', 3),
(23, 13, '1-FL', 3),
(24, 13, '1-FL', 2),
(25, 13, '2-FL', 3),
(26, 13, '2-FL', 1),
(27, 13, '2-FL', 3),
(28, 13, '2-FL', 3),
(29, 13, '2-FL', 2),
(30, 13, '2-FL', 2),
(31, 13, '1-NY', 2),
(32, 13, '1-NY', 1),
(33, 13, '1-NY', 1),
(34, 13, '1-NY', 3),
(35, 13, '1-NY', 2),
(36, 13, '1-NY', 1),
(37, 13, '1-NY', 3),
(38, 13, '1-NY', 3),
(39, 13, '1-NY', 3),
(40, 13, '2-NY', 3),
(41, 13, '2-NY', 3),
(42, 13, '2-NY', 2),
(43, 13, '2-NY', 1),
(44, 13, '2-NY', 1),
(45, 13, '3-NY', 2),
(46, 13, '3-NY', 3),
(47, 13, '1-PA', 1),
(48, 13, '1-PA', 3),
(49, 13, '1-PA', 1),
(50, 13, '1-PA', 3),
(51, 13, '1-PA', 1),
(52, 13, '1-PA', 2),
(53, 13, '1-PA', 2),
(54, 13, '1-PA', 2),
(55, 13, '1-PA', 3),
(56, 13, '1-PA', 2),
(57, 13, '2-PA', 2),
(58, 13, '2-PA', 2),
(59, 13, '2-PA', 2),
(60, 13, '2-PA', 3),
(61, 13, '2-PA', 2),
(62, 13, '2-PA', 1),
(63, 13, '2-PA', 1),
(64, 13, '2-PA', 1),
(65, 13, '1-IL', 3),
(66, 13, '1-IL', 1),
(67, 13, '1-IL', 2),
(68, 13, '1-OH', 1),
(69, 13, '1-GA', 2),
(70, 13, '1-GA', 1),
(71, 13, '1-GA', 3),
(72, 13, '1-GA', 2),
(73, 13, '1-GA', 3),
(74, 13, '1-GA', 3),
(75, 13, '1-GA', 2),
(76, 13, '1-GA', 3),
(1, 14, '1-CA', 3),
(2, 14, '1-CA', 1),
(3, 14, '1-CA', 1),
(4, 14, '1-CA', 3),
(5, 14, '1-CA', 2),
(6, 14, '1-CA', 2),
(7, 14, '1-CA', 1),
(8, 14, '2-CA', 3),
(9, 14, '2-CA', 1),
(10, 14, '2-CA', 1),
(11, 14, '2-CA', 3),
(12, 14, '2-CA', 3),
(13, 14, '2-CA', 1),
(14, 14, '2-CA', 3),
(15, 14, '2-CA', 1),
(16, 14, '2-CA', 3),
(17, 14, '2-CA', 3),
(18, 14, '3-CA', 3),
(19, 14, '3-CA', 3),
(20, 14, '3-CA', 2),
(21, 14, '3-CA', 2),
(22, 14, '3-CA', 2),
(23, 14, '3-CA', 2),
(24, 14, '3-CA', 2),
(25, 14, '3-CA', 1),
(26, 14, '3-CA', 2),
(27, 14, '1-TX', 3),
(28, 14, '1-TX', 2),
(29, 14, '1-TX', 2),
(30, 14, '1-TX', 3),
(31, 14, '1-TX', 3),
(32, 14, '2-TX', 3),
(33, 14, '2-TX', 2),
(34, 14, '2-TX', 2),
(35, 14, '2-TX', 1),
(36, 14, '2-TX', 3),
(37, 14, '2-TX', 2),
(38, 14, '1-FL', 1),
(39, 14, '1-FL', 1),
(40, 14, '1-FL', 3),
(41, 14, '1-FL', 1),
(42, 14, '1-FL', 3),
(43, 14, '1-FL', 3),
(44, 14, '1-FL', 3),
(45, 14, '2-FL', 2),
(46, 14, '2-FL', 2),
(47, 14, '2-FL', 2),
(48, 14, '2-FL', 1),
(49, 14, '2-FL', 3),
(50, 14, '1-NY', 2),
(51, 14, '1-NY', 3),
(52, 14, '1-NY', 3),
(53, 14, '2-NY', 1),
(54, 14, '2-NY', 1),
(55, 14, '2-NY', 2),
(56, 14, '2-NY', 3),
(57, 14, '2-NY', 1),
(58, 14, '2-NY', 3),
(59, 14, '2-NY', 1),
(60, 14, '2-NY', 3),
(61, 14, '2-NY', 2),
(62, 14, '3-NY', 3),
(63, 14, '1-PA', 3),
(64, 14, '1-PA', 2),
(65, 14, '1-PA', 1),
(66, 14, '1-PA', 3),
(67, 14, '1-PA', 3),
(68, 14, '1-PA', 1),
(69, 14, '1-PA', 3),
(70, 14, '1-PA', 1),
(71, 14, '2-PA', 2),
(72, 14, '2-PA', 1),
(73, 14, '1-IL', 2),
(74, 14, '1-IL', 1),
(75, 14, '1-IL', 3),
(76, 14, '1-IL', 2),
(77, 14, '1-IL', 1),
(78, 14, '1-IL', 3),
(79, 14, '1-OH', 3),
(80, 14, '1-GA', 2),
(81, 14, '1-GA', 3),
(82, 14, '1-GA', 3),
(83, 14, '1-GA', 1),
(84, 14, '1-GA', 1),
(85, 14, '1-GA', 1),
(86, 14, '1-GA', 2),
(87, 14, '1-GA', 1),
(88, 14, '1-GA', 2),
(1, 15, '1-CA', 3),
(2, 15, '1-CA', 2),
(3, 15, '1-CA', 2),
(4, 15, '1-CA', 2),
(5, 15, '1-CA', 2),
(6, 15, '2-CA', 2),
(7, 15, '2-CA', 3),
(8, 15, '2-CA', 2),
(9, 15, '3-CA', 1),
(10, 15, '3-CA', 2),
(11, 15, '3-CA', 1),
(12, 15, '3-CA', 2),
(13, 15, '1-TX', 1),
(14, 15, '1-TX', 2),
(15, 15, '1-TX', 1),
(16, 15, '1-TX', 2),
(17, 15, '1-TX', 2),
(18, 15, '1-TX', 2),
(19, 15, '1-TX', 3),
(20, 15, '1-TX', 3),
(21, 15, '2-TX', 3),
(22, 15, '2-TX', 2),
(23, 15, '2-TX', 3),
(24, 15, '2-TX', 1),
(25, 15, '2-TX', 3),
(26, 15, '2-TX', 2),
(27, 15, '1-FL', 2),
(28, 15, '1-FL', 3),
(29, 15, '1-FL', 1),
(30, 15, '1-FL', 3),
(31, 15, '1-FL', 3),
(32, 15, '1-FL', 2),
(33, 15, '1-FL', 2),
(34, 15, '1-FL', 1),
(35, 15, '1-FL', 2),
(36, 15, '1-FL', 2),
(37, 15, '2-FL', 3),
(38, 15, '2-FL', 1),
(39, 15, '2-FL', 1),
(40, 15, '2-FL', 1),
(41, 15, '2-FL', 3),
(42, 15, '1-NY', 2),
(43, 15, '1-NY', 2),
(44, 15, '1-NY', 1),
(45, 15, '1-NY', 1),
(46, 15, '1-NY', 1),
(47, 15, '1-NY', 3),
(48, 15, '2-NY', 1),
(49, 15, '2-NY', 3),
(50, 15, '2-NY', 3),
(51, 15, '2-NY', 2),
(52, 15, '2-NY', 1),
(53, 15, '2-NY', 2),
(54, 15, '2-NY', 1),
(55, 15, '2-NY', 2),
(56, 15, '2-NY', 2),
(57, 15, '2-NY', 1),
(58, 15, '3-NY', 3),
(59, 15, '3-NY', 2),
(60, 15, '3-NY', 2),
(61, 15, '3-NY', 3),
(62, 15, '3-NY', 1),
(63, 15, '3-NY', 3),
(64, 15, '3-NY', 1),
(65, 15, '3-NY', 2),
(66, 15, '3-NY', 2),
(67, 15, '3-NY', 3),
(68, 15, '1-PA', 1),
(69, 15, '1-PA', 1),
(70, 15, '1-PA', 1),
(71, 15, '2-PA', 1),
(72, 15, '2-PA', 2),
(73, 15, '2-PA', 3),
(74, 15, '2-PA', 3),
(75, 15, '2-PA', 3),
(76, 15, '1-IL', 3),
(77, 15, '1-IL', 1),
(78, 15, '1-IL', 3),
(79, 15, '1-IL', 3),
(80, 15, '1-IL', 1),
(81, 15, '1-IL', 3),
(82, 15, '1-IL', 3),
(83, 15, '1-OH', 3),
(84, 15, '1-OH', 3),
(85, 15, '1-OH', 3),
(86, 15, '1-OH', 2),
(87, 15, '1-OH', 1),
(88, 15, '1-OH', 2),
(89, 15, '1-OH', 3),
(90, 15, '1-GA', 1),
(91, 15, '1-GA', 1),
(1, 16, '1-CA', 3),
(2, 16, '2-CA', 1),
(3, 16, '2-CA', 2),
(4, 16, '2-CA', 1),
(5, 16, '2-CA', 2),
(6, 16, '2-CA', 2),
(7, 16, '2-CA', 3),
(8, 16, '2-CA', 3),
(9, 16, '2-CA', 2),
(10, 16, '2-CA', 2),
(11, 16, '2-CA', 3),
(12, 16, '3-CA', 2),
(13, 16, '3-CA', 1),
(14, 16, '3-CA', 2),
(15, 16, '3-CA', 3),
(16, 16, '1-TX', 1),
(17, 16, '1-TX', 1),
(18, 16, '1-TX', 3),
(19, 16, '1-TX', 3),
(20, 16, '1-TX', 1),
(21, 16, '1-TX', 3),
(22, 16, '2-TX', 3),
(23, 16, '2-TX', 1),
(24, 16, '2-TX', 2),
(25, 16, '1-FL', 1),
(26, 16, '1-FL', 1),
(27, 16, '1-FL', 3),
(28, 16, '1-FL', 2),
(29, 16, '2-FL', 3),
(30, 16, '2-FL', 1),
(31, 16, '2-FL', 2),
(32, 16, '2-FL', 3),
(33, 16, '1-NY', 1),
(34, 16, '1-NY', 3),
(35, 16, '1-NY', 2),
(36, 16, '1-NY', 3),
(37, 16, '1-NY', 1),
(38, 16, '1-NY', 2),
(39, 16, '1-NY', 3),
(40, 16, '1-NY', 1),
(41, 16, '2-NY', 3),
(42, 16, '2-NY', 1),
(43, 16, '2-NY', 3),
(44, 16, '2-NY', 2),
(45, 16, '2-NY', 1),
(46, 16, '2-NY', 1),
(47, 16, '2-NY', 1),
(48, 16, '3-NY', 2),
(49, 16, '3-NY', 3),
(50, 16, '3-NY', 2),
(51, 16, '3-NY', 3),
(52, 16, '3-NY', 2),
(53, 16, '3-NY', 2),
(54, 16, '3-NY', 2),
(55, 16, '3-NY', 3),
(56, 16, '3-NY', 2),
(57, 16, '3-NY', 3),
(58, 16, '1-PA', 1),
(59, 16, '1-PA', 1),
(60, 16, '1-PA', 2),
(61, 16, '1-PA', 1),
(62, 16, '1-PA', 1),
(63, 16, '1-PA', 3),
(64, 16, '1-PA', 1),
(65, 16, '2-PA', 1),
(66, 16, '1-IL', 2),
(67, 16, '1-IL', 3),
(68, 16, '1-IL', 1),
(69, 16, '1-IL', 1),
(70, 16, '1-IL', 2),
(71, 16, '1-IL', 3),
(72, 16, '1-IL', 1),
(73, 16, '1-OH', 3),
(74, 16, '1-OH', 2),
(75, 16, '1-OH', 2),
(76, 16, '1-OH', 1),
(77, 16, '1-OH', 3),
(78, 16, '1-OH', 3),
(79, 16, '1-OH', 1),
(80, 16, '1-OH', 2),
(81, 16, '1-OH', 1),
(82, 16, '1-OH', 2),
(83, 16, '1-GA', 1),
(84, 16, '1-GA', 2),
(85, 16, '1-GA', 2),
(86, 16, '1-GA', 3),
(87, 16, '1-GA', 3),
(88, 16, '1-GA', 2),
(89, 16, '1-GA', 3),
(1, 17, '1-CA', 2),
(2, 17, '2-CA', 3),
(3, 17, '2-CA', 2),
(4, 17, '2-CA', 2),
(5, 17, '3-CA', 1),
(6, 17, '3-CA', 1),
(7, 17, '3-CA', 2),
(8, 17, '3-CA', 2),
(9, 17, '3-CA', 1),
(10, 17, '3-CA', 2),
(11, 17, '3-CA', 1),
(12, 17, '3-CA', 2),
(13, 17, '1-TX', 1),
(14, 17, '1-TX', 1),
(15, 17, '2-TX', 1),
(16, 17, '2-TX', 2),
(17, 17, '2-TX', 1),
(18, 17, '2-TX', 1),
(19, 17, '2-TX', 2),
(20, 17, '1-FL', 3),
(21, 17, '1-FL', 3),
(22, 17, '1-FL', 3),
(23, 17, '2-FL', 1),
(24, 17, '2-FL', 2),
(25, 17, '2-FL', 2),
(26, 17, '2-FL', 3),
(27, 17, '2-FL', 3),
(28, 17, '2-FL', 3),
(29, 17, '2-FL', 2),
(30, 17, '2-FL', 2),
(31, 17, '1-NY', 1),
(32, 17, '1-NY', 1),
(33, 17, '1-NY', 3),
(34, 17, '1-NY', 2),
(35, 17, '1-NY', 2),
(36, 17, '1-NY', 1),
(37, 17, '1-NY', 3),
(38, 17, '1-NY', 3),
(39, 17, '1-NY', 1),
(40, 17, '2-NY', 1),
(41, 17, '2-NY', 2),
(42, 17, '2-NY', 2),
(43, 17, '2-NY', 1),
(44, 17, '2-NY', 2),
(45, 17, '2-NY', 1),
(46, 17, '2-NY', 1),
(47, 17, '2-NY', 3),
(48, 17, '3-NY', 3),
(49, 17, '3-NY', 2),
(50, 17, '3-NY', 1),
(51, 17, '3-NY', 1),
(52, 17, '3-NY', 2),
(53, 17, '3-NY', 2),
(54, 17, '3-NY', 1),
(55, 17, '3-NY', 3),
(56, 17, '3-NY', 3),
(57, 17, '1-PA', 1),
(58, 17, '1-PA', 1),
(59, 17, '1-PA', 1),
(60, 17, '1-PA', 1),
(61, 17, '1-PA', 3),
(62, 17, '1-PA', 3),
(63, 17, '1-PA', 1),
(64, 17, '1-PA', 3),
(65, 17, '1-PA', 2),
(66, 17, '1-PA', 1),
(67, 17, '2-PA', 2),
(68, 17, '1-IL', 3),
(69, 17, '1-OH', 3),
(70, 17, '1-OH', 2),
(71, 17, '1-OH', 1),
(72, 17, '1-OH', 1),
(73, 17, '1-OH', 1),
(74, 17, '1-OH', 3),
(75, 17, '1-OH', 2),
(76, 17, '1-OH', 2),
(77, 17, '1-GA', 1),
(78, 17, '1-GA', 1),
(79, 17, '1-GA', 2),
(80, 17, '1-GA', 1),
(81, 17, '1-GA', 1),
(82, 17, '1-GA', 2),
(1, 18, '1-CA', 2),
(2, 18, '1-CA', 2),
(3, 18, '1-CA', 3),
(4, 18, '1-CA', 1),
(5, 18, '1-CA', 2),
(6, 18, '2-CA', 3),
(7, 18, '2-CA', 1),
(8, 18, '2-CA', 1),
(9, 18, '2-CA', 3),
(10, 18, '2-CA', 1),
(11, 18, '2-CA', 3),
(12, 18, '2-CA', 2),
(13, 18, '2-CA', 3),
(14, 18, '3-CA', 1),
(15, 18, '1-TX', 1),
(16, 18, '1-TX', 1),
(17, 18, '1-TX', 1),
(18, 18, '1-TX', 2),
(19, 18, '1-TX', 3),
(20, 18, '1-TX', 1),
(21, 18, '1-TX', 1),
(22, 18, '2-TX', 1),
(23, 18, '2-TX', 1),
(24, 18, '2-TX', 3),
(25, 18, '2-TX', 3),
(26, 18, '1-FL', 1),
(27, 18, '1-FL', 1),
(28, 18, '1-FL', 3),
(29, 18, '1-FL', 2),
(30, 18, '1-FL', 1),
(31, 18, '1-FL', 2),
(32, 18, '1-FL', 2),
(33, 18, '1-FL', 3),
(34, 18, '1-FL', 3),
(35, 18, '2-FL', 2),
(36, 18, '2-FL', 3),
(37, 18, '1-NY', 1),
(38, 18, '1-NY', 1),
(39, 18, '1-NY', 2),
(40, 18, '2-NY', 3),
(41, 18, '3-NY', 1),
(42, 18, '3-NY', 3),
(43, 18, '3-NY', 2),
(44, 18, '3-NY', 1),
(45, 18, '3-NY', 1),
(46, 18, '3-NY', 2),
(47, 18, '3-NY', 3),
(48, 18, '1-PA', 3),
(49, 18, '1-PA', 2),
(50, 18, '1-PA', 1),
(51, 18, '1-PA', 2),
(52, 18, '1-PA', 2),
(53, 18, '1-PA', 1),
(54, 18, '1-PA', 2),
(55, 18, '2-PA', 2),
(56, 18, '2-PA', 1),
(57, 18, '2-PA', 2),
(58, 18, '2-PA', 1),
(59, 18, '2-PA', 3),
(60, 18, '2-PA', 2),
(61, 18, '1-IL', 2),
(62, 18, '1-OH', 3),
(63, 18, '1-OH', 1),
(64, 18, '1-OH', 2),
(65, 18, '1-OH', 2),
(66, 18, '1-GA', 3),
(1, 19, '1-CA', 2),
(2, 19, '2-CA', 3),
(3, 19, '2-CA', 1),
(4, 19, '2-CA', 3),
(5, 19, '2-CA', 3),
(6, 19, '2-CA', 2),
(7, 19, '2-CA', 1),
(8, 19, '2-CA', 2),
(9, 19, '2-CA', 1),
(10, 19, '2-CA', 3),
(11, 19, '3-CA', 2),
(12, 19, '3-CA', 2),
(13, 19, '3-CA', 3),
(14, 19, '3-CA', 1),
(15, 19, '3-CA', 3),
(16, 19, '3-CA', 1),
(17, 19, '3-CA', 1),
(18, 19, '3-CA', 3),
(19, 19, '3-CA', 2),
(20, 19, '3-CA', 1),
(21, 19, '1-TX', 2),
(22, 19, '1-TX', 3),
(23, 19, '2-TX', 2),
(24, 19, '2-TX', 2),
(25, 19, '2-TX', 1),
(26, 19, '2-TX', 3),
(27, 19, '1-FL', 2),
(28, 19, '1-FL', 3),
(29, 19, '2-FL', 2),
(30, 19, '2-FL', 1),
(31, 19, '2-FL', 1),
(32, 19, '2-FL', 2),
(33, 19, '2-FL', 2),
(34, 19, '2-FL', 2),
(35, 19, '2-FL', 1),
(36, 19, '2-FL', 3),
(37, 19, '2-FL', 2),
(38, 19, '2-FL', 3),
(39, 19, '1-NY', 1),
(40, 19, '1-NY', 2),
(41, 19, '1-NY', 2),
(42, 19, '1-NY', 1),
(43, 19, '2-NY', 3),
(44, 19, '2-NY', 2),
(45, 19, '2-NY', 2),
(46, 19, '2-NY', 3),
(47, 19, '2-NY', 3),
(48, 19, '3-NY', 1),
(49, 19, '3-NY', 1),
(50, 19, '3-NY', 2),
(51, 19, '3-NY', 1),
(52, 19, '3-NY', 3),
(53, 19, '1-PA', 3),
(54, 19, '1-PA', 2),
(55, 19, '1-PA', 2),
(56, 19, '2-PA', 2),
(57, 19, '2-PA', 3),
(58, 19, '1-IL', 1),
(59, 19, '1-IL', 2),
(60, 19, '1-IL', 3),
(61, 19, '1-IL', 2),
(62, 19, '1-IL', 1),
(63, 19, '1-IL', 3),
(64, 19, '1-IL', 2),
(65, 19, '1-IL', 2),
(66, 19, '1-OH', 2),
(67, 19, '1-OH', 3),
(68, 19, '1-OH', 1),
(69, 19, '1-OH', 2),
(70, 19, '1-OH', 1),
(71, 19, '1-OH', 1),
(72, 19, '1-OH', 1),
(73, 19, '1-GA', 3),
(74, 19, '1-GA', 2),
(1, 20, '1-CA', 1),
(2, 20, '2-CA', 1),
(3, 20, '2-CA', 2),
(4, 20, '2-CA', 3),
(5, 20, '2-CA', 2),
(6, 20, '2-CA', 2),
(7, 20, '3-CA', 1),
(8, 20, '3-CA', 3),
(9, 20, '3-CA', 3),
(10, 20, '3-CA', 3),
(11, 20, '3-CA', 3),
(12, 20, '3-CA', 1),
(13, 20, '3-CA', 2),
(14, 20, '3-CA', 3),
(15, 20, '1-TX', 3),
(16, 20, '1-TX', 3),
(17, 20, '2-TX', 1),
(18, 20, '2-TX', 1),
(19, 20, '2-TX', 1),
(20, 20, '2-TX', 1),
(21, 20, '2-TX', 1),
(22, 20, '1-FL', 1),
(23, 20, '1-FL', 1),
(24, 20, '1-FL', 3),
(25, 20, '2-FL', 1),
(26, 20, '2-FL', 2),
(27, 20, '2-FL', 2),
(28, 20, '2-FL', 3),
(29, 20, '2-FL', 3),
(30, 20, '2-FL', 2),
(31, 20, '2-FL', 3),
(32, 20, '2-FL', 2),
(33, 20, '2-FL', 3),
(34, 20, '1-NY', 1),
(35, 20, '1-NY', 2),
(36, 20, '1-NY', 2),
(37, 20, '1-NY', 1),
(38, 20, '1-NY', 2),
(39, 20, '1-NY', 3),
(40, 20, '2-NY', 3),
(41, 20, '2-NY', 2),
(42, 20, '3-NY', 3),
(43, 20, '3-NY', 3),
(44, 20, '3-NY', 1),
(45, 20, '1-PA', 2),
(46, 20, '1-PA', 3),
(47, 20, '1-PA', 3),
(48, 20, '1-PA', 3),
(49, 20, '1-PA', 2),
(50, 20, '2-PA', 1),
(51, 20, '1-IL', 2),
(52, 20, '1-OH', 2),
(53, 20, '1-GA', 2),
(54, 20, '1-GA', 2),
(55, 20, '1-GA', 3),
(56, 20, '1-GA', 2),
(1, 21, '1-CA', 2),
(2, 21, '1-CA', 2),
(3, 21, '1-CA', 1),
(4, 21, '1-CA', 3),
(5, 21, '1-CA', 1),
(6, 21, '2-CA', 1),
(7, 21, '2-CA', 1),
(8, 21, '2-CA', 3),
(9, 21, '2-CA', 3),
(10, 21, '2-CA', 3),
(11, 21, '2-CA', 3),
(12, 21, '2-CA', 3),
(13, 21, '2-CA', 1),
(14, 21, '2-CA', 3),
(15, 21, '3-CA', 3),
(16, 21, '3-CA', 3),
(17, 21, '3-CA', 1),
(18, 21, '3-CA', 3),
(19, 21, '3-CA', 3),
(20, 21, '3-CA', 3),
(21, 21, '1-TX', 3),
(22, 21, '1-TX', 1),
(23, 21, '1-TX', 2),
(24, 21, '1-TX', 3),
(25, 21, '1-TX', 3),
(26, 21, '1-TX', 3),
(27, 21, '2-TX', 1),
(28, 21, '2-TX', 2),
(29, 21, '2-TX', 1),
(30, 21, '2-TX', 1),
(31, 21, '2-TX', 1),
(32, 21, '2-TX', 1),
(33, 21, '2-TX', 2),
(34, 21, '2-TX', 3),
(35, 21, '2-TX', 2),
(36, 21, '2-TX', 2),
(37, 21, '1-FL', 1),
(38, 21, '2-FL', 3),
(39, 21, '2-FL', 2),
(40, 21, '2-FL', 2),
(41, 21, '2-FL', 3),
(42, 21, '2-FL', 3),
(43, 21, '2-FL', 2),
(44, 21, '2-FL', 3),
(45, 21, '2-FL', 2),
(46, 21, '2-FL', 1),
(47, 21, '2-FL', 1),
(48, 21, '1-NY', 3),
(49, 21, '1-NY', 3),
(50, 21, '1-NY', 1),
(51, 21, '1-NY', 3),
(52, 21, '1-NY', 1),
(53, 21, '1-NY', 1),
(54, 21, '1-NY', 3),
(55, 21, '1-NY', 1),
(56, 21, '2-NY', 3),
(57, 21, '2-NY', 2),
(58, 21, '2-NY', 3),
(59, 21, '2-NY', 3),
(60, 21, '2-NY', 1),
(61, 21, '2-NY', 2),
(62, 21, '2-NY', 3),
(63, 21, '2-NY', 3),
(64, 21, '3-NY', 2),
(65, 21, '3-NY', 2),
(66, 21, '3-NY', 1),
(67, 21, '3-NY', 3),
(68, 21, '3-NY', 1),
(69, 21, '3-NY', 2),
(70, 21, '3-NY', 1),
(71, 21, '1-PA', 2),
(72, 21, '1-PA', 3),
(73, 21, '1-PA', 1),
(74, 21, '1-PA', 2),
(75, 21, '1-PA', 1),
(76, 21, '1-PA', 3),
(77, 21, '2-PA', 3),
(78, 21, '2-PA', 2),
(79, 21, '2-PA', 2),
(80, 21, '2-PA', 1),
(81, 21, '2-PA', 3),
(82, 21, '2-PA', 2),
(83, 21, '2-PA', 1),
(84, 21, '2-PA', 2),
(85, 21, '2-PA', 3),
(86, 21, '1-IL', 1),
(87, 21, '1-IL', 2),
(88, 21, '1-IL', 3),
(89, 21, '1-OH', 2),
(90, 21, '1-OH', 3),
(91, 21, '1-OH', 3),
(92, 21, '1-OH', 2),
(93, 21, '1-GA', 2),
(94, 21, '1-GA', 2),
(95, 21, '1-GA', 1),
(96, 21, '1-GA', 1),
(97, 21, '1-GA', 3),
(98, 21, '1-GA', 2),
(99, 21, '1-GA', 1),
(1, 22, '1-CA', 2),
(2, 22, '1-CA', 3),
(3, 22, '1-CA', 1),
(4, 22, '1-CA', 2),
(5, 22, '1-CA', 1),
(6, 22, '1-CA', 1),
(7, 22, '1-CA', 2),
(8, 22, '1-CA', 2),
(9, 22, '1-CA', 3),
(10, 22, '1-CA', 2),
(11, 22, '2-CA', 3),
(12, 22, '2-CA', 1),
(13, 22, '2-CA', 2),
(14, 22, '2-CA', 2),
(15, 22, '2-CA', 1),
(16, 22, '3-CA', 1),
(17, 22, '1-TX', 2),
(18, 22, '1-TX', 1),
(19, 22, '1-TX', 2),
(20, 22, '2-TX', 1),
(21, 22, '2-TX', 1),
(22, 22, '2-TX', 3),
(23, 22, '1-FL', 1),
(24, 22, '1-FL', 3),
(25, 22, '1-FL', 1),
(26, 22, '1-FL', 3),
(27, 22, '1-FL', 3),
(28, 22, '2-FL', 1),
(29, 22, '2-FL', 1),
(30, 22, '2-FL', 1),
(31, 22, '2-FL', 2),
(32, 22, '2-FL', 3),
(33, 22, '2-FL', 3),
(34, 22, '1-NY', 3),
(35, 22, '1-NY', 2),
(36, 22, '1-NY', 3),
(37, 22, '1-NY', 3),
(38, 22, '1-NY', 1),
(39, 22, '1-NY', 2),
(40, 22, '2-NY', 3),
(41, 22, '2-NY', 2),
(42, 22, '2-NY', 2),
(43, 22, '2-NY', 1),
(44, 22, '2-NY', 3),
(45, 22, '2-NY', 1),
(46, 22, '3-NY', 1),
(47, 22, '3-NY', 1),
(48, 22, '1-PA', 2),
(49, 22, '1-PA', 2),
(50, 22, '1-PA', 2),
(51, 22, '1-PA', 1),
(52, 22, '1-PA', 1),
(53, 22, '1-PA', 2),
(54, 22, '2-PA', 2),
(55, 22, '2-PA', 3),
(56, 22, '2-PA', 2),
(57, 22, '2-PA', 1),
(58, 22, '2-PA', 1),
(59, 22, '2-PA', 2),
(60, 22, '2-PA', 3),
(61, 22, '2-PA', 2),
(62, 22, '2-PA', 1),
(63, 22, '2-PA', 3),
(64, 22, '1-IL', 2),
(65, 22, '1-OH', 2),
(66, 22, '1-GA', 1),
(67, 22, '1-GA', 1),
(68, 22, '1-GA', 2),
(69, 22, '1-GA', 1),
(70, 22, '1-GA', 3),
(1, 23, '1-CA', 2),
(2, 23, '1-CA', 3),
(3, 23, '1-CA', 2),
(4, 23, '2-CA', 2),
(5, 23, '2-CA', 2),
(6, 23, '2-CA', 3),
(7, 23, '3-CA', 1),
(8, 23, '3-CA', 1),
(9, 23, '3-CA', 2),
(10, 23, '3-CA', 2),
(11, 23, '3-CA', 3),
(12, 23, '3-CA', 2),
(13, 23, '3-CA', 1),
(14, 23, '3-CA', 3),
(15, 23, '3-CA', 3),
(16, 23, '3-CA', 2),
(17, 23, '1-TX', 3),
(18, 23, '1-TX', 2),
(19, 23, '1-TX', 2),
(20, 23, '1-TX', 2),
(21, 23, '1-TX', 2),
(22, 23, '2-TX', 2),
(23, 23, '2-TX', 3),
(24, 23, '2-TX', 2),
(25, 23, '2-TX', 1),
(26, 23, '2-TX', 2),
(27, 23, '2-TX', 2),
(28, 23, '1-FL', 1),
(29, 23, '1-FL', 2),
(30, 23, '1-FL', 1),
(31, 23, '1-FL', 2),
(32, 23, '1-FL', 1),
(33, 23, '1-FL', 3),
(34, 23, '1-FL', 1),
(35, 23, '2-FL', 2),
(36, 23, '2-FL', 2),
(37, 23, '2-FL', 1),
(38, 23, '2-FL', 1),
(39, 23, '2-FL', 3),
(40, 23, '2-FL', 2),
(41, 23, '2-FL', 2),
(42, 23, '2-FL', 2),
(43, 23, '2-FL', 3),
(44, 23, '1-NY', 2),
(45, 23, '1-NY', 3),
(46, 23, '1-NY', 3),
(47, 23, '2-NY', 1),
(48, 23, '2-NY', 3),
(49, 23, '2-NY', 2),
(50, 23, '2-NY', 3),
(51, 23, '2-NY', 2),
(52, 23, '3-NY', 2),
(53, 23, '3-NY', 1),
(54, 23, '1-PA', 2),
(55, 23, '1-PA', 3),
(56, 23, '1-PA', 3),
(57, 23, '1-PA', 1),
(58, 23, '1-PA', 1),
(59, 23, '1-PA', 2),
(60, 23, '1-PA', 2),
(61, 23, '1-PA', 2),
(62, 23, '2-PA', 1),
(63, 23, '2-PA', 2),
(64, 23, '2-PA', 1),
(65, 23, '2-PA', 3),
(66, 23, '1-IL', 1),
(67, 23, '1-OH', 2),
(68, 23, '1-OH', 1),
(69, 23, '1-OH', 2),
(70, 23, '1-OH', 1),
(71, 23, '1-OH', 3),
(72, 23, '1-GA', 2),
(73, 23, '1-GA', 1),
(74, 23, '1-GA', 1),
(1, 24, '1-CA', 1),
(2, 24, '1-CA', 3),
(3, 24, '1-CA', 2),
(4, 24, '1-CA', 1),
(5, 24, '1-CA', 1),
(6, 24, '1-CA', 1),
(7, 24, '1-CA', 1),
(8, 24, '1-CA', 2),
(9, 24, '1-CA', 3),
(10, 24, '2-CA', 1),
(11, 24, '2-CA', 1),
(12, 24, '3-CA', 1),
(13, 24, '3-CA', 3),
(14, 24, '3-CA', 3),
(15, 24, '3-CA', 1),
(16, 24, '3-CA', 1),
(17, 24, '1-TX', 3),
(18, 24, '1-TX', 2),
(19, 24, '1-TX', 1),
(20, 24, '1-TX', 1),
(21, 24, '1-TX', 3),
(22, 24, '1-TX', 3),
(23, 24, '1-TX', 2),
(24, 24, '2-TX', 1),
(25, 24, '2-TX', 3),
(26, 24, '2-TX', 1),
(27, 24, '2-TX', 1),
(28, 24, '2-TX', 1),
(29, 24, '2-TX', 2),
(30, 24, '1-FL', 2),
(31, 24, '1-FL', 2),
(32, 24, '1-FL', 1),
(33, 24, '1-FL', 2),
(34, 24, '1-FL', 1),
(35, 24, '2-FL', 2),
(36, 24, '2-FL', 1),
(37, 24, '2-FL', 3),
(38, 24, '2-FL', 2),
(39, 24, '2-FL', 1),
(40, 24, '2-FL', 3),
(41, 24, '2-FL', 2),
(42, 24, '1-NY', 3),
(43, 24, '1-NY', 2),
(44, 24, '2-NY', 2),
(45, 24, '2-NY', 3),
(46, 24, '3-NY', 2),
(47, 24, '3-NY', 3),
(48, 24, '3-NY', 1),
(49, 24, '3-NY', 3),
(50, 24, '3-NY', 3),
(51, 24, '3-NY', 1),
(52, 24, '3-NY', 2),
(53, 24, '3-NY', 1),
(54, 24, '3-NY', 3),
(55, 24, '1-PA', 1),
(56, 24, '1-PA', 2),
(57, 24, '1-PA', 1),
(58, 24, '1-PA', 3),
(59, 24, '1-PA', 1),
(60, 24, '1-PA', 3),
(61, 24, '1-PA', 3),
(62, 24, '1-PA', 1),
(63, 24, '2-PA', 2),
(64, 24, '2-PA', 1),
(65, 24, '2-PA', 3),
(66, 24, '2-PA', 3),
(67, 24, '2-PA', 2),
(68, 24, '2-PA', 1),
(69, 24, '2-PA', 2),
(70, 24, '2-PA', 3),
(71, 24, '1-IL', 3),
(72, 24, '1-IL', 1),
(73, 24, '1-IL', 3),
(74, 24, '1-IL', 1),
(75, 24, '1-IL', 3),
(76, 24, '1-IL', 2),
(77, 24, '1-OH', 1),
(78, 24, '1-OH', 3),
(79, 24, '1-OH', 2),
(80, 24, '1-OH', 2),
(81, 24, '1-OH', 1),
(82, 24, '1-OH', 2),
(83, 24, '1-GA', 3),
(84, 24, '1-GA', 2),
(1, 25, '1-CA', 1),
(2, 25, '1-CA', 2),
(3, 25, '1-CA', 2),
(4, 25, '1-CA', 2),
(5, 25, '1-CA', 1),
(6, 25, '1-CA', 3),
(7, 25, '1-CA', 3),
(8, 25, '1-CA', 2),
(9, 25, '2-CA', 1),
(10, 25, '2-CA', 2),
(11, 25, '3-CA', 1),
(12, 25, '3-CA', 2),
(13, 25, '3-CA', 2),
(14, 25, '3-CA', 2),
(15, 25, '3-CA', 1),
(16, 25, '3-CA', 2),
(17, 25, '3-CA', 3),
(18, 25, '3-CA', 1),
(19, 25, '1-TX', 3),
(20, 25, '1-TX', 2),
(21, 25, '1-TX', 2),
(22, 25, '1-TX', 1),
(23, 25, '1-TX', 2),
(24, 25, '1-TX', 1),
(25, 25, '1-TX', 2),
(26, 25, '2-TX', 2),
(27, 25, '1-FL', 2),
(28, 25, '1-FL', 1),
(29, 25, '1-FL', 1),
(30, 25, '1-FL', 2),
(31, 25, '1-FL', 2),
(32, 25, '2-FL', 2),
(33, 25, '2-FL', 3),
(34, 25, '2-FL', 2),
(35, 25, '2-FL', 3),
(36, 25, '2-FL', 1),
(37, 25, '2-FL', 3),
(38, 25, '1-NY', 3),
(39, 25, '1-NY', 1),
(40, 25, '1-NY', 1),
(41, 25, '2-NY', 2),
(42, 25, '2-NY', 3),
(43, 25, '2-NY', 3),
(44, 25, '3-NY', 3),
(45, 25, '3-NY', 1),
(46, 25, '3-NY', 1),
(47, 25, '3-NY', 1),
(48, 25, '3-NY', 2),
(49, 25, '3-NY', 1),
(50, 25, '3-NY', 2),
(51, 25, '3-NY', 3),
(52, 25, '3-NY', 1),
(53, 25, '3-NY', 2),
(54, 25, '1-PA', 2),
(55, 25, '1-PA', 3),
(56, 25, '1-PA', 1),
(57, 25, '1-PA', 2),
(58, 25, '1-PA', 2),
(59, 25, '1-PA', 1),
(60, 25, '1-PA', 1),
(61, 25, '2-PA', 2),
(62, 25, '2-PA', 1),
(63, 25, '1-IL', 2),
(64, 25, '1-IL', 3),
(65, 25, '1-OH', 3),
(66, 25, '1-OH', 1),
(67, 25, '1-GA', 3),
(68, 25, '1-GA', 2),
(69, 25, '1-GA', 1),
(70, 25, '1-GA', 3);

INSERT INTO RENTAL (rental_id, employee_id, client_id, rental_date) VALUES
(1, 15, 19, '2020-01-04'),
(2, 12, 30, '2020-01-08'),
(3, 10, 14, '2020-01-12'),
(4, 7, 23, '2020-01-16'),
(5, 11, 25, '2020-01-20'),
(6, 10, 27, '2020-01-24'),
(7, 15, 13, '2020-01-28'),
(8, 10, 9, '2020-02-01'),
(9, 4, 13, '2020-02-05'),
(10, 8, 2, '2020-02-09'),
(11, 4, 22, '2020-02-13'),
(12, 15, 6, '2020-02-17'),
(13, 14, 3, '2020-02-21'),
(14, 9, 15, '2020-02-25'),
(15, 4, 10, '2020-02-29'),
(16, 1, 14, '2020-03-04'),
(17, 3, 13, '2020-03-08'),
(18, 8, 15, '2020-03-12'),
(19, 11, 23, '2020-03-16'),
(20, 4, 4, '2020-03-20'),
(21, 11, 13, '2020-03-24'),
(22, 14, 1, '2020-03-28'),
(23, 13, 30, '2020-04-01'),
(24, 7, 10, '2020-04-05'),
(25, 11, 9, '2020-04-09'),
(26, 5, 19, '2020-04-13'),
(27, 11, 15, '2020-04-17'),
(28, 8, 13, '2020-04-21'),
(29, 4, 12, '2020-04-25'),
(30, 6, 28, '2020-04-29'),
(31, 14, 29, '2020-05-03'),
(32, 12, 28, '2020-05-07'),
(33, 7, 6, '2020-05-11'),
(34, 11, 29, '2020-05-15'),
(35, 14, 30, '2020-05-19'),
(36, 2, 17, '2020-05-23'),
(37, 4, 3, '2020-05-27'),
(38, 2, 7, '2020-05-31'),
(39, 3, 30, '2020-06-04'),
(40, 15, 13, '2020-06-08'),
(41, 8, 10, '2020-06-12'),
(42, 9, 27, '2020-06-16'),
(43, 15, 26, '2020-06-20'),
(44, 12, 25, '2020-06-24'),
(45, 1, 2, '2020-06-28'),
(46, 4, 6, '2020-07-02'),
(47, 14, 23, '2020-07-06'),
(48, 10, 27, '2020-07-10'),
(49, 14, 26, '2020-07-14'),
(50, 7, 9, '2020-07-18'),
(51, 4, 17, '2020-07-22'),
(52, 1, 24, '2020-07-26'),
(53, 11, 21, '2020-07-30'),
(54, 9, 24, '2020-08-03'),
(55, 15, 24, '2020-08-07'),
(56, 5, 24, '2020-08-11'),
(57, 9, 30, '2020-08-15'),
(58, 2, 3, '2020-08-19'),
(59, 10, 15, '2020-08-23'),
(60, 8, 5, '2020-08-27'),
(61, 1, 21, '2020-08-31'),
(62, 7, 11, '2020-09-04'),
(63, 13, 10, '2020-09-08'),
(64, 5, 13, '2020-09-12'),
(65, 12, 12, '2020-09-16'),
(66, 13, 28, '2020-09-20'),
(67, 4, 16, '2020-09-24'),
(68, 14, 14, '2020-09-28'),
(69, 10, 18, '2020-10-02'),
(70, 9, 4, '2020-10-06'),
(71, 3, 28, '2020-10-10'),
(72, 5, 26, '2020-10-14'),
(73, 10, 9, '2020-10-18'),
(74, 5, 7, '2020-10-22'),
(75, 14, 27, '2020-10-26'),
(76, 7, 6, '2020-10-30'),
(77, 12, 8, '2020-11-03'),
(78, 15, 8, '2020-11-07'),
(79, 4, 29, '2020-11-11'),
(80, 10, 27, '2020-11-15'),
(81, 15, 7, '2020-11-19'),
(82, 1, 27, '2020-11-23'),
(83, 6, 22, '2020-11-27'),
(84, 10, 27, '2020-12-01'),
(85, 8, 17, '2020-12-05'),
(86, 9, 19, '2020-12-09'),
(87, 7, 3, '2020-12-13'),
(88, 7, 17, '2020-12-17'),
(89, 14, 3, '2020-12-21'),
(90, 2, 24, '2020-12-25'),
(91, 10, 24, '2020-12-29'),
(92, 15, 8, '2021-01-02'),
(93, 3, 2, '2021-01-06'),
(94, 3, 28, '2021-01-10'),
(95, 1, 21, '2021-01-14'),
(96, 12, 29, '2021-01-18'),
(97, 4, 15, '2021-01-22'),
(98, 11, 16, '2021-01-26'),
(99, 5, 1, '2021-01-30'),
(100, 2, 17, '2021-02-03'),
(101, 5, 5, '2021-02-07'),
(102, 10, 25, '2021-02-11'),
(103, 11, 12, '2021-02-15'),
(104, 12, 15, '2021-02-19'),
(105, 9, 15, '2021-02-23'),
(106, 1, 22, '2021-02-27'),
(107, 9, 7, '2021-03-03'),
(108, 1, 9, '2021-03-07'),
(109, 15, 16, '2021-03-11'),
(110, 14, 21, '2021-03-15'),
(111, 11, 10, '2021-03-19'),
(112, 5, 15, '2021-03-23'),
(113, 3, 15, '2021-03-27'),
(114, 2, 30, '2021-03-31'),
(115, 9, 2, '2021-04-04'),
(116, 13, 18, '2021-04-08'),
(117, 2, 5, '2021-04-12'),
(118, 10, 5, '2021-04-16'),
(119, 9, 22, '2021-04-20'),
(120, 14, 16, '2021-04-24'),
(121, 3, 3, '2021-04-28'),
(122, 1, 13, '2021-05-02'),
(123, 14, 18, '2021-05-06'),
(124, 4, 21, '2021-05-10'),
(125, 2, 24, '2021-05-14'),
(126, 14, 29, '2021-05-18'),
(127, 4, 22, '2021-05-22'),
(128, 12, 7, '2021-05-26'),
(129, 4, 16, '2021-05-30'),
(130, 4, 16, '2021-06-03'),
(131, 12, 23, '2021-06-07'),
(132, 8, 21, '2021-06-11'),
(133, 3, 28, '2021-06-15'),
(134, 12, 5, '2021-06-19'),
(135, 6, 16, '2021-06-23'),
(136, 14, 19, '2021-06-27'),
(137, 4, 17, '2021-07-01'),
(138, 14, 29, '2021-07-05'),
(139, 3, 25, '2021-07-09'),
(140, 9, 3, '2021-07-13'),
(141, 13, 15, '2021-07-17'),
(142, 1, 24, '2021-07-21'),
(143, 11, 16, '2021-07-25'),
(144, 6, 5, '2021-07-29'),
(145, 14, 5, '2021-08-02'),
(146, 13, 6, '2021-08-06'),
(147, 6, 22, '2021-08-10'),
(148, 2, 9, '2021-08-14'),
(149, 1, 12, '2021-08-18'),
(150, 13, 25, '2021-08-22'),
(151, 3, 18, '2021-08-26'),
(152, 5, 13, '2021-08-30'),
(153, 9, 29, '2021-09-03'),
(154, 6, 6, '2021-09-07'),
(155, 8, 30, '2021-09-11'),
(156, 7, 12, '2021-09-15'),
(157, 9, 29, '2021-09-19'),
(158, 7, 19, '2021-09-23'),
(159, 2, 11, '2021-09-27'),
(160, 8, 9, '2021-10-01'),
(161, 3, 3, '2021-10-05'),
(162, 4, 24, '2021-10-09'),
(163, 7, 17, '2021-10-13'),
(164, 12, 13, '2021-10-17'),
(165, 1, 25, '2021-10-21'),
(166, 14, 17, '2021-10-25'),
(167, 11, 19, '2021-10-29'),
(168, 5, 6, '2021-11-02'),
(169, 14, 2, '2021-11-06'),
(170, 6, 5, '2021-11-10'),
(171, 9, 1, '2021-11-14'),
(172, 5, 16, '2021-11-18'),
(173, 13, 17, '2021-11-22'),
(174, 4, 23, '2021-11-26'),
(175, 15, 24, '2021-11-30'),
(176, 9, 8, '2021-12-04'),
(177, 5, 1, '2021-12-08'),
(178, 1, 8, '2021-12-12'),
(179, 7, 14, '2021-12-16'),
(180, 5, 16, '2021-12-20'),
(181, 4, 11, '2021-12-24'),
(182, 6, 6, '2021-12-28'),
(183, 13, 17, '2022-01-01'),
(184, 8, 3, '2022-01-05'),
(185, 8, 23, '2022-01-09'),
(186, 2, 1, '2022-01-13'),
(187, 6, 1, '2022-01-17'),
(188, 9, 22, '2022-01-21'),
(189, 4, 21, '2022-01-25'),
(190, 13, 30, '2022-01-29'),
(191, 7, 29, '2022-02-02'),
(192, 4, 30, '2022-02-06'),
(193, 5, 21, '2022-02-10'),
(194, 14, 13, '2022-02-14'),
(195, 15, 19, '2022-02-18'),
(196, 8, 10, '2022-02-22'),
(197, 15, 22, '2022-02-26'),
(198, 6, 10, '2022-03-02'),
(199, 7, 29, '2022-03-06'),
(200, 9, 25, '2022-03-10');

# An insert into RENTAL_PRODUCT means that a copy is rented and an update means that a copy is returned to the store
INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (1, 76, 7);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-01-07', return_condition = 2 WHERE rental_id = 1 AND copy_id = 76 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (1, 74, 7);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-01-07', return_condition = 2 WHERE rental_id = 1 AND copy_id = 74 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (1, 81, 4);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-01-07', return_condition = 2 WHERE rental_id = 1 AND copy_id = 81 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (2, 78, 21);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-01-12', return_condition = 2 WHERE rental_id = 2 AND copy_id = 78 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (3, 63, 8);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-01-13', return_condition = 2 WHERE rental_id = 3 AND copy_id = 63 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (4, 20, 7);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-01-20', return_condition = 2 WHERE rental_id = 4 AND copy_id = 20 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (4, 30, 10);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-01-20', return_condition = 1 WHERE rental_id = 4 AND copy_id = 30 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (5, 53, 10);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-01-23', return_condition = 2 WHERE rental_id = 5 AND copy_id = 53 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (6, 65, 21);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-01-28', return_condition = 2 WHERE rental_id = 6 AND copy_id = 65 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (7, 88, 16);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-01-29', return_condition = 2 WHERE rental_id = 7 AND copy_id = 88 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (7, 101, 5);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-01-30', return_condition = 2 WHERE rental_id = 7 AND copy_id = 101 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (7, 66, 18);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-01-31', return_condition = 3 WHERE rental_id = 7 AND copy_id = 66 AND movie_id = 18;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (8, 58, 15);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-02-02', return_condition = 3 WHERE rental_id = 8 AND copy_id = 58 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (9, 12, 11);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-02-09', return_condition = 2 WHERE rental_id = 9 AND copy_id = 12 AND movie_id = 11;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (9, 23, 6);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-02-08', return_condition = 3 WHERE rental_id = 9 AND copy_id = 23 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (10, 47, 1);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-02-10', return_condition = 2 WHERE rental_id = 10 AND copy_id = 47 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (10, 42, 4);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-02-12', return_condition = 2 WHERE rental_id = 10 AND copy_id = 42 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (11, 13, 11);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-02-13', return_condition = 3 WHERE rental_id = 11 AND copy_id = 13 AND movie_id = 11;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (11, 23, 8);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-02-17', return_condition = 2 WHERE rental_id = 11 AND copy_id = 23 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (11, 22, 21);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-02-14', return_condition = 1 WHERE rental_id = 11 AND copy_id = 22 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (12, 71, 13);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-02-17', return_condition = 3 WHERE rental_id = 12 AND copy_id = 71 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (13, 67, 23);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-02-22', return_condition = 2 WHERE rental_id = 13 AND copy_id = 67 AND movie_id = 23;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (14, 40, 22);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-02-29', return_condition = 3 WHERE rental_id = 14 AND copy_id = 40 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (14, 50, 12);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-02-27', return_condition = 1 WHERE rental_id = 14 AND copy_id = 50 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (14, 53, 1);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-02-27', return_condition = 3 WHERE rental_id = 14 AND copy_id = 53 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (15, 17, 18);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-03-01', return_condition = 1 WHERE rental_id = 15 AND copy_id = 17 AND movie_id = 18;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (15, 22, 19);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-03-03', return_condition = 3 WHERE rental_id = 15 AND copy_id = 22 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (15, 15, 7);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-03-04', return_condition = 1 WHERE rental_id = 15 AND copy_id = 15 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (16, 3, 23);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-03-07', return_condition = 2 WHERE rental_id = 16 AND copy_id = 3 AND movie_id = 23;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (16, 5, 13);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-03-07', return_condition = 3 WHERE rental_id = 16 AND copy_id = 5 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (17, 12, 17);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-03-11', return_condition = 2 WHERE rental_id = 17 AND copy_id = 12 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (17, 14, 19);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-03-11', return_condition = 1 WHERE rental_id = 17 AND copy_id = 14 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (17, 8, 20);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-03-10', return_condition = 3 WHERE rental_id = 17 AND copy_id = 8 AND movie_id = 20;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (18, 51, 8);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-03-15', return_condition = 1 WHERE rental_id = 18 AND copy_id = 51 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (19, 48, 22);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-03-20', return_condition = 2 WHERE rental_id = 19 AND copy_id = 48 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (19, 48, 7);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-03-20', return_condition = 1 WHERE rental_id = 19 AND copy_id = 48 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (20, 19, 22);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-03-23', return_condition = 2 WHERE rental_id = 20 AND copy_id = 19 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (20, 23, 25);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-03-22', return_condition = 2 WHERE rental_id = 20 AND copy_id = 23 AND movie_id = 25;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (20, 13, 15);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-03-22', return_condition = 1 WHERE rental_id = 20 AND copy_id = 13 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (21, 51, 22);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-03-26', return_condition = 1 WHERE rental_id = 21 AND copy_id = 51 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (21, 55, 2);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-03-24', return_condition = 1 WHERE rental_id = 21 AND copy_id = 55 AND movie_id = 2;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (21, 68, 8);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-03-25', return_condition = 2 WHERE rental_id = 21 AND copy_id = 68 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (22, 69, 12);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-03-28', return_condition = 1 WHERE rental_id = 22 AND copy_id = 69 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (23, 71, 16);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-04-02', return_condition = 3 WHERE rental_id = 23 AND copy_id = 71 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (24, 27, 13);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-04-05', return_condition = 3 WHERE rental_id = 24 AND copy_id = 27 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (24, 40, 1);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-04-06', return_condition = 3 WHERE rental_id = 24 AND copy_id = 40 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (24, 42, 1);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-04-06', return_condition = 1 WHERE rental_id = 24 AND copy_id = 42 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (25, 70, 15);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-04-09', return_condition = 1 WHERE rental_id = 25 AND copy_id = 70 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (25, 68, 15);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-04-12', return_condition = 1 WHERE rental_id = 25 AND copy_id = 68 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (26, 27, 1);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-04-17', return_condition = 1 WHERE rental_id = 26 AND copy_id = 27 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (26, 32, 6);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-04-15', return_condition = 2 WHERE rental_id = 26 AND copy_id = 32 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (26, 24, 1);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-04-14', return_condition = 2 WHERE rental_id = 26 AND copy_id = 24 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (27, 56, 13);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-04-18', return_condition = 2 WHERE rental_id = 27 AND copy_id = 56 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (28, 25, 7);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-04-24', return_condition = 1 WHERE rental_id = 28 AND copy_id = 25 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (28, 38, 22);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-04-22', return_condition = 1 WHERE rental_id = 28 AND copy_id = 38 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (29, 19, 12);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-04-29', return_condition = 3 WHERE rental_id = 29 AND copy_id = 19 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (30, 37, 5);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-05-02', return_condition = 3 WHERE rental_id = 30 AND copy_id = 37 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (30, 31, 24);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-05-01', return_condition = 2 WHERE rental_id = 30 AND copy_id = 31 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (30, 40, 3);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-04-30', return_condition = 1 WHERE rental_id = 30 AND copy_id = 40 AND movie_id = 3;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (31, 67, 7);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-05-05', return_condition = 3 WHERE rental_id = 31 AND copy_id = 67 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (31, 73, 16);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-05-06', return_condition = 3 WHERE rental_id = 31 AND copy_id = 73 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (32, 57, 7);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-05-07', return_condition = 3 WHERE rental_id = 32 AND copy_id = 57 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (32, 65, 24);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-05-08', return_condition = 3 WHERE rental_id = 32 AND copy_id = 65 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (33, 25, 13);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-05-15', return_condition = 3 WHERE rental_id = 33 AND copy_id = 25 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (33, 38, 24);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-05-14', return_condition = 2 WHERE rental_id = 33 AND copy_id = 38 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (33, 36, 19);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-05-15', return_condition = 3 WHERE rental_id = 33 AND copy_id = 36 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (34, 62, 5);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-05-19', return_condition = 3 WHERE rental_id = 34 AND copy_id = 62 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (35, 80, 24);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-05-21', return_condition = 2 WHERE rental_id = 35 AND copy_id = 80 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (36, 5, 19);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-05-23', return_condition = 3 WHERE rental_id = 36 AND copy_id = 5 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (36, 11, 12);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-05-27', return_condition = 2 WHERE rental_id = 36 AND copy_id = 11 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (36, 13, 13);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-05-23', return_condition = 2 WHERE rental_id = 36 AND copy_id = 13 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (37, 21, 16);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-05-27', return_condition = 3 WHERE rental_id = 37 AND copy_id = 21 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (38, 13, 18);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-06-03', return_condition = 3 WHERE rental_id = 38 AND copy_id = 13 AND movie_id = 18;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (39, 8, 17);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-06-05', return_condition = 2 WHERE rental_id = 39 AND copy_id = 8 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (40, 63, 9);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-06-09', return_condition = 3 WHERE rental_id = 40 AND copy_id = 63 AND movie_id = 9;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (40, 83, 16);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-06-09', return_condition = 1 WHERE rental_id = 40 AND copy_id = 83 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (40, 83, 14);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-06-08', return_condition = 1 WHERE rental_id = 40 AND copy_id = 83 AND movie_id = 14;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (41, 38, 17);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-06-15', return_condition = 3 WHERE rental_id = 41 AND copy_id = 38 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (41, 51, 6);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-06-16', return_condition = 2 WHERE rental_id = 41 AND copy_id = 51 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (41, 38, 13);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-06-15', return_condition = 3 WHERE rental_id = 41 AND copy_id = 38 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (42, 41, 25);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-06-17', return_condition = 2 WHERE rental_id = 42 AND copy_id = 41 AND movie_id = 25;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (43, 70, 25);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-06-20', return_condition = 3 WHERE rental_id = 43 AND copy_id = 70 AND movie_id = 25;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (43, 101, 5);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-06-23', return_condition = 2 WHERE rental_id = 43 AND copy_id = 101 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (43, 97, 21);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-06-22', return_condition = 3 WHERE rental_id = 43 AND copy_id = 97 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (44, 44, 9);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-06-24', return_condition = 1 WHERE rental_id = 44 AND copy_id = 44 AND movie_id = 9;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (45, 1, 4);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-06-29', return_condition = 2 WHERE rental_id = 45 AND copy_id = 1 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (45, 3, 1);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-07-02', return_condition = 1 WHERE rental_id = 45 AND copy_id = 3 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (45, 5, 12);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-06-28', return_condition = 2 WHERE rental_id = 45 AND copy_id = 5 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (46, 24, 21);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-07-04', return_condition = 3 WHERE rental_id = 46 AND copy_id = 24 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (47, 87, 5);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-07-08', return_condition = 1 WHERE rental_id = 47 AND copy_id = 87 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (47, 93, 5);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-07-08', return_condition = 2 WHERE rental_id = 47 AND copy_id = 93 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (48, 47, 18);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-07-13', return_condition = 3 WHERE rental_id = 48 AND copy_id = 47 AND movie_id = 18;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (48, 48, 16);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-07-14', return_condition = 2 WHERE rental_id = 48 AND copy_id = 48 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (49, 73, 16);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-07-17', return_condition = 3 WHERE rental_id = 49 AND copy_id = 73 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (50, 42, 23);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-07-22', return_condition = 2 WHERE rental_id = 50 AND copy_id = 42 AND movie_id = 23;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (50, 45, 21);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-07-22', return_condition = 2 WHERE rental_id = 50 AND copy_id = 45 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (51, 24, 5);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-07-25', return_condition = 2 WHERE rental_id = 51 AND copy_id = 24 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (52, 5, 6);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-07-27', return_condition = 1 WHERE rental_id = 52 AND copy_id = 5 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (52, 2, 4);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-07-26', return_condition = 3 WHERE rental_id = 52 AND copy_id = 2 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (53, 61, 23);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-08-03', return_condition = 2 WHERE rental_id = 53 AND copy_id = 61 AND movie_id = 23;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (53, 63, 5);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-08-03', return_condition = 2 WHERE rental_id = 53 AND copy_id = 63 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (53, 69, 3);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-08-01', return_condition = 1 WHERE rental_id = 53 AND copy_id = 69 AND movie_id = 3;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (54, 54, 14);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-08-07', return_condition = 1 WHERE rental_id = 54 AND copy_id = 54 AND movie_id = 14;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (54, 47, 19);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-08-04', return_condition = 3 WHERE rental_id = 54 AND copy_id = 47 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (55, 80, 17);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-08-10', return_condition = 1 WHERE rental_id = 55 AND copy_id = 80 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (56, 29, 24);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-08-12', return_condition = 2 WHERE rental_id = 56 AND copy_id = 29 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (56, 22, 1);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-08-11', return_condition = 3 WHERE rental_id = 56 AND copy_id = 22 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (57, 53, 15);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-08-18', return_condition = 2 WHERE rental_id = 57 AND copy_id = 53 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (58, 10, 25);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-08-19', return_condition = 2 WHERE rental_id = 58 AND copy_id = 10 AND movie_id = 25;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (59, 57, 5);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-08-27', return_condition = 1 WHERE rental_id = 59 AND copy_id = 57 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (59, 52, 25);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-08-23', return_condition = 1 WHERE rental_id = 59 AND copy_id = 52 AND movie_id = 25;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (59, 63, 1);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-08-24', return_condition = 3 WHERE rental_id = 59 AND copy_id = 63 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (60, 55, 21);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-08-30', return_condition = 1 WHERE rental_id = 60 AND copy_id = 55 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (60, 54, 21);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-08-28', return_condition = 3 WHERE rental_id = 60 AND copy_id = 54 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (61, 6, 14);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-09-03', return_condition = 2 WHERE rental_id = 61 AND copy_id = 6 AND movie_id = 14;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (61, 4, 7);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-09-01', return_condition = 2 WHERE rental_id = 61 AND copy_id = 4 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (61, 2, 3);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-09-02', return_condition = 1 WHERE rental_id = 61 AND copy_id = 2 AND movie_id = 3;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (62, 37, 10);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-09-07', return_condition = 1 WHERE rental_id = 62 AND copy_id = 37 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (62, 44, 1);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-09-08', return_condition = 1 WHERE rental_id = 62 AND copy_id = 44 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (63, 67, 12);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-09-10', return_condition = 3 WHERE rental_id = 63 AND copy_id = 67 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (63, 62, 7);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-09-12', return_condition = 3 WHERE rental_id = 63 AND copy_id = 62 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (63, 66, 16);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-09-12', return_condition = 2 WHERE rental_id = 63 AND copy_id = 66 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (64, 17, 9);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-09-15', return_condition = 3 WHERE rental_id = 64 AND copy_id = 17 AND movie_id = 9;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (64, 22, 18);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-09-13', return_condition = 1 WHERE rental_id = 64 AND copy_id = 22 AND movie_id = 18;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (65, 53, 7);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-09-20', return_condition = 1 WHERE rental_id = 65 AND copy_id = 53 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (65, 62, 13);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-09-19', return_condition = 1 WHERE rental_id = 65 AND copy_id = 62 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (66, 83, 8);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-09-21', return_condition = 2 WHERE rental_id = 66 AND copy_id = 83 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (66, 71, 16);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-09-21', return_condition = 3 WHERE rental_id = 66 AND copy_id = 71 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (66, 68, 17);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-09-22', return_condition = 3 WHERE rental_id = 66 AND copy_id = 68 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (67, 17, 15);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-09-28', return_condition = 2 WHERE rental_id = 67 AND copy_id = 17 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (68, 79, 24);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-09-29', return_condition = 2 WHERE rental_id = 68 AND copy_id = 79 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (68, 61, 10);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-09-30', return_condition = 1 WHERE rental_id = 68 AND copy_id = 61 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (69, 50, 19);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-10-02', return_condition = 2 WHERE rental_id = 69 AND copy_id = 50 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (70, 44, 10);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-10-09', return_condition = 3 WHERE rental_id = 70 AND copy_id = 44 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (70, 40, 13);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-10-10', return_condition = 3 WHERE rental_id = 70 AND copy_id = 40 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (71, 15, 21);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-10-10', return_condition = 3 WHERE rental_id = 71 AND copy_id = 15 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (71, 8, 17);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-10-11', return_condition = 2 WHERE rental_id = 71 AND copy_id = 8 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (72, 29, 6);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-10-16', return_condition = 3 WHERE rental_id = 72 AND copy_id = 29 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (72, 20, 22);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-10-16', return_condition = 1 WHERE rental_id = 72 AND copy_id = 20 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (72, 30, 3);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-10-17', return_condition = 3 WHERE rental_id = 72 AND copy_id = 30 AND movie_id = 3;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (73, 44, 20);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-10-21', return_condition = 1 WHERE rental_id = 73 AND copy_id = 44 AND movie_id = 20;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (73, 47, 25);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-10-18', return_condition = 1 WHERE rental_id = 73 AND copy_id = 47 AND movie_id = 25;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (73, 49, 19);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-10-20', return_condition = 1 WHERE rental_id = 73 AND copy_id = 49 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (74, 32, 21);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-10-26', return_condition = 1 WHERE rental_id = 74 AND copy_id = 32 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (74, 37, 14);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-10-25', return_condition = 2 WHERE rental_id = 74 AND copy_id = 37 AND movie_id = 14;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (75, 93, 5);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-10-26', return_condition = 2 WHERE rental_id = 75 AND copy_id = 93 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (76, 42, 1);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-11-01', return_condition = 1 WHERE rental_id = 76 AND copy_id = 42 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (76, 34, 25);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-10-30', return_condition = 2 WHERE rental_id = 76 AND copy_id = 34 AND movie_id = 25;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (76, 35, 23);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-10-31', return_condition = 2 WHERE rental_id = 76 AND copy_id = 35 AND movie_id = 23;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (77, 56, 22);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-11-03', return_condition = 2 WHERE rental_id = 77 AND copy_id = 56 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (78, 95, 21);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-11-11', return_condition = 1 WHERE rental_id = 78 AND copy_id = 95 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (79, 27, 4);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-11-15', return_condition = 3 WHERE rental_id = 79 AND copy_id = 27 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (79, 18, 22);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-11-15', return_condition = 1 WHERE rental_id = 79 AND copy_id = 18 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (79, 21, 25);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-11-13', return_condition = 2 WHERE rental_id = 79 AND copy_id = 21 AND movie_id = 25;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (80, 44, 25);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-11-16', return_condition = 3 WHERE rental_id = 80 AND copy_id = 44 AND movie_id = 25;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (81, 97, 5);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-11-20', return_condition = 2 WHERE rental_id = 81 AND copy_id = 97 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (82, 5, 24);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-11-24', return_condition = 1 WHERE rental_id = 82 AND copy_id = 5 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (82, 5, 13);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-11-25', return_condition = 3 WHERE rental_id = 82 AND copy_id = 5 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (83, 37, 5);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-11-30', return_condition = 3 WHERE rental_id = 83 AND copy_id = 37 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (84, 50, 24);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-12-05', return_condition = 3 WHERE rental_id = 84 AND copy_id = 50 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (85, 39, 25);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-12-06', return_condition = 1 WHERE rental_id = 85 AND copy_id = 39 AND movie_id = 25;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (85, 53, 21);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2020-12-05', return_condition = 1 WHERE rental_id = 85 AND copy_id = 53 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (86, 47, 12);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-12-10', return_condition = 1 WHERE rental_id = 86 AND copy_id = 47 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (86, 47, 10);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-12-13', return_condition = 2 WHERE rental_id = 86 AND copy_id = 47 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (86, 51, 1);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-12-12', return_condition = 1 WHERE rental_id = 86 AND copy_id = 51 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (87, 47, 21);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2020-12-17', return_condition = 1 WHERE rental_id = 87 AND copy_id = 47 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (88, 41, 15);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-12-20', return_condition = 3 WHERE rental_id = 88 AND copy_id = 41 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (88, 39, 10);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-12-20', return_condition = 1 WHERE rental_id = 88 AND copy_id = 39 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (88, 25, 9);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2020-12-19', return_condition = 2 WHERE rental_id = 88 AND copy_id = 25 AND movie_id = 9;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (89, 82, 16);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-12-24', return_condition = 2 WHERE rental_id = 89 AND copy_id = 82 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (90, 11, 24);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2020-12-26', return_condition = 1 WHERE rental_id = 90 AND copy_id = 11 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (90, 9, 14);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2020-12-29', return_condition = 1 WHERE rental_id = 90 AND copy_id = 9 AND movie_id = 14;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (91, 38, 7);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-01-01', return_condition = 1 WHERE rental_id = 91 AND copy_id = 38 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (92, 74, 23);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-01-06', return_condition = 1 WHERE rental_id = 92 AND copy_id = 74 AND movie_id = 23;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (92, 84, 16);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-01-05', return_condition = 2 WHERE rental_id = 92 AND copy_id = 84 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (92, 81, 4);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-01-05', return_condition = 3 WHERE rental_id = 92 AND copy_id = 81 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (93, 12, 12);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-01-08', return_condition = 1 WHERE rental_id = 93 AND copy_id = 12 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (93, 8, 9);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-01-08', return_condition = 1 WHERE rental_id = 93 AND copy_id = 8 AND movie_id = 9;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (93, 20, 3);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-01-10', return_condition = 3 WHERE rental_id = 93 AND copy_id = 20 AND movie_id = 3;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (94, 10, 20);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-01-14', return_condition = 3 WHERE rental_id = 94 AND copy_id = 10 AND movie_id = 20;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (94, 9, 20);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-01-14', return_condition = 3 WHERE rental_id = 94 AND copy_id = 9 AND movie_id = 20;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (95, 2, 2);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-01-16', return_condition = 1 WHERE rental_id = 95 AND copy_id = 2 AND movie_id = 2;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (96, 60, 13);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-01-22', return_condition = 3 WHERE rental_id = 96 AND copy_id = 60 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (96, 85, 21);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-01-19', return_condition = 3 WHERE rental_id = 96 AND copy_id = 85 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (97, 13, 11);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-01-22', return_condition = 3 WHERE rental_id = 97 AND copy_id = 13 AND movie_id = 11;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (98, 59, 17);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-01-29', return_condition = 1 WHERE rental_id = 98 AND copy_id = 59 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (98, 65, 5);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-01-26', return_condition = 2 WHERE rental_id = 98 AND copy_id = 65 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (98, 75, 21);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-01-27', return_condition = 1 WHERE rental_id = 98 AND copy_id = 75 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (99, 24, 18);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-02-02', return_condition = 3 WHERE rental_id = 99 AND copy_id = 24 AND movie_id = 18;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (100, 4, 9);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-02-04', return_condition = 1 WHERE rental_id = 100 AND copy_id = 4 AND movie_id = 9;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (100, 5, 23);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-02-03', return_condition = 2 WHERE rental_id = 100 AND copy_id = 5 AND movie_id = 23;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (100, 16, 8);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-02-03', return_condition = 2 WHERE rental_id = 100 AND copy_id = 16 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (101, 32, 8);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-02-11', return_condition = 2 WHERE rental_id = 101 AND copy_id = 32 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (102, 41, 18);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-02-15', return_condition = 1 WHERE rental_id = 102 AND copy_id = 41 AND movie_id = 18;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (102, 55, 17);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-02-13', return_condition = 3 WHERE rental_id = 102 AND copy_id = 55 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (102, 61, 15);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-02-15', return_condition = 3 WHERE rental_id = 102 AND copy_id = 61 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (103, 69, 14);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-02-15', return_condition = 3 WHERE rental_id = 103 AND copy_id = 69 AND movie_id = 14;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (103, 71, 8);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-02-18', return_condition = 1 WHERE rental_id = 103 AND copy_id = 71 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (104, 57, 19);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-02-19', return_condition = 3 WHERE rental_id = 104 AND copy_id = 57 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (104, 66, 6);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-02-20', return_condition = 2 WHERE rental_id = 104 AND copy_id = 66 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (104, 61, 22);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-02-22', return_condition = 2 WHERE rental_id = 104 AND copy_id = 61 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (105, 46, 12);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-02-25', return_condition = 3 WHERE rental_id = 105 AND copy_id = 46 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (105, 50, 12);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-02-23', return_condition = 1 WHERE rental_id = 105 AND copy_id = 50 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (105, 42, 16);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-02-23', return_condition = 1 WHERE rental_id = 105 AND copy_id = 42 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (106, 6, 4);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-02-28', return_condition = 1 WHERE rental_id = 106 AND copy_id = 6 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (106, 5, 10);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-02-28', return_condition = 3 WHERE rental_id = 106 AND copy_id = 5 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (107, 48, 12);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-03-07', return_condition = 3 WHERE rental_id = 107 AND copy_id = 48 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (107, 34, 7);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-03-04', return_condition = 1 WHERE rental_id = 107 AND copy_id = 34 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (108, 10, 13);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-03-09', return_condition = 1 WHERE rental_id = 108 AND copy_id = 10 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (108, 9, 13);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-03-08', return_condition = 3 WHERE rental_id = 108 AND copy_id = 9 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (108, 3, 4);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-03-11', return_condition = 2 WHERE rental_id = 108 AND copy_id = 3 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (109, 80, 17);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-03-14', return_condition = 1 WHERE rental_id = 109 AND copy_id = 80 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (109, 82, 17);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-03-12', return_condition = 2 WHERE rental_id = 109 AND copy_id = 82 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (109, 61, 9);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-03-11', return_condition = 3 WHERE rental_id = 109 AND copy_id = 61 AND movie_id = 9;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (110, 91, 8);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-03-17', return_condition = 1 WHERE rental_id = 110 AND copy_id = 91 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (110, 53, 9);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-03-19', return_condition = 2 WHERE rental_id = 110 AND copy_id = 53 AND movie_id = 9;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (110, 82, 24);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-03-19', return_condition = 2 WHERE rental_id = 110 AND copy_id = 82 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (111, 38, 9);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-03-20', return_condition = 2 WHERE rental_id = 111 AND copy_id = 38 AND movie_id = 9;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (111, 63, 5);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-03-22', return_condition = 2 WHERE rental_id = 111 AND copy_id = 63 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (112, 16, 7);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-03-25', return_condition = 3 WHERE rental_id = 112 AND copy_id = 16 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (112, 21, 2);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-03-27', return_condition = 3 WHERE rental_id = 112 AND copy_id = 21 AND movie_id = 2;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (113, 18, 19);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-03-30', return_condition = 3 WHERE rental_id = 113 AND copy_id = 18 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (113, 23, 4);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-03-27', return_condition = 3 WHERE rental_id = 113 AND copy_id = 23 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (114, 6, 21);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-04-02', return_condition = 1 WHERE rental_id = 114 AND copy_id = 6 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (115, 41, 25);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-04-05', return_condition = 2 WHERE rental_id = 115 AND copy_id = 41 AND movie_id = 25;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (115, 55, 15);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-04-04', return_condition = 2 WHERE rental_id = 115 AND copy_id = 55 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (116, 73, 24);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-04-11', return_condition = 3 WHERE rental_id = 116 AND copy_id = 73 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (116, 78, 14);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-04-08', return_condition = 3 WHERE rental_id = 116 AND copy_id = 78 AND movie_id = 14;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (116, 71, 4);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-04-09', return_condition = 2 WHERE rental_id = 116 AND copy_id = 71 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (117, 10, 6);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-04-12', return_condition = 2 WHERE rental_id = 117 AND copy_id = 10 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (117, 13, 6);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-04-14', return_condition = 1 WHERE rental_id = 117 AND copy_id = 13 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (117, 11, 8);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-04-14', return_condition = 2 WHERE rental_id = 117 AND copy_id = 11 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (118, 49, 17);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-04-18', return_condition = 2 WHERE rental_id = 118 AND copy_id = 49 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (118, 67, 21);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-04-19', return_condition = 3 WHERE rental_id = 118 AND copy_id = 67 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (119, 47, 5);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-04-20', return_condition = 1 WHERE rental_id = 119 AND copy_id = 47 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (119, 34, 7);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-04-22', return_condition = 1 WHERE rental_id = 119 AND copy_id = 34 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (119, 43, 19);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-04-23', return_condition = 3 WHERE rental_id = 119 AND copy_id = 43 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (120, 85, 15);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-04-25', return_condition = 3 WHERE rental_id = 120 AND copy_id = 85 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (121, 15, 6);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-04-29', return_condition = 1 WHERE rental_id = 121 AND copy_id = 15 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (122, 7, 22);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-05-04', return_condition = 2 WHERE rental_id = 122 AND copy_id = 7 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (123, 71, 19);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-05-08', return_condition = 1 WHERE rental_id = 123 AND copy_id = 71 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (123, 65, 7);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-05-10', return_condition = 1 WHERE rental_id = 123 AND copy_id = 65 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (124, 28, 8);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-05-10', return_condition = 2 WHERE rental_id = 124 AND copy_id = 28 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (125, 12, 13);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-05-16', return_condition = 2 WHERE rental_id = 125 AND copy_id = 12 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (125, 6, 11);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-05-16', return_condition = 2 WHERE rental_id = 125 AND copy_id = 6 AND movie_id = 11;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (125, 11, 12);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-05-17', return_condition = 2 WHERE rental_id = 125 AND copy_id = 11 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (126, 65, 22);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-05-20', return_condition = 2 WHERE rental_id = 126 AND copy_id = 65 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (126, 80, 4);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-05-22', return_condition = 1 WHERE rental_id = 126 AND copy_id = 80 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (127, 13, 17);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-05-26', return_condition = 1 WHERE rental_id = 127 AND copy_id = 13 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (127, 19, 24);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-05-23', return_condition = 1 WHERE rental_id = 127 AND copy_id = 19 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (128, 57, 7);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-05-26', return_condition = 3 WHERE rental_id = 128 AND copy_id = 57 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (129, 15, 7);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-06-02', return_condition = 1 WHERE rental_id = 129 AND copy_id = 15 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (129, 21, 6);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-06-03', return_condition = 3 WHERE rental_id = 129 AND copy_id = 21 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (129, 30, 14);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-05-31', return_condition = 3 WHERE rental_id = 129 AND copy_id = 30 AND movie_id = 14;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (130, 24, 8);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-06-04', return_condition = 3 WHERE rental_id = 130 AND copy_id = 24 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (130, 23, 24);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-06-04', return_condition = 2 WHERE rental_id = 130 AND copy_id = 23 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (131, 78, 21);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-06-07', return_condition = 2 WHERE rental_id = 131 AND copy_id = 78 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (132, 52, 8);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-06-14', return_condition = 2 WHERE rental_id = 132 AND copy_id = 52 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (132, 45, 15);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-06-11', return_condition = 1 WHERE rental_id = 132 AND copy_id = 45 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (133, 16, 23);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-06-16', return_condition = 2 WHERE rental_id = 133 AND copy_id = 16 AND movie_id = 23;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (133, 9, 23);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-06-18', return_condition = 2 WHERE rental_id = 133 AND copy_id = 9 AND movie_id = 23;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (134, 81, 8);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-06-19', return_condition = 1 WHERE rental_id = 134 AND copy_id = 81 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (134, 72, 15);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-06-23', return_condition = 2 WHERE rental_id = 134 AND copy_id = 72 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (135, 43, 3);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-06-23', return_condition = 2 WHERE rental_id = 135 AND copy_id = 43 AND movie_id = 3;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (136, 62, 18);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-06-30', return_condition = 3 WHERE rental_id = 136 AND copy_id = 62 AND movie_id = 18;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (136, 79, 24);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-06-30', return_condition = 2 WHERE rental_id = 136 AND copy_id = 79 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (136, 69, 10);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-06-29', return_condition = 1 WHERE rental_id = 136 AND copy_id = 69 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (137, 28, 8);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-07-03', return_condition = 2 WHERE rental_id = 137 AND copy_id = 28 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (138, 79, 16);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-07-05', return_condition = 1 WHERE rental_id = 138 AND copy_id = 79 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (139, 21, 4);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-07-11', return_condition = 1 WHERE rental_id = 139 AND copy_id = 21 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (140, 35, 9);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-07-15', return_condition = 1 WHERE rental_id = 140 AND copy_id = 35 AND movie_id = 9;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (140, 37, 11);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-07-16', return_condition = 1 WHERE rental_id = 140 AND copy_id = 37 AND movie_id = 11;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (141, 72, 4);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-07-17', return_condition = 2 WHERE rental_id = 141 AND copy_id = 72 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (141, 68, 12);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-07-17', return_condition = 2 WHERE rental_id = 141 AND copy_id = 68 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (141, 57, 11);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-07-19', return_condition = 1 WHERE rental_id = 141 AND copy_id = 57 AND movie_id = 11;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (142, 3, 5);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-07-23', return_condition = 2 WHERE rental_id = 142 AND copy_id = 3 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (142, 7, 24);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-07-21', return_condition = 1 WHERE rental_id = 142 AND copy_id = 7 AND movie_id = 24;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (143, 48, 13);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-07-25', return_condition = 3 WHERE rental_id = 143 AND copy_id = 48 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (143, 57, 2);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-07-28', return_condition = 1 WHERE rental_id = 143 AND copy_id = 57 AND movie_id = 2;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (143, 56, 10);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-07-26', return_condition = 2 WHERE rental_id = 143 AND copy_id = 56 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (144, 38, 6);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-08-02', return_condition = 1 WHERE rental_id = 144 AND copy_id = 38 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (144, 23, 20);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-08-02', return_condition = 1 WHERE rental_id = 144 AND copy_id = 23 AND movie_id = 20;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (145, 77, 6);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-08-02', return_condition = 1 WHERE rental_id = 145 AND copy_id = 77 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (146, 72, 16);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-08-09', return_condition = 1 WHERE rental_id = 146 AND copy_id = 72 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (147, 21, 17);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-08-13', return_condition = 3 WHERE rental_id = 147 AND copy_id = 21 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (147, 25, 10);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-08-14', return_condition = 1 WHERE rental_id = 147 AND copy_id = 25 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (148, 13, 8);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-08-14', return_condition = 2 WHERE rental_id = 148 AND copy_id = 13 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (148, 5, 19);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-08-17', return_condition = 3 WHERE rental_id = 148 AND copy_id = 5 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (149, 5, 12);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-08-20', return_condition = 2 WHERE rental_id = 149 AND copy_id = 5 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (150, 67, 13);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-08-25', return_condition = 2 WHERE rental_id = 150 AND copy_id = 67 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (150, 72, 16);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-08-24', return_condition = 1 WHERE rental_id = 150 AND copy_id = 72 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (151, 8, 11);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-08-27', return_condition = 2 WHERE rental_id = 151 AND copy_id = 8 AND movie_id = 11;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (152, 26, 1);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-09-02', return_condition = 2 WHERE rental_id = 152 AND copy_id = 26 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (152, 23, 18);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-09-01', return_condition = 1 WHERE rental_id = 152 AND copy_id = 23 AND movie_id = 18;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (153, 54, 5);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-09-06', return_condition = 2 WHERE rental_id = 153 AND copy_id = 54 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (154, 19, 9);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-09-10', return_condition = 1 WHERE rental_id = 154 AND copy_id = 19 AND movie_id = 9;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (155, 52, 6);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-09-14', return_condition = 3 WHERE rental_id = 155 AND copy_id = 52 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (155, 46, 2);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-09-14', return_condition = 2 WHERE rental_id = 155 AND copy_id = 46 AND movie_id = 2;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (156, 41, 1);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-09-19', return_condition = 1 WHERE rental_id = 156 AND copy_id = 41 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (156, 33, 10);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-09-15', return_condition = 2 WHERE rental_id = 156 AND copy_id = 33 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (157, 50, 5);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-09-23', return_condition = 2 WHERE rental_id = 157 AND copy_id = 50 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (158, 30, 13);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-09-23', return_condition = 2 WHERE rental_id = 158 AND copy_id = 30 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (158, 36, 10);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-09-23', return_condition = 1 WHERE rental_id = 158 AND copy_id = 36 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (159, 5, 16);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-09-28', return_condition = 2 WHERE rental_id = 159 AND copy_id = 5 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (159, 8, 1);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-09-29', return_condition = 3 WHERE rental_id = 159 AND copy_id = 8 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (160, 44, 23);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-10-01', return_condition = 2 WHERE rental_id = 160 AND copy_id = 44 AND movie_id = 23;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (160, 34, 13);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-10-01', return_condition = 3 WHERE rental_id = 160 AND copy_id = 34 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (161, 16, 21);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-10-06', return_condition = 3 WHERE rental_id = 161 AND copy_id = 16 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (161, 8, 20);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-10-08', return_condition = 3 WHERE rental_id = 161 AND copy_id = 8 AND movie_id = 20;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (162, 16, 1);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-10-11', return_condition = 1 WHERE rental_id = 162 AND copy_id = 16 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (162, 15, 18);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-10-10', return_condition = 1 WHERE rental_id = 162 AND copy_id = 15 AND movie_id = 18;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (162, 19, 12);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-10-12', return_condition = 3 WHERE rental_id = 162 AND copy_id = 19 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (163, 35, 25);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-10-17', return_condition = 3 WHERE rental_id = 163 AND copy_id = 35 AND movie_id = 25;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (163, 37, 15);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-10-15', return_condition = 3 WHERE rental_id = 163 AND copy_id = 37 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (163, 43, 21);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-10-17', return_condition = 2 WHERE rental_id = 163 AND copy_id = 43 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (164, 58, 2);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-10-20', return_condition = 1 WHERE rental_id = 164 AND copy_id = 58 AND movie_id = 2;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (164, 52, 11);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-10-19', return_condition = 2 WHERE rental_id = 164 AND copy_id = 52 AND movie_id = 11;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (165, 5, 10);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-10-24', return_condition = 3 WHERE rental_id = 165 AND copy_id = 5 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (165, 2, 14);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-10-25', return_condition = 1 WHERE rental_id = 165 AND copy_id = 2 AND movie_id = 14;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (165, 6, 10);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-10-22', return_condition = 2 WHERE rental_id = 165 AND copy_id = 6 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (166, 88, 5);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-10-26', return_condition = 2 WHERE rental_id = 166 AND copy_id = 88 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (166, 71, 6);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-10-25', return_condition = 3 WHERE rental_id = 166 AND copy_id = 71 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (167, 51, 7);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-11-01', return_condition = 3 WHERE rental_id = 167 AND copy_id = 51 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (167, 66, 1);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-10-30', return_condition = 2 WHERE rental_id = 167 AND copy_id = 66 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (167, 50, 22);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-11-01', return_condition = 2 WHERE rental_id = 167 AND copy_id = 50 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (168, 21, 2);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-11-05', return_condition = 3 WHERE rental_id = 168 AND copy_id = 21 AND movie_id = 2;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (168, 28, 6);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-11-02', return_condition = 3 WHERE rental_id = 168 AND copy_id = 28 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (169, 79, 14);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-11-08', return_condition = 3 WHERE rental_id = 169 AND copy_id = 79 AND movie_id = 14;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (169, 88, 15);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-11-06', return_condition = 2 WHERE rental_id = 169 AND copy_id = 88 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (170, 28, 15);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-11-10', return_condition = 3 WHERE rental_id = 170 AND copy_id = 28 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (170, 26, 22);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-11-12', return_condition = 3 WHERE rental_id = 170 AND copy_id = 26 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (171, 44, 13);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-11-15', return_condition = 1 WHERE rental_id = 171 AND copy_id = 44 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (171, 51, 23);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-11-14', return_condition = 2 WHERE rental_id = 171 AND copy_id = 51 AND movie_id = 23;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (172, 22, 2);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2021-11-18', return_condition = 3 WHERE rental_id = 172 AND copy_id = 22 AND movie_id = 2;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (173, 84, 5);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-11-24', return_condition = 2 WHERE rental_id = 173 AND copy_id = 84 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (174, 20, 1);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-11-30', return_condition = 1 WHERE rental_id = 174 AND copy_id = 20 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (175, 68, 22);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-12-04', return_condition = 2 WHERE rental_id = 175 AND copy_id = 68 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (176, 48, 5);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-12-04', return_condition = 1 WHERE rental_id = 176 AND copy_id = 48 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (176, 33, 7);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-12-05', return_condition = 3 WHERE rental_id = 176 AND copy_id = 33 AND movie_id = 7;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (177, 28, 2);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2021-12-12', return_condition = 2 WHERE rental_id = 177 AND copy_id = 28 AND movie_id = 2;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (178, 9, 4);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-12-15', return_condition = 3 WHERE rental_id = 178 AND copy_id = 9 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (179, 41, 6);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-12-19', return_condition = 3 WHERE rental_id = 179 AND copy_id = 41 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (180, 31, 6);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2021-12-22', return_condition = 3 WHERE rental_id = 180 AND copy_id = 31 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (180, 36, 3);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-12-24', return_condition = 3 WHERE rental_id = 180 AND copy_id = 36 AND movie_id = 3;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (180, 28, 5);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-12-20', return_condition = 1 WHERE rental_id = 180 AND copy_id = 28 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (181, 23, 21);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2021-12-28', return_condition = 2 WHERE rental_id = 181 AND copy_id = 23 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (182, 28, 16);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2021-12-30', return_condition = 2 WHERE rental_id = 182 AND copy_id = 28 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (183, 80, 15);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2022-01-05', return_condition = 1 WHERE rental_id = 183 AND copy_id = 80 AND movie_id = 15;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (183, 64, 19);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2022-01-04', return_condition = 2 WHERE rental_id = 183 AND copy_id = 64 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (184, 45, 4);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2022-01-06', return_condition = 1 WHERE rental_id = 184 AND copy_id = 45 AND movie_id = 4;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (185, 39, 16);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2022-01-11', return_condition = 3 WHERE rental_id = 185 AND copy_id = 39 AND movie_id = 16;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (185, 34, 13);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2022-01-11', return_condition = 3 WHERE rental_id = 185 AND copy_id = 34 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (186, 8, 1);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2022-01-14', return_condition = 3 WHERE rental_id = 186 AND copy_id = 8 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (187, 20, 10);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2022-01-17', return_condition = 2 WHERE rental_id = 187 AND copy_id = 20 AND movie_id = 10;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (187, 38, 5);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2022-01-20', return_condition = 3 WHERE rental_id = 187 AND copy_id = 38 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (187, 42, 8);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2022-01-19', return_condition = 2 WHERE rental_id = 187 AND copy_id = 42 AND movie_id = 8;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (188, 62, 3);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2022-01-22', return_condition = 3 WHERE rental_id = 188 AND copy_id = 62 AND movie_id = 3;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (189, 9, 9);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2022-01-25', return_condition = 1 WHERE rental_id = 189 AND copy_id = 9 AND movie_id = 9;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (189, 21, 6);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2022-01-28', return_condition = 3 WHERE rental_id = 189 AND copy_id = 21 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (189, 15, 18);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2022-01-27', return_condition = 1 WHERE rental_id = 189 AND copy_id = 15 AND movie_id = 18;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (190, 68, 17);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2022-01-29', return_condition = 3 WHERE rental_id = 190 AND copy_id = 68 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (191, 36, 12);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2022-02-02', return_condition = 3 WHERE rental_id = 191 AND copy_id = 36 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (191, 27, 17);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2022-02-05', return_condition = 3 WHERE rental_id = 191 AND copy_id = 27 AND movie_id = 17;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (191, 35, 19);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2022-02-04', return_condition = 1 WHERE rental_id = 191 AND copy_id = 35 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (192, 10, 9);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2022-02-06', return_condition = 2 WHERE rental_id = 192 AND copy_id = 10 AND movie_id = 9;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (192, 25, 6);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2022-02-10', return_condition = 3 WHERE rental_id = 192 AND copy_id = 25 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (192, 13, 11);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2022-02-07', return_condition = 3 WHERE rental_id = 192 AND copy_id = 13 AND movie_id = 11;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (193, 20, 11);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2022-02-10', return_condition = 3 WHERE rental_id = 193 AND copy_id = 20 AND movie_id = 11;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (194, 70, 19);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2022-02-15', return_condition = 1 WHERE rental_id = 194 AND copy_id = 70 AND movie_id = 19;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (194, 88, 1);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2022-02-16', return_condition = 3 WHERE rental_id = 194 AND copy_id = 88 AND movie_id = 1;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (194, 72, 12);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2022-02-18', return_condition = 2 WHERE rental_id = 194 AND copy_id = 72 AND movie_id = 12;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (195, 69, 13);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2022-02-19', return_condition = 2 WHERE rental_id = 195 AND copy_id = 69 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (196, 61, 3);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2022-02-22', return_condition = 3 WHERE rental_id = 196 AND copy_id = 61 AND movie_id = 3;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (196, 37, 18);
UPDATE RENTAL_PRODUCT SET rating = 1, return_date = '2022-02-22', return_condition = 1 WHERE rental_id = 196 AND copy_id = 37 AND movie_id = 18;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (196, 35, 13);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2022-02-26', return_condition = 2 WHERE rental_id = 196 AND copy_id = 35 AND movie_id = 13;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (197, 102, 5);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2022-03-01', return_condition = 2 WHERE rental_id = 197 AND copy_id = 102 AND movie_id = 5;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (197, 70, 22);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2022-03-02', return_condition = 3 WHERE rental_id = 197 AND copy_id = 70 AND movie_id = 22;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (198, 30, 2);
UPDATE RENTAL_PRODUCT SET rating = 2, return_date = '2022-03-06', return_condition = 3 WHERE rental_id = 198 AND copy_id = 30 AND movie_id = 2;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (199, 43, 23);
UPDATE RENTAL_PRODUCT SET rating = 5, return_date = '2022-03-10', return_condition = 3 WHERE rental_id = 199 AND copy_id = 43 AND movie_id = 23;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (199, 38, 21);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2022-03-08', return_condition = 3 WHERE rental_id = 199 AND copy_id = 38 AND movie_id = 21;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (200, 54, 6);
UPDATE RENTAL_PRODUCT SET rating = 3, return_date = '2022-03-13', return_condition = 3 WHERE rental_id = 200 AND copy_id = 54 AND movie_id = 6;

INSERT INTO RENTAL_PRODUCT (rental_id, copy_id, movie_id) VALUES (200, 54, 1);
UPDATE RENTAL_PRODUCT SET rating = 4, return_date = '2022-03-11', return_condition = 2 WHERE rental_id = 200 AND copy_id = 54 AND movie_id = 1;

