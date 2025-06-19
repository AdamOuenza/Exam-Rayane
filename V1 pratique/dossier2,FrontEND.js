# Réponses aux questions

## 1. Composante DetailsVelo.js

jsx
import React from 'react';
import { useSelector } from 'react-redux';

const DetailsVelo = () => {
  const velo = useSelector(state => state.velo);
  
  return (
    <div>
      <h1>Velo Details</h1>
      <h2>Matricule: {velo.Matricule}</h2>
      <h3>Capacité Batterie Actuelle: {velo.BatterieUtilisee.Capacite}%</h3>
      <h3>Santé Batterie Actuelle: {velo.BatterieUtilisee.sante_batterie}%</h3>
      <h3>Date Dernière Maintenance: {velo.Date_derniere_maintenance.replace(/\//g, '-')}</h3>
      <h3>Date Prochaine Maintenance: {velo.Date_prochaine_maintenance.replace(/\//g, '-')}</h3>
    </div>
  );
};

export default DetailsVelo;


## 2. Composante AjouterChangement.js

jsx
import React, { useState } from 'react';
import { useSelector } from 'react-redux';

const AjouterChangement = () => {
  const [formData, setFormData] = useState({
    id_nouvelle_batterie: '',
    date_changement: '',
    id_technicien: '',
    raison: ''
  });
  
  const velo = useSelector(state => state.velo);
  const batteries = useSelector(state => state.Batteries);
  const techniciens = useSelector(state => state.Techniciens);
  
  const handleSubmit = async (e) => {
    e.preventDefault();
    const data = {
      id_velo: velo.id,
      id_ancienne_batterie: velo.BatterieUtilisee.Id,
      id_nouvelle_batterie: formData.id_nouvelle_batterie,
      date_changement: formData.date_changement,
      id_technicien: formData.id_technicien,
      raison: formData.raison
    };
    
    try {
      const response = await fetch('http://localhost:8000/api/AjouterChangement', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data)
      });
      // Gérer la réponse
    } catch (error) {
      console.error('Error:', error);
    }
  };
  
  return (
    <div>
      <h1>Changement de Batterie</h1>
      <h2>Velo: {velo.Matricule}</h2>
      <h3>Ancienne Batterie:</h3>
      <h4>{velo.BatterieUtilisee.Numero_serie}</h4>
      
      <form onSubmit={handleSubmit}>
        <div>
          <label>Nouvelle Batterie:</label>
          <select 
            value={formData.id_nouvelle_batterie}
            onChange={(e) => setFormData({...formData, id_nouvelle_batterie: e.target.value})}
            required
          >
            <option value="">- Choisir une batterie -</option>
            {batteries.map(bat => (
              <option key={bat.id} value={bat.id}>{bat.Numero_serie}</option>
            ))}
          </select>
        </div>
        
        <div>
          <label>Date de Changement:</label>
          <input 
            type="date" 
            value={formData.date_changement}
            onChange={(e) => setFormData({...formData, date_changement: e.target.value})}
            required
          />
        </div>
        
        <div>
          <label>Technicien:</label>
          <select 
            value={formData.id_technicien}
            onChange={(e) => setFormData({...formData, id_technicien: e.target.value})}
            required
          >
            <option value="">- Choisir un technicien -</option>
            {techniciens.map(tech => (
              <option key={tech.id} value={tech.id}>{tech.Nom}</option>
            ))}
          </select>
        </div>
        
        <div>
          <label>Raison:</label>
          <input 
            type="text" 
            value={formData.raison}
            onChange={(e) => setFormData({...formData, raison: e.target.value})}
            required
          />
        </div>
        
        <button type="submit">Soumettre</button>
      </form>
    </div>
  );
};

export default AjouterChangement;


## 3. Composante ListeBatteries.js

jsx
import React, { useState } from 'react';
import { useSelector } from 'react-redux';

const ListeBatteries = () => {
  const [selectedStatut, setSelectedStatut] = useState('En Stock');
  const batteries = useSelector(state => state.Batteries);
  
  const filteredBatteries = batteries.filter(bat => bat.statut === selectedStatut);
  const totalCycles = filteredBatteries.reduce((sum, bat) => sum + bat.nombre_cycles, 0);
  const moyenneCycles = filteredBatteries.length > 0 ? Math.round(totalCycles / filteredBatteries.length) : 0;
  
  return (
    <div>
      <h2>Liste Batteries</h2>
      <div>
        <label>Choisir le Statut de la Batterie:</label>
        <select 
          value={selectedStatut}
          onChange={(e) => setSelectedStatut(e.target.value)}
        >
          {useSelector(state => state.StatutBatterie).map(statut => (
            <option key={statut} value={statut}>{statut}</option>
          ))}
        </select>
        <button>Filtrer</button>
      </div>
      
      <table>
        <thead>
          <tr>
            <th>Id</th>
            <th>Numero Serie</th>
            <th>Statut</th>
            <th>Nombre Cycles</th>
          </tr>
        </thead>
        <tbody>
          {filteredBatteries.map(bat => (
            <tr key={bat.id}>
              <td>{bat.id}</td>
              <td>{bat.Numero_serie}</td>
              <td>{bat.statut}</td>
              <td>{bat.nombre_cycles}</td>
            </tr>
          ))}
        </tbody>
      </table>
      
      <div>
        <p>{filteredBatteries.length} batteries Trouvées</p>
        <p>La moyenne des nombres de cycles est {moyenneCycles}</p>
      </div>
    </div>
  );
};

export default ListeBatteries;


## 4. Composante Menu.js

jsx
import React from 'react';
import { Link } from 'react-router-dom';

const Menu = () => {
  return (
    <nav>
      <ul>
        <li>
          <Link to="/AjouterChgmt">Nouveau Changement</Link>
        </li>
        <li>
          <Link to="/ListeBatteries">Liste Batteries</Link>
        </li>
        <li>
          <Link to="/DetailsVélo">Détails Vélo</Link>
        </li>
      </ul>
    </nav>
  );
};

export default Menu;


## 5. Composante App.js

jsx
import React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { Provider } from 'react-redux';
import store from './store';
import Menu from './Menu';
import DetailsVelo from './DetailsVelo';
import AjouterChangement from './AjouterChangement';
import ListeBatteries from './ListeBatteries';

const App = () => {
  return (
    <Provider store={store}>
      <BrowserRouter>
        <Menu />
        <Routes>
          <Route path="/AjouterChgmt" element={<AjouterChangement />} />
          <Route path="/ListeBatteries" element={<ListeBatteries />} />
          <Route path="/DetailsVélo" element={<DetailsVelo />} />
        </Routes>
      </BrowserRouter>
    </Provider>
  );
};

export default App;
