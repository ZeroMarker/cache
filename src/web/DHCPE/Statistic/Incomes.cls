Class web.DHCPE.Statistic.Incomes Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ln
/// CreateDate：   2019-10-09
/// Description:：体检卡汇总报表
/// Table：       DHC_PE_APAmountChange
/// Input：       RegNo,Name,Status,BeginDate,EndDate,CardType
/// Output：      TRowID:卡ID,TRegNo:登记号,TCardNo:卡号,TName:姓名,TAmountRemain:剩余金额,Type:类型,TypeDesc:类型描述,Amount:金额
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.Incomes","PECardReport","","","","2020-02-01","2020-02-12","R","304")    
Query PECardReport(RegNo As %String = "", Name As %String = "", Status As %String = "", BeginDate As %String = "", EndDate As %String = "", CardType As %String = "R", CTLOCID As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TRegNo:%String,TCardNo:%String,TName:%String,TAmountRemain:%Float,Type:%String,TypeDesc:%String,Amount:%Float,Now:%String") [ SqlProc ]
{
}

ClassMethod PECardReportExecute(ByRef qHandle As %Binary, RegNo As %String = "", Name As %String = "", Status As %String = "", BeginDate As %String = "", EndDate As %String = "", CardType As %String = "R", CTLOCID As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s User=$j
	K ^TEMPDHCPE("CRegNo",User)
 	s Name=##class(web.DHCPE.DHCPECommon).UnEscape(Name)
 	i ((RegNo="")&(Name="")&(Status="")&(BeginDate="")&(EndDate="")){
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	s ^TempDHCPECardReport("CardReport")=RegNo_"^"_Name_"^"_Status_"^"_BeginDate_"^"_EndDate_"^"_CardType_"^"_CTLOCID
	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H

	i RegNo'=""
	{
		i CardType="R"
		{
			i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
			s APID=0
			f  s APID=$O(^DHCPEAP(0,"RegNo",RegNo,APID)) q:APID=""  d
			.s Sub=""
			.f  s Sub=$O(^DHCPEAP(APID,"AC",Sub),-1) q:(Sub="")||(Sub=0)  d
			..d GetOneInfoNew
		}
		else
		{
			s APID=0
			f  s APID=$O(^DHCPEAP(0,"CardNo",RegNo,APID)) q:APID=""  d
			.s Sub=""
			.f  s Sub=$O(^DHCPEAP(APID,"AC",Sub),-1) q:(Sub="")||(Sub=0)  d
			..d GetOneInfoNew
		}
	}
	elseif (Name'="")
	{
		if (CardType="R"){
			S Name=$$ALPHAUP^SSUTIL4(Name)
			s CName=$O(^PAPERi("PAPER_PatName",Name),-1)
			f  s CName=$O(^PAPERi("PAPER_PatName",CName)) q:(CName="")||(CName'[Name)  d
			.s PID=0
			.f  s PID=$O(^PAPERi("PAPER_PatName",CName,PID)) q:(PID="")  d
			..s CRegNo=$P(^PAPER(PID,"PAT",1),"^",1)
			..Q:$D(^TEMPDHCPE("CRegNo",User,CRegNo))
			..S ^TEMPDHCPE("CRegNo",User,CRegNo)=1
			..s APID=0
			..f  s APID=$O(^DHCPEAP(0,"RegNo",CRegNo,APID)) q:APID=""  d
			...s Sub=""
			...f  s Sub=$O(^DHCPEAP(APID,"AC",Sub),-1) q:(Sub="")||(Sub=0)  d
			....d GetOneInfoNew
		}else{
			S APID=0
			f  s APID=$O(^DHCPEDataEx("DHCPEAD","Info",APID)) q:APID=""  d
			.s CName=$p($G(^DHCPEDataEx("DHCPEAD","Info",APID)),"^",1)
			.q:(Name'="")&&(CName'[Name)
			.s Sub=""
			.f  s Sub=$O(^DHCPEAP(APID,"AC",Sub),-1) q:(Sub="")||(Sub=0)  d  
			..d GetOneInfoNew
		}
	}
	elseif Status'=""
	{
		s APID=0
		f  s APID=$O(^DHCPEAP(0,"Status",Status,APID)) q:APID=""  d
		.s Sub=""
		.f  s Sub=$O(^DHCPEAP(APID,"AC",Sub),-1) q:(Sub="")||(Sub=0)  d 
		..d GetOneInfoNew
	}
	else
	{
		s CDate=BeginDate-1
		f  s CDate=$O(^DHCPEAP(0,"Date",CDate)) q:(CDate="")||(CDate>EndDate)  d
		.s APID=0
		.f  s APID=$O(^DHCPEAP(0,"Date",CDate,APID)) q:(APID="")  d
		..s Sub=""
		..f  s Sub=$O(^DHCPEAP(0,"Date",CDate,APID,Sub),-1) q:(Sub="")||(Sub=0)  d
		...d GetOneInfoNew
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneInfoNew
 	s TRowID=APID
 	q:1=##class(web.DHCPE.AdvancePayment).IsCurLocCard(APID,CTLOCID)
	s TRegNo=$p($g(^DHCPEAP(TRowID)),"^",1)
	s LocID=$P(^DHCPEAP(TRowID),"^",11)
	s HospID=$p(^CTLOC(LocID),"^",22)

	q:(TRegNo="")&&(CardType'="C")
	s TCardNo=$p($g(^DHCPEAP(TRowID)),"^",2)
	s TType=$p($g(^DHCPEAP(TRowID)),"^",3)

	q:TType'=CardType
	s TAmountRemain=$p($g(^DHCPEAP(TRowID)),"^",4)
	i TAmountRemain'="" s TAmountRemain=$fn(TAmountRemain,"",2)
	s TStatus=$p($g(^DHCPEAP(TRowID)),"^",5)
	q:(Status'="")&&(TStatus'=Status)
	
	s TStatus=##class(web.DHCPE.AdvancePayment).GetStatusDesc(TStatus)
	i CardType'="C"
	{
		s ID=$O(^PAPERi("PAPMI_PatNo",TRegNo,0))
		q:ID=""
		s TName=$P(^PAPER(ID,"ALL"),"^",1)
		S TUName=$$ALPHAUP^SSUTIL4(TName)
		q:(Name'="")&&(TUName'[Name)
		s Sex=$p($g(^PAPER(ID,"ALL")),"^",7)
		s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
		s Birth=$p($g(^PAPER(ID,"ALL")),"^",6)
		;s Age=##class(web.DHCBillInterface).GetPapmiAge(ID)
		s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(ID,HospID,CTLOCID)
		s flag=##class(web.DHCPE.PreIADM).JudgeIGByRegNo(TRegNo)
		if (flag="G") s Sex="",Birth="",Age=""

	}
	else
	{
		s ID=""
		s TName=$p($G(^DHCPEDataEx("DHCPEAD","Info",TRowID)),"^",1)
		s Sex=$p($G(^DHCPEDataEx("DHCPEAD","Info",TRowID)),"^",2)
		s Age=$p($G(^DHCPEDataEx("DHCPEAD","Info",TRowID)),"^",3)
        q:TName'[Name
	}
    
	s TypeDesc=""
	s ACDate=$p($g(^DHCPEAP(TRowID,"AC",Sub)),"^",5)
	q:(BeginDate'="")&&(BeginDate>ACDate)
	q:(EndDate'="")&&(EndDate<ACDate)
	s Type=$p($g(^DHCPEAP(TRowID,"AC",Sub)),"^",1)
	s TypeDesc=##class(web.DHCPE.AdvancePayment).GetTypeDesc(Type)
	s Amount=$p($g(^DHCPEAP(TRowID,"AC",Sub)),"^",2)
	d FindBuildNew
	
	q 	
FindBuildNew  
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))   
	set Data=$lb(TRowID,TRegNo,TCardNo,TName,TAmountRemain,Type,TypeDesc,Amount,Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PECardReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PECardReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod PECardReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PECardReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      ln
/// CreateDate：   2019-10-10
/// Description:：体检卡明细报表
/// Table：       DHC_PE_APAmountChange
/// Input：       RegNo,Name,Status,BeginDate,EndDate,CardType
/// Output：      TRowID:明细ID,TRegNo:登记号,TRemainAmount:剩余金额,TType:类型,TAmount:金额,TSourceNo:单据号,TDate:日期,TTime:时间,TUser:操作员,TRemark:备注,TName:姓名,TPayMode:支付方式,TCardNo:代金卡号,TSex:性别,TAge:年龄
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.Incomes","SearchCardDetail","175")    
Query SearchCardDetail(APID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRegNo:%String,TRemainAmount:%String,TType:%String,TAmount:%String,TSourceNo:%String,TDate:%String,TTime:%String,TUser:%String,TRemark:%String,TName:%String,TPayMode:%String,TCardNo:%String,TSex:%String,TAge:%String") [ SqlProc ]
{
}

ClassMethod SearchCardDetailExecute(ByRef qHandle As %Binary, APID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i (APID=""){
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	s Sub=0
	f  s Sub=$O(^DHCPEAP(APID,"AC",Sub)) q:(Sub="")  d
	.s TRowID=APID_"||"_Sub
	.s CType=$p($g(^DHCPEAP(APID)),"^",3)
	.i CType="R" d
	..s TRegNo=$p($g(^DHCPEAP(APID)),"^",1)
	.e  d
	..s TCardNo=$p($g(^DHCPEAP(APID)),"^",2)
	.s LocID=$P(^DHCPEAP(APID),"^",11)
	.s HospID=$p(^CTLOC(LocID),"^",22)
	.s TType=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",1)
	.s TAmount=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",2)
	.s TRemainAmount=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",3)
	.s TSourceNo=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",4)
	.s InvoID=TSourceNo
	.s InvName=""
	.s:InvoID'="" InvName=$G(^DHCPEDataEx("AdvancePayment","InvName",InvoID))
	.i TType="RF" d
	..s InvoID=$p($g(^DHCPEAP(+TSourceNo,"AC",$p(TSourceNo,"||",2))),"^",4)
	..s:InvoID'="" InvName=$G(^DHCPEDataEx("AdvancePayment","InvName",InvoID))
	..s TSourceNo="退"_$p($g(^DHCPEAP(+TSourceNo,"AC",$p(TSourceNo,"||",2))),"^",4)
	.i (TType="B")||(TType="R") d
	..q:'$D(^DHCPEAP(0,"SourceNo","RF",TRowID))
	..s TSourceNo=TSourceNo_"(已退)"
	.s TTypeDesc=""
	.I TType'="" s TTypeDesc=##class(web.DHCPE.AdvancePayment).GetTypeDesc(TType)
	.s TDate=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",5)
	.s TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
	.s TTime=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",6)
	.s:TTime'="" TTime=##class(websys.Conversions).TimeLogicalToHtml(TTime)
	.s TUser=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",7)
	.s:TUser'="" TUser=$P(^SSU("SSUSR",TUser),"^",2)
	.s TRemark=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",8)
	.i TType="B" s TRemark=$p($g(^DHCPEAP(APID)),"^",9)
	.s TPayMode=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",10)
	.i TPayMode'="" d
	..s TPayMode=$P($G(^CT("CTPM",TPayMode)),"^",2)
	..i $g(^DHCPEDataEx("DHCPEAD","paymode",APID_"||"_Sub))'=""  d
	...s TPayMode=TPayMode_"("_$g(^DHCPEDataEx("DHCPEAD","paymode",APID_"||"_Sub))_")"
	.s Sex=""
	.i CType="R" d
	..s ID=$O(^PAPERi("PAPMI_PatNo",TRegNo,0))
	..s TName=$P(^PAPER(ID,"ALL"),"^",1)
	..s Sex=$p($g(^PAPER(ID,"ALL")),"^",7)
	..s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
	..s Birth=$p($g(^PAPER(ID,"ALL")),"^",6)
	..S Birth=##class(websys.Conversions).DateLogicalToHtml(Birth)
	..;S Age=##class(web.DHCBillInterface).GetPapmiAge(ID)
	..s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(ID,HospID,LocID)
	..s flag=##class(web.DHCPE.PreIADM).JudgeIGByRegNo(TRegNo)
	..if (flag="G") s Sex="",Birth="",Age=""
	.e  d
	..i TTypeDesc="结算" d
	...s PAADM=$P($G(^DHCPB(TSourceNo)),"^",1)
	...q:PAADM=""
	...s PatID=$P($g(^PAADM(PAADM)),"^",1)
	...s TRegNo=$P($G(^PAPER(PatID,"PAT",1)),"^",1)
	...s TName=$P(^PAPER(PatID,"ALL"),"^",1)
	...s Sex=$p($g(^PAPER(PatID,"ALL")),"^",7)
	...s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
	...s Birth=$p($g(^PAPER(PatID,"ALL")),"^",6)
	...S Birth=##class(websys.Conversions).DateLogicalToHtml(Birth)
	...;S Age=##class(web.DHCBillInterface).GetPapmiAge(PatID)
	...s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PatID,HospID,LocID)
	...s flag=##class(web.DHCPE.PreIADM).JudgeIGByRegNo(TRegNo)
	...if (flag="G") s Sex="",Birth="",Age=""
	..e  i (TTypeDesc="转入")||(TTypeDesc="转出") d
	...s TName=$p($G(^DHCPEDataEx("DHCPEAD","Info",APID)),"^",1)
	...s Sex=$p($G(^DHCPEDataEx("DHCPEAD","Info",APID)),"^",2)
	..e  i TTypeDesc="退预缴金" d
	...s TSourceNo="退"_$p($g(^DHCPEAP(+TRowID,"AC",$p(TRowID,"||",2))),"^",4)
	...s TName=$p($G(^DHCPEDataEx("DHCPEAD","InvID",$p($g(^DHCPEAP(+TRowID,"AC",$p(TRowID,"||",2))),"^",4))),"^",1)
	...s Sex=$p($G(^DHCPEDataEx("DHCPEAD","InvID",$p($g(^DHCPEAP(+TRowID,"AC",$p(TRowID,"||",2))),"^",4))),"^",2)
	...s Age=$p($G(^DHCPEDataEx("DHCPEAD","InvID",$p($g(^DHCPEAP(+TRowID,"AC",$p(TRowID,"||",2))),"^",4))),"^",3)
    ...s Birth=""
	..e  d
	...s TName=$p($G(^DHCPEDataEx("DHCPEAD","InvID",TRowID)),"^",1)
	...s Sex=$p($G(^DHCPEDataEx("DHCPEAD","InvID",TRowID)),"^",2)
	...s Age=$p($G(^DHCPEDataEx("DHCPEAD","InvID",TRowID)),"^",3)
    ...s Birth=""
	.d FindDetail
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 	
FindDetail      
	set Data=$lb(TRowID,TRegNo,$j(TRemainAmount,3,2),TTypeDesc,$j(TAmount,3,2),TSourceNo,TDate,TTime,TUser,TRemark,TName,TPayMode,TCardNo,Sex,Age)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchCardDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchCardDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchCardDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchCardDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      sxt
/// CreateDate：   2019-11-13
/// Description:：团体费用信息
/// Table：       DHC_PE_GADM,  DHC_PE_PreGteam,DHC_pe_preiorditem,DHC_pe_preiorditemfee,DHC_pe_preiordent,DHC_pe_preiordentfee
/// Input：       BeginDate,EndDate,GADM:DHC_PE_GADM的ID
/// Output：      Date:团体登记日期,GroupName:团体名,AllNum,CheckedNum:已检人数,UnCheckedNum:未检人数,GAccountFee:公费应收,GFactFee:公费实际,GPayedFee:公费实收,GNoPayedFee:公费未收,IAccountFee:自费应收,IFactFee:自费实际,IPayedFee:自费实收,INoPayedFee:自费未收
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.Incomes","GroupIncome","","","170","304")                       
Query GroupIncome(BeginDate As %Library.String = "", EndDate As %Library.String = "", GADM As %Library.String = "", CTLOCID As %Library.String = "") As %Query(ROWSPEC = "Date:%String,GroupName:%String,AllNum:%Float,CheckedNum:%Float,UnCheckedNum:%Float,GAccountFee:%Float,GFactFee:%Float,GPayedFee:%Float,GNoPayedFee:%Float,IAccountFee:%Float,IFactFee:%Float,IPayedFee:%Float,INoPayedFee:%Float,CurGADM:%String,Now:%String") [ SqlProc ]
{
}

ClassMethod GroupIncomeExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, GADM As %Library.String = "", CTLOCID As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((BeginDate="")&(EndDate="")&(GADM=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s ^TempDHCPEGroupIncome("GroupIncome")=BeginDate_"^"_EndDate_"^"_GADM_"^"_CTLOCID
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H

	i +GADM=0 s GADM=""
	
	i GADM'="" d
	.s CurGADM=GADM
	.d OutGroupInfo
	e  d
	.s Date=BeginDate-1
	.f  s Date=$o(^DHCPEGADM(0,"AdmDateTime",Date)) q:(Date="")||(Date>EndDate)  d
	..s Time=""
	..f  s Time=$o(^DHCPEGADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
	...s CurGADM=""
	...f  s CurGADM=$o(^DHCPEGADM(0,"AdmDateTime",Date,Time,CurGADM)) q:(CurGADM="")  d
	....d OutGroupInfo
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutGroupInfo
    s PreGADM=$p($G(^DHCPEGADM(CurGADM)),"^",2)
    q:PreGADM=""
    q:(##class(web.DHCPE.PreCommon).GetLocFlag("GADM",CurGADM,CTLOCID)=1)
    s GADMStatus=$p($G(^DHCPEGADM(CurGADM)),"^",6)
    q:GADMStatus="CANCELPE"
	s GBI=$p(^DHCPEGADM(CurGADM),"^",1)
	s AdmDate=$p(^DHCPEGADM(CurGADM),"^",4)
	s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
	s GName=$p(^DHCPEGBI(GBI),"^",2)
	s CheckedNum=0,UnCheckedNum=0,GAccountFee=0,GPayedFee=0,GNoPayedFee=0,IAccountFee=0,IPayedFee=0,INoPayedFee=0,GFactFee=0,IFactFee=0
	s Nums=..GetTotalPerson(PreGADM)
	s AllNum=$p(Nums,"^",1)
	s CheckedNum=$p(Nums,"^",2)
	s UnCheckedNum=AllNum-CheckedNum
	s PreIADM=""
	f  s PreIADM=$o(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:(Status["CAN")
	.s OneFeeInfo=..GetAdmFee(PreIADM)
	.s GAccountFee=GAccountFee+$p(OneFeeInfo,"^",9)
	.s GFactFee=GFactFee+$p(OneFeeInfo,"^",3)
	.s GPayedFee=GPayedFee+$p(OneFeeInfo,"^",4)
	.s GNoPayedFee=GNoPayedFee+$p(OneFeeInfo,"^",5)
	.s IAccountFee=IAccountFee+$p(OneFeeInfo,"^",10)
	.s IFactFee=IFactFee+$p(OneFeeInfo,"^",6)
	.s IPayedFee=IPayedFee+$p(OneFeeInfo,"^",7)
	.s INoPayedFee=INoPayedFee+$p(OneFeeInfo,"^",8)
	d GroupIncome
	
	q
GroupIncome
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(AdmDate,GName,AllNum,CheckedNum,UnCheckedNum,GAccountFee,GFactFee,GPayedFee,GNoPayedFee,IAccountFee,IFactFee,IPayedFee,INoPayedFee,CurGADM,Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GroupIncomeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupIncomeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		Set AtEnd=1
		Set Row=""		
	}
	  Else 
	{
		Set Row=^CacheTemp(repid,ind)
		}
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod GroupIncomeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupIncomeExecute ]
{
	Set repid=$LIST(qHandle,2)
	kill ^cacheTemp(repid)
	Quit $$$OK
}

/// Creator：      sxt
/// CreateDate：   2019-11-13
/// Description:：团体费用信息
/// Table：       DHC_PE_IADM
/// Input：       GADM:DHC_PE_GADM的ID,Type:Y:已检 N:未检,CTLOCID:科室ID
/// Output：      RegNo:登记号,Name:姓名,Sex:性别,Age:年龄,VIPLevel:类型,Tel:联系电话,GroupName:团体名称,GAccountFee:公费应收,GFactFee:公费实际,GPayedFee:公费实收,GNoPayedFee:公费未收,IAccountFee:自费应收,IFactFee:自费实际,IPayedFee:自费实收,INoPayedFee:自费未收
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.GroupFeeStatistic","GroupFeeStatisticDetail","475","Y")                       
Query GroupFeeStatisticDetail(GADM As %Library.String = "", Type As %Library.String = "") As %Query(ROWSPEC = "RegNo:%String,Name:%String,Sex:%String,Age:%String,VIPLevel:%String,Tel:%String,GroupName:%String,TeamName:%String,GAccountFee:%Float,GFactFee:%Float,GPayedFee:%Float,GNoPayedFee:%Float,IAccountFee:%Float,IFactFee:%Float,IPayedFee:%Float,INoPayedFee:%Float") [ SqlProc ]
{
}

ClassMethod GroupFeeStatisticDetailExecute(ByRef qHandle As %Binary, GADM As %Library.String = "", Type As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i (GADM="")
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
	s PreGADM=$p(^DHCPEGADM(GADM),"^",2)
	s PreIADM=""
	f  s PreIADM=$o(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:(PreIADM="")  d
	.s status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:(status["CAN")
	.
	.s CheckedFlag="N"
	.s PEIADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.i PEIADM'="" d
	..s PAADM=$p($G(^DHCPEIADM(PEIADM)),"^",1)
	..s RLTDR=$o(^DHCPERLT(0,"ADM",PAADM,0))
	..s:(RLTDR'="") CheckedFlag="Y"
	.q:(CheckedFlag'=Type)&&(Type'="")
	.s Info=##class(web.DHCPE.Statistic.WorkStatistic).GetBaseInfo("PreADM",PreIADM)
	.s OneFeeInfo=..GetAdmFee(PreIADM)
	.d GroupIncomeDetail
	

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GroupIncomeDetail
	set Data=$lb($p(Info,"^",1),$p(Info,"^",2),$p(Info,"^",3),$p(Info,"^",4),$p(Info,"^",5),$p(Info,"^",6),$p(Info,"^",8),$p(Info,"^",9),$p(OneFeeInfo,"^",9),$p(OneFeeInfo,"^",3),$p(OneFeeInfo,"^",4),$p(OneFeeInfo,"^",5),$p(OneFeeInfo,"^",10),$p(OneFeeInfo,"^",6),$p(OneFeeInfo,"^",7),$p(OneFeeInfo,"^",8))
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GroupFeeStatisticDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupFeeStatisticDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		Set AtEnd=1
		Set Row=""		
	}
	  Else 
	{
		Set Row=^CacheTemp(repid,ind)
		}
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod GroupFeeStatisticDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupFeeStatisticDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	kill ^cacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTotalPerson(id)
{
	s i=0
	s j=0
	s iAdm=0
	f  s iAdm=$o(^DHCPEPreIADM(0,"PGADM",id,iAdm)) q:iAdm=""  d
	.s Status=$p(^DHCPEPreIADM(iAdm),"^",8)
	.q:(Status["CAN")
	.s i=i+1
	.s PEIADM=$o(^DHCPEIADM(0,"CRMADM",iAdm,0))
	.q:PEIADM=""
	.s PAADM=$p($G(^DHCPEIADM(PEIADM)),"^",1)
	.q:PAADM=""
	.//q:..OrderIsExecByPAAdm(PAADM)=0 //存在已执行项目即算是已检
	.s RLTDR=$o(^DHCPERLT(0,"ADM",PAADM,0))
	.q:RLTDR=""
	.s j=j+1
	q i_"^"_j
}

/// 根据preiadmid获取个人的费用信息
/// 返回   应付金额^最终金额^公费金额^公费已付^公费未付^自费金额^自费已付^自费未付^公费原价^自费原价
/// w ##Class(web.DHCPE.Statistic.Incomes).GetAdmFee("1034")
ClassMethod GetAdmFee(preiadmid, Type As %Library.String = "")
{
	q:preiadmid="" ""
	s itemsub=""
	s (AccountSum,FactSum,PublicSum,PubllicPayed,SelfSum,SelfPayed,SelfUnPayed,GAccountSum,IAccountSum)=0
	s errs=""
	
	//医嘱费用
	f  s itemsub=$o(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub)) q:((itemsub="")||(errs'=""))  d
	.s itemstat=$p($g(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub)),"^",16)
	.q:itemstat'="1"
	.s (AccountAmount,GAccountAmount,IAccountAmount)=0
	.s AccountAmount=$p($g(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub)),"^",14)
	.s IFeePart=..GetItemFeePart(preiadmid_"||"_itemsub,"ORDITEM")
	.i IFeePart=1 d
	..s GAccountAmount=AccountAmount
	..s IAccountAmount=AccountAmount
	.e  d
	..s FeeAmount=..GetItemFeeAmount(preiadmid_"||"_itemsub,"ORDITEM")
	..s IAccountAmount=$p(FeeAmount,"^",1)
	..s GAccountAmount=$p(FeeAmount,"^",2)
	.b ;11
	.s AccountSum=AccountSum+AccountAmount
	.s feesub=0
	.f  s feesub=$o(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub,"FEE",feesub)) q:((feesub="")||(errs'=""))  d
	..s feedata=$g(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub,"FEE",feesub))	
	..s preauditid=$p(feedata,"^",5)
	..s publicflag=0
	..s payedflag=0
	..q:preauditid=""
	..s UseFlag=$p($g(^DHCPEPreA(preauditid)),"^",21)
	..q:UseFlag="NU"
	..i $p($g(^DHCPEPreA(preauditid)),"^",1)="G" s publicflag=1
	..i ($p($g(^DHCPEPreA(preauditid)),"^",14)="CHARGED")&&('$D(^DHCPEPreA("AsCharged",preauditid))) s payedflag=1   //定额卡支付的不算已付
	..s factamount=+$p(feedata,"^",2)
	..s FactSum=FactSum+factamount
	..i publicflag=1  d
	...s PublicSum=PublicSum+factamount
	...i payedflag=1 s PubllicPayed=PubllicPayed+factamount
	...s GAccountSum=GAccountSum+GAccountAmount
	..e  d
	...s SelfSum=SelfSum+factamount
	...s IAccountSum=IAccountSum+IAccountAmount
	...i payedflag=1 s SelfPayed=SelfPayed+factamount
	
	//医嘱套费用
	f  s itemsub=$o(^DHCPEPreIADM(preiadmid,"ORDENT",itemsub)) q:((itemsub="")||(errs'=""))  d
	.s itemstat=$p($g(^DHCPEPreIADM(preiadmid,"ORDENT",itemsub)),"^",9)
	.q:itemstat'="1"
	.s (AccountAmount,GAccountAmount,IAccountAmount)=0
	.s AccountAmount=$p($g(^DHCPEPreIADM(preiadmid,"ORDENT",itemsub)),"^",7)
	.s AccountSum=AccountSum+AccountAmount
	.s IFeePart=..GetItemFeePart(preiadmid_"||"_itemsub,"ORDENT")
	.i IFeePart=1 d
	..s GAccountAmount=AccountAmount
	..s IAccountAmount=AccountAmount
	.e  d
	..s FeeAmount=..GetItemFeeAmount(preiadmid_"||"_itemsub,"ORDENT")
	..s IAccountAmount=$p(FeeAmount,"^",1)
	..s GAccountAmount=$p(FeeAmount,"^",2)
	.s feesub=0
	.f  s feesub=$o(^DHCPEPreIADM(preiadmid,"ORDENT",itemsub,"FEE",feesub)) q:((feesub="")||(errs'=""))  d
	..s feedata=$g(^DHCPEPreIADM(preiadmid,"ORDENT",itemsub,"FEE",feesub))	
	..s preauditid=$p(feedata,"^",5)
	..s publicflag=0
	..s payedflag=0
	..q:preauditid=""
	..s UseFlag=$p($g(^DHCPEPreA(preauditid)),"^",21)
	..q:UseFlag="NU"
	..i $p($g(^DHCPEPreA(preauditid)),"^",1)="G" s publicflag=1
	..i ($p($g(^DHCPEPreA(preauditid)),"^",14)="CHARGED")&&('$D(^DHCPEPreA("AsCharged",preauditid))) s payedflag=1  //定额卡支付的不算已付
	..s factamount=+$p(feedata,"^",2)
	..s FactSum=FactSum+factamount
	..i publicflag=1  d
	...s PublicSum=PublicSum+factamount
	...i payedflag=1 s PubllicPayed=PubllicPayed+factamount
	...s GAccountSum=GAccountSum+GAccountAmount
	..e  d
	...s IAccountSum=IAccountSum+IAccountAmount
	...s SelfSum=SelfSum+factamount
	...i payedflag=1 s SelfPayed=SelfPayed+factamount
	
	s PubllicUnPayed=PublicSum-PubllicPayed
	s SelfUnPayed=SelfSum-SelfPayed
	
	q:Type="1" GAccountSum_"^"_PublicSum_"^"_PubllicPayed_"^"_PubllicUnPayed_"^"_IAccountSum_"^"_SelfSum_"^"_SelfPayed_"^"_SelfUnPayed
	q AccountSum_"^"_FactSum_"^"_PublicSum_"^"_PubllicPayed_"^"_PubllicUnPayed_"^"_SelfSum_"^"_SelfPayed_"^"_SelfUnPayed_"^"_GAccountSum_"^"_IAccountSum
}

/// 项目：Type:ORDITEM   套餐：Type:ORDENT
/// w ##class(web.DHCPE.Statistic.Incomes).GetItemFeePart("1034||7","ORDITEM")
/// w ##class(web.DHCPE.Statistic.Incomes).GetItemFeePart("14080||1","ORDENT")
ClassMethod GetItemFeePart(FID, Type)
{
	n PIADM,sub,FSub,i
	s i=0,IPADR="",GPADR=""
	s PIADM=$p(FID,"||",1)
	s sub=$p(FID,"||",2)
	s FSub=0
	f  s FSub=$o(^DHCPEPreIADM(PIADM,Type,sub,"FEE",FSub)) q:FSub=""  d
	.s PADR=$p(^DHCPEPreIADM(PIADM,Type,sub,"FEE",FSub),"^",5)
	.q:PADR=""
	.s ADMType=$p(^DHCPEPreA(PADR),"^",1)
	.i ADMType="I" s IPADR=PADR
	.i ADMType="G" s GPADR=PADR
	.s i=i+1
	
	i (i=2)&&(IPADR'="")&&(GPADR'="") q 2
	q 1
}

/// 项目：Type:ORDITEM   套餐：Type:ORDENT
/// w ##class(web.DHCPE.Statistic.Incomes).GetItemFeeAmount("1034||7","ORDITEM")
/// w ##class(web.DHCPE.Statistic.Incomes).GetItemFeeAmount("14080||1","ORDENT")
ClassMethod GetItemFeeAmount(FID, Type)
{
	n PIADM,sub,FSub,i
	s IAAmount="",GAAmount=""
	s PIADM=$p(FID,"||",1)
	s sub=$p(FID,"||",2)
	s FSub=0
	f  s FSub=$o(^DHCPEPreIADM(PIADM,Type,sub,"FEE",FSub)) q:FSub=""  d
	.s PADR=$p(^DHCPEPreIADM(PIADM,Type,sub,"FEE",FSub),"^",5)
	.q:PADR=""
	.s Amount=$p(^DHCPEPreIADM(PIADM,Type,sub,"FEE",FSub),"^",2)
	.s ADMType=$p(^DHCPEPreA(PADR),"^",1)
	.s Rebate=$p(^DHCPEPreA(PADR),"^",5)
	.i (Rebate'="")&&(Rebate'=0) s Amount=Amount/Rebate*100	
	.i ADMType="I" s IAAmount=Amount
	.i ADMType="G" s GAAmount=Amount
	
	q IAAmount_"^"_GAAmount
}

/// 按结算日期统计收费员的情况  DHCPEChargedReport.raq    DHCPEChargedReportUserDetail.raq
/// 查询条件：发票结算开始日期、结束日期、收费员（工号）  Type:InvUser  查询收费员统计    Type:InvInfo 收款明细   RefInvInfo 退款明细   NotInvNoInfo 未打发票明细
/// 输出列表：工号、姓名、收款金额，发票张数（附详细名单），退款金额，退款发票张数（附详细名单），未打发票数（附详细名单），金额
/// 输出列表：发票ID 发票号 登记号 姓名 性别 年龄 金额 收费状态 收费员 收费日期时间 被退费的发票号 支付方式 凑整费 发票名称 分币误差 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.Incomes","ChargedReport","2020-02-04","2020-02-04","tj01","RefInvInfo",304)
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.Incomes","ChargedReport","2019-02-01","2019-02-28","tjzx","InvNoInfo",304)
/// call web_DHCPE_Statistic.Incomes_ChargedReport("2019-02-01","2019-02-28","","InvUser",304)
Query ChargedReport(BeginDate As %String = "", EndDate As %String = "", UserCode As %String = "", Type As %String = "", CurLoc As %String = "") As websys.Query(ROWSPEC = "InvUser:%String,tUserCode:%String,tUserName:%String,tInvAmount:%Float,tInvNum:%Float,tRefInvAmount:%Float,tRefInvNum:%Float,tNotInvNoAmount:%Float,tNotInvNoNum:%Float,tTotalAmount:%Float,tInvId:%String,tInvNo:%String,tRegNo:%String,tName:%String,tSex:%String,tAge:%String,tAmount:%Float,tInvFlag:%String,tInvDate:%String,tInvTime:%String,tRfInvNo:%String,tPayMode:%String,tRoundInfo:%Float,tInvName:%String,tFBWC:%Float,Now:%String") [ SqlProc ]
{
}

ClassMethod ChargedReportExecute(ByRef qHandle As %Binary, BeginDate As %String = "", EndDate As %String = "", UserCode As %String = "", Type As %String = "", CurLoc As %String = "") As %Status
{
	Set ind=1
	Set repid=$I(^CacheTemp)
	
	s ^TempDHCPEChargedReport("ChargedReport")=BeginDate_"^"_EndDate_"^"_UserCode_"^"_Type_"^"_CurLoc
	if ((BeginDate="")||(EndDate="")) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	if ((Type'="InvUser")&&(UserCode="")) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s UserID=""
	if (UserCode'="") {
		s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
		s UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
		if (UserID="") {
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
	}
	s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	if (BeginDate>EndDate) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s job=$j
	k ^TempDHCPEChargedReport(job)
	
	if UserID'="" {
		s Date=BeginDate-1
		f  s Date=$o(^DHCPEINVPRT(0,"USER",UserID,Date)) q:((Date="")||(Date>EndDate))  d
		.s InvId=0
		.f  s InvId=$o(^DHCPEINVPRT(0,"USER",UserID,Date,InvId)) q:(InvId="")  d
		..s InvData=$g(^DHCPEINVPRT(InvId))
		..d ChargedReport
		
	} else {
		s Date=BeginDate-1
		f  s Date=$o(^DHCPEINVPRT(0,"DATE",Date)) q:((Date="")||(Date>EndDate))  d
		.s InvId=0
		.f  s InvId=$o(^DHCPEINVPRT(0,"DATE",Date,InvId)) q:(InvId="")  d
		..s InvData=$g(^DHCPEINVPRT(InvId))
		..d ChargedReport
	}
	if '$d(^TempDHCPEChargedReport(job,"UserID")) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
 	
 	s userid=""
 	f {
	 	s userid=$o(^TempDHCPEChargedReport(job,"UserID",userid))
	 	q:userid=""
		d SetChargedReportVariable
		s tUserCode=$p($g(^SSU("SSUSR",userid)),"^",1)  // 工号
		s tUserName=$p($g(^SSU("SSUSR",userid)),"^",2)  // 姓名
		s tInvId=""
		if (Type="InvUser") {
	 		s tInvAmount=$p($g(^TempDHCPEChargedReport(job,"UserID",userid,"InvInfo")),"^",1)
	 		s tInvNum=+$p($g(^TempDHCPEChargedReport(job,"UserID",userid,"InvInfo")),"^",2)
	 		s tRefInvAmount=$p($g(^TempDHCPEChargedReport(job,"UserID",userid,"RefInvInfo")),"^",1)
	 		s tRefInvNum=+$p($g(^TempDHCPEChargedReport(job,"UserID",userid,"RefInvInfo")),"^",2)
	 		s tNotInvNoAmount=$p($g(^TempDHCPEChargedReport(job,"UserID",userid,"NotInvNoInfo")),"^",1)
	 		s tNotInvNoNum=+$p($g(^TempDHCPEChargedReport(job,"UserID",userid,"NotInvNoInfo")),"^",2)
	 		s tTotalAmount=tInvAmount+tNotInvNoAmount+tRefInvAmount  // 总金额(收款+未打-退款)
	 		d OutReportList
			//Set Data=$LB(tUserCode,tUserName,tInvAmount,tInvNum,tRefInvAmount,tRefInvNum,tNotInvNoAmount,tNotInvNoNum)
	 	} else {
		 	s tInvId=""
		 	f  s tInvId=$o(^TempDHCPEChargedReport(job,"UserID",userid,Type,tInvId)) q:tInvId=""  d
		 	.s tPreA="",tInvNo=""
		 	.s InvData=$g(^DHCPEINVPRT(tInvId))
		 	.s tInvNo=$p(InvData,"^",1)
		 	.s FocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_tInvId,""))
		 	.i FocusPrintID'="" d
	        ..s RealInvNo=$LG(^User.DHCPEINVFocusPrtD(FocusPrintID),3)
	        ..s tInvNo=tInvNo_"("_RealInvNo_")"
		 	.s PAADM=$p(InvData,"^",2)
		 	.s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
		 	.s (tRegNo,tName,tSex,tAge)=""
		 	.i IADM'="" d
		 	..s PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
		 	..s PreIBI=$p($g(^DHCPEPreIADM(PreIADM)),"^",1)
		 	..s PreIBaseData=$g(^DHCPEPreIBI(PreIBI))
			..// --------------- 基本信息 --------------- //
		 	..s tRegNo=$p($g(^DHCPEPreIBI(PreIBI)),"^",1)
		 	..s tName=$p($g(^DHCPEPreIBI(PreIBI)),"^",2)
			..s Sex=$p(PreIBaseData,"^",3),tSex=""
			..s:Sex'="" tSex=$p($g(^CT("SEX",Sex)),"^",2)
			..S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",tRegNo,0))
	        ..i PAPMIRowId'="" s tAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId,PAADM)  // 年龄
	        .e  d
	        ..s GADM=$o(^DHCPEGADM(0,"DelegateADM",PAADM,0))
	        ..s PreGADM=$p(^DHCPEGADM(GADM),"^",2)
	        ..s PGBI=$p(^DHCPEPreGADM(PreGADM),"^",1)
	        ..s tRegNo=$p(^DHCPEPreGBI(PGBI),"^",13)
	        ..s tName=$p(^DHCPEPreGBI(PGBI),"^",2)
			.
			.// --------------- 发票信息 --------------- //
			.s tAmount=$p(InvData,"^",7)
			.s tInvFlag=$p(InvData,"^",8)
			.s tInvFlag=##class(web.DHCPE.InvPrt).ParseInvFlag(tInvFlag)
			.s hasDrop=$o(^DHCPEINVPRT(0,"REF",tInvId,""))
			.i hasDrop'="" d
			..s DropInvData=$g(^DHCPEINVPRT(hasDrop))
			..s TDropInvFlag=$p(DropInvData,"^",8)
		    ..s TDropInvFlag=##class(web.DHCPE.InvPrt).ParseInvFlag(TDropInvFlag)
		    ..i TDropInvFlag="作废" s tInvFlag=TDropInvFlag  //与门诊保持一致
		 	.;s:tInvFlag="N" tInvFlag="正常"
			.;s:tInvFlag="A" tInvFlag="作废"
			.;s:tInvFlag="S" tInvFlag="冲红"
			.s tInvDate=$p(InvData,"^",11)
			.s:tInvDate'="" tInvDate=##class(websys.Conversions).DateLogicalToHtml(tInvDate)
			.s tInvTime=$p(InvData,"^",12)
			.s:tInvTime'="" tInvTime=##class(websys.Conversions).TimeLogicalToHtml(tInvTime)
			.
			.// 退费发票信息
			.s tRfInvNo=""
			.s tRfInvID=$p(InvData,"^",9)
			.i tRfInvID'="" d
			..s tRfInvNo=$P($G(^DHCPEINVPRT(tRfInvID)),"^",1)
			..s RFocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_tRfInvID,""))
			..i RFocusPrintID'="" d
			...s RealInvNo=$LG(^User.DHCPEINVFocusPrtD(RFocusPrintID),3)
			...s tRfInvNo=tRfInvNo_"("_RealInvNo_")"
			.
			.s tFBWC=$p(InvData,"^",21)  // 分币误差
			.s tAmount=tAmount+tFBWC
			.
			.s tInvName=$G(^DHCPEDataEx("InvName",tInvId))  // 抬头
			.
			.// --------------- 支付方式 --------------- //
			.s tPayMode="",tRoundInfo=""
			.s ARRCP=$p(InvData,"^",4)
			.s pm=0 f  s pm=$o(^ARRCP(ARRCP,"PAYM",pm)) q:pm=""  d
    		..s tData=$g(^ARRCP(ARRCP,"PAYM",pm))
    		..s pymode=$p(tData,"^",1)
    		..q:'$d(^CT("CTPM",pymode))
    		..s chequeno=$p(tData,"^",4)   
    		..i pymode'="" s pmdesc=$p($g(^CT("CTPM",pymode)),"^",2)
    		..e  s pmdesc="现金"
    		
    		..s payamt=+$p(tData,"^",3)
    		..s payamt=$fn(payamt,"",2)
    		..s:chequeno'="" payamt=payamt_"("_chequeno_")"
    		..i tPayMode="" s tPayMode=pmdesc_":"_payamt
    		..e  s tPayMode=tPayMode_","_pmdesc_":"_payamt
			.// --------------- 分币误差 --------------- //
    		.//s tRoundInfo=##class(web.DHCPE.CashierEx).GetRoundFee(tInvId) 
    		.s tRoundInfos=##class(web.DHCPE.CashierEx).GetRoundFee(tInvId)
    		.s len=$l(tRoundInfos,"$$")
    		.f i=1:1:len d
    		..q:$p(tRoundInfos,"$$",i)=""
    		..s tRoundInfo=+tRoundInfo+$p($p(tRoundInfos,"$$",i),"^",3)
		 	.d OutReportList
		 	.
	 	}
 	}
 	
 	k ^TempDHCPEChargedReport(job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
SetChargedReportVariable
	// 收费员工号 收费员姓名
	s (tUserCode,tUserName)=""
	// 收款金额 发票张数 退款金额 退款发票张数 未打发票金额 未打发票数 总金额(收款+未打-退款)
	s (tInvAmount,tInvNum,tRefInvAmount,tRefInvNum,tNotInvNoAmount,tNotInvNoNum,tTotalAmount)=0
	// 发票号 登记号 姓名 性别 年龄 金额 收费状态 收费员 收费日期时间 被退费的发票号 支付方式 凑整费 发票名称 分币误差 
	s (tInvNo,tRegNo,tName,tSex,tAge,tAmount,tInvFlag,tUserName,tInvDate,tInvTime,tRfInvNo,tPayMode,tRoundInfo,tInvName,tFBWC)=""
	q
ChargedReport
	s InvNo=$p(InvData,"^",1)  // 发票号
	q:InvNo["DHCPEYJS"
	s PAADM=$p(InvData,"^",2)  // 就诊号
	s InvAmt=$p(InvData,"^",7)  // 发票金额
	s tFBWC=$p(InvData,"^",21)  // 分币误差
	s InvAmt=InvAmt+tFBWC
	s InvFlag=$p(InvData,"^",8)  // 发票标志
	s RefInvId=$p(InvData,"^",9)  // 退费发票
	s InvUser=$p(InvData,"^",10)  // 结算人
	
	s PAADM=$p(InvData,"^",2)
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM,CurLoc) 
	q:LocFlag=1
		 	
	s NotInvNoFlag=##class(web.DHCPE.CashierEx).GetSSPFlag(InvId)  // 判断是否未打发票
	
	if (InvFlag="N") {
		if (NotInvNoFlag="1") {  // 未打发票
			if (Type="InvUser") {
				s NotInvNoAmount=$p($g(^TempDHCPEChargedReport(job,"UserID",InvUser,"NotInvNoInfo")),"^",1)
				s NotInvNoAmount=NotInvNoAmount+InvAmt
				s NotInvNoNum=$p($g(^TempDHCPEChargedReport(job,"UserID",InvUser,"NotInvNoInfo")),"^",2)
				s NotInvNoNum=NotInvNoNum+1
				s ^TempDHCPEChargedReport(job,"UserID",InvUser,"NotInvNoInfo")=NotInvNoAmount_"^"_NotInvNoNum
			} else {
				s PBDr=$p(InvData,"^",3)  // 账单表 DHC_PatientBill
				s PAPBDr=0
				f  s PAPBDr=$o(^DHCPEPAPBR(0,"PBDR",PBDr,PAPBDr)) q:PAPBDr=""  d  // 审核表和收费表的对照 DHC_PE_PAPBRelate
				.s PreAudit=$p($g(^DHCPEPAPBR(PAPBDr)),"^",1)  // 审核表
				.s ^TempDHCPEChargedReport(job,"UserID",InvUser,"NotInvNoInfo",InvId,PreAudit)=""
			}
		} else {  // 正常发票
			if (Type="InvUser") {
				s InvAmount=$p($g(^TempDHCPEChargedReport(job,"UserID",InvUser,"InvInfo")),"^",1)
				s InvAmount=InvAmount+InvAmt
				s InvNum=$p($g(^TempDHCPEChargedReport(job,"UserID",InvUser,"InvInfo")),"^",2)
				s InvNum=InvNum+1
				s ^TempDHCPEChargedReport(job,"UserID",InvUser,"InvInfo")=InvAmount_"^"_InvNum
			} else {
				s PBDr=$p(InvData,"^",3)  // 账单表 DHC_PatientBill
				s PAPBDr=0
				f  s PAPBDr=$o(^DHCPEPAPBR(0,"PBDR",PBDr,PAPBDr)) q:PAPBDr=""  d  // 审核表和收费表的对照 DHC_PE_PAPBRelate
				.s PreAudit=$p($g(^DHCPEPAPBR(PAPBDr)),"^",1)  // 审核表
				.s ^TempDHCPEChargedReport(job,"UserID",InvUser,"InvNoInfo",InvId,PreAudit)=""
			}
		}
	} else {  // 退费发票
		if (Type="InvUser") {
			s RefInvAmount=$p($g(^TempDHCPEChargedReport(job,"UserID",InvUser,"RefInvInfo")),"^",1)
			s RefInvAmount=RefInvAmount+InvAmt
			s RefInvNum=$p($g(^TempDHCPEChargedReport(job,"UserID",InvUser,"RefInvInfo")),"^",2)
			s RefInvNum=RefInvNum+1
			s ^TempDHCPEChargedReport(job,"UserID",InvUser,"RefInvInfo")=RefInvAmount_"^"_RefInvNum
		} else {
			s PBDr=$p(InvData,"^",3)  // 账单表 DHC_PatientBill
			s PAPBDr=0
			f  s PAPBDr=$o(^DHCPEPAPBR(0,"PBDR",PBDr,PAPBDr)) q:PAPBDr=""  d  // 审核表和收费表的对照 DHC_PE_PAPBRelate
			.s PreAudit=$p($g(^DHCPEPAPBR(PAPBDr)),"^",1)  // 审核表
			.s ^TempDHCPEChargedReport(job,"UserID",InvUser,"RefInvInfo",InvId,PreAudit)=""
		}
	}
	
	q
OutReportList
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))  
	Set Data=$LB(userid,tUserCode,tUserName,$fn(tInvAmount,"",2),tInvNum,$fn(tRefInvAmount,"",2),tRefInvNum,$fn(tNotInvNoAmount,"",2),tNotInvNoNum,$fn(tTotalAmount,"",2),tInvId,tInvNo,tRegNo,tName,tSex,tAge,$fn(tAmount,"",2),tInvFlag,tInvDate,tInvTime,tRfInvNo,tPayMode,tRoundInfo,tInvName,$fn(tFBWC,"",2),Now)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

/// 体检收费员信息
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.Incomes","OutChangedUserCode")
/// call web_DHCPE_Statistic.Incomes_OutChangedUserCode()
Query OutChangedUserCode(Type As %String = "", LocID As %String = "", hospId As %String = "") As websys.Query(ROWSPEC = "UserID:%String,UserCode:%String,UserName:%String") [ SqlProc ]
{
}

ClassMethod OutChangedUserCodeExecute(ByRef qHandle As %Binary, Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
	Set ind=1
	Set repid=$I(^CacheTemp)
	
	s UserID=0
	f  s UserID=$o(^DHCPEINVPRT(0,"USER",UserID)) q:UserID=""  d
	.s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)  // 工号
	.s UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)  // 姓名
	.s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("SS_User",UserID,Type,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("SS_User",UserID,hospId)
	.q:(HOSPshowFlag="N")
	.d OutChangedUserCode
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutChangedUserCode
	Set Data=$LB(UserID,UserCode,UserName)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

/// 按结算查询科室收入   DHCPEStationIncomeStatistic.raq
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.Incomes","DepartmentIncome","2020-09-11","2020-09-11","","152")
Query DepartmentIncome(BeginDate As %Library.String = "", EndDate As %Library.String = "", GroupDR As %Library.String = "", CTLOCID As %Library.String = "") As websys.Query(ROWSPEC = "RecDepDR:%String,RecLocDesc:%String,ItmMastDR:%String,ARCIMDesc:%String,Price:%Float,ItemNum:%Float,AccountAmount:%Float,FactAmount:%Float,Now:%String") [ SqlProc ]
{
}

ClassMethod DepartmentIncomeExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", GroupDR As %Library.String = "", CTLOCID As %Library.String = "") As %Status
{
 	s ind=1
	Set repid=$I(^CacheTemp)
 	if ((""=BeginDate) && (""=EndDate) && (""=GroupDR)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s job=$j
 	k ^TempDHCPEStationIncome(job)
 	s ^TempDHCPEDepartmentIncome("DepartmentIncome")=BeginDate_"^"_EndDate_"^"_GroupDR_"^"_CTLOCID
 	
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
 	i EndDate'=""   s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H
	i (+GroupDR=0)&&(GroupDR'="ALLI")&&(GroupDR'="ALLG") s GroupDR=""
	
	s GroupFlag=""
	i (("ALLI"=GroupDR)||("ALLG"=GroupDR)) {
		s GroupFlag=GroupDR
		s GroupDR=""
	}
	
	// 按团体查询
 	i (""'=GroupDR) d
 	.s GPAADM=$p($G(^DHCPEGADM(GroupDR)),"^",3)
 	.q:GPAADM=""
 	.s TRowId=""
	.f  s TRowId=$o(^DHCPEINVPRT(0,"ADM",GPAADM,TRowId)) q:((TRowId=""))  d
	..d SetDepartmentIncome
	
	// 按结算日期查询
	i (""=GroupDR)&&((""'=BeginDate)||(""'=EndDate)) d
	.s Date=EndDate+1
	.s TRowId=""
	.f  s Date=$o(^DHCPEINVPRT(0,"DATE",Date),-1) q:((Date="")||(Date<BeginDate))  d
	..f  s TRowId=$o(^DHCPEINVPRT(0,"DATE",Date,TRowId),-1) q:((TRowId=""))  d
	...d SetDepartmentIncome
	
	if ('$d(^TempDHCPEStationIncome(job))) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s LOC=""
	f  s LOC=$o(^TempDHCPEStationIncome(job,"LOC",LOC)) q:LOC=""  d
	.s ARCIM=""
	.f  s ARCIM=$o(^TempDHCPEStationIncome(job,"LOC",LOC,"ARCIM",ARCIM)) q:ARCIM=""  d
	..s PreIADM="",AAmount=0,FAmount=0,Price=0,INum=0
	..f  s PreIADM=$o(^TempDHCPEStationIncome(job,"LOC",LOC,"ARCIM",ARCIM,PreIADM)) q:PreIADM=""  d
	...s INum=INum+$g(^TempDHCPEStationIncome(job,"LOC",LOC,"ARCIM",ARCIM,PreIADM,"ItemNum"))
	...s AAmount=AAmount+$g(^TempDHCPEStationIncome(job,"LOC",LOC,"ARCIM",ARCIM,PreIADM,"AccountAmount"))
	...s FAmount=FAmount+$g(^TempDHCPEStationIncome(job,"LOC",LOC,"ARCIM",ARCIM,PreIADM,"FactAmount"))
	...s Price=##class(web.DHCPE.PreItemList).GetOrderPrice(ARCIM,PreIADM)
	..q:INum=0
	..s LocDesc=$P($G(^CTLOC(LOC)),"^",2)
	..s ARCIMDesc=$P($G(^ARCIM($P(ARCIM,"||",1),$P(ARCIM,"||",2),1)),"^",2)
	..d OutDepartmentIncome
	
 	k ^TempDHCPEStationIncome(job)
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
SetDepartmentIncome	
	q:TRowId=""
	s InvNo=$p($g(^DHCPEINVPRT(TRowId)),"^",1)
	q:InvNo["DHCPEYJS"
	s FH=1
	s RealInv=$p($g(^DHCPEINVPRT(TRowId)),"^",9)
	i RealInv'="" d
	.s InvID=RealInv
	.s FH=-1
	e  d
	.s InvID=TRowId
	s PAADM=$p($g(^DHCPEINVPRT(InvID)),"^",2)
	q:(##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM,CTLOCID)=1)
	s PB=$p($g(^DHCPEINVPRT(InvID)),"^",3)
	s PAPB=0
	f  s PAPB=$o(^DHCPEPAPBR(0,"PBDR",PB,PAPB)) q:PAPB=""  d
	.s PA=$p(^DHCPEPAPBR(PAPB),"^",1)
	.s UseFlag=$p(^DHCPEPreA(PA),"^",21)
	.;q:UseFlag'="U"
	.s PIADM=0
	.f  s PIADM=$o(^DHCPEPreIADM(0,"PAORDITEM",PA,PIADM)) q:PIADM=""  d
	..
	..s PreGADM=$p($g(^DHCPEPreIADM(PIADM)),"^",2)
	..q:(((GroupFlag="ALLI")&&(PreGADM'=""))||((GroupFlag="ALLG")&&(PreGADM="")))
	..
	..s OrdSub=0
	..f  s OrdSub=$o(^DHCPEPreIADM(0,"PAORDITEM",PA,PIADM,OrdSub))  q:OrdSub=""  d
	...s CRMORowId=$O(^DHCPECRMO(0,"CRMORI",PIADM_"||"_OrdSub,0))
	...s OEORI=$P(^DHCPECRMO(CRMORowId),"^",1)
	...s OEORDRowId=+OEORI
	...s OEORIChildsub=$p(OEORI,"||",2)
	...s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	...q:RecDepDR=""
	...s RecLocDesc=$P($G(^CTLOC(RecDepDR)),"^",2)
	...s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	...s ARCIMSubscript=$P(ItmMastDR,"||",1)
	...s ARCIMVersion=$P(ItmMastDR,"||",2)
	...s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	...s Price=##class(web.DHCPE.PreItemList).GetOrderPrice(ItmMastDR,PIADM)
	...s AccountAmount=$p(^DHCPEPreIADM(PIADM,"ORDITEM",OrdSub),"^",14)	
	...s Num=$g(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",PIADM_"||"_OrdSub))
	...s ORDFee=0,FactAmount=0
	...f  s ORDFee=$o(^DHCPEPreIADM(0,"PAORDITEM",PA,PIADM,OrdSub,ORDFee)) q:ORDFee=""  d
	....s OneFactAmount=$p(^DHCPEPreIADM(PIADM,"ORDITEM",OrdSub,"FEE",ORDFee),"^",2)
	....s FactAmount=FactAmount+OneFactAmount
	....s ^TempDHCPEStationIncome(job,"LOC",RecDepDR,"ARCIM",ItmMastDR,PIADM,"ItemNum")=+$g(^TempDHCPEStationIncome(job,"LOC",RecDepDR,"ARCIM",ItmMastDR,PIADM,"ItemNum"))+(Num*FH)
	...s ^TempDHCPEStationIncome(job,"LOC",RecDepDR,"ARCIM",ItmMastDR,PIADM,"AccountAmount")=$G(^TempDHCPEStationIncome(job,"LOC",RecDepDR,"ARCIM",ItmMastDR,PIADM,"AccountAmount"))+(AccountAmount*FH)
	...s ^TempDHCPEStationIncome(job,"LOC",RecDepDR,"ARCIM",ItmMastDR,PIADM,"FactAmount")=$G(^TempDHCPEStationIncome(job,"LOC",RecDepDR,"ARCIM",ItmMastDR,PIADM,"FactAmount"))+(FactAmount*FH)
	...//s Data=$LB(RecDepDR,RecLocDesc,ItmMastDR,ARCIMDesc,Price,AccountAmount,FactAmount,FH)
    ...;d OutStationIncome
	.s PIADM=0
	.f  s PIADM=$o(^DHCPEPreIADM(0,"PAORDENT",PA,PIADM)) q:PIADM=""  d
	..s PreGADM=$p($g(^DHCPEPreIADM(PIADM)),"^",2)
	..q:(((GroupFlag="I")&&(PreGADM'=""))||((GroupFlag="G")&&(PreGADM="")))
	..s EntSub=0
	..f  s EntSub=$o(^DHCPEPreIADM(0,"PAORDENT",PA,PIADM,EntSub))  q:EntSub=""  d
	...s OrdSub=0
	...f  s OrdSub=$o(^DHCPEPreIADM(0,"OrdEnt",PIADM_"||"_EntSub,PIADM,OrdSub)) q:OrdSub=""  d
	....s itemstat=$p($g(^DHCPEPreIADM(PIADM,"ORDITEM",OrdSub)),"^",16)
	....q:itemstat'="1"
	....s CRMORowId=$O(^DHCPECRMO(0,"CRMORI",PIADM_"||"_OrdSub,0))
	....s OEORI=$P(^DHCPECRMO(CRMORowId),"^",1)
	....s OEORDRowId=+OEORI
	....s OEORIChildsub=$p(OEORI,"||",2)
	....s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	....q:RecDepDR=""
	....s RecLocDesc=$P($G(^CTLOC(RecDepDR)),"^",2)
	....s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	....s ARCIMSubscript=$P(ItmMastDR,"||",1)
	....s ARCIMVersion=$P(ItmMastDR,"||",2)
	....s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	....s Price=##class(web.DHCPE.PreItemList).GetOrderPrice(ItmMastDR,PIADM)
	....s AccountAmount=$p(^DHCPEPreIADM(PIADM,"ORDITEM",OrdSub),"^",14)
	....s FactAmount=$p(^DHCPEPreIADM(PIADM,"ORDITEM",OrdSub),"^",6)
	....s ^TempDHCPEStationIncome(job,"LOC",RecDepDR,"ARCIM",ItmMastDR,PIADM,"ItemNum")=+$g(^TempDHCPEStationIncome(job,"LOC",RecDepDR,"ARCIM",ItmMastDR,PIADM,"ItemNum"))+FH
	....s ^TempDHCPEStationIncome(job,"LOC",RecDepDR,"ARCIM",ItmMastDR,PIADM,"AccountAmount")=$G(^TempDHCPEStationIncome(job,"LOC",RecDepDR,"ARCIM",ItmMastDR,PIADM,"AccountAmount"))+(AccountAmount*FH)
	....s ^TempDHCPEStationIncome(job,"LOC",RecDepDR,"ARCIM",ItmMastDR,PIADM,"FactAmount")=$G(^TempDHCPEStationIncome(job,"LOC",RecDepDR,"ARCIM",ItmMastDR,PIADM,"FactAmount"))+(FactAmount*FH)
	....//s Data=$LB(RecDepDR,RecLocDesc,ItmMastDR,ARCIMDesc,Price,AccountAmount,FactAmount,FH)
    ....//d OutStationIncome
	q
	
OutDepartmentIncome
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	Set Data=$LB(LOC,LocDesc,ARCIM,ARCIMDesc,$fn(Price,"",2),INum,$fn(AAmount,"",2),$fn(FAmount,"",2),Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetTarAC(TarItemID)
{
	s ACSubID=$P(^DHCTARI(TarItemID),"^",5)
	s ACID=$P(^DHCTarC("AC",ACSubID),"^",3)
	q ACID_"^"_ACSubID
}

/// 按结算查询体检收入 DHCPEIncomeStatistic.raq     DHCPEIncomeStatistic1.raq 会计分类
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.Incomes","DHCPEIncomeStatistic","","","170","TarAC","304")
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.Incomes","DHCPEIncomeStatistic","2019-09-26","2019-09-26","162","GADM","304")
Query DHCPEIncomeStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", GroupDR As %Library.String = "", ShowFlag As %Library.String = "", CTLOCID As %Library.String = "") As websys.Query(ROWSPEC = "GID:%String,GDesc:%String,AAmount:%Float,FAmount:%Float,DAmount:%Float,RegNum:%Float,ArrNum:%Float,TotalNum:%Float,Loc:%String,LocDesc:%String,TarAC:%String,TarACDesc:%String,TarACAmt:%Float,Now:%String") [ SqlProc ]
{
}

ClassMethod DHCPEIncomeStatisticExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", GroupDR As %Library.String = "", ShowFlag As %Library.String = "", CTLOCID As %Library.String = "") As %Status
{
 	Set ind=1
	Set repid=$I(^CacheTemp)
 	
 	if ((""=BeginDate) & (""=EndDate)& (""=GroupDR)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	s job=$j
 	k ^TempDHCPEIncomeStatistic(job)
 	s ^TempDHCPEIncomeS("IncomeS")=BeginDate_"^"_EndDate_"^"_GroupDR_"^"_ShowFlag_"^"_CTLOCID
 	
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
 	i EndDate'=""   s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H
 	i (+GroupDR=0)&&(GroupDR'="ALLI")&&(GroupDR'="ALLG") s GroupDR=""
 	
	s GroupFlag=""
	i (("ALLI"=GroupDR)||("ALLG"=GroupDR)) {
		s GroupFlag=GroupDR
		s GroupDR=""
	}
	
	// 按团体查询 	
 	i (""'=GroupDR) d
 	.s GPAADM=$p($G(^DHCPEGADM(GroupDR)),"^",3)
 	.q:GPAADM=""
 	.s TRowId=""
	.f  s TRowId=$o(^DHCPEINVPRT(0,"ADM",GPAADM,TRowId)) q:((TRowId=""))  d
	..d SetPEIncome
	
	// 按结算日期查询
	i (""=GroupDR)&&((""'=BeginDate)||(""'=EndDate)) d
	.s Date=EndDate+1
	.s TRowId=""
	.f  s Date=$o(^DHCPEINVPRT(0,"DATE",Date),-1) q:((Date="")||(Date<BeginDate))  d
	..f  s TRowId=$o(^DHCPEINVPRT(0,"DATE",Date,TRowId),-1) q:((TRowId=""))  d
	...d SetPEIncome
	
	if ('$d(^TempDHCPEIncomeStatistic(job))) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s (PGID,GDesc,AAmount,FAmount,DAmount,RegNum,ArrNum,TotalNum,Loc,LocDesc,TarAC,TarACDesc,TarACAmt)=""
	if ShowFlag="GADM" do
	.s PGID=""
	.f  s PGID=$o(^TempDHCPEIncomeStatistic(job,"PreGADM",PGID)) q:PGID=""  d
	..s (AAmount,FAmount,DAmount,RegNum,ArrNum,TotalNum)=0
	..s PreIADM=""
	..f  s PreIADM=$o(^TempDHCPEIncomeStatistic(job,"PreGADM",PGID,"PreIADM",PreIADM)) q:PreIADM=""  d
	...i PGID="I" d
	....s GDesc="个人"
	...e  d
	....s PGBI=$p(^DHCPEPreGADM(PGID),"^",1)
	....s GDesc=$p(^DHCPEPreGBI(PGBI),"^",2)
	...s AAmount=AAmount+$g(^TempDHCPEIncomeStatistic(job,"PreGADM",PGID,"PreIADM",PreIADM,"AccountAmount"))
	...s FAmount=FAmount+$g(^TempDHCPEIncomeStatistic(job,"PreGADM",PGID,"PreIADM",PreIADM,"FactAmount"))
	...s Status=$p($g(^DHCPEPreIADM(PreIADM)),"^",8)
	...i Status="REGISTERED" d
	....s RegNum=RegNum+1
	...i Status="ARRIVED" d
	....s ArrNum=ArrNum+1
	...s TotalNum=TotalNum+1
	..s DAmount=AAmount-FAmount
	..d OutPEIncome
	else  if ShowFlag="TarAC" do
	.s Loc=""
	.f  s Loc=$o(^TempDHCPEIncomeStatistic(job,"Loc",Loc)) q:Loc=""  d
	..s LocDesc=$P($G(^CTLOC(Loc)),"^",2)
	..s TarAC=""
	..f  s TarAC=$o(^TempDHCPEIncomeStatistic(job,"Loc",Loc,"TarAC",TarAC)) q:TarAC=""  d
	...s TarACAmt=0
	...s TarACDesc=$P($G(^DHCTarC("AC",TarAC)),"^",2)
	...s TarACAmt=TarACAmt+$g(^TempDHCPEIncomeStatistic(job,"Loc",Loc,"TarAC",TarAC))
	...d OutPEIncome
	
	k ^TempDHCPEIncomeStatistic(job)
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
SetPEIncome
	q:TRowId=""
	s InvNo=$p($g(^DHCPEINVPRT(TRowId)),"^",1)
	q:InvNo["DHCPEYJS"
	s FH=1
	s RealInv=$p($g(^DHCPEINVPRT(TRowId)),"^",9)
	i RealInv'="" d
	.s InvID=RealInv
	.s FH=-1
	e  d
	.s InvID=TRowId
	s PAADM=$p($g(^DHCPEINVPRT(InvID)),"^",2)
	s GADM=$o(^DHCPEGADM(0,"DelegateADM",PAADM,0))
	i GADM="" s GADM="I"
	
	q:(##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM,CTLOCID)=1)
	s InvDate=$p($g(^DHCPEINVPRT(InvID)),"^",11)
	q:(BeginDate'="")&&(InvDate<BeginDate)
	q:(EndDate'="")&&(InvDate>EndDate)
	s PB=$p($g(^DHCPEINVPRT(InvID)),"^",3)
	s PAPB=0
	f  s PAPB=$o(^DHCPEPAPBR(0,"PBDR",PB,PAPB)) q:PAPB=""  d
	.s PA=$p($g(^DHCPEPAPBR(PAPB)),"^",1)
	.s UseFlag=$p($g(^DHCPEPreA(PA)),"^",21)
	.;q:UseFlag'="U"
	.s PIADM=0
	.f  s PIADM=$o(^DHCPEPreIADM(0,"PAORDITEM",PA,PIADM)) q:PIADM=""  d
	..
	..s PreGADM=$p($g(^DHCPEPreIADM(PIADM)),"^",2)
	..q:(((GroupFlag="ALLI")&&(PreGADM'=""))||((GroupFlag="ALLG")&&(PreGADM="")))
	..s:PreGADM="" PreGADM="I"
	..
	..s OrdSub=0
	..f  s OrdSub=$o(^DHCPEPreIADM(0,"PAORDITEM",PA,PIADM,OrdSub))  q:OrdSub=""  d
	...s CRMORowId=$O(^DHCPECRMO(0,"CRMORI",PIADM_"||"_OrdSub,0))
	...s OEORI=$P($g(^DHCPECRMO(CRMORowId)),"^",1)
	...s OEORDRowId=+OEORI
	...s OEORIChildsub=$p(OEORI,"||",2)
	...s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	...q:RecDepDR=""
	...;s RecLocDesc=$P($G(^CTLOC(RecDepDR)),"^",2)
	...s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	...s ARCIMSubscript=$P(ItmMastDR,"||",1)
	...s ARCIMVersion=$P(ItmMastDR,"||",2)
	...s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	...s IFeePart=..GetItemFeePart(PIADM_"||"_OrdSub,"ORDITEM")
	...i IFeePart=1 d
	....s AccountAmount=$p(^DHCPEPreIADM(PIADM,"ORDITEM",OrdSub),"^",14)
	...e  d
	....s FeeAmount=..GetItemFeeAmount(PIADM_"||"_OrdSub,"ORDITEM")
	....i GADM="I" d
	.....s AccountAmount=$p(FeeAmount,"^",1)
	....e  d
	.....s AccountAmount=$p(FeeAmount,"^",2)
	...;s AccountAmount=$p(^DHCPEPreIADM(PIADM,"ORDITEM",OrdSub),"^",14)
	...s ORDFee=0,FactAmount=0
	...f  s ORDFee=$o(^DHCPEPreIADM(0,"PAORDITEM",PA,PIADM,OrdSub,ORDFee)) q:ORDFee=""  d
	....s OneFactAmount=$p($g(^DHCPEPreIADM(PIADM,"ORDITEM",OrdSub,"FEE",ORDFee)),"^",2)
	....s FactAmount=FactAmount+OneFactAmount
	...;s ^TempDHCPEIncomeStatistic(job,"PreGADM",PreGADM,"PreIADM",PIADM)=(AccountAmount*FH)_"^"_(FactAmount*FH)
	...s ^TempDHCPEIncomeStatistic(job,"PreGADM",PreGADM,"PreIADM",PIADM,"AccountAmount")=$G(^TempDHCPEIncomeStatistic(job,"PreGADM",PreGADM,"PreIADM",PIADM,"AccountAmount"))+(AccountAmount*FH)
	...s ^TempDHCPEIncomeStatistic(job,"PreGADM",PreGADM,"PreIADM",PIADM,"FactAmount")=$G(^TempDHCPEIncomeStatistic(job,"PreGADM",PreGADM,"PreIADM",PIADM,"FactAmount"))+(FactAmount*FH)
	...//按照会计分类统计金额
	...s TARITEMSub=""
	...f  s TARITEMSub=$O(^DHCPEOEITEM(InvID,"OEITEM",PIADM_"||"_OrdSub,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	....s Info=$G(^DHCPEOEITEM(InvID,"OEITEM",PIADM_"||"_OrdSub,"TARITEM",TARITEMSub))
	....s TARITEMID=$P(Info,"^",1)
	....s ACAmount=$P(Info,"^",4)
	....s OneInfo=..GetTarAC(TARITEMID)
	....s ACSubID=$P(OneInfo,"^",2)
	....s ACID=$P(OneInfo,"^",1)
	....;s ACDesc=$P(^DHCTarC("AC",ACSubID),"^",2)
	....s ^TempDHCPEIncomeStatistic(job,"Loc",RecDepDR,"TarAC",ACSubID)=$G(^TempDHCPEIncomeStatistic(job,"Loc",RecDepDR,"TarAC",ACSubID))+(ACAmount*FH)
    ....;d OutetPEIncome
	.s PIADM=0
	.f  s PIADM=$o(^DHCPEPreIADM(0,"PAORDENT",PA,PIADM)) q:PIADM=""  d
	..s PreGADM=$p($g(^DHCPEPreIADM(PIADM)),"^",2)
	..q:(((GroupFlag="ALLI")&&(PreGADM'=""))||((GroupFlag="ALLG")&&(PreGADM="")))
	..s:PreGADM="" PreGADM="I"
	..s EntSub=0
	..f  s EntSub=$o(^DHCPEPreIADM(0,"PAORDENT",PA,PIADM,EntSub))  q:EntSub=""  d
	...s IFeePart=..GetItemFeePart(PIADM_"||"_EntSub,"ORDENT")
	...i IFeePart=1 d
	....s AccountAmount=$p($g(^DHCPEPreIADM(PIADM,"ORDENT",EntSub)),"^",7)
	...e  d
	....s FeeAmount=..GetItemFeeAmount(PIADM_"||"_EntSub,"ORDENT")
	....i GADM="I" d
	.....s AccountAmount=$p(FeeAmount,"^",1)
	....e  d
	.....s AccountAmount=$p(FeeAmount,"^",2) 
	...s ^TempDHCPEIncomeStatistic(job,"PreGADM",PreGADM,"PreIADM",PIADM,"AccountAmount")=$G(^TempDHCPEIncomeStatistic(job,"PreGADM",PreGADM,"PreIADM",PIADM,"AccountAmount"))+(AccountAmount*FH)
	...s PIOEFSub=0,FactAmount=0
	...f  s PIOEFSub=$o(^DHCPEPreIADM(0,"PAORDENT",PA,PIADM,EntSub,PIOEFSub)) q:PIOEFSub=""  d
	....s OneFactAmount=$p(^DHCPEPreIADM(PIADM,"ORDENT",EntSub,"FEE",PIOEFSub),"^",2)
	....s FactAmount=FactAmount+OneFactAmount
	...s ^TempDHCPEIncomeStatistic(job,"PreGADM",PreGADM,"PreIADM",PIADM,"FactAmount")=$G(^TempDHCPEIncomeStatistic(job,"PreGADM",PreGADM,"PreIADM",PIADM,"FactAmount"))+(FactAmount*FH)
	...s OrdSub=0
	...f  s OrdSub=$o(^DHCPEPreIADM(0,"OrdEnt",PIADM_"||"_EntSub,PIADM,OrdSub)) q:OrdSub=""  d
	....s CRMORowId=$O(^DHCPECRMO(0,"CRMORI",PIADM_"||"_OrdSub,0))
	....q:CRMORowId=""
	....s OEORI=$P($g(^DHCPECRMO(CRMORowId)),"^",1)
	....s OEORDRowId=+OEORI
	....s OEORIChildsub=$p(OEORI,"||",2)
	....s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	....q:RecDepDR=""
	....//按照会计分类统计金额
	....s TARITEMSub=""
	....f  s TARITEMSub=$O(^DHCPEOEITEM(InvID,"OEITEM",PIADM_"||"_OrdSub,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	.....s Info=$G(^DHCPEOEITEM(InvID,"OEITEM",PIADM_"||"_OrdSub,"TARITEM",TARITEMSub))
	.....s TARITEMID=$P(Info,"^",1)
	.....s ACAmount=$P(Info,"^",4)
	.....s OneInfo=..GetTarAC(TARITEMID)
	.....s ACSubID=$P(OneInfo,"^",2)
	.....s ACID=$P(OneInfo,"^",1)
	.....;s ACDesc=$P(^DHCTarC("AC",ACSubID),"^",2)	
	.....s ^TempDHCPEIncomeStatistic(job,"Loc",RecDepDR,"TarAC",ACSubID)=$G(^TempDHCPEIncomeStatistic(job,"Loc",RecDepDR,"TarAC",ACSubID))+(ACAmount*FH)
    .....;d OutetPEIncome
	q
	
OutPEIncome
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	s Data=$LB(PGID,GDesc,$fn(AAmount,"",2),$fn(FAmount,"",2),$fn(DAmount,"",2),RegNum,ArrNum,TotalNum,Loc,LocDesc,TarAC,TarACDesc,$fn(TarACAmt,"",2),Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator：      ln
/// CreateDate：   2020-02-20
/// Description:：体检费用统计
/// Table：       DHC_PE_IADM
/// Input：       BeginDate,EndDate,GADM:DHC_PE_GADM的ID
/// Output：      Date:团体登记日期,GroupName:团体名,AllNum,CheckedNum:已检人数,UnCheckedNum:未检人数,GAccountFee:公费应收,GFactFee:公费实际,GPayedFee:公费实收,GNoPayedFee:公费未收,IAccountFee:自费应收,IFactFee:自费实际,IPayedFee:自费实收,INoPayedFee:自费未收
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.Incomes","PEFeeStatistic","2022-03-07","2022-03-07","","Item","","","105")                       
Query PEFeeStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", GroupDR As %Library.String = "", ShowFlag As %Library.String = "", GADM As %Library.String = "", CheckType As %Library.String = "", CurLoc As %Library.String = "") As websys.Query(ROWSPEC = "GADM:%String,GroupName:%String,AllNum:%Float,CheckedNum:%Float,UnCheckedNum:%Float,GAccountFee:%Float,GFactFee:%Float,GPayedFee:%Float,GNoPayedFee:%Float,IAccountFee:%Float,IFactFee:%Float,IPayedFee:%Float,INoPayedFee:%Float,RegNo:%String,Name:%String,Sex:%String,Age:%String,VIPLevel:%String,Tel:%String,GroupName:%String,TeamName:%String,PGAccountFee:%Float,PGFactFee:%Float,PGPayedFee:%Float,PGNoPayedFee:%Float,PIAccountFee:%Float,PIFactFee:%Float,PIPayedFee:%Float,PINoPayedFee:%Float,Now:%String") [ SqlProc ]
{
}

ClassMethod PEFeeStatisticExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, GroupDR As %Library.String = "", ShowFlag As %Library.String = "", GADM As %Library.String = "", CheckType As %Library.String = "", CurLoc As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((BeginDate="")&(EndDate="")&(GroupDR=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s Job=$J
 	k ^TempDHCPEAcountIncome(Job)
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H

	i +GroupDR=0 s GroupDR=""
	s Type="GAccountFee^GFactFee^GPayedFee^GNoPayedFee^IAccountFee^IFactFee^IPayedFee^INoPayedFee"
	
	if ShowFlag="Item" d
	.s Date=BeginDate-1
	.f  s Date=$O(^User.DHCPEItemDetailRecordI("IDRDateIndex",Date)) q:(Date="")||(Date>EndDate)  d
 	..s ID=""
 	..f  s ID=$O(^User.DHCPEItemDetailRecordI("IDRDateIndex",Date,ID)) q:(ID="")  d
 	...s OEORI=$LG(^User.DHCPEItemDetailRecordD(ID),2)
 	...d OneItemFee
 	.d OutItemAmountFee
	else  d
	.i GroupDR'="" d
	..s GTeam=0
	..f  s GTeam=$o(^DHCPEIADM(0,"GADM",GroupDR,GTeam)) q:GTeam=""  d
	...s IADM=0
	...f  s IADM=$o(^DHCPEIADM(0,"GADM",GroupDR,GTeam,IADM)) q:IADM=""  d
	....d OneAmountFee
	.e  d
	..s Date=BeginDate-1
	..f  s Date=$o(^DHCPEIADM(0,"AdmDateTime",Date)) q:(Date="")||(Date>EndDate)  d
	...s Time=""
	...f  s Time=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:Time=""  d
	....s IADM=""
	....f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM)) q:IADM=""  d
	.....d OneAmountFee
	
	if ('$d(^TempDHCPEAcountIncome(Job))) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	if (GADM="") 
	{
		s PGADM=""
		f  s PGADM=$o(^TempDHCPEAcountIncome(Job,PGADM)) q:PGADM=""  d
		.d SetAccountFeeVariable
		.i PGADM="I" d
		..s GDesc="个人体检"
		.e  d
		..s GBI=$p($G(^DHCPEGADM(PGADM)),"^",1)
		..q:GBI=""
		..s GDesc=$p(^DHCPEGBI(GBI),"^",2)
		.q:GDesc=""
		.s AllNum=$G(^TempDHCPEAcountIncome(Job,PGADM,"TotalNum"))
		.s CheckedNum=$G(^TempDHCPEAcountIncome(Job,PGADM,"CheckNum"))
		.s UnCheckedNum=AllNum-CheckedNum
		.f i=1:1:$L(Type,"^") d
		..s str=$p(Type,"^",i)
		..s PLIST(i)=$G(^TempDHCPEAcountIncome(Job,PGADM,str))
		.d OutAmountFee
	}
	else
	{ 
	    d SetAccountFeeVariable
		s PIADM=""
		f  s PIADM=$o(^TempDHCPEAcountIncome(Job,GADM,"Person",PIADM)) q:PIADM=""  d
		.s Info=##class(web.DHCPE.Statistic.WorkStatistic).GetBaseInfo("PreADM",PIADM)
	    .s OneFeeInfo=..GetAdmFee(PIADM)
	    .d OutAmountFee

	}
	k ^TempDHCPEAcountIncome(Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetAccountFeeVariable
    // 团体名称，各节点
    ;s (GDesc,PLIST(1),PLIST(2),PLIST(3),PLIST(4),PLIST(5),PLIST(6),PLIST(7),PLIST(8),Info,OneFeeInfo)=""
    s (GDesc,Info,OneFeeInfo)=""
    k PLIST
    // 总人数，已检人数，未检人数
    s (AllNum,CheckedNum,UnCheckedNum)=0
    q
OneItemFee
    s FH=1
 	s IDType=$LG(^User.DHCPEItemDetailRecordD(ID),3)
 	i IDType="D" s FH=-1
 	s CrmOrderID=$O(^DHCPECRMO(0,"OEORI",OEORI,0))
 	q:CrmOrderID=""
 	s PreItemID=$P(^DHCPECRMO(CrmOrderID),"^",2)
 	s PreIADM=+PreItemID
 	s IADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
 	q:IADM=""
 	q:(##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADM,CurLoc)=1)
 	s CurGADM=$p(^DHCPEIADM(IADM),"^",2)
 	q:(GroupDR'="")&&(GroupDR'=CurGADM)
    i CurGADM="" d
    .s CurGADM="I"
 	s ^TempDHCPEAcountIncome(Job,"Item",CurGADM,+PreItemID,PreItemID,FH)=""	

	q
OneAmountFee
    q:(##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADM,CurLoc)=1)
    s Status=$p(^DHCPEIADM(IADM),"^",8)
    q:(Status'="ARRIVED")
    s CurGADM=$p(^DHCPEIADM(IADM),"^",2)
    i CurGADM="" d
    .s CurGADM="I"
    q:(GADM'="")&&(GADM'=CurGADM)
    s PreIADM=$p(^DHCPEIADM(IADM),"^",4)
    s PAADM=$p(^DHCPEIADM(IADM),"^",1)
    q:PAADM=""
    s CheckFlag=0
    s RLTDR=$o(^DHCPERLT(0,"ADM",PAADM,0)) 
    i RLTDR'=""  s CheckFlag=1
    q:(CheckType="Check")&&(CheckFlag=0)
    q:(CheckType="UnCheck")&&(CheckFlag=1)
    s ^TempDHCPEAcountIncome(Job,CurGADM,"TotalNum")=$G(^TempDHCPEAcountIncome(Job,CurGADM,"TotalNum"))+1
    s ^TempDHCPEAcountIncome(Job,CurGADM,"Person",PreIADM)=""
    s:CheckFlag=1 ^TempDHCPEAcountIncome(Job,CurGADM,"CheckNum")=$G(^TempDHCPEAcountIncome(Job,CurGADM,"CheckNum"))+1
    s OneFeeInfo=..GetAdmFee(PreIADM,1)
    f i=1:1:$L(Type,"^") d
    .s str=$p(Type,"^",i)
    .s Amount=$p(OneFeeInfo,"^",i)
    .s ^TempDHCPEAcountIncome(Job,CurGADM,str)=$G(^TempDHCPEAcountIncome(Job,CurGADM,str))+Amount
    	
	q
OutItemAmountFee
    s CurGADM=0
    f  s CurGADM=$o(^TempDHCPEAcountIncome(Job,"Item",CurGADM)) q:CurGADM=""  d
    .s PreIADM=""
    .f  s PreIADM=$o(^TempDHCPEAcountIncome(Job,"Item",CurGADM,PreIADM)) q:PreIADM=""  d
    ..s IADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
    ..s PAADM=$p(^DHCPEIADM(IADM),"^",1)
    ..s CheckFlag=0
    ..s RLTDR=$o(^DHCPERLT(0,"ADM",PAADM,0)) 
    ..i RLTDR'=""  s CheckFlag=1
    ..s ^TempDHCPEAcountIncome(Job,CurGADM,"TotalNum")=$G(^TempDHCPEAcountIncome(Job,CurGADM,"TotalNum"))+1
    ..s ^TempDHCPEAcountIncome(Job,CurGADM,"AllPerson",PreIADM)=""
    ..i CheckFlag=1 d
    ...s ^TempDHCPEAcountIncome(Job,CurGADM,"CheckNum")=$G(^TempDHCPEAcountIncome(Job,CurGADM,"CheckNum"))+1
    ...s ^TempDHCPEAcountIncome(Job,CurGADM,"CheckPerson",PreIADM)=""
    ..e  d
    ...s ^TempDHCPEAcountIncome(Job,CurGADM,"UnCheckPerson",PreIADM)=""
    ..s PreItemID=0
    ..f  s PreItemID=$o(^TempDHCPEAcountIncome(Job,"Item",CurGADM,PreIADM,PreItemID)) q:PreItemID=""  d
    ...s FH=""
    ...f  s FH=$o(^TempDHCPEAcountIncome(Job,"Item",CurGADM,PreIADM,PreItemID,FH)) q:FH=""  d
    ....i FH="1" s ItemType="A"
    ....i FH="-1" s ItemType="D"
    ....s OneItemFee=..GetItemFee(PreItemID,ItemType)
    ....f i=1:1:$L(Type,"^") d
    .....s str=$p(Type,"^",i)
    .....s Amount=$p(OneItemFee,"^",i)
    .....s ^TempDHCPEAcountIncome(Job,CurGADM,str)=$G(^TempDHCPEAcountIncome(Job,CurGADM,str))+(Amount*FH)
    k ^TempDHCPEAcountIncome(Job,"Item")

    q
OutAmountFee
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(PGADM,GDesc,AllNum,CheckedNum,UnCheckedNum,PLIST(1),PLIST(2),PLIST(3),PLIST(4),PLIST(5),PLIST(6),PLIST(7),PLIST(8),$p(Info,"^",1),$p(Info,"^",2),$p(Info,"^",3),$p(Info,"^",4),$p(Info,"^",5),$p(Info,"^",6),$p(Info,"^",8),$p(Info,"^",9),$p(OneFeeInfo,"^",9),$p(OneFeeInfo,"^",3),$p(OneFeeInfo,"^",4),$p(OneFeeInfo,"^",5),$p(OneFeeInfo,"^",10),$p(OneFeeInfo,"^",6),$p(OneFeeInfo,"^",7),$p(OneFeeInfo,"^",8),Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetItemFee(PreItem, Type As %Library.String = "A")
{
	q:PreItem="" ""
	s preiadmid=+PreItem
	s itemsub=$p(PreItem,"||",2)
	s (GAccountSum,PublicSum,PubllicPayed,PubllicUnPayed,IAccountSum,SelfSum,SelfPayed,SelfUnPayed)=0
	s OrdEntDR=$p($g(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub)),"^",2)
	
	s (AccountAmount,GAccountAmount,IAccountAmount,FactSum)=0
	s AccountAmount=$p($g(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub)),"^",14)
	s IFeePart=..GetItemFeePart(preiadmid_"||"_itemsub,"ORDITEM")
	i IFeePart=1 d
	.s GAccountAmount=AccountAmount
	.s IAccountAmount=AccountAmount
	e  d
	.s FeeAmount=..GetItemFeeAmount(preiadmid_"||"_itemsub,"ORDITEM")
	.s IAccountAmount=$p(FeeAmount,"^",1)
	.s GAccountAmount=$p(FeeAmount,"^",2)
	s feesub=0
	f  s feesub=$o(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub,"FEE",feesub)) q:(feesub="")  d
	.s feedata=$g(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub,"FEE",feesub))	
	.s preauditid=$p(feedata,"^",5)
	.i Type="D" s preauditid=$G(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub,"FEE",feesub,"CancelPE"))
	.s publicflag=0
	.s payedflag=0
	.q:preauditid=""
	.s UseFlag=$p($g(^DHCPEPreA(preauditid)),"^",21)
	.;q:UseFlag="NU"
	.i $p($g(^DHCPEPreA(preauditid)),"^",1)="G" s publicflag=1
	.i ($p($g(^DHCPEPreA(preauditid)),"^",14)="CHARGED")&&('$D(^DHCPEPreA("AsCharged",preauditid))) s payedflag=1   //定额卡支付的不算已付
	.s factamount=+$p(feedata,"^",2)
	.s FactSum=FactSum+factamount
	.i publicflag=1  d
	..s PublicSum=PublicSum+factamount
	..i payedflag=1 s PubllicPayed=PubllicPayed+factamount
	..s GAccountSum=GAccountSum+GAccountAmount
	.e  d
	..s SelfSum=SelfSum+factamount
	..s IAccountSum=IAccountSum+IAccountAmount
	..i payedflag=1 s SelfPayed=SelfPayed+factamount
	
	//计算套餐费用
	s AccountAmount=$p($g(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub)),"^",14)
	i OrdEntDR'="" d
	.s feesub=$o(^DHCPEPreIADM(+OrdEntDR,"ORDENT",$p(OrdEntDR,"||",2),"FEE",0))    //不考虑套餐公+自的情况
	.q:feesub=""
	.s feedata=$g(^DHCPEPreIADM(+OrdEntDR,"ORDENT",$p(OrdEntDR,"||",2),"FEE",feesub))	
	.s preauditid=$p(feedata,"^",5)
	.i Type="D" s preauditid=$G(^DHCPEPreIADM(preiadmid,"ORDENT",itemsub,"FEE",feesub,"CancelPE"))
	.s publicflag=0
	.s payedflag=0
	.q:preauditid=""
	.i $p($g(^DHCPEPreA(preauditid)),"^",1)="G" s publicflag=1
	.i ($p($g(^DHCPEPreA(preauditid)),"^",14)="CHARGED")&&('$D(^DHCPEPreA("AsCharged",preauditid))) s payedflag=1   //定额卡支付的不算已付
	.s factamount=$p($g(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub)),"^",6)
	.s FactSum=FactSum+factamount
	.i publicflag=1  d
	..s PublicSum=PublicSum+factamount
	..i payedflag=1 s PubllicPayed=PubllicPayed+factamount
	..s GAccountSum=GAccountSum+AccountAmount
	.e  d
	..s SelfSum=SelfSum+factamount
	..s IAccountSum=IAccountSum+AccountAmount
	..i payedflag=1 s SelfPayed=SelfPayed+factamount
	
	q GAccountSum_"^"_PublicSum_"^"_PubllicPayed_"^"_PubllicUnPayed_"^"_IAccountSum_"^"_SelfSum_"^"_SelfPayed_"^"_SelfUnPayed
}

Storage Default
{
<Data name="IncomesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.Statistic.IncomesD</DataLocation>
<DefaultData>IncomesDefaultData</DefaultData>
<IdLocation>^web.DHCPE.Statistic.IncomesD</IdLocation>
<IndexLocation>^web.DHCPE.Statistic.IncomesI</IndexLocation>
<StreamLocation>^web.DHCPE.Statistic.IncomesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
