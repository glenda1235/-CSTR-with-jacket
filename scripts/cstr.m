function cstr
    %======================
    % Parâmetros do reator
    %======================
    F = 5;        % l/min
    V = 10;       % l
    k = 0.25;     % 1/min
    CAf = 2.0;    % mol/l
    Xalvo = 0.90; % alvo de 90%

    % Conversão de unidades (para consistência)
    % Aqui pode manter em l/min porque V e F estão em mesma unidade
    % Logo tau já sai em min corretamente

    % Condição inicial
    CA0 = CAf; % começa com concentração igual à alimentação

    % Tempo de simulação
    tspan = [0 200]; % min

    % Resolver EDO
    [t, CA] = ode45(@(t,CA) dCSTR(t,CA,F,V,CAf,k), tspan, CA0);

    % Conversão ao longo do tempo
    X = (CAf - CA)./CAf;

    %======================
    % Cálculos analíticos
    %======================
    tau = V/F;
    Da = k*tau;
    CA_ss = CAf/(1+Da);
    X_ss = 1 - 1/(1+Da);

    % Projeto para alvo
    Da_alvo  = Xalvo/(1 - Xalvo);
    tau_alvo = Da_alvo/k;
    V_alvo   = F * tau_alvo;
    F_alvo   = V / tau_alvo;
    CA_alvo  = CAf * (1 - Xalvo);

    %======================
    % Plotagem
    %======================
    figure;
    plot(t, CA, 'b', 'LineWidth', 2); hold on;
    yline(CA_ss, '--k', 'CA_{ss}');
    xlabel('Tempo [min]');
    ylabel('Concentração C_A [mol/L]');
    title('CSTR - Concentração de A');
    grid on;

    figure;
    plot(t, X, 'r', 'LineWidth', 2); hold on;
    yline(X_ss, '--k', 'X_{ss}');
    xlabel('Tempo [min]');
    ylabel('Conversão X');
    title('CSTR - Conversão ao longo do tempo');
    grid on;

    %======================
    % Mostrar resultados no console
    %======================
    fprintf('\n=== Resultados CSTR ===\n');
    fprintf('Tempo de residência (tau) = %.2f min\n', tau);
    fprintf('Damkohler (Da) = %.2f\n', Da);
    fprintf('CA regime (CA_ss) = %.2f mol/L\n', CA_ss);
    fprintf('X regime (X_ss) = %.2f\n', X_ss);
    fprintf('\n=== Projeto para X alvo = %.2f ===\n', Xalvo);
    fprintf('Da alvo = %.2f\n', Da_alvo);
    fprintf('Tau alvo = %.2f min\n', tau_alvo);
    fprintf('V alvo (para F fixo) = %.2f L\n', V_alvo);
    fprintf('F alvo (para V fixo) = %.2f L/min\n', F_alvo);
    fprintf('CA alvo = %.2f mol/L\n', CA_alvo);
end

function dCA = dCSTR(t,CA,F,V,CAf,k)
    % Cinética de 1ª ordem e balanço de massa no CSTR
    RA = k*CA;
    dCA = F/V*(CAf - CA) - RA;
end
