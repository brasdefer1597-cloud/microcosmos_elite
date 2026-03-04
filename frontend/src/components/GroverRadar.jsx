import React from 'react';

const GroverRadar = ({ data }) => {
  const { poas = 0, fidelidad = 0, mejor_campaña = 0 } = data?.business || {};

  return (
    <div className="p-6 bg-black/80 text-green-400 border border-green-900/50 rounded-xl shadow-2xl backdrop-blur-sm">
      <h3 className="text-2xl font-bold mb-4 glitch-text">🌌 Radar Grover - Amplitud Amplificada</h3>
      <div className="flex items-end justify-between h-64 border-b border-green-800/50 gap-1">
        {[...Array(32)].map((_, i) => (
          <div
            key={i}
            className={`w-2 transition-all duration-700 ease-out ${
              i === mejor_campaña 
                ? 'bg-gradient-to-t from-green-400 to-cyan-300 scale-125' 
                : 'bg-green-900/30 opacity-40'
            }`}
            style={{ height: i === mejor_campaña ? `${fidelidad}%` : '4%' }}
          />
        ))}
      </div>
      <div className="mt-6 grid grid-cols-2 gap-6 text-center">
        <div>
          <p className="text-sm text-green-600">POAS Máximo</p>
          <p className="text-3xl font-black text-cyan-300">{poas.toFixed(2)}x</p>
        </div>
        <div>
          <p className="text-sm text-green-600">Fidelidad</p>
          <p className="text-3xl font-black text-yellow-300">{fidelidad.toFixed(2)}%</p>
        </div>
      </div>
      <p className="mt-4 text-center text-sm text-green-700">
        Campaña óptima: #{mejor_campaña} | Interferencia constructiva máxima
      </p>
    </div>
  );
};

export default GroverRadar;
