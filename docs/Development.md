# Development

# Install

```powershell
choco install au
```

# Build

```powershell
choco pack .\automatic\fafarunner\fafarunner.nuspec
```

# Local Install

```powershell
# Run as admini
choco install fafarunner --pre --version="0.0.1-alpha3" --source="C:\Users\ying\workspace\qiazo\chocolatey-packages"
```

# Push

```powershell
choco push .\fafarunner.0.0.1-alpha3.nupkg --api-key=<api key> --source https://push.chocolatey.org/ -d
```
