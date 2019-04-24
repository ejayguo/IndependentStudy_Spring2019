function X = CS6640_FFT_shape(Z,w)
% CS6640_FFT_shape - compute Fourier shape descriptors for a curve
% On input:
%     Z (Nx2 array): input curve (should be closed)
%     w (int): distance along curve to determine angles
% On output:
%     X ((N/2-1)x1 vector): the Fourier coefficients for the curve
% Call:
%     X = CS6640_FFT_shape(curve,2);
% Author:
%     T. Henderson
%     UU
%     Fall 2018
%

L = length(Z(:,1));
theta = zeros(L,1);
theta(1) = atan2(Z(2,2)-Z(1,2),Z(2,1)-Z(1,1));
dirs = zeros(L,3);
dirs(1,:) = [cos(theta(1)),sin(theta(1)),0];
for t = 2:L
    forward = mod(t+w,L);
    if forward==0
        forward = L;
    end
    tf = (atan2(Z(forward,2)-Z(t,2),Z(forward,1)-Z(t,1)));
    dirs(t,:) = [cos(tf),sin(tf),0];
    v = cross([dirs(t-1,:)],dirs(t,:));
    a = acos(dot(dirs(t-1,1:2),dirs(t,1:2)));
    theta(t) = theta(t-1) + sign(v(3))*a;
end
phi = zeros(1,L);
for p = 1:L
    if -2*pi<=theta(p)&theta(p)<=2*pi
        phi(p) = theta(p)-theta(1);
    else
        phi(p) = mod(theta(p)-theta(1),2*pi);
    end
end
%phi = mod(theta - theta(1),2*pi);
psi = zeros(L,1);
index1 = 0;
for t = 0:2*pi/(L-1):2*pi
    index1 = index1 + 1;
    index = max(1,floor(L*t/(2*pi)));
    psi(index1) = rem(phi(index) + t,pi);
    psi(index1) = phi(index) + t;
end

X = fft(psi);
X = X(2:floor(L/2));
X = X.*conj(X);
tch = 0;
