function dim = l1_statdim(ks, d)

for kk=1:length(ks)
  rho=ks(kk)/d;
  tau1=1e-6;
  tau2=1e+6;
  while 1
    taus=exp(linspace(log(tau1), log(tau2),20));
    res=l1_statdim_fun(rho, taus);
    resp=res; resp(resp<0)=inf;
    [~,ix1]=min(resp);
    resn=res; resn(resn>=0)=-inf;
    [~,ix2]=max(resn);
    tau1=taus(ix1); tau2=taus(ix2);
    fprintf('tau1=%g tau2=%g\n', tau1, tau2);
    if abs(tau1-tau2)<1e-6;
      break;
    end
  end
  tau=(tau1+tau2)/2;

  dim(kk)=d*(rho*(1+tau^2)+(1-rho)*sqrt(2/pi)*((1+tau^2)*sqrt(2*pi)*(1-normcdf(tau))-tau*exp(-tau^2/2)));
end

function res = l1_statdim_fun(rho, tau)

res = exp(-tau.^2/2)./tau - sqrt(2*pi)*(1-normcdf(tau)) - sqrt(pi/2)*rho/(1-rho);