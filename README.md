# Sell Store

Sell Store is a small shopping-style app built with Flutter.

You sign in with an email and password, browse products that come from a free online API, search for products, open a product to see its details, and save the ones you like as favorites. Your favorites stay saved even after you close the app.

This project was built for the Junior Flutter Developer machine task.

---

## Table of contents

1. [What the app can do](#1-what-the-app-can-do)
2. [Screens](#2-screens)
3. [How to run the app](#3-how-to-run-the-app)
4. [Where the data comes from (the API)](#4-where-the-data-comes-from-the-api)
5. [How the code is organised](#5-how-the-code-is-organised)
6. [How the app works, step by step](#6-how-the-app-works-step-by-step)
7. [Technical decisions explained](#7-technical-decisions-explained)
8. [Loading, error and empty states](#8-loading-error-and-empty-states)
9. [Tests](#9-tests)
10. [Known limitations](#10-known-limitations)
11. [AI usage](#11-ai-usage)
12. [Glossary](#12-glossary)

---

## 1. What the app can do

| Feature | What it means for the user |
|---|---|
| Create an account | Sign up with a name, email and password. Accounts are stored by Firebase, Google's login service. |
| Sign in / sign out | Sign in with the same email and password. The app remembers you until you sign out. |
| Browse products | See product cards with a photo, name, price, discount, rating and category. More products load as you scroll. |
| Search | Type in the search box to find products by name. Results update as you type. |
| Categories | Tap a category chip (Beauty, Furniture, ...) to see only that category. |
| Product details | Tap a product to see its photos, description, price, discount, rating, stock, brand, category, tags and customer reviews. |
| Favorites | Tap the heart on any product to save it. Saved products live on the Favorites tab and stay after the app restarts. |
| Extras | A shopping bag, a "recently viewed" row, and a light / dark theme switch. These were added to show that the same code pattern works for more than one feature. |

---

## 2. Screens

| Screen | What is on it |
|---|---|
| **Login** | Email, password, Sign in button, link to create an account. |
| **Create Account** | Name, email, password, confirm password, Sign up button. |
| **Products (Home)** | Greeting, search box, a banner with the biggest discounts, category chips, "Top Deals" row, and the full product grid. |
| **Explore** | Search box with popular tags, a category grid, top brands and top-rated products. |
| **Favorites** | Every product you saved, with filters by category and a "Move to bag" button. |
| **Product Details** | Photo gallery, price, facts (warranty, returns, shipping), specifications table and reviews. Add-to-bag bar at the bottom. |
| **Bag** | Items you added, quantity buttons, order total. |
| **Profile** | Your name and email, theme switch, shortcuts to favorites and categories, Sign Out. |

The four main screens (Products, Explore, Favorites, Profile) are tabs in the bottom bar. Details and Bag open on top of them.

---

## 3. How to run the app

### What you need installed

| Tool | Version used while building | Why |
|---|---|---|
| Flutter | 3.38.8 (stable channel) | Builds and runs the app |
| Dart | 3.10.7 (comes with Flutter) | The language |
| Android Studio or an Android device | any recent | To run the app on a phone or emulator |
| Node.js + Firebase CLI | any recent | Only needed if you connect your **own** Firebase project |
| FlutterFire CLI | any recent | Same as above |

Check your Flutter version with:

```bash
flutter --version
```

### Step 1: get the code and download the packages

```bash
git clone <this repository>
cd product_explorer
flutter pub get
```

`flutter pub get` downloads the libraries the app uses (listed in `pubspec.yaml`).

### Step 2: Firebase (login service)

The app uses **Firebase Authentication** to store user accounts. Firebase is a Google service; the app talks to it over the internet, so you need an internet connection to sign in.

**Option A: use the project that is already set up (fastest).**
The repository already contains the Firebase configuration files for the author's project. You do not need to change anything. Go to Step 3.

**Option B: connect your own Firebase project.**

1. Go to the [Firebase console](https://console.firebase.google.com) and create a project.
2. In the project, open **Authentication → Sign-in method** and enable **Email/Password**.
3. Install the command-line tools once:

   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   firebase login
   ```

4. In the project folder, run:

   ```bash
   flutterfire configure --project=<your-firebase-project-id>
   ```

   This command writes three files for you: `lib/firebase_options.dart`, `android/app/google-services.json` and `firebase.json`. You never type keys by hand, and no other code changes.

### Step 3: run it

Start an Android emulator or plug in a phone, then:

```bash
flutter run
```

To build an APK file you can install on any Android phone:

```bash
flutter build apk --release
```

The file appears at `build/app/outputs/flutter-apk/app-release.apk`.

### Step 4: sign in

Tap **Create new account** on the login screen and make your own account, or use this test account (it exists in the author's Firebase project, so it only works with Option A):

| Field | Value |
|---|---|
| Email | `user1@gmail.com` |
| Password | `User@123` |

---

## 4. Where the data comes from (the API)

All products come from **DummyJSON**, a free public API made for practice apps. An API is simply a web address that returns data (in JSON format) instead of a web page. No key or account is needed.

| What the app needs | Address it calls |
|---|---|
| A page of products | `https://dummyjson.com/products?limit=20&skip=0` |
| Search results | `https://dummyjson.com/products/search?q=phone` |
| One product's details | `https://dummyjson.com/products/1` |
| The list of categories | `https://dummyjson.com/products/category-list` |
| Products in one category | `https://dummyjson.com/products/category/beauty` |

You can open any of these addresses in a browser to see the raw data the app receives.

---

## 5. How the code is organised

All app code lives in the `lib` folder. It is split by **feature** (auth, products, favorites, ...) rather than by file type, so everything about one feature sits together.

```
lib/
  main.dart                 The first file that runs. Starts Firebase, then the app.
  firebase_options.dart     Generated by Firebase tools. Do not edit by hand.

  app/                      App-wide setup
    app.dart                  The root widget (themes + routes)
    routes.dart               Names of every screen, e.g. '/login'
    app_pages.dart            Which widget opens for each route name
    middleware/               "Guards" that send signed-out users to the login screen
    bindings/                 Creates the objects the whole app shares (see Glossary: binding)
    theme.dart                Colours and text styles for light and dark mode

  core/                     Code shared by every feature
    network/                  Talks to the API (ApiClient) and turns failures into readable errors
    storage/                  Saves small data on the phone (LocalStore)
    state/                    AsyncState: "loading", "has data" or "error"
    utils/                    Small helpers, e.g. formatting a price as $12.99
    widgets/                  Reusable pieces: top bar, bottom bar, pills, loading/error/empty views
    firebase/                 Starts Firebase before the first screen

  features/
    auth/                     Login and Create Account
    products/                 Product list, search, categories, product details
    favorites/                The heart button and the Favorites tab
    cart/                     The shopping bag
    history/                  Recently viewed products
    profile/                  The Profile tab
    settings/                 The theme (light / dark) setting
    shell/                    The bottom tab bar that holds the four main screens
```

Inside each feature the folders are always the same:

| Folder | What goes in it | Example |
|---|---|---|
| `data/` | Models (the shape of the data) and repositories (code that fetches or saves data) | `product.dart`, `products_repository.dart` |
| `controllers/` | The screen's "brain": holds the current state and handles actions | `product_list_controller.dart` |
| `bindings/` | Creates the controller when the screen opens and removes it when it closes | `product_details_binding.dart` |
| `views/` | The screens (full pages) | `home_view.dart` |
| `widgets/` | Smaller building blocks used by the views | `product_card.dart` |

**Rule of thumb:** a view only talks to a controller. A controller only talks to a repository. A repository only talks to the API client or local storage. Nothing skips a layer.

---

## 6. How the app works, step by step

### When the app starts

1. `main.dart` starts Firebase and waits until Firebase knows whether someone is already signed in.
2. It loads saved data (favorites, bag, theme) from the phone.
3. The app opens on the home route. A **guard** checks: signed in? Show Home. Not signed in? Show Login.

### When you sign in

1. You type an email and password and tap **Sign in**.
2. `LoginFormController` checks the fields (is the email valid? is the password empty?). If something is wrong, it stores the message and the field turns red.
3. If the fields are fine, it calls `AuthController.signIn`, which asks `FirebaseAuthRepository` to sign in with Firebase.
4. If Firebase says no (wrong password, no internet, ...), the repository converts Firebase's error code into a plain message such as "Incorrect email or password", and the screen shows it.
5. If Firebase says yes, the app replaces the login screen with the Home screen.

### When the product list loads

1. `ProductListController` starts in the **loading** state, so the screen shows a spinner.
2. It asks `ProductsRepository` for the first page. The repository asks `ApiClient`, which makes the HTTP request to DummyJSON.
3. The JSON that comes back is turned into `Product` objects.
4. The controller switches to the **data** state and the grid appears. If the request fails, it switches to the **error** state and the screen shows a message with a **Try again** button.
5. When you scroll near the bottom, the controller asks for the next page and appends it.

### When you search

1. Every key press goes to `setQuery`. The controller waits 400 ms after you stop typing (this is called debouncing) so it does not call the API for every letter.
2. It then loads page one from the search endpoint. An empty search box goes back to the full list.
3. No matches show a "No results" message with a **Clear search** button.

### When you tap the heart

1. `FavoritesController.toggle` adds or removes the product in a list held in memory.
2. Every widget that reads that list (the heart itself, the Favorites tab, the badge on the top bar, the dot on the bottom bar, the count on Profile) updates on its own.
3. The list is also written to phone storage, so it is still there after a restart.

---

## 7. Technical decisions explained

### State management: GetX

"State" is the data a screen needs right now: the list of products, whether it is loading, the text in the search box. "State management" is how that data is stored and how the screen finds out when it changes.

This app uses **GetX**, chosen because one small package covers three things a beginner would otherwise need three packages for:

- **Reactive state.** A controller holds values like `final query = ''.obs`. The `.obs` makes the value observable. A widget wrapped in `Obx(() => ...)` rebuilds automatically when a value it reads changes. No manual `setState` calls.
- **Dependency injection.** `Get.put(...)` creates an object once and `Get.find<...>()` fetches it from anywhere. That is how the heart button on a product card and the Favorites tab share one `FavoritesController`.
- **Routing.** `Get.toNamed('/products/12')` opens a screen by name. Each route can have a **binding** that creates the controller for that screen and disposes it when the screen closes, so memory is not wasted.

Objects that the whole app needs (the signed-in user, favorites, bag, categories, theme) are created once at startup in `InitialBinding`. Objects a single screen needs (the product list, a product's details, a login form) are created by that screen's binding.

### Loading and error states: `AsyncState`

Every controller that fetches data stores the result in an `AsyncState<T>`, which can be exactly one of:

| Value | Meaning | What the screen shows |
|---|---|---|
| `AsyncState.loading()` | waiting for the API | spinner |
| `AsyncState.data(value)` | it worked | the content |
| `AsyncState.error(error)` | it failed | message + Try again |

Because every screen uses the same three cases, they all behave the same way.

### API layer: the repository pattern

The code never calls the internet from inside a widget. The chain is:

```
Widget  →  Controller  →  Repository  →  ApiClient (Dio)  →  DummyJSON
```

- `ApiClient` wraps the Dio HTTP library, sets the base address and a timeout, and turns every kind of failure (no internet, timeout, 404, bad JSON) into one `ApiException` with a readable message.
- `ProductsRepository` knows the exact endpoints and returns typed objects. If DummyJSON changed its URLs tomorrow, only this file would change.

### Authentication: Firebase behind a small interface

`AuthRepository` is an interface with six methods: current user, a stream of sign-in changes, sign in, sign up, send password reset, sign out. `FirebaseAuthRepository` is the only implementation. The rest of the app never imports Firebase directly, so swapping the login provider later would touch one file.

Firebase's error codes (for example `email-already-in-use`) are mapped to app-level codes and to messages the screens can show.

### Local storage: SharedPreferences

Favorites, the bag, recently viewed products and the theme choice are saved with **SharedPreferences**, a simple key-value store built into Android and iOS. Each list is saved as a JSON string under one key. A small `LocalStore` class wraps it so features call `getJsonList` / `setJsonList` instead of dealing with strings.

SharedPreferences was chosen because the data is small and never needs querying. A database such as Hive or SQLite would be the right choice if the app stored thousands of items or needed to search them.

### Navigation

- Four tabs in a bottom bar, kept in an `IndexedStack` so switching tabs does not reset scroll positions.
- Details and Bag are pushed on top of the tabs and closed with the back arrow.
- Two guards protect the routes: `AuthGuard` (must be signed in) and `GuestGuard` (must be signed out, for the login and register screens).

---

## 8. Loading, error and empty states

| Situation | What the user sees |
|---|---|
| First load of products | Centered spinner |
| Loading the next page while scrolling | Small spinner under the grid |
| API failed on first load | "Something went wrong" + reason + **Try again** |
| API failed while loading the next page | The products already shown stay; a small **Retry** appears under them |
| No internet while loading products | "No internet connection. Please check your network and try again." |
| Search returned nothing | "No results for '...'" + **Clear search** |
| Category is empty | "No products available" + **Refresh** |
| No favorites yet | Heart icon, "No favorites yet" + **Browse products** |
| Empty bag | "Your bag is empty" + **Continue shopping** |
| Wrong password | Red text above the form: "Incorrect email or password." |
| Email already registered | "An account with this email already exists. Try signing in instead." |
| Sign-in while offline | "No connection. Check your network and try again." |

Pull down on the Products or Explore screen to refresh.

---

## 9. Tests

```bash
flutter analyze     # checks the code for mistakes and style problems
flutter test        # runs the unit tests
```

The tests live in the `test` folder and cover:

- `product_test.dart`: turning API JSON into `Product` objects, including missing fields.
- `formatters_test.dart`: price, rating and category label formatting.
- `products_repository_test.dart`: the repository calls the right endpoints with the right parameters, and API failures become `ApiException`.
- `favorites_controller_test.dart` and `cart_controller_test.dart`: adding, removing and saving to storage, including surviving a restart.
- `firebase_auth_repository_test.dart`: Firebase error codes map to the right app error.

---

## 10. Known limitations

- Favorites and the bag are saved per phone, not per account. Two people signing in on the same phone see the same favorites. Saving them under the user's id would fix this.
- Only email and password sign-in is available. There is no Google or Apple sign-in.
- Search and category filtering cannot be combined, because DummyJSON has no endpoint that does both.
- Sorting is by price, rating or discount only. There are no price-range filters.
- The **Checkout** button shows a message instead of a real payment flow.
- There are unit tests but no widget tests.

---

## 11. AI usage

### AI development workflow

- **Development:** I mainly use **Claude CLI** (Claude Code, by Anthropic) for development tasks such as code generation, debugging, refactoring, and implementing features.
- **UI development:** I use **Stitch AI** along with **Figma MCP** to accurately understand and implement UI designs, helping maintain consistency between the Figma design and the actual application.

### What the tools were used for

**Tool:** Claude Code (Claude CLI).

**How it helped:**

- Set up the feature-first folder structure and the GetX controllers, bindings and route guards.
- Wrote the DummyJSON repository, the `AsyncState` type and the loading / error / empty widgets.
- Built the screens from the Figma frames (read through Figma MCP) and refined the theme and dark mode.

**Tools:** Stitch AI and Figma MCP.

**How they helped:**

- Stitch AI was used to explore and draft the screen designs.
- Figma MCP let Claude Code read the Figma frames directly (layout, spacing, colours, text styles) so the Flutter screens match the design.
- Integrated Firebase Authentication and the error-code mapping.
- Migrated the project from an earlier Riverpod + go_router version to GetX and removed duplicated code.
- Helped debug problems found while testing on the emulator (for example an `Obx` that read no reactive value, and a snackbar that never closed in Flutter 3.38).
- Wrote the unit tests and this README.

All submitted code was reviewed and is understood by me.

---

## 12. Glossary

| Term | Plain-language meaning |
|---|---|
| **API** | A web address that returns data (JSON) for programs to use, instead of a page for people to read. |
| **JSON** | A text format for data, e.g. `{"title": "Phone", "price": 499}`. |
| **Endpoint** | One specific address of an API, e.g. `/products/search`. |
| **Widget** | A piece of the screen in Flutter. Buttons, text, whole pages: all widgets. |
| **State** | The data a screen needs right now. |
| **Controller** | A class that holds state and handles actions for a screen (GetX name). |
| **`.obs` / `Obx`** | `.obs` makes a value observable; `Obx` rebuilds a widget when an observed value changes. |
| **Repository** | A class whose only job is to get or save data (from an API or the phone). |
| **Model** | A Dart class that describes the shape of data, e.g. `Product` with `title`, `price`, `rating`. |
| **Binding** | A GetX class that creates the controllers a screen needs when it opens. |
| **Route / navigation** | Moving between screens. Each screen has a route name like `/login`. |
| **Guard / middleware** | Code that runs before a screen opens and can redirect, e.g. to Login if you are signed out. |
| **Dependency injection** | Creating an object once and handing it to whoever needs it, instead of creating copies. |
| **Debounce** | Waiting a short moment after the user stops typing before doing work. |
| **Pagination** | Loading a list in pages (20 items at a time) instead of all at once. |
| **SharedPreferences** | Simple built-in storage on the phone for small values. |
| **Firebase Authentication** | Google's service that stores accounts and checks passwords for you. |
| **Dio** | The library used to make HTTP requests. |
| **APK** | The installable Android app file. |
