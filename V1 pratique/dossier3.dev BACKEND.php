# Réponses au Dossier 3 : Développement Back End

## 1) Commande de création de la migration pour la table batteries
bash
php artisan make:migration create_batteries_table


## 2) Code des méthodes up et down du fichier de migration
php
public function up()
{
    Schema::create('batteries', function (Blueprint $table) {
        $table->id();
        $table->string('numero_serie')->unique();
        $table->string('capacite');
        $table->string('sante_batterie');
        $table->integer('nombre_cycle');
        $table->string('statut')->default('En service');
        $table->timestamps();
    });
}

public function down()
{
    Schema::dropIfExists('batteries');
}


## 3) Commande pour appliquer la migration
bash
php artisan migrate


## 4) Commande pour créer une migration de modification
bash
php artisan make:migration modify_batteries_table --table=batteries


## 5) Code pour ajouter un index et changer le type de colonne
php
public function up()
{
    Schema::table('batteries', function (Blueprint $table) {
        $table->string('capacite', 15)->change();
        $table->index('statut');
    });
}

public function down()
{
    Schema::table('batteries', function (Blueprint $table) {
        $table->string('capacite')->change();
        $table->dropIndex(['statut']);
    });
}


## 6) Modèles Batterie et Vélo
php
// app/Models/Batterie.php
class Batterie extends Model
{
    protected $fillable = [
        'numero_serie', 'capacite', 'sante_batterie', 
        'nombre_cycle', 'statut'
    ];

    public function velo()
    {
        return $this->belongsTo(Velo::class);
    }
}

// app/Models/Velo.php
class Velo extends Model
{
    protected $fillable = ['modele', 'description'];

    public function batterie()
    {
        return $this->hasOne(Batterie::class);
    }
}


## 7) Commande de création du contrôleur
bash
php artisan make:controller VeloController


## 8) Méthode GetBatterie
php
public function GetBatterie($id)
{
    return Batterie::findOrFail($id);
}


## 9) Méthode AfficherBatterie
php
public function AfficherBatterie($id)
{
    $batterie = $this->GetBatterie($id);
    return view('InfoBatterie', compact('batterie'));
}


## 10) Vue InfoBatterie (ressources/views/InfoBatterie.blade.php)
php
<table>
    <thead>
        <tr>
            <th>Id</th>
            <th>Numéro série</th>
            <th>Capacité</th>
            <th>Santé batterie</th>
            <th>Nombre cycle</th>
            <th>Statut</th>
            <th>Modifier</th>
            <th>Supprimer</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>{{ $batterie->id }}</td>
            <td>{{ $batterie->numero_serie }}</td>
            <td>{{ $batterie->capacite }}</td>
            <td>{{ $batterie->sante_batterie }}</td>
            <td>{{ $batterie->nombre_cycle }}</td>
            <td>{{ $batterie->statut }}</td>
            <td><a href="#">Modifier</a></td>
            <td><a href="#">Supprimer</a></td>
        </tr>
    </tbody>
</table>


## 11) Méthode SupprimerBatterie
php
public function SupprimerBatterie($id)
{
    Batterie::findOrFail($id)->delete();
    return redirect()->route('welcome');
}


## 12) Commande pour créer le middleware
bash
php artisan make:middleware AutorisationSuppression


## 13) Méthode handle du middleware
php
public function handle(Request $request, Closure $next)
{
    if (auth()->user() && auth()->user()->name === 'toto') {
        return $next($request);
    }
    
    return response()->json([
        'message' => 'Vous n\'êtes pas autorisé à effectuer cette opération de suppression'
    ], 403);
}


## 14) Code de la route protégée
php
Route::delete('/batteries/{id}', [VeloController::class, 'SupprimerBatterie'])
    ->middleware('autorisationSuppression');
