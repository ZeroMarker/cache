Class web.DHCPE.GroupFeeCat [ ClassType = "", Not ProcedureBlock ]
{

/// 得到团体中自费金额
/// ##class(web.DHCPE.GroupFeeCat).GetITotalFee(CRMID)
/// PaiedType  ""  所有
/// 			1  已付
ClassMethod GetITotalFee(CRMID, PaiedType As %String = "", Depart As %String = "")
{
	n (CRMID,PaiedType,Depart)
	s TotalFee=0
	;i PEID'="" s CRMID=$p($G(^DHCPEGADM(PEID)),"^",2)
	i CRMID="" q TotalFee
	s IADM=0
	f  s IADM=$o(^DHCPEPreIADM(0,"PGADM",CRMID,IADM))  q:IADM=""  d
	.s Position=$G(^DHCPEDataEx("DHCPEPreIADM","Position",IADM))  //add 20121208
	.q:(Position'=Depart)&&(Depart'="")                           //add 20121208
	.s OneFee=..GetOneITotalFee(IADM,PaiedType)
	.s TotalFee=+TotalFee+OneFee
	q TotalFee
}

/// 得到一个人的自费金额
ClassMethod GetOneITotalFee(IADM, PaiedType)
{
	n (IADM,PaiedType)
	s TotalFee=0
	s AuditID=0
	f  s AuditID=$o(^DHCPEPreA(0,"CRMADM","I",IADM,AuditID)) q:AuditID=""  d
	.s Status=$p(^DHCPEPreA(AuditID),"^",21)
	.q:Status="NU"
	.s PaiedFlag=$p(^DHCPEPreA(AuditID),"^",14)
	.q:(PaiedType'="")&&(PaiedFlag="UNCHARGED")
	.s OneFee=+$p(^DHCPEPreA(AuditID),"^",9)
	.s TotalFee=+TotalFee+OneFee
	q TotalFee
}

/*
/// 得到团体总的应收金额
/// ##class(web.DHCPE.GroupFeeCat).GetGTotalFee(CRMID)
ClassMethod GetGTotalFee(CRMID, PaiedType As %String = "",Depart As %String = "")
{
	
	q:CRMID="" 0
	i PaiedType'=""
	{
		s IPaied=..GetITotalFee(CRMID,PaiedType)
		s AuditID=0
		f  s AuditID=$o(^DHCPEPreA(0,"CRMADM","G",CRMID,AuditID)) q:AuditID=""  d
		.s Flag=$p($g(^DHCPEPreA(AuditID)),"^",21)
		.q:Flag="NU"
		.s PaiedFlag=$p($g(^DHCPEPreA(AuditID)),"^",14)
		.q:(PaiedFlag="UNCHARGED")
		.s OneFee=+$p(^DHCPEPreA(AuditID),"^",9)
		.s IPaied=IPaied+OneFee
		q IPaied
	}
	;i PEID'="" s CRMID=$p($G(^DHCPEGADM(PEID)),"^",2)
	s retVal=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Grp(CRMID)
	
	s Amount=$p(retVal,"^",1)
	s Fact=$p(retVal,"^",2)
	q +Fact
}
*/
/// 得到团体总的应收金额
/// add 20121208
ClassMethod GetGTotalFee(CRMID, PaiedType As %String = "", Depart As %String = "")
{
	n (CRMID,PaiedType,Depart)
	
	s PreAmount=##class(web.DHCPE.GroupFeeCat).GetGPreTotalFee(CRMID,0,PaiedType,Depart)
	s AddAmount=##class(web.DHCPE.GroupFeeCat).GetGPreTotalFee(CRMID,1,PaiedType,Depart)
	s IAddAmount=##class(web.DHCPE.GroupFeeCat).GetITotalFee(CRMID,PaiedType,Depart)
	q PreAmount+AddAmount+IAddAmount
}

/// 得到团体总的预约金额、公费加项金额
/// ##class(web.DHCPE.GroupFeeCat).GetGPreTotalFee(CRMID,Type)
/// Type  0  预约金额
///       1  加项金额
/// PaiedType
/// 	  ""  所有
/// 	  1   已付    
ClassMethod GetGPreTotalFee(CRMID, Type, PaiedType As %String = "", Depart As %String = "")
{
	s TotalFee=0
	q:CRMID="" 0
	s AuditID=0
	f  s AuditID=$o(^DHCPEPreA(0,"CRMADM","G",CRMID,AuditID)) q:AuditID=""  d
	.s Flag=$p($g(^DHCPEPreA(AuditID)),"^",21)
	.q:Flag="NU"
	.s PaiedFlag=$p($g(^DHCPEPreA(AuditID)),"^",14)
	.q:(PaiedType'="")&&(PaiedFlag="UNCHARGED")
	.s IADM=0
	.f  s IADM=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,IADM)) q:IADM=""  d
	..s Position=$G(^DHCPEDataEx("DHCPEPreIADM","Position",IADM))  //add 20121208
	..q:(Position'=Depart)&&(Depart'="")                           //add 20121208
	..s OneFee=..GetOneGTotalFee(AuditID,Type,IADM,PaiedType)
	..s TotalFee=TotalFee+OneFee
	
	q TotalFee
}

/// 得到这个人的所有公费加项金额、以及加项已付金额
ClassMethod GetOneGTotalFee(AuditID, Type, IADM, PaiedType)
{
	n (AuditID,Type,IADM,PaiedType)
	s TotalFee=0
	s PaiedFlag=$p($g(^DHCPEPreA(AuditID)),"^",14)
	q:(PaiedType'="")&&(PaiedFlag="UNCHARGED") TotalFee
	s ISub=0
	f  s ISub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,IADM,ISub)) q:ISub=""  d
	.s Stat=$p($G(^DHCPEPreIADM(IADM,"ORDITEM",ISub)),"^",16)
	.q:Stat'="1"
	.s TItemID=$p($G(^DHCPEPreIADM(IADM,"ORDITEM",ISub)),"^",4)
	.q:((Type=0)&&(TItemID=""))
	.q:((Type=1)&&(TItemID'=""))
	.s FeeSub=0
	.f  s FeeSub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,IADM,ISub,FeeSub)) q:FeeSub=""  d
	..s OneFee=$p($G(^DHCPEPreIADM(IADM,"ORDITEM",ISub,"FEE",FeeSub)),"^",2)
	..s TotalFee=TotalFee+OneFee
	s ISub=0
	f  s ISub=$o(^DHCPEPreIADM(0,"PAORDENT",AuditID,IADM,ISub)) q:ISub=""  d
	.s Stat=$p($G(^DHCPEPreIADM(IADM,"PAORDENT",ISub)),"^",9)
	.q:Stat'="1"
	.s TItemID=$p($G(^DHCPEPreIADM(IADM,"ORDENT",ISub)),"^",2)
	.q:((Type=0)&&(TItemID=""))
	.q:((Type=1)&&(TItemID'=""))
	.s FeeSub=0
	.f  s FeeSub=$o(^DHCPEPreIADM(0,"PAORDENT",AuditID,IADM,ISub,FeeSub)) q:FeeSub=""  d
	..s OneFee=$p($G(^DHCPEPreIADM(IADM,"ORDENT",ISub,"FEE",FeeSub)),"^",2)
	..s TotalFee=TotalFee+OneFee
	q TotalFee
}

ClassMethod SerchIADMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchIADMExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod SerchIADMExecute(ByRef qHandle As %Binary, GroupID As %String = "", FeeType As %String = "", Depart As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	
	i GroupID=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
 	s ind=1
 	i FeeType="I" d
 	.s IADM=0
 	.f  s IADM=$o(^DHCPEPreIADM(0,"PGADM",GroupID,IADM))  q:IADM=""  d
 	..s Position=$G(^DHCPEDataEx("DHCPEPreIADM","Position",IADM))  //add 20121210
	..q:(Position'=Depart)&&(Depart'="")                           //add 20121210
	..d Reset
	..s Fee=..GetOneITotalFee(IADM,"")
	..q:Fee=0
	..s PaiedFee=..GetOneITotalFee(IADM,"1")
	..d GetOneInfo
	..d FindBuild
	e  i FeeType="G" d 
	.s AuditID=0
	.f  s AuditID=$o(^DHCPEPreA(0,"CRMADM","G",GroupID,AuditID)) q:AuditID=""  d
	..s Flag=$p($g(^DHCPEPreA(AuditID)),"^",21)
	..q:Flag="NU"
	..s IADM=0
	..f  s IADM=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,IADM)) q:IADM=""  d
	...s Position=$G(^DHCPEDataEx("DHCPEPreIADM","Position",IADM))  //add 20121210
	...q:(Position'=Depart)&&(Depart'="")                           //add 20121210
	...s Fee=..GetOneGTotalFee(AuditID,"1",IADM,"")
	...q:(+Fee=0)
	...s PaiedFee=..GetOneGTotalFee(AuditID,"1",IADM,"1")
	...d GetOneInfo
	...d FindBuild
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneInfo
	s IBaseInfoID=$p(^DHCPEPreIADM(IADM),"^",1)
	s Str=$G(^DHCPEPreIBI(IBaseInfoID))
	s RegNo=$p(Str,"^",1)
	s Name=$p(Str,"^",2)
	s Sex=$p(Str,"^",3)
	i Sex'="" s Sex=$p(^CT("SEX",Sex),"^",2)
	s Dob=$p(Str,"^",4)
	i Dob'="" s Age=+##class(web.DHCLCNUREXCUTE).CalAge(Dob,+$H)
	
	
	q
Reset
	s (RegNo,Name,Sex,Age,Fee,PaiedFee)=""
	q 
FindBuild      
	set Data=$lb(IADM,RegNo,Name,Sex,Age,Fee,PaiedFee)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchIADMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchIADMExecute ]
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
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

Query SerchIADM(GroupID As %String = "", FeeType As %String = "", Depart As %String = "") As %Query(ROWSPEC = "TIADM:%String,TRegNo:%String,TName:%String,TSex:%String,TAge:%String,TFee:%String,TPaiedFee:%String")
{
}

ClassMethod SerchIADMItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchIADMItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod SerchIADMItemExecute(ByRef qHandle As %Binary, IADM As %String = "", FeeType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i IADM=""{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	i FeeType="I" d
 	.s AuditID=0
	.f  s AuditID=$o(^DHCPEPreA(0,"CRMADM","I",IADM,AuditID)) q:AuditID=""  d
	..s Status=$p(^DHCPEPreA(AuditID),"^",21)
	..q:Status="NU"
	..s PaiedFlag=$p(^DHCPEPreA(AuditID),"^",14)
	..s Status="已付"
	..i (PaiedFlag="UNCHARGED") s Status="未付"
	..s ItemSub=0
	..f  s ItemSub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,IADM,ItemSub)) q:ItemSub=""  d
	...s Stat=$p($G(^DHCPEPreIADM(IADM,"ORDITEM",ItemSub)),"^",16)
	...q:Stat'="1"
	...s ARCIM=$p($G(^DHCPEPreIADM(IADM,"ORDITEM",ItemSub)),"^",1)
	...s ItemName=$P($G(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1)),"^",2)
	...s FeeSub=0
	...f  s FeeSub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,IADM,ItemSub,FeeSub)) q:FeeSub=""  d
	....s FactAmount=$p(^DHCPEPreIADM(IADM,"ORDITEM",ItemSub,"FEE",FeeSub),"^",2)
	....d FindItemBuild
	..s ItemSub=0
	..f  s ItemSub=$o(^DHCPEPreIADM(0,"PAORDENT",AuditID,IADM,ItemSub)) q:ItemSub=""  d
	...s Stat=$p($G(^DHCPEPreIADM(IADM,"ORDENT",ItemSub)),"^",9)
	...q:Stat'="1"
	...s ARCIM=$p($G(^DHCPEPreIADM(IADM,"ORDENT",ItemSub)),"^",1)
	...s ItemName="(套餐)"_$p($g(^ARCOS(ARCIM)),"^",2)
	...s FeeSub=0
	...f  s FeeSub=$o(^DHCPEPreIADM(0,"PAORDENT",AuditID,IADM,ItemSub,FeeSub)) q:FeeSub=""  d
	....s FactAmount=$p(^DHCPEPreIADM(IADM,"ORDENT",ItemSub,"FEE",FeeSub),"^",2)
	....d FindItemBuild
	e  i FeeType="G" d 
	.s CRMID=$p($G(^DHCPEPreIADM(IADM)),"^",2)
	.q:CRMID=""
	.s AuditID=0
	.f  s AuditID=$o(^DHCPEPreA(0,"CRMADM","G",CRMID,AuditID)) q:AuditID=""  d
	..s Flag=$p($g(^DHCPEPreA(AuditID)),"^",21)
	..q:Flag="NU"
	..s PaiedFlag=$p($g(^DHCPEPreA(AuditID)),"^",14)
	..s Status="已付"
	..i (PaiedFlag="UNCHARGED") s Status="未付"
	..s ItemSub=0
	..f  s ItemSub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,IADM,ItemSub)) q:ItemSub=""  d
	...s Stat=$p($G(^DHCPEPreIADM(IADM,"ORDITEM",ItemSub)),"^",16)
	...q:Stat'="1"
	...s TItemID=$p($G(^DHCPEPreIADM(IADM,"ORDITEM",ItemSub)),"^",4)
	...q:(TItemID'="")
	...s ARCIM=$p($G(^DHCPEPreIADM(IADM,"ORDITEM",ItemSub)),"^",1)
	...s ItemName=$P($G(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1)),"^",2)
	...s FeeSub=0
	...f  s FeeSub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,IADM,ItemSub,FeeSub)) q:FeeSub=""  d
	....s FactAmount=$p(^DHCPEPreIADM(IADM,"ORDITEM",ItemSub,"FEE",FeeSub),"^",2)
	....d FindItemBuild
	..s ItemSub=0
	..f  s ItemSub=$o(^DHCPEPreIADM(0,"PAORDENT",AuditID,IADM,ItemSub)) q:ItemSub=""  d
	...s Stat=$p($G(^DHCPEPreIADM(IADM,"ORDENT",ItemSub)),"^",9)
	...q:Stat'="1"
	...s TItemID=$p($G(^DHCPEPreIADM(IADM,"ORDENT",ItemSub)),"^",2)
	...q:(TItemID'="")
	...s ARCIM=$p($G(^DHCPEPreIADM(IADM,"ORDENT",ItemSub)),"^",1)
	...s ItemName="(套餐)"_$p($g(^ARCOS(ARCIM)),"^",2)
	...s FeeSub=0
	...f  s FeeSub=$o(^DHCPEPreIADM(0,"PAORDENT",AuditID,IADM,ItemSub,FeeSub)) q:FeeSub=""  d
	....s FactAmount=$p(^DHCPEPreIADM(IADM,"ORDENT",ItemSub,"FEE",FeeSub),"^",2)
	....d FindItemBuild
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

FindItemBuild      
	set Data=$lb(ItemName,FactAmount,Status)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchIADMItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchIADMItemExecute ]
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
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

Query SerchIADMItem(IADM As %String = "", FeeType As %String = "") As %Query(ROWSPEC = "ItemName:%String,FactAmount:%String,Status:%String")
{
}

}
