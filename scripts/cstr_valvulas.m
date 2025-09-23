function cstr_valvulas
    %======================
    % Parâmetros
    %======================
    F  = 5;        % l/min
    V  = 10;       % l
    k  = 0.25;     % 1/min
    CAf= 2.0;      % mol/L
    Tf = 300;      % K (alimentação)
    Tc = 290;      % K (fluido de resfriamento)
    dH = -50000;   % J/mol (reação exotérmica)
    rho= 1000;     % g/L -> ~kg/m3
    Cp = 4.18;     % J/g.K
    UA = 2000;     % J/min.K (coef. troca térmica)

    % Válvulas (coeficientes de abertura)
    phi_in = 0.8;  % válvula de concentração
    phi_T  = 0.6;  % válvula de temperatura

    % Vazão ajustada pela válvula
    Fin = phi_in * F;

    % Condições iniciais
    CA0 = CAf;   % mol/L
    T0  = Tf;    % K
    y0  = [CA0; T0];

    % Tempo de simulação
    tspan = [0 200]; % min

    % Resolver EDO
    [t, y] = ode45(@(t,y) dCSTR_valv(t,y,Fin,V,CAf,Tf,k,dH,rho,Cp,UA,phi_T,Tc), tspan, y0);

    CA = y(:,1);
    T  = y(:,2);
    X  = (CAf - CA)./CAf;

    %======================
    % Plots
    %======================
    figure;
    subplot(2,1,1);
    plot(t,CA,'b','LineWidth',2); hold on;
    xlabel('Tempo [min]'); ylabel('C_A [mol/L]');
    title('CSTR com válvulas - Concentração');
    grid on;

    subplot(2,1,2);
    plot(t,T,'r','LineWidth',2);
    xlabel('Tempo [min]'); ylabel('T [K]');
    title('CSTR com válvulas - Temperatura');
    grid on;
end

function dydt = dCSTR_valv(t,y,F,V,CAf,Tf,k,dH,rho,Cp,UA,phi_T,Tc)
    % Estados
    CA = y(1);
    T  = y(2);

    % Reação
    rA = k*CA;

    % Balanço de massa
    dCA = F/V*(CAf - CA) - rA;

    % Balanço de energia com válvula de resfriamento
    UA_eff = phi_T * UA;
    dT = (F/V)*(Tf - T) ...
         + (-dH*rA)/(rho*Cp) ...
         + (UA_eff/(rho*Cp*V))*(Tc - T);

    dydt = [dCA; dT];
end
