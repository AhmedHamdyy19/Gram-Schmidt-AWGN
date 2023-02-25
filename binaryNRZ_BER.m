function binaryNRZ_BER(M, To, probability)

    assert(M(1) == -M(2), "Symbols amplitude must be the same but with different sign")
    assert(probability > 0 && probability < 1, "Probability of ones must be a number ranging from 0 to 1")
          
    dt = To/10;
    [coeffecients, ~] = GramSchmidt(M, To);
    S11 = coeffecients(1);
    S21 = coeffecients(2);
    samples = 10;
    Eb = M(1)^2 * To;
    EbNo_dB = [-10 -8 -6 -4 -2 0 2 4 6];
    EbNo = 10.^(EbNo_dB/10);
    numValues = length(EbNo_dB);
    No = Eb./EbNo;  
    snr = 10*log10(1/samples .* EbNo);            
    N = 100000;
    fs = 1/dt;
    df = 1/(N*dt*samples);
    f = -fs/2:df:fs/2 - df;
    
    n = round(N*probability);                    %desired number of ones
    randomVector = [ ones(1,n) zeros(1,N-n) ];   %n ones and N-n zeros
    randomVector = randomVector(randperm(N));
    
    %--------------------- Transmitter ----------------------
    
    %Sequence generation
    randomVector(randomVector==1) = M(1);
    randomVector(randomVector==0) = M(2);       
    
    %Extending the sequence to get continous time signal
    randomInTime = repelem(randomVector,samples);
    
    %Low pass filter with BW equal to the second null
    U = fftshift(fft(randomInTime)) .* (heaviside(f-2/To)-heaviside(f+2/To));
    randomInTime = ifft(fftshift(U));
    
    %adding a negligible img part to the signal because otherwise awgn() will add real noise only
    randomInTime = randomInTime + 1e-10*1i;   
    
    %--------------------- Channel --------------------------
                                                 
    signalWithNoise = zeros(numValues,length(randomInTime));
    power = bandpower(randomInTime);
    for cc=1:numValues
        signalWithNoise(cc,:) = awgn(randomInTime,snr(cc), 10*log10(power));
    end
    
    %--------------------- Receiver ----------------------
    
    %Low pass filter with BW equal to the second null
    afterFilter = fftshift(fft(signalWithNoise, N*samples, 2), 2);
    afterFilter = afterFilter.* repmat(heaviside(f-2/To)-heaviside(f+2/To), numValues, 1);
    afterFilter = ifft(fftshift(afterFilter,2), N*samples, 2);
    
    %Integrate and dump 
    receivedSignal = sqrt(To) .* intdump(afterFilter', samples)'; 
    
    %Decision Device
    lambda = ( S11+S21 )/2 + No.*(log(probability/(1-probability)) / (2*S21-S11));
    afterThreshold = zeros(numValues,N);
    for cc=1 : numValues
        afterThreshold(cc,:) = double(real(receivedSignal(cc,:)) > lambda(cc));
    end
    afterThreshold(afterThreshold == 1) = M(1);
    afterThreshold(afterThreshold == 0) = M(2);

    %Counting the number of error bits by comparing the received bits to the generated bits
    errorBits = sum((afterThreshold ~= randomVector),2);  
    
    %--------------------------------------------------------
    
    figure
    for cc=1 : numValues
        subplot(ceil(numValues/3),3,cc)
        scatter(real(receivedSignal(cc,:)),imag(receivedSignal(cc,:)),5)
        title(['E_{b} / N_{o} = ' int2str(EbNo_dB(cc)) ' dB'],'FontWeight', 'normal');
        xlabel("Real Part");  ylabel("Imaginary Part")
        grid on
    end
    sgtitle("Constellation at the receiver")
    
    figure
    for cc=1 : numValues
        subplot(ceil(numValues/3),3,cc)
        scatter(real(receivedSignal(cc,:)), zeros(1,length(receivedSignal)) ,5)
        title(['E_{b}/N_{o} = ' int2str(EbNo_dB(cc)) ' dB'],'FontWeight', 'normal');
        xlabel("φ_{1}(t)")
        grid on
    end
    sgtitle("Constellation after projection on φ_{1}")
    
    Pe = zeros(1,numValues);
    
    for cc=1 : numValues
        figure
        h = histogram(real(receivedSignal(cc,:)),40,'Normalization','pdf');
        limits = h.BinLimits;
        bar(linspace(limits(1),limits(2), 40), 2*h.Values, 'FaceColor', '#CCF6FB')
        hold on
        title(sprintf('E_{b}/N_{o} = %g dB and probability of ones = %g', EbNo_dB(cc),...
            probability), 'FontWeight', 'normal');
        xlabel("φ_{1}(t)")
        std = sqrt(No(cc)/2);
        x = linspace(S21-4*std, S11+4*std, 1000);
        pd1 = makedist('Normal', S11, sqrt(No(cc)/2));
        pd2 = makedist('Normal', S21, sqrt(No(cc)/2));
        dist1 = pdf(pd1,x); dist2 = pdf(pd2,x); 
        closest = interp1(x,x,lambda(cc),'nearest');
        idx = find(x==closest);
        p1 = trapz( x(1:idx), dist1(1:idx) );
        p2 = trapz( x(idx:end), dist2(idx:end)); 
        Pe(cc) = probability*p1 + (1-probability)*p2;       
        plot(x, (dist1.* probability*2  + dist2 .* (1-probability)*2), 'k', 'LineWidth', 1.7)
        xlim([-3*std+S21 3*std+S11])
        x1 = linspace(S11-4*std, S11+4*std, 100);
        x2 = linspace(S21-4*std, S21+4*std, 100);
        dist11 = 2.*probability.*pdf(pd1,x1); dist22 = 2.*(1-probability).*pdf(pd2,x2);
        plot(x1,dist11, 'Color', 'b', 'LineWidth' , 1.3, 'LineStyle', '--')
        plot(x2,dist22, 'Color', '#8b0000', 'LineWidth' , 1.3, 'LineStyle', '--')
        plot(x, (dist1.* probability*2  + dist2 .* (1-probability)*2), 'k', 'LineWidth', 1.7)
        legend("Received Bits Distribution", "Theroretical Distribution",...
            "F_{X1}(X_{1}|S_{1})",  "F_{X1}(X_{1}|S_{2})")
        hold off
    end
    
    if probability == 0.5   %If P1 = P2 calculate the BER using the formula
        BER = qfunc(sqrt(2*EbNo));
    else                    %If P1 ~= P2 calculate the BER using the calculated intersection area
        BER = Pe;
    end
        
    figure
    semilogy(EbNo_dB, errorBits./N, 'k')
    ylabel("BER"); xlabel("Eb/No(dB)")
    title("Actual BER")
    grid on
    
    figure
    semilogy(EbNo_dB, errorBits./N, 'k', EbNo_dB, BER ,'r')
    ylabel("BER"); xlabel("Eb/No(dB)")
    legend("Actual BER", "Theoretical BER")
    grid on
end
