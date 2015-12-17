% ERRORBAR_LOGSAFE - Computes a log-safe errorbar
%
% Syntax
%  function h=errorbar_logsafe(X, Y, E, epsilon)
%
% Reference
% "On the extension of trace norm to tensors"
% Ryota Tomioka, Kohei Hayashi, and Hisashi Kashima
% arXiv:1010.0789
% http://arxiv.org/abs/1010.0789
% 
% Copyright(c) 2010 Ryota Tomioka
% This software is distributed under the MIT license. See license.txt


function h=errorbar_logsafe(X, Y, E, epsilon)

if ~exist('epsilon','var')
  epsilon=0.99;
end


U = E;
L = min(E,Y*epsilon);

h=errorbar(X,Y,L,U);