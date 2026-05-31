@echo off
echo === Running flutter clean ===
call flutter clean

echo === Running dart pub get ===
call dart pub get

echo === Running dart run build_runner build ===
call dart run build_runner build

echo === Done ===
pause