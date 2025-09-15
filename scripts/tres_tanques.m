function tres_tanques
    %======================
    % Parâmetros do modelo
    %======================
    A = 3;              % m^2 (área igual pros 3 tanques)
    k = 0.01;           % m^2.5/s (coeficiente de vazão)
    phi_foul = 0.7;     % fator de incrustação no tanque 2
    t_step = 20*60;     % tempo do degrau (20 min -> s)
    t_foul = 40*60;     % tempo da incrustação (40 min -> s)

    % Condições iniciais (convertidas de cm para m)
    h0 = [1.10; 1.75; 1.10]; % alturas iniciais [m]

    % Tempo de simulação (60 min)
    tspan = [0 60*60]; % segundos

    % Resolver EDO
    [t, h] = ode45(@(t,h) dinamica_tanques(t,h,A,k,phi_foul,t_step,t_foul), tspan, h0);

    %======================
    % Plot dos resultados
    %======================
    figure;
    plot(t/60, h(:,1), 'r', 'LineWidth', 2); hold on;
    plot(t/60, h(:,2), 'b', 'LineWidth', 2);
    plot(t/60, h(:,3), 'g', 'LineWidth', 2);
    xlabel('Tempo [min]');
    ylabel('Altura [m]');
    legend('Tanque 1','Tanque 2','Tanque 3');
    title('Sistema de 3 Tanques em Série');
    grid on;
end

function dhdt = dinamica_tanques(t,h,A,k,phi_foul,t_step,t_foul)
    % Estados
    h1 = h(1); h2 = h(2); h3 = h(3);

    % Evento: degrau na alimentação
    if t < t_step
        Fin = 175/1000/60;  % 175 L/min -> m3/s
    else
        Fin = 300/1000/60;  % 300 L/min -> m3/s
    end

    % Evento: incrustação no tanque 2
    if t < t_foul
        phi2 = 1;
    else
        phi2 = phi_foul;
    end

    % Vazões de saída (Torricelli)
    Fout1 = k*1*sqrt(max(h1,0));     % tanque 1 sem incrustação
    Fout2 = k*phi2*sqrt(max(h2,0));  % tanque 2 com incrustação
    Fout3 = k*1*sqrt(max(h3,0));     % tanque 3 sem incrustação

    % Balanços (em termos de alturas, já que V = A*h)
    dh1 = (Fin - Fout1)/A;
    dh2 = (Fout1 - Fout2)/A;
    dh3 = (Fout2 - Fout3)/A;

    dhdt = [dh1; dh2; dh3];
end
