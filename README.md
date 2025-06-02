# RaPizz — Guide de démarrage rapide

> **But** : vous permettre de cloner/ouvrir, configurer et lancer le projet RaPizz en moins de 5 minutes.

---
## 1. Prérequis

| Outil                   | Version minimale | Où le récupérer                                            |
|-------------------------|------------------|------------------------------------------------------------|
| **Java JDK**            | 17               | <https://adoptium.net/> ou gestionnaire de paquets         |
| **Maven**               | 3.9              | Inclus dans *Extension Pack for Java* de VS Code ou <https://maven.apache.org/> |
| **PostgreSQL**          | 17               | <https://www.postgresql.org/download/>                     |
| **Visual Studio Code**  | Dernière         | <https://code.visualstudio.com/>                           |
| **Extension Pack for Java** | —            | Marketplace VS Code                                        |

**Remarque importante : **
- Assurez-vous que **`JAVA_HOME`** pointe vers le dossier d’installation du JDK ; Maven en a besoin pour fonctionner correctement.
- VS Code détecte automatiquement Maven et Java via les extensions, mais _en ligne de commande_, vous devez avoir :`JAVA_HOME` et `PATH` configurés.

Les dépendances Java (JDBC, Log4j, Lombok) sont gérées automatiquement par **Maven**.

---
## 2. Installation du projet

**Préparer la base de données PostgreSQL** :  
   Ouvrez un terminal :
   ```bash
   # se connecter en tant que super-utilisateur PostgreSQL (ex. 'postgres')
   psql -U postgres

   -- 1. Créer la base de données
   CREATE DATABASE rapizz;
   -- 2. Quitter psql
   \q

   # 3. Exécuter les scripts SQL depuis le terminal
   psql -U <PGUSER> -d rapizz -f sql/create_tables.sql
   psql -U <PGUSER> -d rapizz -f sql/logique_metier.sql
   psql -U <PGUSER> -d rapizz -f sql/requete.sql   # (facultatif)
   ```

---
## 3. Configuration de la connexion

Le projet lit `src/main/resources/db.properties`, qui référence les variables d’environnement `PGUSER` et `PGPASS`:
```properties
jdbc.url=jdbc:postgresql://localhost:5432/rapizz
jdbc.user=${env:PGUSER}
jdbc.password=${env:PGPASS}
```

### 3.1. Méthode A — variables d’environnement (recommandée)
Ajoutez dans votre shell :
```bash
export PGUSER=<user>
export PGPASS=<password>
```
Sur Windows (PowerShell) :
```powershell
setx PGUSER "<user>"
setx PGPASS "<password>"
```

### 3.2. Méthode B — fichier `.env`
Créez un fichier `.env` à la racine du projet :
```
PGUSER=<user>
PGPASS=<password>
```
VS Code charge automatiquement ce fichier dans le terminal intégré.

> **Que mettre dans `PGUSER` / `PGPASS` ?**  
> • **`PGUSER`** : nom du rôle (utilisateur) PostgreSQL ; par défaut, souvent `postgres` (créé lors de l’installation), sinon le rôle que vous avez créé (ex. `rapizz`).  
> • **`PGPASS`** : mot de passe associé à ce rôle.  
>  
> **Créer un utilisateur dédié si nécessaire :**  
> ```sql
> -- dans psql en tant que super-utilisateur
> CREATE ROLE rapizz LOGIN PASSWORD 'monMotDePasse';
> GRANT ALL PRIVILEGES ON DATABASE rapizz TO rapizz;
> ```
> Ensuite, indiquez :
> ```env
> PGUSER=rapizz
> PGPASS=monMotDePasse
> ```

---
## 4. Lancer l’application

### 4.1. Depuis VS Code (recommandé)
1. **Ouvrez** le dossier `RaPizz` (contenant `pom.xml`).  
2. VS Code doit détecter automatiquement le `pom.xml` et proposer « Import Maven Project » en bas à droite ; cliquez dessus pour générer le classpath.  
   **Si cette invite n’apparaît pas :**
   - Vérifiez que l’extension **Maven for Java** est installée.
   - Ouvrez la palette (**Ctrl + Shift + P**), lancez :
     * `Java: Clean Java Language Server Workspace` (puis relancez VS Code) ;
     * puis `Maven: Reload Project`.
   - Dans la vue latérale **Maven** (icône « M »), cliquez sur **➕ Add Project** et sélectionnez `pom.xml`.
   - À défaut, compilez `mvn clean install` dans le terminal intégré ; VS Code proposera l’import à la fin.  
3. Dans l’explorateur, ouvrez `src/main/java/com/rapizz/App.java`.  
4. Cliquez sur ▶️ au‑dessus de `main`, ou appuyez sur **F5**.

### 4.2. Depuis le terminal
```bash
# placez-vous à la racine du projet (contenant pom.xml)
cd /chemin/vers/RaPizz
mvn compile exec:java -Dexec.mainClass=com.rapizz.App
```


## 5. Structure du projet

RaPizz
├─ sql/                         # scripts PL/pgSQL & requêtes
│  ├─ create_tables.sql
│  ├─ logique_metier.sql
│  └─ requete.sql
├─ src/
│  └─ main/
│     ├─ java/com/rapizz/…      # code (model, dao, ui…)
│     │   ├─ App.java
│     │   ├─ model/
│     │   │   └─ Pizza.java
│     │   ├─ dao/
│     │   │   ├─ AbstractDAO.java
│     │   │   └─ PizzaDAO.java
│     │   ├─ service/
│     │   │   └─ LivraisonService.java
│     │   └─ ui/
│     │       ├─ MainFrame.java
│     │       └─ panels/
│     │           ├─ MenuPanel.java
│     │           ├─ CommandePanel.java
│     │           └─ StatsPanel.java
│     └─ resources/
│         └─ db.properties
├─ pom.xml                      # dépendances Maven
├─ .vscode/settings.json        # config VS Code Java
└─ README.md                    # ce fichier

