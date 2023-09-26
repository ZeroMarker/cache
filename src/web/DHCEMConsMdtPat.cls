Import sqluser

/// Descript:   MDT会诊病人列表
/// Creator:    bianshuai
/// CreateDate: 2018-07-18
Class web.DHCEMConsMdtPat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: MDT会诊病人列表
/// W ##Class(web.DHCEMConsMdtPat).JsQryConsMdtPatList("30","1","^266^E^2018-07-26^2018-07-26")
ClassMethod JsQryConsMdtPatList(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	
	s PatNo=$p(params,"^",1)    /// 登记号
	s LocID=$p(params,"^",2)    /// MDT科室
	s PAADMType=$p(params,"^",3)  /// 病人类型
	s StartDate=$p(params,"^",4)  /// 起始日期    
	s EndDate=$p(params,"^",5)    /// 截止日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate) /// 开始日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate) /// 开始日期
	s:StartDate="" StartDate=+$H
	s:EndDate="" EndDate=+$H
	
 	Set result=##class(%Library.ResultSet).%New("web.DHCEMConsMdtPat:QueryConsMdtPatList")
 	Set sc=result.Execute(StartDate,EndDate,LocID,PatNo,PAADMType)
 	If $$$ISERR(sc) Quit ""
	
    Set colNum=result.GetColumnCount() //列数
    Set count = 0
    Set del=""""
 	Set tmp=""
 	Set EmPatLevTotal=0,EmPatLevCnt1=0,EmPatLevCnt2=0,EmPatLevCnt3=0,EmPatLevNotCnt=0,EmPatLevWait=0,EmPatLevUnWait=0,EmPatLevStay=0,EmPatLevSalv=0
 	Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.
		
		Set count = count+1
		Continue:(count<Start)||(count>End)
		
		If count=Start Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
    }
	w "]"
	w ","_del_"total"_del_":"_count
	w "}"
	Do result.Close()
	Quit ""
}

/// D ##class(%ResultSet).RunQuery("web.DHCEMConsMdtPat","QueryConsMdtPatList","110","","")
Query QueryConsMdtPatList(StartDate As %String, EndDate As %String, LocID As %String, PatientNo As %String, PAADMType As %String) As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PatNo:%String,PatName:%String,PatBDay:%String,PatAge:%String,PatSex:%String,PAAdmDate:%String,PAAdmTime:%Time,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,PAAdmWard:%String,PAAdmBed:%String,Diagnosis:%String,BillType:%String,CareProv:%String,CareProvCode:%String,ConsID:%String,CurStatus:%String")
{
}

ClassMethod QueryConsMdtPatListExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocID As %String, PatientNo As %String, PAADMType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global

	if (PatientNo=""){
		/*
		s LocType = $p($g(^CTLOC(LocID)),"^",13)
		if (LocType="W") {
			s LocArrStr = ##class(EMRservice.DAL.GetPaAdmDetail).CurDeptLinkLocByDept(LocID)
			F i=3:1:$L(LocArrStr,"^") D
			.s mLocID = $p(LocArrStr,"^",i)
			.Q:mLocID=""
			.s Date=""
			.F  s Date = $O(^PAADMi("AdmTypeCurrLoc","O",mLocID,Date)) Q:Date=""  D
			..s Time=""
			..F  s Time=$O(^PAADMi("AdmTypeCurrLoc","O",mLocID,Date,Time)) Q:Time=""  D
			...s EpisodeID=""
			...F  s EpisodeID=$O(^PAADMi("AdmTypeCurrLoc","O",mLocID,Date,Time,EpisodeID)) Q:EpisodeID=""  D
			....Do OutputRow
		}else{
			s Date=""
			F  s Date = $O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date)) Q:Date=""  D
			.s Time=""
			.F  s Time=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time)) Q:Time=""  D
			..s EpisodeID=""
			..F  s EpisodeID=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time,EpisodeID)) Q:EpisodeID=""  D
			...Do OutputRow
		}
		*/
		For Date=StartDate:1:EndDate Do
		.Set Time=""
		.For  Set Time=$O(^PAADMi("CurrLoc",LocID,Date,Time)) Quit:(Time="")  Do
		..Set EpisodeID=""
		..For  Set EpisodeID=$O(^PAADMi("CurrLoc",LocID,Date,Time,EpisodeID)) Quit:(EpisodeID="")  Do
		...Q:$P(^PAADM(EpisodeID),"^",20)'="A"
		...//到达病人不显示
		...//Set WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(EpisodeID)
		...//If WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
		...//Quit:WalkStatus="到达"
		...Do OutputRow
		.Set Time=0
		
	}else{
		if (PatientNo'=""){
			//登记号查询
			Set PAPMI=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
			if $g(PAPMI)="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
			Set EpisodeID="", CurrentAdmType=PAADMType
			For  Set EpisodeID=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,EpisodeID)) Quit:EpisodeID=""  Do
			.Set AdmDate=$p(^PAADM(EpisodeID),"^",6)
			.;Quit:((StartDate'="")&&(AdmDate<StartDate))||((EndDate'="")&&(AdmDate>EndDate))
			.d OutputRow
		}ELSEIF (PatName'=""){
			Set PAPMI="", CurrentAdmType=PAADMType
			For  Set PAPMI = $O(^PAPERi("PAPER_PatName",$$ALPHAUP^SSUTIL4(PatName),PAPMI)) Q:PAPMI=""  Do
			.Set EpisodeID="" For  Set EpisodeID=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,EpisodeID)) Q:EpisodeID=""  Do
			..Set AdmDate=$p(^PAADM(EpisodeID),"^",6)
			..;Quit:(AdmDate<StartDate)||(AdmDate>EndDate)
			..d OutputRow
		}ELSEIF (CardNo'=""){
			Set CFRowID="", PAPMI="", CurrentAdmType=PAADMType
			Set CFRowID = $o(^DHCCARDi("CF",0,"CardNo",$$ALPHAUP^SSUTIL4(CardNo),CFRowID))
			if (CFRowID'=""){
				Set ActiveFlag = $p(^DHCCARD("CF",CFRowID),"^",10)
				if ("N"=ActiveFlag){
					Set PAPMI = $p(^DHCCARD("CF",CFRowID),"^",4)
					Set EpisodeID="" For  Set EpisodeID=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,EpisodeID)) Q:EpisodeID=""  Do
					.Set AdmDate=$p(^PAADM(EpisodeID),"^",6)
					.;Quit:(AdmDate<StartDate)||(AdmDate>EndDate)
					.d OutputRow
				}
			}
		}
	}
	
	/// 输出病人列表信息
	s index="" f  s index = $o(^TMP("DHCST","web.DHCEMConsMdtPat","QueryConsMdtPatList",pid,index)) q:index=""  d
	.s index2="" f   s index2 = $o(^TMP("DHCST","web.DHCEMConsMdtPat","QueryConsMdtPatList",pid,index,index2)) q:index2=""  d
	..s ^CacheTemp(repid,ind) = $g(^TMP("DHCST","web.DHCEMConsMdtPat","QueryConsMdtPatList",pid,index,index2))
	..s ind=ind+1
	
	d ..killTmpGlobal(pid) //k掉临时global

	Quit $$$OK



OutputRow
    /// 病人就诊信息
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	Q:$P(^PAADM(EpisodeID),"^",20)'="A"
	s mradm=$P(^PAADM(EpisodeID),"^",61) 
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)       //姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)       //登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)         //姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)       //出生日期
	i PatBDay'="" s PatBDay=$zd(PatBDay,3)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //年龄 //hxy 2022-10-14
	s PAAdmDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml($P($g(^PAADM(EpisodeID)),"^",6))  //就诊日期
	s PAAdmTime=$ZT($P($g(^PAADM(EpisodeID)),"^",7),2)  //就诊时间
	s PAAdmNo=$P($g(^PAADM(EpisodeID)),"^",81)          
	s Loc=$P($g(^PAADM(EpisodeID)),"^",4)
	s PAAdmDepCodeDR=$P($g(^CTLOC(Loc)),"^",2)
	i PAAdmDepCodeDR["-" s PAAdmDepCodeDR=$p(PAAdmDepCodeDR,"-",2)
	s Doctor=$P($g(^PAADM(EpisodeID)),"^",9)
	I Doctor'="" s PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	E  s PAAdmDocCodeDR=""
	s PAAdmType=$P($g(^PAADM(EpisodeID)),"^",2)
	s PAAdmWard=""
	s WardDr=$P($g(^PAADM(EpisodeID)),"^",70)
	i WardDr'="" s PAAdmWard=$P($g(^PAWARD(WardDr)),"^",2)                       /// 病区
	s:PAAdmWard["-" PAAdmWard=$p(PAAdmWard,"-",2)
	s BedId=$P($g(^PAADM(EpisodeID)),"^",73)
	I BedId'="" s PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)  /// 床号
	E  s PAAdmBed=""
	s QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
	s QueObj=##Class(User.DHCQueue).%OpenId(QueRowId,0)
	s CareProvCode="", CareProv=""
	s RegDocDr=QueObj.QueMarkDr.%Id()
	i RegDocDr'="" D
	.Set CareProv=$P($g(^CTPCP(RegDocDr,1)),"^",2)
	.Set CareProvCode=$P($g(^CTPCP(RegDocDr,1)),"^",1)
	s PAAdmStatus=$P($g(^PAADM(EpisodeID)),"^",20)
	s FinalDischargeFlag=$S($g(PAAdmStatus)="D":"Y",1:"N")
	s AdmReason=$P($g(^PAADM(EpisodeID,1)),"^",7)
	I AdmReason'="" s PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	E  s PAAdmReason="",PAAdmReasonCode=""
	s DischargeDate=$P($g(^PAADM(EpisodeID)),"^",17)
	s:DischargeDate'="" DischargeDate=$zd(DischargeDate,3)                /// 出院时间
	s Diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm) /// 诊断
	s MedicareNo=##Class(web.DHCEMCommonUtil).GetMrNo(EpisodeID)          //  病案号
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)                       /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s CurStatus=""
	s ConsID=..GetMdtConsID(EpisodeID)  /// 本次就诊关联的MDT申请ID
	i ConsID'="" D
	.s ID=$p(^DHCEMCON(ConsID),"^",18)
	.s CurStatus=$p($g(^DHCEMCONS(+ID)),"^",2)
	.i CurStatus="" s CurStatus="申请"
	s Data=$LB(PatientID,EpisodeID,mradm,PatNo,PatName,PatBDay,PatAge,PatSex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,PAAdmWard,PAAdmBed,Diagnosis,BillType,CareProv,CareProvCode,ConsID,CurStatus)
	s ^TMP("DHCST","web.DHCEMConsMdtPat","QueryConsMdtPatList",pid,LocID,PatNo)=Data
	Quit
}

ClassMethod QueryConsMdtPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryConsMdtPatListExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QueryConsMdtPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryConsMdtPatListExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Descript: 科室列表
/// W ##Class(web.DHCEMConsMdtPat).jsonListLoc(2)	
ClassMethod jsonListLoc(HospID As %String) As %String
{
	n (HospID)
	s Count=0
	w "["
	s WardID=0 
	F  s WardID=$o(^PAWARD(WardID)) Q:(+WardID=0)  D
    .Q:$p(^PAWARD(WardID),"^",6)'="Y"
    .s WardDesc=$p($g(^PAWARD(WardID)),"^",2)
    .s LocID=$p(^PAWARD(WardID),"^",5)
    .Q:LocID=""
    .Q:$p(^CTLOC(LocID),"^",13)'="EM"
    .Q:'$o(^PAWARD(WardID,"ROOM",0))
    .Q:$p(^CTLOC(LocID),"^",22)'=HospID
    .s DateFrom=$P(^PAWARD(WardID),"^",7)
 	.s DateTo=$P(^PAWARD(WardID),"^",9)
 	.Q:((+$h<DateFrom)&&(DateFrom'=""))!((+$h>DateTo)&&(DateTo'=""))
	.s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	.s Data = WardID_"^"_WardDesc
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Data)
	w "]"
	Q ""
}

/// Descript: MDT成员科室列表
/// W ##Class(web.DHCEMConsMdtPat).jsonListMdtLoc(2)	
ClassMethod jsonListMdtLoc(HospID As %String) As %String
{
	n (HospID)
	s Count=0
	w "["
	s ID="" 
	F  s ID=$o(^DHCEMCG(ID)) Q:ID=""  D
	.s CH=""
	.F  s ID=$o(^DHCEMCG(ID,"G",CH)) Q:CH=""  D
    .s LocID=$p(^DHCEMCG(ID,"G",CH),"^",1)
    .Q:LocID=""
    .Q:$p(^CTLOC(LocID),"^",22)'=HospID
    .s LocDesc=$p(^CTLOC(LocID),"^",2)
	.s Data = LocID_"^"_LocDesc
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Data)
	w "]"
	Q ""
}

/// Descript: 获取病人会诊记录ID
/// W ##Class(web.DHCEMConsMdtPat).GetMdtConsID(2)
ClassMethod GetMdtConsID(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s ConsID=$o(^DHCEMCON(0,"ADM",EpisodeID,""))
	Q ConsID
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCEMConsMdtPat","QueryConsMdtPatList",pid)
}

Storage Default
{
<Data name="DHCEMConsMdtPatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMConsMdtPatD</DataLocation>
<DefaultData>DHCEMConsMdtPatDefaultData</DefaultData>
<IdLocation>^web.DHCEMConsMdtPatD</IdLocation>
<IndexLocation>^web.DHCEMConsMdtPatI</IndexLocation>
<StreamLocation>^web.DHCEMConsMdtPatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
