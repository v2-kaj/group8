-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 06, 2023 at 11:11 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gms`
--

-- --------------------------------------------------------

--
-- Table structure for table `assessments`
--

CREATE TABLE `assessments` (
  `assessment_id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `type` enum('continuous','final_exam') DEFAULT NULL,
  `total_marks` int(11) DEFAULT NULL,
  `module_code` varchar(10) NOT NULL,
  `weight` float(2,1) DEFAULT NULL,
  `scheduled_date` date DEFAULT NULL,
  `lecturer_id` int(11) NOT NULL,
  `program_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assessments`
--

INSERT INTO `assessments` (`assessment_id`, `name`, `type`, `total_marks`, `module_code`, `weight`, `scheduled_date`, `lecturer_id`, `program_id`) VALUES
(1, 'Mid-semester', 'continuous', 100, 'CSDM111', 0.2, '2023-10-23', 18, 1),
(2, 'Test1', 'final_exam', 100, 'CSDM111', 0.2, '2023-10-24', 18, 1);

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `name` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `name`) VALUES
(1, 'Department of Computer Science'),
(2, 'Department of Engineering'),
(3, 'Department of Commerce');

-- --------------------------------------------------------

--
-- Table structure for table `grades`
--

CREATE TABLE `grades` (
  `id` int(11) NOT NULL,
  `regnumber` varchar(32) NOT NULL,
  `module_code` varchar(32) NOT NULL,
  `semester` int(11) NOT NULL,
  `marks` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `grades`
--

INSERT INTO `grades` (`id`, `regnumber`, `module_code`, `semester`, `marks`) VALUES
(1, 'MIS/23/SS/001', 'CSIP111', 1, 80.00),
(2, 'MIS/23/SS/001', 'CSDM111', 1, 96.00),
(3, 'MIS/23/SS/001', 'CSDS111', 1, 70.00),
(4, 'MIS/23/SS/001', 'CSWD111', 1, 96.00),
(5, 'MIS/23/SS/001', 'COFA121', 2, 81.00),
(6, 'MIS/23/SS/001', 'COCA121', 2, 98.00),
(7, 'MIS/23/SS/001', 'CSOP121', 2, 81.00),
(8, 'MIS/23/SS/001', 'CSSP121', 2, 78.00),
(9, 'MIS/23/SS/002', 'CSIP111', 1, 23.00),
(10, 'MIS/23/SS/002', 'CSDM111', 1, 45.00),
(11, 'MIS/23/SS/002', 'CSDS111', 1, 50.00),
(12, 'MIS/23/SS/002', 'CSWD111', 1, 34.00),
(13, 'MIS/23/SS/002', 'COFA121', 2, 80.00),
(14, 'MIS/23/SS/002', 'COCA121', 2, 76.00),
(15, 'MIS/23/SS/002', 'CSOP121', 2, 99.00),
(16, 'MIS/23/SS/002', 'CSSP121', 2, 43.00),
(17, 'BAF/23/SS/001', 'COFA111', 1, 76.00),
(18, 'BAF/23/SS/001', 'COCA111', 1, 56.00),
(19, 'BAF/23/SS/001', 'COCA121', 2, 50.00),
(20, 'BAF/23/SS/001', 'COOB111', 1, 73.00),
(21, 'BAF/23/SS/001', 'COFA121', 2, 81.00),
(22, 'BAF/23/SS/001', 'COFA121', 2, 76.00),
(23, 'BAF/23/SS/001', 'COBL111', 1, 55.00),
(24, 'BAF/23/SS/002', 'COFA111', 1, 42.00),
(25, 'BAF/23/SS/002', 'COCA111', 1, 55.00),
(26, 'BAF/23/SS/002', 'COCA121', 2, 50.00),
(27, 'BAF/23/SS/002', 'COOB111', 1, 65.00),
(28, 'BAF/23/SS/002', 'COFA121', 2, 70.00),
(29, 'BAF/23/SS/002', 'COFA121', 2, 75.00),
(30, 'BAF/23/SS/002', 'COBL111', 1, 51.00),
(31, 'BAF/23/SS/003', 'COFA111', 1, 65.00),
(32, 'BAF/23/SS/003', 'COCA111', 1, 80.00),
(33, 'BAF/23/SS/003', 'COCA121', 2, 54.00),
(34, 'BAF/23/SS/003', 'COOB111', 1, 90.00),
(35, 'BAF/23/SS/003', 'COFA121', 2, 70.00),
(36, 'BAF/23/SS/003', 'COFA121', 2, 52.00),
(37, 'BAF/23/SS/003', 'COBL111', 1, 80.00),
(38, 'BME/23/SS/001', 'ENCA111', 1, 55.00),
(39, 'BME/23/SS/001', 'ENCH111', 1, 51.00),
(40, 'BME/23/SS/001', 'ENED111', 1, 59.00),
(41, 'BME/23/SS/001', 'ENEM111', 1, 67.00),
(42, 'BME/23/SS/001', 'ENPH121', 2, 70.00),
(43, 'BME/23/SS/001', 'ENMS121', 2, 50.00),
(44, 'BME/23/SS/001', 'ENTR121', 2, 51.00),
(45, 'BME/23/SS/001', 'ENWOP121', 2, 59.00),
(46, 'BME/23/SS/002', 'ENCA111', 1, 57.00),
(47, 'BME/23/SS/002', 'ENCH111', 1, 61.00),
(48, 'BME/23/SS/002', 'ENED111', 1, 65.00),
(49, 'BME/23/SS/002', 'ENEM111', 1, 60.00),
(50, 'BME/23/SS/002', 'ENPH121', 2, 61.00),
(51, 'BME/23/SS/002', 'ENMS121', 2, 64.00),
(52, 'BME/23/SS/002', 'ENTR121', 2, 53.00),
(53, 'BME/23/SS/002', 'ENWOP121', 2, 57.00),
(54, 'BME/23/SS/003', 'ENCA111', 1, 41.00),
(55, 'BME/23/SS/003', 'ENCH111', 1, 52.00),
(56, 'BME/23/SS/003', 'ENED111', 1, 50.00),
(57, 'BME/23/SS/003', 'ENEM111', 1, 34.00),
(58, 'BME/23/SS/003', 'ENPH121', 2, 50.00),
(59, 'BME/23/SS/003', 'ENMS121', 2, 61.00),
(60, 'BME/23/SS/003', 'ENTR121', 2, 42.00),
(61, 'BME/23/SS/003', 'ENWOP121', 2, 40.00);

-- --------------------------------------------------------

--
-- Table structure for table `lecturers`
--

CREATE TABLE `lecturers` (
  `id` int(11) NOT NULL,
  `firstname` varchar(64) NOT NULL,
  `lastname` varchar(64) NOT NULL,
  `gender` char(1) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `department` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lecturers`
--

INSERT INTO `lecturers` (`id`, `firstname`, `lastname`, `gender`, `age`, `department`) VALUES
(18, 'D', 'Mkavea', NULL, NULL, 1),
(19, 'ron', 'ron3', NULL, NULL, 3),
(20, 'Madalitso', 'Mkavea', NULL, NULL, 2);

-- --------------------------------------------------------

--
-- Table structure for table `lecturer_module`
--

CREATE TABLE `lecturer_module` (
  `id` int(11) NOT NULL,
  `lecturer_id` int(11) NOT NULL,
  `module_code` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lecturer_module`
--

INSERT INTO `lecturer_module` (`id`, `lecturer_id`, `module_code`) VALUES
(1, 18, 'CSDM111'),
(2, 18, 'CSOS111'),
(3, 19, 'COBL111'),
(4, 19, 'COFA111'),
(5, 20, 'ENCH111'),
(6, 20, 'ENEM111');

-- --------------------------------------------------------

--
-- Table structure for table `modules`
--

CREATE TABLE `modules` (
  `title` varchar(32) DEFAULT NULL,
  `code` varchar(10) NOT NULL,
  `semester` int(11) DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `program_id` int(11) DEFAULT NULL,
  `level` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `modules`
--

INSERT INTO `modules` (`title`, `code`, `semester`, `department_id`, `program_id`, `level`) VALUES
('Business Law', 'COBL111', 1, 3, 3, 1),
('Cost Accounting', 'COCA111', 1, 3, 3, 1),
('Cost Accounting', 'COCA121', 2, 1, NULL, 1),
('Financial Accounting', 'COFA111', 1, 3, 3, 1),
('Financial Accounting', 'COFA121', 2, 1, NULL, 1),
('Organisational Behaviour', 'COOB111', 1, 3, 3, 1),
('Database Management', 'CSDM111', 1, 1, 1, 1),
('Data Structures', 'CSDS111', 1, 1, 1, 1),
('Introduction to Programming', 'CSIP111', 1, 1, 1, 1),
('Operating Systems', 'CSOP121', 2, 1, NULL, 1),
('Operating Systems', 'CSOS111', 1, 1, 1, 1),
('Script', 'CSSP121', 2, 1, NULL, 1),
('Web Development', 'CSWD111', 1, 1, 1, 1),
('Calculus', 'ENCA111', 1, 2, 6, 1),
('Chemistry', 'ENCH111', 1, 2, 6, 1),
('Engineering Drawing', 'ENED111', 1, 2, 6, 1),
('Engineering Materials', 'ENEM111', 1, 2, 6, 1),
('Mechanical Science', 'ENMS121', 2, 2, NULL, 1),
('Physics', 'ENPH121', 2, 2, NULL, 1),
('Trigonometry', 'ENTR121', 2, 2, NULL, 1),
('Workshop', 'ENWOP121', 2, 2, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `programs`
--

CREATE TABLE `programs` (
  `program_id` int(11) NOT NULL,
  `name` varchar(128) DEFAULT NULL,
  `abbreviation` varchar(4) DEFAULT NULL,
  `dept` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `programs`
--

INSERT INTO `programs` (`program_id`, `name`, `abbreviation`, `dept`) VALUES
(1, 'Bachelor of Management Information Systems', 'MIS', 1),
(3, 'Bachelor of Banking and Finance', 'BAF', 3),
(6, 'Bachelor of Mechanical Engineering', 'BME', 2);

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `regnumber` varchar(32) NOT NULL,
  `firstname` varchar(64) NOT NULL,
  `lastname` varchar(64) NOT NULL,
  `gender` char(1) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `program_id` int(11) DEFAULT NULL,
  `c_year` int(11) DEFAULT NULL,
  `c_semester` int(11) DEFAULT NULL,
  `nk_full_name` varchar(255) DEFAULT NULL,
  `nk_relationship` varchar(255) DEFAULT NULL,
  `nk_phone_number` varchar(15) DEFAULT NULL,
  `nk_email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`regnumber`, `firstname`, `lastname`, `gender`, `age`, `program_id`, `c_year`, `c_semester`, `nk_full_name`, `nk_relationship`, `nk_phone_number`, `nk_email`) VALUES
('BAF/23/SS/001', 'ron', 'Mha', NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL),
('BAF/23/SS/002', 'Zon', 'lls', NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL),
('BAF/23/SS/003', 'zondiwe', 'mha', NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL),
('BAF/23/SS/004', 'aubrey', 'ron', NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL),
('BME/23/SS/001', 'John ', 'D', 'M', NULL, 6, NULL, NULL, 'snsn', 'Father', '099', 'bit-mmuva@poly.ac.mw'),
('BME/23/SS/002', 'esmie', 'luh', NULL, NULL, 6, NULL, NULL, NULL, NULL, NULL, NULL),
('BME/23/SS/003', 'ken', 'renda', NULL, NULL, 6, NULL, NULL, NULL, NULL, NULL, NULL),
('MIS/23/SS/001', 'Madalitso', 'Mkavea', 'M', NULL, 1, NULL, NULL, 'Elton', 'Father', '0988', 'dad@mail.com'),
('MIS/23/SS/002', 'olivia', 'mka', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL),
('MIS/23/SS/003', 'Martin', 'K', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assessments`
--
ALTER TABLE `assessments`
  ADD PRIMARY KEY (`assessment_id`),
  ADD KEY `FK_AssessmentType` (`name`),
  ADD KEY `FK_AssessmentProgram` (`program_id`),
  ADD KEY `FK_AssessmentModule` (`module_code`),
  ADD KEY `FK_AssessmentLecturer` (`lecturer_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `grades`
--
ALTER TABLE `grades`
  ADD PRIMARY KEY (`id`),
  ADD KEY `regnumber` (`regnumber`),
  ADD KEY `module_code` (`module_code`);

--
-- Indexes for table `lecturers`
--
ALTER TABLE `lecturers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_LecturerDept` (`department`);

--
-- Indexes for table `lecturer_module`
--
ALTER TABLE `lecturer_module`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_LecturerModule_Lecturer` (`lecturer_id`),
  ADD KEY `FK_LecturerModule_Module` (`module_code`);

--
-- Indexes for table `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`code`),
  ADD KEY `FK_ModuleDepartment` (`department_id`),
  ADD KEY `FK_ModuleProgram` (`program_id`);

--
-- Indexes for table `programs`
--
ALTER TABLE `programs`
  ADD PRIMARY KEY (`program_id`),
  ADD KEY `FK_ProgramDept` (`dept`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`regnumber`),
  ADD KEY `FK_StudentProgram` (`program_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assessments`
--
ALTER TABLE `assessments`
  MODIFY `assessment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `grades`
--
ALTER TABLE `grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `lecturers`
--
ALTER TABLE `lecturers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `lecturer_module`
--
ALTER TABLE `lecturer_module`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `programs`
--
ALTER TABLE `programs`
  MODIFY `program_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assessments`
--
ALTER TABLE `assessments`
  ADD CONSTRAINT `FK_AssessmentLecturer` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturers` (`id`),
  ADD CONSTRAINT `FK_AssessmentModule` FOREIGN KEY (`module_code`) REFERENCES `modules` (`code`),
  ADD CONSTRAINT `FK_AssessmentProgram` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`);

--
-- Constraints for table `grades`
--
ALTER TABLE `grades`
  ADD CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`regnumber`) REFERENCES `students` (`regnumber`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `grades_ibfk_2` FOREIGN KEY (`module_code`) REFERENCES `modules` (`code`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `lecturers`
--
ALTER TABLE `lecturers`
  ADD CONSTRAINT `FK_LecturerDept` FOREIGN KEY (`department`) REFERENCES `departments` (`id`);

--
-- Constraints for table `lecturer_module`
--
ALTER TABLE `lecturer_module`
  ADD CONSTRAINT `FK_LecturerModule_Lecturer` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturers` (`id`),
  ADD CONSTRAINT `FK_LecturerModule_Module` FOREIGN KEY (`module_code`) REFERENCES `modules` (`code`);

--
-- Constraints for table `modules`
--
ALTER TABLE `modules`
  ADD CONSTRAINT `FK_ModuleDepartment` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  ADD CONSTRAINT `FK_ModuleProgram` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`);

--
-- Constraints for table `programs`
--
ALTER TABLE `programs`
  ADD CONSTRAINT `FK_ProgramDept` FOREIGN KEY (`dept`) REFERENCES `departments` (`id`);

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `FK_StudentProgram` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
