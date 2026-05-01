# مخطط التتابع الشامل للتطبيق (Global Sequence Diagram)

هذا الملف يحتوي على الكود والرسم البياني لتدفق البيانات في التطبيق من البداية وحتى المزامنة.

```mermaid
sequenceDiagram
    autonumber
    actor User as المستعمل (Recenseur)
    participant App as التطبيق (Flutter App)
    participant DB as قاعدة البيانات (SQLite Local)
    participant API as السيرفر المركزي (Backend API)

    Note over User, API: مرحلة تسجيل الدخول (Authentication)
    User->>App: إدخال البريد وكلمة السر
    App->>API: POST /login
    API-->>App: Token + User Info
    App->>DB: تخزين بيانات الجلسة محلياً

    Note over User, API: مرحلة ملء الاستبيان (Data Collection)
    loop لكل قسم (Sections 1-7)
        User->>App: إدخال البيانات (فلاحة، مواشي، إلخ)
        App->>DB: حفظ المسودة (Save Local Draft)
    end

    Note over User, API: مرحلة المراجعة والاعتماد (Validation)
    User->>App: طلب الاعتماد النهائي
    App->>DB: جلب البيانات الكاملة
    DB-->>App: Full Survey Data
    App->>App: تشغيل ValidationService (التحقق البرمجي)
    App-->>User: إظهار الملخص (Summary) + الأخطاء إن وجدت
    User->>App: تأكيد الحفظ النهائي
    App->>DB: تحديث الحالة إلى "Completed"

    Note over User, API: مرحلة المزامنة (Synchronization)
    User->>App: الضغط على زر المزامنة
    App->>DB: جلب الاستبيانات المكتملة وغير المزامنة
    DB-->>App: List of Surveys
    loop لكل استبيان
        App->>API: POST /sync/survey
        API-->>App: Response (200 OK)
        alt في حالة النجاح
            App->>DB: تحديث الحالة إلى "Synced"
        else في حالة الفشل
            App-->>User: إظهار خطأ في الاتصال
        end
    end
    App-->>User: تم الانتهاء من المزامنة بنجاح ✅
```

## شرح المخطط:
1. **المزامنة:** يتم إرسال البيانات فقط عند توفر الإنترنت، مع تحديث الحالة في قاعدة البيانات المحلية.
2. **الأمان:** يتم تخزين التوكن محلياً لتفادي تسجيل الدخول في كل مرة.
3. **الدقة:** يتم التحقق من البيانات برمجياً (Validation) قبل إرسالها للسيرفر لضمان جودة الإحصاء.
