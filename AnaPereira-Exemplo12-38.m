function buffer_simulation(p, c, x0, steps)
  % Inicializa
  buffer = x0;
  
  % Vetores para resultados
  buffer_size = zeros(1, steps);

  % Loop
  for t = 1:steps
    if rand() < p
      arriving_packets = 1;
    else
      arriving_packets = 0;
    end

    buffer = buffer + arriving_packets;

    if buffer > c
      buffer = c; 
    end

    % Pacotes processados (removidos) pelo roteador (um pacote por unidade de tempo)
    buffer = max(buffer - 1, 0);

    % Armazena o tamanho do buffer após cada passo de tempo
    buffer_size(t) = buffer;
  end

  % Plot dos resultados
  figure;
  plot(1:steps, buffer_size);
  title(sprintf('Simulação do Buffer do Roteador para %d passos de tempo', steps));
  xlabel('Passo de Tempo');
  ylabel('Pacotes no Buffer');
  grid on;
end

% Parâmetros
p = 0.48;
c = 30;
x0 = 20;

% 40 passos de tempo
buffer_simulation(p, c, x0, 40);

% 400 passos de tempo
buffer_simulation(p, c, x0, 400);