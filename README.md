# 🌍 Rahhala – Travel Community App

Rahhala is a community-driven travel app built with **Flutter** and **Supabase**. Users can sign in, share travel experiences, explore posts by city, and connect with a global travel community.

## ✨ Features

- 🔐 **Authentication** with Email & Google Sign-In (using Supabase Auth)
- 📝 **Create & View Posts** with text, images, and location
- 🗂️ **City-Based Filtering** for exploring posts by destination
- 📤 **Upload Images** to Supabase Storage
- 🧠 **State Management** using `flutter_bloc` (Cubit)
- 📱 **Responsive UI** with `flutter_screenutil`
- 🔁 **Real-Time Updates** using Supabase Streams
- 🧾 **Shared Preferences** for persistent login
- ✅ Prevents auto logout unless user logs out manually

---

## 📸 Screenshots

| Home | 
|----------------|
| ![photo_٢٠٢٥-٠٥-٠٨_٢٠-٤٢-٣١](https://github.com/user-attachments/assets/bceaa221-e5f7-4e02-b1f0-9f0e1bec025c)|

| Home | 
|----------------|
| ![photo_٢٠٢٥-٠٥-٠٨_٢٠-٤٤-٠٤](https://github.com/user-attachments/assets/f303889b-b404-4a1c-8cde-dd50af89b88d) |

| Profile |
|----------------|
| ![photo_٢٠٢٥-٠٥-٠٨_٢٠-٤٢-٣١ (2)](https://github.com/user-attachments/assets/ac7e8f29-6a32-4d60-a103-9eebdfd33b1a)|

| City Filter |
|-------------|
| ![photo_٢٠٢٥-٠٥-٠٨_٢٠-٤٢-٣٠](https://github.com/user-attachments/assets/30790df3-59f5-4800-a66a-6f8525f97df8) |  

| Create Post  | 
|----------------|
| ![photo_٢٠٢٥-٠٥-٠٨_٢٠-٤٢-٢٩](https://github.com/user-attachments/assets/23d112ff-66e6-43ee-9ddb-b80a8244283d)|






| SignIn | 
|----------------|
| ![photo_٢٠٢٥-٠٥-٠٨_٢٠-٤٢-٢٩ (2)](https://github.com/user-attachments/assets/ff4a3d3e-2456-4b19-85b6-575c09c89c28) |

| LogIn | 
|----------------|
| ![photo_٢٠٢٥-٠٥-٠٨_٢٠-٤٢-٢٨](https://github.com/user-attachments/assets/ff1d52a2-2732-4f28-931c-bd63b8f6507a) |




---

## 🛠️ Tech Stack

| Tool              | Purpose                                 |
|-------------------|------------------------------------------|
| Flutter           | UI Framework                            |
| Supabase          | Backend, Auth, Realtime, Storage        |
| flutter_bloc      | State Management                        |
| flutter_login     | Login UI                                |
| shared_preferences| Local Storage                           |
| lottie            | Animations                              |
 

---

## 🚀 Getting Started

1. **Clone the repo**
   ```bash
   https://github.com/noRan56/Rahhala.git
   cd rahhala
2. **Install dependencies**
   ```bash
   flutter pub get
3. **Set up Supabase**
     - Create a project on https://supabase.com

    - Create a posts table and a storage bucket also named posts

    - Enable Google Auth (OAuth) in the Supabase project

    - Add your Supabase url and anonKey in lib/main.dart or a .env file

4. **Run the app**
    ```bash
    flutter run


## 📁 Project Structure
    ```bash
     lib/
      ├── core/           # Reusable widgets
      ├── data/
      │   ├── cubit/            # User cubit for state management
      │   ├── repositories/     # Supabase & local storage logic             
      ├── presentation_layer/   # Views and UI layer
      └── main.dart             # Entry point


## 🙋‍♂️ Contributing
 - Feel free to open issues or submit pull requests. Feedback and improvements are always welcome!

## 📬 Contact
  - Developed with ❤️ by [Nouran Yasser]
  - 📧 Email: noran.nassef12@gmail.com
  - 🔗 LinkedIn: https://www.linkedin.com/in/nouraneyasser/



