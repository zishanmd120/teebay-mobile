## Teebay Doc

1. Authentication – Login & Signup
✔️ Approach: Implemented using Flutter and GetX for state management.
API calls made using http.
Basic auth token is saved in SharedPreferences after successful login.
Login & Signup includes form validation and API error handling.

Corner Cases Handled:
Network failures and incorrect credentials show proper user-facing messages.
Prevented multiple login taps with loading state.
Password confirmation mismatch handled with client-side validation.


2. All Products List Page
✔️ Approach: Used ListView.builder to show product listings.
Data is fetched from the backend for all users. 
User can see their own & others products and buy / rent products.

Corner Cases Handled:
Users own products can not buy / rent.

3. Transaction
✔️ Approach:Implemented using TabBar and TabBarView to show:
Bought products
Sold products
Borrowed items
Lent items
Each tab loads its respective data list via API.

Corner Cases:
Used Obx with loading indicators for each list independently.
build() API call inside item widgets.

4. My Products List Page
✔️ Approach:This page shows products listed by the current user (both for sale and rent).
Fetches product list on init, and uses Obx to update UI dynamically.
User can update their data. 

5. Product Buy / Rent Page
✔️ Approach: Product details shown after user taps a card.
Separate actions for Buy and Rent.
Order confirmation dialogs and transaction creation APIs integrated.

Corner Cases:
Prevented double taps on Buy/Rent buttons.
Managed navigation stack cleanly post-purchase.