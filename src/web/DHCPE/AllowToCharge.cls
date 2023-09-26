Class web.DHCPE.AllowToCharge Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// debug: w ##class(web.DHCPE.AllowToCharge).AllowToCharge("39^1","Group","ADM","18853")
ClassMethod AllowToCharge(Data, Type, IDType As %String = "ADM", userId As %String = "")
{
	s dateTime=$H
	s i=$l(Data,"&")
	s Flag=0
	f j=1:1:i
	{
		s value=$p(Data,"&",j)
		s admId=$p(value,"^",1)
		i IDType="Pre" d
		.s CRMGADM=admId
		.s admId=$O(^DHCPEGADM(0,"CRMGADM",admId,0))
		e  d
		.s CRMGADM=$P($G(^DHCPEGADM(admId)),"^",2)
		s:admId="" Flag=1
		
		q:admId="" 
		s allowFlag=$p(value,"^",2)
		i allowFlag=0 d
		.k ^DHCPEDataEx("DHCPECharge",Type,admId)
		e  d
		.s ^DHCPEDataEx("DHCPECharge",Type,admId)=allowFlag_"^"_userId_"^"_dateTime
		.d ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(CRMGADM,"1")
	}
	i Flag=1 q "-1^还没有登记，不能允许缴费"
	q Flag
}

ClassMethod AllowToChargeNew(Data, Type, IDType As %String = "ADM")
{
	s ret=""
	s userId=%session.Get("LOGON.USERID")
	s dateTime=$H
	s i=$l(Data,"&")
	s Flag=0
	f j=1:1:i
	{
		s value=$p(Data,"&",j)
		s admId=$p(value,"^",1)
		i IDType="Pre" d
		.s CRMGADM=admId
		.s admId=$O(^DHCPEGADM(0,"CRMGADM",admId,0))
		e  d
		.s CRMGADM=$P($G(^DHCPEGADM(admId)),"^",2)
		s:admId="" Flag=1
		
		q:admId="" 
		s allowFlag=$p(value,"^",2)
	    d ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(CRMGADM,"1")
	}
	i Flag=1 q "-1^还没有登记，不能允许缴费"
	q ret
}

ClassMethod GetToChargeFlag(Type, ID)
{
	;##class(web.DHCPE.AllowToCharge).GetToChargeFlag("Pre",ID)
	i Type="Pre" s ID=$O(^DHCPEGADM(0,"CRMGADM",ID,0))
	q:ID="" 0
	q $D(^DHCPEDataEx("DHCPECharge","Group",ID))
}

Query AllowToCharge(txtPatName As %String, txtGroupId As %String, txtAdmDate As %String, txtAdmNo As %String, txtItemId As %String, EndDate As %String = "", HadAllowed As %String = "", ShowGroup As %String = "") As %Query(ROWSPEC = "AdmId:%String,PatName:%String, AdmNo:%String,AdmDate:%String, AdmStatus:%String, IsCompleted:%Integer, Diet:%String, PEIAdmId:%String, AdmAccountAmount:%String,AdmFactAmount:%String,PAADMNo:%String,TReportStatus:%String,TGDesc:%String,TSelect:%String")
{
}

/// w ##class(%ResultSet).RunQuery("web.DHCPE.AllowToCharge","AllowToCharge","","","20220101","","","20230101","","1")
ClassMethod AllowToChargeExecute(ByRef qHandle As %Binary, txtPatName As %String, txtGroupId As %String, txtAdmDate As %String, txtAdmNo As %String, txtItemId As %String, EndDate As %String, HadAllowed As %String = "", ShowGroup As %String = "") As %Status
{
	s ^dhcpe("AllowToCharge")=$lb(txtPatName,txtGroupId,txtAdmDate,txtAdmNo,txtItemId,EndDate,HadAllowed,ShowGroup)
	
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s txtPatName=$g(txtPatName),  txtGroupId=$g(txtGroupId), txtAdmDate=$g(txtAdmDate), txtAdmNo=$g(txtAdmNo)
	s txtItemId=$g(txtItemId)
	i ((txtPatName="")&(txtGroupId="")&(txtAdmDate="")&(txtAdmNo="")&(EndDate="")){
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	i txtAdmDate'=""  s txtAdmDate=##class(websys.Conversions).DateHtmlToLogical(txtAdmDate)
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	i txtAdmNo'="" s txtAdmNo=##class(web.DHCPE.DHCPECommon).RegNoMask(txtAdmNo)
	s vEndDate=EndDate
	i EndDate="" s vEndDate=+$H
	s vStartDate=txtAdmDate
	i txtAdmDate="" s vStartDate=0
	/*
	if (HadAllowed="checked") s HadAllowed=1
	e  s HadAllowed=0
	if (ShowGroup="checked") s ShowGroup=1
	e  s ShowGroup=0
	*/
	
	i ShowGroup="0"
	{
		If txtAdmNo'="" Do
		.Set PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",txtAdmNo,0))
		.Quit:PIBI=""
		.Set PIADM=0
		.For  Set PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM))  Quit:PIADM=""  Do
		..Set IAdmId=0
		..For  Set IAdmId=$o(^DHCPEIADM(0,"CRMADM",PIADM,IAdmId))  Quit:IAdmId=""  Do
		...Do GetIADMInfo
		Else  If EndDate'=""||txtAdmDate'="" Do
		.i EndDate="" s EndDate=+$H
		.s EndDate=EndDate+1
		.f  s EndDate=$o(^DHCPEIADM(0,"AdmDateTime",EndDate),-1) q:(EndDate<+txtAdmDate)||(EndDate="")  d
		..s Time=0
		..f  s Time=$o(^DHCPEIADM(0,"AdmDateTime",EndDate,Time)) q:Time=""  d
		...s IAdmId=0
		...f  s IAdmId=$o(^DHCPEIADM(0,"AdmDateTime",EndDate,Time,IAdmId)) q:IAdmId=""  d
		....Do GetIADMInfo
		Else  Do
		.Set IAdmId=0
		.For  Set IAdmId=$o(^DHCPEIADM(IAdmId)) Quit:IAdmId=""  Do
		..Do GetIADMInfo
	}
	else
	{
		If txtAdmNo'="" Do
		.Set PIBI=$o(^DHCPEPreGBI(0,"PAPAMINo",txtAdmNo,0))
		.Quit:PIBI=""
		.Set PIADM=0
		.For  Set PIADM=$o(^DHCPEPreGADM(0,"PGBI",PIBI,PIADM))  Quit:PIADM=""  Do
		..Set IAdmId=0
		..For  Set IAdmId=$o(^DHCPEGADM(0,"CRMGADM",PIADM,IAdmId))  Quit:IAdmId=""  Do
		...Do GetGADMInfo
		//Else  If txtPatName'="" Do
		//.
		Else  If EndDate'=""||txtAdmDate'="" Do
		.i EndDate="" s EndDate=+$H
		.s EndDate=EndDate+1
		.f  s EndDate=$o(^DHCPEGADM(0,"AdmDateTime",EndDate),-1) q:(EndDate<+txtAdmDate)||(EndDate="")  d
		..s Time=0
		..f  s Time=$o(^DHCPEGADM(0,"AdmDateTime",EndDate,Time)) q:Time=""  d
		...s IAdmId=0
		...f  s IAdmId=$o(^DHCPEGADM(0,"AdmDateTime",EndDate,Time,IAdmId)) q:IAdmId=""  d
		....Do GetGADMInfo
		Else  Do
		.Set IAdmId=0
		.For  Set IAdmId=$o(^DHCPEGADM(IAdmId)) Quit:IAdmId=""  Do
		..Do GetGADMInfo
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetGADMInfo
	s strIAdm=^DHCPEGADM(IAdmId)
	//q:($p(strIAdm,"^",8)="COMPLETED")
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("GADM",IAdmId) //add 2009-07-07 
  	q:LocFlag=1 

	s PEIDate=$p(strIAdm,"^",4)
	q:(+PEIDate)<vStartDate
	q:(+PEIDate)>vEndDate
	//过滤2007-07-12以前的数据    2007-07-25
	s PESystemStartDate=##class(web.DHCPE.Public.Setting).GetPESystemStartDate()
	q:$p(strIAdm,"^",4)<PESystemStartDate

	s needQ=0, GID=""
	i (txtGroupId'="")  d
	. i (IAdmId'=txtGroupId)  s needQ=1
	q:(needQ=1)
	
	s paadmId=$p(strIAdm,"^",3)
	q:(paadmId="")
	s patMatId=$p($g(^PAADM(paadmId)),"^",1)
	Quit:patMatId=""
	s PAADMNo=$p(^PAADM(paadmId),"^",81)
	q:(txtAdmNo'="")&(txtAdmNo'=$p($g(^PAPER(patMatId,"PAT",1)),"^",2))
	q:(txtPatName'="")&($p($g(^PAPER(patMatId,"ALL")),"^",1)'[txtPatName)
	s retAdmId=paadmId, retPatName=$p($g(^PAPER(patMatId,"ALL")),"^",1)
	s retAdmNo=$p($g(^PAPER(patMatId,"PAT",1)),"^",2)
	s retRegStatus=$p(strIAdm,"^",6)
	s retRegStatus=##Class(web.DHCPE.PreCommon).TransStatus(retRegStatus)
	s retAdmDate=##class(websys.Conversions).DateLogicalToHtml($p(strIAdm,"^",4))
	s Diet="" //$p(strIAdm,"^",17)
	// IADM_GADM_DR
	s GADMDR=IAdmId
	s GDesc="是"
	// IADM_AccountAmount	应收金额
	s PreIADM=$p(strIAdm,"^",2)
	s Amount=..GetAmount(IAdmId,"G")
	q:+Amount=0
	s AccountAmount=$fn($p(Amount,"^",1),"",2)
	// IADM_FactAmount	最终金额
	s FactAmount=$fn($p(Amount,"^",2),"",2)
	;---- 取是否体检项目完成的状态----
	s isCompleted=""
	s ReportStatus=""
	s Select=+$G(^DHCPEDataEx("DHCPECharge","Group",IAdmId))

	q:(HadAllowed="1")&&(Select=0)
	q:(HadAllowed="0")&&(Select=1)

	Do OutputRow1
	Quit	
GetIADMInfo
	s strIAdm=^DHCPEIADM(IAdmId)
	
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmId) 
  	q:LocFlag=1 
  	
	q:($p(strIAdm,"^",8)="COMPLETED")||($p(strIAdm,"^",8)="CANCELPE")
	s PEIDate=$p(strIAdm,"^",5)
	q:(+PEIDate)<vStartDate
	q:(+PEIDate)>vEndDate
	
	//过滤2007-07-12以前的数据    2007-07-25
	s PESystemStartDate=##class(web.DHCPE.Public.Setting).GetPESystemStartDate()
	q:$p(strIAdm,"^",5)<PESystemStartDate
	s needQ=0, GID=""
	i (txtGroupId'="")  d
	. s GAdmId=$p(strIAdm,"^",2)
	. i (GAdmId'=txtGroupId)  s needQ=1
	.q:needQ=1
	.i txtItemId'="" d
	.. s GItemId=$p(strIAdm,"^",3)
	.. i (GItemId'=txtItemId)  s needQ=1
	q:(needQ=1)
	s paadmId=$p(strIAdm,"^",1)
	q:(paadmId="")
	s patMatId=$p($g(^PAADM(paadmId)),"^",1)
	Quit:patMatId=""
	s PAADMNo=$p(^PAADM(paadmId),"^",81)
	q:(txtAdmNo'="")&(txtAdmNo'=$p($g(^PAPER(patMatId,"PAT",1)),"^",2))
	q:(txtPatName'="")&($p($g(^PAPER(patMatId,"ALL")),"^",1)'[txtPatName)
	s retAdmId=paadmId, retPatName=$p($g(^PAPER(patMatId,"ALL")),"^",1)
	s retAdmNo=$p($g(^PAPER(patMatId,"PAT",1)),"^",2)
	s retRegStatus=$p(strIAdm,"^",8)
	s retAdmDate=##class(websys.Conversions).DateLogicalToHtml($p(strIAdm,"^",5))
	s Diet=$p(strIAdm,"^",17)
	// IADM_GADM_DR
	s GADMDR=$p(strIAdm,"^",2)
	s GDesc=""
	i GADMDR'="" d
	.s GDesc=##class(web.DHCPE.DHCPEGAdm).GetGAdmDesc(GADMDR)
	// IADM_AccountAmount	应收金额
	s PreIADM=$p(strIAdm,"^",4)
	s Amount=..GetAmount(IAdmId,"I")
	q:+Amount=0
	s AccountAmount=$fn($p(Amount,"^",1),"",2)
	// IADM_FactAmount	最终金额
	s FactAmount=$fn($p(Amount,"^",2),"",2)
	;---- 取是否体检项目完成的状态----
	s isCompleted=""
	s RPId=$o(^DHCPERPT(0,"IADM",IAdmId,0))
	s ReportStatus=""
	i RPId'="" d
	.s ReportStatus=$p(^DHCPERPT(RPId),"^",2)
	;s ReportStatus=##class(web.DHCPE.Report).GetStatusDesc(ReportStatus)
	s Select=+$G(^DHCPEDataEx("DHCPECharge","Person",IAdmId))
	q:(HadAllowed="1")&&(Select=0)
	q:(HadAllowed="0")&&(Select=1)

	Do OutputRow1
	Quit
OutputRow1
	/*** 翻译 start ***/
	s retRegStatus=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeallowtocharge.hisui.csp",retRegStatus)
	/*** 翻译 end ***/
	set Data=$lb( retAdmId, retPatName, retAdmNo, retAdmDate,retRegStatus,isCompleted,Diet, IAdmId, AccountAmount, FactAmount,PAADMNo,ReportStatus,GDesc,Select)  //todo: Modify
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod AllowToChargeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AllowToChargeExecute ]
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

ClassMethod AllowToChargeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AllowToChargeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAmount(ID, Type)
{
	s amount=0
	s chargedAmount=0
	s auditId=0
	f  s auditId=$o(^DHCPEPreA(0,"GIADM",Type,ID,auditId))  q:auditId=""  d
	.s status=$p(^DHCPEPreA(auditId),"^",21)
	.q:status="NU"
	.s oneAmount=+$p(^DHCPEPreA(auditId),"^",9)
	.q:oneAmount=0
	.s amount=amount+oneAmount
	.s chargedStatus=$p(^DHCPEPreA(auditId),"^",14)
	.q:chargedStatus="UNCHARGED"
	.s chargedAmount=chargedAmount+oneAmount
	q amount_"^"_chargedAmount
}

}
