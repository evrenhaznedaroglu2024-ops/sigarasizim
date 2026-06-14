# Google Play Data Safety Checklist

Bu dosya Play Console Data Safety formunu doldururken kullanilmak uzere hazirlanmistir.
Nihai secimleriniz, uygulamanin gercek davranisi ve AdMob kurulumunuza gore kontrol edilmelidir.

## Uygulama kendi icinde topluyor mu?

Uygulama kendi sunucusuna kullanici hesabi veya form verisi gondermiyor.
Temel ilerleme ve ayar verileri cihaz icinde yerel olarak saklaniyor.

## Reklam nedeni ile dikkate alinacak alan

Google AdMob kullanildigi icin Google tarafinda reklam ve analiz amacli bazi veriler islenebilir.
Bu nedenle Play Console formunu doldururken AdMob belgeleriyle birlikte kontrol etmeniz gerekir.

## Guvenli baslangic cevap seti

### Data collected

- App info and performance: Yes
- Device or other IDs: Yes
- Diagnostics: Yes

### Data shared

- Device or other IDs: Yes
- App info and performance: Possibly yes, reklam olcumleme senaryosuna gore kontrol edin

### Collection purpose

- Advertising or marketing
- Analytics
- Fraud prevention, security and compliance

### Is data encrypted in transit?

- Yes

### Can users request data deletion?

- No account system yoksa genelde `No`

## Genelde No olarak kalabilecek alanlar

Asagidaki alanlar, uygulamanin mevcut yapisina gore genelde `No` olur:

- Location
- Personal info
- Financial info
- Messages
- Photos and videos
- Audio files
- Files and docs
- Calendar
- Contacts
- Web browsing

## Kontrol etmeniz gereken yerler

- AdMob hesabindaki reklam ozellikleri
- Privacy policy ile Data Safety yanitlarinin uyumu
- Play Console icindeki `Contains ads = Yes` secimi
