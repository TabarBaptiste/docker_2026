import React, { useState, useEffect } from 'react';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';

function App() {
    const [products, setProducts] = useState([]);
    const [formData, setFormData] = useState({
        name: '',
        description: '',
        price: '',
        quantity: ''
    });
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);

    // Récupérer tous les produits au chargement
    useEffect(() => {
        fetchProducts();
    }, []);

    const fetchProducts = async () => {
        setLoading(true);
        setError(null);
        try {
            const response = await fetch(`${API_URL}/products`);
            if (!response.ok) throw new Error('Erreur lors de la récupération des produits');
            const data = await response.json();
            setProducts(data);
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({
            ...prev,
            [name]: value
        }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError(null);

        try {
            const response = await fetch(`${API_URL}/products`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    name: formData.name,
                    description: formData.description,
                    price: parseFloat(formData.price),
                    quantity: parseInt(formData.quantity)
                })
            });

            if (!response.ok) throw new Error('Erreur lors de l\'ajout du produit');

            // Réinitialiser le formulaire
            setFormData({
                name: '',
                description: '',
                price: '',
                quantity: ''
            });

            // Recharger la liste
            fetchProducts();
        } catch (err) {
            setError(err.message);
        }
    };

    const handleDelete = async (id) => {
        if (!window.confirm('Êtes-vous sûr de vouloir supprimer ce produit ?')) return;

        setError(null);
        try {
            const response = await fetch(`${API_URL}/products/${id}`, {
                method: 'DELETE'
            });

            if (!response.ok) throw new Error('Erreur lors de la suppression du produit');

            // Recharger la liste
            fetchProducts();
        } catch (err) {
            setError(err.message);
        }
    };

    return (
        <div className="container">
            <header>
                <h1>📦 Gestion de Produits</h1>
                <p>Application CRUD avec React, Node.js et MongoDB</p>
            </header>

            {error && (
                <div className="error-message">
                    ❌ {error}
                </div>
            )}

            <div className="content">
                {/* Formulaire d'ajout */}
                <section className="form-section">
                    <h2>➕ Ajouter un produit</h2>
                    <form onSubmit={handleSubmit}>
                        <div className="form-group">
                            <label htmlFor="name">Nom du produit *</label>
                            <input
                                type="text"
                                id="name"
                                name="name"
                                value={formData.name}
                                onChange={handleInputChange}
                                required
                                placeholder="Ex: Ordinateur portable"
                            />
                        </div>

                        <div className="form-group">
                            <label htmlFor="description">Description</label>
                            <textarea
                                id="description"
                                name="description"
                                value={formData.description}
                                onChange={handleInputChange}
                                placeholder="Description du produit"
                                rows="3"
                            />
                        </div>

                        <div className="form-row">
                            <div className="form-group">
                                <label htmlFor="price">Prix (€) *</label>
                                <input
                                    type="number"
                                    id="price"
                                    name="price"
                                    value={formData.price}
                                    onChange={handleInputChange}
                                    required
                                    min="0"
                                    step="0.01"
                                    placeholder="0.00"
                                />
                            </div>

                            <div className="form-group">
                                <label htmlFor="quantity">Quantité *</label>
                                <input
                                    type="number"
                                    id="quantity"
                                    name="quantity"
                                    value={formData.quantity}
                                    onChange={handleInputChange}
                                    required
                                    min="0"
                                    placeholder="0"
                                />
                            </div>
                        </div>

                        <button type="submit" className="btn-primary">
                            Ajouter le produit
                        </button>
                    </form>
                </section>

                {/* Liste des produits */}
                <section className="list-section">
                    <h2>📋 Liste des produits</h2>

                    {loading ? (
                        <div className="loading">Chargement...</div>
                    ) : products.length === 0 ? (
                        <div className="empty-state">
                            <p>Aucun produit trouvé. Ajoutez-en un !</p>
                        </div>
                    ) : (
                        <div className="products-grid">
                            {products.map(product => (
                                <div key={product._id} className="product-card">
                                    <div className="product-header">
                                        <h3>{product.name}</h3>
                                        <button
                                            onClick={() => handleDelete(product._id)}
                                            className="btn-delete"
                                            title="Supprimer"
                                        >
                                            🗑️
                                        </button>
                                    </div>
                                    <p className="product-description">{product.description || 'Aucune description'}</p>
                                    <div className="product-details">
                                        <div className="product-price">
                                            <span className="label">Prix:</span>
                                            <span className="value">{product.price.toFixed(2)} €</span>
                                        </div>
                                        <div className="product-quantity">
                                            <span className="label">Stock:</span>
                                            <span className="value">{product.quantity}</span>
                                        </div>
                                    </div>
                                    <div className="product-date">
                                        Ajouté le {new Date(product.createdAt).toLocaleDateString('fr-FR')}
                                    </div>
                                </div>
                            ))}
                        </div>
                    )}
                </section>
            </div>
        </div>
    );
}

export default App;
