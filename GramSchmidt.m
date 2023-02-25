function [basisCoeff, symbols_energy] = GramSchmidt(M, To)

    rows = size(M,1);                           %Number of input signals
    columns = size(M,2);                        %Number of values taken within each period
    s = repelem(M,1,1000);                      %Signals matrix
    dt = To/(columns*1000);                               %Time step
    t = linspace(0, To-dt, 1000*columns);
        
    figure
    for cc=1 : rows
        subplot(floor((rows+1)/2),2,cc)
        plot([t To], [s(cc,:) 0])                        %Plotting the input signals
        ax = gca; ax.XAxisLocation = 'origin';
        ylim([-max(abs(M(cc,:)))-1, max(abs(M(cc,:)))+1])
        xlim([0 To+0.5])
        grid on
        title(['S_{' int2str(cc) '}(t)'],'FontWeight', 'normal');
        xlabel("t")
    end
    phi(rows,columns*1000) = 0;                %Basis functions matrix
    basisCoeff(rows,rows) = 0;                  %Coefficients matrix

    % Gram-Schmidt Algorithm
    for cc=1: rows
        g = s(cc,:);
        for bb=1:rows
            g = g - basisCoeff(cc,bb)*phi(bb,:);
        end
        if max(abs(g)) < 1e-3        %Neglect phi(cc) if the difference between the input signal and the
            phi(cc,:) = 0;           %reconstructed signal is so small because it's certainly an error 
                                     %due to the accroximate integrals.
        else
            phi(cc,:) = g/sqrt(trapz(t,g.^2));
            basisCoeff(cc,cc) = sqrt(trapz(t,g.^2));
            basisCoeff(cc, cc+1:end) = 0;
            
            for dd= cc+1 : rows                                  %Finding the projection of other input function
                basisCoeff(dd,cc) = trapz(t,s(dd,:).*phi(cc,:)); %on the calculated basis function.
                if abs(basisCoeff(dd,cc)) < 1e-3                    
                    basisCoeff(dd,cc) = 0;                      %Neglect the projection if it has a very small value
                end                                             %because it's an error due to the accroximate
            end                                                 %integrals.
        end
    end

    idx = find(all(phi==0,2));    %Find the index of basis functions with zero values
    phi(idx,:) = [];              %Delete the basis functions with zero values
    basisCoeff(:,idx) = [];       %Delete the coeffecients that are multiplied by the deleted basis functions

    figure
    for cc=1 : size(phi,1)
        subplot(floor((size(phi,1)+1)/2),2,cc)
        plot([t To],[phi(cc,:) 0])                         %Plotting the basis functions
        ax = gca; ax.XAxisLocation = 'origin';
        ylim([-max(abs(phi(cc,:)))-1, max(abs(phi(cc,:)))+1])
        xlim([0 To+0.5])
        title(['φ_{' int2str(cc) '}(t)'],'FontWeight', 'normal');
        xlabel("t"); grid on
    end

    reconstructedSignals = basisCoeff * phi;   %Matrix multiplication of the coefficients matrix and the basis functions
                                               %to get the reconstructed signals.
    figure 
    for cc=1 : rows
        subplot(floor((rows+1)/2),2,cc)
        plot([t To],[reconstructedSignals(cc,:) 0])  %Plotting the reconstructed signals
        ax = gca; ax.XAxisLocation = 'origin';
        ylim([-max(abs(reconstructedSignals(cc,:)))-1, max(abs(reconstructedSignals(cc,:)))+1])
        xlim([0 To+0.5])
        title(['reconstructed S_{' int2str(cc) '}(t)'],'FontWeight', 'normal');
        xlabel("t"); grid on
    end
    
    x = basisCoeff(:,1);
    y = zeros(length(x),1);
    if(size(phi,1) == 2)
        y = basisCoeff(:,2);
    elseif(size(phi,1) == 3)
        y = basisCoeff(:,2);
        z = basisCoeff(:,3);
    end
    
    if(size(phi,1) < 4)
        figure
        hold on
        title("Signal Constellation"); xlabel("φ_{1}"); ylabel("φ_{2}")
        grid on
        xlim([min(x)-0.5 max(x)+0.5])
        ax = gca;
        ax.XAxisLocation = 'origin'; ax.YAxisLocation = 'origin';
        if(size(phi,1) == 1 || size(phi,1) == 2)
            scatter(x,y,'filled')  
            ylim([min(y)-0.5 max(y)+0.5])
        elseif(size(phi,1) == 3)
            hold off
            scatter3(x,y,z,'filled')
            title("Signal Constellation")
            xlim([min(x)-0.5 max(x)+0.5])
            ylim([min(y)-0.5 max(y)+0.5])
            zlim([min(z)-0.5 max(z)+0.5])
            xlabel("φ_{1}"); ylabel("φ_{2}"); zlabel("φ_{3}")       
        end
        hold off
        
        figure
        hold on
        title("Signal Space"); xlabel("φ_{1}"); ylabel("φ_{2}")
        ax = gca;
        ax.XAxisLocation = 'origin';  ax.YAxisLocation = 'origin';
        xlim([min(x)-0.5 max(x)+0.5])
        grid on
        if(size(phi,1) == 1 || size(phi,1) == 2)
            quiver(zeros(length(x),1),zeros(length(x),1), x, y, 0, 'linewidth', 1.5)      
            ylim([min(y)-1 max(y)+1])
        elseif(size(phi,1) == 3)
            hold off
            quiver3(zeros(rows,1),zeros(rows,1) ,zeros(rows,1) ,x, y, z, 0, 'linewidth', 1.5);
            title("Signal Space")
            xlabel("φ_{1}"); ylabel("φ_{2}"); zlabel("φ_{3}")
            xlim([min(x)-0.5 max(x)+0.5])
            ylim([min(y)-0.5 max(y)+0.5])
            zlim([min(z)-0.5 max(z)+0.5])
        end
        hold off
    end

    symbols_energy(1,rows) = 0;
    for cc = 1:rows
        symbols_energy(1,cc) = norm(basisCoeff(cc,:)).^2;  %Calculating the energy of each symbol using the second norm
    end

end
