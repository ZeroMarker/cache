Import SQLUser

Class web.INSUReport Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 4;

/// 保存医保结算返回信息
/// w ##class(web.INSUReport).InsertReport("")
ClassMethod InsertReport(InString As %String) As %String
{
	n (InString)
	
	s ^CacheTemp("InsertReport")=InString
	;s InString="^^^0044512^^15^^20110814^0^^002^高血压病(高危组)^20110814^20110814^^^^^^1^^^^0^0^^^李向荣^^李向荣^20110813^1^450100^01^01^01^^ww^qq^^^^^^^^^^^^^00013001-00000001-201108010940553867"
	q:InString="" -100
    s Rowid=+$p(InString,"^",1)
    i Rowid=0 d
    .s InsertReport=$$InsertReport^INSUReport(InString)
    e  d
    .i $d(^INSURPT(Rowid))=0 d
    ..s InsertReport=$$InsertReport^INSUReport(InString)
    .e  d
    ..s InsertReport=$$UpdateReport^INSUReport(InString)
    q InsertReport
}

ClassMethod UpdateReport(str, rowid) As %String
{
	q:str="" -1
	q:rowid="" -1
	&SQL(UpDate INSU_Report set INRPT_Flag=:str where INRPT_Rowid=:rowid)
	q SQLCODE
}

ClassMethod DeleteReport(rowid) As %String
{
	q:rowid="" -1
	&SQL(UpDate INSU_Report set INRPT_Flag='-1' where INRPT_Rowid=:rowid)
	q SQLCODE
}

ClassMethod QueryAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.INSUReport","QueryAll","2022-02-11","2022-02-15","01","00A","2","|")
ClassMethod QueryAllExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Rptlb As %String, ParamINSUType As %String, HospId, ExpStr = "") As %Status
{
	s ^CacheTemp("QueryAllExecute11asd")=$lb(StartDate , EndDate, Rptlb,ParamINSUType,HospId,ExpStr)
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	i +StartDate=0 s StartDate=+$H
	i +EndDate=0 s EndDate=+$H
	
	s ParamRptNo=$p(ExpStr,"|",1) // 审批编号
	s ParamPatNo=$p(ExpStr,"|",2) // 人员编号
	b // #1 根据日期查询
	i ParamRptNo'=""  { // #2 根据审批编号查询
		s rowid=0
		for  s rowid=$o(^INSURPT(0,"RptNo",ParamRptNo,rowid))  q:rowid=""  d
		.d Build1	
	}elseif(ParamPatNo'="") {	// #2 根人员编号查询
		s rowid=0
		for  s rowid=$o(^INSURPT(0,"PatNo",ParamPatNo,rowid))  q:rowid=""  d
		.d Build1	
	}else{
		for TmpDate=StartDate:1:EndDate  d
		.s TmpInsuType=""
		.for  s TmpInsuType=$o(^INSURPT(0,"RptDate",TmpDate,"INSUType",TmpInsuType))  q:TmpInsuType=""  d
		..q:(ParamINSUType'="")&&(ParamINSUType'=TmpInsuType)
		..s rowid=0
		..for  s rowid=$o(^INSURPT(0,"RptDate",TmpDate,"INSUType",TmpInsuType,rowid))  q:rowid=""  d
		...d Build1		
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build1  
	s s=$g(^INSURPT(rowid))
	q:$p(s,"^",52)'=HospId
	s TabPatNo=$p(s,"^",3)  
	s TabPatName=$p(s,"^",4)  
	s TabRptType=$p(s,"^",5)
	q:(Rptlb'="")&&(TabRptType'=Rptlb)
	b ;001
	s INSUAdmDr=$p(s,"^",2)
	if +INSUAdmDr'=0  d
	.set InsuType=$p($g(^DHCINADM(INSUAdmDr)),"^",18)
	s AdmDr=$p(s,"^",1)
	s DataINSUType=$p(s,"^",43) //医保类型 
	s TabRptTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA130"_$g(DataINSUType),TabRptType,4,HospId)
	s:TabRptTypeDesc="" TabRptTypeDesc=TabRptType
	s TabAdmSeriNo=$p(s,"^",6)  
	s TabRptDate=$p(s,"^",7)
	s TabRptDate=##class(websys.Conversions).DateLogicalToHtml(TabRptDate)
	s TabFlag=$p(s,"^",8)
	s:TabFlag="-1" TabFlag="已撤销" 
	s:TabFlag="0" TabFlag="未审批" 
	s:TabFlag="1" TabFlag="审批通过" 
	s:TabFlag="2" TabFlag="审批未通过" 
	s:TabFlag="3" TabFlag="已使用"   
	s TabAdmType=""
	s:AdmDr'="" TabAdmType=$p($g(^PAADM(AdmDr)),"^",2)
	s TabAdmType=$case(TabAdmType,"O":"门诊","E":"急诊","I":"住院","H":"体检",:TabAdmType)
	s TabDiagCode=$p(s,"^",10) 
	s TabDiagDesc=$p(s,"^",11) 
	s TabSDate=##class(websys.Conversions).DateLogicalToHtml($p(s,"^",12))
	s TabEDate=##class(websys.Conversions).DateLogicalToHtml($p(s,"^",13))
	s TabRPTNo=$p(s,"^",14) 
	s Tabxmbm=$p(s,"^",15) 
	s Tabxmmc=$p(s,"^",16) 
	s TabHisCode=$p(s,"^",17) 
	s TabHisDesc=$p(s,"^",18) 
	s Tabxmlb=$p(s,"^",19) 
	s TabOutHosName=$p(s,"^",20) 
	s Tabmoney=$p(s,"^",23) 
	s Tabsl=$p(s,"^",24) 
	s TabUserName=$p(s,"^",27) 
	s TabDoctor=$p(s,"^",28) 
	s TabNumberID=$p(s,"^",31) 
	s TabStates=$p(s,"^",32) 
	s TabHosYJ=$p(s,"^",33)
	s:TabHosYJ="01" TabHosYJ="同意" 
	s:TabHosYJ="02" TabHosYJ="不同意"
	s TabJSYJ=$p(s,"^",34) 
	s:TabJSYJ="01" TabJSYJ="同意" 
	s:TabJSYJ="02" TabJSYJ="不同意"
	s TabMD=$p(s,"^",37) 
	s TabZZ=$p(s,"^",38)
	s TabBZ=$p(s,"^",41) 
	s TabINSUType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DLLType",DataINSUType,4,HospId)
	set Data=$lb(rowid,	TabPatNo,TabPatName,TabRptType,TabAdmSeriNo,TabRptDate,TabFlag,TabAdmType,TabDiagCode,TabDiagDesc,TabSDate,TabEDate,TabRPTNo,Tabxmbm,Tabxmmc,TabHisCode,TabHisDesc,Tabxmlb,TabOutHosName,$fn(Tabmoney,"",2),$fn(Tabsl,"",2),TabUserName,TabDoctor,TabNumberID,TabStates,TabHosYJ,TabJSYJ,TabMD,TabZZ,TabBZ,TabRptTypeDesc,TabINSUType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllExecute ]
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

Query QueryAll(StartDate As %String, EndDate As %String, Rptlb As %String, ParamINSUType, HospId, ExpStr = "") As %Query(ROWSPEC = "rowid:%String,TabPatNo:%String,TabPatName:%String,TabRptType:%String,TabAdmSeriNo:%String,TabRptDate:%String,TabFlag:%String,TabAdmType:%String,TabDiagCode:%String,TabDiagDesc:%String,TabSDate:%String,TabEDate:%String,TabRPTNo:%String,Tabxmbm:%String,Tabxmmc:%String,TabHisCode:%String,TabHisDesc:%String,Tabxmlb:%String,TabOutHosName:%String,Tabmoney:%String,Tabsl:%String,TabUserName:%String,TabDoctor:%String,TabNumberID:%String,TabStates:%String,TabHosYJ:%String,TabJSYJ:%String,TabMD:%String,TabZZ:%String,TabBZ:%String,TabRptTypeDesc:%String,TabINSUType") [ SqlProc ]
{
}

/// do ##class(%ResultSet).RunQuery("web.INSUReport","FindAdmList", "27", "2","I")
Query FindAdmList(papmi As %String, hospId As %String, HisType As %String) As websys.Query(ROWSPEC = "admNo:%String,regNo:%String,patName:%String,admDate:%String,admTime:%String,admDept:%String,admWard:%String,admBed:%String,admStatus:%String,admId:%String,PaSex,PAPMIHealthFundNo")
{
}

ClassMethod FindAdmListExecute(ByRef qHandle As %Binary, papmi As %String, hospId As %String, HisType As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (papmi="")  quit $$$OK
	s ^CacheTemp("FindAdmListExecute")=$lb(papmi,hospId,HisType)
  	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
 	//s PaSex=$p(^PAPER(papmi,"ALL"),"^",7) //
 	s PAPMIHealthFundNo=$p($G(^PAPER(papmi,"PAT",3)),"^",12) //医保手册号
 	k ^CacheTemp("AdmDateInd",$j)
 	
	set AdmType=""
	for  set AdmType=$o(^PAPERdr(papmi,"ADM",AdmType))  quit:(AdmType="")  do
	.q:(HisType'="")&&(("^"_HisType_"^")'[("^"_AdmType_"^")) //DingSH  20210104
	.set rowId=""
	.for  set rowId=$o(^PAPERdr(papmi,"ADM",AdmType,rowId),-1)  quit:(rowId="")  do
	..set admDeptDR=$p(^PAADM(rowId),"^",4)
	..set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
	..quit:((hospId'="")&&(hospId'=admHospDR))
	..q:AdmType="H"    //体检去掉  20210929 DingSH
	..d AdmDateInd

    set rowId=""
	for  set rowId=$o(^CacheTemp("AdmDateInd",$j,rowId),-1)  quit:(rowId="")  do
    .d BudInfo
    
    k ^CacheTemp("AdmDateInd",$j)
    quit $$$OK
AdmDateInd
  s ^CacheTemp("AdmDateInd",$j,rowId)=rowId
 q
	
    
BudInfo	
    set AdmType = $p(^PAADM(rowId),"^",2)
	set admNo=$p(^PAADM(rowId),"^",81)
	set admDate=$p(^PAADM(rowId),"^",6)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=$p(^PAADM(rowId),"^",7)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime, 1)
    set admDeptDR=$p(^PAADM(rowId),"^",4)
	set admDept=$p($g(^CTLOC(admDeptDR)),"^",2)
	set admDept=$s(($f(admDept,"-")'=0):$p(admDept,"-",2),1:admDept)
	set admWardDR=$p(^PAADM(rowId),"^",70)
	set admWard=""
	set:admWardDR'="" admWard=$p($g(^PAWARD(admWardDR)),"^",2)
	set:admWardDR'="" admWard=$s(($f(admWard,"-")'=0):$p(admWard,"-",2),1:admWard)
	set admBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(rowId)
	s admStatus=""
	if (AdmType="I") set admStatus="住院"
	if (AdmType="O") set admStatus="门诊"
	if (AdmType="E") set admStatus="急诊"
	//if (AdmType="H") set admStatus="体检"
	s:admStatus="" admStatus=AdmType
	do OutputAdmList
    q 
	
OutputAdmList
	set Data=$lb(admNo,regNo,patName,admDate,admTime,admDept,admWard,admBed,admStatus,rowId,PaSex,PAPMIHealthFundNo)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// do ##class(%ResultSet).RunQuery("web.INSUReport","FindCTSex")
Query FindCTSex() As websys.Query(ROWSPEC = "Id,Code,Desc")
{
}

ClassMethod FindCTSexExecute(ByRef qHandle As %Binary) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	s Id=0
	for  s Id=$o(^CT("SEX",Id)) q:Id=""  d
	.s Code=$p(^CT("SEX",Id),"^",1)
	.s Desc=$p(^CT("SEX",Id),"^",2)
	.d OutputSex
	quit $$$OK
OutputSex
	set Data=$lb(Id,Code,Desc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 查询科主任/主治医生
/// do ##class(%ResultSet).RunQuery("web.INSUReport","FindSSUser")
Query FindSSUser(HospId) As websys.Query(ROWSPEC = "Id,Code,Desc")
{
}

ClassMethod FindSSUserExecute(ByRef qHandle As %Binary, HospId) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	s Id=0
	for  s Id=$o(^SSU("SSUSR",Id)) q:Id=""  d
	.Set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_User", Id, HospId)
	.Quit:(showFlag="N")
	.s Code=$p(^SSU("SSUSR",Id),"^",1)
	.s Desc=$p(^SSU("SSUSR",Id),"^",2)
	.d OutputSSUser
	quit $$$OK
OutputSSUser
	set Data=$lb(Id,Code,Desc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: Lid
/// CreatDate: 2014-03-13
/// Description: 获取卡类型信息
/// Input: SessionStr:session数据串(IP地址^用户ID^登录科室ID^安全组ID^院区ID^站点^^^)
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QCardTypeDefineList","")
Query QCardTypeDefineList(SessionStr As %String = "") As websys.Query(ROWSPEC = "caption:%String,value:%String,selected:%Boolean,myTypeID")
{
}

ClassMethod QCardTypeDefineListExecute(ByRef qHandle As %Binary, SessionStr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 
   	Set myTypeID=0
	Set mydes=""
	Set myval=""
	Set mySelFlag=0
	Set myDataFlag=0
	Set ^TMPSessionStr=SessionStr
	Set myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	If ($IsObject(myPEObj)){
		Set myDataFlag=1
	}
	Set myIdx=0
	For  Set myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) Quit:(myTypeID="")  Do
	.Set mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.Set myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.Quit:(myActiveFlag'="IE")
	.Set myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.Quit:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.Set myval=myTypeID
	.Set myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.Set myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.If myDefault="Y" Do
	..Set mySelFlag=1
	.Else  Do
	..Set mySelFlag=0
	.Set myFindFlag=1
	.If (+myDataFlag)  Do
	..Set myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
	..If (myPEObj.DefaultCardTypeDR=myTypeID)  Do
	...Set mySelFlag=1
	.Set mySelected="false"     //取默认
	.Set:(mySelFlag=1) mySelected="true"
	.Quit:(+myFindFlag=0)
	.Do OutputCardTypeList
   	
   	Quit $$$OK
 
OutputCardTypeList
	Set Data=$lb(mydes,myval,mySelected,myTypeID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 根据Rowid获取备案信息
/// w ##class(web.INSUReport).GetReportById("47")
ClassMethod GetReportById(InsuReportID As %String) As %String
{
	n (InsuReportID)
	q:InsuReportID="" -100
	s InsuReportInfo=$g(^INSURPT(InsuReportID))
    q:InsuReportInfo="" -100
    q InsuReportID_"^"_InsuReportInfo
}

/// 根据就诊Dr判断患者是否慢病
/// 丁少华 20230331
/// AdmDr：Pa_Adm.Rowid 
/// ExpStr:
/// Return: 成功：Y^医疗类别 或 N^ ；失败 小于0^错误信息
/// 判断规则说明：
/// 	      1:根据医保就诊登记表 AdmType(医疗类别),XString9(病种编码|病种名称)
///  使用场景 门诊收费界面 人员信息展示患者是否慢病
///  特别说明如果 按照3 判断 可能会影响性能
/// w ##class(web.INSUReport).ChekIsChronic("4153")
ClassMethod CheckIsChronic(AdmDr As %String, ExpStr As %String = "") As %String
{
	set $zt="CheckIsChronicEx"
	set IsChronic = "N",MedType=""
	quit:$g(AdmDr)="" "-1^就诊号不能为空"
	set HospDr = ##class(UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
    /*
	set InAdmDr = $O(^DHCINADM("0","ADM",AdmDr,""),-1)
	set PatNo=""
	if +InAdmDr > 0{
		  set PatNo = $P(^DHCINADM(InAdmDr),"^",2) ;INADM_InsuId
		}
	quit:PatNo="" "N^"
	*/
	set InRId=""
	for {
		//set InRId =$O(^INSURPT("0","PatNo",AdmDr,InRId))     //PatNo ? 个人编号 
		// AdmDr 注意 要有AdmDr索引
		set InRId =$O(^INSURPT("0","AdmDr",AdmDr,InRId))  
		quit:InRId=""
		quit:IsChronic="Y"         
		set InRptInfo=$g(^INSURPT(InRId))
		set RptType = $P(InRptInfo,"^",5)     //审批类型
		set RptFlag = $P(InRptInfo,"^",8)     //审批标志
		set InsuType = $P(InRptInfo,"^",43)   //医保类型 String2
		Continue:(RptFlag'="A")
		set TmpMedType=$P(InRptInfo,"^",9)   //医疗类别 INRPT_AdmType 
		;med_type00A的使用标识需要配置 M INSU_DicData.DicUseFlag
		;set MBFalg = ##class(INSU.COM.BaseData).GetDicByCodeAndInd("med_type"_InsuType,11,HospDr)
		;RTPType00A的使用标识需要配置 M INSU_DicData.DicUseFlag 
		set MBFalg = ##class(INSU.COM.BaseData).GetDicByCodeAndInd("RTPType"_InsuType,11,HospDr)
		Continue:MBFalg'="M"
		set MedType = TmpMedType
		set IsChronic="Y"
		}
	quit IsChronic_"^"_MedType
CheckIsChronicEx
 set $zt=""
 b ; CheckIsChronicEx
 quit "-99^调用ChekIsChronic程序异常："_$ze
}

}
