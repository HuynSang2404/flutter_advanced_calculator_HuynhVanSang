# Máy Tính Nâng Cao Flutter

## Video Demo

<video src="https://github.com/HuynSang2404/flutter_advanced_calculator_HuynhVanSang/raw/main/ScreenRecording.mp4" controls width="100%">
  Video demo ứng dụng máy tính
</video>

[Tải video ](https://github.com/HuynSang2404/flutter_advanced_calculator_HuynhVanSang/raw/main/ScreenRecording.mp4)


## Ảnh Chụp Màn Hình

#### Test Case 1: Biểu Thức Phức Tạp
![Test Case 1](screenshots/01_complex_expression.png)

#### Test Case 2: Tính Toán Khoa Học
![Test Case 2](screenshots/02_scientific_sin_cos_deg.png)

#### Test Case 3: Chức Năng Bộ Nhớ
![Test Case 3](screenshots/03_memory_operations.png)

#### Test Case 4: Tính Toán Liên Tiếp
![Test Case 4](screenshots/04_chain_calculations.png)

#### Test Case 5: Ngoặc Lồng Nhau
![Test Case 5](screenshots/05_nested_parentheses.png)

#### Test Case 6: Hàm Khoa Học Kết Hợp
![Test Case 6](screenshots/06_mixed_scientific.png)

#### Test Case 7: Chế Độ Lập Trình Viên
![Test Case 7](screenshots/07_programmer_hex_and.png)

---

## Mô Tả Dự Án

Ứng dụng máy tính nâng cao được phát triển bằng Flutter, hỗ trợ ba chế độ tính toán: Cơ Bản, Khoa Học và Lập Trình Viên.

## Tính Năng Chính

- **Chế độ Cơ Bản**: Các phép tính số học cơ bản (+, -, ×, ÷, %)
- **Chế độ Khoa Học**: Hàm lượng giác, logarit, lũy thừa, hằng số (π, e)
- **Chế độ Lập Trình Viên**: Chuyển đổi hệ số (HEX, DEC, BIN), phép toán bitwise
- Lưu lịch sử tính toán và cài đặt
- Hỗ trợ cử chỉ (vuốt, nhấn giữ, chụm)
- Giao diện Light/Dark mode
- Chức năng bộ nhớ (M+, M-, MR, MC)

## Công Nghệ

- Flutter SDK >=3.0.0
- Provider pattern để quản lý trạng thái
- SharedPreferences để lưu trữ dữ liệu
- Math expressions parser

## Cài Đặt

```bash
git clone https://github.com/HuynSang2404/flutter_advanced_calculator_HuynhVanSang.git
cd flutter_advanced_calculator_HuynhVanSang
flutter pub get
flutter run
```

## Tác Giả

**Huỳnh Văn Sang** - [@HuynSang2404](https://github.com/HuynSang2404)
