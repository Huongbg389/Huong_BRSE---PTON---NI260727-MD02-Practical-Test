-- Tạo và gọi cơ sở dữ liệu
CREATE DATABASE academic_management;
USE academic_management;

-- Phần 1: Tạo bảng
CREATE TABLE IF NOT EXISTS courses (
  course_id INT PRIMARY KEY AUTO_INCREMENT,
  course_name VARCHAR(100) NOT NULL,
  course_code VARCHAR(20) NOT NULL UNIQUE,
  department VARCHAR(100) NOT NULL,
  creation_date DATE NOT NULL
  );
  
  CREATE TABLE IF NOT EXISTS students (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  fullname VARCHAR (100) NOT NULL,
  major VARCHAR(100) NOT NULL,
  phone_number VARCHAR(15) NOT NULL UNIQUE,
  gpa DECIMAL(3,1) DEFAULT 4.0 CHECK (gpa BETWEEN 0.0 AND 4.0)
  );
  
  CREATE TABLE IF NOT EXISTS enrollments(
  enrollment_id INT  PRIMARY KEY AUTO_INCREMENT,
  enroll_time DATETIME NOT NULL,
  credits INT CHECK (credits > 0),
  status VARCHAR (50) CHECK (status IN ('PENDING', 'COMPLETED', 'DROPPED')),
  course_id INT,
  student_id INT,
  FOREIGN KEY (course_id) REFERENCES courses(course_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id)
  );
  
  CREATE TABLE IF NOT EXISTS enrollment_details(
  detail_id INT PRIMARY KEY AUTO_INCREMENT,
  enrollment_id INT ,
  attendance_check VARCHAR(150) NOT NULL,
  detail_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
  );
  
  CREATE TABLE IF NOT EXISTS academic_logs(
  log_id INT PRIMARY KEY AUTO_INCREMENT,
  enrollment_id INT,
  student_id INT,
  log_time DATETIME NOT NULL,
  note TEXT,
  FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id)
  );
  
  -- Phần 2 - câu 1: Viết câu lệnh INSERT
  INSERT INTO courses (course_name, course_code, department, creation_date)
  VALUE 
  ('Lập trình java', 'JAVA01', 'CNTT', '2023-12-03'),
  ('Cấu trúc dữ liệu', 'DSA02', 'Khoa học máy tính', '1996-11-25'),
  ('Cơ sở dữ liệu', 'SQL03', 'CNTT', '2001-07-08');
  
  INSERT INTO students (fullname, major, phone_number, gpa)
  VALUE 
  ('Nguyễn Văn  Hải', 'Hệ thống TT', '0931112223', '3.8'),
  ('Trần Thu Hà', 'Kỹ thuật PM', '0932223334', '4.0'),
  ('Lê Quốc Tuấn', 'An toàn TT', '0933334445', '3.6');
  
  INSERT INTO enrollments(enrollment_id, course_id, student_id, enroll_time, credits, status)
  VALUE
  ('7001', '1', '1', '2024-05-20 08:00', '3', 'Pending'),
  ('7002', '2', '2', '2024-05-20 09:30', '4', 'Completed'),
  ('7003', '3', '3', '2024-05-20 10:15', '3', 'Pending'),
  ('7004', '3', '3', '2024-05-21 07:00', '3', 'Completed');
  
  INSERT INTO enrollment_details(detail_id, enrollment_id, attendance_check, detail_date)
  VALUE
  ('8001', '7002', 'Đủ điều kiện thi', '2024-05-20 10:00'),
  ('8002', '7004', 'Vắng 1 buổi', '2024-05-21 08:00'),
  ('8003', '7001', 'Đang học', '2024-05-20');
  
  INSERT INTO academic_logs(enrollment_id, student_id, log_time, note)
  VALUE 
  ('7001', '1', '2024-05-20 09:05', 'Bắt dầu lớp học'),
  ('7002', '2', '2024-05-20 10:05', 'Hoàn tất môn học'),
  ('7003', '3', '2024-05-20 11:10', 'Đang sắp xếp lịch bù');
  
  -- Phần 2- UPDATE - DELETE
-- 1. Viết câu lệnh tăng thêm 1 tín chỉ (credits) cho các bản ghi đăng ký học thỏa mãn đồng thời:
-- Có trạng thái “Completed”.
-- Thuộc môn học có năm tạo (creation_date) < 2000.

  SET SQL_SAFE_UPDATES= 1;
  
  UPDATE enrollments e
  JOIN courses c
  ON e.course_id = c.course_id
  SET e.credits = e.credits + 1
  WHERE e.status = 'Compled'
  AND c.creation_date < '2000-01-01';
  
  SELECT * FROM academic_logs
  WHERE log_time < '2024-05-20';
  
  -- 2. Viết câu lệnh xóa các bản ghi trong academic_logs thỏa mãn:
-- Có log_time trước ngày 20/05/2024.

  SET SQL_SAFE_UPDATES = 0;
  DELETE FROM academic_logs
  WHERE log_time < '2024-05-20';
  SET SQL_SAFE_UPDATES = 1;
  
  -- Phần 3 Truy vấn cơ bản
  -- Câu 1: Liệt kê các thông tin sinh viên gồm: fullname, major, gpa của những sinh viên có điểm GPA lớn hơn 3.8 
  -- hoặc thuộc chuyên ngành PM
  
  SELECT fullname, major, gpa
  FROM students
  WHERE gpa > 3.8
  OR major = 'Kỹ thuật PM';
  
  --  Câu 2 : Liệt kê các thông tin môn học gồm course_name và course_code của những môn học có ngày tạo trong
  -- khoảng từ 1998-01-01 đến 2001-12-31 và mã học phần bắt đầu bằng “A”.
  
  SELECT course_name, course_code
  FROM courses
  WHERE  creation_date BETWEEN '1998-01-01' AND '2001-12-31'
  AND course_code LIKE 'A%';

-- Câu 3: Liệt kê các bản ghi đăng ký học gồm enrollment_id, enroll_time và credits, trong đó danh sách được sắp
-- xếp theo số tín chỉ (credits) giảm dần và chỉ hiển thị 2 bản ghi ở trang thứ hai.

  SELECT enrollment_id, enroll_time, credits
  FROM enrollments
  ORDER BY credits DESC
  LIMIT 2 OFFSET 2;
  
  -- Phần 4: Truy vấn nâng cao
-- Câu 1: Liệt kê các thông tin xử lý học vụ gồm tên môn học, họ tên sinh viên, chuyên ngành, số tín chỉ và 
-- thời gian đăng ký, với dữ liệu được lấy từ các bảng liên quan trong hệ thống.

SELECT
  c.course_name,
  s.fullname,
  s.major,
  e.credits,
  e.enroll_time
FROM enrollments e
JOIN students s
ON s.student_id = e.student_id
JOIN courses c
ON e.course_id = c.course_id;

-- Câu 2:Liệt kê các thông tin sinh viên gồm họ tên sinh viên và tổng số tín chỉ mà sinh viên đó đã tích lũy 
-- (chỉ tính các đăng ký trạng thái Completed), chỉ hiển thị những sinh viên có tổng số tín chỉ lớn hơn 120.

SELECT
   s.fullname,
   SUM(e.credits) AS total_credits
FROM students s
JOIN enrollments e
   ON s.student_id = e.student_id
WHERE e.status = 'Completed'
GROUP BY s.student_id, s.fullname
HAVING SUM(e.credits) > 120;

-- Câu 3 : Liệt kê các thông tin sinh viên gồm student_id, full_name và gpa của những sinh viên 
-- có điểm trung bình (GPA) cao nhất.

SELECT student_id, fullname, gpa
FROM students
WHERE gpa = (
          SELECT MAX(gpa)
          FROM students
          );

-- Phần 5: INDEX và VIEW
-- Câu 1 : Tạo một chỉ mục (index) trên bảng enrollments dựa trên hai thông tin là trạng thái học và số tín chỉ 
-- nhằm phục vụ việc tối ưu truy vấn.

CREATE INDEX idx_status_credits
ON enrollments (status, credits);

-- Câu 2 : Tạo một khung nhìn (view) dữ liệu hiển thị họ tên sinh viên, tổng số môn học đã đăng ký và 
-- tổng số tín chỉ mà sinh viên đó đã tích lũy, trong đó không tính các môn bị hủy (Dropped).

CREATE VIEW v_student AS
SELECT
    s.fullname,
    COUNT(e.course_id) AS total_courses,
    SUM(e.credits) AS total_credits
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
WHERE e.status <> 'Dropped'
GROUP BY s.student_id, s.fullname;

SELECT * FROM v_student;




  

  
  
  
  
