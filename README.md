Below is the fully formatted **`README.md`** file for the `DishBuilder` module:

---

# DishBuilder Module

The `DishBuilder` module provides tools to create, manage, and validate `Dish` entities in a structured and reusable way. It ensures attributes are handled immutably and validated before use.

---

## Features

- **Dish Creation**: Create a new `Dish` with default values.
- **Set Functions**: Update specific attributes while preserving immutability.
- **Validation**: Validate key attributes such as `name`, `price`, and `nutritional` data.
- **Build Functionality**: Finalize a `Dish` entity after all attributes are set and validated.

---

## Types

### DishId
```motoko
type DishId = Nat32;
```
Unique identifier for a dish.

### Allergen
```motoko
type Allergen = {
  #Gluten;
  #Dairy;
  #Nuts;
  #Shellfish;
  #Soy;
  #Eggs;
};
```
Enumerates potential allergens in a dish.

### DishCategory
```motoko
type DishCategory = {
  #Appetizer;
  #MainCourse;
  #Dessert;
  #Beverage;
  #Specials;
};
```
Categories used to classify dishes.

### Nutritional
```motoko
type Nutritional = {
  calories: Nat32;
  protein: Float;
  carbohydrates: Float;
  fat: Float;
};
```
Represents nutritional information about a dish.

### Dish
```motoko
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
```
A structured entity representing a dish.

### DishError
```motoko
type DishError = {
  #NotFound;
  #InvalidName;
  #InvalidPrice;
  #InvalidNutrition;
};
```
Defines errors that may occur when validating or building a dish.

---

## Modules

### Validation

Provides functions to validate individual `Dish` attributes.

#### Functions

1. **`validateDishName(name: Text): Bool`**
   ```motoko
   public func validateDishName(name: Text): Bool {
     let trimmedName = Text.strip(name);
     trimmedName.size() >= 2 and trimmedName.size() <= 50;
   };
   ```
   Validates that the dish name is between 2 and 50 characters.

2. **`validatePrice(price: Float): Bool`**
   ```motoko
   public func validatePrice(price: Float): Bool {
     price > 0 and price < 1000;
   };
   ```
   Validates that the price is in an acceptable range.

3. **`validateNutrition(nutrition: Nutritional): Bool`**
   ```motoko
   public func validateNutrition(nutrition: Nutritional): Bool {
     nutrition.calories <= 2000 and
     nutrition.protein >= 0 and
     nutrition.carbohydrates >= 0 and
     nutrition.fat >= 0;
   };
   ```
   Ensures the nutritional values are valid.

---

### DishBuilder

Provides tools for creating and updating `Dish` entities immutably.

#### Functions

1. **`create(): Dish`**
   ```motoko
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
   ```
   Creates a new dish entity with default values.

2. **Set Functions**

   Update specific attributes of a dish entity.

   - **`setId(dish: Dish, newId: DishId): Dish`**
     ```motoko
     public func setId(dish: Dish, newId: DishId): Dish {
       return {...dish; id = ?newId};
     };
     ```

   - **`setName(dish: Dish, newName: Text): Dish`**
     ```motoko
     public func setName(dish: Dish, newName: Text): Dish {
       return {...dish; name = ?newName};
     };
     ```

   - **`setDescription(dish: Dish, newDescription: Text): Dish`**
     ```motoko
     public func setDescription(dish: Dish, newDescription: Text): Dish {
       return {...dish; description = ?newDescription};
     };
     ```

   - **`setIngredients(dish: Dish, newIngredients: [Text]): Dish`**
     ```motoko
     public func setIngredients(dish: Dish, newIngredients: [Text]): Dish {
       return {...dish; ingredients = newIngredients};
     };
     ```

   - **`setPrice(dish: Dish, newPrice: Float): Dish`**
     ```motoko
     public func setPrice(dish: Dish, newPrice: Float): Dish {
       return {...dish; price = ?newPrice};
     };
     ```

   - **`setCategory(dish: Dish, newCategory: DishCategory): Dish`**
     ```motoko
     public func setCategory(dish: Dish, newCategory: DishCategory): Dish {
       return {...dish; category = ?newCategory};
     };
     ```

   - **`setNutritional(dish: Dish, newNutritional: Nutritional): Dish`**
     ```motoko
     public func setNutritional(dish: Dish, newNutritional: Nutritional): Dish {
       return {...dish; nutritional = ?newNutritional};
     };
     ```

   - **`setVegetarian(dish: Dish, isVeg: Bool): Dish`**
     ```motoko
     public func setVegetarian(dish: Dish, isVeg: Bool): Dish {
       return {...dish; isVegetarian = isVeg};
     };
     ```

   - **`setVegan(dish: Dish, isVegan: Bool): Dish`**
     ```motoko
     public func setVegan(dish: Dish, isVegan: Bool): Dish {
       return {...dish; isVegan = isVegan};
     };
     ```

   - **`setAllergens(dish: Dish, newAllergens: [Allergen]): Dish`**
     ```motoko
     public func setAllergens(dish: Dish, newAllergens: [Allergen]): Dish {
       return {...dish; allergens = newAllergens};
     };
     ```

3. **`build(dish: Dish): Result.Result<Dish, DishError>`**
   ```motoko
   public func build(dish: Dish): Result.Result<Dish, DishError> {
     if (dish.id == null or dish.name == null or dish.price == null or dish.category == null or dish.nutritional == null) {
       return #err(#NotFound);
     };

     let dishId = Option.get(dish.id);
     let dishName = Option.get(dish.name);
     let dishPrice = Option.get(dish.price);
     let dishCategory = Option.get(dish.category);
     let dishNutrition = Option.get(dish.nutritional);

     let description = switch dish.description {
       case (?desc) desc;
       case null "No description provided";
     };

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
   ```
   Validates and finalizes the dish entity.

---

## Usage Example

```motoko
let dish = DishBuilder.create();
let updatedDish = DishBuilder.setName(dish, "Spaghetti Carbonara");
let finalDish = DishBuilder.build(updatedDish);

switch finalDish {
  case (#ok(d)) Debug.print("Dish created: " # d.name);
  case (#err(e)) Debug.print("Error: " # Text.fromError(e));
};
```

This `README.md` provides all necessary details about the `DishBuilder` module, ensuring clarity and usability for developers.
