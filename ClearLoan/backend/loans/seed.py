from datetime import date, timedelta
import random

from django.contrib.auth import get_user_model

from .models import Bank, BankBranch, LoanProduct, CreditHistoryEntry


def seed_banks_and_products():
    # NOTE: Data below is used for a prototype demo. Rates/addresses were collected from public pages
    # on banks' websites at the time of project preparation.
    banks = [
        {
            "code": "aiyl",
            "name_en": "Aiyl Bank",
            "name_ru": "Айыл Банк",
            "name_ky": "Айыл Банк",
            "website": "https://ab.kg/en/",
            "support_phone": "5511",
            "hq": {
                "en": "Bishkek, 14 Logvinenko St., 720040",
                "ru": "г. Бишкек, ул. Логвиненко, 14, 720040",
                "ky": "Бишкек, Логвиненко көч., 14, 720040",
            },
            "about": {
                "en": "State-focused bank with regional infrastructure; supports social and agricultural programs.",
                "ru": "Банк с сильной региональной сетью; участвует в социальных и агро‑программах.",
                "ky": "Аймактарда кеңири тармак; социалдык жана агро‑программаларды колдойт.",
            },
            "branches": [
                {"city": "Bishkek", "en": "14 Logvinenko St.", "ru": "ул. Логвиненко, 14", "ky": "Логвиненко көч., 14", "hours": "Mon–Fri 08:30–17:30"},
            ],
            "products": [
                {
                    "loan_type": "consumer",
                    "title_en": "Yngailuu (consumer)",
                    "title_ru": "Ыңгайлуу (потребительский)",
                    "title_ky": "Ыңгайлуу (керектөөчү)",
                    "min_amount": 10000,
                    "max_amount": 500000,
                    "min_months": 3,
                    "max_months": 24,
                    "rate_from": 14.0,
                    "rate_to": 22.0,
                    "collateral": "none/guarantor (depends)",
                    "is_islamic": False,
                    "desc_en": "Consumer loan products with different terms (prototype).",
                    "desc_ru": "Потребительские кредиты с разными условиями (прототип).",
                    "desc_ky": "Ар кандай шарттары бар керектөөчү насыялар (прототип).",
                },
            ],
        },
        {
            "code": "optima",
            "name_en": "Optima Bank",
            "name_ru": "Оптима Банк",
            "name_ky": "Оптима Банк",
            "website": "https://optimabank.kg/en/",
            "support_phone": "905959",
            "hq": {
                "en": "Bishkek, 493 Jibek-Jolu str., 720070",
                "ru": "г. Бишкек, ул. Жибек-Жолу, 493, 720070",
                "ky": "Бишкек, Жибек-Жолу көч., 493, 720070",
            },
            "about": {
                "en": "Retail-focused bank with mobile services and consumer lending.",
                "ru": "Банк с сильными розничными продуктами и мобильными сервисами.",
                "ky": "Чекене продуктылар жана мобилдик кызматтар.",
            },
            "branches": [
                {"city": "Bishkek", "en": "493, Jibek-Jolu str.", "ru": "ул. Жибек-Жолу, 493", "ky": "Жибек-Жолу көч., 493", "hours": "Mon–Fri 09:00–18:00"},
                {"city": "Bishkek", "en": "326, Jibek Jolu ave. (Head office map)", "ru": "пр-т Жибек Жолу, 326", "ky": "Жибек Жолу пр., 326", "hours": ""},
            ],
            "products": [
                {
                    "loan_type": "consumer",
                    "title_en": "Consumer loan",
                    "title_ru": "Потребительский кредит",
                    "title_ky": "Керектөөчү насыя",
                    "min_amount": 250001,
                    "max_amount": 1500000,
                    "min_months": 3,
                    "max_months": 60,
                    "rate_from": 22.0,
                    "rate_to": 30.0,
                    "collateral": "depends",
                    "is_islamic": False,
                    "desc_en": "Consumer loan in KGS with term up to 60 months (prototype).",
                    "desc_ru": "Потребкредит в сомах до 60 мес. (прототип).",
                    "desc_ky": "Сом менен керектөөчү насыя, 60 айга чейин (прототип).",
                },
                {
                    "loan_type": "mortgage",
                    "title_en": "Mortgage (prototype)",
                    "title_ru": "Ипотека (прототип)",
                    "title_ky": "Ипотека (прототип)",
                    "min_amount": 300000,
                    "max_amount": 5000000,
                    "min_months": 12,
                    "max_months": 120,
                    "rate_from": 21.0,
                    "rate_to": 28.0,
                    "collateral": "real estate",
                    "is_islamic": False,
                    "desc_en": "Mortgage product (prototype ranges).",
                    "desc_ru": "Ипотека (прототип диапазонов).",
                    "desc_ky": "Ипотека (прототип).",
                },
            ],
        },
        {
            "code": "demir",
            "name_en": "DemirBank",
            "name_ru": "ДемирБанк",
            "name_ky": "DemirBank",
            "website": "https://demirbank.kg/en/",
            "support_phone": "+996 (312) 610610",
            "hq": {
                "en": "Bishkek, 245 Chui Ave.",
                "ru": "г. Бишкек, пр. Чүй, 245",
                "ky": "Бишкек, Чүй пр., 245",
            },
            "about": {
                "en": "Universal bank with retail loans and digital onboarding.",
                "ru": "Универсальный банк с розничными кредитами и цифровыми сервисами.",
                "ky": "Универсал банк, чекене насыялар жана санарип кызматтар.",
            },
            "branches": [
                {"city": "Bishkek", "en": "245 Chui Ave.", "ru": "пр. Чүй, 245", "ky": "Чүй пр., 245", "hours": ""},
            ],
            "products": [
                {
                    "loan_type": "consumer",
                    "title_en": "Loan for any purpose (prototype)",
                    "title_ru": "Кредит на любые цели (прототип)",
                    "title_ky": "Каалаган максатка насыя (прототип)",
                    "min_amount": 10000,
                    "max_amount": 700000,
                    "min_months": 6,
                    "max_months": 60,
                    "rate_from": 20.0,
                    "rate_to": 30.0,
                    "collateral": "depends",
                    "is_islamic": False,
                    "desc_en": "Consumer loan product (prototype).",
                    "desc_ru": "Потребительский кредит (прототип).",
                    "desc_ky": "Керектөөчү насыя (прототип).",
                },
            ],
        },
        {
            "code": "kicb",
            "name_en": "KICB",
            "name_ru": "КИКБ",
            "name_ky": "KICB",
            "website": "https://kicb.net/en/",
            "support_phone": "",
            "hq": {
                "en": "Bishkek, 21 Erkindik Ave.",
                "ru": "г. Бишкек, пр. Эркиндик, 21",
                "ky": "Бишкек, Эркиндик пр., 21",
            },
            "about": {
                "en": "Kyrgyz Investment and Credit Bank with retail and SME products.",
                "ru": "Кыргызский Инвестиционно‑Кредитный Банк: продукты для физлиц и бизнеса.",
                "ky": "Инвестиция жана кредит банкы: жеке жана бизнес продуктылар.",
            },
            "branches": [
                {"city": "Bishkek", "en": "21 Erkindik Ave.", "ru": "пр. Эркиндик, 21", "ky": "Эркиндик пр., 21", "hours": "Mon–Fri 09:00–17:00"},
            ],
            "products": [
                {
                    "loan_type": "consumer",
                    "title_en": "Personal (consumer) loan",
                    "title_ru": "Потребительский кредит Personal",
                    "title_ky": "Personal керектөөчү насыя",
                    "min_amount": 1000000,
                    "max_amount": 36000000,
                    "min_months": 6,
                    "max_months": 120,
                    "rate_from": 19.0,
                    "rate_to": 25.0,
                    "collateral": "depends",
                    "is_islamic": False,
                    "desc_en": "Consumer loans with rate from 19% (prototype).",
                    "desc_ru": "Потребкредиты со ставкой от 19% (прототип).",
                    "desc_ky": "19% дан башталган керектөөчү насыя (прототип).",
                },
            ],
        },
        {
            "code": "kompanion",
            "name_en": "Kompanion Bank",
            "name_ru": "Банк Компаньон",
            "name_ky": "Компаньон Банк",
            "website": "https://www.kompanion.kg/en/",
            "support_phone": "",
            "hq": {
                "en": "Bishkek, 62 Shota Rustaveli St., 720044",
                "ru": "г. Бишкек, ул. Шота Руставели, 62, 720044",
                "ky": "Бишкек, Шота Руставели көч., 62, 720044",
            },
            "about": {
                "en": "Retail and SME lender with consumer products (prototype).",
                "ru": "Кредитование физлиц и МСБ, потребительские продукты (прототип).",
                "ky": "Жеке жана МСБ насыялары (прототип).",
            },
            "branches": [
                {"city": "Bishkek", "en": "62 Shota Rustaveli St.", "ru": "ул. Шота Руставели, 62", "ky": "Шота Руставели көч., 62", "hours": ""},
                {"city": "Bishkek", "en": "248A, Kievskaya St.", "ru": "ул. Киевская, 248А", "ky": "Киевская көч., 248А", "hours": ""},
            ],
            "products": [
                {
                    "loan_type": "consumer",
                    "title_en": "Consumer Loan",
                    "title_ru": "Потребительский кредит",
                    "title_ky": "Керектөөчү насыя",
                    "min_amount": 10000,
                    "max_amount": 500000,
                    "min_months": 3,
                    "max_months": 48,
                    "rate_from": 22.0,
                    "rate_to": 26.99,
                    "collateral": "depends",
                    "is_islamic": False,
                    "desc_en": "Nominal annual interest rate from 22% (prototype).",
                    "desc_ru": "Номинальная ставка от 22% (прототип).",
                    "desc_ky": "Номиналдык чен 22% дан (прототип).",
                },
            ],
        },
        {
            "code": "baitushum",
            "name_en": "Bai-Tushum Bank",
            "name_ru": "Бай-Тушум Банк",
            "name_ky": "Бай-Тушум Банк",
            "website": "https://www.baitushum.kg/en/",
            "support_phone": "+996 (312) 905 805",
            "hq": {
                "en": "Bishkek, 76 Umetaliev St.",
                "ru": "г. Бишкек, ул. Уметалиева, 76",
                "ky": "Бишкек, Уметалиев көч., 76",
            },
            "about": {
                "en": "Bank with consumer and SME lending, wide branch network (prototype).",
                "ru": "Банк с потребительским и бизнес‑кредитованием (прототип).",
                "ky": "Керектөөчү жана бизнес насыялары (прототип).",
            },
            "branches": [
                {"city": "Bishkek", "en": "76 Umetaliev St.", "ru": "ул. Уметалиева, 76", "ky": "Уметалиев көч., 76", "hours": ""},
                {"city": "Bishkek", "en": "119 Abdrakhmanova St.", "ru": "ул. Абдрахманова, 119", "ky": "Абдрахманова көч., 119", "hours": ""},
            ],
            "products": [
                {
                    "loan_type": "consumer",
                    "title_en": "Consumer loans",
                    "title_ru": "Потребительские кредиты",
                    "title_ky": "Керектөөчү насыялар",
                    "min_amount": 10000,
                    "max_amount": 300000,
                    "min_months": 3,
                    "max_months": 24,
                    "rate_from": 30.58,
                    "rate_to": 35.0,
                    "collateral": "depends",
                    "is_islamic": False,
                    "desc_en": "Consumer loans; rate depends on solvency/collateral (prototype).",
                    "desc_ru": "Ставка зависит от условий/обеспечения (прототип).",
                    "desc_ky": "Чен камсыздоо/шарттарга жараша (прототип).",
                },
            ],
        },
        {
            "code": "eldik",
            "name_en": "Eldik Bank",
            "name_ru": "Элдик Банк",
            "name_ky": "Элдик Банк",
            "website": "https://eldik.kg/en",
            "support_phone": "9111",
            "hq": {
                "en": "Bishkek, 80/1 Moskovskaya St.",
                "ru": "г. Бишкек, ул. Московская, 80/1",
                "ky": "Бишкек, Московская көч., 80/1",
            },
            "about": {
                "en": "State bank, consumer and car loans (prototype).",
                "ru": "Госбанк: потребительские и авто‑кредиты (прототип).",
                "ky": "Мамбанк: керектөөчү жана авто насыялар (прототип).",
            },
            "branches": [
                {"city": "Bishkek", "en": "80/1 Moskovskaya St.", "ru": "ул. Московская, 80/1", "ky": "Московская көч., 80/1", "hours": "24/7 contact center"},
            ],
            "products": [
                {
                    "loan_type": "consumer",
                    "title_en": "Consumer credit",
                    "title_ru": "Потребительский кредит",
                    "title_ky": "Керектөөчү насыя",
                    "min_amount": 10000,
                    "max_amount": 4000000,
                    "min_months": 3,
                    "max_months": 60,
                    "rate_from": 19.0,
                    "rate_to": 30.0,
                    "collateral": "depends",
                    "is_islamic": False,
                    "desc_en": "Consumer credit from 19% per annum (prototype).",
                    "desc_ru": "Потребкредит от 19% годовых (прототип).",
                    "desc_ky": "19% дан башталган керектөөчү насыя (прототип).",
                },
            ],
        },
        {
            "code": "bakai",
            "name_en": "Bakai Bank",
            "name_ru": "Бакай Банк",
            "name_ky": "Бакай Банк",
            "website": "https://bakai.kg/en/",
            "support_phone": "",
            "hq": {
                "en": "Bishkek, 56 Michurina St.",
                "ru": "г. Бишкек, ул. Мичурина, 56",
                "ky": "Бишкек, Мичурина көч., 56",
            },
            "about": {
                "en": "Retail bank with online loan products (prototype).",
                "ru": "Розничный банк, в том числе онлайн‑кредиты (прототип).",
                "ky": "Чекене банк, онлайн насыялар (прототип).",
            },
            "branches": [
                {"city": "Bishkek", "en": "56 Michurina St.", "ru": "ул. Мичурина, 56", "ky": "Мичурина көч., 56", "hours": ""},
            ],
            "products": [
                {
                    "loan_type": "consumer",
                    "title_en": "Online loan up to 200,000 KGS",
                    "title_ru": "Онлайн кредит до 200 000 сом",
                    "title_ky": "200 000 сомго чейин онлайн насыя",
                    "min_amount": 10000,
                    "max_amount": 200000,
                    "min_months": 3,
                    "max_months": 36,
                    "rate_from": 15.5,
                    "rate_to": 30.0,
                    "collateral": "none",
                    "is_islamic": False,
                    "desc_en": "Online loan product (prototype).",
                    "desc_ru": "Онлайн кредит (прототип).",
                    "desc_ky": "Онлайн насыя (прототип).",
                },
            ],
        },
    ]

    for b in banks:
        bank, _ = Bank.objects.get_or_create(
            code=b["code"],
            defaults=dict(
                name_en=b["name_en"],
                name_ru=b["name_ru"],
                name_ky=b["name_ky"],
                website=b["website"],
                support_phone=b["support_phone"],
                hq_address_en=b["hq"]["en"],
                hq_address_ru=b["hq"]["ru"],
                hq_address_ky=b["hq"]["ky"],
                about_en=b["about"]["en"],
                about_ru=b["about"]["ru"],
                about_ky=b["about"]["ky"],
            ),
        )
        # update if exists (simple)
        Bank.objects.filter(id=bank.id).update(
            name_en=b["name_en"],
            name_ru=b["name_ru"],
            name_ky=b["name_ky"],
            website=b["website"],
            support_phone=b["support_phone"],
            hq_address_en=b["hq"]["en"],
            hq_address_ru=b["hq"]["ru"],
            hq_address_ky=b["hq"]["ky"],
            about_en=b["about"]["en"],
            about_ru=b["about"]["ru"],
            about_ky=b["about"]["ky"],
        )

        # branches
        for br in b.get("branches", []):
            BankBranch.objects.get_or_create(
                bank=bank,
                city=br.get("city", ""),
                address_en=br["en"],
                address_ru=br["ru"],
                address_ky=br["ky"],
                defaults={"hours": br.get("hours", "")},
            )

        # products
        for p in b.get("products", []):
            LoanProduct.objects.get_or_create(
                bank=bank,
                loan_type=p["loan_type"],
                title_en=p["title_en"],
                defaults=dict(
                    title_ru=p["title_ru"],
                    title_ky=p["title_ky"],
                    min_amount=p["min_amount"],
                    max_amount=p["max_amount"],
                    min_months=p["min_months"],
                    max_months=p["max_months"],
                    rate_from=p["rate_from"],
                    rate_to=p["rate_to"],
                    collateral=p.get("collateral", ""),
                    is_islamic=p.get("is_islamic", False),
                    desc_en=p.get("desc_en", ""),
                    desc_ru=p.get("desc_ru", ""),
                    desc_ky=p.get("desc_ky", ""),
                ),
            )


def seed_fake_users_with_histories(count: int = 25):
    User = get_user_model()

    first_names = [
        ("Aibek", "Айбек", "Айбек"),
        ("Ainura", "Айнура", "Айнура"),
        ("Ramazan", "Рамазан", "Рамазан"),
        ("Bakyt", "Бакыт", "Бакыт"),
        ("Meerim", "Мээрим", "Мээрим"),
        ("Nursultan", "Нурсултан", "Нурсултан"),
        ("Aigerim", "Айгерим", "Айгерим"),
        ("Erbol", "Эрбол", "Эрбол"),
        ("Kanykei", "Каныкей", "Каныкей"),
        ("Adilet", "Адилет", "Адилет"),
    ]
    last_names = [
        ("Ulanbekov", "Уланбеков", "Уланбеков"),
        ("Sydykov", "Сыдыков", "Сыдыков"),
        ("Turgunbaev", "Тургунбаев", "Тургунбаев"),
        ("Ismailova", "Исмаилова", "Исмаилова"),
        ("Abdyrahmanov", "Абдырахманов", "Абдырахманов"),
        ("Japarov", "Жапаров", "Жапаров"),
        ("Toktogulova", "Токтогулова", "Токтогулова"),
    ]
    occupations = [
        "Student",
        "Teacher",
        "Driver",
        "Developer",
        "Sales manager",
        "Doctor",
        "Accountant",
        "Self-employed",
        "Farmer",
        "Office worker",
    ]

    # Create users with different credit histories
    for i in range(count):
        phone = f"+996700{100000 + i}"
        password = "demo12345"
        fn = random.choice(first_names)[1]
        ln = random.choice(last_names)[1]
        full_name = f"{ln} {fn}"
        passport_id = f"AN{random.randint(1000000,9999999)}"
        occupation = random.choice(occupations)
        income = random.choice([25000, 35000, 45000, 60000, 80000, 120000])
        user_type = "individual"

        user, created = User.objects.get_or_create(
            phone=phone,
            defaults=dict(
                full_name=full_name,
                passport_id=passport_id,
                workplace="Demo workplace",
                occupation=occupation,
                monthly_income=income,
                user_type=user_type,
            ),
        )
        if created:
            user.set_password(password)
            user.save()

        # Clear and regenerate history for idempotence-ish
        CreditHistoryEntry.objects.filter(user=user).delete()

        mode = random.choice(["clean", "late", "mixed", "none", "default"])
        providers = ["Aiyl Bank", "Optima Bank", "KICB", "Bakai Bank", "Kompanion Bank", "Bai-Tushum Bank", "Eldik Bank"]

        if mode == "none":
            continue

        entries_n = random.randint(1, 4) if mode != "default" else random.randint(1, 2)
        for _ in range(entries_n):
            provider = random.choice(providers)
            original_amount = random.choice([50000, 100000, 200000, 300000, 500000])
            opened = date.today() - timedelta(days=random.randint(200, 2000))
            closed = None
            status = "ontime"
            late_payments = 0
            note = ""

            if mode == "clean":
                status = "ontime"
                late_payments = 0
            elif mode == "late":
                status = "late"
                late_payments = random.randint(1, 6)
                note = "Had minor delays."
            elif mode == "mixed":
                status = random.choice(["ontime", "late"])
                late_payments = 0 if status == "ontime" else random.randint(1, 4)
            elif mode == "default":
                status = "default"
                late_payments = random.randint(6, 12)
                note = "Serious delinquency."

            if status in ["ontime", "late"] and random.random() < 0.5:
                closed = opened + timedelta(days=random.randint(120, 720))

            CreditHistoryEntry.objects.create(
                user=user,
                provider_name=provider,
                original_amount=original_amount,
                opened_at=opened,
                closed_at=closed,
                status=status,
                late_payments=late_payments,
                note=note,
            )
