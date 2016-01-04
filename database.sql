-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema icat-facilitator
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `icat-facilitator` ;

-- -----------------------------------------------------
-- Schema icat-facilitator
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `icat-facilitator` DEFAULT CHARACTER SET utf8 ;
USE `icat-facilitator` ;

-- -----------------------------------------------------
-- Table `icat-facilitator`.`tournament`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `icat-facilitator`.`tournament` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `star-date` DATE NULL,
  `number-rounds` INT(2) NULL,
  `number-participants` INT(3) NULL,
  `number-each-team` INT(2) NULL,
  `number-teams` INT(3) NULL,
  `have-pre-rounds` TINYINT(1) NULL,
  `max-ideas-pre-round` INT(3) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `icat-facilitator`.`participant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `icat-facilitator`.`participant` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `social-media` TEXT NULL,
  `name` VARCHAR(50) NOT NULL,
  `username` VARCHAR(25) NOT NULL,
  `password` VARCHAR(25) NOT NULL,
  `phone` VARCHAR(15) NULL,
  `email` VARCHAR(45) NULL,
  `skills` TEXT NULL,
  `tournament_id` INT NOT NULL,
  PRIMARY KEY (`id`, `tournament_id`),
  INDEX `fk_participant_tournament1_idx` (`tournament_id` ASC),
  CONSTRAINT `fk_participant_tournament1`
    FOREIGN KEY (`tournament_id`)
    REFERENCES `icat-facilitator`.`tournament` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `icat-facilitator`.`ideas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `icat-facilitator`.`ideas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(30) NOT NULL,
  `tweet` TEXT NOT NULL,
  `tournament_id` INT NOT NULL,
  `participant_id` INT NOT NULL,
  `participant_tournament_id` INT NOT NULL,
  PRIMARY KEY (`id`, `tournament_id`, `participant_id`, `participant_tournament_id`),
  INDEX `fk_ideas_tournament1_idx` (`tournament_id` ASC),
  INDEX `fk_ideas_participant1_idx` (`participant_id` ASC, `participant_tournament_id` ASC),
  CONSTRAINT `fk_ideas_tournament1`
    FOREIGN KEY (`tournament_id`)
    REFERENCES `icat-facilitator`.`tournament` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ideas_participant1`
    FOREIGN KEY (`participant_id` , `participant_tournament_id`)
    REFERENCES `icat-facilitator`.`participant` (`id` , `tournament_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `icat-facilitator`.`team`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `icat-facilitator`.`team` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `ideas_id` INT NOT NULL,
  `participant_id` INT NOT NULL,
  `tournament_id` INT NOT NULL,
  PRIMARY KEY (`id`, `ideas_id`, `participant_id`, `tournament_id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_team_ideas_idx` (`ideas_id` ASC),
  INDEX `fk_team_participant1_idx` (`participant_id` ASC),
  INDEX `fk_team_tournament1_idx` (`tournament_id` ASC),
  CONSTRAINT `fk_team_ideas`
    FOREIGN KEY (`ideas_id`)
    REFERENCES `icat-facilitator`.`ideas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_team_participant1`
    FOREIGN KEY (`participant_id`)
    REFERENCES `icat-facilitator`.`participant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_team_tournament1`
    FOREIGN KEY (`tournament_id`)
    REFERENCES `icat-facilitator`.`tournament` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `icat-facilitator`.`vote`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `icat-facilitator`.`vote` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `round` VARCHAR(3) NOT NULL,
  `point-value` INT(6) NOT NULL,
  `ideas_id` INT NOT NULL,
  `participant_id` INT NOT NULL,
  PRIMARY KEY (`id`, `ideas_id`, `participant_id`),
  INDEX `fk_vote_ideas1_idx` (`ideas_id` ASC),
  INDEX `fk_vote_participant1_idx` (`participant_id` ASC),
  CONSTRAINT `fk_vote_ideas1`
    FOREIGN KEY (`ideas_id`)
    REFERENCES `icat-facilitator`.`ideas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vote_participant1`
    FOREIGN KEY (`participant_id`)
    REFERENCES `icat-facilitator`.`participant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `icat-facilitator`.`media`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `icat-facilitator`.`media` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `doc-link` TEXT NULL,
  `doc-type` VARCHAR(30) NULL,
  `team-id` INT(8) NULL,
  `participant_id` INT NOT NULL,
  `participant_tournament_id` INT NOT NULL,
  PRIMARY KEY (`id`, `participant_id`, `participant_tournament_id`),
  INDEX `fk_media_participant1_idx` (`participant_id` ASC, `participant_tournament_id` ASC),
  CONSTRAINT `fk_media_participant1`
    FOREIGN KEY (`participant_id` , `participant_tournament_id`)
    REFERENCES `icat-facilitator`.`participant` (`id` , `tournament_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `icat-facilitator`.`facilitator`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `icat-facilitator`.`facilitator` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `username` VARCHAR(25) NOT NULL,
  `password` VARCHAR(25) NULL,
  `social-media` TEXT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `icat-facilitator`.`rounds`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `icat-facilitator`.`rounds` (
  `id` INT NOT NULL,
  `number` VARCHAR(3) NULL,
  `end-date` DATE NULL,
  `tournament_id` INT NOT NULL,
  PRIMARY KEY (`id`, `tournament_id`),
  INDEX `fk_rounds_tournament1_idx` (`tournament_id` ASC),
  CONSTRAINT `fk_rounds_tournament1`
    FOREIGN KEY (`tournament_id`)
    REFERENCES `icat-facilitator`.`tournament` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `icat-facilitator`.`facilitator_has_tournament`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `icat-facilitator`.`facilitator_has_tournament` (
  `facilitator_id` INT NOT NULL,
  `tournament_id` INT NOT NULL,
  PRIMARY KEY (`facilitator_id`, `tournament_id`),
  INDEX `fk_facilitator_has_tournament_tournament1_idx` (`tournament_id` ASC),
  INDEX `fk_facilitator_has_tournament_facilitator1_idx` (`facilitator_id` ASC),
  CONSTRAINT `fk_facilitator_has_tournament_facilitator1`
    FOREIGN KEY (`facilitator_id`)
    REFERENCES `icat-facilitator`.`facilitator` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_facilitator_has_tournament_tournament1`
    FOREIGN KEY (`tournament_id`)
    REFERENCES `icat-facilitator`.`tournament` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `icat-facilitator`.`media_has_ideas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `icat-facilitator`.`media_has_ideas` (
  `media_id` INT NOT NULL,
  `media_participant_id` INT NOT NULL,
  `tournament_id` INT NOT NULL,
  `ideas_id` INT NOT NULL,
  PRIMARY KEY (`media_id`, `media_participant_id`, `tournament_id`, `ideas_id`),
  INDEX `fk_media_has_ideas_ideas1_idx` (`ideas_id` ASC),
  INDEX `fk_media_has_ideas_media1_idx` (`media_id` ASC, `media_participant_id` ASC, `tournament_id` ASC),
  CONSTRAINT `fk_media_has_ideas_media1`
    FOREIGN KEY (`media_id` , `media_participant_id` , `tournament_id`)
    REFERENCES `icat-facilitator`.`media` (`id` , `participant_id` , `participant_tournament_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_has_ideas_ideas1`
    FOREIGN KEY (`ideas_id`)
    REFERENCES `icat-facilitator`.`ideas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
