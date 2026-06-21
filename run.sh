#!/bin/bash

echo "=== بدء تجهيز نظام Windows XP ==="

# 1. إنشاء هارد ديسك وهمي بمساحة 10 جيجا (ملف محلي داخل السيرفر)
qemu-img create -f qcow2 winxp.qcow2 10G

# 2. تحميل نسخة ويندوز XP مجهزة بصيغة ISO (رابط مباشر آمن وسريع)
# يمكنك استبدال هذا الرابط برابط نسخة خاصة بك إذا أردت لاحقاً
if [ ! -f "winxp.iso" ]; then
    echo "جاري تحميل نسخة Windows XP..."
    wget -O winxp.iso "https://archive.org/download/WinXPProSP3Arabic/Win_XP_Pro_SP3_Arabic.iso"
fi

echo "=== جاري إقلاع محرك QEMU وبث الشاشة ==="

# 3. تشغيل أداة websockify لتحويل بروتوكول الشاشة إلى ويب على منفذ Render (10000)
# وتقوم بتوجيه البث داخلياً إلى منفذ المحاكي (5900)
websockify --web=/usr/share/novnc/ 10000 localhost:5900 &

# 4. تشغيل محاكي QEMU لنسخة الويندوز
# تخصيص 256 ميجا رام (ممتازة لـ XP وتترك مساحة للسيرفر المجاني)
qemu-system-i386 \
    -m 256 \
    -smp 1 \
    -drive file=winxp.qcow2,format=qcow2,index=0,media=disk \
    -cdrom winxp.iso \
    -boot d \
    -vnc localhost:0 \
    -vga std \
    -device usb-tablet

# إبقاء السكريبت شغالاً لمنع توقف الحاوية
wait
