# 🚀 Scripts d'Installation Automatique - Environnement de Développement Ubuntu 24.04

**Collection complète de scripts bash pour installer un environnement de développement polyglotte sur Ubuntu 24.04**

## 🌟 Vue d'ensemble

Cette collection de scripts permet d'installer automatiquement **18+ langages de programmation et outils** sur Ubuntu 24.04 LTS, avec gestion des versions, vérifications d'intégrité, et configuration automatique de l'environnement.

### ⚡ Installation Rapide

```bash
# Télécharger et rendre exécutable le script principal
chmod +x install_complete_dev_stack.sh

# Lancer l'installation interactive
./install_complete_dev_stack.sh
```

## 📦 Stack Technologique Couverte

### 🌐 Frontend & Web
- **JavaScript (JS)** + **TypeScript (TS)** via Node.js
- **Node.js** + **npm** (runtime et gestionnaire de packages)
- **React** (bibliothèque UI)
- **Angular** (framework frontend complet)
- **Vite** (bundler rapide)
- **CSS** + **Tailwind CSS** (styling moderne)

### 🖥️ Backend & Enterprise
- **Python3** + **pip** (data science, web, automation)
- **Java Eclipse Temurin** (OpenJDK, versions 17 & 21 LTS)
- **C# (.NET SDK)** (développement Microsoft multiplateforme)
- **Go (Golang)** (cloud native, microservices)
- **Rust** + **Cargo** (systems programming, sécurité mémoire)
- **C++** (performance, embedded, gaming)

### 📱 Mobile & Multiplatform
- **Kotlin** (Android, multiplateforme JVM)

### ⛓️ Blockchain & Web3
- **Solidity** (smart contracts Ethereum)

### 📊 Data Science & Analytics
- **R** + **RStudio** (analyse statistique, visualisation)

### 🏗️ DevOps & Infrastructure
- **Docker** + **Docker Compose** (containerisation)
- **Kubernetes** (kubectl pour orchestration)

## 🎯 Scripts Disponibles

### 📜 Scripts Principaux

| Script | Description |
|--------|-------------|
| `install_complete_dev_stack.sh` | 🌟 **Script COMPLET** - 18+ langages avec menu interactif |
| `install_dev_environment.sh` | Version précédente (7 langages de base) |

### 🔧 Scripts Individuels

| Langage/Outil | Script | Fonctionnalités |
|---------------|--------|----------------|
| **Node.js** | `install_nodejs.sh` | NVM, npm, outils frontend |
| **Python3** | `install_python3.sh` | pip, virtualenv, outils dev |
| **Java** | `install_java_temurin.sh` | Eclipse Temurin, versions multiples |
| **C#** | `install_csharp.sh` | .NET SDK, ASP.NET Core |
| **Go** | `install_go.sh` | Dernière version, workspace |
| **Rust** | `install_rust.sh` | rustup, cargo, clippy, rustfmt |
| **C++** | `install_cpp.sh` | GCC, Clang, CMake, libs |
| **Kotlin** | `install_kotlin.sh` | SDKMAN, runtime JVM |
| **Solidity** | `install_solidity.sh` | Compilateurs, outils blockchain |
| **R** | `install_r.sh` | CRAN, RStudio, packages essentiels |
| **Docker** | `install_docker.sh` | Docker Engine, Compose |

## 🎛️ Modes d'Installation

### 1. Installation Complète (Recommandée)
```bash
./install_complete_dev_stack.sh
# Choisir option 1: Installation complète
```

### 2. Packs Thématiques
- **🌐 Frontend Pack**: Node.js + React + Angular + Tailwind
- **🖥️ Backend Pack**: Python + Java + C# + Go + Rust
- **📱 Mobile Pack**: Java + Kotlin + Node.js
- **⛓️ Blockchain Pack**: Node.js + Solidity + Go + Rust
- **📊 Data Science Pack**: Python + R + C++
- **⚡ Systems Pack**: Rust + C++ + Go
- **🏗️ DevOps Pack**: Docker + Kubernetes + Go + Python

### 3. Installation Personnalisée
Choisir individuellement chaque langage selon vos besoins.

### 4. Scripts Individuels
```bash
# Exemples d'installation individuelle
./install_nodejs.sh    # Node.js uniquement
./install_python3.sh   # Python3 uniquement
./install_rust.sh      # Rust uniquement
```

## ✨ Fonctionnalités des Scripts

### 🛡️ Sécurité & Robustesse
- ✅ **Vérification des versions existantes** (évite les doublons)
- ✅ **Gestion d'erreurs robuste** (script s'arrête en cas d'échec critique)
- ✅ **Validation de l'installation** (tests après installation)
- ✅ **Gestion des permissions sudo**
- ✅ **Nettoyage automatique** des fichiers temporaires

### 🎨 Interface Utilisateur
- ✅ **Messages colorés et informatifs**
- ✅ **Progress indicators**
- ✅ **Menus interactifs**
- ✅ **Résumés post-installation**

### ⚙️ Configuration Automatique
- ✅ **Variables d'environnement** (PATH, *_HOME, etc.)
- ✅ **Configuration des profiles** (~/.bashrc, /etc/profile.d/)
- ✅ **Création de projets de test**
- ✅ **Installation de packages/outils essentiels**

## 🧪 Projets de Test Créés

Chaque script crée automatiquement des projets de test:

```
~/nodejs-test/       # Exemples JavaScript/TypeScript
~/python-test/       # Scripts Python avec packages
~/java-test/         # Applications Java
~/csharp-test/       # Projets C# .NET
~/go/                # Workspace Go
~/cpp-test/          # Projets C++ avec Makefile/CMake
~/kotlin-test/       # Programmes Kotlin
~/solidity-test/     # Smart contracts Ethereum
~/r-test/            # Scripts R et analyses de données
```

## 📋 Pré-requis

- **Ubuntu 24.04 LTS** (optimisé pour cette version)
- **Compte utilisateur avec privilèges sudo**
- **Connexion Internet** (pour téléchargements)
- **8-12 GB d'espace disque libre** (installation complète)

## 🚀 Instructions d'Installation

### 1. Télécharger les scripts
```bash
# Si vous avez tous les scripts dans un dossier
cd /path/to/scripts
chmod +x *.sh
```

### 2. Lancer l'installation
```bash
# Installation complète interactive
./install_complete_dev_stack.sh

# Ou installation d'un langage spécifique
./install_python3.sh
```

### 3. Suivre les instructions
- Répondre aux prompts interactifs
- Saisir le mot de passe sudo si demandé
- Choisir les options d'installation

### 4. Post-installation
```bash
# Recharger l'environnement
source ~/.bashrc

# Ou redémarrer le terminal
```

## 🧪 Tests et Vérification

### Commandes de Test Recommandées

```bash
# Frontend & Web
node --version && npm --version
npx create-react-app --version

# Backend & Systems  
python3 --version && pip3 --version
java -version && javac -version
dotnet --version
go version
rustc --version && cargo --version
g++ --version && clang++ --version

# Spécialisés
kotlin -version
solc --version || solcjs --version  
R --version

# DevOps
docker --version && docker compose version
kubectl version --client
```

### Projets de Test
```bash
# Tester les projets créés automatiquement
cd ~/python-test && python3 test_script.py
cd ~/go && go run hello.go
cd ~/cpp-test && make && ./hello
```

## 🔧 Configuration Avancée

### Variables d'Environnement Configurées
```bash
# Java
export JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64
export PATH=$PATH:$JAVA_HOME/bin

# Go
export GOROOT=/usr/local/go
export GOPATH=$HOME/go  
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Rust
export PATH=$PATH:$HOME/.cargo/bin

# Kotlin (si SDKMAN)
export SDKMAN_DIR="$HOME/.sdkman"
```

### Gestionnaires de Packages Installés
- **npm** (Node.js packages)
- **pip3** (Python packages)  
- **cargo** (Rust packages)
- **go modules** (Go packages)
- **NuGet** (C# packages)
- **Maven/Gradle** (Java packages)
- **CRAN** (R packages)

## 🛠️ Résolution de Problèmes

### Problèmes Courants

**1. Erreur de permissions**
```bash
sudo chmod +x *.sh
```

**2. Variables d'environnement non chargées**
```bash
source ~/.bashrc
# ou redémarrer le terminal
```

**3. Docker nécessite redémarrage de session**
```bash
sudo usermod -aG docker $USER
newgrp docker
# ou redémarrer la session
```

**4. Erreur "command not found"**
```bash
# Vérifier que le PATH contient les bons répertoires
echo $PATH
source ~/.bashrc
```

### Logs et Debug
Chaque script affiche des messages détaillés. En cas d'erreur:
1. Lire attentivement le message d'erreur
2. Vérifier les prérequis
3. Relancer le script spécifique qui a échoué

## 📚 Documentation Supplémentaire

### IDEs Recommandés
- **VS Code** - Excellent support pour tous les langages
- **JetBrains Suite** - IDEs spécialisés (IntelliJ, PyCharm, WebStorm, Rider)
- **RStudio** - IDE dédié R (installé automatiquement)

### Ressources Utiles
- [Node.js Documentation](https://nodejs.org/docs/)
- [Python.org](https://python.org)
- [Go Documentation](https://golang.org/doc/)
- [Rust Book](https://doc.rust-lang.org/book/)
- [.NET Documentation](https://docs.microsoft.com/dotnet/)
- [Kotlin Documentation](https://kotlinlang.org/docs/)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [R Documentation](https://cran.r-project.org/)

## 🤝 Contribution

Ces scripts sont générés automatiquement et optimisés pour Ubuntu 24.04. Pour des améliorations:

1. Tester sur différents systèmes
2. Signaler les bugs ou problèmes
3. Proposer des optimisations
4. Ajouter support pour d'autres versions Ubuntu

## 📄 Licence

Scripts open source, libres d'utilisation et de modification.

## 🎉 Conclusion

Cette collection de scripts vous permet d'obtenir un environnement de développement polyglotte complet en quelques commandes. Parfait pour:

- **Développeurs Full-Stack**
- **Data Scientists** 
- **Développeurs Blockchain**
- **Ingénieurs DevOps**
- **Étudiants en informatique**
- **Équipes de développement**

**🚀 Transformez votre Ubuntu 24.04 en station de développement polyglotte en moins d'une heure !**
