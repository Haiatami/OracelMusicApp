CREATE TABLE artists(
    artist_id NUMBER,-- ID của nghệ sĩ
    email VARCHAR(100),-- Địa chỉ email của nghệ sĩ
    country VARCHAR2(50),
    artist_name NVARCHAR2(100),-- Tên nghệ sĩ
    description NVARCHAR2(500), -- Mô tả về nghệ sĩ 
    artist_type VARCHAR2(50) NOT NULL, -- Loại nghệ sĩ: "composer" hoặc "performer"
    active NUMBER(1) DEFAULT 1, -- Trạng thái hoạt động của nghệ sĩ (1: active, 0: inactive)
    date_created DATE NOT NULL -- Ngày tạo nghệ sĩ trong hệ thống
);

DESCRIBE artists;

CREATE TABLE songs(
   song_id NUMBER,
   song_name NVARCHAR2(100),-- Tên bài hát
   duration NUMBER, -- Thời lượng bài hát
   released_date DATE,-- Ngày phát hành bài hát
   lyrics CLOB, -- Lời của bài hát  
   --CLOB (Character Large Object) được sử dụng để lưu trữ dữ liệu dạng văn bản có kích thước lớn,
   mp3_path VARCHAR2(200) -- Đường dẫn tới file MP3
);

DESCRIBE songs;

--Đổi tên bảng
--ALTER TABLE songs RENAME TO bai_hat;
ALTER TABLE bai_hat RENAME TO songs;
/*
Tên bảng ko chứa ký tự đặc biệt, phản ánh rõ nội dung
Tên bảng là danh từ, ko chứa từ khóa SQL như SELECT, INSERT, UPDATE, DELETE,...
Tên bảng không phân biệt chữ hoa và chữ thường trong Oracle. 
Tên bảng phải là duy nhất trong cơ sở dữ liệu. 
Không thể có hai bảng trong cùng một cơ sở dữ liệu có cùng tên.
*/

--Xoá bảng + toàn bộ dữ liệu trong bảng(rất thận trọng)
DROP TABLE songs;
/*
Sau khi thực thi lệnh này, 
bảng "songs" sẽ bị xóa khỏi cơ sở dữ liệu Oracle của bạn. 
Tất cả dữ liệu bên trong bảng cũng sẽ bị xóa đi và không thể khôi phục lại được.
*/

INSERT INTO artists(
    artist_id, 
    email, 
    country, 
    artist_name, 
    description, 
    artist_type, 
    active, 
    date_created)
VALUES(1, 
'a@gmail.com', 
'Việt Nam', 
N'Nguyễn Thị A', 
'Nghệ sĩ nổi tiếng với sự sáng tạo và phong cách biểu diễn độc đáo.', 
'performer', 
1, 
SYSDATE);

INSERT INTO artists(
    artist_id, 
    email, 
    country, 
    artist_name, 
    description, 
    artist_type, 
    active, 
    date_created)
VALUES(2, 
'b@gmail.com', 
'Việt Nam', 
N'Nguyễn Thị A', 
'Nghệ sĩ với khả năng biểu diễn sân khấu ấn tượng và giọng hát mạnh mẽ.', 
'performer', 
0, 
SYSDATE);

--Kiểm tra xem dữ liệu đã vào chưa
SELECT * FROM artists;

--Phát hiện thêm nhầm, xoá đi thêm lại
DELETE FROM artists WHERE email='b@gmail.com';

--THÊM DỮ LIỆU NULL ?
INSERT INTO artists(
    artist_id, 
    email, 
    country, 
    artist_name, 
    description, 
    artist_type, 
    active, 
    date_created)
VALUES(3, 
    NULL, 
    'Việt Nam', 
    N'Thanh Vân', 
    'This is test info',
    'composer', 
    0,
    SYSDATE
);

/*
Trong Oracle, bạn có thể đặt các ràng buộc (constraints) cho các thuộc tính 
(cột) trong một bảng để đảm bảo tính nhất quán và độ chính xác của dữ liệu.
-NOT NULL: Một cột không thể chứa giá trị NULL
*/


INSERT INTO songs(song_id, song_name, duration, released_date, lyrics,mp3_path)
VALUES(
    1, 
    N'Yêu thương mộng mơ', 
    240, 
    TO_DATE('2024-01-01', 'YYYY-MM-DD'), 
    N'Trong ánh mắt em là yêu thương mộng mơ, em là nắng trong anh.',
    'yeuthuongmongmo.mp3'
);

ALTER TABLE songs
MODIFY song_name NOT NULL;

--Thêm ràng buộc UNIQUE cho cột song_name
ALTER TABLE songs
ADD CONSTRAINT unq_song_name UNIQUE(song_name)

-- Thêm ràng buộc CHECK cho cột duration, thời lượng không quá 600 giây
ALTER TABLE songs
ADD CONSTRAINT chk_duration 
CHECK(duration <= 600);

ALTER TABLE songs
DROP CONSTRAINT chk_duration;

DELETE FROM songs WHERE song_id=2;

--Thêm ràng buộc CHECK cho cột released_date, 
--ngày phát hành phải trong khoảng từ 1 năm trước đến 1 năm sau ngày hiện tại
ALTER TABLE songs
ADD CONSTRAINT chk_released_date
CHECK (released_date BETWEEN ADD_MONTHS(SYSDATE, -12) AND ADD_MONTHS(SYSDATE, 12));

-- Đặt giá trị mặc định cho cột lyrics là "No content"
ALTER TABLE songs
MODIFY lyrics DEFAULT 'No content';

--thử test xem nào
INSERT INTO songs(song_id, song_name, duration, released_date)
VALUES(
    2, 
    N'Là Anh', 
    500, 
    TO_DATE('2023-05-30', 'YYYY-MM-DD')    
);
SELECT * FROM songs;

-- Đặt giá trị mặc định cho cột mp3_path là ""
ALTER TABLE songs
MODIFY mp3_path DEFAULT ' ';

--Các ràng buộc Primary Key và Foreign Key. Quan hệ 1-n(one to many)
--1 nghệ sĩ có thể sáng tác 1 hoặc nhiều bài hát
--quan hệ giữa artists và songs là 1-n
--vậy là trong bảng songs phải có trường artist_id
--hiện bảng songs chưa có cột artist_id nên phải thêm vào
ALTER TABLE artists
ADD CONSTRAINT pk_artists PRIMARY KEY(artist_id);

-- Thêm cột artist_id để chuẩn bị phong làm khoá ngoại
ALTER TABLE songs
ADD artist_id NUMBER;

--phong cột artist_id trong bảng songs thành Foreign Key
ALTER TABLE songs
ADD CONSTRAINT fk_artists FOREIGN KEY(artist_id)
REFERENCES artists(artist_id); -- Khóa ngoại tham chiếu tới bảng ARTISTS

--Xoá các ràng buộc(ko làm mất dữ liệu)
-- ALTER TABLE songs DROP CONSTRAINT fk_artists;
-- ALTER TABLE artists DROP CONSTRAINT pk_artists;
-- ALTER TABLE songs DROP CONSTRAINT pk_songs;