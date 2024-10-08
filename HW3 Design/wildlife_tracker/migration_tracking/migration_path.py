from typing import Optional, List

from wildlife_tracker.animal_management.animal import Animal
from wildlife_tracker.habitat_management.habitat import Habitat

class MigrationPath:
    def __init__(self) -> None:
        paths: dict[int, dict] = {}

    #Migration Path Registration
    def register_path(self, path_id: int, species: Animal, source: Habitat, destination: Habitat) -> None:
        pass

    def remove_path(self, path_id: int) -> None:
        pass

    #Migration Path Retrieval
    def get_path_by_id(self, path_id: int) -> Optional[dict]:
        pass

    def get_all_paths(self) -> List[dict]:
        pass

    def get_paths_by_species(self, species: Animal) -> List[dict]:
        pass

    def get_paths_by_habitat(self, source: Habitat, destination: Habitat) -> List[dict]:
        pass

    # Migration Path Details
    def view_path_details(self, path_id: int) -> Optional[dict]:
        pass

    def update_path_details(self, path_id: int, new_details: dict) -> None:
        pass