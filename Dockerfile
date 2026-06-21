# استخدام نظام أوبونتو كمشغل أساسي وخفيف
FROM ubuntu:20.04

# منع الأسئلة التفاعلية أثناء التثبيت
ENV DEBIAN_FRONTEND=noninteractive

# تثبيت محرك QEMU وأدوات البث والشبكات الأساسية
RUN apt-get update && apt-get install -y \
    qemu-system-x86 \
    novnc \
    websockify \
    curl \
    wget \
    && apt-get clean

# إنشاء مجلد العمل داخل الحاوية
WORKDIR /app

# نسخ سكريبت التشغيل إلى داخل الحاوية
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

# فتح المنفذ 10000 (وهو المنفذ الافتراضي الذي تطلبه منصة Render)
EXPOSE 10000

# أمر تشغيل الحاوية عند البدء
CMD ["/app/run.sh"]
