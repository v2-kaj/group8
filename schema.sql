CREATE TABLE `departments` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(64) DEFAULT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `programs` (
    `program_id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(128) DEFAULT NULL,
    `abbreviation` varchar(4) DEFAULT NULL,
    `dept` int DEFAULT NULL,
    PRIMARY KEY (`program_id`),
    KEY `FK_ProgramDept` (`dept`),
    CONSTRAINT `FK_ProgramDept` FOREIGN KEY (`dept`) REFERENCES `departments` (`id`)
);

-- Insert data into the 'departments' table
INSERT INTO `departments` (`name`)
VALUES
    ('Department of Computer Science'),
    ('Department of Engineering'),
    ('Department of Commerce');

-- Insert data into the 'programs' table
INSERT INTO `programs` (`name`, `abbreviation`, `dept`)
VALUES
    ('Management Information Systems', 'IS', 1),  
    ('Information Technology', 'IT', 1),     
    ('Banking and Finance', 'BAF', 3), 
    ('Business Administration', 'BE', 3),       
    ('Electrical Engineering', 'EE', 2),
    ('Mechanical Engineering', 'ME', 2);


CREATE TABLE `students` (
    `regnumber` varchar(32) NOT NULL,
    `firstname` varchar(64) NOT NULL,
    `lastname` varchar(64) NOT NULL,
    `gender` char(1) DEFAULT NULL,
    `age` int DEFAULT NULL,
    `program_id` int  DEFAULT NULL,
    `c_year` int DEFAULT NULL,
    `c_semester` int DEFAULT NULL,
     `next_of_kin` varchar(64) NOT NULL,
     
    PRIMARY KEY (`regnumber`),
    KEY `FK_StudentProgram` (`program_id`),
    CONSTRAINT `FK_StudentProgram` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`)
);

CREATE TABLE next_of_kin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_regnumber VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    relationship VARCHAR(255) NOT NULL,
    phone_number VARCHAR(15),
    email VARCHAR(255), -- Assuming email can be longer than 15 characters
    postal_address VARCHAR(255),
    FOREIGN KEY (student_regnumber) REFERENCES students(regnumber)
);

INSERT INTO `students` (`regnumber`, `firstname`, `lastname`, `program_id`)
VALUES
    ('BIT/21/SS/001', 'las', 'las', 2),  
    ('BIT/21/SS/002', 'hsjs', 'las', 2);  
     

CREATE TABLE `lecturers` (
    `id` int NOT NULL AUTO_INCREMENT,
    `firstname` varchar(64) NOT NULL,
    `lastname` varchar(64) NOT NULL,
    `gender` char(1) DEFAULT NULL,
    `age` int DEFAULT NULL,
    `department` int  DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `FK_LecturerDept` (`department`),
    CONSTRAINT `FK_LecturerDept` FOREIGN KEY (`department`) REFERENCES `departments` (`id`)
);

INSERT INTO `lecturers` ( `firstname`, `lastname`, `department`)
VALUES
    ('T', 'Chadza', 2), 
    ('H', 'Chilunga', 1);  


CREATE TABLE `modules` (
  `title` varchar(32) DEFAULT NULL,
  `code` varchar(10) NOT NULL,
  `semester` int DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  `level` int DEFAULT NULL,
  PRIMARY KEY (`code`),
  KEY `FK_ModuleDepartment` (`department_id`), -- Corrected the index name and field name
  CONSTRAINT `FK_ModuleDepartment` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`)
);

-- Inserting data into the modules table
INSERT INTO `modules` (`title`, `code`, `semester`, `department_id`, `level`) VALUES
  ('Introduction to Programming', 'CSIP111', 1, 1, 1),
  ('Database Management', 'CSDM111', 1, 1, 1),
  ('Web Development', 'CSWD111', 1, 1, 1),
  ('Data Structures', 'CSDS111', 1, 1, 1),
  ('Operating Systems', 'CSOS111', 1, 1, 1),
  ('Engineering Materials', 'ENEM111', 1, 2, 1),
  ('Engineering Drawing', 'ENED111', 1, 2, 1),
  ('Calculus', 'ENCA111', 1, 2, 1),
  ('Chemistry', 'ENCH111', 1, 2, 1),
  ('Business Law', 'COBL111', 1, 3, 1),
  ('Cost Accounting', 'COCA111', 1, 3, 1),
  ('Financial Accounting', 'COFA111', 1, 3, 1),
  ('Organisational Behaviour', 'COOB111', 1, 3, 1);
INSERT INTO `modules` (`title`, `code`, `semester`, `department_id`, `level`) VALUES
('Financial Accounting', 'COFA121', 2, 1, 1),
('Cost Accounting', 'COCA121', 2, 1, 1),
('Script', 'CSSP121', 2, 1, 1),
('Operating Systems', 'CSOP121', 2, 1, 1);

INSERT INTO `modules` (`title`, `code`, `semester`, `department_id`, `level`) VALUES
 ('Physics', 'ENPH121', 2, 2, 1),
('Mechanical Science', 'ENMS121', 2, 2, 1),
('Workshop', 'ENWOP121', 2, 2, 1),
('Trigonometry', 'ENTR121', 2, 2, 1);
CREATE TABLE `lecturer_module` (
    `id` int NOT NULL AUTO_INCREMENT,
    `lecturer_id` int NOT NULL,
    `module_code` VARCHAR(10) NOT NULL, -- Specify a length, e.g., VARCHAR(10)
    PRIMARY KEY (`id`),
    CONSTRAINT `FK_LecturerModule_Lecturer` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturers` (`id`),
    CONSTRAINT `FK_LecturerModule_Module` FOREIGN KEY (`module_code`) REFERENCES `modules` (`code`)
);

CREATE TABLE `assessments` (
  `assessment_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `type` enum('continuous','final_exam') DEFAULT NULL,
  `total_marks` int DEFAULT NULL,
  `module_code` varchar(10) NOT NULL,
  `weight` float(2,1) DEFAULT NULL,
  `scheduled_date` date DEFAULT NULL,
  `lecturer_id` int NOT NULL,
  PRIMARY KEY (`assessment_id`),
  KEY `FK_AssessmentType` (`name`),
  KEY `FK_AssessmentModule` (`module_code`),
  CONSTRAINT `FK_AssessmentModule` FOREIGN KEY (`module_code`) REFERENCES `modules` (`code`),
  CONSTRAINT `FK_AssessmentLecturer` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturers` (`id`)  -- Add a foreign key constraint
);


CREATE TABLE grades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    regnumber VARCHAR(32) NOT NULL,
    module_code VARCHAR(32) NOT NULL,
    semester INT NOT NULL,
    marks DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (regnumber) REFERENCES students(regnumber)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (module_code) REFERENCES modules(code)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

SELECT p.abbreviation, AVG(g.marks) AS average_grade
FROM programs p
INNER JOIN students s ON p.program_id = s.program_id
INNER JOIN grades g ON s.regnumber = g.regnumber
GROUP BY p.name;

SELECT
    s.firstname,
    g.regnumber,
    g.module_code,
    g.semester,
    g.marks
FROM
    students s
JOIN
    grades g ON s.regnumber = g.regnumber
ORDER BY
    s.firstname,
    g.semester;



INSERT INTO `grades` ( `regnumber`, `module_code`, `semester`, `marks`)
VALUES
    ('MIS/23/SS/001', 'CSIP111', 1, 80), 
    ('MIS/23/SS/001','CSDM111', 1, 96),
    ('MIS/23/SS/001','CSDS111', 1, 70),
    ('MIS/23/SS/001','CSWD111', 1, 96),
    ('MIS/23/SS/001','COFA121', 2, 81),
    ('MIS/23/SS/001','COCA121', 2, 98),
    ('MIS/23/SS/001','CSOP121', 2, 81),
    ('MIS/23/SS/001','CSSP121', 2, 78),
    -- another student
    ('MIS/23/SS/002', 'CSIP111', 1, 23), 
    ('MIS/23/SS/002','CSDM111', 1, 45),
    ('MIS/23/SS/002','CSDS111', 1, 50),
    ('MIS/23/SS/002','CSWD111', 1, 34),
    ('MIS/23/SS/002','COFA121', 2, 80),
    ('MIS/23/SS/002','COCA121', 2, 76),
    ('MIS/23/SS/002','CSOP121', 2, 99),
    ('MIS/23/SS/002','CSSP121', 2, 43);

    INSERT INTO `grades` ( `regnumber`, `module_code`, `semester`, `marks`)
VALUES
    ('BAF/23/SS/001', 'COFA111', 1, 76), 
    ('BAF/23/SS/001','COCA111', 1, 56),
    ('BAF/23/SS/001','COCA121', 2, 50),
    ('BAF/23/SS/001','COOB111', 1, 73),
    ('BAF/23/SS/001','COFA121', 2, 81),
    ('BAF/23/SS/001','COFA121', 2, 76),
    ('BAF/23/SS/001','COBL111', 1, 55),

    ('BAF/23/SS/002', 'COFA111',1, 42), 
    ('BAF/23/SS/002','COCA111', 1, 55),
    ('BAF/23/SS/002','COCA121', 2, 50),
    ('BAF/23/SS/002','COOB111', 1, 65),
    ('BAF/23/SS/002','COFA121', 2, 70),
    ('BAF/23/SS/002','COFA121', 2, 75),
    ('BAF/23/SS/002','COBL111', 1, 51),
    

    ('BAF/23/SS/003', 'COFA111',1, 65), 
    ('BAF/23/SS/003','COCA111', 1, 80),
    ('BAF/23/SS/003','COCA121', 2, 54),
    ('BAF/23/SS/003','COOB111', 1, 90),
    ('BAF/23/SS/003','COFA121', 2, 70),
    ('BAF/23/SS/003','COFA121', 2, 52),
    ('BAF/23/SS/003','COBL111', 1, 80);
    
   ENPH121, ENMS121, ENTR121, ENWOP121
INSERT INTO `grades` ( `regnumber`, `module_code`, `semester`, `marks`)
VALUES
    ('BME/23/SS/001', 'ENCA111', 1, 55), 
    ('BME/23/SS/001','ENCH111', 1, 51),
    ('BME/23/SS/001','ENED111', 1, 59),
    ('BME/23/SS/001','ENEM111', 1, 67),

    ('BME/23/SS/001', 'ENPH121', 2, 70), 
    ('BME/23/SS/001','ENMS121', 2, 50),
    ('BME/23/SS/001','ENTR121', 2, 51),
    ('BME/23/SS/001','ENWOP121', 2, 59),

     ('BME/23/SS/002', 'ENCA111', 1, 57), 
    ('BME/23/SS/002','ENCH111', 1, 61),
    ('BME/23/SS/002','ENED111', 1, 65),
    ('BME/23/SS/002','ENEM111', 1, 60),

    ('BME/23/SS/002', 'ENPH121', 2, 61), 
    ('BME/23/SS/002','ENMS121', 2, 64),
    ('BME/23/SS/002','ENTR121', 2, 53),
    ('BME/23/SS/002','ENWOP121', 2, 57),

    ('BME/23/SS/003', 'ENCA111', 1, 41), 
    ('BME/23/SS/003','ENCH111', 1, 52),
    ('BME/23/SS/003','ENED111', 1, 50),
    ('BME/23/SS/003','ENEM111', 1, 34),

    ('BME/23/SS/003', 'ENPH121', 2, 50), 
    ('BME/23/SS/003','ENMS121', 2, 61),
    ('BME/23/SS/003','ENTR121', 2, 42),
    ('BME/23/SS/003','ENWOP121', 2, 40);


    




INSERT INTO `grades` ( `regnumber`, `module_code`, `semester`, `marks`)
VALUES
    ('IS/23/SS/003', 'CSIP111', 1, 76), 
    ('IS/23/SS/003','CSDM111', 1, 65),
    ('IS/23/SS/003','CSDS111', 1, 89),
    ('IS/23/SS/003','CSWD111', 1, 55),
    ('IS/23/SS/003','COFA121', 2, 59),
    ('IS/23/SS/003','COCA121', 2, 70),
    ('IS/23/SS/003','CSOP121', 2, 66),
    ('IS/23/SS/003','CSSP121', 2, 90);

INSERT INTO `grades` ( `regnumber`, `module_code`, `semester`, `marks`)
VALUES
    ('IS/23/SS/004', 'CSIP111', 1, 40), 
    ('IS/23/SS/004','CSDM111', 1, 39),
    ('IS/23/SS/004','CSDS111', 1, 49),
    ('IS/23/SS/004','CSWD111', 1, 23),
    ('IS/23/SS/004','COFA121', 2, 67),
    ('IS/23/SS/004','COCA121', 2, 32),
    ('IS/23/SS/004','CSOP121', 2, 66),
    ('IS/23/SS/004','CSSP121', 2, 64);

SELECT p.abbreviation, COUNT(s.regnumber) AS number_of_students FROM students s INNER JOIN programs p ON s.program_id = p.program_id GROUP BY s.program_id;




     
=====================================
CREATE TABLE User (
    userid INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);

