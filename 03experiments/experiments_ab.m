clc
clear all

data=xlsread('aData.xlsx');
sigma0_experiment_a = data(:, 1)*1e6;
dxdt_experiment_a = data(:, 2)/86400*1e-6;

data=xlsread('bData.xlsx');
sigma0_experiment_b = data(:, 1)*1e6;
dxdt_experiment_b = data(:, 2)/86400*1e-6;

sigma0_experiment = [sigma0_experiment_a; sigma0_experiment_b];
dxdt_experiment = [dxdt_experiment_a; dxdt_experiment_b];

R = 8.3145;
T = 633;
Delta_V0 = -22e-6;%the value of Vs is used.
Vs = - Delta_V0;
h = 2.2e-9;
D = 1e-9;
r0 = 1e-4;
c_eq0 = 730;%mol per m3

k = 3.6986e-6/2;

dxdt_min = 1e-20;
dxdt_max = 1.1574e-10;

Rd_min = dxdt_min/Vs;
Rd_max = dxdt_max/Vs;
% Rd_min = 1e-15;
% Rd_max = 5.2609e-6;
num = 1000;

Rd_data = linspace(Rd_min, Rd_max, num);
dxdt_data = Rd_data * Vs;
sigma0_data = linspace(0, 1, num);
diffusion_sigma0_data = linspace(0, 1, num);
reaction_sigma0_data = linspace(0, 1, num);

exponential_sigma0_data = 1/0.013 * log(dxdt_data*86400/1e-6/0.28 + 1) * 1e6;

for i = 1:num
    Rd = Rd_data(i);
    a1 = 2*h*D/(k * (r0^2)) + 4*h*D*c_eq0/(Rd * (r0^2));
    a2 = log(Rd/(2* k * c_eq0) + 1);
    a3 = log(Rd * (r0^2)/(4 * h * D * c_eq0) + Rd/(2 * k * c_eq0) + 1);
    sigma0 = R*T/Delta_V0 *(-a1 * a2 + (1+a1)*a3 - 1);
    sigma0_data(i) = sigma0;

    diffusion_sigma0 = R*T/Delta_V0 * (Rd * (r0^2))/(8*h*D*c_eq0);
    diffusion_sigma0_data(i) = diffusion_sigma0;

    reaction_sigma0 = R*T/Delta_V0 * log(Rd/(2* k*c_eq0) + 1);
    reaction_sigma0_data(i) = reaction_sigma0;
end

% compute error vs measurement (error by dx/dt)
size = length(dxdt_experiment);
dxdt_present = dxdt_experiment; %initializationg
dxdt_old = dxdt_experiment; %initializationg

for i = 1:size
    sigma0 = sigma0_experiment(i);
    [value, index] = min(abs(-sigma0_data - sigma0));
    dxdt_present(i) = dxdt_data(index);
    
    [value, index] = min(abs(exponential_sigma0_data - sigma0));
    dxdt_old(i) = dxdt_data(index);
      
end

error_present = (mean((dxdt_experiment*86400/1e-6 - dxdt_present*86400/1e-6).^2)) 
error_old = (mean((dxdt_experiment*86400/1e-6 - dxdt_old*86400/1e-6).^2))


% % compute error vs measurement (error by sigma)
% size = length(dxdt_experiment);
% sigma0_present = dxdt_experiment; %initializationg
% sigma0_exponential_model = 1/0.013 * log(dxdt_experiment*86400/1e-6/0.28 + 1) * 1e6;
% for i = 1:size
%     Rd = dxdt_experiment(i)/Vs;
%     a1 = 2*h*D/(k * (r0^2)) + 4*h*D*c_eq0/(Rd * (r0^2));
%     a2 = log(Rd/(2* k * c_eq0) + 1);
%     a3 = log(Rd * (r0^2)/(4 * h * D * c_eq0) + Rd/(2 * k * c_eq0) + 1);
%     sigma0 = R*T/Delta_V0 *(-a1 * a2 + (1+a1)*a3 - 1);
%     sigma0_present(i) = -sigma0;    
% end
% 
% error_present = (mean((sigma0_experiment - sigma0_present).^2)/size).^0.5
% error_exponential_model = (mean((sigma0_experiment - sigma0_exponential_model).^2)/size).^0.5



% color1=[158	202	225]/255;
% color2=[107	174	214]/255;
% color3=[66	146	198]/255;
% color4=[33	113	181]/255;
% color5=[8	69	148]/255;

% color1=[253	187	132]/255;
% color2=[252	141	89]/255;
% color3=[239	101	72]/255;
% color4=[215	48	31]/255;
% color5=[153	0	0]/255;


% color1=[158	202	225]/255;
% color2=[107	174	214]/255;
% color3=[49	130	189]/255;
% color4=[8	81	156]/255;

% color1=[252	141	89]/255;
% color2=[153	213	148]/255;
% color3=[50	136	189]/255;
% 
% color = [0	90	50]/255;
% color_i = [150 150 150]/255;

color0 = [0, 0.5, 0];
% p1 = plot(Rd_data, sigma0_data, 'k-', 'markers',8 ,'linewidth',1.5);
%hold on
%p2 = plot(Rd_data(5:10:num), diffusion_sigma0_data(5:10:num), 'bs', 'markers',8 ,'linewidth',1.5);
%p3 = plot(Rd_data(5:10:num), reaction_sigma0_data(5:10:num), 'ro', 'markers',8 ,'linewidth',1.5);

p1 = plot(-sigma0_data/1e6, dxdt_data*86400/1e-6, 'k-', 'markers',8 ,'linewidth',1.5);
hold on
p2 = plot(exponential_sigma0_data/1e6, dxdt_data*86400/1e-6, 'k--', 'markers',8 ,'linewidth',1.5);
p3 = plot(sigma0_experiment_a/1e6, dxdt_experiment_a*86400/1e-6, 'or', 'markers',8 ,'linewidth',1.5);
p4 = plot(sigma0_experiment_b/1e6, dxdt_experiment_b*86400/1e-6, 'bs', 'markers',8 ,'linewidth',1.5);
% p11 = plot(x,tracking(:,1), 'k-' ,'linewidth',2);
% p2 = plot(x2,capturing2(:,2),'^', 'markers',8 ,'linewidth',1.5, 'color', [0.4940 0.1840 0.5560]);
% p22 = plot(x,tracking(:,2), 'k--' ,'linewidth',2);
% p3 = plot(x2,capturing2(:,3),'b+', 'markers',10 ,'linewidth',1.5, 'color', color);
% p33 = plot(x,tracking(:,3), 'k-.' ,'linewidth',2);
% p4 = plot(x2,capturing2(:,4),'bx', 'markers',10 ,'linewidth',1.5);
% p44 = plot(x,tracking(:,4), 'k:' ,'linewidth',2);
% 
% p5 = plot([0, 1], [h0, h0], '--', 'linewidth',1, 'color', color_i);

% p2=plot (x2,capturing2(:,3),'ok',x2,capturing240_2(:,3),'+k',x,tracking(:,3),'k', 'markers',8,'linewidth',2, 'color', color2);
% p3=plot (x2,capturing2(:,4),'ok',x2,capturing240_2(:,4),'+k',x,tracking(:,4),'k', 'markers',8,'linewidth',2, 'color', color3);
% p4=plot (x2,capturing2(:,5),'ok',x2,capturing240_2(:,5),'+k',x,tracking(:,5),'k', 'markers',8,'linewidth',2, 'color', color4);
% p5=plot (x2,capturing2(:,6),'ok',x2,capturing240_2(:,6),'+k',x,tracking(:,6),'k', 'markers',8,'linewidth',2, 'color', color5);

%%%%%% Axis %%%%%%
% xlabel('$R_d$ (mol/m$^2$/s)','FontSize',16,'Interpreter','latex');
% ylabel('$\sigma_0$ (Pa)','FontSize',16,'Interpreter','latex');
% ylim([-2.5e8, 0]);

xlabel('$\sigma_0$ (MPa)','FontSize',16,'Interpreter','latex');
ylabel('$dx/dt$ ($\mathrm{\mu}$m/day)','FontSize',16,'Interpreter','latex');
xlim([0 300])

set(gca,'FontName','Times New Roman','FontSize',...
    16,'LineWidth',2,'Xscale','linear', 'Yscale','linear');

%%%%%%% Legend %%%%%%
legend([p1 p2 p3 p4], 'Proposed model','Exponential model','Measurement 1','Measurement 2','FontSize',16,'Interpreter','latex')
set(legend, 'box', 'off', 'Location', 'northwest')

% a=axes('position',get(gca,'position'),'visible','off');
% legend(a,[p11 p22 p33 p44], '$Pe = 0.011$', '$Pe = 0.022$', '$Pe = 0.11$', '$Pe = 11$', 'FontSize',16,'Interpreter','latex')
% set(legend, 'box', 'off', 'Position', [0.75 0.65 0 0])
% a=axes('position',get(gca,'position'),'visible','off');
% legend(a, p5, 'Initial aperture','FontSize',16,'Interpreter','latex')
% set(legend, 'box', 'off', 'Position', [0.72 0.51 0 0])

text(0.6e-8,-0.3e8, '$k = 1 \times 10^{-9}$ m/s','FontSize',16,'Interpreter','latex')

% legend([p1 p2 p3 p4], '','','','','','FontSize',18,'Interpreter','latex')
% set(legend, 'box', 'off', 'Position', [0.6 0.74 0 0])
% a=axes('position',get(gca,'position'),'visible','off');
% legend(a,[p1(2) p2(2) p3(2) p4(2) p5(2)], '$t=1,000$ s', '$t=3,000$ s', '$t=5,000$ s', '$t=10,000$ s' , '$t=50,000$ s','FontSize',18,'Interpreter','latex')
% set(legend, 'box', 'off', 'Position', [0.73 0.74 0 0])

% legend('$c_1$','$c_1$, reference','$c_2$','$c_2$, reference','$c_3$','$c_3$, reference','FontSize',16,'Interpreter','latex')
% set(legend,'box', 'off', 'location', 'northeast')


%%%%%%%%% Figure %%%%%%%%%%
set(gcf, 'Units', 'centimeters',...
    'Position',[3 4 16 12],... % [left bottom width height]
    'PaperPositionMode', 'auto');
h=gcf;
pos = get(gcf, 'Position');
set(h,'PaperUnits','centimeters', 'PaperSize', pos(3:4));
print(h,'-dpdf', sprintf('./%s.pdf',mfilename));