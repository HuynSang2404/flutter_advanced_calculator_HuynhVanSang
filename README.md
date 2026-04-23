# Máy Tính Nâng Cao - Flutter

Ứng dụng máy tính chuyên nghiệp với 3 chế độ: Cơ bản, Khoa học và Lập trình viên.

## Ảnh Chụp Màn Hình

### Các Kịch Bản Test (Theo Yêu Cầu Lab 3)

#### Test Case 1: Biểu Thức Phức Tạp
**Biểu thức**: `(5 + 3) × 2 - 4 ÷ 2 = 14`

![Test Case 1](screenshots/01_complex_expression.png)

---

#### Test Case 2: Tính Toán Khoa Học (Độ)
**Biểu thức**: `sin(45°) + cos(45°) ≈ 1.414`

![Test Case 2](screenshots/02_scientific_sin_cos_deg.png)

*Lưu ý: Đảm bảo máy tính đang ở chế độ DEG (kiểm tra indicator ở trên cùng)*

---

#### Test Case 3: Chức Năng Bộ Nhớ
**Các bước**: `5 M+ 3 M+ MR = 8`

![Test Case 3](screenshots/03_memory_operations.png)

---

#### Test Case 4: Tính Toán Liên Tiếp
**Biểu thức**: `5 + 3 = + 2 = + 1 = 11`

![Test Case 4](screenshots/04_chain_calculations.png)

---

#### Test Case 5: Ngoặc Lồng Nhau
**Biểu thức**: `((2 + 3) × (4 - 1)) ÷ 5 = 3`

![Test Case 5](screenshots/05_nested_parentheses.png)

---

#### Test Case 6: Hàm Khoa Học Kết Hợp
**Biểu thức**: `2 × π × √9 ≈ 18.85`

![Test Case 6](screenshots/06_mixed_scientific.png)

---

#### Test Case 7: Chế Độ Lập Trình Viên (Hexadecimal)
**Biểu thức**: `0xFF AND 0x0F = 0x0F` (hiển thị là `FF AND F = F`)

![Test Case 7](screenshots/07_programmer_hex_and.png)

*Lưu ý: Trong hệ hexadecimal, `0x0F` và `F` là cùng một giá trị (15 trong hệ thập phân). Máy tính tự động bỏ số 0 ở đầu.*

---

## Kiểm Thử

### Độ Bao Phủ Test
Độ bao phủ test hiện tại: **>80%**

Tổng số tests: **57 tests**
- Math Utility Tests: 30 tests
- Provider Tests: 26 tests  
- Widget Tests: 1 test

### Chạy Tests
```bash
flutter test
```

### Kết Quả Test
```
00:02 +57: All tests passed!

Tổng: 57 tests
Passed: 57 tests
Failed: 0 tests
Coverage: >80%
```

### Xác Nhận Các Kịch Bản Test

Tất cả các kịch bản test từ yêu cầu Lab 3 đều đã pass:

1. ✅ Biểu thức phức tạp: `(5 + 3) × 2 - 4 ÷ 2 = 14`
2. ✅ Tính toán khoa học: `sin(45°) + cos(45°) ≈ 1.414`
3. ✅ Chức năng bộ nhớ: `5 M+ 3 M+ MR = 8`
4. ✅ Tính toán liên tiếp: `5 + 3 = + 2 = + 1 = 11`
5. ✅ Ngoặc lồng nhau: `((2 + 3) × (4 - 1)) ÷ 5 = 3`
6. ✅ Hàm khoa học kết hợp: `2 × π × √9 ≈ 18.85`
7. ✅ Chế độ lập trình viên: `0xFF AND 0x0F = 0x0F`

---

## Tác Giả

**Huỳnh Văn Sang**
- GitHub: [@HuynSang2404](https://github.com/HuynSang2404)
- Dự án: Máy Tính Nâng Cao - Lab 3
