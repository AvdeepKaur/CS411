import pytest

from meal_max.models.battle_model import BattleModel
from meal_max.models.kitchen_model import Meal

@pytest.fixture()
def battle_model():
    """Fixture to provide a new instance of BattleModel for each test."""
    return BattleModel()

"""Fixtures providing sample meal combatants for the tests."""
@pytest.fixture()
def sample_combatant1():
    return Meal(0, "popcorn", "american", 5.00, "LOW")

@pytest.fixture()
def sample_combatant2():
    return Meal(1, "pasta", "italian", 30.00, "MED")

@pytest.fixture()
def sample_combatant3():
    return Meal(2, "pizza", "italian", 20.00, "HIGH")

"""Fixtures providing sample battles for the tests."""
@pytest.fixture()
def sample_battle(sample_combatant1, sample_combatant2):
    return [sample_combatant1, sample_combatant2]

@pytest.fixture()
def sample_battle2(sample_combatant1, sample_combatant2, sample_combatant3):
    return [sample_combatant1, sample_combatant2, sample_combatant3]


##################################################
# Combatant Management Test Cases
##################################################

def test_clear_combatants(battle_model, sample_combatant1):
    """Test removing all combatants that are prepped."""
    battle_model.prep_combatant(sample_combatant1)
    battle_model.clear_combatants()

    combatant_list = battle_model.get_combatants()
    assert len(combatant_list) == 0

def test_get_combatants(battle_model, sample_battle):
    """Test retrieving all combatants that have been prepped."""
    battle_model.prep_combatant(sample_battle[0])
    battle_model.prep_combatant(sample_battle[1])
    all_combatants = battle_model.get_combatants()

    assert len(all_combatants) == 2
    assert all_combatants[0].id == 0
    assert all_combatants[1].id == 1

def test_prep_combatant(battle_model, sample_battle2):
    """Test adding combatants to battle and error if more than 2 combatants are added."""
    battle_model.prep_combatant(sample_battle2[0])

    assert len(battle_model.combatants) == 1
    assert battle_model.combatants[0].meal == "popcorn"

    battle_model.prep_combatant(sample_battle2[1])

    assert len(battle_model.combatants) == 2
    assert battle_model.combatants[1].meal == "pasta"

    with pytest.raises(ValueError, match="Combatant list is full, cannot add more combatants."):
        battle_model.prep_combatant(sample_battle2[2])

##################################################
# Battle Test Cases
##################################################
def test_get_battle_score(battle_model, sample_combatant1):
    """Test successfully retrieving the correct score"""
    score = battle_model.get_battle_score(sample_combatant1)
    assert score == 37


def test_battle(battle_model, sample_battle):
    """Test successfully retrieving the winner from battle."""
    battle_model.prep_combatant(sample_battle[0])
    battle_model.prep_combatant(sample_battle[1])

    winner = battle_model.battle()

    assert winner == "pasta"