import Foundation

struct UserSettings: Codable, Equatable {
    var cigsPerDay: Int
    var cigsPerPack: Int
    var packPrice: Double
    var minutesPerCig: Int
    var notificationsEnabled: Bool
    var language: AppLanguage

    static let defaultValue = UserSettings(
        cigsPerDay: 10,
        cigsPerPack: 20,
        packPrice: 80.0,
        minutesPerCig: 5,
        notificationsEnabled: false,
        language: .tr
    )
}
import Foundation
import Combine

enum AppLanguage: String, CaseIterable, Codable {
    case tr = "tr"
    case en = "en"
    
    var displayName: String {
        switch self {
        case .tr: return "Türkçe"
        case .en: return "English"
        }
    }
}

class Localization {
    static let shared = Localization()
    
    // Basit bir yaklaşım için static sözlük kullanıyoruz.
    // Gerçek bir uygulamada Localizable.strings dosyaları daha iyidir ama 
    // kod içinde hızlı çözüm için bu yöntem seçildi.
    
    private let trStrings: [String: String] = [
        // Tab Bar
        "tab_summary": "Özet",
        "tab_health": "Sağlık",
        "tab_achievements": "Kazanımlar",
        "tab_breath": "Nefes",
        "tab_settings": "Ayarlar",
        
        // Summary View
        "summary_title": "Özet",
        "summary_journey": "Yolculuğun",
        "summary_how_long": "Sigarayı bırakalı ne kadar oldu?",
        "summary_card_today": "Bugün",
        "summary_time_smoke_free": "Sigarasız Süre",
        "summary_cigs_not_smoked": "İçilmeyen Sigara",
        "summary_money_saved": "Tasarruf",
        "summary_time_saved": "Kazandığın Zaman",
        "summary_stats": "İstatistikler",
        "summary_daily_consumption": "Günlük Tüketim",
        "summary_pack_price": "Paket Fiyatı",
        "summary_in_pack": "Paket İçi",
        "summary_time_per_cig": "1 Sigara Süresi",
        "unit_count": "adet",
        "unit_min": "dk",
        "unit_hour": "saat",
        "unit_day": "gün",
        
        // Health View
        "health_title": "Sağlık",
        "health_body_healing": "Vücudun İyileşiyor",
        "health_smoke_free_duration": "Sigarasız geçen süre: ",
        "health_completed": "Tamamlandı",
        "health_remaining": "kaldı",
        
        // Breath Test View
        "breath_title": "Nefes Egzersizi",
        "breath_desc": "Bu teknik rahatlamana yardımcı olur.\n4 sn al, 4 sn tut, 6 sn ver.",
        "breath_inhale": "Nefes Al",
        "breath_hold": "Tut",
        "breath_exhale": "Ver",
        "breath_start": "Başlat",
        "breath_stop": "Durdur",
        "breath_reset": "Sıfırla",
        
        // Achievements View
        "achievements_title": "Kazanımlar",
        
        // Settings View
        "settings_title": "Ayarlar",
        "settings_user_info": "Kullanıcı Bilgileri",
        "settings_daily": "Günde",
        "settings_in_pack": "Pakette",
        "settings_pack_price": "Paket Fiyatı",
        "settings_time_per_cig": "1 Sigara Süresi",
        "settings_notifications": "Bildirimler",
        "settings_daily_motivation": "Günlük Motivasyon",
        "settings_counter_management": "Sayaç Yönetimi",
        "settings_quit_date": "Bırakma Tarihi",
        "settings_smoked_reset": "Sigara İçtim (Sıfırla)",
        "settings_save": "Ayarları Kaydet",
        "settings_saved_alert_title": "Başarılı",
        "settings_saved_alert_msg": "Ayarlarınız başarıyla kaydedildi.",
        "settings_ok": "Tamam",
        "settings_language": "Dil / Language",
        
        // Notification
        "notification_title": "Sigarasızım",
        "notification_body": "Bugün de sigarasız bir gün için harika bir fırsat.",

        // Health Milestones
        "health_pulse_title": "Nabız ve Tansiyon",
        "health_pulse_detail": "Nabız ve kan basıncı normal seviyelere düşmeye başlar.",
        "health_oxygen_title": "Oksijen Seviyesi",
        "health_oxygen_detail": "Kandaki oksijen seviyesi normale döner, karbonmonoksit azalır.",
        "health_heart_attack_title": "Kalp Krizi Riski",
        "health_heart_attack_detail": "Kalp krizi geçirme riski azalmaya başlar.",
        "health_taste_smell_title": "Tat ve Koku",
        "health_taste_smell_detail": "Sinir uçları iyileşir, tat ve koku alma duyusu gelişir.",
        "health_energy_title": "Enerji Artışı",
        "health_energy_detail": "Bronşlar gevşer, nefes almak kolaylaşır ve enerji artar.",
        "health_circulation_title": "Dolaşım Sistemi",
        "health_circulation_detail": "Kan dolaşımı iyileşir, yürümek ve koşmak kolaylaşır.",
        "health_lung_clean_title": "Akciğer Temizliği",
        "health_lung_clean_detail": "Öksürük, tıkanıklık ve nefes darlığı azalır. Akciğer enfeksiyon riski düşer.",
        "health_heart_health_title": "Kalp Sağlığı",
        "health_heart_health_detail": "Koroner kalp hastalığı riski, sigara içen birine göre yarıya iner.",
        "health_stroke_title": "İnme Riski",
        "health_stroke_detail": "İnme riski, sigara içmeyen bir insan seviyesine iner.",
        "health_cancer_title": "Akciğer Kanseri",
        "health_cancer_detail": "Akciğer kanseri riski sigara içenlere göre yarıya düşer.",
        
        // Achievements
        "ach_6_hours": "6 Saat",
        "ach_6_hours_detail": "6 saattir sigara içmiyorsun.",
        "ach_12_hours": "12 Saat",
        "ach_12_hours_detail": "Yarım günü devirdin!",
        "ach_1_day": "1 Gün",
        "ach_1_day_detail": "24 saat sigarasız geçti.",
        "ach_3_days": "3 Gün",
        "ach_3_days_detail": "Nikotin vücuttan atıldı.",
        "ach_1_week": "1 Hafta",
        "ach_1_week_detail": "Bir haftayı tamamladın, harika!",
        "ach_2_weeks": "2 Hafta",
        "ach_2_weeks_detail": "İki hafta bitti, alışkanlık kırılıyor.",
        "ach_1_month": "1 Ay",
        "ach_1_month_detail": "Bir aydır sigara içmiyorsun!",
        "ach_3_months": "3 Ay",
        "ach_3_months_detail": "Akciğer kapasiten artıyor.",
        "ach_6_months": "6 Ay",
        "ach_6_months_detail": "Yarım yıl oldu, inanamıyorum!",
        "ach_1_year": "1 Yıl",
        "ach_1_year_detail": "Bir yıl dönümü, tebrikler!",
        "ach_money_saver": "Tasarrufçu",
        "ach_money_saver_detail": "500 ₺ tasarruf ettin.",
        
        // Medical Disclaimer
        "medical_disclaimer": "Bu uygulamadaki bilgiler sadece bilgilendirme amaçlıdır ve tıbbi tavsiye niteliği taşımaz. Herhangi bir tıbbi karar vermeden önce lütfen bir doktora danışın.",
        "medical_source_title": "Kaynak: Dünya Sağlık Örgütü (WHO)",
        "medical_source_url": "https://www.who.int/news-room/questions-and-answers/item/tobacco-health-benefits-of-smoking-cessation"
    ]
    
    private let enStrings: [String: String] = [
        // Tab Bar
        "tab_summary": "Summary",
        "tab_health": "Health",
        "tab_achievements": "Achievements",
        "tab_breath": "Breath",
        "tab_settings": "Settings",
        
        // Summary View
        "summary_title": "Summary",
        "summary_journey": "Your Journey",
        "summary_how_long": "How long has it been?",
        "summary_card_today": "Today",
        "summary_time_smoke_free": "Smoke Free",
        "summary_cigs_not_smoked": "Cigs Not Smoked",
        "summary_money_saved": "Money Saved",
        "summary_time_saved": "Time Saved",
        "summary_stats": "Statistics",
        "summary_daily_consumption": "Daily Consumption",
        "summary_pack_price": "Pack Price",
        "summary_in_pack": "In Pack",
        "summary_time_per_cig": "Time per Cig",
        "unit_count": "cigs",
        "unit_min": "min",
        "unit_hour": "hours",
        "unit_day": "days",
        
        // Health View
        "health_title": "Health",
        "health_body_healing": "Body Healing",
        "health_smoke_free_duration": "Smoke-free duration: ",
        "health_completed": "Completed",
        "health_remaining": "left",
        
        // Health Milestones
        "health_pulse_title": "Pulse & Blood Pressure",
        "health_pulse_detail": "Pulse and blood pressure drop to normal levels.",
        "health_oxygen_title": "Oxygen Level",
        "health_oxygen_detail": "Oxygen level in blood returns to normal, CO level drops.",
        "health_heart_attack_title": "Heart Attack Risk",
        "health_heart_attack_detail": "Risk of heart attack begins to decrease.",
        "health_taste_smell_title": "Taste & Smell",
        "health_taste_smell_detail": "Nerve endings start to regrow, sense of smell/taste improves.",
        "health_energy_title": "Energy Boost",
        "health_energy_detail": "Bronchial tubes relax, breathing becomes easier.",
        "health_circulation_title": "Circulation",
        "health_circulation_detail": "Blood circulation starts to improve.",
        "health_lung_clean_title": "Lung Cleaning",
        "health_lung_clean_detail": "Coughing and shortness of breath decrease.",
        "health_heart_health_title": "Heart Health",
        "health_heart_health_detail": "Risk of coronary heart disease is half that of a smoker.",
        "health_stroke_title": "Stroke Risk",
        "health_stroke_detail": "Risk of stroke is reduced to that of a non-smoker.",
        "health_cancer_title": "Lung Cancer",
        "health_cancer_detail": "Risk of lung cancer falls to about half that of a smoker.",
        
        // Breath Test View
        "breath_title": "Breath Exercise",
        "breath_desc": "Technique to help you relax.\nInhale 4s, Hold 4s, Exhale 6s.",
        "breath_inhale": "Inhale",
        "breath_hold": "Hold",
        "breath_exhale": "Exhale",
        "breath_start": "Start",
        "breath_stop": "Stop",
        "breath_reset": "Reset",
        
        // Achievements View
        "achievements_title": "Achievements",
        "ach_6_hours": "6 Hours",
        "ach_6_hours_detail": "6 hours smoke free.",
        "ach_12_hours": "12 Hours",
        "ach_12_hours_detail": "Half a day done!",
        "ach_1_day": "1 Day",
        "ach_1_day_detail": "24 hours without a cigarette.",
        "ach_3_days": "3 Days",
        "ach_3_days_detail": "Nicotine is out of your system.",
        "ach_1_week": "1 Week",
        "ach_1_week_detail": "One week completed, amazing!",
        "ach_2_weeks": "2 Weeks",
        "ach_2_weeks_detail": "Two weeks done, habit is breaking.",
        "ach_1_month": "1 Month",
        "ach_1_month_detail": "One month smoke free!",
        "ach_3_months": "3 Months",
        "ach_3_months_detail": "Lung capacity is increasing.",
        "ach_6_months": "6 Months",
        "ach_6_months_detail": "Half a year, unbelievable!",
        "ach_1_year": "1 Year",
        "ach_1_year_detail": "One year anniversary, congrats!",
        "ach_money_saver": "Money Saver",
        "ach_money_saver_detail": "You saved 500 ₺."
        ,
        
        // Settings View
        "settings_title": "Settings",
        "settings_user_info": "User Info",
        "settings_daily": "Daily",
        "settings_in_pack": "In Pack",
        "settings_pack_price": "Pack Price",
        "settings_time_per_cig": "Time per Cig",
        "settings_notifications": "Notifications",
        "settings_daily_motivation": "Daily Motivation",
        "settings_counter_management": "Counter Management",
        "settings_quit_date": "Quit Date",
        "settings_smoked_reset": "I Smoked (Reset)",
        "settings_save": "Save Settings",
        "settings_saved_alert_title": "Success",
        "settings_saved_alert_msg": "Settings saved successfully.",
        "settings_ok": "OK",
        "settings_language": "Language",
        
        // Notification
        "notification_title": "Smoke Free",
        "notification_body": "Today is a great opportunity for a smoke-free day.",
        
        // Medical Disclaimer
        "medical_disclaimer": "The information in this app is for informational purposes only and does not constitute medical advice. Please consult a doctor before making any medical decisions.",
        "medical_source_title": "Source: World Health Organization (WHO)",
        "medical_source_url": "https://www.who.int/news-room/questions-and-answers/item/tobacco-health-benefits-of-smoking-cessation"
    ]
    
    func string(_ key: String, for language: AppLanguage) -> String {
        switch language {
        case .tr:
            return trStrings[key] ?? key
        case .en:
            return enStrings[key] ?? key
        }
    }
}
