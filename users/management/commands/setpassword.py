from django.core.management.base import BaseCommand, CommandError
from users.models import User


class Command(BaseCommand):
    help = 'Set password for a user by email (non-interactive)'

    def add_arguments(self, parser):
        parser.add_argument('--email', required=True, help='User email')
        parser.add_argument('--password', required=True, help='New password')

    def handle(self, *args, **options):
        email = options['email']
        password = options['password']
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            raise CommandError(f"User with email {email} does not exist")
        user.set_password(password)
        user.save()
        self.stdout.write(self.style.SUCCESS(f"Password updated for {email}"))


