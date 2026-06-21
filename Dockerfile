# استخدام نسخة نظام لينكس مجهزة بالكامل بالواجهة والـ noVNC تلقائياً
FROM dorowu/ubuntu-desktop-lxde-vnc:focal

# فتح المنفذ المتوافق مع سيرفرات رندر
EXPOSE 10000

# تشغيل النظام مباشرة على المنفذ المطلوب
CMD ["/startup.sh"]
