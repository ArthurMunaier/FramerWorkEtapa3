# Atividade — Integração Python API + Flutter (Voos)

```
AtividadeVoos/
├── backend/    -> Python / Flask (API de voos, código da aula)
└── voos_app/   -> Flutter (pages / providers / services)
```

## Terminal 1 — Python
```bash
cd backend
pip install -r requirements.txt
python app.py
```

## Terminal 2 — Flutter
Na primeira vez, gere as pastas de plataforma (android, web...):
```bash
cd voos_app
flutter create .
flutter pub get
flutter run -d chrome
```

Fluxo: `Page -> Provider -> Service -> API Python`
