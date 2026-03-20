package util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtils {

    // ⚠️ NHỚ THAY BẰNG EMAIL GMAIL THẬT CỦA BẠN
    private static final String MY_EMAIL = "techstore.support.2026@gmail.com";

    private static final String MY_PASSWORD = "suetpzvezujricet";

    public static void sendVerificationEmail(String toEmail, String token) {
        Properties pr = new Properties();
        pr.setProperty("mail.smtp.host", "smtp.gmail.com");
        pr.setProperty("mail.smtp.port", "587");
        pr.setProperty("mail.smtp.auth", "true");
        pr.setProperty("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(pr, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(MY_EMAIL, MY_PASSWORD);
            }
        });

        try {
            Message mess = new MimeMessage(session);
            mess.setFrom(new InternetAddress(MY_EMAIL));
            mess.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            mess.setSubject("Xác thực tài khoản TechStore");

            String content = "<div style='font-family: Arial, sans-serif; padding: 20px; max-width: 600px; margin: auto; border: 1px solid #ddd; border-radius: 10px;'>"
                    + "<h2 style='color: #d70018; text-align: center;'>Chào mừng đến với TechStore!</h2>"
                    + "<p>Mã xác nhận để kích hoạt tài khoản của bạn là:</p>"
                    + "<div style='text-align: center; margin: 30px 0;'>"
                    + "<span style='font-size: 28px; font-weight: bold; background: #f4f4f4; padding: 15px 25px; border-radius: 8px; letter-spacing: 5px; color: #333;'>"
                    + token + "</span>"
                    + "</div>"
                    + "<p>Vui lòng nhập mã này lên website để hoàn tất đăng ký.</p></div>";

            mess.setContent(content, "text/html; charset=UTF-8");

            System.out.println("Đang kết nối tới Google Server để gửi mail...");
            Transport.send(mess);
            System.out.println("Đã gửi email OTP thành công tới: " + toEmail);

        } catch (Exception e) {
            System.out.println("LỖI GỬI MAIL. Hãy đọc lỗi màu đỏ bên dưới:");
            e.printStackTrace();
        }
    }
}