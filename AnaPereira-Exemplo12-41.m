function mmcc_simulation(lambda, c, mu, T)
  % Parâmetros
  total_time = T;
  total_servers = c;
  arrival_rate = lambda;
  service_rate = mu;

  % Variáveis de estado
  servers_busy = 0;
  blocked_customers = 0;
  total_arrivals = 0;

  % Lista de eventos
  events = [];

  % Agendar o primeiro evento de chegada
  next_arrival = -log(rand()) / arrival_rate;
  events = [events; next_arrival, 'arrival'];

  % Executar até tempo total T
  current_time = 0;

  while current_time < total_time
    % Pegar o próximo evento
    [next_time, event_type] = min(events(:, 1));
    current_time = events(next_time, 1);
    event = events(next_time, 2);

    % Remover o evento da lista
    events(next_time, :) = [];

    if event == 'arrival'
      total_arrivals += 1;

      if servers_busy < total_servers
        servers_busy += 1;

        service_time = -log(rand()) / service_rate;
        events = [events; current_time + service_time, 'departure'];
      else
        blocked_customers += 1;
      end

      next_arrival = current_time + -log(rand()) / arrival_rate;
      if next_arrival <= total_time
        events = [events; next_arrival, 'arrival'];
      end

    elseif event == 'departure'
      servers_busy -= 1;
    end
  end

  % Resultados
  fprintf('Total de chegadas: %d\n', total_arrivals);
  fprintf('Clientes bloqueados: %d\n', blocked_customers);
  fprintf('Probabilidade de bloqueio: %.4f\n', blocked_customers / total_arrivals);
end

% Parâmetros
lambda = 8;  % chegadas por minuto
c = 10;      % número de servidores
mu = 1;      % taxa de serviço (minutos por serviço)
T = 5;       % tempo total de simulação em minutos

% Executar
mmcc_simulation(lambda, c, mu, T);