# Flutter To-Do List App

- 📱 [Download the app here!](https://github.com/milenafs/todo-list-app/actions/runs/10511418707/artifacts/1843130323)
- 💻 [Web view here!](https://milenafs.github.io/todo-list-app/)

### 📡 **Project Overview:**
This Flutter app is a simple and minimalist to-do list application that allows users to manage their daily tasks effectively. The core functionalities include the ability to add new tasks, delete tasks, and mark tasks as completed. The design of the app is intentionally clean and minimalistic, focusing on usability and a distraction-free user experience.

### 🍁 **Purpose:**
The primary goal of this project was to refresh and enhance my Flutter development skills. During my internship, I was tasked with a challenge involving Flutter, a framework I wasn't familiar with since my experience is primarily in web front-end development. This project served as a hands-on learning opportunity, allowing me to get comfortable with Flutter and its ecosystem by building a functional and visually appealing application from scratch.

https://github.com/user-attachments/assets/4c0416bd-59cc-4682-9037-df0a62a1495f

### 🚀 **Key Features:**
- **Add Tasks:** Easily add new tasks to your to-do list.
- **Delete Tasks:** Remove tasks that are no longer needed.
- **Complete Tasks:** Mark tasks as completed to keep track of your progress.
- **Minimalist Design:** A clean and straightforward interface to keep you focused on your tasks.

### ⚗️ **Technologies Used:**
- **Flutter:** For building the cross-platform mobile application.
- **Dart:** The programming language used in Flutter for writing the app's logic.

### 🍎 **Learning Outcomes:**
- Gained practical experience with Flutter, enhancing my ability to work with this framework in future projects.
- Improved understanding of mobile app development principles and best practices.
- Bridged the gap between my web front-end skills and mobile development using Flutter.

> Followed this tutorial: https://www.youtube.com/watch?v=K4P5DZ9TRns

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How to run a Flutter project on th web

1. Ensure you have the Flutter SDK installed and that it's up to date. You can check your Flutter version and update it by running:
```sh
flutter upgrade 
```
1. Enable web support if you haven't already. Run:
```sh
flutter config --enable-web
```
1. Check for available devices to ensure the web device is available:
```sh
flutter devices
```
1. Run the project on the web using the following command:
```sh
flutter run -d chrome
```
This will build and serve your Flutter project on a local web server, and it will open the default web browser to display your application.

## Useful Flutter Commands

```sh
flutter pub get
```
Baixa e instala as dependências especificadas no arquivo pubspec.yaml.

```sh
flutter --version
```
Este comando mostrará a versão atual do Flutter instalada no seu sistema, bem como outras informações sobre o Dart SDK e as ferramentas instaladas.

```sh
flutter doctor
```
Este comando fornece um diagnóstico do seu ambiente de desenvolvimento Flutter e inclui a versão do Flutter instalada.

```sh
# Clean the build directory
flutter clean

# Rebuild the project for Linux
flutter build linux

# Run the application
sudo env "PATH=$PATH" flutter run -d linux
```
To run the flutter application on linux device

```sh
flutter pub outdated
```
This command will provide a list of all dependencies and indicate whether they are up-to-date, have newer versions available, or are outdated.