from django.core.management.base import BaseCommand

from loans.seed import seed_banks_and_products, seed_fake_users_with_histories


class Command(BaseCommand):
    help = "Seed demo data: banks/products + 25 fake users with different credit histories."

    def add_arguments(self, parser):
        parser.add_argument("--users", type=int, default=25)

    def handle(self, *args, **options):
        seed_banks_and_products()
        seed_fake_users_with_histories(count=int(options["users"]))
        self.stdout.write(self.style.SUCCESS("Demo data seeded successfully."))
