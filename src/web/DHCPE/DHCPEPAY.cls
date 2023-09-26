Import SQLUser

Class web.DHCPE.DHCPEPAY Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 194;

ClassMethod paybill(billno, user, loc, str, deplist, flag, sumright) As %String
{
	 ;str="&463.28&现金^^^^^463.28"  deplist="^1293||1^1293||2"
	n (billno,user,loc,str,deplist,flag,sumright)
	;字符处理
	
	s ARREC=0
	;
	s billno=+billno
	s CardNo=$P(str,"#",2)     //20120718
	s str=$P(str,"#",1) 	   //20120718
	s str=$e(str,2,$l(str)),ln=$l(str,"&"),right=$e(str,$l(str))
	s payamt=+$p(str,"&",1)
	i sumright-payamt'=0  q -1
	i str="" s payamt=0
	f n=2:1:ln  s paymod(n-1)=$p(str,"&",n)
	i right="!" s outstamt=paymod(ln-1) k paymod(ln-1)
	;q paymod(1)_"&&&"_paymod(2)
	;Start a Transaction
	//s $ZT="ERROR^DHCSSERR" s ttt=..tb()
	//s ttt=..tb()
	;插入AR_RECEIPTS记录
	s ^DHCPETemp("billno","a")=billno
	s s=^DHCPB(+billno),adm=$p(s,"^",1),papmi=$p(^PAADM(adm),"^",1)
	
	i ln>1 s recamt=..sum(.paymod)
	i ln=1 s recamt=payamt
	i recamt-payamt>0  s PLIST(11)=recamt-payamt  ;PLIST(11) ->ARRCP_RecvAmt
	s PLIST(3)=loc,PLIST(7)=+$H  
	s PLIST(49)=user,PLIST(50)=+$H,PLIST(51)=$P($H,",",2)
	s PLIST(52)=papmi ;papmi_rowid
	s PLIST(44)=+$p(s,"^",9),PLIST(47)=+$p(s,"^",11)
	s PLIST(48)=loc_"||"
	s PLIST(23)=PLIST(47)+$P(s,"^",12)
	//s ^zl("BillCharge",1)=BillNo_"^"_UserID_"^"_LocID_"^"_PayModeStr_"^"_DepositStr_"^"_0_"^"_PayAmount
	;s err=$$insert^MVBARREC()
	&sql(insert into AR_Receipts values :PLIST())
	s err=SQLCODE
	;插入AR_RCPTPAYMODE表记录
	;s ARREC=$p(PLIST(1),$c(1)) k PLIST
	s ARREC=$g(%ROWID)
	;
	s l=$o(paymod(""),-1),sum=0
	;s:'l PLIST(5)=payamt,PLIST(0)=ARREC,PLIST(3)=2,err=$$insert^MVBARRPM(ARREC)  ;PLIST(3) PAYM_PayMode_DR 2现金
	i 'l d
	.s PLIST(5)=payamt,PLIST(0)=ARREC,PLIST(3)=2
	.&sql(insert into AR_RcptPayMode values :PLIST())
	.s err=SQLCODE
	;q ARREC
	s ^zltmp("0403","AccID","1-1")=papmi_"^"_adm
	s sum=..paymode(ARREC,.paymod,user,papmi,CardNo)   //20120718
	;  
	;插入和更新AR_RCPTALLOC
	;ARRAL_PayAmt 4,ARRAL_Admission_DR 9,ARRAL_1stPayFlag 18,ARRAL_ARPBIL_DR 23
	i (deplist="")&(flag=1) d
	.s ttt=..getdeposit(adm)
	.m DEP=PLIST
	i deplist'=""  d
	.s ln=$l(deplist,"^")
	.f n=2:1:ln  d
	..s DEP(n-1)=$p(deplist,"^",n)

	s itm=$o(DEP(""),-1)
		
	k PLIST s PLIST(0)=ARREC
	s PLIST(4)=payamt
	;s:'sum PLIST(4)=payamt
	s:(sum'="err")&(sum<payamt) PLIST(4)=+sum
	i sum="err" s PLIST(4)=payamt
	s PLIST(9)=adm,PLIST(23)=billno
	;s PLIST(18)="N"
	;i itm="" s PLIST(18)="Y"
	;s err=$$insert^MVBARRCA(ARREC)
	&sql(insert into AR_RcptAlloc values :PLIST())
	;
	s err=SQLCODE
	i itm s ttt=..arral(itm,.DEP,billno) 
	;s err=$$select^MVBARREC(ARREC)
	s PLIST(54)="",PLIST(55)="",PLIST(56)=""
	;s err=$$update^MVBARREC(ARREC)
	&sql(update AR_Receipts set ARRCP_GLBatch_DR=null,ARRCP_InvalidFlag=null,ARRCP_InvalidAmt=null where ARRCP_RowId=:ARREC)
	s err=SQLCODE
	;
	;更新账单??更新医嘱标价位
	;s err=$$SELECT^DHCJFPB(billno)
	s err=##class(web.UDHCJFPB).SELECT(billno)
	s PLIST(7)=+PLIST(7)
	s PLIST(8)=+PLIST(8)
	s PLIST(17)="P"
	s PLIST(15)=payamt    ;PB_AmountToPay
	s PLIST(14)=payamt    ;PB_AmountPaid
	i sum'="err"&(sum<payamt) s PLIST(14)=sum
	s PLIST(20)=+$h      ;PB_UpdateDate
	s PLIST(21)=$p($h,",",2)  ;PB_UpdateTime
	s PLIST(22)=user   ; PB_UpdateUser
	;s err=$$UPDATE^DHCJFPB(billno)
	s err=##class(web.UDHCJFPB).UPDATE(billno)
	i 'err s err=..updateitms(billno)
	;
	;Commit a Transaction
	//s ttt=..tc()
	q ARREC
	;
}

ClassMethod getdeposit(adm)
{
 ;get current patient's deposits
	k PLIST
	s arrcp="",dep=0,n=0 f  s arrcp=$o(^ARRCP("Adm_DR",+adm,arrcp))  q:arrcp=""  d
	.s arral=""  f  s arral=$o(^ARRCP("Adm_DR",adm,arrcp,arral))  q:arral=""   d
	..s s=^ARRCP(arrcp,"RAL",arral),arpbl=$p(s,"^",18),flag=$p(s,"^",5),amt=+$p(s,"^",2)
	..i +arpbl=0  s dep=dep+amt,n=n+1,PLIST(n)=arrcp_"||"_arral
	s PLIST=$o(PLIST(""),-1)
	s P9=$p(^PAADM(adm),"^",45) ;$p(^PAADM(adm),"^",45)->BILL
	q dep
	;
}

ClassMethod arral(itm, DEP, billno)
{
    
    ;押金插入明细
	;PLIST(23)->ARRAL_ARPBIL_DR
	f n=1:1:itm  d
	.k PLIST
	.s ralid=DEP(n)
	.;s err=$$select^MVBARRCA(ralid)
	.;s PLIST(23)=billno
	.;s err=$$update^MVBARRCA(ralid)                
	.&sql(update AR_RcptAlloc set ARRAL_ARPBIL_DR=:billno where ARRAL_ROWID=:ralid)
	q err
}

ClassMethod paymode(ARREC, paymod, user, papmi, CardNo)
{
	   ;付款明细插入  现金^农业银行^123^456^789^263.28
	;PLIST(4) CMBANK; PLIST(6) CARDCHEQUNO; PLIST(7) AUTHORCODE; PLIST(21) GOVERNNO
	n (ARREC,paymod,user, papmi, CardNo)   
	s sum=0
	s l=$o(paymod(""),-1)
	i 'l q "err"
	f n=1:1:l  d
	.k PLIST  s PLIST(0)=ARREC
	.s mode=$p(paymod(n),"^",1),bank=$p(paymod(n),"^",2),PLIST(6)=$p(paymod(n),"^",3)
	.//s mode=$$ALPHAUP^SSUTIL4(mode)
	.s bank=$$ALPHAUP^SSUTIL4(bank)
	.s PLIST(7)=$p(paymod(n),"^",4),PLIST(21)=+$p(paymod(n),"^",5)
	.s PLIST(5)=+$p(paymod(n),"^",6)  ;支付金额
	.s PLIST(3)=mode
	.s paymode=$P(^CT("CTPM",mode),"^",1)         //add 20120718
	.if paymode="CPP" d                           //如果是门诊预交金记录预交金账户ID
	..s PLIST(22)=CardNo      //记录账号ID
	
	.//i mode=""  d
	.//.s PLIST(3)=""
	.//e  d
	.//.s PLIST(3)=$o(^CT("CTPM",0,"Desc",mode,""))      
	.i bank=""  d
	..s PLIST(4)=""
	.e  d
	..s PLIST(4)=$o(^CMC("CMCBM",0,"CMCBM_Desc",bank,""))
	.;s err=$$insert^MVBARRPM(ARREC)
	.;&js<alert("#(mode)#"+"#(bank)#")>
	.b ;AR_RcptPayMode 1
	.&sql(insert into AR_RcptPayMode values :PLIST())
	.b ;AR_RcptPayMode 2
	.s err=SQLCODE
	.s sum=sum+PLIST(5)
	.s ^zltmp("0403","AccID",2)=paymode_"^"_papmi_"^"_CardNo_"^"_PLIST(5)
	.;.s myrtn=##class(web.DHCPE.DHCQseXmComm).ReduDepos(user,papmi,CardNo,PLIST(5))    //add 20120718
	q sum
}

ClassMethod sum(plist)
{
	n (plist)
	s len=$o(plist(""),-1)
	s m=0
	f n=1:1:len  d
	.s str=+$p(plist(n),"^",6)
	.s m=m+str
	q m
}

ClassMethod tb()
{
 n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q SQLCODE
}

ClassMethod tc()
{
    n SQLCODE
    TCOMMIT  s SQLCODE=$zu(34)
	q SQLCODE
}

ClassMethod updateitms(billno)
{
	n (billno) 
	s pbo=0 f  s pbo=$o(^DHCPB(billno,"O",pbo))  q:pbo=""  s s=^(pbo)  d
	.s oeori=$p(s,"^",4)
	.q:'$d(^OEORD($p(oeori,"||",1),"I",$p(oeori,"||",2)))
	.s BillStatus=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",5)
	.s $p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",5)="P"
	.s $p(^DHCPB(billno,"O",pbo),"^",16)=BillStatus
	.s itm=0 f  s itm=$o(^DHCPB(billno,"O",pbo,"D",itm)) q:itm=""  d
	..s $p(^DHCPB(billno,"O",pbo,"D",itm),"^",14)="P"
	q 0 
	 ;
}

ClassMethod PBCancel(ADM, BILL, User, invflag, InvprtID, RefuntInfo, HospitalID)
{
	;
	s ^tmpdhcpe("0403")=RefuntInfo
	n (ADM,BILL,User,invflag,InvprtID,RefuntInfo,HospitalID)
	s BILL=$g(BILL),User=$g(User)
	s PayModeCode=$P(RefuntInfo,"^",1)                                   //add by zhouli
	s CardAccDR=$P(RefuntInfo,"^",2)                                    //add by zhouli
	s RefuntMoney=$P(RefuntInfo,"^",3)                                //add by zhouli
	s papmi=$p($g(^PAADM(ADM)),"^",1) 
	s LocID=$P($G(^PAADM(ADM)),"^",4)                                    
	q:BILL="" 100
	i '$d(^DHCPB(BILL)) q 100
	q:$p(^DHCPB(BILL),"^",16)'="P" 100
	q:$p(^DHCPB(BILL),"^",17)'="" 100
	s err=""
	i invflag="Y" d
	.s tmpno=##Class(web.DHCPE.DHCPEPAY).getcurinvno(User,"N",LocID)
	.s invno=$p(tmpno,"^",1)
	.s rid=$p(tmpno,"^",2)
	.i invno="" s err="null"
	q:err="null" err
	;Start a Transaction
	//s $ZT="ERROR^SSERR" d ..tb()
	;
	;Create a RED BILL and mark it is a refund bill
	s err=##CLASS(web.UDHCJFPB).SELECT(BILL)            ;q:err err
	s PLIST(18)="R"
	s PLIST(19)=BILL
	s PLIST(22)=User
	s PLIST(9)=-PLIST(9)
	s PLIST(10)=-PLIST(10)
	s PLIST(12)=-PLIST(12)
	s PLIST(13)=-PLIST(13)
	s PLIST(14)=-PLIST(14)
	s PLIST(15)=-PLIST(15)
	s err=##CLASS(web.UDHCJFPB).INSERT()                ;q:err err向表dhc_patientbill中加付值
	s RedBill=$p(PLIST(1),$c(1))
	
	s Order=0
	f  s Order=$o(^DHCPB(BILL,"O",Order)) q:Order=""  d
	.s err=##CLASS(web.UDHCJFPBO).SELECT(BILL_"||"_Order)               ;q:err
	.k PLIST(1),PLIST(2)
	.s ORD=$g(PLIST(4),$c(1))
	.s PLIST(0)=RedBill
	.s PLIST(7)=-PLIST(7),PLIST(6)=-PLIST(6)
	.s PLIST(8)=-PLIST(8),PLIST(9)=-PLIST(9),PLIST(10)=-PLIST(10),PLIST(11)=-PLIST(11)
	.s err=##CLASS(web.UDHCJFPBO).INSERT()     
	.s NewPBO=PLIST(1)
	.s Itm=0 f  s Itm=$o(^DHCPB(BILL,"O",Order,"D",Itm)) q:Itm=""  d
	..s err=##CLASS(web.UDHCJFPBOD).SELECT(BILL_"||"_Order_"||"_Itm)    ;q:err
	..k PLIST(1),PLIST(2)
	..s PLIST(0)=NewPBO
	..s PLIST(5)=-PLIST(5)
	..s PLIST(7)=-PLIST(7),PLIST(8)=-PLIST(8),PLIST(9)=-PLIST(9),PLIST(10)=-PLIST(10)
	..s PLIST(11)=+$H,PLIST(12)=$p($H,",",2),PLIST(14)=+$H,PLIST(15)=$p($H,",",2),PLIST(16)=User
	..s err=##CLASS(web.UDHCJFPBOD).INSERT()                                                    ;q:err
	  
	;Update BILL to mark it is a refunded bill
	s err=##CLASS(web.UDHCJFPB).SELECT(BILL)            ;q:err err
	s PLIST(18)="B"
	s PLIST(19)=RedBill
	s err=##CLASS(web.UDHCJFPB).UPDATE(BILL)            ;q:err err      
	;Change Bill Status of Orders of BILL to Billed
	s Ord=0
	f  s Ord=$o(^DHCPB(BILL,"O",Ord)) q:Ord=""  d
	.s BillStatus=$P(^DHCPB(BILL,"O",Ord),"^",16)
	.s OEITM=$p(^DHCPB(BILL,"O",Ord),"^",4)
	.s $p(^OEORD(+OEITM,"I",$p(OEITM,"||",2),3),"^",5)=BillStatus
	;Create a Red Receipts 
	s Rcp=0  f  s Rcp=$o(^ARRCP("ARPBL",BILL,Rcp)) q:Rcp=""  d
	.s Ral=0 f  s Ral=$o(^ARRCP("ARPBL",BILL,Rcp,Ral)) q:Ral=""  d
	..;s err=$$select^MVBARRCA(Rcp_"||"_Ral)               
	..s a=Rcp_"||"_Ral
	..&sql(select * into :PLIST() from ar_rcptalloc where arral_rowid=:a)
	..s DepositType=$p(PLIST(17),$c(1))
	..q:$g(DepositType)'=""
	..s err=..RedRcp(Rcp,User,RedBill,CardAccDR)
	..;&js<alert(#(err)#);>
	;Commit a Transaction
	;Deposit link Changed to Blank   修改成按新索引取值
	s Rcp=0  f  s Rcp=$o(^ARRCP("ARPBL",BILL,Rcp)) q:Rcp=""  d
	.s Ral=0 f  s Ral=$o(^ARRCP("ARPBL",BILL,Rcp,Ral)) q:Ral=""  d
	..s tmprowid=Rcp_"||"_Ral
	..&sql(select * into :PLIST() from ar_rcptalloc where arral_rowid=:tmprowid)
	..;s err=$$select^MVBARRCA(Rcp_"||"_Ral)                 ;q:err
	..s DepositType=$p(PLIST(17),$c(1))
	..q:$g(DepositType)=""
	..s PLIST(23)=""
	..s tmprowid=Rcp_"||"_Ral
	..i tmprowid'="" d
	...&sql(UPDATE ar_rcptalloc values :PLIST() where arral_rowid=:tmprowid)

	;UPDATE to new invoice table
	;是否走收据号   yyx
	s tmpno=""_"^"_""
	s cat="S"
	s redinvid=""
	i invflag="Y" d 
	.s tmpno=##Class(web.DHCPE.DHCPEPAY).getcurinvno(User,"N",LocID)
	.s invno=$p(tmpno,"^",3)_$p(tmpno,"^",1)
	.s rid=$p(tmpno,"^",2)
	.s err=##Class(web.DHCPE.DHCPEPAY).savetoinvprt(invno,User,BILL,cat,rid,"Y",InvprtID,"",HospitalID)
	.i $p(err,"^")=0 s redinvid=$p(err,"^",2)
	i invflag="N" d
	.s err=##Class(web.DHCPE.DHCPEPAY).savetoinvprt("",User,BILL,cat,"","N",InvprtID,"",HospitalID)        
	.i $p(err,"^")=0 s redinvid=$p(err,"^",2)
	
	/*
	;Create a new BILL or Search a existed BILL
	s bill=""
	s admbill=0 f  s admbill=$o(^DHCPB(0,"ADM",ADM,admbill)) q:admbill=""!(bill'="")  d
	.q:$p(^DHCPB(admbill),"^",16)="P"
	.i $p(^DHCPB(admbill),"^",16)="B" s bill=admbill
	;
	i bill="" s err=##CLASS(UDHCJFPB).PBINS(ADM,User),bill=$p(err,"^",2)
	;
	s TotalAmount=+$g(TotalAmount)
	s DiscAmount=+$g(DiscAmount)
	s PayorShare=+$g(PayorShare)
	s PatientShare=+$g(PatientShare)
	s DateF=+$H,DateT=0
	;
	s Order=0
	f  s Order=$o(^DHCPB(BILL,"O",Order)) q:Order=""  d
	.s err=##CLASS(UDHCJFPBO).SELECT(BILL_"||"_Order)               ;q:err
	.s oeitm=$p(^DHCPB(BILL,"O",Order),"^",4)
	.s orddate=$p(^DHCPB(BILL,"O",Order),"^",12)
	.;
	.i orddate<DateF s DateF=orddate
	.i orddate>DateT s DateT=orddate
	.;
	.k PLIST(1),PLIST(2),PLIST(16)
	.s PLIST(0)=bill
	.s err=##CLASS(UDHCJFPBO).INSERT()                              ;q:err
	.s TotalAmount=TotalAmount+PLIST(8)
	.s DiscAmount=DiscAmount+PLIST(9)
	.s PayorShare=PayorShare+PLIST(10)
	.s PatientShare=PatientShare+PLIST(11)
	.;
	.s PBO=PLIST(1)
	.s $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",16)=PBO
	.s Itm=0
	.f  s Itm=$o(^DHCPB(BILL,"O",Order,"D",Itm)) q:Itm=""  d
	..s err=##CLASS(UDHCJFPBOD).SELECT(BILL_"||"_Order_"||"_Itm)            ;q:err
	..k PLIST(1),PLIST(2)
	..s PLIST(0)=PBO
	..S PLIST(11)=+$H
	..S PLIST(12)=$P($H,",",2)
	..s PLIST(13)="B"
	..S PLIST(14)=+$H
	..S PLIST(15)=$P($H,",",2)
	..s PLIST(16)=User
	..s err=##CLASS(UDHCJFPBOD).INSERT()                                    ;q:err
	;
	s err=##CLASS(UDHCJFPB).SELECT(bill)                                    ;q:err 0
	s PLIST(9)=PLIST(9)+TotalAmount,PLIST(10)=PLIST(10)+DiscAmount
	s PLIST(12)=PLIST(12)+PayorShare,PLIST(13)=PLIST(13)+PatientShare
	i +PLIST(7)="0" s PLIST(7)=DateF
	i +PLIST(8)="0" s PLIST(8)=DateT
	i PLIST(7)>DateF s PLIST(7)=DateF
	i PLIST(8)<DateT s PLIST(8)=DateT 
	s PLIST(20)=+$H,PLIST(21)=$p($H,",",2)
	s PLIST(22)=User
	s err=##CLASS(UDHCJFPB).UPDATE(bill)                                    ;q:err 0
	//s err=..updatebillflag(ADM,"N")
	//d ..tc()
	;
	
	q 0_"^"_RedBill_"^"_bill
	*/
	q 0_"^"_redinvid
}

ClassMethod RedRcp(Rcp, User, Bill, CardAccDR As %String = "")
{
	n (Rcp,User,Bill,CardAccDR)
	;s err=$$select^MVBARREC(Rcp)
	&sql(select * into :PLIST() from ar_receipts where arrcp_rowid=:Rcp)
	s PLIST(50)=+$H,PLIST(51)=$P($H,",",2),PLIST(49)=User
	s PLIST(7)=+$H
	S PLIST(3)="2"
	K PLIST(1)
	&sql(insert into ar_receipts values :PLIST())
	s NewRcp=$g(%ROWID)
	s papmi=PLIST(52)                                         //add by zhouli
	//s Flag=..isReportInv(Rcp,"",User)
	s Ral=0 f  s Ral=$o(^ARRCP(Rcp,"RAL",Ral)) q:Ral=""  d
	.;s err=$$select^MVBARRCA(Rcp_"||"_Ral)
	.s a=Rcp_"||"_Ral
	.&sql(select * into :PLIST() from ar_rcptalloc where arral_rowid=:a)
	.s PLIST(0)=NewRcp
	.k PLIST(1)
	.s PLIST(23)=Bill
	.s PLIST(4)=-PLIST(4)
	.&sql(INSERT into ar_rcptalloc Values :PLIST())
	
	s Paym=0 f  s Paym=$o(^ARRCP(Rcp,"PAYM",Paym)) q:Paym=""  d
	.s a=Rcp_"||"_Paym
	.&sql(select * into:PLIST() from ar_rcptpaymode where paym_rowid=:a)
	.;s err=$$select^MVBARRPM(Rcp_"||"_Paym)
	.//退费如果不是这个收费员或者已经结算过的发票，支付方式修改为现金
	.//i Flag=1 d
	.//.i PLIST(5)<500 d
	.//..s OldPayMode=PLIST(3)
	.//..i OldPayMode="15" s PLIST(3)=1
	.//..i OldPayMode="4" s PLIST(3)=1
	.//修改支付方式结束
	.s PLIST(0)=NewRcp
	.k PLIST(1)
	.s PLIST(5)=-PLIST(5)
	.s PayCode=..GetCodeByDR(PLIST(3))			      //add by zhouli
	.i PayCode="CPP" d							      //add by zhouli
	..s PLIST(22)=CardAccDR
	.&sql(insert into ar_rcptpaymode values :PLIST())
	.q:SQLCODE'=0								      //add by zhouli
	.;.s myrtn=##class(web.DHCPE.DHCQseXmComm).ReduDepos(User,papmi,CardAccDR,PLIST(5))  //add by zhouli

    q 0
}

// s Flag=##class(web.DHCPE.DHCPEPAY).isReportInv(Rcp,InvID,User)

ClassMethod isReportInv(Rcp, InvID, User)
{
	//退费如果不是这个收费员或者已经结算过的发票，支付方式修改为现金
	s Flag=0  //没有结算，不是另外的收费员
	i Rcp'="" d
	.s OldInvNo=$P(^ARRCP(Rcp),"^",2)
	.s InvID=$O(^DHCPEINVPRT(0,"INV",OldInvNo,0))
	
	s ReportID=$P(^DHCPEINVPRT(InvID),"^",13)
	s OldUser=$P(^DHCPEINVPRT(InvID),"^",10)
	i ReportID'="" s Flag=1
	i OldUser'=User s Flag=1
	q Flag
	//判断结束
}

// w ##class(web.DHCPE.DHCPEPAY).getcurinvno(6601)

ClassMethod getcurinvno(User, finalflag As %Library.String = "N", CurLocID As %String = "")
{
	//n (User)
	s:$D(%session) LocID = %session.Get("LOGON.CTLOCID")
	i CurLocID'=""  s LocID =CurLocID
	//s finalflag=..GetFinalFlag()        //新老版本发票表的结束标记意义不同,用此参数来区分.老版本"N"为可以,新版本"Y"为可用.
	s finalflag=..GetFinalFlag(LocID)        //新老版本发票表的结束标记意义不同,用此参数来区分.老版本"N"为可以,新版本"Y"为可用.
	b ;finalflag
	s HospID=$p($g(^CTLOC(LocID)),"^",22)
	i finalflag="Y" s rtn=..getcurinvno1(User,HospID)
	i finalflag="N" s rtn=..getcurinvno2(User)
	i finalflag="" s rtn=..getcurinvno3(User)
	
	q rtn
}

ClassMethod getcurinvno1(User, HospID As %String = "")
{
	//n (User)
	i $D(%session) s HospID=%session.Get("LOGON.HOSPID")
	s no="",id="",title=""
	&sql(select inv_rowid,inv_lastnum,inv_finalflag,inv_title into :id,:no,:flag,:title from dhc_invoice where inv_usr=:User and inv_finalflag='Y' and inv_type='O' and INV_hospital=:HospID)
	s id=$g(id),no=$g(no),flag=$g(flag)
	i flag'["Y" q "^"
	i id="" q "^"	
	q $p(no,$c(1))_"^"_$p(id,$c(1))_"^"_$p(title,$c(1))
}

ClassMethod getcurinvno2(User)
{
	n (User)
	s no="",id="",title=""
	
	&sql(select inv_rowid,inv_lastnum,inv_finalflag,inv_startinv,inv_title into :id,:no,:flag,:startinv,:title from dhc_invoice where inv_usr=:User and inv_finalflag='N' and inv_type='O')
	s id=$g(id),no=$g(no),flag=$g(flag),startinv=$p($g(startinv),$c(1))
	i flag'["N" q "^"
	i id="" q "^"
	i +no=0 s no=startinv
	e  s no=..incre(no)
	q $p(no,$c(1))_"^"_$p(id,$c(1))_"^"_$p(title,$c(1))
}

ClassMethod getcurinvno3(User)
{
	n (User)
	s no="",id="",title=""
	
	&sql(select inv_rowid,inv_lastnum,inv_finalflag,inv_startinv,inv_title into :id,:no,:flag,:startinv,:title from dhc_invoice where inv_usr=:User and inv_finalflag='N' and inv_type='O')
	s id=$g(id),no=$g(no),flag=$g(flag),startinv=$p($g(startinv),$c(1))
	i flag'["N" q "^"
	i id="" q "^"
	i +no=0 s no=startinv
	q $p(no,$c(1))_"^"_$p(id,$c(1))_"^"_$p(title,$c(1))
}

ClassMethod getiniinv(BILL)
{
 ;取被冲红的原始记录
	   n (BILL)
	   s inv="" f  s inv=$o(^DHCPEINVPRT(0,"PB",BILL,inv)) q:inv=""  d
	   .s flag=$p(^DHCPEINVPRT(inv),"^",8)
	   .s deposit=$p(^DHCPEINVPRT(inv),"^",6)   
	   .i flag="N" s ret=inv
	   q $g(ret)_"^"_deposit
}

ClassMethod Abort0(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 s curno=$p(val,"^",1),newno=$p(val,"^",2),billno=$p(val,"^",3),usr=$p(val,"^",4)
 i curno="" q 100
 s prt=$o(^DHCINVPRTZY(0,"INV",curno,""))
 s handin=$p(^DHCINVPRTZY(prt),"^",14)
 i handin="Y" q 1
 s err=..Abort(curno, newno, billno, usr)
 q err
}

ClassMethod Abort(curno, newno, billno, usr)
{
 ;(id,stat,invno,user,bill) 
	;
	n (curno,newno,billno,usr)
	i (curno="")&(newno="") q 100
	
	i curno'=""  d
	.s prt=$o(^DHCINVPRTZY(0,"INV",curno,""))
	.s err=##CLASS(web.UDHCJFINVPRTZY).SELECT(prt)
	.s PLIST(10)="A"
	.s err=##CLASS(web.UDHCJFINVPRTZY).UPDATE(prt)
	.s arrcp=""
	.s arrcp=$o(^ARRCP("ARPBL",+billno,""),-1) 
	.i arrcp d
	..;s err=$$select^MVBARREC(arrcp)
	..;s PLIST(4)="" 
	..;s err=$$update^MVBARREC(arrcp)
	..&sql(update AR_Receipts set ARRCP_Number='' where ARRCP_ROWID=:arrcp)
	e   d  ;如果是未打印发票之前作废
	.s err=##CLASS(web.UDHCJFPB).SELECT(billno)
	.s invdat=+$h,invtim=$p($h,",",2),adm=PLIST(2),amount=PLIST(9)
	.Set Config=##Class(websys.Configuration).%OpenId(1)
    .Set MEDDATA=Config.DataNamespace
    .Set LABDATA=Config.LabDataNamespace
    .Set CurrentNS=$ZNSPACE
    .ZN MEDDATA
	.s err=$$select^MVBPAADM(adm),type=$p(PLIST(9),$c(1),2)
	.ZN CurrentNS
	.k PLIST
	.s PLIST(2)=newno,PLIST(3)=invdat,PLIST(4)=invtim,PLIST(5)=adm,PLIST(7)=billno
	.s PLIST(8)=amount,PLIST(9)=usr,PLIST(10)="A",PLIST(11)=type,PLIST(12)="N"
	.s err=##CLASS(web.UDHCJFINVPRTZY).INSERT()
	;i id="" d  
	;.i stat["作废" s sign="Abort"
	;.&sql(select arpbl_paadm_dr,arpbl_totalpatient 
	;    into :adm,:amount from ar_patientbill where arpbl_rowid=:bill)
	;.&sql(select paadm_type into:type from paadm where paadm_rowid=:adm)
	;.s amount=$p(amount,$c(1)),invdat=+$h,invtim=$p($h,",",2),type=$P(type,$c(1),2)
	;.&sql(insert into DHC_INVPRT(prt_inv,prt_date,prt_time,prt_adm,prt_arpbl,prt_acount,prt_usr,prt_flag,prt_pattype)
	;    values(:invno,:invdat,:invtim,:adm,:bill,:amount,:usr,:sign,:type) )
	;i id'="" d
	;.&sql(update dhc_invprt set prt_flag='Abort' where prt_rowid=:id)
	q 0
}

ClassMethod pbstatus(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 
	   s billno=val
	   s status=""
	   i $d(^DHCPB(billno))  d
	   .s status=$p(^DHCPB(billno),"^",16)
	   q status
}

ClassMethod pbflag(val As %Library.String = "")
{
	    s BILL=val
	    s flag="N"
	    i $D(^DHCINVPRTZY(0,"AR",BILL))=0 d
	    .s flag="N"
	    e  d
	    .s prt="" f  s prt=$o(^DHCINVPRTZY(0,"AR",BILL,prt)) q:prt=""  d
	    ..s prtflag=$p(^DHCINVPRTZY(prt),"^",8)
	    ..i prtflag'="A" s flag="Y"
	    q flag
}

ClassMethod savetoinvprt(invno, usr, bill, cat, rid, invflag, InvprtID, AccID As %Library.String = "", HospitalID)
{
 ;记录发票打印
	n (invno,usr,bill,cat,rid,invflag,InvprtID,AccID,HospitalID)
	i InvprtID'="" d
	.s paadm=$p($g(^DHCPEINVPRT(InvprtID)),"^",2)
	.s LocID=$P($G(^PAADM(paadm)),"^",4)

	s finalflag=..GetFinalFlag(LocID)
	s err=##class(web.UDHCJFPB).SELECT(bill)
	s invdat=PLIST(20),invtim=PLIST(21),adm=PLIST(2),amount=PLIST(9)
	;
	;&sql(select pb_updatedate,pb_updatetime,pb_adm_dr,pb_totalamount into :invdat,:invtim,:adm,:amount from dhc_patientbill where pb_rowid=:bill)
	;&sql(select paadm_type into:type from paadm where paadm_rowid=:adm)
	
    Set MEDDATA=##Class(web.DHCPE.DHCPEBillCharge).getMEDDATA()
    Set CurrentNS=$ZNSPACE
    ZN MEDDATA
	s err=$$select^MVBPAADM(adm),type=PLIST(9),visst=$g(PLIST(25))
	ZN CurrentNS
	;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\yyx
	s deposit=0
	s arrcp=""
	s rcpt=""
	i cat="S"  s tmpbill=$p(^DHCPB(bill),"^",18)
	e  s tmpbill=bill
	f  s rcpt=$o(^ARRCP("ARPBL",tmpbill,rcpt)) q:rcpt=""  d 
	.s childsub=""
	.f  s childsub=$o(^ARRCP("ARPBL",tmpbill,rcpt,childsub))  q:childsub=""  d
	..s depositlx=$p(^ARRCP(rcpt,"RAL",childsub),"^",9)
	..i depositlx'="" s deposit=deposit+$p(^ARRCP(rcpt,"RAL",childsub),"^",2)
	..e  s arrcp=rcpt
	;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\yyx
	;
	s sign=cat
	
	s amount=$p(amount,$c(1)),invdat=+$h,invtim=$p($h,",",2),type=$P(type,$c(1),2)
	k PLIST
	s PLIST(2)=invno,PLIST(3)=adm,PLIST(4)=bill,PLIST(5)=arrcp,PLIST(12)=invdat,PLIST(13)=invtim
	s PLIST(8)=amount,PLIST(11)=usr,PLIST(9)=sign,PLIST(7)=deposit
	
	i InvprtID'="" d
	.s ReportID=$p(^DHCPEINVPRT(InvprtID),"^",13)
	.i ReportID="" d
	..s OldUsr=$p(^DHCPEINVPRT(InvprtID),"^",10)
	..i OldUsr=usr d
	...s PLIST(9)="A"
	
	//i sign="S" s PLIST(8)=-amount,PLIST(10)=$P(..getiniinv(bill),"^",1),PLIST(7)=-$P(..getiniinv(bill),"^",2)  ;取押金
	i sign="S" s PLIST(8)=-amount,PLIST(10)=InvprtID,PLIST(7)=0-(+$p(^DHCPEINVPRT(InvprtID),"^",6))  ;取押金
	i sign="S" s PLIST(4)=$p(^DHCPB(bill),"^",18),bill=PLIST(4)
	i sign="S" s PLIST(22)=-$P(^DHCPEINVPRT(InvprtID),"^",21)  //退费同时退四舍五入的
	s PLIST(25)="N",PLIST(26)="N"
	s PLIST(27)=HospitalID
	//s $ZT="ERROR^SSERR" s ttt=..tb()
	s PLIST(23)=AccID   //add by zhouli	
	s err=0
	&sql(INSERT INTO DHC_PE_INVPRT VALUES :PLIST())
	
	s PRTRowid=$p(%ROWID,$c(1))
	s rid=$p(rid,"^",1)
	s err=err+SQLCODE
	i invflag="Y" d
	.i invno'="" d
	..s err=##CLASS(web.UDHCJFINV).SELECT(rid),endinv=+PLIST(3),title=PLIST(17)
	..;&sql(select inv_endinv into:endinv from DHC_INVOICE where inv_rowid=:rid)
	..i title'="" d
	...s tmpinvno=$P(invno,title,2)
	..e  d
	...s tmpinvno=invno
	..//s tmpinvno=+invno
	..i +tmpinvno=+endinv d      ;如果是最后一张领取的发票??标记为已用完
	...;b
	...s err=..invrefund(rid,tmpinvno,usr,LocID)
	...s err=err+SQLCODE
	...;&sql(update DHC_INVOICE set inv_lastnum=:invno,inv_finalflag='N' where inv_rowid=:rid)
	..i +tmpinvno<endinv d
	...i finalflag="Y" s lastnum=..incre(tmpinvno)
	...i finalflag="N" s lastnum=tmpinvno
	...i finalflag="" s lastnum=..incre(tmpinvno)
	...&sql(update DHC_INVOICE set inv_lastnum=:lastnum where inv_rowid=:rid)   
	...s err=err+SQLCODE
	
	;添加发票号到AR_RECEIPTS中
	;k PLIST 
	s arrcp=""   ;recnum->ar_receipts.arrcp_number
	s arrcp=$o(^ARRCP("ARPBL",+bill,""),-1) 
	i (arrcp'="")&(invno'="") d
	.;s err=$$select^MVBARREC(arrcp)
	.;s PLIST(4)=invno
	.;s err=$$update^MVBARREC(arrcp)
	.&sql(update AR_Receipts set ARRCP_Number=:invno where ARRCP_ROWID=:arrcp)
	.s err=err+SQLCODE
	//s ttt=..tc()
	s rtn=err_"^"_PRTRowid
	q rtn
}

ClassMethod invrefund(rid As %String, invno As %String, usr As %String, LocID As %String) As %String
{
	       
	       s finalflag=..GetFinalFlag(LocID)
	   
	       i finalflag="Y" s err=..invrefund1(rid,invno,usr)
	       e  s err=..invrefund2(rid,invno,usr)
	       q err
}

ClassMethod invrefund1(rid As %String, invno As %String, usr As %String) As %String
{
  
       &sql(update DHC_INVOICE set inv_lastnum=:invno,inv_finalflag='N' where inv_rowid=:rid)
       q:SQLCODE'=0 SQLCODE
       s YFlag=""
       s NID=""
       s ID=rid
       f  s ID=$O(^DHCINVOICE(0,"USER",usr,ID)) q:ID=""  d
       .s Type=$P(^DHCINVOICE(ID),"^",8)
       .q:Type'="O"
       .s Flag=$P(^DHCINVOICE(ID),"^",7)
       .q:Flag="N"
       .s:Flag="Y" YFlag=1
       .q:Flag="Y"
       .s:NID="" NID=ID
       q:NID="" SQLCODE
       q:YFlag=1 SQLCODE
       &sql(update DHC_INVOICE set inv_finalflag='Y' where inv_rowid=:NID)
       q SQLCODE
       
       
       
       //&sql(select count(*) into :num from DHC_INVOICE where (inv_finalflag='' or inv_finalflag is null) and inv_rowid<>'0' and inv_usr=:usr and inv_type='O')
      // q:SQLCODE'=0 0
      // i num'=0  d
      // .&sql(select min(inv_rowid) into :rowid1  from DHC_INVOICE where (inv_finalflag='' or inv_finalflag is null) and inv_rowid<>'0' and inv_usr=:usr and inv_type='O')
      // .&sql(update DHC_INVOICE set inv_finalflag='Y' where inv_rowid=:rowid1)
       q SQLCODE
}

ClassMethod invrefund2(rid As %String, invno As %String, usr As %String) As %String
{
	       //
	       
	       &sql(update DHC_INVOICE set inv_lastnum=:invno,inv_finalflag='Y' where inv_rowid=:rid)
	       q SQLCODE
}

/// ////////////////////////////////////////////////
ClassMethod depositlistClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = depositlistExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod depositlistExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
   // s Adm=%request.Data("Adm",1)
    if Adm="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	If $g(ind)="" Set ind=1
	s n=0,sum=0
	s arrcp="",dep=0,n=0 f  s arrcp=$o(^ARRCP("Adm_DR",+Adm,arrcp))  q:arrcp=""  d
	.s arral=""  f  s arral=$o(^ARRCP("Adm_DR",Adm,arrcp,arral))  q:arral=""   d
	..s s=^ARRCP(arrcp,"RAL",arral),arpbl=$p(s,"^",18),flag=$p(s,"^",5),amt=+$p(s,"^",2),type=$p(s,"^",9)
	..;
	..q:amt=0
	..;
	..i (flag="")&(arpbl="") d 
	...;
	...s dat=$zd($p(^ARRCP(arrcp),"^",3),3)
	...s rcptrowid=$o(^DHCSFPRINTDETAIL(0,"RcptDR",arrcp,""))
	...s rcptno=$p(^DHCSFPRINTDETAIL(rcptrowid),"^",1)
	...s sum=sum+amt
	...s str=$j(amt,3,2)_"^"_rcptno_"^"_dat_"^"_arrcp_"||"_arral
	...d OutputRow5
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	set Data=$lb(str)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod depositlistFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = depositlistExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query depositlist(Adm As %String) As %Query(ROWSPEC = "str:%String")
{
}

ClassMethod listdep(adm)
{
	k ^TMP("ZYJF","listdep",$j)
	s n=0,sum=0
	s arrcp="",dep=0,n=0 f  s arrcp=$o(^ARRCP("Adm_DR",+adm,arrcp))  q:arrcp=""  d
	.s arral=""  f  s arral=$o(^ARRCP("Adm_DR",adm,arrcp,arral))  q:arral=""   d
	..s s=^ARRCP(arrcp,"RAL",arral),arpbl=$p(s,"^",18),flag=$p(s,"^",5),amt=+$p(s,"^",2),type=$p(s,"^",9)
	..;
	..q:amt=0
	..;
	..i (flag="")&(arpbl="") d 
	...;
	...s dat=$zd($p(^ARRCP(arrcp),"^",3),3)
	...s rcptrowid=$o(^DHCSFPRINTDETAIL(0,"RcptDR",arrcp,""))
	...s rcptno=$p(^DHCSFPRINTDETAIL(rcptrowid),"^",1)
	...s sum=sum+amt
	...s n=n+1,^TMP("ZYJF","listdep",$j,n)=$j(amt,3,2)_"^"_rcptno_"^"_dat_"^"_arrcp_"||"_arral
	q n_"^"_$j_"^"_$j(sum,3,2)
}

ClassMethod list(i, jj, j)
{
	s tmpstr=^TMP("ZYJF","listdep",jj,i)
	;s j=$o(^TMP("ZYJF","listdep",jj,""),-1)
	i i=j  k ^TMP("ZYJF","listdep",jj)
	q tmpstr
}

ClassMethod GetFinalFlag(LocID As %String = "")
{
	new (LocID,%session)
	i $D(%session) s LocID=%session.Get("LOGON.CTLOCID")
	//s finalflag=$g(^DHCPESetting("DHCPE","InvFlag"))
	s finalflag=$g(^DHCPESetting("DHCPE","InvFlag",LocID))

	//if finalflag=""  d
	//.s finalflag="N"
	q finalflag
}

// d ##class(web.DHCPE.DHCPEPAY).incre()

ClassMethod incre(invno) As %String
{
 ;发票号自动累加1
	s lng=$l(invno)
	s ret=invno+1
	s l=$l(ret)
	f i=lng:(-1):(l+1) d
	.s ret="0"_""_ret
	q ret
}

ClassMethod RMBDXXZH(itmjs As %Library.String = "", itmjsex As %Library.String = "", numstr As %Library.String = "", Type As %String = 1, LocID As %String = "")
{
	i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
	//s HospitalCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
	s HospitalCode=$g(^DHCPESetting("DHCPE","HospitalCode",LocID))

	i ((HospitalCode="ZHRMYY"))&&(Type=2)
	{
		q ##class(web.UDHCOPINVPrtIF).RMBConvertFill(numstr,8)
	}
	elseif ((HospitalCode="ZSSY"))&&(Type=2)
	{
		s str=##class(web.UDHCOPINVPrtIF).RMBConvertFill(numstr,8)
		q ##class(web.DHCPE.Public.Setting).Replace(str,"^","   ")
	}
    ;RMB DAXIAOXIE CONVERSION,
	k P1
	s numstr=$tr(numstr," ","")
	s i=0,lendec=0,lenint=0
	S a="",b="",c="",d="",bbak="",bs=""
	s numstr=+numstr
	i $p(numstr,".",1)=""  s numstr="0"_numstr
	s lenint=$l($p(numstr,".",1))
	s lendec=2
	i $p(numstr,".",2)="00" s lendec=0  
	s dxint(13)="",dxdec(2)="",sz(13)=""
	s dxstr="万|仟|佰|拾|亿|仟|佰|拾|万|仟|佰|拾|元"
	s szstr="零|壹|贰|叁|肆|伍|陆|柒|捌|玖"
	s lendxstr=$l(dxstr,"|")+1
	s lenszstr=$l(szstr,"|")+1
	f i=1:1:lendxstr d
	.s dxint(i)=$p(dxstr,"|",lendxstr-i)
	.s sz(i)=" "
	.i i<11  s sz(i)=$p(szstr,"|",i)  
	s dxdec(1)="角",dxdec(2)="分",dxstr=" "
	;**整数部分**
	f i=1:1:lenint d
	.s a=$e($e(numstr,1,lenint),i,i)
	.s b=sz(a+1)
	.s c=dxint(lenint-i+1)
	.s d=" "
	.i dxstr'=" "  s d=$e(dxstr,$l(dxstr)-1,($l(dxstr)-1)+2-1)  
	.i a="0"  s b="",bs="零"
	.i (b="零")&((d="零")!(b=bbak)!(c="元")!(c="万")!(c="亿"))  s b=""
	.i (a="0")&(c'="元")&(c'="万")&(c'="亿") s c=""
	.i ((c="元")!(c="万")!(c="亿"))&(d="零")&(a="0")  d 
	..s dxstr=$e(dxstr,1,1+($l(dxstr)-2)-1)
	.s d=$e(dxstr,$l(dxstr)-1,($l(dxstr)-1)+2-1)
	.i (c="元")&(d="万")&(c="万")&(d="亿")  s c=""
	.i (bs="零")&(a'=0)&(a'="") s b=bs_b,bs=""
	.s dxstr=dxstr_b_c,bbak=b
	;
	;**小数部分**
	i ($p(numstr,".",2)=0)!(lendec=0)!($p(numstr,".",2)="")  s dxstr=dxstr_"整" 
	i $p(numstr,".",2)>0  d
	.f i=1:1:lendec d
	..s a=$e($p(numstr,".",2),i,i)
	..s b=sz(a+1)
	..i (a="0")&(dxdec(i)="分")  s b=""  
	..i a="0"  s dxstr=dxstr_b
	..i a'="0"  s dxstr=dxstr_b_dxdec(i)   
	i numstr<1 s dxstr=$e(dxstr,3,$l(dxstr))
	i numstr<0.1 s dxstr=$e(dxstr,3,$l(dxstr))
	i numstr=0 s dxstr=""
	s P1=dxstr
	s retcode=dxstr
	q retcode
}

ClassMethod GetBalance(CardAccDR, payedFee)
{
      
	s returnFee="",cardAmount=""
	q:CardAccDR="" ""
	s cardAmount=+$p($G(^DHCACD("AccM",CardAccDR)),"^",8)
	i ((cardAmount[".")&&(cardAmount'="")) d
	.i $p(cardAmount,".",1)="" s cardAmount=0_cardAmount

	i payedFee>cardAmount{
		s returnFee=payedFee-cardAmount
		q cardAmount_"^"_",不足金额为"_returnFee
	}
	i payedFee<=cardAmount{
		q cardAmount
	}
}

ClassMethod CheckAccount(CardAccDR, CurrRegNo)
{
	s Flag=1
	s CardRegNo=""
	s PAPMID=$p($G(^DHCACD("AccM",CardAccDR)),"^",2)
 	i PAPMID'=""  d
 	.s CardRegNo=$P(^PAPER(PAPMID,"PAT",1),"^",1)
 	i CurrRegNo=CardRegNo  s Flag="0"
	q Flag
}

ClassMethod GetCurRegNo(Type, GIADM)
{
	/*
	s RegNo=""
	q:GIADM="" RegNo
	q:Type="" RegNo
	i Type="G"
	{
		s PAADM=$p($G(^DHCPEGADM(GIADM)),"^",3)
	}
	else
	{
		s PAADM=$p($G(^DHCPEIADM(GIADM)),"^",1)
	}
	s PatID=$P(^PAADM(PAADM),"^",1)
	s RegNo=$P(^PAPER(PatID,"PAT",1),"^",1)
	q RegNo
	*/
	s strRegNo=""
	q:GIADM="" strRegNo
	q:Type="" strRegNo
	s i=1
	while(i<=$l(GIADM,",")){
		s GIADMi=$p(GIADM,",",i)
		i Type="G"
		{
			s PAADM=$p($G(^DHCPEGADM(GIADMi)),"^",3)
		}
		else
		{
			s PAADM=$p($G(^DHCPEIADM(GIADMi)),"^",1)
		}
		s PatID=$P(^PAADM(PAADM),"^",1)
		s RegNo=$P(^PAPER(PatID,"PAT",1),"^",1)
		i strRegNo=""{
			s strRegNo=RegNo
		}else{
			s strRegNo=strRegNo_"^"_RegNo	
		}
		s i=i+1 
	}
	q strRegNo
}

ClassMethod getCardAmount(cardId)
{
	q:cardId="" ""
	s cardAmount=$p($G(^DHCACD("AccM",cardId)),"^",8)
	q cardAmount
}

ClassMethod GetDefaultTypeStr(LocID As %String = "")
{
   	s Data=""
    i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    //s CardType=$G(^DHCPESetting("DHCPE","CardType"))
    s CardType=$G(^DHCPESetting("DHCPE","CardType",LocID))

	q:CardType="" Data
	s Data=$g(^DHCCARDTYPEDef(CardType))
	q Data
}

ClassMethod GetCodeByDR(MODEDR)
{
	q $p(^CT("CTPM",MODEDR),"^",1)
}

// d ##class(web.DHCPE.DHCPEPAY).OutAdmReason(%request.Get("GIADM"),%request.Get("ADMType"))

ClassMethod OutAdmReason(GIADM, GIType, ContrlWidth As %String = "", InvID As %String = "")
{
	q:GIType="G"
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='AdmReason' id='AdmReason' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>  </option>",!
	s DefaultReason="",PAADM=""
	i InvID'="" d
	.s PAADM=$P(^DHCPEINVPRT(InvID),"^",2)
	e  i GIADM'=""  d
	.s PAADM=$P(^DHCPEIADM(GIADM),"^",1)
	i PAADM'="" d
	.s DefaultReason=$P(^PAADM(PAADM,1),"^",7)
	
	s ID=0
	f  s ID=$O(^PAC("ADMREA",ID)) q:ID=""  d
	.s ReasonType=$P(^PAC("ADMREA",ID),"^",9)
	.q:ReasonType=""
	.s StartDate=$P(^PAC("ADMREA",ID),"^",3)
	.q:StartDate>+$H
	.s EndDate=$P(^PAC("ADMREA",ID),"^",4)
	.q:(EndDate'="")&&(EndDate<+$H)
	.s Default=""
	.s:ID=DefaultReason Default="selected"
	.s Desc=$P(^PAC("ADMREA",ID),"^",2)
	.q:$g(^DHCPESetting("DHCPE","AdmReason",ID))'="Y"
	.w "<option value='"_ID_"' "_Default_">"_Desc_"</option>",!
	w "</select>",!
	Quit $$$OK
}

// d ##class(web.DHCPE.DHCPEPAY).OutAdmReasonForRefund(102)

ClassMethod OutAdmReasonForRefund(InvID, ContrlWidth As %String = "")
{
	
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='AdmReason' id='AdmReason' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>  </option>",!
	s DefaultReason=""
	s:InvID'="" DefaultReason=$P(^DHCPEOEITEM(InvID),"^",6)
	s ID=0
	f  s ID=$O(^PAC("ADMREA",ID)) q:ID=""  d
	.s ReasonType=$P(^PAC("ADMREA",ID),"^",9)
	.q:ReasonType=""
	.s StartDate=$P(^PAC("ADMREA",ID),"^",3)
	.q:StartDate>+$H
	.s EndDate=$P(^PAC("ADMREA",ID),"^",4)
	.q:(EndDate'="")&&(EndDate<+$H)
	.s Default=""
	.s:ID=DefaultReason Default="selected"
	.s Desc=$P(^PAC("ADMREA",ID),"^",2)
	.w "<option value='"_ID_"' "_Default_">"_Desc_"</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutPayMode(ElementName, ContrlWidth As %String = "")
{
	
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='"_ElementName_"' id='"_ElementName_"' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>  </option>",!
	s CTPMRowId=0
   	f  s CTPMRowId=$o(^CT("CTPM",CTPMRowId))  q:CTPMRowId=""  d
   	.s CTPMDesc=$p(^CT("CTPM",CTPMRowId),"^",2)
   	.s CTPMCode=$p(^CT("CTPM",CTPMRowId),"^",1)
   	.;q:$g(^DHCPESetting("DHCPE","CashierMode",CTPMRowId))'="Y"
    .q:$g(^DHCPESetting("DHCPE","RefundMode",CTPMRowId))'="Y"
	.w "<option value='"_CTPMRowId_"'>"_CTPMDesc_"</option>",!
	w "</select>",!
	Quit $$$OK
}

}
