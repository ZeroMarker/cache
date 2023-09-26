Import SQLUser

/// Class Name:web.AccCredManage
/// Description:临时凭证管理
/// Creator:ZHL
/// CreatDate:2010-07-01
Class web.AccCredManage Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod CredInfo(CredCode) As %String
{
   if CredCode=""   s CredCode="DHCOPB001"
   s cred=$o(^DHCACCCRE(0,"Code",CredCode,""))
   q:cred="" "No CredMode"
  
   s PrePrtFlag=$p(^DHCACCCRE(cred),"^",10)
   s CludAbort=$p(^DHCACCCRE(cred),"^",11)
   s ^TMP("Credinfo",CredCode,$j,"info")=PrePrtFlag_"^"_CludAbort
         
   s sub="0"
   f  s sub=$o(^DHCACCCRE(cred,"S",sub))  q:sub=""    d
   .s admreastr=$p(^DHCACCCRE(cred,"S",sub),"^",5)
   .s paymstr=$p(^DHCACCCRE(cred,"S",sub),"^",6)
   .s catstr=$p(^DHCACCCRE(cred,"S",sub),"^",7)
   .s locstr=$p(^DHCACCCRE(cred,"S",sub),"^",8)
   .s AccItem=$p(^DHCACCCRE(cred,"S",sub),"^",4)
   .s itmdes=$p(^DHCACCCRE(cred,"S",sub),"^",1)
   .s DataSource=$p(^DHCACCCRE(cred,"S",sub),"^",2)
   .s:DataSource="" DataSource="ALL"
   .s Type=$p(^DHCACCCRE(cred,"S",sub),"^",3)
   .s:Type="" Type="ALL" 
   .s JD=$p(^DHCACCCRE(cred,"S",sub),"^",9)
   .s JFDetails=$p(^DHCACCCRE(cred,"S",sub),"^",14)
   .s DFDetails=$p(^DHCACCCRE(cred,"S",sub),"^",15)
   .s ^TMP("Credinfo",CredCode,$j,"info",Type,DataSource)=""
   .s:admreastr'="" ^TMP("Credinfo",CredCode,$j,"info",Type,DataSource,"admres")="Y" 
   .s:paymstr'="" ^TMP("Credinfo",CredCode,$j,"info",Type,DataSource,"paym")="Y"
   .s:catstr'="" ^TMP("Credinfo",CredCode,$j,"info",Type,DataSource,"cat")="Y"
   .s:locstr'="" ^TMP("Credinfo",CredCode,$j,"info",Type,DataSource,"loc")="Y"
   .s ind=$o(^TMP("Credinfo",CredCode,$j,"item",""),-1)
   .s ^TMP("Credinfo",CredCode,$j,"item",ind+1)=itmdes_"^"_DataSource_"^"_Type_"^"_JD_"^"_admreastr_"^"_paymstr_"^"_catstr_"^"_locstr_"^"_AccItem_"^"_JFDetails_"^"_DFDetails
   
   q cred
}

ClassMethod GetCredData(CredCode, StDate, EndDate, User) As %String
{
	  s Flag=$g(^TMP("Credinfo",CredCode,$j,"info"))
	  s PrePrtFlag=$p(Flag,"^",1)
	  s CludAbort=$p(Flag,"^",2)
	  
	  s Type=""
	  f  s Type=$o(^TMP("Credinfo",CredCode,$j,"info",Type))  q:Type=""  d
	  .i Type'="O"    d
	  ..f Date=StDate:1:EndDate    d
	  ...s JKDr=""
	  ...f  s JKDr=$o(^DHCJFUSERJK(0,"date",Date,JKDr))   q:JKDr=""    d
	  ....s AccFlag=$g(^DHCJFUSERJK(JKDr,"Acct",CredCode))
	  ....q:+AccFlag'=0
	  ....s JKUser=$p($g(^DHCJFUSERJK(JKDr)),"^",5)
	  ....q:(User'="")&(User'=JKUser)
	  ....s InvFlag=""
	  ....f  s InvFlag=$o(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag))   q:InvFlag=""    d
	  .....i InvFlag'="FP"    d
	  ......s (reasflag,locflag,catflag,paymflag)=0
	  ......i $g(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag,"admres"))="Y"   s reasflag=1
      ......i $g(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag,"loc"))="Y"   s locflag=1
	  ......i $g(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag,"paym"))="Y"   s paymflag=1
	  ......s dept=""
	  ......f  s dept=$o(^DHCSFPRINTDETAIL(0,"JKDR",JKDr,dept))   q:dept=""    d
      .......s status=$p(^DHCSFPRINTDETAIL(dept),"^",8)
      .......q:status="2"
      .......i (status=1)||(status=4)  s status="N"
      .......i status=3  s status="S"
      .......s amt=$p(^DHCSFPRINTDETAIL(dept),"^",6)
      .......s ^TMP("CredData",CredCode,$j,"InPatient","Deposit")=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit"))+amt
      .......s ^TMP("CredData",CredCode,$j,"InPatient","Deposit",status)=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit",status))+amt
      .......s adm=$p(^DHCSFPRINTDETAIL(dept),"^",4)
      .......s paymode=$p(^DHCSFPRINTDETAIL(dept),"^",9)
      .......s admreas=$p(^PAADM(adm,1),"^",7)
      .......s loc=$p(^PAADM(adm),"^",4)
      .......i reasflag=1   d
      ........s ^TMP("CredData",CredCode,$j,"InPatient","Deposit","admres",admreas)=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","admres",admreas))+amt
      ........s ^TMP("CredData",CredCode,$j,"InPatient","Deposit","admres",admreas,status)=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","admres",admreas,status))+amt
      ........i paym=1   d
      .........s ^TMP("CredData",CredCode,$j,"InPatient","Deposit","ReasPaym",admreas,paymode)=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","ReasPaym",admreas,paymode))+amt
      .........s ^TMP("CredData",CredCode,$j,"InPatient","Deposit","ReasPaym",admreas,paymode,status)=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","ReasPaym",admreas,paymode,status))+amt
      .......i locflag=1   d
      ........s ^TMP("CredData",CredCode,$j,"InPatient","Deposit","Loc",loc)=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","Loc",loc))+amt
      ........s ^TMP("CredData",CredCode,$j,"InPatient","Deposit","Loc",loc,status)=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","Loc",loc,status))+amt
      ........i reasflag=1   d
      .........s ^TMP("CredData",CredCode,$j,"InPatient","Deposit","LocReas",loc,admreas)=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","LocReas",loc,admreas))+amt
      .........s ^TMP("CredData",CredCode,$j,"InPatient","Deposit","LocReas",loc,admreas,status)=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","LocReas",loc,admreas,status))+amt
      .......i paymflag=1   d
      ........s ^TMP("CredData",CredCode,$j,"InPatient","Deposit","Paym",paymode)=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","Paym",paymode))+amt
      ........s ^TMP("CredData",CredCode,$j,"InPatient","Deposit","Paym",paymode,status)=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","Paym",paymode,status))+amt
	  .....i InvFlag'="YJ"    d
	  ......s (reasflag,locflag,catflag,paymflag)=0
	  ......i $g(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag,"admres"))="Y"   s reasflag=1
      ......i $g(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag,"loc"))="Y"   s locflag=1
	  ......i $g(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag,"paym"))="Y"   s paymflag=1
	  ......i $g(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag,"cat"))="Y"   s catflag=1
	  ......s InvDr=""
	  ......f  s InvDr=$o(^DHCINVPRTZY(0,"JK",JKDr,InvDr))   q:InvDr=""     d
	  .......s status=$p(^DHCINVPRTZY(InvDr),"^",8)
	  .......q:status["A"
	  .......s initinv=$p(^DHCINVPRTZY(InvDr),"^",19)
	  .......i +initinv'=0  s status="N"
	  .......;s amt=$p(^DHCINVPRTZY(InvDr),"^",6)
	  .......s amt=$p(^DHCINVPRTZY(InvDr),"^",6)
	  .......s adm=$p(^DHCINVPRTZY(InvDr),"^",4)
	  .......s ^TMP("CredData",CredCode,$j,"InPatient","InvFee")=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee"))+amt	
	  .......s ^TMP("CredData",CredCode,$j,"InPatient","InvFee",status)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee",status))+amt	
	  .......s deptamt=$p(^DHCINVPRTZY(InvDr),"^",22)
	  .......s ^TMP("CredData",CredCode,$j,"InPatient","Deposit","InvStr")=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","InvStr"))+deptamt
	  .......s admreas=$p(^PAADM(adm,1),"^",7) 
	  .......s loc=$p(^PAADM(adm),"^",4)
	  .......i reasflag=1  d
	  ........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","admres",admreas)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","admres",admreas))+amt	
	  ........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","admres",admreas,status)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","admres",admreas,status))+amt	 
	  ........s ^TMP("CredData",CredCode,$j,"InPatient","Deposit","admres",admreas,"InvStr")=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","admres",admreas,"InvStr"))+deptamt
	  .......i locflag=1    d
	  ........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","Loc",loc)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","Loc",loc))+amt	
	  ........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","Loc",loc,status)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","Loc",loc,status))+amt	 
      ........s ^TMP("CredData",CredCode,$j,"InPatient","Deposit","Loc",loc,"InvStr")=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","Loc",loc,"InvStr"))+deptamt
      ........i reasflag=1   d
      .........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","LocReas",loc,admreas)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","LocReas",loc,admreas))+amt	
	  .........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","LocReas",loc,admreas,status)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","LocReas",loc,admreas,status))+amt	 
      .........s ^TMP("CredData",CredCode,$j,"InPatient","Deposit","LocReas",loc,admreas,"InvStr")=$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","LocReas",loc,admreas,"InvStr"))+deptamt
      .......i paymflag=1    d
      ........s rcpt=$p(^DHCINVPRTZY(InvDr),"^",17)
      ........i rcpt=""   d
      .........s invpb=$p(^DHCINVPRTZY(InvDr),"^",5)
      .........s rcpt=$o(^ARRCP("ARPBL",invpb,""),-1)
      ........s paysub=""
      ........f  s paysub=$o(^ARRCP(+rcpt,"PAYM",paysub))   q:paysub=""     d
      .........s payamt=$p(^ARRCP(+rcpt,"PAYM",paysub),"^",3)
      .........s paymode=$p(^ARRCP(+rcpt,"PAYM",paysub),"^",1)
      .........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","Paym",paymode)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","Paym",paymode))+payamt	
	  .........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","Paym",paymode,status)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","Paym",paymode,status))+payamt
	  .........i reasflag=1    d
	  ..........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","ReasPaym",admreas,paymode)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","ReasPaym",admreas,paymode))+payamt	
	  ..........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","ReasPaym",admreas,paymode,status)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","ReasPaym",admreas,paymode,status))+payamt
	  .......i catflag=1    d
	  ........s Invpb=$p(^DHCINVPRTZY(InvDr),"^",5)
	  ........s pbo="0"
	  ........f  s pbo=$o(^DHCPB(+Invpb,"O",pbo))   q:pbo=""   d
	  .........s pbd="0"
	  .........f  s pbd=$o(^DHCPB(+Invpb,"O",pbo,"D",pbd))   q:pbd=""    d
	  ..........s cati=$p(^DHCPB(+Invpb,"O",pbo,"D",pbd),"^",3)
	  ..........s Catfee=$p(^DHCPB(+Invpb,"O",pbo,"D",pbd),"^",10)
	  ..........s Catsub=$p(^DHCTARI(cati),"^",14)
	  ..........s Cat=$p(^DHCTarC("IC",Catsub),"^",3)
	  ..........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","Cat",Cat)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","Cat",Cat))+Catfee
	  ..........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","Cat",Cat,status)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","Cat",Cat,status))+Catfee
	  ..........i reasflag=1  d
	  ...........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","CatReas",Cat,admreas)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","CatReas",Cat,admreas))+Catfee
	  ...........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","CatReas",Cat,admreas,status)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","CatReas",Cat,admreas,status))+Catfee
      ..........i locflag=1  d
	  ...........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","CatLoc",Cat,loc)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","CatReas",Cat,loc))+Catfee
	  ...........s ^TMP("CredData",CredCode,$j,"InPatient","InvFee","CatLoc",Cat,loc,status)=$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","CatReas",Cat,loc,status))+Catfee
	  .i Type'="I"    d 
	  ..s InvFlag=""
	  ..f  s InvFlag=$o(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag))   q:InvFlag=""    d
      ...i InvFlag'="YJ"   d
      ....s (reasflag,locflag,catflag,paymflag)=0
	  ....i $g(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag,"admres"))="Y"   s reasflag=1
      ....i $g(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag,"loc"))="Y"   s locflag=1
	  ....i $g(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag,"paym"))="Y"   s paymflag=1
	  ....i $g(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag,"cat"))="Y"   s catflag=1
      ....f Date=StDate:1:EndDate   d
      .....s RepDr="0"
      .....f  s RepDr=$o(^DHCOPInsFootI(0,"Date",Date,RepDr))   q:RepDr=""   d
      ......s AccFlag=$g(^DHCOPInsFoot(RepDr,"Acct",CredCode))
      ......q:+AccFlag'=0
      ......s PUsr=$p(^DHCOPInsFoot(RepDr),"^",8) 
      ......q:(User'="")&&(User'=PUsr)
      ......s Inv="0"
      ......f  s Inv=$o(^DHCINVPRT(0,"Report",RepDr,Inv))  q:Inv=""   d
      .......s status=$p(^DHCINVPRT(Inv),"^",8)
      .......q:status["A"
      .......s initinv=$p(^DHCINVPRT(Inv),"^",13)
      .......i +initinv'=0   s status="N"
      .......;s amt=$p(^DHCINVPRT(Inv),"^",1)
      .......s amt=$p(^DHCINVPRT(Inv),"^",16)
      .......s ^TMP("CredData",CredCode,$j,"OutPatient","InvFee")=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee"))+amt
      .......s ^TMP("CredData",CredCode,$j,"OutPatient","InvFee",status)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee",status))+amt
      .......i catflag=1    d 
      ........i $d(^DHCINVPRT(Inv,"C"))    d
      .........s Sub="0"
      .........f  s Sub=$o(^DHCINVPRT(Inv,"C",Sub))  q:Sub=""   d
      ..........s Cat=$p(^DHCINVPRT(Inv,"C",Sub),"^",2)
      ..........s CatFee=$p(^DHCINVPRT(Inv,"C",Sub),"^",1)
      ..........s InvBill=$p(^DHCINVPRT(Inv,"C",Sub),"^",4)
      ..........s ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Cat",Cat)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Cat",Cat))+CatFee
	  ..........s ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Cat",Cat,status)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Cat",Cat,status))+CatFee
	  ..........i (locflag=1)||(reasflag=1)  d    d 
	  ...........q:(+InvBill=0)||('$d(^DHCPB(InvBill)))
      ...........s Adm=$p(^DHCPB(InvBill),"^",1)
      ...........s AdmLoc=$p(^PAADM(Adm),"^",4)
      ...........s Admreas=$p(^PAADM(Adm,1),"^",7)
      ...........s:locflag=1 ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatLoc",Cat,AdmLoc)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatReas",Cat,AdmLoc))+CatFee
	  ...........s:locflag=1 ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatLoc",Cat,AdmLoc,status)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatReas",Cat,AdmLoc,status))+CatFee
	  ...........s:reasflag=1 ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatReas",Cat,Admreas)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatReas",Cat,Admreas))+CatFee
	  ...........s:reasflag=1 ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatReas",Cat,Admreas,status)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatReas",Cat,Admreas,status))+CatFee
      ........e     d
      .........s cons="0"
      .........f  s cons=$o(^DHCBCI(0,"INV",Inv,cons))   q:cons=""    d
      ..........s InvBill=$p(^DHCBCI(cons),"^",2)
      ..........q:(InvBill="")||('$d(^DHCPB(InvBill)))
      ..........s invpbo="0"
      ..........f  s invpbo=$o(^DHCPB(InvBill,"O",invpbo))  q:invpbo=""    d
      ...........s invpbd="0"
      ...........f  s invpbd=$o(^DHCPB(InvBill,"O",invpbo,"D",invpbd))   q:invpbd=""   d
      ............s itm=$p(^DHCPB(InvBill,"O",invpbo,"D",invpbd),"^",3)
      ............s ocsub=$p(^DHCTARI(itm),"^",15)
      ............s Cat=$p(^DHCTarC("OC",ocsub),"^",3)
      ............s CatFee=$p(^DHCPB(InvBill,"O",invpbo,"D",invpbd),"^",10)
      ............s ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Cat",Cat)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Cat",Cat))+CatFee
	  ............s ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Cat",Cat,status)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Cat",Cat,status))+CatFee
	  ............i (locflag=1)||(reasflag=1)  d    d 
	  .............q:(+InvBill=0)||('$d(^DHCPB(InvBill)))
      .............s Adm=$p(^DHCPB(InvBill),"^",1)
      .............s AdmLoc=$p(^PAADM(Adm),"^",4)
      .............s Admreas=$p(^PAADM(Adm,1),"^",7)
      .............s:locflag=1 ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatLoc",Cat,AdmLoc)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatReas",Cat,AdmLoc))+CatFee
	  .............s:locflag=1 ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatLoc",Cat,AdmLoc,status)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatReas",Cat,AdmLoc,status))+CatFee
	  .............s:reasflag=1 ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatReas",Cat,Admreas)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatReas",Cat,Admreas))+CatFee
	  .............s:reasflag=1 ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatReas",Cat,Admreas,status)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatReas",Cat,Admreas,status))+CatFee
      .......i paymflag=1    d
	  ........s PaySub="0"
	  ........f  s PaySub=$o(^DHCINVPRT(Inv,"P",PaySub))   q:PaySub=""   d
	  .........s paym=$p(^DHCINVPRT(Inv,"P",PaySub),"^",1)
	  .........s payamt=$p(^DHCINVPRT(Inv,"P",PaySub),"^",3)
	  .........s ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Paym",paym)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Paym",paym))+payamt	
	  .........s ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Paym",paym,status)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Paym",paym,status))+payamt
	  .........i reasflag=1   d
	  ..........i Adm=""   d
	  ...........s Cons=$o(^DHCBCI(0,"INV",Inv,""))
	  ...........s Adm=$p(^DHCBCI(Cons),"^",3)
	  ..........q:Adm=""
	  ..........s Admreas=$p(^PAADM(Adm,1),"^",7)
	  ..........s ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","ReasPaym",Admreas,paym)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","ReasPaym",Admreas,paym))+payamt	
	  ..........s ^TMP("CredData",CredCode,$j,"OutPatient","InvFee","ReasPaym",Admreas,paym,status)=$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","ReasPaym",Admreas,paym,status))+payamt
      ...i InvFlag'="FP"   d
      ....s (reasflag,locflag,catflag,paymflag)=0
	  ....i $g(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag,"admres"))="Y"   s reasflag=1
      ....i $g(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag,"loc"))="Y"   s locflag=1
	  ....i $g(^TMP("Credinfo",CredCode,$j,"info",Type,InvFlag,"paym"))="Y"   s paymflag=1
      ....f Date=StDate:1:EndDate    d
      .....s FootDr="0"
      .....f  s FootDr=$o(^DHCACDi("AccPDFL",0,"FootDT",Date,FootDr))   q:FootDr=""    d
      ......s AccFlag=$g(^DHCACD("AccPDFL",FootDr,"Acct",CredCode))
      ......q:+AccFlag'=0
      ......s FUsr=$p(^DHCACD("AccPDFL",FootDr),"^",3)
      ......q:(User'="")&&(User'=FUsr)
      ......s AccM="0"
      ......f  s AccM=$o(^DHCACDi("AccM",0,"PDFootDR",FootDr,AccM))   q:AccM=""   d
      .......s AccPD="0"
      .......f  s AccPD=$o(^DHCACDi("AccM",0,"PDFootDR",FootDr,AccM,"AccPD",AccPD))   q:AccPD=""   d
      ........s Flag=$p(^DHCACD("AccM",AccM,"AccPD",AccPD),"^",1)
      ........s amt=$p(^DHCACD("AccM",AccM,"AccPD",AccPD),"^",2)
      ........s ^TMP("CredData",CredCode,$j,"OutPatient","Deposit")=$g(^TMP("CredData",CredCode,$j,"OutPatient","Deposit"))+amt
      ........s ^TMP("CredData",CredCode,$j,"OutPatient","Deposit",Flag)=$g(^TMP("CredData",CredCode,$j,"OutPatient","Deposit",Flag))+amt
      ........i paymflag=1   d
      .........s Paysub="0"
      .........f  s Paysub=$o(^DHCACD("AccM",AccM,"AccPD",AccPD,"P",Paysub))   q:Paysub=""    d
      ..........s PayM=$p(^DHCACD("AccM",AccM,"AccPD",AccPD,"P",Paysub),"^",1)
      ..........s Payamt=$p(^DHCACD("AccM",AccM,"AccPD",AccPD,"P",Paysub),"^",6)
      ..........s ^TMP("CredData",CredCode,$j,"OutPatient","Deposit","Paym",PayM)=$g(^TMP("CredData",CredCode,$j,"OutPatient","Deposit","Paym",PayM))+Payamt
      ..........s ^TMP("CredData",CredCode,$j,"OutPatient","Deposit","Paym",PayM,Flag)=$g(^TMP("CredData",CredCode,$j,"OutPatient","Deposit","Paym",PayM,Flag))+Payamt
}

ClassMethod CreatOCCat()
{
}

/// w ##class(web.AccCredManage).BuildCredA("DHCOPB002","2010-03-31","2010-03-31","","demo",1)
ClassMethod BuildCredA(CredCode, StDate, EndDate, User, Guser, yearPeriodId) As %String
{
  
 	s ^TMP("Test",1)=CredCode_"^"_StDate_"^"_EndDate_"^"_User_"^"_Guser_"^"_yearPeriodId
	s stD = $zdh(StDate,3)
	s endD = $zdh(EndDate,3)
	s bc =  ##class(web.AccCredManage).BuildCred(CredCode,stD,endD,User,Guser,yearPeriodId)
	q bc
}

/// w ##class(web.AccCredManage).BuildCred("DHCOPB002",61810,61810,"","demo",1)
ClassMethod BuildCred(CredCode, StDate, EndDate, User, Guser, yearPeriodId) As %String
{
		 s ^TMP("Test",2)=CredCode_"^"_StDate_"^"_EndDate_"^"_User_"^"_Guser_"^"_yearPeriodId
		 k ^TMP("Credinfo",CredCode,$j)
		 k ^TMP("CredData",CredCode,$j)
	     
	     s Cred= ..CredInfo(CredCode)
	     ;b   ;;1  CredInfo
	     q:+Cred<=0 "-11" 
	     
	     s modCode=$p(^DHCACCCRE(cred),"^",12)
	     q:modCode="" "-11"
	     d ..GetCredData(CredCode,StDate,EndDate,User)
	     ;b   ;;;2    GetCredData
	     
	     
	     q:('$d(^TMP("CredData",CredCode,$j))) "-100"  
         
         
         s objYearPeriod=##class(User.ACCTYearPeriod).%OpenId(yearPeriodId)
	     i objYearPeriod="" d ErrorRecord(-2,"取会计年度出错")
	     q:objYearPeriod="" ""
	     s objYear=objYearPeriod.AcctYearDr					;会计年度
	     s acctYearId=objYear.%Id()
	     i acctYearId="" d ErrorRecord(-3,"会计年度没有定义")
	     q:acctYearId="" ""

         
         s rtn=$$AddLock()
	     i rtn'=0  d UnLock
	     i rtn'=0 d ErrorRecord(-4,"加锁失败")
	     q:rtn'=0 ""						

         s vouchNo=..CreateVouchNo(modCode)
         ;b   ;;;  3   CreateVouchNo
	     i vouchNo=""  d UnLock
	     i vouchNo="" d ErrorRecord(-5,"生成凭证号失败")
	     q:vouchNo="" ""	
						
	     tstart
	     //s $ZT="Error"
	     ;保存凭证主记录
	     s listData=yearPeriodId_"^"_"01"_"^"_modCode_"^"_Cred_"^"_vouchNo_"^"_1_"^"_Guser
	     s vouchId=..SaveVouchRecord(listData)
	     b   ;;;4   SaveVouchRecord
	     i vouchId=""  d UnLock
	     i vouchId="" d ErrorRecord(-6,"保存凭证主记录失败")
	     
	     i vouchId=""  s rtn="-100" 
	     							

         
         s itm="",DFSum=0,JFSum=0
         f  s itm=$o(^TMP("Credinfo",CredCode,$j,"item",itm))   q:(itm="")||(rtn'=0)    d
         .s itmdes=$p(^TMP("Credinfo",CredCode,$j,"item",itm),"^",1)
         .s InvFalg=$p(^TMP("Credinfo",CredCode,$j,"item",itm),"^",2)
         .s patflag=$p(^TMP("Credinfo",CredCode,$j,"item",itm),"^",3)
         .s actflag=$p(^TMP("Credinfo",CredCode,$j,"item",itm),"^",4)
         .s insstr=$p(^TMP("Credinfo",CredCode,$j,"item",itm),"^",5)
         .s paystr=$p(^TMP("Credinfo",CredCode,$j,"item",itm),"^",6)
         .s catstr=$p(^TMP("Credinfo",CredCode,$j,"item",itm),"^",7)
         .s locstr=$p(^TMP("Credinfo",CredCode,$j,"item",itm),"^",8)
         .s actitem=$p(^TMP("Credinfo",CredCode,$j,"item",itm),"^",9)
         .s JFDetails=$p(^TMP("Credinfo",CredCode,$j,"item",itm),"^",10)
         .s DFDetails=$p(^TMP("Credinfo",CredCode,$j,"item",itm),"^",11)
         .s itmdf=0,itmjf=0
         .i patflag="O"   s patflag="OutPatient"
         .i patflag="I"   s patflag="InPatient"
         .i InvFalg'="YJ"   d
         ..i (insstr="")&(paystr="")&(catstr="")&(locstr="")   d
         ...;b ;;1
         ...s JFlen=$l(JFDetails,",")
         ...f j=1:1:JFlen   d
         ....s Stat=$p(JFDetails,",",j)
         ....q:Stat=""
         ....i patflag["A"   s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee",Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee",Stat))
         ....e  s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee",Stat))
         ...s DFlen=$l(DFDetails,",")
         ...;b   ;;;2
         ...f j=1:1:DFlen   d
         ....s Stat=$p(DFDetails,",",j)
         ....q:Stat=""
         ....;b  ;;3
         ....i patflag["A"   s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee",Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee",Stat))
         ....e  s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee",Stat))
         ..;b  ;;4
         ..i (insstr'="")&(paystr="")&(catstr="")&(locstr="")  d
         ...s len=$l(insstr,",")
         ...f i=1:1:len   d
         ....s admreas=$p(insstr,",",i)
         ....s JFlen=$l(JFDetails,",")
         ....f j=1:1:JFlen   d
         .....s Stat=$p(JFDetails,",",j)
         .....q:Stat=""
         .....i patflag["A"   s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","admres",admreas,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","admres",admreas,Stat))
         .....e  s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee","admres",admreas,Stat))
         ....s DFlen=$l(DFDetails,",")
         ....f j=1:1:DFlen   d
         .....s Stat=$p(DFDetails,",",j)
         .....q:Stat=""
         .....i patflag["A"   s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","admres",admreas,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","admres",admreas,Stat))
         .....e  s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee","admres",admreas,Stat))
         ..i (insstr="")&(paystr'="")&(catstr="")&(locstr="")   d
         ...s len=$l(paystr,",")
         ...f i=1:1:len   d
         ....s paym=$p(paystr,",",i)
         ....s JFlen=$l(JFDetails,",")
         ....f j=1:1:JFlen   d
         .....s Stat=$p(JFDetails,",",j)
         .....q:Stat=""
         .....i patflag["A"   s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Paym",paym,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","Paym",paym,Stat))
         .....e  s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee","Paym",paym,Stat))
         ....s DFlen=$l(DFDetails,",")
         ....f j=1:1:DFlen   d
         .....s Stat=$p(DFDetails,",",j)
         .....q:Stat=""
         .....i patflag["A"   s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Paym",paym,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","Paym",paym,Stat))
         .....e  s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee","Paym",paym,Stat))
         ..i (insstr="")&(paystr="")&(catstr'="")&(locstr="")  d
         ...s len=$l(catstr,",")
         ...f i=1:1:len   d
         ....s cat=$p(catstr,",",i)
         ....s JFlen=$l(JFDetails,",")
         ....f j=1:1:JFlen   d
         .....s Stat=$p(JFDetails,",",j)
         .....q:Stat=""
         .....i patflag["A"   s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Cat",cat,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","Cat",cat,Stat))
         .....e  s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee","Cat",cat,Stat))
         ....s DFlen=$l(DFDetails,",")
         ....f j=1:1:DFlen   d
         .....s Stat=$p(DFDetails,",",j)
         .....q:Stat=""
         .....i patflag["A"   s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Cat",cat,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","Cat",cat,Stat))
         .....e  s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee","Cat",cat,Stat))
         ..i (insstr="")&(paystr="")&(catstr="")&(locstr'="")  d
         ...s len=$l(locstr,",")
         ...f i=1:1:len   d
         ....s loc=$p(locstr,",",i)
         ....s JFlen=$l(JFDetails,",")
         ....f j=1:1:JFlen   d
         .....s Stat=$p(JFDetails,",",j)
         .....q:Stat=""
         .....i patflag["A"   s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Loc",loc,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","Loc",loc,Stat))
         .....e  s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee","Loc",loc,Stat))
         ....s DFlen=$l(DFDetails,",")
         ....f j=1:1:DFlen   d
         .....s Stat=$p(DFDetails,",",j)
         .....q:Stat=""
         .....i patflag["A"   s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","Loc",loc,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","Loc",loc,Stat))
         .....e  s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee","Loc",loc,Stat))
         ..i (insstr'="")&(paystr'="")&(catstr="")&(locstr="")  d
         ...s inslen=$l(insstr,",")
         ...f i=1:1:inslen   d
         ....s ins=$p(insstr,",",i)
         ....s paylen=$l(paystr,",")
         ....f k=1:1:paylen   d      
         .....s paym=$p(paystr,",",k)
         .....s JFlen=$l(JFDetails,",")
         .....f j=1:1:JFlen   d
         ......s Stat=$p(JFDetails,",",j)
         ......q:Stat=""
         ......i patflag["A"   s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","ReasPaym",ins,paym,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","ReasPaym",ins,paym,Stat))
         ......e  s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee","ReasPaym",ins,paym,Stat))
         .....s DFlen=$l(DFDetails,",")
         .....f j=1:1:DFlen   d
         ......s Stat=$p(DFDetails,",",j)
         ......q:Stat=""
         ......i patflag["A"   s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","ReasPaym",ins,paym,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","ReasPaym",ins,paym,Stat))
         ......e  s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee","ReasPaym",ins,paym,Stat))
         ..i (insstr="")&(paystr="")&(catstr'="")&(locstr'="")  d
         ...s catlen=$l(catstr,",")
         ...f i=1:1:catlen   d
         ....s cat=$p(catstr,",",i)
         ....s loclen=$l(locstr,",")
         ....f k=1:1:loclen   d      
         .....s loc=$p(locstr,",",k)
         .....s JFlen=$l(JFDetails,",")
         .....f j=1:1:JFlen   d
         ......s Stat=$p(JFDetails,",",j)
         ......q:Stat=""
         ......i patflag["A"   s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatLoc",cat,loc,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","CatLoc",cat,loc,Stat))
         ......e  s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee","CatLoc",cat,loc,Stat))
         .....s DFlen=$l(DFDetails,",")
         .....f j=1:1:DFlen   d
         ......s Stat=$p(DFDetails,",",j)
         ......q:Stat=""
         ......i patflag["A"   s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,"OutPatient","InvFee","CatLoc",cat,loc,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","InvFee","CatLoc",cat,loc,Stat))
         ......e  s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee","CatLoc",cat,loc,Stat))
         .;;;;;;;;;;;;;;;;;;;;;;;;;;;;;YJ ;;;;;;;;;;;;;;;;;;;
         .i InvFalg'="FP"   d
         ..i (insstr="")&(paystr="")&(catstr="")&(locstr="")  d
         ...s JFlen=$l(JFDetails,",")
         ...f j=1:1:JFlen   d
         ....s Stat=$p(JFDetails,",",j)
         ....q:Stat=""
         ....i patflag["A"   s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,"OutPatient","Deposit",Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit",Stat))
         ....e  s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,patflag,"Deposit",Stat))
         ...s DFlen=$l(DFDetails,",")
         ...f j=1:1:DFlen   d
         ....s Stat=$p(DFDetails,",",j)
         ....q:Stat=""
         ....i patflag["A"   s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,"OutPatient","Deposit",Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit",Stat))
         ....e  s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,patflag,"Deposit",Stat))
         ..i (insstr'="")&(paystr="")&(catstr="")&(locstr="")  d
         ...s len=$l(insstr,",")
         ...f i=1:1:len   d
         ....s admreas=$p(insstr,",",i)
         ....s JFlen=$l(JFDetails,",")
         ....f j=1:1:JFlen   d
         .....s Stat=$p(JFDetails,",",j)
         .....q:Stat=""
         .....i patflag["A"   s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,"OutPatient","Deposit","admres",admreas,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","admres",admreas,Stat))
         .....e  s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,patflag,"Deposit","admres",admreas,Stat))
         ....s DFlen=$l(DFDetails,",")
         ....f j=1:1:DFlen   d
         .....s Stat=$p(DFDetails,",",j)
         .....q:Stat=""
         .....i patflag["A"   s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,"OutPatient","Deposit","admres",admreas,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","admres",admreas,Stat))
         .....e  s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,patflag,"Deposit","admres",admreas,Stat))
         ..i (insstr="")&(paystr'="")&(catstr="")&(locstr="")   d
         ...s len=$l(paystr,",")
         ...f i=1:1:len   d
         ....s paym=$p(paystr,",",i)
         ....s JFlen=$l(JFDetails,",")
         ....f j=1:1:JFlen   d
         .....s Stat=$p(JFDetails,",",j)
         .....q:Stat=""
         .....i patflag["A"   s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,"OutPatient","Deposit","Paym",paym,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","Paym",paym,Stat))
         .....e  s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,patflag,"InvFee","Paym",paym,Stat))
         ....s DFlen=$l(DFDetails,",")
         ....f j=1:1:DFlen   d
         .....s Stat=$p(DFDetails,",",j)
         .....q:Stat=""
         .....i patflag["A"   s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,"OutPatient","Deposit","Paym",paym,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","Paym",paym,Stat))
         .....e  s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,patflag,"Deposit","Paym",paym,Stat))
         ..i (insstr="")&(paystr="")&(catstr="")&(locstr'="")  d
         ...s len=$l(locstr,",")
         ...f i=1:1:len   d
         ....s loc=$p(locstr,",",i)
         ....s JFlen=$l(JFDetails,",")
         ....f j=1:1:JFlen   d
         .....s Stat=$p(JFDetails,",",j)
         .....q:Stat=""
         .....i patflag["A"   s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,"OutPatient","Deposit","Loc",loc,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","Loc",loc,Stat))
         .....e  s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,patflag,"Deposit","Loc",loc,Stat))
         ....s DFlen=$l(DFDetails,",")
         ....f j=1:1:DFlen   d
         .....s Stat=$p(DFDetails,",",j)
         .....q:Stat=""
         .....i patflag["A"   s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,"OutPatient","Deposit","Loc",loc,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","Loc",loc,Stat))
         .....e  s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,patflag,"Deposit","Loc",loc,Stat))
         ..i (insstr'="")&(paystr'="")&(catstr="")&(locstr="")  d
         ...s inslen=$l(insstr,",")
         ...f i=1:1:inslen   d
         ....s ins=$p(insstr,",",i)
         ....s paylen=$l(paystr,",")
         ....f k=1:1:paylen   d      
         .....s paym=$p(paystr,",",k)
         .....s JFlen=$l(JFDetails,",")
         .....f j=1:1:JFlen   d
         ......s Stat=$p(JFDetails,",",j)
         ......q:Stat=""
         ......i patflag["A"   s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,"OutPatient","Deposit","ReasPaym",ins,paym,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","ReasPaym",ins,paym,Stat))
         ......e  s itmjf=itmjf+$g(^TMP("CredData",CredCode,$j,patflag,"Deposit","ReasPaym",ins,paym,Stat))
         .....s DFlen=$l(DFDetails,",")
         .....f j=1:1:DFlen   d
         ......s Stat=$p(DFDetails,",",j)
         ......q:Stat=""
         ......i patflag["A"   s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,"OutPatient","Deposit","ReasPaym",ins,paym,Stat))+$g(^TMP("CredData",CredCode,$j,"InPatient","Deposit","ReasPaym",ins,paym,Stat))
         ......e  s itmdf=itmdf+$g(^TMP("CredData",CredCode,$j,patflag,"Deposit","ReasPaym",ins,paym,Stat))
         .s DFSum=DFSum+itmdf
         .s JFSum=JFSum+itmjf
         .;b  ;; i
         .s rtn=..SaveVouchDetail(vouchId,actitem,itm,itmjf,itmdf,itmdes)
         .;b  ;;;5   SaveVouchDetail 
         b  ;;jd
         i DFSum'=JFSum  s rtn=-110
         i (DFSum=JFSum)&(JFSum=0)  s rtn="-100"
         i rtn=0   d
         .s rtn=..SetCredFlag(Cred, StDate, EndDate, User,vouchId)
         ;b   ;;; 6     SetCredFlag
         d UnLock 
         
         
         
         i rtn=0     tcommit
         e   trollback
         
         k ^TMP("Credinfo",CredCode,$j)
		 k ^TMP("CredData",CredCode,$j)
         
         q rtn 
         
AddLock()	
	s rett=##class(web.ACCTCommon).AddLock("Charge","CreateCred")		;对生成凭证号代码段加锁
	q rett
UnLock
	s rett=##class(web.ACCTCommon).RemoveLock("Charge","CreateCred")												
	q  
ErrorRecord(errCode,errDesc)
	s err=$$ErrorRecord^DHCSTERROR("Charge","CreateCred",errCode,errDesc)
    q
}

ClassMethod SetCredFlag(Cred, StDate, EndDate, User, vouchId)
{
   
     s rtn=0
     s DataSource=$p(^DHCACCCRE(Cred),"^",3)
     s PatType=$p(^DHCACCCRE(Cred),"^",4)
     
     i PatType'="I"   d
     .f Date=StDate:1:EndDate   d
     ..i DataSource'="YJ"   d
     ...s HisDr=""
     ...f  s HisDr=$o(^DHCOPInsFootI(0,"Date",Date,HisDr))   q:(HisDr="")||(rtn'=0)   d
     ....s HUsr=$p(^DHCOPInsFoot(HisDr),"^",8)
     ....q:(User'="")&&(User'=HUsr)
     ....s rtn=..SaveVouchBuss(vouchId,HisDr)
     ....q:rtn'=0
     ....s ^DHCOPInsFoot(HisDr,"Acct",1)="Y"
     ....s ^DHCOPInsFoot(HisDr,"Acct",CredCode)=vouchId
     ..i DataSource'="FP"   d
     ...s HisDr=""
     ...f  s HisDr=$o(^DHCACDi("AccPDFL",0,"FootDT",Date,HisDr))   q:(HisDr="")||(rtn'=0)   d
     ....s HUsr=$p(^DHCACD("AccPDFL",HisDr),"^",3)
     ....q:(User'="")&&(User'=HUsr)
     ....s rtn=..SaveVouchBuss(vouchId,HisDr)
     ....q:rtn'=0
     ....s ^DHCACD("AccPDFL",HisDr,"Acct",1)="Y"
     ....s ^DHCACD("AccPDFL",HisDr,"Acct",CredCode)=vouchId
     i PatType'="O"   d 
     .f Date=StDate:1:EndDate   d
     ..s HisDr=""
     ..f  s HisDr=$o(^DHCJFUSERJK(0,"date",Date,HisDr))   q:(HisDr="")||(rtn'=0)   d
     ...s HUsr=$p(^DHCJFUSERJK(HisDr),"^",5)
     ...q:(User'="")&&(User'=HUsr)
     ...s rtnflag=0
     ...i DataSource'="YJ"   d
     ....i $d(^DHCINVPRTZY(0,"JK",HisDr))    s rtnflag=1  
     ...i DataSource'="FP"   d
     ....i $d(^DHCSFPRINTDETAIL(0,"JKDR",HisDr))   s rtnflag=1 
     ...q:(rtnflag=0)
     ...s rtn=..SaveVouchBuss(vouchId,HisDr)
     ...q:rtn'=0
     ...s ^DHCJFUSERJK(HisDr,"Acct",1)="Y"
     ...s ^DHCJFUSERJK(HisDr,"Acct",CredCode)=vouchId
  
     q rtn
}

ClassMethod SaveVouchDetail(parref As %String, subjId As %String, serialNo As %Integer, amtDebit As %Numeric, amtCredit As %Numeric, summary As %String) As %String
{
   
	&sql(Insert into ACCT_VouchDetail(ACCT_VouchParref,ACCT_Subj_Dr,vouch_page,
	     vouch_row,amt_debit,amt_credit,summary) 
	     Values(:parref,:subjId,1,:serialNo,:amtDebit,:amtCredit,:summary))
	i SQLCODE'=0  d
	.s ret=$$SqlErrorRecord^DHCSTERROR("web.AccCredManage.SaveVouchDetail","parref:"_parref,SQLCODE)
	q SQLCODE
}

ClassMethod SaveVouchRecord(listData As %String) As %String
{
	n (listData)
	s yearPeriod=$p(listData,"^",1)
	s vouchType=$p(listData,"^",2)
	s vouchSource=$p(listData,"^",3)
	s busiType=$p(listData,"^",4)
	s vouchNo=$p(listData,"^",5)
	s billNum=$p(listData,"^",6)
	s operator=$p(listData,"^",7)
	s date=+$h
	&sql(Insert into ACCT_Vouch(ACCT_YearPeriod_Dr,ACCT_VouchType_Dr,vouch_source,
	     ACCT_BusiType_Dr,vouch_no,vouch_no_use,vouch_date,vouch_bill_num,operator) 
	     Values(:yearPeriod,:vouchType,:vouchSource,:busiType,:vouchNo,:vouchNo,
	     :date,:billNum,:operator))
	i SQLCODE'=0  d
	.s ret=$$SqlErrorRecord^DHCSTERROR("web.AccCredManage.SaveVouchRecord","vouchno:"_vouchNo,SQLCODE)
	q:SQLCODE'=0 ""
	q $p(%ROWID,$c(1))
}

ClassMethod CreateVouchNo(modCode As %String) As %String
{
	n (modCode)
	q:modCode="" ""
	s date=$zd(+$h,8)
	s pre=modCode_$e(date,1,6)
	&sql(Select Max(vouch_no) into :maxNo From ACCT_Vouch 
	     WHERE vouch_no %STARTSWITH :pre)
	i SQLCODE'=0  d
	.s ret=$$SqlErrorRecord^DHCSTERROR("web.AccCredManage.CreateVouchNo","pre:"_pre,SQLCODE)
	q:SQLCODE'=0 ""
	s vouchNo=+$e(maxNo,$l(maxNo)-3,$l(maxNo))
	s vouchNo=vouchNo+1
	s vouchNo=$tr($j(vouchNo,4),$c(32),"0")
	s vouchNo=pre_vouchNo
	q vouchNo
}

ClassMethod SaveVouchBuss(vouchId As %String, Bussno As %String) As %String
{
     q:($g(vouchId)="")||($g(Bussno)="") -1
	s ret=0
	&sql(Insert into ACCT_VouchBuss(Acct_Vouch_Dr,buss_no) 
	     Values(:vouchId,:Bussno))
	i SQLCODE'=0  d
	.s ret=$$SqlErrorRecord^DHCSTERROR("web.AccCredManage.SaveVouchBuss","vouchId:"_vouchId,SQLCODE)
	s:SQLCODE'=0 ret=-1
	
	q:ret'=0 ret
	q 0
}

}
