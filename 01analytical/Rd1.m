clc
clear all

%data=xlsread('k_m9.xlsx');
%Rd_simulation = data(:, 1);
%sigma0_simulation = -data(:, 2);

R = 8.3145;
T = 298;
Delta_V0 = -50e-6;
h = 1e-9;
D = 1e-9;
r0 = 1e-6;
c_eq0 = 1e-1;%mol per m3

%%%%% modified
Rd = 1e-9;

k_min = 1e-6;
k_max = 1e-2;
num = 300;

k_data = logspace(log10(k_min), log10(k_max), num);

alpha_R_min = 0.5e-5;
alpha_R_max = 1e1;
alpha_R_data = logspace(log10(alpha_R_min), log10(alpha_R_max), num);

alpha_product = 1e-6;
alpha_D_data = alpha_product ./ alpha_R_data;
%%%%%%%%%%%%%%
sigma0_data = linspace(0, 1, num);
diffusion_sigma0_data = linspace(0, 1, num);
reaction_sigma0_data = linspace(0, 1, num);

for i = 1:num
    %%%%%%
    alpha_R = alpha_R_data(i);
    alpha_D = alpha_D_data(i);
    %%%%%%%
    a1 = alpha_R/alpha_D + 1/alpha_D;
    a2 = log(alpha_R + 1);
    a3 = log(alpha_R + alpha_D + 1);
    sigma0 = R*T/Delta_V0 *(-a1 * a2 + (1+a1)*a3 - 1);
    sigma0_data(i) = sigma0;

    diffusion_sigma0 = R*T/Delta_V0 * alpha_D/2;
    diffusion_sigma0_data(i) = diffusion_sigma0;

    reaction_sigma0 = R*T/Delta_V0 * log(alpha_R + 1);
    reaction_sigma0_data(i) = reaction_sigma0;
end


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
x = alpha_R_data./alpha_D_data;
color0 = [0, 0.5, 0];
p1 = plot(x, -sigma0_data, 'k-', 'markers',8 ,'linewidth',1.5);
hold on
p2 = plot(x(5:10:num), -diffusion_sigma0_data(5:10:num), 'bs', 'markers',8 ,'linewidth',1.5);
p3 = plot(x(5:10:num), -reaction_sigma0_data(5:10:num), 'ro', 'markers',8 ,'linewidth',1.5);
%p4 = plot(Rd_simulation, sigma0_simulation, 'd', 'markers',8 ,'linewidth',1.5,'MarkerEdge',color0, 'MarkerFaceColor',color0);

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
xlabel('$\alpha_R / \alpha_D$','FontSize',16,'Interpreter','latex');
ylabel('$\sigma_0$ (Pa)','FontSize',16,'Interpreter','latex');
xlim([0.9999e-5, 1e10]);
ylim([1e4, 1e8]);

set(gca,'FontName','Times New Roman','FontSize',...
    16,'LineWidth',2,'Xscale','log', 'Yscale','log');

%%%%%%% Legend %%%%%%
legend([p1 p2 p3], 'Proposed model','Diffusion controlled','Reaction controlled','FontSize',16,'Interpreter','latex')
set(legend, 'box', 'off', 'Location', 'southeast')
% a=axes('position',get(gca,'position'),'visible','off');
% legend(a,[p11 p22 p33 p44], '$Pe = 0.011$', '$Pe = 0.022$', '$Pe = 0.11$', '$Pe = 11$', 'FontSize',16,'Interpreter','latex')
% set(legend, 'box', 'off', 'Position', [0.75 0.65 0 0])
% a=axes('position',get(gca,'position'),'visible','off');
% legend(a, p5, 'Initial aperture','FontSize',16,'Interpreter','latex')
% set(legend, 'box', 'off', 'Position', [0.72 0.51 0 0])

text(1e-4,3e7, '$\alpha_R \cdot \alpha_D = 1 \times 10^{-6}$','FontSize',16,'Interpreter','latex')

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