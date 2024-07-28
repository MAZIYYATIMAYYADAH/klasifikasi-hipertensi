-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 12, 2024 at 10:24 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.3.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hipertensi`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`) VALUES
(1, 'admin', 'pbkdf2:sha256:600000$c7RPUS4UXyTbIKTp$f4e88c985b1b6e6da7feb86a7c3dda8bf1249dcb77d75b0a1f49b484982a8bcb'),
(3, 'admin1', 'pbkdf2:sha256:600000$JHteKMjKu71AVFMl$898f92ae1e664a17e1aa9972b4ce4070db57867b06f9c9633f73e55306a71292');

-- --------------------------------------------------------

--
-- Table structure for table `detail`
--

CREATE TABLE `detail` (
  `id` int(11) NOT NULL,
  `grade_id` int(11) NOT NULL,
  `saran` text NOT NULL,
  `solusi` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `detail`
--

INSERT INTO `detail` (`id`, `grade_id`, `saran`, `solusi`) VALUES
(48, 1, 'Pertahankan pola makan sehat.', 'Teruskan konsumsi makanan sehat seperti buah-buahan dan sayuran.'),
(49, 1, 'Lakukan aktivitas fisik teratur.', 'Lakukan aktivitas fisik minimal 150 menit per minggu.'),
(50, 1, 'Pantau tekanan darah secara rutin.', 'Rutin memantau tekanan darah untuk memastikan tetap optimal.'),
(51, 1, 'Hindari stres.', 'Kelola stres dengan teknik relaksasi.'),
(52, 2, 'Pertahankan pola hidup sehat.', 'Lanjutkan pola makan sehat dan olahraga teratur.'),
(53, 2, 'Kurangi konsumsi garam.', 'Batasi konsumsi garam untuk menjaga tekanan darah.'),
(54, 2, 'Monitor tekanan darah secara berkala.', 'Lakukan pemeriksaan tekanan darah secara berkala.'),
(55, 2, 'Hindari rokok dan alkohol.', 'Kurangi atau hentikan konsumsi rokok dan alkohol.'),
(56, 3, 'Modifikasi pola makan.', 'Kurangi makanan tinggi lemak dan garam, tingkatkan asupan buah dan sayur.'),
(57, 3, 'Tingkatkan aktivitas fisik.', 'Tingkatkan intensitas dan frekuensi olahraga.'),
(58, 3, 'Kelola berat badan.', 'Usahakan mencapai berat badan ideal.'),
(59, 3, 'Relaksasi dan tidur cukup.', 'Pastikan tidur cukup dan kelola stres dengan baik.'),
(60, 4, 'Konsultasi medis.', 'Mulai berkonsultasi dengan dokter untuk penanganan lebih lanjut.'),
(61, 4, 'Ubah gaya hidup.', 'Implementasikan perubahan signifikan dalam gaya hidup.'),
(62, 4, 'Aktivitas fisik rutin.', 'Lakukan aktivitas fisik secara teratur dengan intensitas yang sesuai.'),
(63, 4, 'Pengurangan stres.', 'Gunakan teknik relaksasi untuk membantu menurunkan tekanan darah.'),
(64, 5, 'Pengobatan.', 'Terima pengobatan sesuai anjuran dokter.'),
(65, 5, 'Monitoring ketat.', 'Pantau tekanan darah secara teratur dan catat hasilnya.'),
(66, 5, 'Perubahan gaya hidup.', 'Terapkan perubahan gaya hidup termasuk diet dan olahraga.'),
(67, 5, 'Konseling dan edukasi.', 'Ikuti program konseling untuk memahami dan mengelola hipertensi.'),
(68, 6, 'Perawatan medis segera.', 'Segera temui dokter atau pergi ke rumah sakit untuk perawatan medis mendesak.'),
(69, 6, 'Pengobatan intensif.', 'Ikuti semua instruksi pengobatan yang diberikan dokter.'),
(70, 6, 'Pola hidup ketat.', 'Terapkan diet ketat rendah garam dan tinggi serat.'),
(71, 6, 'Pemantauan teratur.', 'Pantau tekanan darah secara ketat dan laporkan perubahan kepada dokter.'),
(72, 7, 'Konsultasi dokter.', 'Diskusikan strategi pengelolaan dengan dokter.'),
(73, 7, 'Perubahan diet.', 'Fokus pada diet rendah garam dan tinggi serat.'),
(74, 7, 'Lakukan aktivitas fisik.', 'Lakukan aktivitas fisik teratur dengan pengawasan dokter jika diperlukan.'),
(75, 7, 'Kelola faktor risiko.', 'Identifikasi dan kelola faktor risiko lain seperti diabetes dan obesitas.');

-- --------------------------------------------------------

--
-- Table structure for table `grade`
--

CREATE TABLE `grade` (
  `id` int(11) NOT NULL,
  `cgrade` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `grade`
--

INSERT INTO `grade` (`id`, `cgrade`) VALUES
(1, 'Optimal'),
(2, 'Normal'),
(3, 'High_normal'),
(4, 'Grade_1'),
(5, 'Grade_2'),
(6, 'Grade_3'),
(7, 'Isolated_systemic_hypertension');

-- --------------------------------------------------------

--
-- Table structure for table `hasil_klasifikasi`
--

CREATE TABLE `hasil_klasifikasi` (
  `id` int(11) NOT NULL,
  `age` int(11) NOT NULL,
  `Smoker` int(11) NOT NULL,
  `cigsPerDay` int(11) NOT NULL,
  `BPMeds` int(11) NOT NULL,
  `diabetes` int(11) NOT NULL,
  `totChol` int(11) NOT NULL,
  `SysBP` int(11) NOT NULL,
  `DiaBP` int(11) NOT NULL,
  `heartRate` int(11) NOT NULL,
  `BMI` float NOT NULL,
  `glucose` int(11) NOT NULL,
  `grade_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `hasil_klasifikasi`
--

INSERT INTO `hasil_klasifikasi` (`id`, `age`, `Smoker`, `cigsPerDay`, `BPMeds`, `diabetes`, `totChol`, `SysBP`, `DiaBP`, `heartRate`, `BMI`, `glucose`, `grade_id`, `created_at`) VALUES
(1, 34, 0, 0, 0, 0, 180, 150, 80, 60, 23, 70, 4, '2024-07-11 14:23:30'),
(2, 23, 1, 20, 0, 0, 170, 140, 80, 50, 24, 80, 3, '2024-07-11 15:31:21'),
(3, 60, 1, 60, 1, 1, 200, 120, 90, 40, 20, 80, 6, '2024-07-11 17:01:29'),
(4, 40, 0, 0, 1, 1, 170, 90, 70, 60, 20, 70, 6, '2024-07-11 17:05:53'),
(5, 55, 1, 0, 1, 0, 170, 80, 60, 40, 18, 60, 6, '2024-07-12 14:08:36');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `detail`
--
ALTER TABLE `detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `grade_id` (`grade_id`);

--
-- Indexes for table `grade`
--
ALTER TABLE `grade`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hasil_klasifikasi`
--
ALTER TABLE `hasil_klasifikasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `grade_id` (`grade_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `detail`
--
ALTER TABLE `detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `grade`
--
ALTER TABLE `grade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `hasil_klasifikasi`
--
ALTER TABLE `hasil_klasifikasi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail`
--
ALTER TABLE `detail`
  ADD CONSTRAINT `detail_ibfk_1` FOREIGN KEY (`grade_id`) REFERENCES `grade` (`id`);

--
-- Constraints for table `hasil_klasifikasi`
--
ALTER TABLE `hasil_klasifikasi`
  ADD CONSTRAINT `hasil_klasifikasi_ibfk_1` FOREIGN KEY (`grade_id`) REFERENCES `grade` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
