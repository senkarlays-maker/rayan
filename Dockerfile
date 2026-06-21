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

# إنشاء الهارد ديسك الوهمي وتحميل نسخة الويندوز مباشرة أثناء بناء الحاوية
RUN qemu-img create -f qcow2 winxp.qcow2 10G && \
    wget -O winxp.iso "https://archive.org/download/WinXPProSP3Arabic/Win_XP_Pro_SP3_Arabic.iso"

# فتح المنفذ 10000 (وهو المنفذ الافتراضي الذي تطلبه منصة Render)
EXPOSE 10000

# أمر تشغيل المحاكي وبث الويب مباشرة بداخل سطر واحد
CMD websockify --web=/usr/share/novnc/ 10000 localhost:5900 & qemu-system-i386 -m 256 -smp 1 -drive file=winxp.qcow2,format=qcow2,index=0,media=disk -cdrom winxp.iso -boot d -vnc localhost:0 -vga std -device usb-tablet
