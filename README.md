# 🛡️ BasicAV – PowerShell Antivirus & Honeypot

**BasicAV** to modularny, lokalny system bezpieczeństwa hosta stworzony w całości w PowerShell.
Projekt łączy funkcjonalność antywirusa, honeypota oraz lekkiego EDR,
opierając się na natywnych możliwościach systemu Windows – bez potrzeby instalowania zewnętrznych narzędzi.

---

## 🎯 Cel projektu

- Zapewnienie lokalnej ochrony systemu Windows przy użyciu PowerShell
- Detekcja złośliwych plików, nieautoryzowanej aktywności i skanowania portów
- Implementacja pasywnych honeypotów portowych (na podstawie Windows Firewall)
- Implementacja honeypotów plikowych (pułapki dla malware i intruzów)
- Możliwość integracji z systemami logowania i alertowania

---

## ✅ Aktualny stan

- ✅ Opracowana struktura katalogów projektu
- ✅ Załadowanie i walidacja pliku `config.json` z ekspansją zmiennych środowiskowych
- ✅ Funkcja sprawdzająca uprawnienia administratora
- ✅ Automatyczny import wszystkich modułów z folderu `Modules`
- ✅ Wstępna struktura funkcji `Start-BasicAV`
- ✅ Podstawowe komunikaty systemowe i szkielet menu interaktywnego

---

## 🛠️ W planach

- [ ] Dodanie silnika skanowania plików i hashów
- [ ] Budowa modułu honeypota portowego
- [ ] Budowa honeypota plikowego z monitorowaniem dostępu
- [ ] System logowania i alertów
- [ ] Wykrywanie w logach zdefiniowanych wcześniej ataków
- [ ] Moduł EDR (zbieranie procesów i zdarzeń)
- [ ] Panel CLI do zarządzania systemem
- [ ] Integracja z systemami zewnętrznymi (SMTP, Syslog, itp.)

---

## 📋 Wymagania

- Windows 10 / 11 / Server
- PowerShell 5.1+
- Uprawnienia administratora

---

## 📄 Licencja

Projekt open-source – licencja MIT.

---

## ✍️ Autor

Projekt tworzony z pasji do bezpieczeństwa i PowerShella przez [LazyScriptTurtle].
