# Music Client 

### Showcase

![!](./assets/music.png)

### Info

Thật ra nó chỉ là 1 cái `tui app` nghe nhạc tên là [`ncmpcpp`](https://github.com/ncmpcpp/ncmpcpp) trên Linux thôi. Nhưng với Awesomewm, bạn có thể thêm các widget vào các app có class xác định.

Mình set music client của riêng mình bằng cmd như sau:

```bash
music_client = "st -c music -e ncmpcpp",
```

Terminal emulator mặc định ở đây là [`st`](https://st.suckless.org/), cmd có nghĩa `st` run command `ncmpcpp` và set class là `music`, giờ chỉ cần tạo các widget bằng lua api của Awesomewm và khởi động cùng các app có class `music`.

Nếu chỉ bật `ncmpcpp` riêng thì chỉ có thế này thôi :v. 

![!](./assets/music_ori.png)

Mình sẽ nói cụ thể từng cái decorations này sau. But as you can see, so beautiful =]].
