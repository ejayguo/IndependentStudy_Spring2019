function F = KB_Temp_Error_Func(x)
%

F(1) = -0.9864+(1-x(4))+x(1)-(1-x(4))*x(1);
F(2) = -0.65854+(1-x(5))+x(1)-(1-x(5))*x(1);
F(3) = -0.98113+(1-x(6))+x(2)-(1-x(6))*x(2);
F(4) = -0.70526+(1-x(7))+x(2)-(1-x(7))*x(2);
F(5) = -0.84694+(1-x(8))+x(2)-(1-x(8))*x(2);
F(6) = -1+(1-x(9))+(1-x(24))+x(1)-(1-x(9))*(1-x(24))-(1-x(9))*x(1)-(1-x(24))*x(1)+(1-x(9))*(1-x(24))*x(1);
F(7) = -0.84615+(1-x(9))+(1-x(25))+x(1)-(1-x(9))*(1-x(25))-(1-x(9))*x(1)-(1-x(25))*x(1)+(1-x(9))*(1-x(25))*x(1);
F(8) = -0.83165+(1-x(9))+(1-x(26))+x(1)-(1-x(9))*(1-x(26))-(1-x(9))*x(1)-(1-x(26))*x(1)+(1-x(9))*(1-x(26))*x(1);
F(9) = -0.94558+(1-x(9))+(1-x(27))+x(1)-(1-x(9))*(1-x(27))-(1-x(9))*x(1)-(1-x(27))*x(1)+(1-x(9))*(1-x(27))*x(1);
F(10) = -1+(1-x(9))+(1-x(28))+x(3)-(1-x(9))*(1-x(28))-(1-x(9))*x(3)-(1-x(28))*x(3)+(1-x(9))*(1-x(28))*x(3);
F(11) = -0.95455+(1-x(10))+(1-x(19))+x(1)-(1-x(10))*(1-x(19))-(1-x(10))*x(1)-(1-x(19))*x(1)+(1-x(10))*(1-x(19))*x(1);
F(12) = -0.54225+(1-x(10))+(1-x(20))+x(1)-(1-x(10))*(1-x(20))-(1-x(10))*x(1)-(1-x(20))*x(1)+(1-x(10))*(1-x(20))*x(1);
F(13) = -0.9375+(1-x(10))+(1-x(21))+x(1)-(1-x(10))*(1-x(21))-(1-x(10))*x(1)-(1-x(21))*x(1)+(1-x(10))*(1-x(21))*x(1);
F(14) = -0.84409+(1-x(10))+(1-x(22))+x(2)-(1-x(10))*(1-x(22))-(1-x(10))*x(2)-(1-x(22))*x(2)+(1-x(10))*(1-x(22))*x(2);
F(15) = -1+(1-x(10))+(1-x(23))+x(3)-(1-x(10))*(1-x(23))-(1-x(10))*x(3)-(1-x(23))*x(3)+(1-x(10))*(1-x(23))*x(3);
F(16) = -1+(1-x(11))+(1-x(14))+x(3)-(1-x(11))*(1-x(14))-(1-x(11))*x(3)-(1-x(14))*x(3)+(1-x(11))*(1-x(14))*x(3);
F(17) = -1+(1-x(11))+(1-x(15))+x(1)-(1-x(11))*(1-x(15))-(1-x(11))*x(1)-(1-x(15))*x(1)+(1-x(11))*(1-x(15))*x(1);
F(18) = -1+(1-x(12))+x(3)-(1-x(12))*x(3);
F(19) = -1+(1-x(13))+x(2)-(1-x(13))*x(2);
F(20) = -1+x(4);
F(21) = -1+x(9);
F(22) = -1+x(25);
