# 🛒 Flutter E-Commerce App

A clean architecture Flutter application that demonstrates fetching, caching, and displaying a product list from an API with search, filter, and offline support — built using the **BLoC (MVVM)** pattern and **SQFLite**.

## 🚀 Features

### ✅ Core Features
- 🔰 **Splash Screen**: A splash screen on app startup.
- 📦 **Product List & Pagination**:
  - Data fetched from API using Repository pattern.
  - Pagination simulated with "Page 2" data.
- 🔎 **Search**:
  - Search products by name using BLoC.
- 🧮 **Sorting**:
  - Sort by **Price** (Low to High/Hight to Low).
  - Sort by **Rating**.
- ⚡ **State Management**:
  - Implemented using **BLoC** with MVVM.
  - Follows **Clean Architecture** to separate concerns.
- 📴 **Offline Support**:
  - API data cached using **SQFLite**.
  - If offline, previously fetched data is shown from local database.
  - Displays FlushBar when offline.
- ❌ **No Internet & No Cache**:
  - Shows error state/exception UI when neither internet nor cached data is available.
- 📡 **Connectivity Status**:


## 📷 Screenshots:

### 🔹 Splash Screen
![image alt](https://github.com/akanto99/Qtec-Task-Ecommerce/blob/main/assets/screenshot/splash.jpg?raw=true)

### 🔹 Product List & Pagination (Online)
![image alt](https://github.com/akanto99/Qtec-Task-Ecommerce/blob/main/assets/screenshot/product.jpg?raw=true)

### 🔹 Offline Mode (Cached Data)
![image alt](https://github.com/akanto99/Qtec-Task-Ecommerce/blob/main/assets/screenshot/dbbrock.jpeg?raw=true)

### 🔹 Search Functionality
![image alt](https://github.com/akanto99/Qtec-Task-Ecommerce/blob/main/assets/screenshot/search.jpeg?raw=true)

### 🔹 Sorting (Price & Rating)
![image alt](https://github.com/akanto99/Qtec-Task-Ecommerce/blob/main/assets/screenshot/sort.jpeg?raw=true)

### 🔹 Offline Flushbar Notification
![image alt](https://github.com/akanto99/Qtec-Task-Ecommerce/blob/main/assets/screenshot/nointerPro.jpg?raw=true)
