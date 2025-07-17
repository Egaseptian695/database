-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 17, 2025 at 10:11 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `simple_php_mvc`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_abandoned_carts` ()   BEGIN
    SELECT 
        u.email,
        u.username,
        COUNT(DISTINCT ci.product_id) AS items_in_cart,
        SUM(p.price * ci.quantity) AS potential_revenue,
        DATEDIFF(NOW(), MAX(ci.created_at)) AS days_abandoned,
        GROUP_CONCAT(p.name SEPARATOR ', ') AS abandoned_books
    FROM cart_items ci
    JOIN users u ON ci.user_id = u.id
    JOIN products p ON ci.product_id = p.id
    WHERE NOT EXISTS (
        SELECT 1 
        FROM transactions t
        JOIN transaction_items ti ON t.id = ti.transaction_id
        WHERE t.user_id = ci.user_id 
        AND ti.product_id = ci.product_id
        AND t.created_at > ci.created_at
    )
    AND DATEDIFF(NOW(), ci.created_at) > 7
    GROUP BY u.id
    HAVING potential_revenue > 10000
    ORDER BY potential_revenue DESC;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `book_recommendations`
-- (See below for the actual view)
--
CREATE TABLE `book_recommendations` (
`user_id` int(11)
,`recommended_book_id` int(11)
,`recommended_book_name` varchar(255)
,`image` varchar(255)
,`pembeli_serupa` bigint(21)
,`harga_rekomendasi` decimal(14,6)
);

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart_items`
--

INSERT INTO `cart_items` (`id`, `user_id`, `product_id`, `quantity`, `created_at`) VALUES
(9, 12, 13, 1, '2024-12-01 03:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `image` varchar(255) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `year` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `user_id`, `name`, `description`, `price`, `quantity`, `created_at`, `updated_at`, `image`, `type`, `year`) VALUES
(10, 2, 'Berserk Volume 1 Series', 'Diciptakan oleh Kentaro Miura, Berserk adalah kekacauan manga yang ekstrem - keras, mengerikan, dan tanpa ampun lucu - dan sumber untuk seri anime yang populer secara internasional. Bukan untuk mual atau mudah tersinggung, Berserk tidak meminta seperempat - dan tidak menawarkan apa pun', 50000.00, 1, '2025-06-23 09:36:25', '2025-06-23 09:36:25', 'img_6859201974e83.jpg', 'manga', 2003),
(11, 2, 'Initial D Vol. 1', 'Hantu Gunung Akina Tak Fujiwara menghabiskan banyak waktu di belakang kemudi. Pekerjaannya sebagai pengantar tahu membawanya berpacu di jalanan Gunung Akina yang berbahaya, dan tanpa menyadarinya, Tak telah menguasai teknik balap yang membutuhkan waktu seumur hidup bagi sebagian besar pengemudi untuk mempelajarinya. Tentu saja, tidak ada satu pun temannya yang menyadari hal ini. Mereka semua terlalu sibuk menonton Akina Speed ​​Stars, tim balap jalanan lokal. Ketika Red Suns yang legendaris muncul untuk menantang Speed ​​Stars, mobil itu tampak seperti Trueno Eight Six yang telah terlihat berpacu di jalanan pegunungan. Pertanyaannya tetap ... siapa pengemudi mobil hantu ini?', 70000.00, 1, '2025-06-23 13:26:06', '2025-06-23 13:26:06', 'img_685955eea8402.jpg', 'manga', 1995),
(12, 2, 'Detektif Conan Shinichi Kudo Selection Vol. 01', 'Di antara jenis buku lainnya, komik memang disukai oleh semua kalangan mulai dari anak kecil hingga orang dewasa. Alasan komik lebih disukai oleh banyak orang karena disajikan dengan penuh dengan gambar dan cerita yang mengasyikan sehingga mampu menghilangkan rasa bosan di kala waktu senggang.\r\n\r\nKomik seringkali dijadikan sebagai koleksi dan diburu oleh penggemarnya karena serinya yang cukup terkenal dan kepopulerannya terus berlanjut sampai saat ini. Dalam memilih jenis komik, ada baiknya perhatikan terlebih dahulu ringkasan cerita komik di sampul bagian belakang sehingga sesuai dengan preferensi pribadi pembaca.', 75000.00, 1, '2025-06-23 13:32:54', '2025-06-23 13:32:54', 'img_6859578685907.jpg', 'komik', 2023),
(13, 2, 'Kamus Bahasa Inggris', 'Kamus Bahasa Inggris dari indo ke inggris', 40000.00, 1, '2025-06-23 17:35:17', '2025-06-23 17:35:17', 'img_68599054f41df.jpg', 'kamus', 2020),
(14, 8, 'Novel Dilan 2:Dia Adalah Dilanku Tahun 1991', 'Jika aku berkata bahwa aku mencintainya, maka itu adalah sebuah pernyataan yang sudah cukup lengkap.&quot;&quot;\r\n-Milea\r\n&quot;&quot;Senakal-nakalnya anak geng motor, Lia, mereka shalat pada waktu ujian praktek Agama.&quot;&quot;\r\n-Dilan\r\n\r\n@Viny_JKT48 &quot;&quot;Aku suka Dilan-nya Kak Pidi Baiq. Baru beli, tapi sudah aku baca dua kali lho~ Buku yang menyenangkan, jadi ingin kenal Dilan XD.&quot;&quot;\r\n@renindydevris &quot;&quot;Kukira cinta hanya sebatas kenal, bilang, dan jadi. Tetapi ternyata cinta itu bisa dibuat jadi seni yang amat menarik.&quot;&quot;\r\n@yusuf_imam29 &quot;&quot;Terima kasih, Dilan. Dirimu telah mengajarkanku tentang banyak hal. Terutama tentang mengistimewakan wanita.&quot;&quot;\r\n@IanisJanuar &quot;&quot;Selama hampir 27 tahun hidup, baru pertama kali baca novel sampe tamat. Thank You, Dilan.&quot;&quot;\r\n@rudijatjahja &quot;&quot;Hatur nuhun Surayah Pidi Baiq, sudah merawat selera tawa yang dibalut kisah bahagia dua sejoli Dilan dan Milea.&quot;&quot;\r\n@alirohman21 &quot;&quot;Bukan hanya novel tentang cinta remaja biasa, tapi juga cara mengungkapkan rasa sayang di luar kebiasaan.&quot;&quot;\r\n@saljuapi &quot;&quot;The greatest love story the world has ever known.&quot;&quot;\r\n@Tedy_Pensil &quot;&quot;Jika buku ini kumpulan rumus Fisika yang akan diujikan maka banyak pelajar yang membakarnya dan mengonsumsi abunya.', 99000.00, 1, '2025-06-24 05:33:03', '2025-06-24 05:33:03', 'img_685a388f2a54e.jpg', 'novel', 2015),
(15, 8, 'Kumpulan Cerpen: Di Tengah Kegelapan Inuvik', '&quot;Ompung, saat ini Fibri berada di Inuvik di tepi sungai Mackenzie Northwest District yang jaraknya 150 kilo meter dari Snag. Kota ini unik dan Fibri ke Kota kecil ini atas saran Purser Concordia. Dalam satu tahun Matahari hanya memperlihatkan dirinya selama 11 bulan di kota ini setelah itu dia tidur satu bulan. Kota pun gelap. ini berlangsung sejak awal Desember hingga awal Januari. Fibri masuk ke kota ini pertengahan Desember, berarti selama lima belas hari Fibri ikut bergelap-gelap karena tidak melihat matahari. Anehnya, Ompung. Kota yang hanya berpenduduk 4000 orang ini diberi julukan &#039;medan laki-laki&#039;, Fibri tidak tahu apa maksudnya. Mungkin kata itu bermakna, mayoritas penduduk kota ini adalah laki-laki.”\r\n\r\nBuku Kumpulan Cerpen: Di Tengah Kegelapan Inuvik merupakan buku yang ditulis oleh Sori Siregar. Sori Siregar adalah pengarang yang telah menulis sejak 1960. Mendapat trofi “Kesetiaan Berkarya” dari harian Kompas. Cerita pendeknya banyak tersebar di harian Kompas dan majalah Horison. Baginya, menulis adalah memberi kenyamanan, kesehatan, dan pencerahan. Beberapa cerpennya terpilih dalam buku Cerpen Pilihan Kompas. Buku ini berisikan kumpulan-kumpulan cerita pendek (cerpen) yang mengisahkan tentang kehidupan di dalam kegelapan yang terjadi dalam sebuah tempat yang cukup unik, tempat tersebut bernama kota Inuvik. Kegelapan disini hanya penggambaran dari situasi sebenarnya yang sedang terjadi dalam kota tersebut. Bagaimanakah cerita-cerita tersebut? Baca dan ikuti bukunya!', 59000.00, 1, '2025-06-24 15:04:24', '2025-06-25 11:35:23', 'img_685abe78e536f.jpg', 'cerpen', 2019),
(17, 8, 'Novel Milea Suara Dari Dilan', '“Dilan memberi penggambaran lain dari sebuah penaklukan cinta &amp; bagaimana indahnya cinta sederhana anak zaman dahulu.” @refaniris\r\n“Cuma satu yang kuinginkan, aku ingin cowok seperti Dilan.” @_SLovaFC\r\n“Dilan brengsek! Dia selalu tahu caranya menjadi pusat perhatian, bahkan ketika jadi buku, setiap serinya selalu ditunggu.” @Tedy_Pensil\r\n“Membaca Dilan itu seperti jatuh cinta lagi, lagi, dan lagi. Ah, indah, deh. Rasanya gak akan pernah bosan membacanya.” @agungwyd\r\n“Bukan cuma sekadar novel, tapi bisa menjadikan yang malas baca jadi mau baca.” @cobra_iqq\r\n“Kisah cintanya gak lebay. Dilan tahu bagaimana memperlakukan wanita. Novelnya keren, bahasanya gak bertele-tele.” @AH_DILAN\r\n“Terima kasih Dilan telah menginspirasiku lewat ceritamu bersama Milea. Terima kasih Surayah, novelmu seru.” @EnciSrifiyani\r\n“Dari Dilan kita belajar mengistimewakan wanita, romantis yang gak kuno, bahkan menjadi ayah &amp; bunda yang hebat :)” @ginaalna\r\n“Kurasa Dilan satu-satunya novel yang aku harap ceritanya terus berlanjut, dan tidak ingin ada akhir.” @TriaFitriaN41', 89000.00, 1, '2025-06-25 15:40:00', '2025-06-25 15:40:00', 'img_685c185085fbf.jpg', 'novel', 2020),
(18, 8, 'Ancika: Dia Yang Bersamaku Tahun 1995', 'Deskripsi\r\nAncika: Dia Yang Bersamaku Tahun 1995 menceritakan tentang persahabatan antara Dilan dan Ancika Mehrunisa Rabu. Hubungan mereka yang semakin dekat membuat benih-benih cinta tumbuh dan hubungan mereka pun naik tingkat menjadi hubungan sepasang kekasih. Ancika merupakan gadis cantik yang memiliki sifat tegas, rajin, dan memiliki pendirian yang kuat. Novel ini menceritakan kelanjutan hidup Dilan setelah putus dengan Milea dan bertemu dengan orang-orang baru yang membuat Dilan menjadi lebih dewasa dari sebelumnya. Novel ini mengajarkan bahwa hubungan antara manusia yang sehat adalah tidak ada satu pihak yang mendominasi, mereka tumbuh bersama dan saling menghargai keputusan masing-masing.\r\n\r\nSinopsis\r\n\r\n“Dia memang punya masa lalu, tetapi saya punya Dilan.” —Ancika\r\n\r\nAncika ini, pacarnya Dilan. Mereka saling mengenal setelah Dilan sudah tidak lagi sama Lia. Ya, gitu deh, drama kehidupan namanya juga. Mau bagaimana lagi? Kita ini hanya manusia. Pokoknya, baca aja, deh. Mudah-mudahan menyenangkan.\r\n\r\nAncika akan menceritakan kisahnya bersama Dilan ketika Ancika berumur 17 tahun dan masih seorang siswi SMA. Dilan sendiri, saat itu, sedang berkuliah di ITB. Sosok Ancika tidak kalah menarik daripada Dilan. Dilan dan Ancika seolah-olah memang diciptakan untuk saling mengisi dan saling melengkapi satu sama lain. Apakah Ancika adalah alasan satu-satunya mengapa Dilan tidak bisa balikan dengan Milea? Baca kisah lengkap Ancika di dalam novel ini!\r\n\r\nSeri lainnya:\r\n\r\n- Dilan: Dia Adalah Dilanku Tahun 1990\r\n- Dilan Bagian Kedua: Dia Adalah Dilanku Tahun 1991\r\n- Milea: Suara Dari Dilan\r\n- Ancika: Dia yang Bersamaku Tahun 1995\r\n\r\nKeterangan\r\n\r\nJumlah Halaman : 344\r\nPenerbit : Pastel Books\r\nTanggal Terbit : 3 Sep 2021\r\nBerat : 0.32 kg\r\nISBN : 9786026716897\r\nLebar : 14 cm\r\nPanjang : 21 cm\r\nBahasa : Indonesia', 98000.00, 1, '2025-06-25 15:41:31', '2025-06-25 15:41:31', 'img_685c18ab29d49.jpg', 'novel', 2021),
(19, 8, 'Jujutsu Kaisen 02', 'Di antara jenis buku lainnya, komik memang disukai oleh semua kalangan mulai dari anak kecil hingga orang dewasa. Alasan komik lebih disukai oleh banyak orang karena disajikan dengan penuh dengan gambar dan cerita yang mengasyikan sehingga mampu menghilangkan rasa bosan di kala waktu senggang. Komik seringkali dijadikan sebagai koleksi dan diburu oleh penggemarnya karena serinya yang cukup terkenal dan kepopulerannya terus berlanjut sampai saat ini. Dalam memilih jenis komik, ada baiknya perhatikan terlebih dahulu ringkasan cerita komik di sampul bagian belakang sehingga sesuai dengan preferensi pribadi pembaca.\r\n\r\nKomik Jujutsu Kaisen 2 karya Gege Akutami menjadi salah satu komik yang wajib untuk diikuti. Sebuah kutukan yang menyerupai janin tiba-tiba muncul di lapas anak pria. Itadori dan murid tahun pertama lainnya diutus untuk menyelamatkan orang-orang yang masih berada di lapas tersebut. Akan tetapi, janin yang telah bermetamorfosis menjadi kutukan tingkat tinggi itu melancarkan serangannya sehingga Itadori dkk berada dalam bahaya. Itadori kemudian bertukar dengan Sukuna untuk mengalahkan kutukan tersebut, tapi...!? Yuk, mulai ikuti dan simak serial komik ini dengan konsep pertarungan unik dan epik.\r\n\r\nInformasi lain:\r\nJudul Buku: Jujutsu Kaisen 2\r\nPenulis: Gege Akutami\r\nJumlah Halaman: 200\r\nTanggal Terbit: 1 April 2021\r\nISBN: 9786230024399\r\nBahasa: Indonesia\r\nPenerbit: Elex Media Komputindo\r\nBerat: 0.13 kg\r\nLebar: 12 cm\r\nPanjang: 18 cm', 34000.00, 1, '2025-06-25 15:46:18', '2025-06-25 15:46:18', 'img_685c19cabbda2.jpg', 'manga', 2021),
(20, 23, 'Bobo Edisi 24', 'Sampul\r\nFauna: Sugar Gluder, Si Imut yang Hobi Terbang Meluncur\r\nMenu Bobo\r\nBoleh Tahu\r\nArena Kecil\r\nHalamanku\r\nAdopsi Kucing\r\nDongeng: Tarian Peri Bintang\r\nPengetahuan: Cara Asyik Menata Koleksi Buku\r\nKreatif: Wadah Buku\r\nProfil: Yusuf, Lestarikan Wayang dengan Mendalang\r\nWow: Perpustakaan-perpustakaan Unik di Dunia\r\nCerpen: Perpustakaan Luna\r\nCeritera dari Negeri Dongeng: Peliharaan Polkadot\r\nReportasia: Melihat Indahnya Gunung-Gunung Indonesia\r\nKuis Bobo\r\nCerpen: Sepanjang Jalan ke Sekolah\r\nBuku Pilihanku\r\nBona: Skipping Spesial Ola\r\nPin Up: Serian Planet Kerdil (2): Ceres', 20000.00, 1, '2025-07-15 15:33:33', '2025-07-15 15:33:33', 'img_687674cdae094.jpg', 'majalah', 2013);

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `total_amount` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `email` varchar(255) DEFAULT NULL,
  `payment_method` varchar(255) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `shipping_method` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `user_id`, `total_amount`, `created_at`, `email`, `payment_method`, `alamat`, `shipping_method`) VALUES
(1, 11, 99000, '2025-06-25 08:00:57', NULL, NULL, NULL, NULL),
(2, 11, 99000, '2025-06-25 08:04:52', NULL, NULL, NULL, NULL),
(3, 11, 59000, '2025-06-25 10:05:45', NULL, NULL, NULL, NULL),
(4, 11, 59000, '2025-06-25 10:05:58', NULL, NULL, NULL, NULL),
(5, 11, 40000, '2025-06-25 10:10:11', '', '', NULL, NULL),
(6, 11, 59000, '2025-06-25 10:11:32', '', '', NULL, NULL),
(7, 11, 59000, '2025-06-25 10:31:08', '', 'COD', NULL, NULL),
(8, 11, 75000, '2025-06-25 10:39:41', '', 'Transfer Bank', NULL, NULL),
(9, 11, 70000, '2025-06-25 10:41:24', '', 'COD', NULL, NULL),
(10, 11, 70000, '2025-06-25 10:52:07', '', 'COD', NULL, NULL),
(11, 11, 50000, '2025-06-25 10:54:42', '', 'COD', NULL, NULL),
(12, 11, 99000, '2025-06-25 11:01:27', '', 'Transfer Bank', NULL, NULL),
(13, 11, 99000, '2025-06-25 11:02:55', '', 'COD', NULL, 'AnterAja'),
(14, 11, 40000, '2025-06-25 11:04:55', '', 'COD', NULL, 'SiCepat'),
(15, 11, 158000, '2025-06-25 11:05:56', '', 'COD', NULL, 'J&T'),
(16, 11, 70000, '2025-06-25 11:09:41', '', 'COD', NULL, 'SiCepat'),
(17, 11, 75000, '2025-06-25 11:17:01', '', 'Transfer Bank', '', 'JNE'),
(18, 11, 50000, '2025-06-25 11:31:11', 'vitara0992@gmail.com', 'Transfer Bank', 'ajkfjkb', 'JNE'),
(19, 11, 99000, '2025-06-25 11:34:23', 'vitara0992@gmail.com', 'Transfer Bank', 'hvkjh', 'J&T'),
(20, 11, 187000, '2025-06-25 17:41:51', 'vitara0992@gmail.com', 'Transfer Bank', 'sadad', 'SiCepat'),
(21, 11, 187000, '2025-06-25 18:03:04', 'nopal2@gmail.com', 'COD', 'kon', 'J&T'),
(22, 11, 89000, '2025-06-25 18:04:33', 'nopal2@gmail.com', 'COD', 'kon', 'JNE'),
(23, 11, 98000, '2025-06-26 02:30:02', 'vitara0992@gmail.com', 'COD', 'jember', 'JNE'),
(24, 11, 80000, '2025-07-02 09:19:22', 'nopal2@gmail.com', 'COD', 'jember\r\n', 'J&T'),
(25, 11, 70000, '2025-07-13 06:25:03', 'nopal2@gmail.com', 'Transfer Bank', 'jember\r\n', 'JNE'),
(26, 21, 98000, '2025-07-13 08:07:04', 'wisnu12@gmail.com', 'COD', 'surabaya\r\n', 'SiCepat'),
(27, 11, 34000, '2025-07-14 14:26:07', 'nopal2@gmail.com', 'COD', 'jember\r\n', 'J&T'),
(28, 21, 335000, '2025-07-14 14:26:36', 'wisnu12@gmail.com', 'COD', 'surabaya\r\n', 'J&T'),
(29, 11, 68000, '2025-07-15 06:53:57', 'vitara0992@gmail.com', 'COD', 'tu', 'J&T'),
(30, 11, 34000, '2025-07-15 12:24:36', 'vitara0992@gmail.com', 'COD', 'naj', 'J&T'),
(31, 21, 34000, '2025-07-15 12:25:18', 'wisnu12@gmail.com', 'COD', 'indo\r\n', 'SiCepat'),
(32, 22, 197000, '2025-07-15 12:27:12', 'budi123@gmail.com', 'COD', 'jember\r\n', 'SiCepat');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_items`
--

CREATE TABLE `transaction_items` (
  `id` int(11) NOT NULL,
  `transaction_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction_items`
--

INSERT INTO `transaction_items` (`id`, `transaction_id`, `product_id`, `quantity`, `price`) VALUES
(1, 1, 14, 1, 99000),
(2, 2, 14, 1, 99000),
(3, 3, 15, 1, 59000),
(4, 4, 15, 1, 59000),
(5, 5, 13, 1, 40000),
(6, 6, 15, 1, 59000),
(7, 7, 15, 1, 59000),
(8, 8, 12, 1, 75000),
(9, 9, 11, 1, 70000),
(10, 10, 11, 1, 70000),
(11, 11, 10, 1, 50000),
(12, 12, 14, 1, 99000),
(13, 13, 14, 1, 99000),
(14, 14, 13, 1, 40000),
(15, 15, 14, 1, 99000),
(16, 15, 15, 1, 59000),
(17, 16, 11, 1, 70000),
(18, 17, 12, 1, 75000),
(19, 18, 10, 1, 50000),
(20, 19, 14, 1, 99000),
(21, 20, 18, 1, 98000),
(22, 20, 17, 1, 89000),
(23, 21, 18, 1, 98000),
(24, 21, 17, 1, 89000),
(25, 22, 17, 1, 89000),
(26, 23, 18, 1, 98000),
(27, 24, 13, 2, 40000),
(28, 25, 11, 1, 70000),
(29, 26, 18, 1, 98000),
(30, 27, 19, 1, 34000),
(31, 28, 18, 2, 98000),
(32, 28, 17, 1, 89000),
(33, 28, 10, 1, 50000),
(34, 29, 19, 2, 34000),
(35, 30, 19, 1, 34000),
(36, 31, 19, 1, 34000),
(37, 32, 18, 1, 98000),
(38, 32, 14, 1, 99000);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','penjual','pembeli') NOT NULL DEFAULT 'penjual',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `created_at`) VALUES
(2, 'admin', NULL, '$2y$10$Sys2jKvdjVVTtqpJ2TG92eREUyoKos4oWEio9S5AHB7QdGvx032MK', 'admin', '2025-06-01 07:13:21'),
(8, 'dodi', NULL, '$2y$10$ckhPYXi41rCC0/c6vCjrC.aGyDIjDQL1VnRM/YFyNf.okXF8bbqAy', 'penjual', '2025-06-20 07:52:19'),
(11, 'egaa', NULL, '$2y$10$KCUWMDRjEoqpIVbrU.djNeiReIeIWqvGnNcq9YI/tjx50buG5Vtta', 'pembeli', '2025-06-25 05:57:28'),
(12, 'naruto', NULL, '$2y$10$oYKDZjCKgfVkAghwYs2M.OXJwEhp.oHCwZHRR36vR237/IZIMCGwS', 'pembeli', '2025-06-25 08:06:27'),
(17, 'noval', 'nopal@gmail.com', '$2y$10$a4xGogEyq07CXonb4THbg.8VOtuQIue56aVVuoi1psVDGZiSwGhi6', 'pembeli', '2025-06-25 15:29:52'),
(18, 'novalll', 'nopal22@gmail.com', '$2y$10$zaLj7Qigi/OSfJF3JYSDuuS5lepBUK7Abzw1V9BepOUWV8GVVwpcq', 'pembeli', '2025-06-25 17:47:48'),
(19, 'wisnu', 'wisnuuu@gmail.com', '$2y$10$fBeK1abxK1lKr2NLN/.BY.onp9o8ibogTpJduGqjDcTs.MY5fW1rS', 'penjual', '2025-06-26 01:33:23'),
(20, 'jack', 'jackky@gmail.com', '$2y$10$57oDYTu5jsBOnoBvV8vQBuwShEBor1gcsKR0SfxjilNel7gJQv7xW', 'penjual', '2025-06-26 01:35:31'),
(21, 'wisnuu', 'wisnu12@gmail.com', '$2y$10$3mPKx/.wZ2fq0bWtGuATd.oR7cuswM15NjpaiW2isCyiCQTepthT.', 'pembeli', '2025-07-13 08:06:29'),
(22, 'budi', 'budi123@gmail.com', '$2y$10$FhvX2iFiUmalAn7FGL9iQ.ySudRKCWFkvWm2jKcqX8MCnJAZ/zhYi', 'pembeli', '2025-07-15 07:04:16'),
(23, 'ogah', 'oga123@gmail.com', '$2y$10$6AIpQGbZ6N1EnBW4XxK54e0IiKuiEOvLjtg8juOlK6CBFj1Q.zUaa', 'penjual', '2025-07-15 14:10:41');

-- --------------------------------------------------------

--
-- Structure for view `book_recommendations`
--
DROP TABLE IF EXISTS `book_recommendations`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `book_recommendations`  AS SELECT `u`.`id` AS `user_id`, `p2`.`id` AS `recommended_book_id`, `p2`.`name` AS `recommended_book_name`, `p2`.`image` AS `image`, count(distinct `t2`.`user_id`) AS `pembeli_serupa`, avg(`p2`.`price`) AS `harga_rekomendasi` FROM ((((((`users` `u` join `transactions` `t1` on(`u`.`id` = `t1`.`user_id`)) join `transaction_items` `ti1` on(`t1`.`id` = `ti1`.`transaction_id`)) join `transaction_items` `ti2` on(`ti1`.`product_id` <> `ti2`.`product_id`)) join `transactions` `t2` on(`ti2`.`transaction_id` = `t2`.`id` and `t2`.`user_id` <> `u`.`id`)) join `transaction_items` `ti3` on(`t2`.`id` = `ti3`.`transaction_id` and `ti3`.`product_id` = `ti1`.`product_id`)) join `products` `p2` on(`ti2`.`product_id` = `p2`.`id`)) WHERE !(`p2`.`id` in (select `ti`.`product_id` from (`transactions` `t` join `transaction_items` `ti` on(`t`.`id` = `ti`.`transaction_id`)) where `t`.`user_id` = `u`.`id`)) GROUP BY `u`.`id`, `p2`.`id` HAVING `pembeli_serupa` >= 1 ORDER BY count(distinct `t2`.`user_id`) DESC ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaction_items`
--
ALTER TABLE `transaction_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `transaction_items`
--
ALTER TABLE `transaction_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
