Class dhc.bonus.uinter.uGetIncomeByGeneralAudit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 体检收入采集
/// w ##class(dhc.bonus.uinter.uGetIncomeByGeneralAudit).GetIncomeByGeneralAudit("2013-03-01","2013-03-31","10")
ClassMethod GetIncomeByGeneralAudit(sttdate As %String, enddate As %String, sMethodDr As %String) As %String
{
    n (sttdate,enddate,sMethodDr)
	s MethodDr=sMethodDr
    s CurrentDate=sttdate
	s CurrentY=$p(CurrentDate,"-",1) 
	s CurrentM=$p(CurrentDate,"-",2)
	s CurrentD=$p(CurrentDate,"-",3)
	S Year = CurrentY
	s Month= "M"_CurrentM
	
	s sttdate=$zdh(sttdate,3)
    s enddate=$zdh(enddate,3)
    
    s DateFrom = sttdate
    s DateTo = enddate
    
   
   ;Set UserID=%session.Get("LOGON.USERID")
    Set UserID="ZLG"
    k ^DHCPETemp("IncomeByGeneral",UserID)
    k ^DHCPEGetIncomeByIADM("OrdEntDR",UserID)

    Set repid=$I(^CacheTemp)
    s ind=1
    i DateFrom=""  s DateFrom=0
    i DateTo=""    s DateTo=+$H
    s j=0
    s Date=DateFrom-1
    f  s Date=$o(^DHCPEDataEx("DHCPEGeneralAuditDate",Date))  q:(Date="")||((DateTo'="")&&(DateTo<Date))  d 
    .s Time=0
    .f  s Time=$o(^DHCPEDataEx("DHCPEGeneralAuditDate",Date,Time))  q:Time=""  d
    ..s j=j+1  
    ..i j=1  s ^DHCPETemp("IncomeByGeneral",UserID,"FirstTime")=Date_"^"_Time
    ..s ^DHCPETemp("IncomeByGeneral",UserID,"LastTime")=Date_"^"_Time
    ..s IADMRowID=0
    ..f  s IADMRowID=$o(^DHCPEDataEx("DHCPEGeneralAuditDate",Date,Time,IADMRowID))  q:IADMRowID=""  d
    ...//q:IADMRowID="535"
    ...d ..GetIncomeByIADM(IADMRowID)


    s CatJob=$j
    s TarECID=0,num=0
    s TJK=0,BCS=0,FSK=0,JYK=0,BLK=0,CTS=0,TJZX=0
    f  s TarECID=$o(^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,TarECID))  q:TarECID=""  d
    .s num=1
    .S TarECDesc=$p($G(^DHCTarC("EC",TarECID)),"^",2)
    .s FaceAmount=$g(^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,TarECID))
    .;s FaceAmount=$fn(+FaceAmount,",",2)
    .;i TarECID="100"  s TarECDesc="凑整费"
    .;d QueryOut  
    
    .s TJZX = TJZX+FaceAmount
    
    .i TarECID="11" d
    ..s TJK=TJK+FaceAmount
    .i TarECID="12" d
    ..s BCS=BCS+FaceAmount
    .i ((TarECID="19")||(TarECID="20")||(TarECID="21")) d
    ..s FSK=FSK+FaceAmount
    .i ((TarECID="24")||(TarECID="25")) d
    ..s CTS=CTS+FaceAmount
    .i (TarECID="30") d
    ..s BLK=BLK+FaceAmount
    .i ((TarECID="33")||(TarECID="34")||(TarECID="35")||(TarECID="36")||(TarECID="38")) d
    ..s JYK=JYK+FaceAmount
    
    &sql(delete from dhc_bonus_subs.BonusSubExpendCollect 
         where BonusYear=:Year and BonusPeriod=:Month and InterLocMethodID=:MethodDr )
         
        
    
    s UnitType=5
    
    &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values('05011','体检收入','D2022','特检室',:Year,:Month,:TJK,getdate(), 0,:UnitType,:MethodDr)
		)
	&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values('05011','体检收入','D2021','B超室',:Year,:Month,:BCS,getdate(), 0,:UnitType,:MethodDr)
		)
	&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values('05011','体检收入','D2031','放射科',:Year,:Month,:FSK,getdate(), 0,:UnitType,:MethodDr)
		)
	&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values('05011','体检收入','D2032','CT室',:Year,:Month,:CTS,getdate(), 0,:UnitType,:MethodDr)
		)
	&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values('05011','体检收入','D205','病理科',:Year,:Month,:BLK,getdate(), 0,:UnitType,:MethodDr)
		)
	&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values('05011','体检收入','D201','检验科',:Year,:Month,:JYK,getdate(), 0,:UnitType,:MethodDr)
		)
		
	&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values('25010','体检收入','D123','中医药预防保健服务中心',:Year,:Month,:TJZX,getdate(), 0,:UnitType,:MethodDr)
		)
    
	q num
}

ClassMethod GetIncomeByIADM(IADM)
{
    Set UserID="ZLG" ;%session.Get("LOGON.USERID")
    s preAdmId=$P(^DHCPEIADM(IADM),"^",4)
    S GADMDR=$P(^DHCPEIADM(IADM),"^" ,2)
    i GADMDR'="" s GBaesInfo=$p($g(^DHCPEGADM(GADMDR)),"^",1)
    s ^zl("IADM",IADM)=GADMDR
    s CatJob=$j
    k ^DHCPEGetIncomeByIADM("OrdEntDR")
	s ChildSub=0
	f  s ChildSub=$o(^DHCPEPreIADM(preAdmId,"ORDITEM", ChildSub))  q:ChildSub=""  d
	.q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",16)'=1 //判断是否有效
	.s OrdEntDR=$p(^DHCPEPreIADM(preAdmId,"ORDITEM", ChildSub),"^",2) 
	.i OrdEntDR'=""  s ^DHCPEGetIncomeByIADM("OrdEntDR",UserID,OrdEntDR)=preAdmId
	.i OrdEntDR="" d 
	..s arcitmid=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",1)
	..s Amount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",14)
	..s CurDate=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub)),"^",12)
	..s Flag=0 
	..//q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee"))
	..s FSub=0
	..f  s FSub=$o(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub,"FEE",FSub))  q:FSub=""  d
	...S PAuditID=$P($G(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub,"FEE",FSub)),"^",5)
	...Q:PAuditID=""
	...s AuditType=$p(^DHCPEPreA(PAuditID),"^",1) 
	...s AuditStr=..GetPersonAuditAmount(preAdmId_"||"_ChildSub,"ORDITEM")
	...s CurFact=+$p($G(^DHCPEPreIADM(preAdmId,"ORDITEM",ChildSub,"FEE",FSub)),"^",2)
	...q:CurFact=0
	...i arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee"))  d
	....s ^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,"100")=+$G( ^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,"100"))+CurFact
	....i (GADMDR'="")&&(AuditType="G") d
	.....s ^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR))+CurFact
    ....else  d
	.....s ^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob))+CurFact
    ....s ^DHCPETemp("IncomeByGeneral",UserID,CatJob,100)=+$g(^DHCPETemp("IncomeByGeneral",UserID,CatJob,100))+CurFact 
	...q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee"))
	...s TarItem=0
	...f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
	....s StartDate=0
	....f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>CurDate)  d
	.....s OLTID=0
	.....f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:OLTID=""  d
	......s EndDate=$p(^DHCOLT(OLTID),"^",5)
	......q:(EndDate'="")&&(EndDate<CurDate)
	......s qty=$p(^DHCOLT(OLTID),"^",3)
	......s CurPrice=+##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"","","")  //得到当前计费项金额
	......s AddbyTwoAuditAmount=$p(AuditStr,"^",1)
	......s AuditNum=$p(AuditStr,"^",2)
	......i (Amount'=0)&&(CurPrice'=0) d
	.......s CurCatFee=(CurPrice/Amount)*CurFact*qty
	.......i +AuditNum>1 s CurAccountAmount=((AddbyTwoAuditAmount)/Amount)*CurPrice*qty
	.......else  s CurAccountAmount=CurPrice*qty
	......e  d
	.......s CurCatFee=CurFact
	......//w !,arcitmid_"^"_TarItem_"^"_CurCatFee
	......s OneInfo=..GetTarEC(TarItem)
	......//w !,arcitmid_"^"_TarItem_"^"_CurCatFee_"^"_OneInfo
	......s ^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,$p(OneInfo,"^",1))=+$g(^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,$p(OneInfo,"^",1)))+CurCatFee
	......//s ^zl("IncomeByGeneral","FactAmount",CatJob,$p(OneInfo,"^",1))=+$g(^zl("IncomeByGeneral","FactAmount",CatJob,$p(OneInfo,"^",1)))+CurCatFee
	......s ^DHCPETemp("IncomeByGeneral",UserID,CatJob,100)=+$g(^DHCPETemp("IncomeByGeneral",UserID,CatJob,100))+CurCatFee        
	......i (GADMDR'="")&&(AuditType="G") d
	.......s ^DHCPETemp("IncomeByGeneral",UserID,"GADM",CatJob,GADMDR)=GBaesInfo
	.......s ^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR))+CurCatFee
    ......else  d
	.......s ^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob))+CurCatFee
	..q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee"))
		
		s PIOIOrdEntDR=0
		f  s PIOIOrdEntDR=$o(^DHCPEGetIncomeByIADM("OrdEntDR",UserID,PIOIOrdEntDR))  q:PIOIOrdEntDR=""  d
		.s preAdmId=$p(PIOIOrdEntDR,"||",1)
		.s childsub=$p(PIOIOrdEntDR,"||",2)
		.q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
		.s Amount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",7)
		.s CurDate=$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",4)
		.s EFSub=0
		.f  s EFSub=$o(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",EFSub)) q:EFSub=""  d 
		..s CurFact=+$p($G(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",EFSub)),"^",2)
		..S PAuditID=$P($G(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",EFSub)),"^",5)
		..Q:PAuditID=""
		..s AuditType=$p(^DHCPEPreA(PAuditID),"^",1)
	    ..s AuditStr=..GetPersonAuditAmount(PIOIOrdEntDR,"ORDENT")
		..q:CurFact=0
		..s ItemSub=0
		..f  s ItemSub=$o(^DHCPEPreIADM(0,"OrdEnt",preAdmId_"||"_childsub,preAdmId,ItemSub)) q:ItemSub=""  d
		...s arcitmid=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",1)
	    ...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",16)'=1 //判断是否有效
		...s ItemAmount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",14)
		...q:ItemAmount=0
		...i arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee"))  d
	    ....s ^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,"100")=+$G( ^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,"100"))+ItemAmount
	    ....i (GADMDR'="")&&(AuditType="G") d
	    .....s ^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR))+ItemAmount
        ....else  d
	    .....s ^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob))+ItemAmount
	    ....s ^DHCPETemp("IncomeByGeneral",UserID,CatJob,100)=+$g(^DHCPETemp("IncomeByGeneral",UserID,CatJob,100))+ItemAmount 
	    ...q:arcitmid=$G(^DHCPESetting("DHCPE","RoundingFee"))
		...s TarItem=0
		...f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
		....s StartDate=0
		....f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>CurDate)  d
		.....s OLTID=0
		.....f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:OLTID=""  d
		......s EndDate=$p(^DHCOLT(OLTID),"^",5)
		......q:(EndDate'="")&&(EndDate<CurDate)
		......s qty=$p(^DHCOLT(OLTID),"^",3)
		......s CurPrice=##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"","","")   //得到当前计费项金额
		......s AddbyTwoAuditAmount=$p(AuditStr,"^",1)
		......s AuditNum=$p(AuditStr,"^",2)
		......i Amount'=0 d
		.......s CurCatFee=(CurPrice/Amount)*CurFact*qty
		.......i +AuditNum>1 s CurAccountAmount=((AddbyTwoAuditAmount)/Amount)*CurPrice*qty
		.......else  s CurAccountAmount=CurPrice*qty
		......e  d
	    .......s CurCatFee=CurFact
	    ......s OneInfo=..GetTarEC(TarItem)
	    ......s ^DHCPETemp("IncomeByGeneral",UserID,CatJob,$p(OneInfo,"^",1))=$p(OneInfo,"^",2)
	    ......s ^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,$p(OneInfo,"^",1))=+$g(^DHCPETemp("IncomeByGeneral",UserID,"FactAmount",CatJob,$p(OneInfo,"^",1)))+CurCatFee
	    ......s ^DHCPETemp("IncomeByGeneral",UserID,CatJob,100)=+$g(^DHCPETemp("IncomeByGeneral",UserID,CatJob,100))+CurCatFee 
	    ......i (GADMDR'="")&&(AuditType="G") d
	    .......s ^DHCPETemp("IncomeByGeneral",UserID,"GADM",CatJob,GADMDR)=GBaesInfo
	    .......s ^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"GFactAmount",CatJob,GADMDR))+CurCatFee
        ......else  d
	    .......s ^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob)=+$g(^DHCPETemp("IncomeByGeneral",UserID,"IFactAmount",CatJob))+CurCatFee
}

ClassMethod GetPersonAuditAmount(PIOIDR, Type)
{
   n (PIOIDR, Type,PAuditID)
   s PIADMRowId=$P(PIOIDR,"||",1)
   s PIADMAddOrdItem=$p(^DHCPEPreIADM(PIADMRowId),"^",10)
   s AddOrdItemLimit=$p(^DHCPEPreIADM(PIADMRowId),"^",11)
   s AddOrdItemAmount=$p(^DHCPEPreIADM(PIADMRowId),"^",12)
   if Type="ORDITEM"{
    s PIOIChildSub=0,ADDAmount=0,ADDAmountbyTwoAuditID=0
    f  s PIOIChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub))  q:PIOIChildSub=""  d
    .s PIOIItemStat=$p($G(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub)),"^",16)
    .q:PIOIItemStat'=1
    .s PIOIOrdEntDR=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub),"^",2)
    
    .s AccountAmount=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub),"^",14)
    .s FChildSub=0,num=0
    .f  s FChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",FChildSub))  q:FChildSub=""  d
    ..S PAuditID=$P($G(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",FChildSub)),"^",5)
    ..Q:PAuditID=""
    ..s num=num+1
    ..s AuditType=$p(^DHCPEPreA(PAuditID),"^",1)
    ..s PAType=$p(^DHCPEPreA(PAuditID),"^",20)
    .i (num=1)&&(AuditType="G")  d 
    ..i PAType="ADD"  S ADDAmount=ADDAmount+AccountAmount
    
    i AddOrdItemLimit="Y"  S ADDAmountbyTwoAuditID=AddOrdItemAmount-ADDAmount
    
    s FChildSub=0,i=0
    f  s FChildSub=$o(^DHCPEPreIADM($P(PIOIDR,"||",1),"ORDITEM",$P(PIOIDR,"||",2),"FEE",FChildSub))  q:FChildSub=""  d
	.S PAuditID=$P($G(^DHCPEPreIADM($P(PIOIDR,"||",1),"ORDITEM",$P(PIOIDR,"||",2),"FEE",FChildSub)),"^",5)
	.Q:PAuditID=""
	.s i=i+1
	
	q ADDAmountbyTwoAuditID_"^"_i
   }
   
	if Type="ORDENT"{
		
	s PIOEChildSub=0,ADDAmount=0,ADDAmountbyTwoAuditID=0
    f  s PIOEChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub))  q:PIOEChildSub=""  d
    .s PIOIOrdEntDR=$p(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub),"^",2)
    .s AccountAmount=$p(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub),"^",14)
    .s FChildSub=0,num=0
    .f  s FChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOEChildSub,"FEE",FChildSub))  q:FChildSub=""  d
    ..S PAuditID=$P($G(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOEChildSub,"FEE",FChildSub)),"^",5)
    ..Q:PAuditID=""
    ..s num=num+1
    ..s AuditType=$p(^DHCPEPreA(PAuditID),"^",1)
    ..s PAType=$p(^DHCPEPreA(PAuditID),"^",20)
    .i (num=1)&&(AuditType="G")  d 
    ..i PAType="ADD"  S ADDAmount=ADDAmount+AccountAmount
    
    i AddOrdItemLimit="Y"  S ADDAmountbyTwoAuditID=AddOrdItemAmount-ADDAmount	
    s FChildSub=0,i=0
    s feesub1=0
	f  s feesub1=$o(^DHCPEPreIADM($P(PIOIDR,"||",1),"ORDENT",$P(PIOIDR,"||",2),"FEE",feesub1)) q:((feesub1=""))  d
	.s feeData=$g(^DHCPEPreIADM($P(PIOIDR,"||",1),"ORDENT",$P(PIOIDR,"||",2),"FEE",feesub1))
	.s PIOEFPAuditDR=$p(feeData,"^",5)
	.Q:PAuditID=""
	.s i=i+1
	
	q ADDAmountbyTwoAuditID_"^"_i
	}
}

ClassMethod GetTarEC(TarItem)
{
    
	s TarECID=$p($G(^DHCTARI(TarItem)),"^",16)
	Q:TarECID=""
	s TarECDesc=$p($G(^DHCTarC("EC",TarECID)),"^",2)
	q TarECID_"^"_TarECDesc
}

Storage Default
{
<StreamLocation>^dhc.bonus.u649.uGetIncomeBy960S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
