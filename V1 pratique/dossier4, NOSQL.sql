// ===== 1 Créer la base de données et la collection =====
use FastFoodDelivery
db.createCollection("batteries")

// ===== 2 Insérer les documents =====
db.batteries.insertMany([
  {
    _id: "batt123",
    nombre: 50,
    cycles: 500,
    statut: "en panne",
    capacite: "190%"
  },
  {
    _id: "batt124",
    nombre: 20,
    cycles: 300,
    statut: "en service",
    capacite: "350%"
  }
])

// ===== 3 Modifier la capacité à 30% pour les batteries en panne =====
db.batteries.updateMany(
  { statut: "en panne" },
  { $set: { capacite: "30%" } }
)

// ===== 4 Afficher les batteries dont la capacité est entre 60% et 100% =====
db.batteries.find({
  capacite: { $gte: "60%", $lte: "100%" }
})

// ===== 5 Moyenne des cycles pour les batteries en panne ou capacité < 200% =====
db.batteries.aggregate([
  {
    $match: {
      $or: [
        { statut: "en panne" },
        { capacite: { $lt: "200%" } }
      ]
    }
  },
  {
    $group: {
      _id: null,
      moyenne_cycles: { $avg: "$cycles" }
    }
  }
])
