Import SQLUser

/// Created by Robert 2006/4/1
/// Description: 取体检项目的执行情况
/// test: d ##class(%ResultSet).RunQuery("web.DHCPE.Query.IAdmItemStatus", "query","","58","","","")
Class web.DHCPE.Query.IAdmItemStatus Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// 显示患者的项目执行状态
Query query(txtPatName As %String, txtGroupId As %String, BeginDate As %String, txtAdmNo As %String, txtItemId As %String, EndDate As %String = "", CheckedFlag As %String, Depart As %String = "") As %Query(ROWSPEC = "AdmId:%String,PatName:%String, AdmNo:%String,AdmDate:%String, AdmStatus:%String, IsCompleted:%Integer, Diet:%String, PEIAdmId:%String, AdmAccountAmount:%String,AdmFactAmount:%String,PAADMNo:%String,TReportStatus:%String,TGDesc:%String")
{
}

/// *******************************************
/// Rewrite by mlh 2008-06-10
///  test: d ##class(%ResultSet).RunQuery("web.DHCPE.Query.IAdmItemStatus", "query","","","","175","")
ClassMethod queryExecute(ByRef qHandle As %Binary, txtPatName As %String, txtGroupId As %String, BeginDate As %String, txtAdmNo As %String, txtItemId As %String, EndDate As %String, CheckedFlag As %String, Depart As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	
 	If $g(ind)="" Set ind=1
 	s txtPatName=##class(web.DHCPE.DHCPECommon).UnEscape(txtPatName)
 	s Depart=##class(web.DHCPE.DHCPECommon).UnEscape(Depart)
	s txtPatName=$g(txtPatName),  txtGroupId=$g(txtGroupId), BeginDate=$g(BeginDate), txtAdmNo=$g(txtAdmNo)
	s txtItemId=$g(txtItemId)
	i ((txtPatName="")&(txtGroupId="")&(BeginDate="")&(txtAdmNo="")&(EndDate="")){
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	s TotalAmout=0
	s TotalFact=0
	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	i txtAdmNo'="" s txtAdmNo=##class(web.DHCPE.DHCPECommon).RegNoMask(txtAdmNo)
	s vEndDate=EndDate
	i EndDate="" s vEndDate=+$H
	s vStartDate=BeginDate
	i BeginDate="" s vStartDate=0
	If txtAdmNo'="" Do
	.Set PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",txtAdmNo,0))
	.Quit:PIBI=""
	.Set PIADM=""
	.For  Set PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1)  Quit:PIADM=""  Do
	..Set IAdmId=""
	..For  Set IAdmId=$o(^DHCPEIADM(0,"CRMADM",PIADM,IAdmId),-1)  Quit:IAdmId=""  Do
	...Do GetIADMInfo
	Else  If txtPatName'="" d
	.s txtPatName=$$ALPHAUP^SSUTIL4(txtPatName)
	.s desc=$o(^DHCPEPreIBI(0,"Name",txtPatName),-1)
	.f  s desc=$o(^DHCPEPreIBI(0,"Name",desc)) q:(desc="")||(desc'[txtPatName)  d
	..s PIBI=0
	..f  s PIBI=$o(^DHCPEPreIBI(0,"Name",desc,PIBI)) q:PIBI=""  d
	...s PIADM=0
	...f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM)) q:PIADM=""  d
	....Set IAdmId=""
	....For  Set IAdmId=$o(^DHCPEIADM(0,"CRMADM",PIADM,IAdmId),-1)  Quit:IAdmId=""  Do
	.....Do GetIADMInfo
	
	else  if ($g(txtGroupId)'="") d
	.s TeamDR=0
	.f  s TeamDR=$o(^DHCPEIADM(0,"GADM",txtGroupId,TeamDR)) q:TeamDR=""  d
	..q:(txtItemId'="")&&(txtItemId'=TeamDR)
	..s IAdmId=""
	..f  s IAdmId=$o(^DHCPEIADM(0,"GADM",txtGroupId,TeamDR,IAdmId),-1) q:IAdmId=""  d
	...d GetIADMInfo
	
	
	Else  If EndDate'=""||BeginDate'="" Do
	.i EndDate="" s EndDate=+$H
	.s EndDate=EndDate+1
	.f  s EndDate=$o(^DHCPEIADM(0,"AdmDateTime",EndDate),-1) q:(EndDate<+BeginDate)||(EndDate="")  d
	..s Time=""
	..f  s Time=$o(^DHCPEIADM(0,"AdmDateTime",EndDate,Time),-1) q:Time=""  d
	...s IAdmId=""
	...f  s IAdmId=$o(^DHCPEIADM(0,"AdmDateTime",EndDate,Time,IAdmId),-1) q:IAdmId=""  d
	....Do GetIADMInfo
	Else  Do
	.Set IAdmId=""
	.For  Set IAdmId=$o(^DHCPEIADM(IAdmId),-1) Quit:IAdmId=""  Do
	..Do GetIADMInfo
 	d ClearValue
 	s AccountAmount=TotalAmout
 	s FactAmount=TotalFact
 	Do OutputRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	// "AdmId:%String,PatName:%String, AdmNo:,AdmDate:, AdmStatus:%String, IsCompleted:%Integer")
ClearValue
	s (retAdmId, retPatName, retAdmNo, retAdmDate,retRegStatus,isCompleted,Diet, IAdmId, AccountAmount, FactAmount,PAADMNo,ReportStatus,GDesc)=""
	quit
GetIADMInfo
	s strIAdm=^DHCPEIADM(IAdmId)
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmId)            //Add by 090702
  	q:LocFlag=1 
	q:($p(strIAdm,"^",8)="COMPLETED")
	s PEIDate=$p(strIAdm,"^",5)
	q:((+PEIDate)<vStartDate)&&(txtAdmNo="")
	q:((+PEIDate)>vEndDate)&&(txtAdmNo="")
	

	//过滤2007-07-12以前的数据    2007-07-25
	s PESystemStartDate=##class(web.DHCPE.Public.Setting).GetPESystemStartDate()
	q:$p(strIAdm,"^",5)<PESystemStartDate
	s needQ=0, GID=""
	i (txtGroupId'="")  d
	. s GAdmId=$p(strIAdm,"^",2)
	.// i GAdmId'=""  s GID=$p($g(^DHCPEGADM(GAdmId)),"^",1)
	. i (GAdmId'=txtGroupId)  s needQ=1
	.q:needQ=1
	.i txtItemId'="" d
	.. s GItemId=$p(strIAdm,"^",3)
	.. i (GItemId'=txtItemId)  s needQ=1
	q:(needQ=1)
	s paadmId=$p(strIAdm,"^",1)
	q:(paadmId="")
	//判断科室所在的医院是否一致                                          //add 2009-07-15
	s CurLocID=%session.Get("LOGON.CTLOCID")                           //add 2009-07-15
	s CurHospDR=$p($g(^CTLOC(CurLocID)),"^",22)                             //add 2009-07-15                            //add 2009-07-15
	s DepCodeDR=$P($g(^PAADM(paadmId)),"^",4)                       //add 2009-07-15
	i DepCodeDR'="" s HospDR=$p($g(^CTLOC(DepCodeDR)),"^",22)                                 //add 2009-07-15
	//q:CurHospDR'=HospDR 
     
	s patMatId=$p($g(^PAADM(paadmId)),"^",1)
	Quit:patMatId=""
	s PAADMNo=$p(^PAADM(paadmId),"^",81)
	S PatNameU=$$ALPHAUP^SSUTIL4($p($g(^PAPER(patMatId,"ALL")),"^",1))
	q:(txtAdmNo'="")&(txtAdmNo'=$p($g(^PAPER(patMatId,"PAT",1)),"^",2))
	q:(txtPatName'="")&(PatNameU'[txtPatName)
	;q:(txtPatName'="")&($p($g(^PAPER(patMatId,"ALL")),"^",1)'[txtPatName)
	s retAdmId=paadmId, retPatName=$p($g(^PAPER(patMatId,"ALL")),"^",1)
	s retAdmNo=$p($g(^PAPER(patMatId,"PAT",1)),"^",2)
	s retRegStatus=$p(strIAdm,"^",8)
	q:retRegStatus="CANCELPE"
	;s retAdmDate=$ZD($p(strIAdm,"^",5),3)
	s retAdmDate=##class(websys.Conversions).DateLogicalToHtml($p(strIAdm,"^",5))
	s Diet=$p(strIAdm,"^",17)
	s PreIADM=$p(strIAdm,"^",4)
	s ARCItemStatus=..GetIADMARCItemStatus(PreIADM)
     //Q:(CheckedFlag="on")&&(ARCItemStatus="6")
    Q:(CheckedFlag="checked")&&(ARCItemStatus="6") 
	s Diet=##class(web.DHCPE.PreIADM).GetDietFlagByID(PreIADM)
	s curDepart=$G(^DHCPEDataEx("DHCPEPreIADM","Position",PreIADM))
	q:(Depart'="")&&(curDepart'[Depart)
	
	s GADMDR=$p(strIAdm,"^",2)
	s GDesc=""
	i GADMDR'="" d
	.s GDesc=##class(web.DHCPE.DHCPEGAdm).GetGAdmDesc(GADMDR)
	// IADM_AccountAmount	应收金额
	s PreIADM=$p(strIAdm,"^",4)
	s Amount=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(PreIADM)
	s AccountAmount=+$p(Amount,"^",1)
	i $p(AccountAmount,".",1)="" s AccountAmount=0_AccountAmount
	s AccountAmount=$fn(AccountAmount,"",2)

	// IADM_FactAmount	最终金额
	s FactAmount=+$p(Amount,"^",2)
	i $p(FactAmount,".",1)="" s FactAmount=0_FactAmount
	s FactAmount=$fn(FactAmount,"",2)

	;---- 取是否体检项目完成的状态----
	s isCompleted=..IsOrdItemsCompleted(retAdmId)
	s RPId=$o(^DHCPERPT(0,"IADM",IAdmId,0))
	s ReportStatus=""
	i RPId'="" d
	.s ReportStatus=$p(^DHCPERPT(RPId),"^",2)
	s ReportStatus=##class(web.DHCPE.Report).GetStatusDesc(ReportStatus,paadmId)
	s TotalAmout=TotalAmout+AccountAmount
	s TotalFact=TotalFact+FactAmount
	Do OutputRow1
	Quit
OutputRow1
	set Data=$lb( retAdmId, retPatName, retAdmNo, retAdmDate,retRegStatus,isCompleted,Diet, IAdmId, AccountAmount, FactAmount,PAADMNo,ReportStatus,GDesc)  //todo: Modify
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// modify by jdl
/// test: d ##class(web.DHCPE.Query.IAdmItemStatus).queryExecute("","","","","175","")
ClassMethod queryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = queryExecute ]
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

ClassMethod queryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = queryFetch ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 打印条形码 获取患者信息和检验医嘱项信息
/// 使用组件: DHCPEIAdmItemStatusAdms    PatOrdItemInfo
/// w ##Class(web.DHCPE.Query.IAdmItemStatus).PatOrdItemInfo("","","8890^")
ClassMethod PatOrdItemInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "", AllowUnPayed As %Library.String = "", BDFlag As %Library.String = "", OrderFlag As %Library.String = "")
{
	s Data=##class(web.DHCPE.BarPrint).GetPatOrdItemInfo("","",InString,AllowUnPayed,BDFlag,OrderFlag)
	;i ""'=itmjs d
	;.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	;.&javascript<#(retval)#>
	Q Data
}

// w ##Class(web.DHCPE.Query.IAdmItemStatus).GetPatOrdItemInfo("","","3759277")

/// 判断指定的Adm的所有医嘱是否已经执行，(如果没医嘱返回0)
/// test: w ##Class(web.DHCPE.Query.IAdmItemStatus).IsOrdItemsCompleted(9707)
ClassMethod IsOrdItemsCompleted(AdmId As %String) As %Integer
{
	s STATUSStoped="4"
	s STATUSExecuted= "6" 

	s isCompleted=1, itemCount=0,ordIChd="0"
	s ordId=$o(^OEORD(0,"Adm",AdmId,""))
	if (ordId'="") {
		f  s ordIChd=$o(^OEORD(ordId,"I",ordIChd)) q:(ordIChd="")||(isCompleted=0)  d
		.s itemCount=itemCount+1
		.s hisOEItemDr=ordId_"||"_ordIChd
		.s ordIStatus=$p($G(^OEORD(ordId,"I",ordIChd,1)),"^",13)
		.
		.i (ordIStatus'=STATUSStoped)&(ordIStatus'=STATUSExecuted)  s isCompleted=0
	}
	i (isCompleted=1)&(itemCount=0)  s isCompleted=0
	
	q isCompleted
}

/// Description:获取患者检验项目的受检状态 即是否进入检验状态
/// creater	xuwm
/// date	2006.06.28
/// test:	d ##Class(%ResultSet).RunQuery("web.DHCPE.Report","SearchItemResultStatus","00000099")													
Query SearchItemResultStatus(RegNo As %String = "") As %Query(ROWSPEC = "IRS_ARCIM_Desc:%String, IRS_Station_Desc:%String, IRS_ItemResultStatus:%String")
{
}

ClassMethod SearchItemResultStatusExecute(ByRef qHandle As %Binary, RegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	if (""=RegNo) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s id=0
	f  s id=$o(^DHCPEIADM(id)) q:id=""  d
	.s CurData=$g(^DHCPEIADM(id))
	.// IADM_PAADM_DR --> PA_ADM.PAADM_RowID
	.s ADM=$p(CurData,"^",1)
	.q:(""=ADM)
	.
	.// 验证患者是否符合条件
	.// PAADM_PAPMI_DR   PA_ADM.PAADM_PAPMI_DR-->PA_PatMas.PAPMI_RowId
	.s PAADMPAPMIDR=$p($g(^PAADM(ADM)),"^",1)
	.q:(""=PAADMPAPMIDR)
	.
	.// PAPMI_IPNo 登记号 PA_PatMas
	.s PAPMIIPNo=$p(^PAPER(PAADMPAPMIDR,"PAT",1),"^",1)
	.Q:(PAPMIIPNo'=RegNo)
	.
	.// PAPMI_Name 患者姓名 PA_PatMas
	.s Name=$p(^PAPER(PAADMPAPMIDR,"ALL"),"^",1)	
	.
	.// 获取患者检验项目
    .// Adm --> OE_Order.OEORD_Adm_DR
    .s OEORDRowId=0
    .s OEORDRowId=$o(^OEORD(0,"Adm",ADM,OEORDRowId))
    .Q:(""=OEORDRowId)
    .
    .//OEORDRowId --> OE_OrdItem.OEORI_OEORD_ParRef
    .s OEORIChildsub=0
    .f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
    ..
    ..// OEORI_ItmMast_DR --> ARC_ItmMast.ARCIM_RowId
    ..s OEORIItmMastDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
    ..//OE_OrdItem.OEORI_ItemStat_DR -->OEC_OrderStatus.OSTAT_RowId
    ..s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
    ..//6	E	执行	Y
    ..i "6"=OEORIItemStatDR d
    ...s ItemResultStatus="Y"
    ..e  d
    ...s ItemResultStatus="N"
    ..//^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
    ..s ARCIMSubscript=$P(OEORIItmMastDR,"||",1)
    ..s ARCIMVersion=$P(OEORIItmMastDR,"||",2)
    ..// ARCIM_Desc 医嘱项目名称
    ..s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
    ..
    ..//获取站点名称
    ..s Station=##Class(web.DHCPE.StationOrder).FromARCIMToStation(OEORIItmMastDR)
    ..set Data=$lb(ARCIMDesc, Station, ItemResultStatus)
    ..d IADMItemStatus
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IADMItemStatus
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchItemResultStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchItemResultStatusExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchItemResultStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchItemResultStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatOrdItemInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "", IsPreview As %String = "N")
{
	q ##class(web.DHCPE.PrintNewDirect).GetPrintInfo(InString,IsPreview)
	s AdmId=$P(InString,"^",1)
	s curLoc=%session.Get("LOGON.CTLOCID")
	s curUser=%session.Get("LOGON.USERID")
	s ^TMPPOI("GetPatOrdItemInfo","ItemOrder",$j)=0
	k ^TMPPOI("LabSpecNo",$j)
	s DeitFlag=$P(InString,"^",2)
	s DeitFlag="true"
	s AdmType=$P(InString,"^",3)
	s regDate=""
	s labPatItem=""
	s LabItemNum=0
	s OtherlabPatItem=""
	s OtherLabItemNum=0
	i AdmType'="CRM"
	{
		i AdmType="IADM"
		{
			s Flag=##class(web.DHCPE.DHCPEIAdm).HaveNoPayedItem(AdmId)
			q:Flag="1" "NoPayed"
			s AdmId=$p($g(^DHCPEIADM(AdmId)),"^",4)
		}else{
			s AdmId=$o(^DHCPEIADM(0,"PAADM",AdmId,0))
			s Flag=##class(web.DHCPE.DHCPEIAdm).HaveNoPayedItem(AdmId)
			q:Flag="1" "NoPayed"
			s AdmId=$p($g(^DHCPEIADM(AdmId)),"^",4)
		}
	}
	d ##class(web.DHCPE.AdmRecordManager).Insert(AdmId,"P","PrintDJD","","")
	
	s iadm=$O(^DHCPEIADM(0,"CRMADM",AdmId,0))
	i iadm'="" d
	.s regDate=$p(^DHCPEIADM(iadm),"^",5)
	.i regDate'="" s regDate=$ZD(regDate,3)
	s Diet=##class(web.DHCPE.PreIADM).GetDietFlagByID(AdmId)
	i Diet="1"
	{
		s DeitFlag="true"
	}
	else
	{
		s DeitFlag="false"
	}
	s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	s Delim=$c(2)
	s BaseId=$p(^DHCPEPreIADM(AdmId),"^",1)  //预登记个人基本信息表
	q:BaseId=""
	s ParInfo=$g(^DHCPEPreIBI(BaseId))
	
	s TypeID=$p(^DHCPEPreIADM(AdmId),"^",25)   //类型
	s Type=##class(web.DHCPE.PreCommon).GetPreTypeDesc(TypeID)
	s recheck=##class(web.DHCPE.PreCommon).GetReCheckFlag(AdmId,"PreADM")
	s recheck=recheck+1
	s recheck="第"_recheck_"次"
	
	s RegNo=$P(ParInfo,"^",1)		// 登记号
    s CardID=##class(web.DHCPE.PreIBIUpdate).GetRelate(RegNo,"R")
    i CardID="" s CardID=RegNo
    //i HospitalCode="ZSSY" s CardID=RegNo
    s BarRegNo="*"_RegNo_"*"
    
    s PatName = $P(ParInfo,"^",2)	// 姓名
	s Position=$G(^DHCPEDataEx("DHCPEPreIADM","Position",AdmId))  //$P(ParInfo,"^",11)	// 部门
	i Position="" s Position=$P(ParInfo,"^",11)	// 部门
	s CompanyName=$P(ParInfo,"^",12)	// 公司
	s MobilePhone=$P(ParInfo,"^",8)
	i MobilePhone="" s MobilePhone=$P(ParInfo,"^",7)
	i MobilePhone="" s MobilePhone=$P(ParInfo,"^",6)
	s IDCard=$P(ParInfo,"^",9)
	s Address=$P(ParInfo,"^",14)
	
	s PatAge = $P(ParInfo,"^",4)	// 年龄
	s PatAge=##class(web.DHCLCNUREXCUTE).CalAge(PatAge,+$h)
	s PatAge=$P(PatAge,"Y",1)
	
	s BedCode = "" //$P(ParInfo,"^",8)	// 床号
	
	s Sex = $P(ParInfo,"^",3)		// 性别
	i Sex'="" d
	.s Sex=$p($g(^CT("SEX",Sex)),"^",2)
	
	s PatLoc = "" //$P(ParInfo,"^",2)	// 部门	
	i Position'="" s CompanyName="("_Position_")"_CompanyName
	s GADMDR=$P($G(^DHCPEPreIADM(AdmId)),"^",2)
	s GTeam=$P($G(^DHCPEPreIADM(AdmId)),"^",3)
	s SortNo=""
	s GTeamDesc=""
	s Company="个人"
	i ""'=GADMDR d
	.s GBIDR=$P($G(^DHCPEPreGADM(GADMDR)),"^",1)
	.s Company=$P($G(^DHCPEPreGBI(GBIDR)),"^",2)
	.s GTeamDesc=""
	.i GTeam'="" d
	..s GTeamDesc=$p(^DHCPEPreGADM(+GTeam,"Team",$p(GTeam,"||",2)),"^",1)
	..s Char=##class(web.DHCPE.PreIADM).NumToChar($p(GTeam,"||",2))
	..s SortNo=Char_$G(^DHCPEDataEx("DHCPEPreIADM","GTEAM","IADM",AdmId))
	.s Company=Company
	//.s TotalFee=""
	//e  d
	//.s TotalFee=##class(web.DHCPE.PreItemList).IGetOrdAmount(AdmId,"PERSON")
	//.s i=$l(TotalFee,$C(13))
	//.//s TotalFee=$p(TotalFee,$C(13),4) //"应收: "_$p(TotalFee,$C(13),2)_"优惠: "_$p(TotalFee,$C(13),4)
	
	/*
	e  d
	.s Company="(个人客户)"
	.s GTeamDesc=""
	*/
	
	s HOSPDesc=$g(^DHCPESetting("DHCPE","HospitalName"))
	
	s Hospital= HOSPDesc_"体检导检单"	// 体检单位
	
	s PrintUser=%session.Get("LOGON.USERID")
	//s PrintUser="62"
	i PrintUser'="" s PrintUser=$p($G(^SSU("SSUSR",PrintUser)),"^",1)
	
	s PrintDate=+$H
	s PrintDate=$ZD(PrintDate,3)
	s PrintTime=$p($h,",",2)
	s PrintTime=$zt(PrintTime,4)
	s PrintDate=PrintDate_" "_PrintTime
	
	s ReportDate=$G(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",AdmId))
	i ReportDate'="" s ReportDate=$ZD(+ReportDate,3)
	
	
	s BookDateFrom=$p(^DHCPEPreIADM(AdmId),"^",4)  //预约日期
	s BookDateFrom=$zd(BookDateFrom,3)
	s BookDateTo=$p(^DHCPEPreIADM(AdmId),"^",5)
	s BookDateTo=$zd(BookDateTo,3)
	s PreDate=BookDateFrom_"--"_BookDateTo
	
	s TJZXTel="024-83282013"
   
    s OrderSetsDesc=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(AdmId)
	
	///自动转换导检单排列顺序
	d ##class(web.DHCPE.SetPatItem).UpdatePatItemSort()
	
	s TotalFee=0
	s PhotoFlag=0 
	
	s docName=""
	s OEOrdItem=$$GetOEOrdItem(AdmId,"Lab","PRE^Preprandial^")
	i HospitalCode="SYYD" s OEOrdItem=..splitLine("注意^请前台登记放射、CT项目^^")_OEOrdItem
	
	s TotalFee=##class(web.DHCPE.PreItemList).IGetOrdAmount(AdmId,"PERSON")
	s i=$l(TotalFee,$C(13))
	s TotalFee=$p(TotalFee,$C(13),4) //"应收: "_$p(TotalFee,$C(13),2)_"优惠: "_$p(TotalFee,$C(13),4)
	
	
	s TotalFee=$j(TotalFee,3,2)
	i ""'=GADMDR d
	.s TotalFee=""
	s VIPID="",VIPDesc=""
	s VIPID=$p($g(^DHCPEPreIADM(IAdmId)),"^",18)
	s:(VIPID'="") VIPDesc=$p($G(^DHCPEVIPLevel("VIP",VIP)),"^",2)
	s:((VIPDesc["VIP")||(VIPDesc["vip")) PrintDate=$zd($p($g(^DHCPEPreIADM(IAdmId)),"^",4),3)_" "_$zt($p($g(^DHCPEPreIADM(IAdmId)),"^",6),4)
	;s PrintDate=""
	s ParTag ="RegNo"_"^"_"PatName"_"^"_"PatAge"_"^"_"Sex"_"^"_"Company"_"^"_"Hospital"_"^"_"VIP"_"^"_"AddOrdItem"_"^"_"AddPhcItem"_"^TotalFee"_"^GTeamDesc"_"^GPositionDesc"_"^ReportDate"_"^PrintUser"_"^PrintDate"_"^recheck"_"^PreDate"_"^OrderSetsDesc"_"^CompanyName"_"^MobilePhone"_"^TJZXTel"_"^BarRegNo"_"^regDate"
	s ParInfo=RegNo_"^"_   PatName_"^"_  PatAge_"^"_  Sex_"^"_  Company_"^"_Hospital_"^"_  $$GetPEPatientInfo(AdmId)_"^"_TotalFee_"^"_GTeamDesc_"^"_Position_"^"_ReportDate_"^"_PrintUser_"^"_PrintDate_"^"_recheck_"^"_PreDate_"^"_$g(OrderSetsDesc)_"^"_CompanyName_"^"_MobilePhone_"^"_TJZXTel_"^"_BarRegNo_"^"_regDate
	s ParInfo=$TR(ParInfo,$c(10)," ")
	s ParInfo=$TR(ParInfo,$c(13,10)," ")
	s ParTag=ParTag_"^"_"docName"
	s ParInfo=ParInfo_"^"_docName
	//i ((HospitalCode="NBMZ")||(HospitalCode="SHHS")) d
	s ParTag=ParTag_"^SortNo"
	s ParInfo=ParInfo_"^"_SortNo
	s ParTag=ParTag_"^Address"
	s ParInfo=ParInfo_"^"_Address
	s ParTag=ParTag_"^PersonID"
	s ParInfo=ParInfo_"^"_IDCard
	s CheckRoom=$G(^DHCPEDataEx("DHCPEPreIADM","CheckRoom",AdmId))
	i CheckRoom'="" s CheckRoom=$P($G(^DHCPEDataEx("RoomCheck",curLoc,CheckRoom)),"^",1)
	s ParTag=ParTag_"^CheckRoom"
	s ParInfo=ParInfo_"^"_CheckRoom
	s PatOrdFlag=$G(^DHCPESetting("DHCPE","PatOrdFlag"))
	
	if (DeitFlag="true")&&((VIPDesc'["VIP")&&(VIPDesc'["vip")) d
	.s ParTag=ParTag_"^DietFlag"
	.s ParInfo=ParInfo_"^早餐"
	s PhotoFlag=##class(web.DHCPE.PreIADM).GetPhotoFlag(AdmId)
	if (PhotoFlag>0)&&((VIPDesc'["VIP")&&(VIPDesc'["vip")) d
	.s ParTag=ParTag_"^PhotoFlag"
	.s ParInfo=ParInfo_"^片子"
	
	
	
	/*if DeitFlag="true" d
	.s OEOrdItem=$$Getflow1()_$$GetOEOrdItem(AdmId,"Lab","PRE^Preprandial^")_$$GetOEOrdItem(AdmId,"PRERis","PRE^Preprandial^")_$$GetOEOrdItem(AdmId,"PRE","PRE^Preprandial^")_$$Getflow2()_$$GetOEOrdItem(AdmId,"LabPost","PRE^Preprandial^")_$$GetOEOrdItem(AdmId,"POSTRis","POST^Postprandial^N^")_$$GetOEOrdItem(AdmId,"POST","POST^Postprandial^N^")
	.//s OEOrdItem=$$GetOEOrdItem(AdmId,"Lab","PRE^Preprandial^")_$$GetOEOrdItem(AdmId,"PRERis","PRE^Preprandial^")_$$GetOEOrdItem(AdmId,"PRE","PRE^Preprandial^")_$$Getflow2()_$$GetOEOrdItem(AdmId,"LabPost","PRE^Preprandial^")_$$GetOEOrdItem(AdmId,"POSTRis","POST^Postprandial^N^")_$$GetOEOrdItem(AdmId,"POST","POST^Postprandial^N^")_$$Getflow3()
	else  d
	.s OEOrdItem=$$Getflow1()_$$GetOEOrdItem(AdmId,"Lab","PRE^Preprandial^")_$$GetOEOrdItem(AdmId,"PRERis","PRE^Preprandial^")_$$GetOEOrdItem(AdmId,"PRE","PRE^Preprandial^")_$$GetOEOrdItem(AdmId,"LabPost","PRE^Preprandial^")_$$GetOEOrdItem(AdmId,"POSTRis","POST^Postprandial^N^")_$$GetOEOrdItem(AdmId,"POST","POST^Postprandial^N^")
	*/
	
	
	
	i GADMDR="" d
	.s ParTag=ParTag_"^TMessage1^TMessage2^TMessage3^TMessage4"
	.s ParInfo=ParInfo_"^1、个人交费地点：一楼简易门诊对面5、6号窗口。取报告地点：一楼验单发放处^2、取报告时间：抽血当天16:00  周一、周二、周三、周四、周五、周六上午^   周一至周五8:00-11:45、14:15-17:15；周六8:00-11:30^3、自己保管体检表，取完所有报告后找医生写结论（各诊室均可）"
	e  d
	.s ParTag=ParTag_"^TGroupMessage1"
	.s ParInfo=ParInfo_"^体检完毕请讲此单交回体检中心发单处"
	
	s ret=ParTag_";"_ParInfo_"#"_OEOrdItem
    ;s ^fxtmp("RegNo",RegNo)=ret
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	.&javascript<#(retval)#>
	
	s iadm=$O(^DHCPEIADM(0,"CRMADM",AdmId,0))
	i iadm'="" d
	.s PAADM=$P(^DHCPEIADM(iadm),"^",1)
	.d:PAADM'="" ..PatItemPrintFlag(PAADM)
	
	k ^TMPPOI("GetPatOrdItemInfo","ItemOrder",AdmId,$j)
	
	k ^TMPPOI("GetPatOrdItemInfo",AdmId,$j)
    Q ret

  




GetPEPatientInfo(IAdmId)
	// DHC_PE_IADM.{ IADM_RowId }
	s CurData=$G(^DHCPEPreIADM(IAdmId))
	s GADMDR=$P(CurData,"^",2)
	s ret=""
	i ""'=GADMDR d
	.// IADM_AddOrdItem
	.s IADMAddOrdItem=$P(CurData,"^", 10) // 21
	.// IADM_AddOrdItemLimit
	.s IADMAddOrdItemLimit=$P(CurData,"^", 11) //22
	.// IADM_AddOrdItemAmount
	.s IADMAddOrdItemAmount=$P(CurData,"^", 12) //23
	.
	.i "N"=IADMAddOrdItem d
	..s ret=ret_"自费"
	.
	.i ("Y"=IADMAddOrdItem)&("N"=IADMAddOrdItemLimit) d
	..s ret=ret_"公费,不限"
	.
	.i ("Y"=IADMAddOrdItem)&("Y"=IADMAddOrdItemLimit) d
	..
	..s ret=ret_"公费限"_IADMAddOrdItemAmount_"元"
	.
	.// IADM_AddPhcItem
	.s IADMAddPhcItem=$P(CurData,"^", 13) //24
	.// IADM_AddPhcItemLimit
	.s IADMAddPhcItemLimit=$P(CurData,"^", 14) // 25
	.// IADM_AddPhcItemAmount
	.s IADMAddPhcItemAmount=$P(CurData,"^", 15) // 26
	.
	.s ret=ret_"^"
	.i "N"=IADMAddPhcItem d
	..s ret=ret_"自费"
	.
	.i ("Y"=IADMAddPhcItem)&("N"=IADMAddPhcItemLimit) d
	..s ret=ret_"公费,不限金额"
	.	
	.i ("Y"=IADMAddPhcItem)&("Y"=IADMAddPhcItemLimit) d
	..s ret=ret_"公费限"_IADMAddPhcItemAmount_"元"
	// 个人客户
	i ""=GADMDR d
	.s ret=ret_"不限"
	.s ret=ret_"^"
	.s ret=ret_"不限"
	
	//  PIADM_VIP
	s VIP=$P(CurData,"^", 18)
	s:VIP'="" VIP=$G(^DHCPEVIPLevel("VIP",VIP))
	s:(""'=VIP) VIP=$Extract("☆☆☆☆☆",1,+VIP)
	s ret=VIP_"^"_ret
	Q ret
    // AdmId = OE_Order.{OEORD_Adm_DR} = PA_ADM.{PAADM_RowID}
    // d GetOEOrdItem^DHCPEBarPrint("9577")
    // w $$GetOEOrdItem^DHCPEOEItemPrint("9629")
    // w ##Class(web.DHCPE.Query.IAdmItemStatus).GetPatOrdItemInfo("","","")
    //STDesc:Lab,PRERis,POSTRis,PRE,POST   检验、餐前检查、餐后检查、饭前、饭后
GetOEOrdItem(AdmId,STDesc,Diet)
    s ret=""
	s iLLoop=0
	s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other"))
	s NoReportStation=$G(^DHCPESetting("DHCPE","NoReportStation"))
	s OtherStation="^"_OtherStation_"^"_NoReportStation_"^"
	s OEORILabEpisodeNo="",docName=""
	s ChildId=0  ,additem=""
	f  s ChildId=$o(^DHCPEPreIADM(AdmId,"ORDITEM",ChildId)) q:ChildId=""  d 
	.s myStr=$G(^DHCPEPreIADM(AdmId,"ORDITEM",ChildId))
	.s PrintRecord=+$O(^DHCPEDataEx("OEOrder","PatTtemHadPrint",AdmId_"||"_ChildId,""),-1)+1
	.s ^DHCPEDataEx("OEOrder","PatTtemHadPrint",AdmId_"||"_ChildId,PrintRecord)=$H_"^"_curUser
	
	.s OEORIItmMastDR=$P(myStr,"^",1)
    .q:$o(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,0))=""  // 当医嘱在站点与大项中未关联退出
	.s ARCSequence=$G(^DHCPECTDataEx("DHCPEStationOrder","Sequence",OEORIItmMastDR))
	.i ARCSequence="" s ARCSequence="0"
	.s PatItemNameID=+$G(^DHCPECTDataEx("PatItemSort",OEORIItmMastDR))
	.s PatItemName="没有分类"
	.s PatItemSort="0"
	.s PatItemPlace=""
	.i PatItemNameID'=0 d
	..s PatItemName=$p($G(^DHCPECTDataEx("PatItem",PatItemNameID)),"^",1)
	..s PatItemSort=$p($G(^DHCPECTDataEx("PatItem",PatItemNameID)),"^",2)
	..s PatItemPlace=$G(^DHCPECTDataEx("PatItem",PatItemNameID,"Place",curLoc))
	..s PatItemPlace=$tr(PatItemPlace," ","")
	.
	.s PIOIOrdEntDR=$P(myStr,"^",2)  //判断是否 有医嘱套  zhouli
	.i PIOIOrdEntDR=""  s additem="*"
	.s UFlag=$P(myStr,"^",16)
	.q:UFlag'=1
	.i docName="" d
	..s userID=$P(^DHCPEPreIADM(AdmId,"ORDITEM",ChildId),"^",11)
	..i (userID'="") d
	...s docName=$P(^SSU("SSUSR",userID),"^",1)
	.s UFlag=0
	.//判断是否退费申请过
	.s feesub=0
	.i PIOIOrdEntDR'="" d
	..f  s feesub=$O(^DHCPEPreIADM(AdmId,"ORDENT",$P(PIOIOrdEntDR,"||",2),"FEE",feesub)) q:feesub=""  d
	...s preAuditID=$P(^DHCPEPreIADM(AdmId,"ORDENT",$P(PIOIOrdEntDR,"||",2),"FEE",feesub),"^",5)
	...q:preAuditID=""
	...s auditStat=$P(^DHCPEPreA(preAuditID),"^",21)
	...q:auditStat="NU"
	...s papbID=$O(^DHCPEPAPBR(0,"PADR",preAuditID,0))
	...q:papbID=""
	...s pbID=$P(^DHCPEPAPBR(papbID),"^",2)
	...s invID=$O(^DHCPEINVPRT(0,"PB",pbID,0))
	...s refundIDs=$G(^DHCPEDataEx("DHCPERefundApply","SelectIds",invID))
	...s:refundIDs[(",2^"_PIOIOrdEntDR_"||"_feesub_",") UFlag=1
	.e  d
	..f  s feesub=$O(^DHCPEPreIADM(AdmId,"ORDITEM",ChildId,"FEE",feesub)) q:feesub=""  d
	...s preAuditID=$P(^DHCPEPreIADM(AdmId,"ORDITEM",ChildId,"FEE",feesub),"^",5)
	...q:preAuditID=""
	...s auditStat=$P(^DHCPEPreA(preAuditID),"^",21)
	...q:auditStat="NU"
	...s papbID=$O(^DHCPEPAPBR(0,"PADR",preAuditID,0))
	...q:papbID=""
	...s pbID=$P(^DHCPEPAPBR(papbID),"^",2)
	...s invID=$O(^DHCPEINVPRT(0,"PB",pbID,0))
	...s refundIDs=$G(^DHCPEDataEx("DHCPERefundApply","SelectIds",invID))
	...s:refundIDs[(",1^"_AdmId_"||"_ChildId_"||"_feesub_",") UFlag=1
	.q:UFlag=1
	.//看医嘱是否已经执行
	.s ExecFlag=""
	.s CRMOrdID=$o(^DHCPECRMO(0,"CRMORI",AdmId_"||"_ChildId,0))
	.i CRMOrdID'="" d
	..s OEOrdID=$p(^DHCPECRMO(CRMOrdID),"^",1)
	..i OEOrdID'="" s OEORIItemStatDR=$p($G(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),1)),"^",13)
	..;i ($g(OEORIItemStatDR)'=1)&&(GADMDR'="") s UFlag=1   //2009,12,18
	..i ($g(OEORIItemStatDR)'=1)&&(GADMDR="") s ExecFlag="已执行"
	..//i OEOrdID="" s UFlag=1    //2009,12,18
	..s OEORILabEpisodeNo=$p($G(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),3)),"^",20)
	.i OEORILabEpisodeNo'="" d
	..;采血标本数量
	..i '$D(^TMPPOI("LabSpecNo",$j,OEORILabEpisodeNo)) d
	...s SpecName=##class(web.DHCPE.BarPrint).GetSpecName(OEOrdID)
	...i SpecName[("血") d
	....s labPatItem=PatItemName
	....s LabItemNum=LabItemNum+1
	...e  d
	....s OtherlabPatItem=PatItemName
	....s OtherLabItemNum=OtherLabItemNum+1
	...s ^TMPPOI("LabSpecNo",$j,OEORILabEpisodeNo)=""
	.s:OEORILabEpisodeNo="" OEORILabEpisodeNo=1
	.q:UFlag=1
	.i $G(^DHCPECTDataEx("DHCPEStationOrder","Photo",OEORIItmMastDR))="Y" d
	..s PhotoFlag=PhotoFlag+1
	.//s Price=##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(OEORIItmMastDR)
	.s Price=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(AdmId_"||"_ChildId,"","")
	.s Price=$j(Price,3,2)
	.s TotalFee=TotalFee+Price
	.s:GADMDR'="" Price=""
	.s ARCIMSubscript=$P(OEORIItmMastDR,"||",1)
	.s ARCIMVersion=$P(OEORIItmMastDR,"||",2)
	.s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	.i ARCIMDesc="一般检查" s ARCIMDesc="身高      体重      血压          心率"
	.i ARCIMDesc="身高、体重" s ARCIMDesc="身高______体重______"
	.i ARCIMDesc="血压检查" s ARCIMDesc="血压_____________"
	.i ARCIMDesc="眼科检查" s ARCIMDesc="眼科检查   右：    左：   矫正  佩戴隐形眼镜"
	.i OEORILabEpisodeNo'=1 s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",3)
	.i $D(^DHCPECTDataEx("DHCPEStationOrder","SpecialItem",OEORIItmMastDR,curLoc))&&($G(^DHCPECTDataEx("DHCPEStationOrder","SpecialItem",OEORIItmMastDR,curLoc))="Y")  S ARCIMDesc="** "_ARCIMDesc
    .//q:'$d(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR))
    .s STRowId="0"
	.s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,STRowId))
    .s Station="^"_STRowId_"^"
	.Q:(""=STRowId)
	.q:OtherStation[Station
	.///添加检查科室的位置
	.//s STLoc=$p(^DHCPEST(STRowId),"^",3)
	.s STLoc=$G(^DHCPECTDataEx("DHCPEStation",STRowId,"Place",curLoc))
	.i PatItemPlace'="" s STLoc=PatItemPlace
	.s STName=ExecFlag  //$p(^DHCPEST(STRowId),"^",2)  //zhouli
	.s STORDChildSub="0"
	.s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,STRowId,STORDChildSub))
	.Q:(""=STORDChildSub)
	.s STORDDiet=$P($G(^DHCPEST(STRowId, "O", STORDChildSub)),"^",2)
	.
	.i STORDDiet="PRE" s STORDDiet="1"
	.i STORDDiet="POST" s STORDDiet="5"
	.i STORDDiet="N" s STORDDiet="3"
	.i STORDDiet="" s STORDDiet="3"
	.//s Notice=$P($G(^DHCPEST(STRowId, "O", STORDChildSub)),"^",5)
	.s Notice=$G(^DHCPECTDataEx("DHCPEStationOrder","NoticeInfo",OEORIItmMastDR,curLoc))
	.i Notice'="" s STLoc=Notice  //
	.i $L(STLoc,"&")>1 d
	..i GADMDR'="" d
	...s STLoc=$P(STLoc,"&",2)
	..e  d
	...s STLoc=$P(STLoc,"&",1)
	.s StationType=##class(web.DHCPE.Public.Setting).GetStationType(STRowId)
	.;s:StationType="Lab" labPatItem=PatItemName
	.s iLLoop=iLLoop+1
	.//I $o(^TMPPOI("GetPatOrdItemInfo",AdmId,$j,STDesc,STRowId,0))'="" s STName=""
	.s STSequence=$P($G(^DHCPEST(STRowId)),"^",4)
	.i STSequence="" s STSequence="999999999"
	.i STRowId=$g(^DHCPESetting("DHCPE","StationId_Medical"))  d
	..s RecLocID=$p($G(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),3)),"^",6)
	..i RecLocID'="" s STLoc=$p(^CTLOC(RecLocID),"^",2)_"取药"
	.s ^TMPPOI("GetPatOrdItemInfo",AdmId,$j,STORDDiet,PatItemSort,STSequence,OEORILabEpisodeNo,ARCSequence,iLLoop,OEORIItmMastDR)=PatItemName_"^"_ARCIMDesc_"^"_STLoc_"^"_OEORILabEpisodeNo_"^"_STName_"^"_additem_"^"_STLoc_"^"_Price // 标本号:
	i DeitFlag="true" d
    .;s ^TMPPOI("GetPatOrdItemInfo",AdmId,$j,2         ,1          ,1                 ,1         ,1         ,iLLoop ,1)=$$Getflow2() //"早餐"_"^"_"米"_"^"_Notice_"^"_OEORILabEpisodeNo_"^"_STName_"^"_additem   // 标本号:
    s ^wrz("IADM")=OtherLabItemNum_"^"_OtherlabPatItem
    k ^TMPPOI("LabSpecNo",$j)
    s ret=""
    s STORDDiet=""
    f  s STORDDiet=$o(^TMPPOI("GetPatOrdItemInfo",AdmId,$j,STORDDiet))  q:STORDDiet=""  d
    .s PatSort=""
    .f  s PatSort=$o(^TMPPOI("GetPatOrdItemInfo",AdmId,$j,STORDDiet,PatSort))  q:PatSort=""  d
    ..s i=0
    ..s OldNotice=""
    ..s STRowID=0
    ..f  s STRowID=$O(^TMPPOI("GetPatOrdItemInfo",AdmId,$j,STORDDiet,PatSort,STRowID))  Q:STRowID=""   d
    ...s LabEpisodeNo=""
    ...f  s LabEpisodeNo=$O(^TMPPOI("GetPatOrdItemInfo",AdmId,$j,STORDDiet,PatSort,STRowID,LabEpisodeNo))  Q:LabEpisodeNo=""   d
    ....s ItemDesc=""
    ....s EmptyFlag="0"
    ....s ARCSequence=""
    ....f  s ARCSequence=$O(^TMPPOI("GetPatOrdItemInfo",AdmId,$j,STORDDiet,PatSort,STRowID,LabEpisodeNo,ARCSequence),-1)  Q:ARCSequence=""   d
    .....s Sub=0
    .....f  s Sub=$O(^TMPPOI("GetPatOrdItemInfo",AdmId,$j,STORDDiet,PatSort,STRowID,LabEpisodeNo,ARCSequence,Sub)) Q:(""=Sub)  d
    ......s ARCIMID=""
    ......f  s ARCIMID=$o(^TMPPOI("GetPatOrdItemInfo",AdmId,$j,STORDDiet,PatSort,STRowID,LabEpisodeNo,ARCSequence,Sub,ARCIMID)) q:ARCIMID=""  d
    .......s quitFlag=0
    .......i $D(^DHCPECTDataEx("RelatedItem",ARCIMID)) d 
    ........s oldArcim=^DHCPECTDataEx("RelatedItem",ARCIMID)
    ........s:$o(^DHCPEPreIADM(0,"ItmMast",oldArcim,AdmId,0))'="" quitFlag=1 
    .......q:quitFlag=1
    .......s CurData=$G(^TMPPOI("GetPatOrdItemInfo",AdmId,$j,STORDDiet,PatSort,STRowID,LabEpisodeNo,ARCSequence,Sub,ARCIMID))
    .......i ($P(CurData,"^",1)=labPatItem)&&(LabItemNum'=0) d
    ........s $P(CurData,"^",1)=$P(CurData,"^",1)_"("_LabItemNum_")"
    .......i ($P(CurData,"^",1)=OtherlabPatItem)&&(OtherLabItemNum'=0) d
    ........s $P(CurData,"^",1)=$P(CurData,"^",1)_"("_OtherLabItemNum_")"
    .......s:$P(CurData,"^",7)[("空腹") EmptyFlag=1
    .......i OldNotice=$p(CurData,"^",3) d
    ........s $p(CurData,"^",3)=""
    .......e  d
    ........s OldNotice=$p(CurData,"^",3)
    .......i i=1 d
    ........s $p(CurData,"^",1)=""
    .......s ArcDesc=$P(CurData,"^",2)
    .......i LabEpisodeNo'="1" d
    ........i ItemDesc="" d
    .........s ItemDesc=ArcDesc
    ........e  d
    .........s ItemDesc=ItemDesc_"、"_ArcDesc
    .......q:LabEpisodeNo'="1"
    .......s i=1
    .......i ret="" d
    ........s ret=ret_..splitLine(CurData)
    .......e  d
    ........s ret=ret_..splitLine(CurData)
    .......d ..AddTarItemInfo(AdmId,ARCIMID,CurData,.ret)
    .......s tmpLoop=0,tmpflag=0
    .......f  s tmpLoop=$o(^DHCPEDataEx("RelateItem",ARCIMID,tmpLoop)) q:tmpLoop=""  d
    ........s RelateItem=$g(^DHCPEDataEx("RelateItem",ARCIMID,tmpLoop))
    ........q:$o(^DHCPEPreIADM(0,"ItmMast",RelateItem,AdmId,0))=""
    ........s PIOISub=$o(^DHCPEPreIADM(0,"ItmMast",RelateItem,AdmId,0))
    ........s PIOIStat=$p(^DHCPEPreIADM(AdmId,"ORDITEM",PIOISub),"^",16)
    ........q:PIOIStat'=1
    ........s RelateData=CurData
    ........s $p(RelateData,"^",1)=""
    ........s $p(RelateData,"^",2)=$P($G(^ARCIM($p(RelateItem,"||",1),$p(RelateItem,"||",2),1)),"^",2)
    ........i ret="" d
    .........s ret=ret_..splitLine(RelateData)
    ........e  d
    .........s ret=ret_..splitLine(RelateData)
    ........d ..AddTarItemInfo(AdmId,RelateItem,CurData,.ret)
	....i LabEpisodeNo'="1" d
	.....i EmptyFlag="1" d
	......s Notice=$P(CurData,"^",7)
	......i '(Notice[("空腹")) d
	.......s Notice=Notice_"(空腹)"
	.......s $P(CurData,"^",7)=Notice
	
	.....s i=1
	.....s $P(CurData,"^",2)=ItemDesc
	.....i ret="" d
    ......s ret=ret_..splitLine(CurData)
    .....e  d
    ......s ret=ret_..splitLine(CurData) 
	Q ret
	

	// 体检流程 前台
Getflow1()
	s ret=""
	q:+PatOrdFlag=0 ret
	s ret=ret_..splitLine("前台^登记^留取个人详细资料^")
	s ret=ret_..splitLine("^领取体检表^核实体检项目^^")
	//s ret=ret_..splitLine("^领取尿,便标本盒^留尿,便标本^")
	Q ret
	// 体检流程 前台
Getflow2()
	s ret=""
	//s ret=ret_..splitLine("餐饮区^免费营养早餐^^^^^体检中心登记处^") //请到二楼餐厅就餐
	s ret=ret_"餐饮区^免费营养早餐^^^^^体检中心登记处^" //请到二楼餐厅就餐
	//s ret=ret_"餐后^领取尿,便标本盒^留尿,便标本^"
	Q ret
	// 体检流程 前台
Getflow3()
	s ret=""
	q:$p(PatOrdFlag,"^",2)=0 ret
	s ret=ret_..splitLine("前台^交体检表,结账^^^^^^")
	//s ret=..splitLine(ret)
	Q ret
FromARCIMToStation(ARICM)
	&sql(
		select STORD_ParRef->ST_RowId,STORD_ParRef->ST_Desc,STORD_Diet into :STRowId, :STation,:STORDDiet 
		from DHC_PE_StationOrder 
		where STORD_ARCIM_DR=:ARICM
		)
	Q:("0"'=SQLCODE) ""
	
	s DietSesc=""
	i ("Preprandial"=STORDDiet)||("PRE"=STORDDiet) s DietSesc="空腹项目"
	i ("Postprandial"=STORDDiet)||("POST"=STORDDiet) s DietSesc="餐后项目"  //
	
	Q STRowId_"^"_STation_"^"_DietSesc
}

// 体检套餐1：1||1，1||2，胸部正侧位套餐、腰部正侧位套餐

// 胸部正侧位套餐2：1||3，1||4    打印套餐名 ：胸部正位

// 腰部正侧位套餐3:1||3,1||5

// d ##class(web.DHCPE.Query.IAdmItemStatus).GetOrdSetsFlag("30","2911||1")

/// [Previously private]
ClassMethod GetOrdSetsFlag(ParARCOSID, ItemID)
{
 s ARCOSRowId=0,OSEOrdSetsDRName="",HasFlag=0
 f  s ARCOSRowId=$o(^DHCPETMPOrdSets(ParARCOSID,ItemID,ARCOSRowId))  q:ARCOSRowId=""  d
 .i $d(^DHCPETMPOrdSets("HasPrint",ARCOSRowId))  s HasFlag=1
 .q:HasFlag=1 
 .s OSEOrdSetsDRName=$g(^DHCPEDataEx("OrdSetsEx","OrdSetsOEItemAbbre",ARCOSRowId))
 .s ^DHCPETMPOrdSets("HasPrint",ARCOSRowId)="Y"

 
 Q HasFlag_"^"_OSEOrdSetsDRName
}

/// 根据preadm号得到医嘱套的dr
/// d ##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(41)
ClassMethod GetArcSetDr(AdmId)
{
	s PIADMchildsub=0 ,OrderSetsDesc="",PIOEOrderSetsDR=""                    //获取套餐名
    f  s PIADMchildsub=$o(^DHCPEPreIADM(AdmId,"ORDENT",PIADMchildsub))  Q:PIADMchildsub=""  d 
    .s PIOEItemStat=$p($g(^DHCPEPreIADM(AdmId,"ORDENT",PIADMchildsub)),"^",9)
    .i PIOEItemStat=1   d
    ..s PIOEOrderSetsDR=$p(^DHCPEPreIADM(AdmId,"ORDENT",PIADMchildsub),"^",1)
   q PIOEOrderSetsDR
}

/*
ClassMethod GetArcSetDesc(AdmId, IDFlag As %String = "N")
{
	s PIADMchildsub=0 ,OrderSetsDesc="" ,OrderSetsIDs=""                      //获取套餐名
    f  s PIADMchildsub=$o(^DHCPEPreIADM(AdmId,"ORDENT",PIADMchildsub))  Q:PIADMchildsub=""  d 
    .s PIOEItemStat=$p($g(^DHCPEPreIADM(AdmId,"ORDENT",PIADMchildsub)),"^",9)
    .i PIOEItemStat=1   d
    ..s PIOEOrderSetsDR=$p(^DHCPEPreIADM(AdmId,"ORDENT",PIADMchildsub),"^",1)
    ..s ARCOSOrdSubCatDR=$p($G(^ARCOS(PIOEOrderSetsDR)),"^",9)
    ..q:ARCOSOrdSubCatDR=""
    ..s OrcatDesc=$p($G(^ARC("IC",ARCOSOrdSubCatDR)),"^",2)
    ..q:OrcatDesc'="体检医嘱套"
    ..s OneOrderSetsDesc=$p(^ARCOS(PIOEOrderSetsDR),"^",2)
    ..i OrderSetsDesc="" d
    ...s OrderSetsDesc=$p(OneOrderSetsDesc,"套(",1)
    ...s OrderSetsIDs=PIOEOrderSetsDR
    ..e  d
    ...s OrderSetsDesc=OrderSetsDesc_"+"_$p(OneOrderSetsDesc,"套(",1)
    ...s OrderSetsIDs=OrderSetsIDs_"+"_PIOEOrderSetsDR
    ..//If HospitalCode="NBMZ" s DeitFlag=$g(^DHCPESetting("DHCPEBaseData","PEARCOS",PIOEOrderSetsDR))
    q:IDFlag="Y" OrderSetsIDs
	s OrderSets=$G(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",AdmId))
    s i=$l(OrderSets,"^")
    s j=1
    while (j<=i){
    	s PIOEOrderSetsDR=$p(OrderSets,"^",j)
    	s j=j+1
    	continue:PIOEOrderSetsDR=""
    	s ARCOSOrdSubCatDR=$p($G(^ARCOS(PIOEOrderSetsDR)),"^",9)
    	continue:ARCOSOrdSubCatDR=""
    	s OrcatDesc=$p($G(^ARC("IC",ARCOSOrdSubCatDR)),"^",2)
    	continue:OrcatDesc'="体检医嘱套"
    	s OneOrderSetsDesc=$p(^ARCOS(PIOEOrderSetsDR),"^",2)
   		i OrderSetsDesc="" d
    	.s OrderSetsDesc=$p(OneOrderSetsDesc,"套(",1)
    	e  d
    	.s OrderSetsDesc=OrderSetsDesc_"+"_$p(OneOrderSetsDesc,"套(",1)
    }
    s:OrderSetsDesc'="" OrderSetsDesc=OrderSetsDesc //_"套"
	q OrderSetsDesc
}
*/

/*
/// 根据itemdr通过OE_OrdItem 得到是否属于套餐 1不是套餐的 0 是套餐里的
/// d ##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(41)
/// d ##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(41)
ClassMethod GetArcSetDesc(AdmId, IDFlag As %String = "N", UserID As %Library.String = "")
{
	if UserID="" d
	.s:$d(%session) UserID=%session.Get("LOGON.USERID")
	.s:'$d(%session) UserID=1
    .i UserID="" s UserID=1
	k ^TEMPDHCPEOrderSets("OrderSets",UserID,AdmId)
	s PIADMchildsub=0 ,OrderSetsDesc="" ,OrderSetsIDs=""                      //获取套餐名
    f  s PIADMchildsub=$o(^DHCPEPreIADM(AdmId,"ORDENT",PIADMchildsub)) Q:PIADMchildsub=""  d 
    .s PIOEItemStat=$p($g(^DHCPEPreIADM(AdmId,"ORDENT",PIADMchildsub)),"^",9)
    .i PIOEItemStat=1 d
    ..s PIOEOrderSetsDR=$p(^DHCPEPreIADM(AdmId,"ORDENT",PIADMchildsub),"^",1)
    ..s ARCOSOrdSubCatDR=$p($G(^ARCOS(PIOEOrderSetsDR)),"^",9)
    ..q:ARCOSOrdSubCatDR=""
    ..s OrcatDesc=$p($G(^ARC("IC",ARCOSOrdSubCatDR)),"^",2)
    ..q:OrcatDesc'="体检医嘱套"
    ..s OneOrderSetsDesc=$p(^ARCOS(PIOEOrderSetsDR),"^",2)
    ..i OrderSetsDesc="" d
    ...s OrderSetsDesc=$p(OneOrderSetsDesc,"套(",1)
    ...s OrderSetsIDs=PIOEOrderSetsDR
    ..e  d
    ...s OrderSetsDesc=OrderSetsDesc_"+"_$p(OneOrderSetsDesc,"套(",1)
    ...s OrderSetsIDs=OrderSetsIDs_"+"_PIOEOrderSetsDR
       q:IDFlag="Y" OrderSetsIDs
	s OrderSets=$G(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",AdmId))
    s i=$l(OrderSets,"^")
    s j=1
    while (j<=i){
    	s PIOEOrderSetsDR=$p(OrderSets,"^",j)
    	s j=j+1
    	continue:PIOEOrderSetsDR=""
    	s ARCOSOrdSubCatDR=$p($G(^ARCOS(PIOEOrderSetsDR)),"^",9)
    	continue:ARCOSOrdSubCatDR=""
    	s OrcatDesc=$p($G(^ARC("IC",ARCOSOrdSubCatDR)),"^",2)
    	continue:OrcatDesc'="体检医嘱套"
    	s flag=..ItemstatusByOrdset(AdmId,PIOEOrderSetsDR)
    	continue:flag="0"
    	s OneOrderSetsDesc=$p(^ARCOS(PIOEOrderSetsDR),"^",2)
    	i OneOrderSetsDesc'="" s ^TEMPDHCPEOrderSets("OrderSets",UserID,AdmId,PIOEOrderSetsDR)=$p(OneOrderSetsDesc,"套(",1)
   	
    }
    s OrderSetsDR=0
    f  s OrderSetsDR=$o(^TEMPDHCPEOrderSets("OrderSets",UserID,AdmId,OrderSetsDR)) q:OrderSetsDR=""  d
    .i OrderSetsDesc="" d
    ..s OrderSetsDesc=$g(^TEMPDHCPEOrderSets("OrderSets",UserID,AdmId,OrderSetsDR))
    .e  d
    ..s OrderSetsDesc=OrderSetsDesc_"、"_$g(^TEMPDHCPEOrderSets("OrderSets",UserID,AdmId,OrderSetsDR))
    
    s:OrderSetsDesc'="" OrderSetsDesc=OrderSetsDesc //_"套"
	q OrderSetsDesc
}
*/
/// Creator：	 xy 
/// CreatDate：	 20211203
/// Description: 根据个人预约ID获取套餐名称
/// Input:		 AdmId（个人预约ID）
/// Return：     套餐描述
/// Debug:  w ##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(2520)
ClassMethod GetArcSetDesc(AdmId, IDFlag As %String = "N", UserID As %Library.String = "")
{
    s ^tempdhcpe("GetArcSetDesc")=$lb(AdmId, IDFlag,UserID)
    s OrderSetsDesc=""
    s PIADMchildsub=0                    
    f  s PIADMchildsub=$o(^DHCPEPreIADM(AdmId,"ORDITEM",PIADMchildsub)) Q:PIADMchildsub=""  d 
    .s PIOIItemStat=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",PIADMchildsub)),"^",16)
    .q:PIOIItemStat="4"
    .s PIOIOrdEntDR=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",PIADMchildsub)),"^",2)
    .q:PIOIOrdEntDR=""
    .s PIOEOrderSetsDR=$p($g(^DHCPEPreIADM(+PIOIOrdEntDR,"ORDENT",$p(PIOIOrdEntDR,"||",2))),"^",1)
    .s OneOrderSetsDesc=$p($g(^ARCOS(PIOEOrderSetsDR)),"^",2)
    .s:OneOrderSetsDesc'="" OneOrderSetsDesc=$p(OneOrderSetsDesc,"套(",1)
    .s:OrderSetsDesc="" OrderSetsDesc=OneOrderSetsDesc
    .e  d
    ..s:OrderSetsDesc'[OneOrderSetsDesc OrderSetsDesc=OrderSetsDesc_"^"_OneOrderSetsDesc
   
	q OrderSetsDesc
}

/// function：判断可拆分的套餐是否还有没停止的医嘱
/// d ##class(web.DHCPE.Query.IAdmItemStatus).ItemstatusByOrdset(41)
ClassMethod ItemstatusByOrdset(AdmId, OrderSetID)
{
	S PIOIRowId=""
	s ItemStr=""
	s flag=0
	f  s PIOIRowId=$o(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",AdmId,OrderSetID,PIOIRowId)) q:PIOIRowId=""  d
	.s Status=$g(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",AdmId,OrderSetID,PIOIRowId))
	.q:Status=4
	.i ItemStr="" s ItemStr=PIOIRowId
	.e  s ItemStr=ItemStr_"^"_PIOIRowId
	i ItemStr'="" s flag=1
	q flag
}

/// w ##class(web.DHCPE.Query.IAdmItemStatus).splitLine("^癌胚抗原+甲胎蛋白^甲胎蛋白,癌胚抗原^2253780")
ClassMethod splitLine(vLine)
{
	s lstDesc=$P(vLine,"^",1)
	s laricmDesc=$P(vLine,"^",2)
	s lNotice=$P(vLine,"^",3)
	s lOEORILabEpisodeNo=$P(vLine,"^",4)
	s STName=$P(vLine,"^",5)
	s AddItem=$P(vLine,"^",6)
	s STLoc=$P(vLine,"^",7)
	s price=$P(vLine,"^",8)
	s ^TMPPOI("GetPatOrdItemInfo","ItemOrder",$j)=+$g(^TMPPOI("GetPatOrdItemInfo","ItemOrder",$j))+1
	s ItemOrder=$g(^TMPPOI("GetPatOrdItemInfo","ItemOrder",$j))
	// 项目名称折行
	s iLLoop=1
	s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	s LineLength=30
	i HospitalCode="NB" s LineLength=15  //宁波
	i HospitalCode="FX" s LineLength=23  //复兴
	i HospitalCode="AZ" s LineLength=23  //安贞
	i HospitalCode="JXZH" s LineLength=28  //中环
	i HospitalCode="ZSSY" s LineLength=24  //中环
	do{ 
		s strLine=$e(laricmDesc,1,LineLength)
		s laricmDesc=$e(laricmDesc,LineLength+1,$l(laricmDesc))
		s laricmDescs(iLLoop)=strLine
		s:($l(laricmDesc)=1) laricmDescs(iLLoop)=laricmDescs(iLLoop)_laricmDesc
		s:($l(laricmDesc)=1) laricmDesc=""
		s laricmDescs=iLLoop
		s iLLoop=iLLoop+1
		//s:(9=+LineLength) LineLength=7 //除第一行取9个字符,以下行取7个字符
	}
	while (laricmDesc'="")
	// 项目备注折行
	s iLLoop=1
	s LineLength=14
	do{ 
		s strLine=$e(lNotice,1,LineLength)
		s lNotice=$e(lNotice,LineLength+1,$l(lNotice))
		s lNotices(iLLoop)=strLine
		s:($l(lNotice)=1) lNotices(iLLoop)=lNotices(iLLoop)_lNotice
		s:($l(lNotice)=1) lNotice=""
		s lNotices=iLLoop
		s iLLoop=iLLoop+1
		//s:(28=+LineLength) LineLength=27 //除第一行取30个字符,以下行取28个字符
	}
	while (lNotice'="")
	
	s ret=""
	s iLLoop=1
	s prefix=""
	while (lNotices>=iLLoop)||(laricmDescs>=iLLoop){
		
	 i ""'=$G(laricmDescs(iLLoop)) d
	 .s ret=ret_lstDesc_"^"_prefix_$G(laricmDescs(iLLoop))
	 e  d
	 .s ret=ret_lstDesc_"^"_""
	 
	 i ""'=$G(lNotices(iLLoop)) d
	 .s ret=ret_"^"_$tr(prefix,"")_$G(lNotices(iLLoop))
	 .//_"^"_lOEORILabEpisodeNo
	 e  d
	 .s ret=ret_"^"_""
	 .//_"^"_lOEORILabEpisodeNo
	 
	 //s ret=ret_"^"_ItemOrder_";"
	 
	 i iLLoop=1 d
	 .s ret=ret_"^"_lOEORILabEpisodeNo_"^"_ItemOrder_"^"_STName_"^"_AddItem_"^"_STLoc_"^"_price_";"
	 e  d
	 . s ret=ret_"^^"_ItemOrder_"^^^^;"
	 
	 
	 s:(7=+LineLength) strLine=""_strLine //除第一行取9个字符,以下行取7个字符
	 s lstDesc=""
	 s prefix=""
	 s iLLoop=iLLoop+1
	}
	Q ret
}

/// w ##class(web.DHCPE.Query.IAdmItemStatus).Test("男","专用")
/// w ##class(web.DHCPE.Query.IAdmItemStatus).Q("25")
ClassMethod Test(Sex, Notice)
{
	s SexStr=Sex_"性"
	w SexStr,!
	s strLength=$l(Notice,SexStr)
	w strLength,!
	i strLength>1 d
	.i $p(Notice,SexStr,1)="" d
	..s Notice=$p(Notice,SexStr,2)
	e  d
	.i SexStr="男性" d
	..s SexStr="女性"
	.e  d
	..s SexStr="男性"
	.w SexStr,!
	.s strLength=$l(Notice,SexStr)
	.w strLength,!
	.i strLength>1 d
	..i $p(Notice,SexStr,1)="" d
	...s Notice=""
	q Notice
}

ClassMethod Q(AdmId)
{
	s PIADMchildsub=0 ,OrderSetsDesc=0                       //获取套餐名
    f  s PIADMchildsub=$o(^DHCPEPreIADM(AdmId,"ORDENT",PIADMchildsub))  Q:PIADMchildsub=""  d 
    .//s PIADMchildsub=$G(^DHCPEPreIADM(AdmId,"ORDENT",PIADMchildsub))
    .s PIOEItemStat=$p(^DHCPEPreIADM(AdmId,"ORDENT",PIADMchildsub),"^",9)
    .i PIOEItemStat=1   d
    ..s PIOEOrderSetsDR=$p(^DHCPEPreIADM(AdmId,"ORDENT",PIADMchildsub),"^",1)
    ..s ARCOSOrdSubCatDR=$p($G(^ARCOS(PIOEOrderSetsDR)),"^",9)
    ..s OrcatDesc=$p($G(^ARC("IC",ARCOSOrdSubCatDR)),"^",2)
    ..i OrcatDesc="体检医嘱套"  s OrderSetsDesc=$p(^ARCOS(PIOEOrderSetsDR),"^",2)
   
     q OrderSetsDesc
}

/// 对需要排序的打印进行人员按照登记号排序
ClassMethod printSort(inStrings, AdmType)
{
	//产生临时Global
	s iLength=$l(inStrings,";")
	s job=$j
	k ^DHCPESortTemp(job)
	for i=1:1:iLength-1
	{
		s InString=$p(inStrings,";",i)
		s AdmId=$P(InString,"^",3)
		i AdmType="CRM" d
		.
		e  i AdmType="PEADM" d
		.s AdmId=$p($g(^DHCPEIADM(AdmId)),"^",4)
		e  d
		.s AdmId=$o(^DHCPEIADM(0,"PAADM",AdmId,0))
		.s AdmId=$p($g(^DHCPEIADM(AdmId)),"^",4)
		s BaseId=$p($g(^DHCPEPreIADM(AdmId)),"^",1)
		s RegNo=$P($g(^DHCPEPreIBI(BaseId)),"^",1)
		s ^DHCPESortTemp(job,RegNo,AdmId)=InString
	}
	//排序
	s returnStr=""
	s curRegNo=0
	f  s curRegNo=$o(^DHCPESortTemp(job,curRegNo)) q:curRegNo=""  d
	.s curAdm=0
	.f  s curAdm=$o(^DHCPESortTemp(job,curRegNo,curAdm)) q:curAdm=""  d
	..s str=$G(^DHCPESortTemp(job,curRegNo,curAdm))
	..i returnStr="" d
	...s returnStr=str
	..e  d
	...s returnStr=returnStr_";"_str
	k ^DHCPESortTemp(job)
	q returnStr_";"
}

ClassMethod OutPatItemToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='PatItemName' id='PatItemName' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^DHCPECTDataEx("PatItem",id)) q:id=""  d
	.s Selected=""
	.i id=DefaultValue s Selected="selected"
	.w "<option value='"_id_"' "_Selected_">"_$G(^DHCPECTDataEx("PatItem",id))_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

// 报告类别下拉列表

ClassMethod OutReportItemToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	w "<select name='ReportItemName' id='ReportItemName' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^DHCPECTDataEx("ReportItem",id)) q:id=""  d
	.
	.w "<option value='"_id_"'>"_$G(^DHCPECTDataEx("ReportItem",id))_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

// d ##class(web.DHCPE.Query.IAdmItemStatus).GetIADMARCItemStatus("412")

ClassMethod GetIADMARCItemStatus(PreIADM)
{
 
    s PIOIChildSub=0 ,IADMARCItemStatus="0"
	f  s PIOIChildSub=$o(^DHCPEPreIADM(PreIADM,"ORDITEM",PIOIChildSub))  q:(PIOIChildSub="")||(IADMARCItemStatus="6")   d
	.s CRMID=$O(^DHCPECRMO(0,"CRMORI",PreIADM_"||"_PIOIChildSub,0))
	.q:CRMID=""
	.s OEORDItemID=$p(^DHCPECRMO(CRMID),"^",1)
	.q:OEORDItemID=""
	.s ItemStat=$P($G(^OEORD(+OEORDItemID,"I",$P(OEORDItemID,"||",2),1)),"^",13)
    .i ItemStat="6"  s IADMARCItemStatus="6"
    q IADMARCItemStatus
}

// d ##class(web.DHCPE.Query.IAdmItemStatus).SetOtherStationStatus(27, "")

ClassMethod SetOtherStationStatus(IADM, OEOrdItem)
{
  
    s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other"))
    s Return=""
  	s PIADMDR=$p(^DHCPEIADM(IADM),"^",4)
    S ChildSub=""
    f  s ChildSub=$o(^DHCPEPreIADM(PIADMDR,"ORDITEM",ChildSub))  q:ChildSub=""  d
    .s PIADM=PIADMDR_"||"_ChildSub
    .s ItmMastDR=$p(^DHCPEPreIADM(PIADMDR,"ORDITEM",ChildSub),"^",1)
    .s stat=$p(^DHCPEPreIADM(PIADMDR,"ORDITEM",ChildSub),"^",16)
    .q:stat'="1"
    .s CRMID=$O(^DHCPECRMO(0,"CRMORI",PIADMDR_"||"_ChildSub,0))
    .//i CRMID=""  s Return="后台数据出错"
	.q:CRMID=""
	.s ItemID=$p(^DHCPECRMO(CRMID),"^",1)
	.q:(OEOrdItem'="")&&(OEOrdItem'=ItemID)
    .s STRowId="0"
	.s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,STRowId))
	.//i STRowId=""  s Return="基础数据出错"
	.q:("^"_OtherStation_"^")'[("^"_STRowId_"^")
	.Q:$D(^DHCPEDataEx("DHCPEOtherStation","PIADM",IADM,ItemID))
	.s ^DHCPEDataEx("DHCPEOtherStation",+$h,ItemID)=1
	.s ^DHCPEDataEx("DHCPEOtherStation","PIADM",IADM,ItemID)=+$h
	.&sql(Update sqluser.OE_OrdItem set OEORI_ItemStat_DR='6' where OEORI_RowId=:ItemID)
	.//s $p(^OEORD($p(ItemID,"||",1),"I",$p(ItemID,"||",2),1),"^",13)=6	//status: 1-verified  4-stopped  6-executed
 	q Return
}

ClassMethod CancelOtherStationStatus(IADM, OEOrdItem)
{
  
 
  	//s PIADMDR=$p(^DHCPEIADM(IADM),"^",4)
    i OEOrdItem=""  d
    .s OEDR=0
    .f  s OEDR=$o(^DHCPEDataEx("DHCPEOtherStation","PIADM",IADM,OEDR))  q:OEDR=""  d
    ..s Date=$g(^DHCPEDataEx("DHCPEOtherStation","PIADM",IADM,OEDR))
    ..k ^DHCPEDataEx("DHCPEOtherStation","PIADM",IADM,OEDR)
    ..k ^DHCPEDataEx("DHCPEOtherStation",+$h,OEDR)
    ..s $p(^OEORD($p(OEDR,"||",1),"I",$p(OEDR,"||",2),1),"^",13)=1
    else  d
    .s Date=$g(^DHCPEDataEx("DHCPEOtherStation","PIADM",IADM,OEOrdItem))
	.k ^DHCPEDataEx("DHCPEOtherStation","PIADM",IADM,OEOrdItem)
	.k ^DHCPEDataEx("DHCPEOtherStation",+$h,OEOrdItem)
	.s $p(^OEORD($p(OEOrdItem,"||",1),"I",$p(OEOrdItem,"||",2),1),"^",13)=1	//status: 1-verified  4-stopped  6-executed
 	q ""
}

// 导检单中增加收费项信息

ClassMethod AddTarItemInfo(AdmId, ArcIMID, CurData, ret)
{
	q:$G(^DHCPESetting("DHCPE","PrintTarInfo",%session.Get("LOGON.CTLOCID")))'="Y"
	s preSub=$O(^DHCPEPreIADM(0,"ItmMast",ArcIMID,AdmId,0))
    q:preSub=""
    s date=$P(^DHCPEPreIADM(AdmId,"ORDITEM",preSub),"^",12)
    s tarInfo=##class(web.DHCPE.Cashier).ArcItem2TarItem("","",ArcIMID,date,"","","","")
    s k=$L(tarInfo,"&")
	f j=1:1:k d
	.s oneInfo=$P(tarInfo,"&",j)
	.q:+oneInfo=0
	.s tarItemID=$p(oneInfo,"^",1)
	.s price=$j(+$p(oneInfo,"^",3),3,2)
	.s count=+$p(oneInfo,"^",2)
	.s tarDesc=$P(^DHCTARI(tarItemID),"^",2)
	.s tarData=CurData
	.s $p(tarData,"^",1)=""
	.s $p(tarData,"^",2)="    "_tarDesc
	.//PatItemName_"^"_ARCIMDesc_"^"_Notice_"^"_OEORILabEpisodeNo_"^"_STName_"^"_additem_"^"_STLoc_"^"_Price
	.s $p(tarData,"^",8)=price_"*"_count
	.s ret=ret_..splitLine(tarData)
}

ClassMethod GetShortLocDesc(LocDesc)
{
	s Length=$L(LocDesc,"-")
	i Length>1 d
	.s LocDesc=$P(LocDesc,"-",2,Length)
	q LocDesc
}

/*
ClassMethod NeedPrint(OEORDID, ARCIMID)
{
	q +$G(^DHCPECTDataEx("DHCPEStationOrder","BaseInfoBar",ARCIMID))
}
*/
/// Creator：	 xy 
/// CreatDate：	 20210830
/// Description: 医嘱项是否需要打印条码
/// Input:       OEORDID（医嘱ID）, ARCIMID(医嘱项ID)
/// Debug: w ##class(web.DHCPE.Query.IAdmItemStatus).NeedPrint("257167||19","22257||1")
ClassMethod NeedPrint(OEORDID, ARCIMID)
{
	q:ARCIMID="" "N"
	s BaseInfoBar="N"
	s PAADM=$p($g(^OEORD(+OEORDID)),"^",1)
	s LocID=$p($g(^PAADM(PAADM)),"^",4)
    s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMID,LocID)
    s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderDR,""))
    i StatOrdSetID'="" s BaseInfoBar=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),14)  //基本信息条码(科室站点项目扩展表)
	q BaseInfoBar
}

/// d ##class(web.DHCPE.Query.IAdmItemStatus).GetIfHadLCT("3812568")
ClassMethod GetIfHadLCT(PAADM)
{
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:IADM="" ""
    s PIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
    q:('$d(^DHCPEPreIADM(0,"ItmMast","33046||1",PIADM))) ""
    s PreordSub=0
    s OEORIDR=""
    f  s PreordSub=$o(^DHCPEPreIADM(0,"ItmMast","33046||1",PIADM,PreordSub)) q:(PreordSub="")  d
	.s CRMOCRMORI=PIADM_"||"_PreordSub
	.s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",CRMOCRMORI,0))
	.s BillStatus=$p(^DHCPECRMO(CRMORowId),"^",4)
	.s OEORIDR=$p(^DHCPECRMO(CRMORowId),"^",1)
	.q:((BillStatus="NP")||(BillStatus="PP"))
	q OEORIDR
}

/// Description: 获取检查条码信息
/// Input:       PAADM（就诊ID）, OEORDID(医嘱ID), BloodFlag(血/非血标记)
/// Debug: w ##class(web.DHCPE.Query.IAdmItemStatus).GetPrintItem("7459677","",1)
ClassMethod GetPrintItem(PAADM, OEORDID, BloodFlag As %String = "0")
{
	s ^tempdhcpe("GetPrintItem")=$lb(PAADM, OEORDID, BloodFlag)
	;RegNo^Name^Sex^Age^PatLoc$C(1)ItemName1^RecLoc1$C(2)ItemName2^RecLoc2
	s PrintNum=1
	i OEORDID'=""
	{
		s obj=##class(User.OEOrdItem).%OpenId(OEORDID)
		s ARCIMID=obj.OEORIItmMastDRGetObjectId()
		q:(..NeedPrint(OEORDID,ARCIMID)="0")||(..NeedPrint(OEORDID,ARCIMID)="N") ""
		s ARCIMDesc=obj.OEORIItmMastDR.ARCIMAbbrev  //ARCIMDesc
		s LabSpecNo=obj.OEORILabEpisodeNo
		s Name=obj.OEORIOEORDParRef.OEORDAdmDR.PAADMPAPMIDR.PAPMIName
		s RegNo=obj.OEORIOEORDParRef.OEORDAdmDR.PAADMPAPMIDR.PAPMIIPNo
		s Sex=obj.OEORIOEORDParRef.OEORDAdmDR.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc
		//s Age=obj.OEORIOEORDParRef.OEORDAdmDR.PAADMPAPMIDR.PAPMIDOB
		//s Age=+##class(web.DHCLCNUREXCUTE).CalAge(Age,+$h)
		s PAADM=obj.OEORIOEORDParRef.OEORDAdmDRGetObjectId()
		s Age=""
		s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
		i PAPMIRowId'="" s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId,PAADM)
		
        s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
        q:IADM="" ""
        s PreIADM=$P($g(^DHCPEIADM(IADM)),"^",4)
        //按体检取姓名
        s CurData=$g(^DHCPEPreIADM(PreIADM))
        s PIBIDR=$P(CurData,"^",1)
        s CurData=$g(^DHCPEPreIBI(PIBIDR))
        s Name=$p(CurData,"^",2)
        
		s LocID=$P($g(^DHCPEPreIADM(PreIADM)),"^",26) //就诊科室ID
    	s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMID,LocID)
    	s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderDR,""))
        i StatOrdSetID'="" s PrintNum=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),25) //条码数量
        i PrintNum="" s PrintNum=0
        /*i $d(^DHCPECTDataEx("DHCPEStationOrder","BarPrintNum",ARCIMID)) d
        .s PrintNum=$g(^DHCPECTDataEx("DHCPEStationOrder","BarPrintNum",ARCIMID))
       */
        s NewHPNo=$P($g(^DHCPEPreIADM(PreIADM)),"^",27)
        s PatLocDR=obj.OEORIOEORDParRef.OEORDAdmDR.PAADMDepCodeDRGetObjectId()
        s PatLoc=obj.OEORIOEORDParRef.OEORDAdmDR.PAADMDepCodeDR.CTLOCDesc
		s PatLoc=..GetShortLocDesc(PatLoc)
		s RecLoc=obj.OEORIRecDepDR.CTLOCDesc
		//q:($g(^DHCPESetting("DHCPE","SendPisFBWay"))="F")&&(RecLoc["病理科")
		q:($g(^DHCPESetting("DHCPE","SendPisFBWay",PatLocDR))="F")&&(RecLoc["病理科")
		i RecLoc["病理科" d
		.;s BarInfo=NewHPNo_"^"_RegNo
		.s BarInfo=RegNo_"^"_$p(OEORDID,"||",1)_"-"_$p(OEORDID,"||",2)_"-"_1
		e  d
		.s BarInfo=RegNo_"^"_NewHPNo
		s RecLoc=..GetShortLocDesc(RecLoc)
		 s CRMOID=$o(^DHCPECRMO(0,"OEORI",OEORDID,0))
        s PaiedFlag=$P($g(^OEORD(+OEORDID,"I",$P(OEORDID,"||",2),3)),"^",5)
        s Flag=0
        if $G(^DHCPESetting("DHCPE","AllowPrint",PatLocDR))="Y" d
		.s Flag="0"
		e  d 
		.i PaiedFlag'="P" s Flag=1
		q:Flag="1" "NoPayed"	
		q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORDID))
        //s Flag=##class(web.DHCPE.DHCPEIAdm).HaveNoPayedItem(IADM)
        //q:Flag="1" "NoPayed"
        s GADM=$P(^DHCPEIADM(IADM),"^",2)
        s PGDesc="个人"
        s:GADM'="" PGDesc="团体"
        s VIPLevel=##class(web.DHCPE.PreCommon).GetVIPLevel("IADM", IADM)
        s VIPDesc=$P(VIPLevel,"^",2)
		s ^DHCPEDataEx("OEOrderItem","PrintRisRequest",OEORDID)="Y"
		
		s OEItemInfo=""	
		f i=1:1:PrintNum  d
		.i OEItemInfo="" s OEItemInfo=ARCIMDesc_"^"_RecLoc_"^"_BarInfo
		.e  s OEItemInfo=OEItemInfo_$C(2)_ARCIMDesc_"^"_RecLoc_"^"_BarInfo
	    q RegNo_"^"_Name_"^"_Sex_"^"_Age_"^"_PatLoc_"^"_PGDesc_"^"_VIPDesc_$C(1)_OEItemInfo

		//q RegNo_"^"_Name_"^"_Sex_"^"_Age_"^"_PatLoc_"^"_PGDesc_"^"_VIPDesc_$C(1)_ARCIMDesc_"^"_RecLoc_"^"_BarInfo  //RegNo^HPNo
	}
	else
	{
		s PAADMObj=##class(User.PAAdm).%OpenId(PAADM)
		s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
        q:IADM="" ""
        s PreIADM=$P(^DHCPEIADM(IADM),"^",4)
        s LocID=$P($g(^DHCPEPreIADM(PreIADM)),"^",26) //就诊科室ID
        s NewHPNo=$P(^DHCPEPreIADM(PreIADM),"^",27)	
        s Flag=##class(web.DHCPE.DHCPEIAdm).HaveNoPayedItem(IADM)
        q:Flag="1" "NoPayed"
        s GADM=$P(^DHCPEIADM(IADM),"^",2)
        s PGDesc="个人"
        s:GADM'="" PGDesc="团体"
        s VIPLevel=##class(web.DHCPE.PreCommon).GetVIPLevel("IADM", IADM)
        s VIPDesc=$P(VIPLevel,"^",2)
		s Name=PAADMObj.PAADMPAPMIDR.PAPMIName
		s RegNo=PAADMObj.PAADMPAPMIDR.PAPMIIPNo
		s Sex=PAADMObj.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc
		//s Age=PAADMObj.PAADMPAPMIDR.PAPMIDOB
		//s Age=+##class(web.DHCLCNUREXCUTE).CalAge(Age,+$h)
		s Age=""
		s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
		i PAPMIRowId'="" s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId,PAADM)
       	s PatLocDR=PAADMObj.PAADMDepCodeDR
		s PatLoc=PAADMObj.PAADMDepCodeDR.CTLOCDesc
		s PatLoc=..GetShortLocDesc(PatLoc)
		s Order=$O(^OEORD(0,"Adm",PAADM,0))
		q:Order="" ""
		s OrderObj=##class(User.OEOrder).%OpenId(Order)
		s Length=OrderObj.ChildOEOrdItem.Count()
		q:Length=0 ""
		s ItemInfo=""
		s Flag=0
		s Job=$J
		s Flag=0
		k ^TempDHCPEBarCodeSort(Job)
		
		for i=1:1:Length
		{
			
			s obj=OrderObj.ChildOEOrdItem.GetAt(i)
			s OEID=obj.%Id()
			s ARCIMID=obj.OEORIItmMastDRGetObjectId()
			;s STID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,0))	
            s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMID,LocID)
			continue:StatOrderDR=""
			s STID=+StatOrderDR
			continue:(..NeedPrint(OEID,ARCIMID)="0")||(..NeedPrint(OEID,ARCIMID)="N")
			s Status=obj.OEORIItemStatDRGetObjectId()
			s LabSpecNo=obj.OEORILabEpisodeNo
			//continue:LabSpecNo'="" //打印所有条码
			continue:Status="4"
			continue:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEID))
			;s STSort=$P(^DHCPEST(STID),"^",4)
			s StatSetID=$O(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,STID,""))
			continue:StatSetID=""
			s STSort=$lg($g(^CF.PE.StationSetD(StatSetID)),5) //站点顺序
			s ARCIMDesc=obj.OEORIItmMastDR.ARCIMAbbrev //ARCIMDesc
			s RecLoc=obj.OEORIRecDepDR.CTLOCDesc
			s ARCCode=obj.OEORIItmMastDR.ARCIMCode
			//continue:(BloodFlag="0")&&(ARCCode="PE036")
			//continue:(BloodFlag="1")&&(ARCCode'="PE036")
			//continue:($g(^DHCPESetting("DHCPE","SendPisFBWay"))="F")&&(RecLoc["病理科")
			continue:($g(^DHCPESetting("DHCPE","SendPisFBWay",PatLocDR))="F")&&(RecLoc["病理科")	
			s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderDR,""))
        	s PrintNum=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),25) //条码数量
        	i PrintNum="" s PrintNum=0
        
			/*i $d(^DHCPECTDataEx("DHCPEStationOrder","BarPrintNum",ARCIMID)) d
			.s PrintNum=$g(^DHCPECTDataEx("DHCPEStationOrder","BarPrintNum",ARCIMID))
			*/
			for NUM=1:1:PrintNum {

			  i RecLoc["病理科" d
			  .;s BarInfo=NewHPNo_"^"_RegNo
			  .s BarInfo=RegNo_"^"_$p(OEID,"||",1)_"-"_$p(OEID,"||",2)_"-"_1
			  .s STSort=0
			  e  d
			  .s BarInfo=RegNo_"^"_NewHPNo
			  s RecLoc=..GetShortLocDesc(RecLoc)

			  //s:STID=12 STSort=0
			  //s:ARCCode="PE036" STSort="99999999"
			  //s ^TempDHCPEBarCodeSort(Job,STSort,STID,OEID)=ARCIMDesc_"^"_RecLoc_"^"_BarInfo ////RegNo^HPNo
			  s ^TempDHCPEBarCodeSort(Job,STSort,STID,OEID,NUM)=ARCIMDesc_"^"_RecLoc_"^"_BarInfo
			}
			
		}
		
		
		s STSort=""
		f  s STSort=$O(^TempDHCPEBarCodeSort(Job,STSort)) q:STSort=""  d
		.s STID=""
		.f  s STID=$O(^TempDHCPEBarCodeSort(Job,STSort,STID)) q:STID=""  d
		..s OEID=""
		..f  s OEID=$O(^TempDHCPEBarCodeSort(Job,STSort,STID,OEID)) q:OEID=""  d
		...S PNUM=0
		...f  s PNUM=$O(^TempDHCPEBarCodeSort(Job,STSort,STID,OEID,PNUM)) q:PNUM=""  d 
		....s Info=$G(^TempDHCPEBarCodeSort(Job,STSort,STID,OEID,PNUM))
		....s ^DHCPEDataEx("OEOrderItem","PrintRisRequest",OEID)="Y"
		....i ItemInfo="" d
		.....s ItemInfo=Info
		....e  d
		.....s ItemInfo=ItemInfo_$C(2)_Info
		....i STSort="99999999" d
		.....s ItemInfo=ItemInfo_$C(2)_Info

		/*
		s STSort=""
		f  s STSort=$O(^TempDHCPEBarCodeSort(Job,STSort)) q:STSort=""  d
		.s STID=""
		.f  s STID=$O(^TempDHCPEBarCodeSort(Job,STSort,STID)) q:STID=""  d
		..s OEID=""
		..f  s OEID=$O(^TempDHCPEBarCodeSort(Job,STSort,STID,OEID)) q:OEID=""  d
		...s Info=$G(^TempDHCPEBarCodeSort(Job,STSort,STID,OEID))
		...s ^DHCPEDataEx("OEOrderItem","PrintRisRequest",OEID)="Y"
		...i ItemInfo="" d
		....s ItemInfo=Info
		...e  d
		....s ItemInfo=ItemInfo_$C(2)_Info
		...i STSort="99999999" d
		....s ItemInfo=ItemInfo_$C(2)_Info
		*/
		/*
		i (Flag=1)&&(BloodFlag=0) d
		.s ItemName="超声专用 "_$ZD(+$H,3)
		.i ItemInfo="" d
		..s ItemInfo=ItemName_"^"_"^"_RegNo_"^"_NewHPNo
		.e  d
		..s ItemInfo=ItemInfo_$C(2)_ItemName_"^"_"^"_RegNo_"^"_NewHPNo
		*/
		q:ItemInfo="" ""
		k ^TempDHCPEBarCodeSort(Job)
		q RegNo_"^"_Name_"^"_Sex_"^"_Age_"^"_PatLoc_"^"_PGDesc_"^"_VIPDesc_$C(1)_ItemInfo
	}
	q ""
}

ClassMethod GetHPNoByPreIADM(PreIADM As %String = "")
{
	q:PreIADM="" ""
	s NewHPNo=$P($g(^DHCPEPreIADM(PreIADM)),"^",27)
	q NewHPNo
}

/// 打印基本信息获取信息
ClassMethod GetBaseInfoNew(PAADM)
{
	
	s PAADMObj=##class(User.PAAdm).%OpenId(PAADM)
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:IADM="" ""
    s PreIADM=$P($g(^DHCPEIADM(IADM)),"^",4)
    s NewHPNo=$P($g(^DHCPEPreIADM(PreIADM)),"^",27)	
    s GADM=$P($g(^DHCPEIADM(IADM)),"^",2)
    s PGDesc="个人"
    s:GADM'="" PGDesc="团体"
    s VIPLevel=##class(web.DHCPE.PreCommon).GetVIPLevel("IADM", IADM)
    s VIPDesc=$P(VIPLevel,"^",2)
	s Name=PAADMObj.PAADMPAPMIDR.PAPMIName
	s RegNo=PAADMObj.PAADMPAPMIDR.PAPMIIPNo
	s Sex=PAADMObj.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc
	//s Age=PAADMObj.PAADMPAPMIDR.PAPMIDOB
	//s Age=+##class(web.DHCLCNUREXCUTE).CalAge(Age,+$h)
	S Age=""
	S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	I PAPMIRowId'="" s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId,PAADM)
	s PatLoc=PAADMObj.PAADMDepCodeDR.CTLOCDesc
	s PatLoc=..GetShortLocDesc(PatLoc)
	s FactAmount=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(PreIADM)
	s FactAmount=$p(FactAmount,"^",2)_"元"
	q RegNo_"^"_Name_"^"_Sex_"^"_Age_"^"_FactAmount_"^"_RegNo
}

/// 打印基本信息获取信息
ClassMethod GetBaseInfo(PAADM)
{
	//RegNo+"^"+Name+"  "+FactAmount+"^"+"^"+"^"+"^"+Sex+String.fromCharCode(1)+"^"+Age+"^"+RegNo+"^"+NewHPNo;
	s PAADMObj=##class(User.PAAdm).%OpenId(PAADM)
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:IADM="" ""
    s PreIADM=$P(^DHCPEIADM(IADM),"^",4)
    s NewHPNo=$P(^DHCPEPreIADM(PreIADM),"^",27)	
    s GADM=$P(^DHCPEIADM(IADM),"^",2)
    s PGDesc="个人"
    s:GADM'="" PGDesc="团体"
    s VIPLevel=##class(web.DHCPE.PreCommon).GetVIPLevel("IADM", IADM)
    s VIPDesc=$P(VIPLevel,"^",2)
	s Name=PAADMObj.PAADMPAPMIDR.PAPMIName
	s RegNo=PAADMObj.PAADMPAPMIDR.PAPMIIPNo
	s Sex=PAADMObj.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc
	//s Age=PAADMObj.PAADMPAPMIDR.PAPMIDOB
	//s Age=+##class(web.DHCLCNUREXCUTE).CalAge(Age,+$h)
	S Age=""
	S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	I PAPMIRowId'="" s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId,PAADM)
	s PatLoc=PAADMObj.PAADMDepCodeDR.CTLOCDesc
	s PatLoc=..GetShortLocDesc(PatLoc)
	s FactAmount=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(PreIADM)
	s FactAmount=$p(FactAmount,"^",2)_"元"
	//q RegNo_"^"_Name_"  "_FactAmount_"^"_"^"_"^"_"^"_Sex_$C(1)_"^"_Age_"^"_RegNo_"^"_NewHPNo
	q RegNo_"^"_Name_"^"_Sex_"^"_Age_"^"_"^"_"^"_Sex_$C(1)_"^^"_RegNo_"^"_NewHPNo
}

ClassMethod CopyOrdSet(SourceAdmID, ToAdmID)
{
	s ^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",ToAdmID)=$G(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",SourceAdmID))
	q ""
}

ClassMethod PatItemPrintFlag(PAADM)
{
	Q:PAADM=""
	s ^DHCPEPatItemPrintFlag("PatItem","PrintFlag",PAADM)="Y"
	q ""
}

/// function:根据医嘱id获取报告状态
/// d ##class(web.DHCPE.Query.IAdmItemStatus).GetReportStaus()
ClassMethod GetReportStaus(OEORIRowId As %String = "")
{
	s OEORIRowId=$p(OEORIRowId,"^",1)
	s PAADM=$P($G(^OEORD(+OEORIRowId)),"^",1)
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	s RPId=$o(^DHCPERPT(0,"IADM",IADM,0))
	s ReportStatus=""
	i RPId'="" d
	.s ReportStatus=$p(^DHCPERPT(RPId),"^",2)
	s ReportStatus=##class(web.DHCPE.Report).GetStatusDesc(ReportStatus,PAADM)
	Q ReportStatus
}

}
