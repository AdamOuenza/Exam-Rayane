// =========================================
// 1. Créer la base de données et la collection
// =========================================
use FastFoodDelivery;

db.createCollection("batteries");

// =========================================
// 2. Insérer les documents initiaux
// =========================================
db.batteries.insertMany([
  {
    _id: "1",
    numéro_série: "s12",
    capacité: "20%",
    santé_batterie: "bonne",
    nombre_cycle: 300,
    statut: "en service"
  },
  {
    _id: "2",
    numéro_série: "s245",
    capacité: "30%",
    santé_batterie: "moyenne",
    nombre_cycle: 700,
    statut: "en panne"
  }
]);

// =========================================
// 3. Modifier la batterie avec id = 2
// =========================================
db.batteries.updateOne(
  { _id: "2" },
  {
    $set: {
      capacité: "45%",
      statut: "Entretienne"
    }
  }
);

// =========================================
// 4. Afficher nombre_cycles, santé_batterie et capacité
//    pour les batteries avec capacité > 50% (tri décroissant)
// =========================================
db.batteries.find(
  { capacité: { $gt: "50%" } },
  {
    _id: 0,
    nombre_cycle: 1,
    santé_batterie: 1,
    capacité: 1
  }
).sort({ nombre_cycle: -1 });

// =========================================
// 5. Grouper par nombre_cycle pour compter
// =========================================
db.batteries.aggregate([
  {
    $group: {
      _id: "$nombre_cycle",
      total: { $sum: 1 }
    }
  }
]);

// =========================================
// 6. Supprimer les batteries dont le statut
//    n est ni "en service" ni "entretienne"
// =========================================
db.batteries.deleteMany({
  statut: { $nin: ["en service", "entretienne"] }
});
