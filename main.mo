import Trie "mo:base/Trie";
import Text "mo:base/Text";
import Nat32 "mo:base/Nat32";
import Float "mo:base/Float";
import Option "mo:base/Option";
import Time "mo:base/Time";
import Result "mo:base/Result";

// Tip Tanımları
type DishId = Nat32;

type Allergen = {
  #Gluten;
  #Dairy;
  #Nuts;
  #Shellfish;
  #Soy;
  #Eggs;
};

type DishCategory = {
  #Appetizer;
  #MainCourse;
  #Dessert;
  #Beverage;
  #Specials;
};

type Nutritional = {
  calories: Nat32;
  protein: Float;
  carbohydrates: Float;
  fat: Float;
};

type Dish = {
  id: ?DishId;
  name: ?Text;
  description: ?Text;
  ingredients: [Text];
  price: ?Float;
  category: ?DishCategory;
  nutritional: ?Nutritional;
  isVegetarian: Bool;
  isVegan: Bool;
  allergens: [Allergen];
};

// Hata Türleri
type DishError = {
  #NotFound;
  #InvalidName;
  #InvalidPrice;
  #InvalidNutrition;
};

// Doğrulama Modülü
module Validation {
  public func validateDishName(name: Text): Bool {
    let trimmedName = Text.strip(name);
    trimmedName.size() >= 2 and trimmedName.size() <= 50;
  };

  public func validatePrice(price: Float): Bool {
    price > 0 and price < 1000;
  };

  public func validateNutrition(nutrition: Nutritional): Bool {
    nutrition.calories <= 2000 and
    nutrition.protein >= 0 and
    nutrition.carbohydrates >= 0 and
    nutrition.fat >= 0;
  };
};

// DishBuilder
module DishBuilder {
  public func create(): Dish {
    return {
      id = null;
      name = null;
      description = null;
      ingredients = [];
      price = null;
      category = null;
      nutritional = null;
      isVegetarian = false;
      isVegan = false;
      allergens = [];
    };
  };

  // Set Fonksiyonları
  public func setId(dish: Dish, newId: DishId): Dish {
    return {
      id = ?newId;
      name = dish.name;
      description = dish.description;
      ingredients = dish.ingredients;
      price = dish.price;
      category = dish.category;
      nutritional = dish.nutritional;
      isVegetarian = dish.isVegetarian;
      isVegan = dish.isVegan;
      allergens = dish.allergens
    };
  };

  public func setName(dish: Dish, newName: Text): Dish {
    return {
      id = dish.id;
      name = ?newName;
      description = dish.description;
      ingredients = dish.ingredients;
      price = dish.price;
      category = dish.category;
      nutritional = dish.nutritional;
      isVegetarian = dish.isVegetarian;
      isVegan = dish.isVegan;
      allergens = dish.allergens
    };
  };

  public func setDescription(dish: Dish, newDescription: Text): Dish {
    return {
      id = dish.id;
      name = dish.name;
      description = ?newDescription;
      ingredients = dish.ingredients;
      price = dish.price;
      category = dish.category;
      nutritional = dish.nutritional;
      isVegetarian = dish.isVegetarian;
      isVegan = dish.isVegan;
      allergens = dish.allergens
    };
  };

  public func setIngredients(dish: Dish, newIngredients: [Text]): Dish {
    return {
      id = dish.id;
      name = dish.name;
      description = dish.description;
      ingredients = newIngredients;
      price = dish.price;
      category = dish.category;
      nutritional = dish.nutritional;
      isVegetarian = dish.isVegetarian;
      isVegan = dish.isVegan;
      allergens = dish.allergens
    };
  };

  public func setPrice(dish: Dish, newPrice: Float): Dish {
    return {
      id = dish.id;
      name = dish.name;
      description = dish.description;
      ingredients = dish.ingredients;
      price = ?newPrice;
      category = dish.category;
      nutritional = dish.nutritional;
      isVegetarian = dish.isVegetarian;
      isVegan = dish.isVegan;
      allergens = dish.allergens
    };
  };

  public func setCategory(dish: Dish, newCategory: DishCategory): Dish {
    return {
      id = dish.id;
      name = dish.name;
      description = dish.description;
      ingredients = dish.ingredients;
      price = dish.price;
      category = ?newCategory;
      nutritional = dish.nutritional;
      isVegetarian = dish.isVegetarian;
      isVegan = dish.isVegan;
      allergens = dish.allergens
    };
  };

  public func setNutritional(dish: Dish, newNutritional: Nutritional): Dish {
    return {
      id = dish.id;
      name = dish.name;
      description = dish.description;
      ingredients = dish.ingredients;
      price = dish.price;
      category = dish.category;
      nutritional = ?newNutritional;
      isVegetarian = dish.isVegetarian;
      isVegan = dish.isVegan;
      allergens = dish.allergens
    };
  };

  public func setVegetarian(dish: Dish, isVeg: Bool): Dish {
    return {
      id = dish.id;
      name = dish.name;
      description = dish.description;
      ingredients = dish.ingredients;
      price = dish.price;
      category = dish.category;
      nutritional = dish.nutritional;
      isVegetarian = isVeg;
      isVegan = dish.isVegan;
      allergens = dish.allergens
    };
  };

  public func setVegan(dish: Dish, isVegan: Bool): Dish {
    return {
      id = dish.id;
      name = dish.name;
      description = dish.description;
      ingredients = dish.ingredients;
      price = dish.price;
      category = dish.category;
      nutritional = dish.nutritional;
      isVegetarian = dish.isVegetarian;
      isVegan = isVegan;
      allergens = dish.allergens
    };
  };

  public func setAllergens(dish: Dish, newAllergens: [Allergen]): Dish {
    return {
      id = dish.id;
      name = dish.name;
      description = dish.description;
      ingredients = dish.ingredients;
      price = dish.price;
      category = dish.category;
      nutritional = dish.nutritional;
      isVegetarian = dish.isVegetarian;
      isVegan = dish.isVegan;
      allergens = newAllergens;
    };
  };

  // Build Fonksiyonu
  public func build(dish: Dish): Result.Result<Dish, DishError> {
    // Zorunlu alanları kontrol et
    if (dish.id == null or dish.name == null or dish.price == null or dish.category == null or dish.nutritional == null) {
      return #err(#NotFound);
    };

    // Zorunlu alanları unwrap et
    let dishId = Option.get(dish.id);
    let dishName = Option.get(dish.name);
    let dishPrice = Option.get(dish.price);
    let dishCategory = Option.get(dish.category);
    let dishNutrition = Option.get(dish.nutritional);

    // Opsiyonel alanları varsayılan değerle doldur
    

    // Doğrulama
    if (not Validation.validateDishName(dishName)) {
      return #err(#InvalidName);
    };

    if (not Validation.validatePrice(dishPrice)) {
      return #err(#InvalidPrice);
    };

    if (not Validation.validateNutrition(dishNutrition)) {
      return #err(#InvalidNutrition);
    };

    // Başarılı sonuç döndür
    #ok({
      id = dishId;
      name = dishName;
      description = description;
      ingredients = dish.ingredients;
      price = dishPrice;
      category = dishCategory;
      nutritional = dishNutrition;
      isVegetarian = dish.isVegetarian;
      isVegan = dish.isVegan;
      allergens = dish.allergens;
    });
  };
};
