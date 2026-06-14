from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter


ROOT = Path(__file__).resolve().parent
PROJECT_ROOT = ROOT.parent.parent
ICON_PATH = PROJECT_ROOT / "Assets.xcassets" / "AppIcon.appiconset" / "AppIcon-1024.png"

FONT_REG = "/System/Library/Fonts/SFNS.ttf"
FONT_BOLD = "/System/Library/Fonts/SFNSRounded.ttf"


def font(size, bold=False):
    path = FONT_BOLD if bold else FONT_REG
    return ImageFont.truetype(path, size=size)


def gradient(size, top, bottom):
    img = Image.new("RGB", size, top)
    draw = ImageDraw.Draw(img)
    w, h = size
    for y in range(h):
        ratio = y / max(h - 1, 1)
        color = tuple(int(top[i] * (1 - ratio) + bottom[i] * ratio) for i in range(3))
        draw.line((0, y, w, y), fill=color)
    return img


def rounded_panel(base, xy, radius, fill, outline=None, width=1):
    draw = ImageDraw.Draw(base)
    draw.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline, width=width)


def add_text(draw, xy, text, size, fill, bold=False, anchor=None):
    draw.text(xy, text, font=font(size, bold), fill=fill, anchor=anchor)


def fit_icon(size):
    icon = Image.open(ICON_PATH).convert("RGBA")
    return icon.resize((size, size), Image.LANCZOS)


def glow_circle(base, center, radius, color):
    glow = Image.new("RGBA", base.size, (0, 0, 0, 0))
    gdraw = ImageDraw.Draw(glow)
    gdraw.ellipse((center[0] - radius, center[1] - radius, center[0] + radius, center[1] + radius), fill=color)
    glow = glow.filter(ImageFilter.GaussianBlur(radius=24))
    base.alpha_composite(glow)


def feature_graphic():
    img = gradient((1024, 500), (244, 251, 247), (213, 240, 224)).convert("RGBA")
    draw = ImageDraw.Draw(img)

    glow_circle(img, (110, 100), 90, (186, 236, 205, 110))
    glow_circle(img, (940, 430), 120, (163, 228, 192, 100))

    card_shadow = Image.new("RGBA", img.size, (0, 0, 0, 0))
    sdraw = ImageDraw.Draw(card_shadow)
    sdraw.rounded_rectangle((574, 74, 924, 426), radius=34, fill=(0, 0, 0, 28))
    card_shadow = card_shadow.filter(ImageFilter.GaussianBlur(18))
    img.alpha_composite(card_shadow)

    rounded_panel(img, (574, 74, 924, 426), 34, (20, 132, 95, 255))
    rounded_panel(img, (602, 102, 896, 398), 28, (249, 255, 251, 255))
    img.alpha_composite(fit_icon(242), (628, 129))

    add_text(draw, (84, 136), "Sigarasizim", 68, (14, 43, 31), bold=True)
    add_text(draw, (84, 192), "Smoke-free tracking, health milestones and calm breathing support.", 28, (48, 91, 74))

    chips = [
        ((84, 244, 286, 332), "MONEY SAVED", "₺12.480"),
        ((304, 244, 506, 332), "SMOKE-FREE", "142 DAYS"),
    ]
    for box, title, value in chips:
        rounded_panel(img, box, 26, (255, 255, 255, 255), (208, 232, 216, 255), 2)
        add_text(draw, (box[0] + 28, box[1] + 24), title, 18, (96, 140, 120), bold=True)
        add_text(draw, (box[0] + 28, box[1] + 52), value, 30, (14, 109, 79), bold=True)

    rounded_panel(img, (84, 352, 506, 430), 24, (14, 109, 79, 255))
    add_text(draw, (116, 376), "Break the habit. Keep the progress.", 28, (247, 255, 250), bold=True)
    img.convert("RGB").save(ROOT / "feature-graphic.png")


def device_shell(base):
    draw = ImageDraw.Draw(base)
    rounded_panel(base, (86, 182, 1154, 2026), 72, (15, 32, 24, 255))
    rounded_panel(base, (124, 224, 1116, 1984), 56, (246, 251, 247, 255))


def screenshot_summary():
    img = gradient((1240, 2208), (244, 251, 247), (228, 244, 234)).convert("RGBA")
    draw = ImageDraw.Draw(img)
    add_text(draw, (620, 120), "Track every smoke-free win", 62, (18, 51, 37), bold=True, anchor="mm")
    device_shell(img)

    rounded_panel(img, (176, 286, 1064, 586), 46, (14, 116, 84, 255))
    add_text(draw, (238, 378), "Your journey", 62, (248, 255, 251), bold=True)
    add_text(draw, (238, 444), "See time, savings and motivation in one place.", 31, (221, 247, 234))
    rounded_panel(img, (238, 500, 560, 568), 24, (255, 255, 255, 48))
    add_text(draw, (270, 520), "142 days smoke-free", 30, (248, 255, 251), bold=True)

    rounded_panel(img, (176, 642, 1064, 1236), 42, (255, 255, 255, 255))
    rows = [
        ("Smoke-free time", "142 d 6 h"),
        ("Cigarettes not smoked", "2840"),
        ("Money saved", "₺12.480"),
        ("Time saved", "237 h"),
    ]
    top = 696
    for label, value in rows:
        rounded_panel(img, (214, top, 1026, top + 108), 28, (234, 246, 239, 255))
        add_text(draw, (266, top + 32), label, 26, (18, 72, 53), bold=True)
        add_text(draw, (980, top + 32), value, 34, (11, 110, 79), bold=True, anchor="ra")
        top += 130

    panels = [("Daily consumption", "10 cigarettes"), ("Pack price", "₺80")]
    x_positions = [176, 638]
    for (title, value), x in zip(panels, x_positions):
        rounded_panel(img, (x, 1278, x + 426, 1458), 34, (255, 255, 255, 255))
        add_text(draw, (x + 44, 1350), title, 26, (106, 131, 117), bold=True)
        add_text(draw, (x + 44, 1412), value, 50, (16, 61, 45), bold=True)

    rounded_panel(img, (176, 1504, 1064, 1688), 34, (13, 109, 79, 255))
    add_text(draw, (236, 1576), "Stay motivated every day", 48, (248, 255, 251), bold=True)
    img.convert("RGB").save(ROOT / "screenshot-summary.png")


def screenshot_health():
    img = gradient((1240, 2208), (247, 252, 248), (227, 244, 234)).convert("RGBA")
    draw = ImageDraw.Draw(img)
    add_text(draw, (620, 120), "Watch your body recover", 62, (18, 51, 37), bold=True, anchor="mm")
    device_shell(img)

    rounded_panel(img, (176, 286, 1064, 510), 44, (255, 255, 255, 255))
    add_text(draw, (238, 374), "Health timeline", 58, (18, 51, 37), bold=True)
    add_text(draw, (238, 438), "Milestones show what improves after quitting.", 31, (95, 122, 106))

    cards = [
        ("Pulse and blood pressure", "Start returning to healthier levels.", "100%", (11, 110, 79)),
        ("Oxygen level", "Carbon monoxide drops, oxygen rises.", "100%", (38, 161, 123)),
        ("Taste and smell", "Senses get sharper as recovery continues.", "82%", (85, 191, 155)),
    ]
    y = 552
    for title, desc, pct, accent in cards:
        rounded_panel(img, (176, y, 1064, y + 236), 40, (255, 255, 255, 255))
        draw.ellipse((224, y + 60, 340, y + 176), fill=(225, 246, 233))
        draw.ellipse((240, y + 76, 324, y + 160), fill=accent)
        add_text(draw, (378, y + 76), title, 34, (19, 52, 39), bold=True)
        add_text(draw, (378, y + 136), desc, 28, (101, 127, 111))
        add_text(draw, (950, y + 96), pct, 34, (11, 110, 79), bold=True, anchor="ra")
        y += 278

    rounded_panel(img, (176, 1386, 1064, 1622), 40, (13, 109, 79, 255))
    add_text(draw, (236, 1478), "Clinically-inspired milestone view", 48, (248, 255, 251), bold=True)
    add_text(draw, (236, 1544), "Simple, calm and motivating day after day.", 30, (214, 243, 230))
    img.convert("RGB").save(ROOT / "screenshot-health.png")


def screenshot_breath():
    img = gradient((1240, 2208), (245, 251, 249), (228, 243, 236)).convert("RGBA")
    draw = ImageDraw.Draw(img)
    add_text(draw, (620, 120), "Breathe through cravings", 62, (18, 51, 37), bold=True, anchor="mm")
    device_shell(img)

    rounded_panel(img, (176, 286, 1064, 534), 44, (255, 255, 255, 255))
    add_text(draw, (236, 376), "Breath exercise", 58, (18, 51, 37), bold=True)
    add_text(draw, (236, 442), "Use a gentle 4-4-6 cycle to settle the urge.", 31, (95, 122, 106))

    glow_circle(img, (620, 1088), 290, (68, 199, 155, 90))
    draw.ellipse((410, 878, 830, 1298), fill=(216, 244, 231))
    draw.ellipse((466, 934, 774, 1242), fill=(181, 235, 210))
    add_text(draw, (620, 1040), "Inhale", 52, (14, 109, 79), bold=True, anchor="mm")
    add_text(draw, (620, 1142), "04", 118, (18, 51, 37), bold=True, anchor="mm")

    rounded_panel(img, (224, 1486, 1016, 1612), 36, (14, 109, 79, 255))
    add_text(draw, (620, 1550), "A calming tool built into your quit journey", 44, (248, 255, 251), bold=True, anchor="mm")
    img.convert("RGB").save(ROOT / "screenshot-breath.png")


def main():
    ROOT.mkdir(parents=True, exist_ok=True)
    feature_graphic()
    screenshot_summary()
    screenshot_health()
    screenshot_breath()


if __name__ == "__main__":
    main()
