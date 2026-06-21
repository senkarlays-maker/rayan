# نظام لينكس مجهز بالواجهة الرسومية والمتصفح
FROM dorowu/ubuntu-desktop-lxde-vnc:focal

# فتح المنفذ 10000 لـ Render
EXPOSE 10000

# خدعة برمجية لنسخ ملف البث الرئيسي ليصبح هو الصفحة الرئيسية للسيرفر تلقائياً
RUN cp /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# تشغيل النظام والبث المباشر
CMD websockify --web=/usr/share/novnc/ 10000 localhost:5900 & /startup.sh
