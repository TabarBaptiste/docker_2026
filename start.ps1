# Script de démarrage rapide pour l'application CRUD
# Usage: .\start.ps1 [up|down|restart|logs|status]

param(
    [Parameter(Position=0)]
    [ValidateSet('up','down','restart','logs','status','build','clean','help')]
    [string]$Action = 'up'
)

$ProjectName = "Mini-App CRUD - Gestion de Produits"

function Show-Banner {
    Write-Host ""
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host "  $ProjectName" -ForegroundColor Cyan
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Help {
    Write-Host "Commandes disponibles:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  .\start.ps1 up       " -NoNewline -ForegroundColor Green
    Write-Host "- Démarrer tous les services"
    Write-Host "  .\start.ps1 down     " -NoNewline -ForegroundColor Green
    Write-Host "- Arrêter tous les services"
    Write-Host "  .\start.ps1 restart  " -NoNewline -ForegroundColor Green
    Write-Host "- Redémarrer tous les services"
    Write-Host "  .\start.ps1 logs     " -NoNewline -ForegroundColor Green
    Write-Host "- Afficher les logs en temps réel"
    Write-Host "  .\start.ps1 status   " -NoNewline -ForegroundColor Green
    Write-Host "- Voir l'état des conteneurs"
    Write-Host "  .\start.ps1 build    " -NoNewline -ForegroundColor Green
    Write-Host "- Reconstruire les images"
    Write-Host "  .\start.ps1 clean    " -NoNewline -ForegroundColor Green
    Write-Host "- Nettoyer tout (SUPPRIME LES DONNEES)"
    Write-Host "  .\start.ps1 help     " -NoNewline -ForegroundColor Green
    Write-Host "- Afficher cette aide"
    Write-Host ""
}

function Show-Services {
    Write-Host ""
    Write-Host "Services disponibles:" -ForegroundColor Yellow
    Write-Host "  - Frontend:     " -NoNewline -ForegroundColor Cyan
    Write-Host "http://localhost:3000" -ForegroundColor White
    Write-Host "  - Backend API:  " -NoNewline -ForegroundColor Cyan
    Write-Host "http://localhost:5000/api" -ForegroundColor White
    Write-Host "  - Mongo Express:" -NoNewline -ForegroundColor Cyan
    Write-Host "http://localhost:8081 (admin/admin123)" -ForegroundColor White
    Write-Host "  - MongoDB:      " -NoNewline -ForegroundColor Cyan
    Write-Host "mongodb://localhost:27017" -ForegroundColor White
    Write-Host ""
}

Show-Banner

switch ($Action) {
    'up' {
        Write-Host "🚀 Démarrage de tous les services..." -ForegroundColor Green
        Write-Host ""
        docker-compose up -d --build
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ Services démarrés avec succès!" -ForegroundColor Green
            Show-Services
            Write-Host "💡 Utilisez " -NoNewline
            Write-Host ".\start.ps1 logs" -NoNewline -ForegroundColor Cyan
            Write-Host " pour voir les logs"
        } else {
            Write-Host ""
            Write-Host "❌ Erreur lors du démarrage" -ForegroundColor Red
        }
    }
    
    'down' {
        Write-Host "⏹️  Arrêt de tous les services..." -ForegroundColor Yellow
        Write-Host ""
        docker-compose down
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ Services arrêtés" -ForegroundColor Green
        }
    }
    
    'restart' {
        Write-Host "🔄 Redémarrage de tous les services..." -ForegroundColor Yellow
        Write-Host ""
        docker-compose restart
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ Services redémarrés" -ForegroundColor Green
            Show-Services
        }
    }
    
    'logs' {
        Write-Host "📋 Affichage des logs (Ctrl+C pour quitter)..." -ForegroundColor Cyan
        Write-Host ""
        docker-compose logs -f
    }
    
    'status' {
        Write-Host "📊 État des conteneurs:" -ForegroundColor Cyan
        Write-Host ""
        docker-compose ps
        Write-Host ""
        Show-Services
    }
    
    'build' {
        Write-Host "🔨 Reconstruction des images..." -ForegroundColor Yellow
        Write-Host ""
        docker-compose build --no-cache
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ Images reconstruites" -ForegroundColor Green
            Write-Host "💡 Utilisez " -NoNewline
            Write-Host ".\start.ps1 up" -NoNewline -ForegroundColor Cyan
            Write-Host " pour démarrer"
        }
    }
    
    'clean' {
        Write-Host "⚠️  ATTENTION: Cette opération va supprimer TOUTES les données!" -ForegroundColor Red
        Write-Host ""
        $confirmation = Read-Host "Êtes-vous sûr? (oui/non)"
        
        if ($confirmation -eq 'oui') {
            Write-Host ""
            Write-Host "🧹 Nettoyage complet..." -ForegroundColor Yellow
            docker-compose down -v
            docker system prune -f
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host ""
                Write-Host "✅ Nettoyage terminé" -ForegroundColor Green
            }
        } else {
            Write-Host ""
            Write-Host "❌ Opération annulée" -ForegroundColor Yellow
        }
    }
    
    'help' {
        Show-Help
    }
    
    default {
        Write-Host "❌ Action inconnue: $Action" -ForegroundColor Red
        Write-Host ""
        Show-Help
    }
}

Write-Host ""
