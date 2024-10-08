from typing import Optional, List

from wildlife_tracker.migration_tracking.migration_path import MigrationPath

class Migration:
    def __init__(self) -> None:
        migrations: dict[int, dict] = {}

    # Migration Registration
    def register_migration(self, migration_id: int, path: MigrationPath) -> None:
        pass

    def remove_migration(self, migration_id: int) -> None:
        pass

    # Migration Retrieval
    def get_migration_by_id(self, migration_id: int) -> Optional[dict]:
        pass

    def get_all_migrations(self) -> List[dict]:
        pass

    def get_migrations_by_path(self, path: MigrationPath) -> List[dict]:
        pass

    # Migration Management
    def schedule_migration(self, migration_id: int, start_date: str, end_date: str) -> None:
        pass

    def cancel_migration(self, migration_id: int) -> None:
        pass

    # 3.4 Migration Details
    def view_migration_details(self, migration_id: int) -> Optional[dict]:
        pass

    def update_migration_details(self, migration_id: int, new_details: dict) -> None:
        pass