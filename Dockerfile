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

# فتح المنفذ 10000 تلبية لطلب Render
EXPOSE 10000

# أمر التشغيل: تفعيل البث، وإنشاء الهارد، وتحميل الويندوز، وتفعيل الـ USB واللمس بشكل صحيح
CMD websockify --web=/usr/share/novnc/ 10000 localhost:5900 & \
    qemu-img create -f qcow2 winxp.qcow2 10G && \
    wget --no-check-certificate -qO winxp.iso "https://github.com/0x802/winxp-iso/raw/main/winxp_micro.iso" || true && \
    qemu-system-i386 -m 256 -smp 1 -drive file=winxp.qcow2,format=qcow2,index=0,media=disk -cdrom winxp.iso -boot d -vnc localhost:0 -vga std -usb -device usb-tablet
