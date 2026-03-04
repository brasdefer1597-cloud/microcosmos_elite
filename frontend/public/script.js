// Lógica para el Dashboard de Soberana (Nirvana v2.0)
async function updateDashboard() {
    try {
        const response = await fetch('data/history.json');
        const data = await response.json();
        
        // Extraer los últimos valores para la consola del navegador
        const ultimo = data[data.length - 1];
        console.log(`📈 Nirvana Sincronizado | POAS: ${ultimo.poas} | Fidelidad: ${ultimo.fidelidad}%`);
        
        // Aquí es donde Chart.js o el DOM se actualizarían en el navegador
    } catch (error) {
        console.error("⚠️ Error en el pulso del Dashboard:", error);
    }
}

// Iniciar el ciclo de escucha
setInterval(updateDashboard, 12000);
updateDashboard(); // Carga inicial
