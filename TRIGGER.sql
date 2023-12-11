#AFTER_INSERT
CREATE DEFINER=`root`@`localhost` TRIGGER `seat_AFTER_INSERT` AFTER INSERT ON `seat` FOR EACH ROW BEGIN
	UPDATE room 
   	SET total_seat = (SELECT COUNT(*) FROM seat WHERE room_id = NEW.room_id)
  	WHERE id =  NEW.room_id;
END

#BEFORE_INSERT
CREATE DEFINER=`root`@`localhost` TRIGGER `seat_BEFORE_INSERT` BEFORE INSERT ON `seat` FOR EACH ROW BEGIN
	UPDATE room 
   	SET total_seat = (SELECT COUNT(*) FROM seat WHERE room_id = NEW.room_id) + 1
  	WHERE id =  NEW.room_id;
END

#AFTER_UPDATE
CREATE DEFINER=`root`@`localhost` TRIGGER `seat_AFTER_UPDATE` AFTER UPDATE ON `seat` FOR EACH ROW BEGIN
	UPDATE room
    SET total_seat = (SELECT COUNT(*) FROM seat WHERE room_id = OLD.room_id) 
    WHERE id = OLD.room_id;
    
    UPDATE room
    SET total_seat = (SELECT COUNT(*) FROM seat WHERE room_id = NEW.room_id) 
    WHERE id = NEW.room_id;
END

#BEFORE_UPDATE
CREATE DEFINER = CURRENT_USER TRIGGER `cinema_be5`.`seat_BEFORE_UPDATE` BEFORE UPDATE ON `seat` FOR EACH ROW
BEGIN
	UPDATE room
    SET total_seat = (SELECT COUNT(*) FROM seat WHERE room_id = OLD.room_id) - 1
    WHERE id = OLD.room_id;
    
    UPDATE room
    SET total_seat = (SELECT COUNT(*) FROM seat WHERE room_id = NEW.room_id) + 1
    WHERE id = NEW.room_id;
END

#BEFORE_DELETE
CREATE DEFINER=`root`@`localhost` TRIGGER `seat_BEFORE_DELETE` BEFORE DELETE ON `seat` FOR EACH ROW BEGIN
	UPDATE room
    SET total_seat = (SELECT COUNT(*) FROM seat WHERE room_id = OLD.room_id) - 1
	WHERE id = OLD.room_id;
END

#AFTER_DELETE
CREATE DEFINER=`root`@`localhost` TRIGGER `seat_AFTER_DELETE` AFTER DELETE ON `seat` FOR EACH ROW BEGIN
	UPDATE room
    SET total_seat = (SELECT COUNT(*) FROM seat WHERE room_id = OLD.room_id) 
	WHERE id = OLD.room_id;
END








