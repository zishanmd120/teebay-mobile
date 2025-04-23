1. Authentication – Login & Signup
   Approach:

Built using Flutter and GetX for state management.

API calls handled via the http package.

After successful login, the basic auth token is saved in SharedPreferences.

Input validations include:

Email format validation

Password: must be 6 digits minimum

Name field cannot be empty

Password and Confirm Password must match

Validation is handled via TextFormField validators.

API is only triggered if all fields are validated.

Dynamic error handling for API responses (supports both Map and List error formats).

Corner Cases Handled:

Displays user-friendly error messages for network issues and invalid credentials.

Prevents multiple login attempts using a loading state.

Client-side password confirmation check prevents unnecessary API calls.

2. All Products List Page
   Approach:

Uses ListView.builder to render the product list.

Data is fetched from the backend and shows all users' products.

Users can view, buy, or rent products except their own.

Corner Cases:

Products created by the logged-in user do not show Buy/Rent buttons.

Logic checks if sellerId == currentUserId.

3. Add Product
   Approach:

Allows users to upload products with images and details.

Form submission triggers an API call.

Corner Cases:

Errors are shown via toast messages, helping users identify what went wrong.

4. Transactions
   Approach:

Tab-based UI using TabBar and TabBarView.

Shows:

Bought Products

Sold Products

Borrowed Items

Lent Items

Two APIs used:

One for transactions

One for rentals

Filtering based on sellerId / buyerId to ensure users see only their relevant data.

Corner Cases:

Independent loading states using Obx for each tab.

build() method in item widgets includes API calls with safeguards.

5. My Products List Page
   Approach:

Displays products listed by the current user (both for sale and rent).

Data is fetched during initState() and updated dynamically using Obx.

Allows product updates directly from this screen.

6. Product Buy / Rent Page
   Approach:

Tapping a product card navigates to this page with full product details.

Users can choose to Buy or Rent the item.

Order confirmation dialogs appear before triggering the transaction API.

On successful transaction:

A notification is displayed.

Tapping it navigates to the relevant page.

Corner Cases:

Prevents double taps on Buy/Rent buttons using button state or debounce.

Handles navigation cleanup post-transaction to avoid stack issues.

7. Token & User ID Storage
   User ID and auth token are saved in SharedPreferences.

Used for authenticated API calls across the app.