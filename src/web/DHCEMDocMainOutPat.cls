Import sqluser

/// Descript:   急诊病人登记
/// Creator:    bianshuai
/// CreateDate: 2016-11-11
Class web.DHCEMDocMainOutPat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 急诊病人信息
/// w ##class(web.DHCEMDocMainOutPat).GetEmRegPatInfo("0000000011")
ClassMethod GetEmRegPatInfo(EmPatNo As %String, PatientID As %String) As %String
{
	n (EmPatNo, PatientID ,%session)
	s LgHospID=%session.Get("LOGON.HOSPID")
    i PatientID="" s PatientID=$o(^PAPERi("PAPMI_PatNo",EmPatNo,""))
    Q:PatientID="" ""
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	   /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",LgHospID)  /// 年龄
	s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	i birthday'="" s birthday=$zd(birthday,3)
	s IdentNo=$p(^PAPER(PatientID,"ALL"),"^",9)         /// 身份证号
	s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  /// 民族
	s countrydr=$p(^PAPER(PatientID,"PER",1),"^",8) 	/// 国家
	s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s PatDiag=""
	s PAAdmType=$o(^PAPERdr(PatientID,"ADM",""),-1)
	s EpisodeID=$o(^PAPERdr(PatientID,"ADM",PAAdmType,""),-1)
	s PatCardMoney=##Class(web.DHCAPPPrintCom).GetPatCardMoney(PatientID)  /// 获取卡余额
	s PatCardNo=##Class(web.DHCAPPPrintCom).GetCardNoByRegNo(PatientID)    /// 获取卡号

	s ListData=PatientID_"^"_EpisodeID_"^"_PatCardNo_"^"_PatNo_"^"_PatName_"^"_sexId_"^"_PatSex_"^"_PatAge_"^"_PatDiag
	s ListData=ListData_"^"_nationdr_"^"_countrydr_"^"_birthday_"^"_IdentNo_"^"_PatTelH_"^"_Address_"^"_BillType_"^"_"1"_"^"_PatCardMoney
	
	s ListTitle="PatientID^EpisodeID^PatCardNo^PatNo^PatName^sexId^PatSex^PatAge^PatDiag^nationdr^countrydr^birthday^IdentNo^PatTelH^Address^BillType^PatLevel^PatCardBal"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript: 急诊病人列表
/// W ##Class(web.DHCEMDocMainOutPat).JSonQryEmDocMainPatList("30","1","^^^E^^^^Y^^^^^203^11841^^cl^^^Per^^^^^")
ClassMethod JSonQryEmDocMainPatList(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params,%session)
	s End = page*rows
	s Start=(page-1)*rows+1
	s ListPid=##Class(web.DHCEMPatCheckLevCom).NewPid()
	
 	Set result=##class(%Library.ResultSet).%New("web.DHCEMDocMainOutPat:QueryEmDocMainPatListA")
 	Set sc=result.Execute(params,ListPid)
 	If $$$ISERR(sc) Quit ""
	
    Set colNum=result.GetColumnCount() //列数
    Set count = 0
    Set del=""""
 	Set tmp=""
 	Set TmpWardPatNum=""
 	Set EmPatLevTotal=0,EmPatLevCnt1=0,EmPatLevCnt2=0,EmPatLevCnt3=0,EmPatLevCnt4=0,EmPatLevNotCnt=0,EmPatLevWait=0,EmPatLevUnWait=0,EmPatLevStay=0,EmPatLevSalv=0
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
		Set ret=ret_","_del_"ItmXH"_del_":"_del_count_del
		If count=Start Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
		
	 }
	 
	
	 s ObsPatInfo = ""			/// 以前版本为写死状态，如今改为动态获取数量  qqa 2018-11-20
	 s WardDesc =""				/// 留观室人数信息
	 f  s WardDesc  = $o(^TMP("web.DHCEMDocMainOutPat","WardPatNumber",ListPid,WardDesc)) q:WardDesc=""  d
	 .s WardPatNum = ^TMP("web.DHCEMDocMainOutPat","WardPatNumber",ListPid,WardDesc)
	 .s:ObsPatInfo'="" ObsPatInfo = ObsPatInfo_"^"_WardDesc_":"_WardPatNum
	 .s:ObsPatInfo="" ObsPatInfo = WardDesc_":"_WardPatNum
	 
	 s EmPatLevCnt1=+$g(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevCnt1"))
	 s EmPatLevCnt2=+$g(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevCnt2"))
	 s EmPatLevCnt3=+$g(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevCnt3"))
	 s EmPatLevCnt4=+$g(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevCnt4"))
	 s EmPatLevUnWait=+$g(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevUnWait"))
	 s EmPatLevWait=+$g(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevWait"))
	 s EmPatLevNotCnt=+$g(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevNotCnt"))
	 s EmPatLevComp=+$g(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevComp"))
	 s EmPatDisHosp=+$g(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatDisHosp"))
	 
	 w "]"
	 w ","_del_"total"_del_":"_count
	 w ","_del_"EmPatLevTotal"_del_":"_EmPatLevTotal_","_del_"EmPatLevCnt1"_del_":"_EmPatLevCnt1
	 w ","_del_"EmPatLevCnt2"_del_":"_EmPatLevCnt2_","_del_"EmPatLevCnt3"_del_":"_EmPatLevCnt3
	 w ","_del_"EmPatLevCnt4"_del_":"_EmPatLevCnt4 //hxy 2020-02-21
	 w ","_del_"EmPatLevNotCnt"_del_":"_EmPatLevNotCnt_","_del_"EmPatLevWait"_del_":"_EmPatLevWait
	 w ","_del_"EmPatLevComp"_del_":"_EmPatLevComp
	 w ","_del_"EmPatDisHosp"_del_":"_EmPatDisHosp
	 w ","_del_"EmPatLevUnWait"_del_":"_EmPatLevUnWait
	 ;w ","_del_"EmPatLevStay"_del_":"_EmPatLevStay       //
	 ;w ","_del_"EmPatLevSalv"_del_":"_EmPatLevSalv
	 w ","_del_"ObsPatInfo"_del_":"_del_ObsPatInfo_del
	 w "}"
	 Do result.Close()
	 k ^TMP("web.DHCEMDocMainOutPat","WardPatNumber",ListPid)
	 k ^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid)
	 k ^TMP("web.DHCEMDocMainOutPat","ThisAdmIsHas",ListPid)
	 Quit ""
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocMainOut","FindCurrentAdmProxy","","","","","O","","2016-08-18","2016-11-26","","","","")
/// d ##class(%ResultSet).RunQuery("web.DHCEMDocMainOutPat","QueryEmDocMainPatListA","","","","O","","2016-08-18","2016-11-26","","","","","","308","2874")
/// d ##class(%ResultSet).RunQuery("web.DHCEMDocMainOutPat","QueryEmDocMainPatListA","^^^E^^2022-01-27^2022-01-28^Y^^^^^39^18849^^^^^Per^^^^^^N^^2",101199)
Query QueryEmDocMainPatListA(Params As %String, ListPid As %String) As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PatNo:%String,PatName:%String,PatBDay:%String,PatSex:%String,PAAdmDate:%String,PAAdmTime:%Time,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String,DischargeDate:%String,RegDoctor:%String,Diagnosis:%String,ArrivedDate:%String,ArrivedTime:%String,LeavedDate:%String,LeavedTime:%String,LocSeqNo:%String,PAAdmPriority:%String,WalkStatus:%String,ConsultRoom:%String,ConsultArea:%String,PAAdmReasonCode:%String,StatusCode:%String,PatAge:%String,PriorityCode:%String,Called:%String,RegDocDr:%String,IconProfile:%String,Arrived:%String,1,2,3,PatCardBal:%String,BillType:%String,PatLevel:%String,CardNo:%String,PatGreFlag:%String,PCLvArea:%String,PCLvNurse:%String,PriorityColor:%String,CalledDesc:%String,EmChkWaitYx:%String,StrTime,ItmUnObr,CareLevel,CareLevelUpOrDown")
{
}

ClassMethod QueryEmDocMainPatListAExecute(ByRef qHandle As %Binary, Params As %String, ListPid = 0) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PatientNo=$p(Params,"^",1)     /// 登记号
	s PatName=$p(Params,"^",2)       /// 姓名
	s MedicalNo=$p(Params,"^",3)     /// 病案号
	s PAADMType=$p(Params,"^",4)     /// 就诊类型
	s CardNo=$p(Params,"^",5)        /// 卡号
	s StartDate=$p(Params,"^",6)  /// 起始日期    
	s EndDate=$p(Params,"^",7)    /// 截止日期
	s OutArrivedQue=$p(Params,"^",8) /// 已就诊
	s OutRegQue=$p(Params,"^",9)     /// 未就诊
	s OutConsultation=$p(Params,"^",10) ///
	s OutAllPatient=$p(Params,"^",11)   /// 
	s AdmReqNo=$p(Params,"^",12)        ///
	s LocID=$p(Params,"^",13)  		    /// 科室
	s UserID=$p(Params,"^",14) 		    /// 用户
	s EmPatLev=$p(Params,"^",15) 	    /// 分级
	s TmpCondition=$p(Params,"^",16)    ///登记号或者病人姓名
	s StayInWard=$p(Params,"^",17)
	s ToArea=$p(Params,"^",18)           /// 去向
	s PatListType=$p(Params,"^",19)      /// 病人列表类型
	s TmpWardID=$p(Params,"^",20)        /// 抢救/留观病区ID
	s CurCheckLev=$p(Params,"^",21)      ///当前分级
	s CareDesc=$p(Params,"^",22)         /// 号别 hxy 2018-06-22
    s ConcDoc=$p(Params,"^",23)			 ///主管医生
    s InSeatNo=$p(Params,"^",24)		 ///床号
    s InCompted=$p(Params,"^",25)		 ///完成就诊
    s DisHospPat=$p(Params,"^",26)		 ///离院患者
    s LgHospID=$p(Params,"^",27)
    s AllWard=$p(Params,"^",28)          ///全病区
    
	s LocHospID=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(LocID)
	;""或者0:复诊以普通待诊排序,-1:处于队列最后方，-2:处于队列最前方，>0：配置数量为待诊穿插数(例如2，就是2个待诊中穿插一个复诊)
	s LimitNum=+##Class(web.DHCEMComPar).GetAppPropValue("DHCEMDOC","VISITLISTORDER",LocHospID,"","","")
	; 1：未分诊患者限制就诊（不查询） 其他：未分诊患者不限制就诊（查询）  2022-08-30 cy
	s LimitNoTriage=+##Class(web.DHCEMComPar).GetAppPropValue("DHCEMDOC","LIMITNOTRIAGE",LgHospID,LocID,UserID,"")
	; 已就诊患者列表排序 -1：完全按就诊时间倒序，1：完全按就诊时间正序显示，其他：此配置(UNWAITLISTORDER)不影响已就诊患者列表排序  2022-08-30 cy
	s ListOrder="1"
	s UnWaitOrder=+##Class(web.DHCEMComPar).GetAppPropValue("DHCEMDOC","UNWAITLISTORDER",LgHospID,LocID,UserID,"")
	s:(OutArrivedQue="Y")&&(UnWaitOrder="-1") ListOrder="-1"
	s:(OutArrivedQue="Y")&&(UnWaitOrder="1") ListOrder="1"
	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid() 
    d ..killTmpGlobal(pid) //k掉临时global
    s StartTime=""                         //遍历的时候查询的开始时间
    i StartDate="" d  //日期的设置
    .s StartDate=+$H-1    
    .s StartTime = $p($H,",",2)
	i EndDate="" s EndDate=+$H    //结束日期
	Set:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate) /// 开始日期
	Set:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate) /// 开始日期
	s DocId=$p($g(^SSU("SSUSR",UserID)),"^",14) 	 /// 医生ID 
	
	s ListNormalNumber=0,ListVisitCallNumber=0,ListDefaultCallNumber=0
	
	s PAPMI=""
	/// 录入内容可能为登记号/姓名其中一项，此处做判断
	s PatLikeName="" ;qqa Add Fuzzy Matching
	if (TmpCondition'="") {
		s PAPMI=$o(^PAPERi("PAPMI_PatNo",TmpCondition,""))
		s:PAPMI="" PatLikeName=TmpCondition
	}
	
	///病案号
	IF (MedicalNo'="")&&(PAPMI=""){
		Set PAPMI = $O(^PAPERi("Medicare1",$$ALPHAUP^SSUTIL4(MedicalNo),""))
	}
	
	///卡号
	IF (CardNo'="")&&(PAPMI=""){
		Set CFRowID="", PAPMI=""
		Set CFRowID = ""
		For  Set CFRowID=$o(^DHCCARDi("CF",0,"CardNo",$$ALPHAUP^SSUTIL4(CardNo),CFRowID),-1) Quit:(CFRowID="")||(PAPMI'="")  Do
		.Set ActiveFlag = $p(^DHCCARD("CF",CFRowID),"^",10)
		.Quit:"N"'=ActiveFlag
		.Set PAPMI = $p(^DHCCARD("CF",CFRowID),"^",4)
	}
	
	Quit:(MedicalNo'="")&&(PAPMI="") $$$OK
	Quit:(CardNo'="")&&(PAPMI="") $$$OK
	
	if (PAPMI=""){
		//统计未诊断/已诊断的病人
		For Date=StartDate:1:EndDate Do
		.Set:Date=StartDate Time=StartTime      //取24小时
		.Set:Date'=StartDate Time=""            //第二天查全天
		.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time)) Quit:Time=""  Do
		..Set EpisodeID=0
		..For  Set EpisodeID=$O(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time,EpisodeID)) Quit:EpisodeID=""  Do ;所有的过滤走公共部分
		...Do OutputRow

		/// 留观/抢救
		Set LinkID="" For  Set LinkID=$O(^CTLOC(LocID,"LINK",LinkID)) Quit:LinkID=""  Do
		.Set LnkLocID=$P($G(^CTLOC(LocID,"LINK",LinkID)),"^",1)
		.Set LnkLocType=$P($G(^CTLOC(LnkLocID)),"^",13)
		.Quit:LnkLocType'="EM"
		.Set EmWardID=$O(^PAWARD(0,"WARD_LocationDR",LnkLocID,""))
		.Quit:EmWardID=""
		.Set RoomDr=0
		.For  Set RoomDr=$O(^PAADMi("CurrWard",EmWardID,RoomDr)) Quit:RoomDr=""  Do
		..Set EpisodeID=""
		..For  Set EpisodeID=$O(^PAADMi("CurrWard",EmWardID,RoomDr,EpisodeID)) Quit:EpisodeID=""  Do
		...s AdmLocID=$p(^PAADM(EpisodeID),"^",4) 	/// 科室
		...q:(LocID'=AdmLocID)&&(AllWard'="Y")	;只看就诊科室是本科室的留观患者 ;全病区时不过滤科室
		...Set QueRowId=##Class(web.DHCDocOutPatientList).GetQueRowidByMore(EpisodeID,DocId)
		...d OutputRow
		.Set CH=0
		.For  Set CH=$O(^PAWARDA(EmWardID,"WADM",CH)) Quit:CH=""  Do
		..Set EpisodeID=$P(^PAWARDA(EmWardID,"WADM",CH),"^",1)
		..s AdmLocID=$p(^PAADM(EpisodeID),"^",4) 	/// 科室
		..;q:LocID'=AdmLocID	;只看就诊科室是本科室的离院患者
		..q:(LocID'=AdmLocID)&&(AllWard'="Y")	;只看就诊科室是本科室的等候患者 ;全病区时不过滤科室
		..Do OutputRow
		
		///离院患者
		s DischargeDr = $o(^DHCPACVisitStatus(0,"Desc","离院",""))  
		For Date=+$H-1:1:+$H Do
		.Set AVSRowId=""
		.For  s AVSRowId=$o(^DHCADMVisitStatus(0,"DateStatus",Date,DischargeDr,AVSRowId)) Quit:AVSRowId=""  Do
		..Set EpisodeID = $p(^DHCADMVisitStatus(AVSRowId),"^",1)
		..Set ADMVisitStatusDr = $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
		..Set PACVisitStatusDr=$p(^DHCADMVisitStatus(ADMVisitStatusDr),"^",2)
		..Set CurStatusDesc = $p(^DHCPACVisitStatus(PACVisitStatusDr),"^",2)
		..Quit:PACVisitStatusDr'=DischargeDr 
		..Set AdmWardId=$p(^PAADM(EpisodeID),"^",70)
		..Quit:+AdmWardId=0
		..s AdmHospId=##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
		..q:(LgHospID'="")&&(LgHospID'=AdmHospId)
		..Do OutputRow
	}else{
		if $g(PAPMI)="" Quit $$$OK
		Set EpisodeID="", CurrentAdmType=PAADMType
		For  Set EpisodeID=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,EpisodeID)) Quit:EpisodeID=""  Do
		.Set AdmDate=$p(^PAADM(EpisodeID),"^",6)
		.Quit:((StartDate'="")&&(AdmDate<StartDate))||((EndDate'="")&&(AdmDate>EndDate))
		.d OutputRow
	}
	
	s Count=0,VisitIndex=0,DefInex=0
	
	;起始复诊展示位置
	s ThisLimitNum="" ;起始第几个数据显示复诊，这里由于是先显示正在呼叫,故应排除正在呼叫数量
	i LimitNum>0 d
	.s:'$d(^TMP("ThisLimitNum",+UserID)) ^TMP("ThisLimitNum",+UserID)=LimitNum+1
	.s:ListVisitCallNumber'=0 ^TMP("ThisLimitNum",+UserID)=LimitNum+1        ;正在呼叫的患者包含复诊患者：首个复诊显示为默认待诊间隔
	.s ThisLimitNum=^TMP("ThisLimitNum",+UserID)
	.i (ListVisitCallNumber=0)&&(ListDefaultCallNumber'=0) d	             ;正在呼叫的患者为默认队列
	..s:ListDefaultCallNumber'<+^TMP("ThisLimitNum",+UserID) ThisLimitNum=1	 ;正在呼叫的患者超过默认显示位置
	..s:ListDefaultCallNumber<+^TMP("ThisLimitNum",+UserID) ThisLimitNum=^TMP("ThisLimitNum",+UserID)-ListDefaultCallNumber	;未超过默认显示位置
	
	
	s IsShowVisitList=((LimitNum>0)&&(OutArrivedQue="N")&&(TmpWardID="")&&(DisHospPat'="Y"))	;是否显示复诊间隔队列
	
	d:'IsShowVisitList OutputNormalList  ;显示正常列表：复诊最下方,已诊,留观室患者,离院患者
	d:IsShowVisitList OutputVisitList	;显示待诊和复诊间隔列表
	
	d ..killTmpGlobal(pid) //k掉临时global
	Quit $$$OK

OutputRow
	
	s AdmVisit=$p(^PAADM(EpisodeID),"^",20)
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	q:'$d(^PAPER(PatientID,"ALL"))
	s mradm=$P(^PAADM(EpisodeID),"^",61) 
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)       //姓名
	s Doctor=$P($g(^PAADM(EpisodeID)),"^",9)   ///主管医生
	s PAAdmWard=""
	s WardDr=$P($g(^PAADM(EpisodeID)),"^",70)                                    /// 
	i WardDr'="" s PAAdmWard=$P($g(^PAWARD(WardDr)),"^",2)                       /// 病区
	s:PAAdmWard["-" PAAdmWard=$p(PAAdmWard,"-",2)
	S PAAdmWard=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",PAAdmWard)

	s BedId=$P($g(^PAADM(EpisodeID)),"^",73)
	I BedId'="" s PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)  /// 床号
	E  s PAAdmBed="" 
	
	s WalkStatus=##Class(web.DHCEMDocMainOutPat).GetPatCurStat(EpisodeID)       /// 当前状态
	i WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
	i WalkStatus="" s WalkStatus="等候"
	s IsWaitPat = ((WalkStatus="等候")||(WalkStatus["复诊"))
	s Compted = $p(^PAADM(EpisodeID,1),"^",23)
	s:Compted="" Compted="N"
	
	s QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))   			///QueRowId
	s QueObj=##Class(User.DHCQueue).%OpenId(QueRowId,0)
	s RegDocCode="", RegDoctor="",RegDocDr=""
	s QueDocId="",Include="",IsCESFlag="" ;就诊医师(已诊),医生号别对照id,根据业务表和ID获取判断数据是否是应急收费系统导入的数据0:否;1:是
	s:QueObj="" IsCESFlag=##Class(DHCDoc.Interface.StandAlone.Service).IsCESFlag("pa_adm",EpisodeID)
	s:IsCESFlag IsWaitPat=0 													///应急患者算已诊
	s Called=""																	///叫号
	i QueObj'="" d
	.s QueDocId=QueObj.QueDocDrGetObjectId()
	.s QueMarkId=QueObj.QueMarkDrGetObjectId()
	.s:QueMarkId'="" Include=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,QueMarkId,""))	///医生号别对照
	.s Called=QueObj.QueCompDr
	.s:QueMarkId'="" RegDocDr=QueObj.QueMarkDr.%Id()
	.i RegDocDr'="" D
	..Set RegDoctor=$P($g(^CTPCP(RegDocDr,1)),"^",2)
	..Set RegDocCode=$P($g(^CTPCP(RegDocDr,1)),"^",1)
	
	s EmPCLvArea=##Class(web.DHCEMDocMainOutPat).GetEmPCLvArea(EpisodeID)       /// 分级去向
	s PAAdmPriority="",PriorityCode="",PriorityColor=""                         /// 优先级、优先级代码、背景色
	s Priority=$P($g(^PAADM(EpisodeID)),"^",33)
	s PriorityColor=""
	i Priority'="" s PAAdmPriority=$p($g(^CT("ACU",Priority)),"^",1),PriorityCode=+$p($g(^CT("ACU",Priority)),"^",1),PriorityColor=$p($g(^CT("ACU",Priority)),"^",11)
	s:Priority="" Priority=5                                                    /// 排序字段为空设置为5
	s EmPCLvArea=$s(PAAdmPriority="1级":"红区",PAAdmPriority="2级":"橙区",PAAdmPriority="3级":"黄区",PAAdmPriority="4级":"绿区",PAAdmPriority="5级":"绿区",1:EmPCLvArea) //hxy 2020-02-21
	s NurseLevel=""
	i PAAdmPriority'="" s NurseLevel=PAAdmPriority
	Q:(LimitNoTriage=1)&&(EmPCLvArea="") /// 2022-08-30 cy 未分诊患者限制就诊
	
	;优化加载速度过滤提前
	;本人/本组/本科过滤医师,非留观
	q:(QueDocId'="")&&(QueDocId'=DocId)&&(PatListType="Per")&&(PAAdmWard="")&&(IsCESFlag'=1)	///IsCESFlag:应急患者0:否;1:是
	q:(Include="")&&(PatListType="Per")&&(PAAdmWard="")&&(IsCESFlag'=1)
	s UnitFlag=""  				/// 医疗组
	s:(PatListType="Grp") UnitFlag=##Class(EMRservice.DAL.GetPaAdmDetail).CheckCTLocMedUnit(Doctor,DocId,LocID)
	q:(PatListType="Grp")&&(UnitFlag'=1)&&(PAAdmWard="")&&(IsCESFlag'=1)
	
	;患者姓名/号别/床号
	q:(PatLikeName'="")&&(PatName'[PatLikeName)	
	q:(ConcDoc'="")&&(ConcDoc'=Doctor)
	q:(InSeatNo'="")&&(+InSeatNo'=+PAAdmBed)
	
	;设置界面已诊，未诊，留观室数量
	i AdmVisit="A" d
	.q:$d(^TMP("web.DHCEMDocMainOutPat","ThisAdmIsHas",ListPid,AdmVisit,EpisodeID)) ;已经设置过的就诊不再重复计数
	.s ^TMP("web.DHCEMDocMainOutPat","ThisAdmIsHas",ListPid,AdmVisit,EpisodeID)=""
	.d:PAAdmWard'="" $i(^TMP("web.DHCEMDocMainOutPat","WardPatNumber",ListPid,PAAdmWard))
	.i ('IsWaitPat)&&(PAAdmWard="") d
	..d:Compted'="Y" $i(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevUnWait"))
	..d:Compted="Y" $i(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevComp"))
	.d:(IsWaitPat)&&(PAAdmWard="") $i(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevWait"))
	i AdmVisit="D" d
	.q:$d(^TMP("web.DHCEMDocMainOutPat","ThisAdmIsHas",ListPid,AdmVisit,EpisodeID)) ;已经设置过的就诊不再重复计数
	.s ^TMP("web.DHCEMDocMainOutPat","ThisAdmIsHas",ListPid,AdmVisit,EpisodeID)=""
	.d $i(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatDisHosp"))
	
	;离院患者过滤
	q:(DisHospPat'="Y")&&(AdmVisit'="A")			//离院患者
	q:(DisHospPat="Y")&&(AdmVisit'="D")				//离院患者
	;已诊未诊过滤
	q:(OutArrivedQue="Y")&&(IsWaitPat)&&(PAAdmWard="")			//已就诊
	q:(OutArrivedQue'="Y")&&('IsWaitPat)&&(PAAdmWard="")	    	//未就诊       
	q:(OutArrivedQue="Y")&&(InCompted'=Compted)&&(PAAdmWard="")	//完成就诊过滤
	;留观过滤
	q:(TmpWardID'="")&&(WardDr'=TmpWardID)						//留观室患者列表展现过滤
	q:(TmpWardID="")&&(WardDr'="")&(DisHospPat'="Y")				//非留观患者过滤,去除离院患者
	S RegDoctor=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",RegDoctor)
	q:(CareDesc'="")&&(RegDoctor'=CareDesc)
	
	;记录分级人数
	i PAAdmPriority'="" d
	.d $i(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevTotal"))
	.d:PAAdmPriority="1级" $i(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevCnt1"))
	.d:PAAdmPriority="2级" $i(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevCnt2"))
	.d:PAAdmPriority="3级" $i(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevCnt3"))
	.d:(PAAdmPriority="4级")||(PAAdmPriority="5级") $i(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevCnt4"))
	E  d $i(^TMP("web.DHCEMDocMainOutPat","DataNumber",ListPid,"EmPatLevNotCnt"))
	
	;记录分诊数量之后再过滤分诊级别
	q:(ToArea'="")&(ToArea'=EmPCLvArea)
	q:(CurCheckLev'="")&&(CurCheckLev'=+PAAdmPriority)
	q:(EmPatLev'="")&(EmPatLev'=NurseLevel)

	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)       //登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)         //姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)       //出生日期
	i PatBDay'="" s PatBDay=$zd(PatBDay,3)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	s PAAdCacheDate=$P($g(^PAADM(EpisodeID)),"^",6)
	s PAAdCacheTime=$P($g(^PAADM(EpisodeID)),"^",7)
	s PAAdmDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PAAdCacheDate)  //就诊日期
	s PAAdmTime=$ZT(PAAdCacheTime,2)  //就诊时间
	s Deposit=##class(web.UDHCJFBaseCommon).deposit(EpisodeID) // 患者未结算押金总额
	s PAAdmNo=$P($g(^PAADM(EpisodeID)),"^",81)          
	s Loc=$P($g(^PAADM(EpisodeID)),"^",4)
	s PAAdmDepCodeDR=$P($g(^CTLOC(Loc)),"^",2)
	i PAAdmDepCodeDR["-" s PAAdmDepCodeDR=$p(PAAdmDepCodeDR,"-",2)
	
	I Doctor'="" s PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	E  s PAAdmDocCodeDR=""
	
	s:$g(WalkStatus)="" PAAdmDocCodeDR=""  ///未就诊病人不配有就诊医生
	s PAAdmType=$P($g(^PAADM(EpisodeID)),"^",2)
	
	s FinancialDischargeFlag=$P($g(^PAADM(EpisodeID)),"^",45)
	s MedicalDischargeFlag=$P($g(^PAADM(EpisodeID)),"^",63)
	s PAAdmStatus=$P($g(^PAADM(EpisodeID)),"^",20)
	s FinalDischargeFlag=$S($g(PAAdmStatus)="D":"Y",1:"N")
	s AdmReason=$P($g(^PAADM(EpisodeID,1)),"^",7)
	I AdmReason'="" s PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	E  s PAAdmReason="",PAAdmReasonCode=""
	s DischargeDate=$P($g(^PAADM(EpisodeID)),"^",17)
	s:DischargeDate'="" DischargeDate=$zd(DischargeDate,3)                /// 出院时间
	s Diagnosis=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID,"","") ;##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm) /// 诊断
	s:Diagnosis'="" Diagnosis=$tr(Diagnosis,$c(92),"")
	s Seq=EpisodeID
	s PatientMedicare=##Class(web.DHCEMCommonUtil).GetMrNo(EpisodeID)     //病案号
	s LocSeqNo=""
	&SQL(SELECT ID into :RegId FROM SQLUser.DHCRegistrationFee Where RegfeeAdmDr=:EpisodeID)
	i RegId'="" d
	.s LocSeqNo=$List(^User.DHCRegistrationFeeD(RegId),8)
	s:(LocSeqNo="")&&(QueObj'="") LocSeqNo=QueObj.QueNo
	s IconProfile=""
	s Arrived=""
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)                        /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)

	s PatCardMoney="" //##Class(web.DHCAPPPrintCom).GetPatCardMoney(PatientID) 	    /// 获取卡余额
	s CardNo="" //##Class(web.DHCAPPPrintCom).GetCardNoByRegNo(PatientID)  	        /// 获取卡号
	s EmNurLev=##Class(web.DHCEMDocMainOutPat).GetEmPatCheckLev(EpisodeID)      /// 分级
	s EmPatGreFlag=##Class(web.DHCEMDocMainOutPat).GetEmPatGreenFlag(EpisodeID) /// 绿色通道标示

	s EmPCLvNurse=##Class(web.DHCEMDocMainOutPat).GetEmPCLvNurse(EpisodeID)     /// 分级护士

	s IsYx =##Class(web.DHCEMDocMainOutPat).IsYx(EpisodeID)
	s CallStatus = ##class(web.DHCEMDocMainOutPat).GetCallStatu(EpisodeID)
	
	/// 滞留时间
	s StrTime="" //##class(web.DHCEMObsRoomSeat).GetFirstInSeatDate(EpisodeID)
	s ItmUnObr=$ZCVT(##class(web.DHCDocMain).ShowIcon("MAP",EpisodeID_"^^^"_PatientID,""),"O","HTML")	//加图表菜单
	s ItmUnObr=##class(web.DHCDocUtil).EvalJSON(ItmUnObr)
	s CareLevel=##class(Nur.CommonInterface.Patient).getCareLevel(EpisodeID)	/// 护理级别
	s CareLevelUpOrDown=..GetCareLevelUpOrDown(EpisodeID)

	
	s PriorityCallStatus=1,CalledDesc="" ///排序呼叫状态
	i IsWaitPat d
	.i +Called=1 d
	..s PriorityCallStatus=0,CalledDesc="正在叫号" ///已经叫号的提前至医生队列前方
 	.i CallStatus="过号" d
 	..s PriorityCallStatus=2,CalledDesc="过号" ///过号的最后方显示
 	
	s EmChkWaitIndex=1,EmChkWaitYx="" ///分诊等待超时是否优先
	i IsYx d
	.s EmChkWaitIndex=0,EmChkWaitYx="是"

	s VisitPatOrd=2 	///复诊排序
	i (WalkStatus["复诊")&&(PAAdmWard="") d
	.s:LimitNum=-1 VisitPatOrd=3
	.s:LimitNum=-2 VisitPatOrd=1
	
	s OrdEmNurLev=$s(+EmNurLev=0:99,1:+EmNurLev)

	;呼叫状态^过号^优先^复诊^就诊日期^分诊级别^就诊时间^就诊ID
	s index=PriorityCallStatus_"^"_EmChkWaitIndex_"^"_VisitPatOrd_"^"_
			PAAdCacheDate_"^"_OrdEmNurLev_"^"_PAAdCacheTime_"^"_EpisodeID
	
	s OrderStr=$case(PAAdmBed,"":"999床",:PAAdmBed_"床")  ///无床患者排有床患者后方
	
	/// 多语言修改
	S EmPCLvArea=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patlist.csp",EmPCLvArea)
	S PAAdmPriority=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patlist.csp",PAAdmPriority)
	S EmNurLev=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patlist.csp",EmNurLev)
	S CalledDesc=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patlist.csp",CalledDesc)
	S PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	S PAAdmDepCodeDR=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",PAAdmDepCodeDR)
	S PAAdmDocCodeDR=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",PAAdmDocCodeDR)
	S EmPCLvNurse=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",EmPCLvNurse)
	S BillType=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSocialStatus","SSDesc","",BillType)
	S Diagnosis=##class(web.DHCEMCommonUtil).GetTransDesc("User.MRCICDDx","MRCIDDesc","",Diagnosis)
	S EmChkWaitYx=##class(web.DHCEMCommonUtil).GetTrans("",EmChkWaitYx)
	; 已就诊患者列表排序--配置 -1：完全按就诊时间倒序，1：完全按就诊时间正序显示 2022-10-08 cy
	I (OutArrivedQue="Y")&&((UnWaitOrder=1)||(UnWaitOrder=-1)) D
	.S index=PAAdCacheDate_"^"_PAAdCacheTime
	.S OrderStr="999"
	s Data=$LB(PatientID,EpisodeID,mradm,PatNo,PatName,PatBDay,PatSex,PAAdmDate,
		PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,"",PAAdmWard,PAAdmBed,
		FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,
		DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,
		LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,
		StatusCode,PatAge,PriorityCode,Called,RegDocDr,PatientMedicare,"",IconProfile,Arrived,""
		,PatCardMoney,BillType,EmNurLev,CardNo,EmPatGreFlag,EmPCLvArea,EmPCLvNurse,PriorityColor,
		CalledDesc,EmChkWaitYx,StrTime,ItmUnObr,CareLevel,CareLevelUpOrDown)
	s ^TMP("DHCST","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,OrderStr,index)=Data
	
	i (WalkStatus'["复诊")||(PAAdmWard'="") d
	.i CallStatus="过号" d
	..s ^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"DefaultListSkip",index)=Data	;过号池
	.e  i +Called=1 d
	..s ListDefaultCallNumber=ListDefaultCallNumber+1
	..s ^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"DefaultListCalled",index)=Data ;正在呼叫池
	.e  d
	..s ListNormalNumber=ListNormalNumber+1
	..s ^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"DefaultList",index)=Data	;普通池
	i (WalkStatus["复诊")&&(PAAdmWard="") d
	.i +Called=1 d
	..s:+Called=1 ListVisitCallNumber=ListVisitCallNumber+1
	..s ^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"VisitListCalled",index)=Data
	.e  d
	..s ListNormalNumber=ListNormalNumber+1
	..s ^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"VisitList",index)=Data
	Quit


	
OutputNormalList
	s index="" for  s index = $o(^TMP("DHCST","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,index)) q:index=""  d
	.s index2="" f   s index2=$o(^TMP("DHCST","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,index,index2),ListOrder) q:index2=""  d
	..s ^CacheTemp($LIST(qHandle,2),ind) = $g(^TMP("DHCST","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,index,index2))
	..s ind=ind+1
	q ""
OutputVisitList	
	;正在呼叫列表展示
	s index="" for  s index = $o(^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"DefaultListCalled",index)) q:index=""  d
	.s ^CacheTemp($LIST(qHandle,2),ind) = $g(^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"DefaultListCalled",index))
	.s ind=ind+1
	s index="" for  s index = $o(^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"VisitListCalled",index)) q:index=""  d
	.s ^CacheTemp($LIST(qHandle,2),ind) = $g(^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"VisitListCalled",index))
	.s ind=ind+1
	;待诊复诊按照配置显示
	s DefInex=0,VisitIndex=0
	f TableIndex=1:1:ListNormalNumber d
	.s IsShowVisitIndex = ((TableIndex-ThisLimitNum)#(LimitNum+1)=0)&&(TableIndex-ThisLimitNum'<0) ;是否是展现复诊数据
	.s IsShowVisit=""
	.s NextDefaultIndex=$o(^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"DefaultList",DefInex))
	.s:NextDefaultIndex="" IsShowVisit=1 		;如果非复诊患者列表已经输出完,输出复诊队列
	.i (IsShowVisitIndex)&&('IsShowVisit) d
	..s NextVisitIndex=$o(^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"VisitList",VisitIndex))
	..q:NextVisitIndex=""
	..s IsShowVisit=1
	.s ItmData=""
	.i IsShowVisit d
	..s VisitIndex=$o(^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"VisitList",VisitIndex))
	..s ItmData=^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"VisitList",VisitIndex)
	.i 'IsShowVisit d
	..s DefInex=$o(^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"DefaultList",DefInex))
	..s ItmData=^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"DefaultList",DefInex)
	.s ^CacheTemp($LIST(qHandle,2),ind) = ItmData
	.s ind=ind+1
	;过号列表展现
	s index="" for  s index = $o(^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"DefaultListSkip",index)) q:index=""  d
	.s ^CacheTemp($LIST(qHandle,2),ind) = $g(^TMP("DHCEM","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid,"DefaultListSkip",index))
	.s ind=ind+1
	q ""
}

/// Descript: 急诊病人查询:厦门翔安新增的界面
/// W ##Class(web.DHCEMDocMainOutPat).JSonQryEmMainPatList("30","1","^^^E^^^^N^^^^^203^11841^^0000000055^^^^")
ClassMethod JSonQryEmMainPatList(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params,%session)
	s End = page*rows
	s Start=(page-1)*rows+1
	s PatientNo=$p(params,"^",1)     /// 登记号
	s PatName=$p(params,"^",2)       /// 姓名
	s MedicalNo=$p(params,"^",3)     /// 病案号
	s PAADMType=$p(params,"^",4)     /// 就诊类型
	s CardNo=$p(params,"^",5)        /// 卡号
	s OutStartDate=$p(params,"^",6)  /// 起始日期    
	s OutEndDate=$p(params,"^",7)    /// 截止日期
	s OutArrivedQue=$p(params,"^",8) /// 已就诊
	s OutRegQue=$p(params,"^",9)     /// 未就诊
	s OutConsultation=$p(params,"^",10) ///
	s OutAllPatient=$p(params,"^",11)   /// 
	s AdmReqNo=$p(params,"^",12)        ///
	s LocID=$p(params,"^",13)  		    /// 科室
	s UserID=$p(params,"^",14) 		    /// 用户
	s EmPatLev=$p(params,"^",15) 	    /// 分级
	s TmpCondition=$p(params,"^",16)    ///登记号或者病人姓名
	s StayInWard=$p(params,"^",17)
	s ToArea=$p(params,"^",18)           /// 去向
	s PatListType=$p(params,"^",19)      /// 病人列表类型
	s TmpWardID=$p(params,"^",20)        /// 抢救/留观病区ID
	s CurCheckLev=$p(params,"^",21)      ///当前分级
	s CareDesc=$p(params,"^",22)         /// 号别 hxy 2018-06-22
    s DisHosp = $p(params,"^",23)   
    s ObsAdmLocID = $p(params,"^",24)
    s FilterPatID=""    ///是否按照人过滤
	i CardNo'="" d
	.s CFRowID = $o(^DHCCARDi("CF",0,"CardNo",$$ALPHAUP^SSUTIL4(CardNo),""),-1)
	.s:CFRowID'="" FilterPatID = $p(^DHCCARD("CF",CFRowID),"^",4)
	.s:CFRowID="" FilterPatID=0  ;如果输入的卡号不存在
	
 	Set result=##class(%Library.ResultSet).%New("web.DHCEMDocMainOutPat:QueryEmMainPatListA")
 	Set sc=result.Execute(PatientNo,PatName,MedicalNo,PatListType,CardNo,OutStartDate,OutEndDate,OutArrivedQue,OutRegQue,OutConsultation,OutAllPatient,AdmReqNo,LocID,UserID,"",StayInWard,DisHosp,ObsAdmLocID)
 	If $$$ISERR(sc) Quit ""
	
    Set colNum=result.GetColumnCount() //列数
    Set count = 0
    Set del=""""
 	Set tmp=""
 	Set TmpWardPatNum=""
 	Set EmPatLevTotal=0,EmPatLevCnt1=0,EmPatLevCnt2=0,EmPatLevCnt3=0,EmPatLevCnt4=0,EmPatLevNotCnt=0,EmPatLevWait=0,EmPatLevUnWait=0,EmPatLevStay=0,EmPatLevSalv=0
 	Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.s resultcode=result.GetColumnName(i)
		.s resultdesc=$P(result.%GetData(i),$C(13,10))
		.s:resultcode="PCLvArea" resultdesc=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patlist.csp",resultdesc)
		.s:resultcode="WalkStatus" resultdesc=##class(web.DHCEMCommonUtil).GetTrans("",resultdesc)
		.If ret="" Set ret=del_resultcode_del_":"_del_resultdesc_del
		.Else   Set ret=ret_","_del_resultcode_del_":"_del_resultdesc_del
		s PatientID=$P(result.%GetData(1),$C(13,10))
		s EpisodeID=$P(result.%GetData(2),$C(13,10))       
		s PatRegNo = $P(result.%GetData(4),$C(13,10))
		s PatName = $P(result.%GetData(5),$C(13,10))
		s PAAdmWard=$P(result.%GetData(15),$C(13,10))  			///当前病区 
		s WardDr=$P($g(^PAADM(EpisodeID)),"^",70)               /// 病区ID 
		s PatLocID=$p(^PAADM(EpisodeID),"^",4) //hxy 2020-06-08 st
		s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)  
		s LgHospID=$p($g(^CTLOC(+LocID)),"^",22)
		Continue:CurHospID'=LgHospID //ed
		Continue:(FilterPatID'="")&&(FilterPatID'=PatientID)
		Continue:(TmpCondition'=PatRegNo)&&(PatName'[TmpCondition)
		Continue:(PatListType'="Obs")&&(WardDr'="")
		Continue:(PatListType="Obs")&&(WardDr="")
		Set:PAAdmWard'="" TmpWardPatNum(PAAdmWard) = +$g(TmpWardPatNum(PAAdmWard))+1  
		Set WalkStatus=##Class(web.DHCEMDocMainOutPat).GetPatCurStat(EpisodeID)
		If WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)  //到达
		s IsWaitPat = ((WalkStatus="")||(WalkStatus["复诊"))
		s Compted = $p(^PAADM(EpisodeID,1),"^",23) 			   //界面处点击完成就诊按钮置标志
	
		i (WalkStatus["到达")&&(PAAdmWard="") s EmPatLevUnWait=EmPatLevUnWait+1
		i WalkStatus="" s EmPatLevWait=EmPatLevWait+1
		Continue:(OutArrivedQue="Y")&(IsWaitPat)
		Continue:(OutArrivedQue="N")&('IsWaitPat)
		Continue:(TmpWardID'="")&(WardDr'=TmpWardID)

		s NurseLevel=$P(result.%GetData(46),$C(13,10))     /// 分级
		s PAAdmPriority=$P(result.%GetData(29),$C(13,10))  /// 病人分级
		s CurCare=$P(result.%GetData(22),$C(13,10))  /// 号别 hxy 2018-06-22 st
		i CareDesc'="" Continue:CurCare'=CareDesc //hxy 2018-06-22
		Continue:(CurCheckLev'="")&&(CurCheckLev'=+PAAdmPriority)
		
		i PAAdmPriority'="" s NurseLevel=PAAdmPriority
		i NurseLevel'="" d
		.s EmPatLevTotal=EmPatLevTotal+1
		.s:NurseLevel="1级" EmPatLevCnt1=EmPatLevCnt1+1
		.s:NurseLevel="2级" EmPatLevCnt2=EmPatLevCnt2+1
		.s:NurseLevel="3级" EmPatLevCnt3=EmPatLevCnt3+1
		.s:(NurseLevel="4级")||(NurseLevel="5级") EmPatLevCnt4=EmPatLevCnt4+1
		E  s EmPatLevNotCnt=EmPatLevNotCnt+1

		Continue:(EmPatLev'="")&(EmPatLev'=NurseLevel)
	    s EmPCLvArea=$P(result.%GetData(49),$C(13,10))  /// 去向
		Continue:(ToArea'="")&(ToArea'=EmPCLvArea)
		Set count = count+1
		Continue:(count<Start)||(count>End)
		/// 滞留时间
		s StrTime="" 
		s ItmUnObr="" 
		s ItmUnObr="" 
		
		s ret=ret_","_del_"ItmXH"_del_":"_del_count_del_","_del_"StrTime"_del_":"_del_StrTime_del_","_del_"ItmUnObr"_del_":"_del_ItmUnObr_del
		
		If count=Start Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 } 
	 w "]"
	 w ","_del_"total"_del_":"_count
	  w ","_del_"EmPatLevTotal"_del_":"_EmPatLevTotal_","_del_"EmPatLevCnt1"_del_":"_EmPatLevCnt1
	 w ","_del_"EmPatLevCnt2"_del_":"_EmPatLevCnt2_","_del_"EmPatLevCnt3"_del_":"_EmPatLevCnt3
	 w ","_del_"EmPatLevCnt4"_del_":"_EmPatLevCnt4 //hxy 2020-02-21
	 w ","_del_"EmPatLevNotCnt"_del_":"_EmPatLevNotCnt_"}"
	 Do result.Close()
	 Quit ""
}

/// 获取患者状态
ClassMethod GetCallStatu(AdmID As %String) As %String
{
	s StsteDEsc=""
	s QueID=$O(^User.DHCQueueI("QuePaadmDrIndex",AdmID,0))
	if (+QueID'=0){
		s StsteDr=$List(^User.DHCQueueD(QueID),14)
	    s StsteDEsc=""
	    s:StsteDr'="" StsteDEsc=$List(^User.DHCPerStateD(StsteDr),4) ;队列状态
	}
	q StsteDEsc
}

/// 急诊医生过号重排
/// w ##class(web.DHCEMDocMainOutPat).PatPrior(50506946,6)
ClassMethod PatPrior(EpisodeID, UserID)
{
	n (EpisodeID,UserID)
	s QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
	q:QueRowId="" "-1"
	s UserID=$g(UserID)
	if UserID="" s UserID=%session.Get("LOGON.USERID")
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	&sql(select ID into :WaitStateID from dhcperstate where PersName='等候')
	q:SQLCODE'=0 SQLCODE
	&sql(update Dhcqueue set questatedr=:WaitStateID,QueStateDate=:CurDate,QueStateTime=:CurTime,Operuserid=:UserID where Id=:QueRowId)
	q SQLCODE
}

ClassMethod QueryEmDocMainPatListAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEmDocMainPatListAExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QueryEmDocMainPatListAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEmDocMainPatListAExecute ]
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

/// Descript: 根据限制查询天数计算开始日期
ClassMethod GetLimirDay(Data, Limit) As %String
{
	q:Data="" ""
	q:Limit="" Data
	if Data["-" Set Data=$zdh(Data,3)
	s Data=Data-Limit
	s Data=$zd(Data,3)
	q Data
}

/// Descript: 重复呼叫
ClassMethod SendReCallInfo(UserId As %String)
{
	n (UserId)
	///调用叫号公司提供的webservice
	s DocRowid=$p($g(^SSU("SSUSR",UserId)),"^",14)
	Q:DocRowid="" "-1^医生不存在"
	s DocCode=$p(^CTPCP(DocRowid,1),"^",1)
	s CallServiceObj=##class(DHCDocCallService.HtOutpIndexManagerPort).%New()
	s ret=CallServiceObj.recall(DocCode)   //ret 为json串的格式
	s retFlag=$p($p(ret,"""flag"":",2),",",1)
	s AdmRowid=$p($p(ret,"""visitNo"":",2),",",1)
	if AdmRowid=""{
		//Quit "-1^没有需要呼叫的病人信息"_ret
		Quit "-1^没有需要呼叫的病人信息"
	}
	
	if retFlag="false"{
		Quit "-1^重复呼叫病人失败"	
	}
	
	s PatientId=$p(^PAADM(AdmRowid),"^",1)
	s PatietnNo=$p(^PAPER(PatientId,"PAT",1),"^",1)
	s PatName=$p(^PAPER(PatientId,"ALL"),"^",1)
    s QueRowId=$o(^User.DHCQueueI("QuePaadmDrIndex",AdmRowid,0))
	s SeqNo="",QueStatDesc=""
	if QueRowId'=""{
		s SeqNo=$lg(^User.DHCQueueD(QueRowId),10)
		s QueStatId=$lg(^User.DHCQueueD(QueRowId),14)
		s QueStatDesc=$lg(^User.DHCPerStateD(QueStatId),4)
	}
	if QueStatDesc="复诊"{
		 s retStr="正在重复呼叫复诊"_" "_SeqNo_"号"_" "_PatName
	}else{
		s retStr="正在重复呼叫"_" "_SeqNo_"号"_" "_PatName	
	}
	Quit 0_"^"_retStr
}

/// Descript: 判读当前用户是否有指定操作的权限
/// W ##Class(web.DHCEMDocMainOutPat).GetEmPatStatusAcc("13","46","Stay")
ClassMethod GetEmPatStatusAcc(userid As %String, GroupID As %String, AuthCode As %String) As %String
{
	n (userid, GroupID, AuthCode)

	s quitflag=0
	/// 按用户
	s EmPSAId=""  
	f  s EmPSAId=$o(^DHCEMPSA(0,"TYPE","U",userid,EmPSAId)) Q:(EmPSAId="")||(quitflag=1)  d
	.Q:'$d(^DHCEMPSA(EmPSAId))
	.s Parf=$p(^DHCEMPSA(EmPSAId),"^",1)
	.q:+Parf=0
	.s Code=$p(^DHCPACVisitStatus(Parf),"^",1)
	.Q:Code'=AuthCode
	.s quitflag=1
	
	Q:quitflag=1 quitflag
	/// 按安全组
	s EmPSAId=""  
	f  s EmPSAId=$o(^DHCEMPSA(0,"TYPE","G",GroupID,EmPSAId)) Q:(EmPSAId="")||(quitflag=1)  d
	.Q:'$d(^DHCEMPSA(EmPSAId))
	.s Parf=$p(^DHCEMPSA(EmPSAId),"^",1)
	.q:+Parf=0
	.s Code=$p(^DHCPACVisitStatus(Parf),"^",1)
	.Q:Code'=AuthCode
	.s quitflag=1
	Q quitflag
}

/// Descript: 获取病人预检分级
/// W ##Class(web.DHCEMDocMainOutPat).GetEmPatCheckLev("")
ClassMethod GetEmPatCheckLev(EpisodeID) As %String
{
	n (EpisodeID)
	s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""),-1)
	Q:EmPCLvID="" ""
	s EmNurLev=$p(^DHCEMPCL(EmPCLvID),"^",7) /// 护士分级
	Q EmNurLev_"级"
}

/// Descript: 获取病人预检分级绿色通道
/// W ##Class(web.DHCEMDocMainOutPat).GetEmPatGreenFlag("")
ClassMethod GetEmPatGreenFlag(EpisodeID, EmPCLvID = "") As %String
{
	n (EpisodeID,EmPCLvID)
	//s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""),-1)
	//Q:EmPCLvID="" ""
	//s EmPatGreFlag=##Class(web.DHCEMPatCheckLev).GetEmPatGreenFlag(EmPCLvID,EpisodeID) /// 绿色通道标示
	s EmPatGreFlag=##class(web.DHCEMPatGreenRec).checkGreenRec(EpisodeID,EmPCLvID)  ///zhouxin 2018-07-18
	s EmPatGreFlag=$s(EmPatGreFlag=1:"是",1:"")
	Q EmPatGreFlag
}

/// Descript: 获取病人预检分级去向
/// W ##Class(web.DHCEMDocMainOutPat).GetEmPCLvArea("")
ClassMethod GetEmPCLvArea(EpisodeID) As %String
{
	n (EpisodeID)
	s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""),-1)
	Q:EmPCLvID="" ""
	s PCLvArea=$p(^DHCEMPCL(EmPCLvID),"^",7)  		///分级
	s PCLvArea=$s(PCLvArea=1:"红区",PCLvArea=2:"橙区",PCLvArea=3:"黄区",PCLvArea=4:"绿区",1:"")
	Q PCLvArea
}

/// Descript: 获取病人预检分级护士
/// W ##Class(web.DHCEMDocMainOutPat).GetEmPCLvNurse("")
ClassMethod GetEmPCLvNurse(EpisodeID) As %String
{
	n (EpisodeID)
	s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""),-1)
	Q:EmPCLvID="" ""
	s UserID=$p(^DHCEMPCL(EmPCLvID),"^",3)  		/// 分诊人员
	i UserID'="" s UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)
	Q $g(UserName)
}

/// Descript: 设置病人状态为到达
/// W ##Class(web.DHCEMDocMainOutPat).SetArrivedStatus("667","163","6")
ClassMethod SetArrivedStatusBak(EpisodeID As %String, LocID As %String, UserID As %String) As %String
{
	n (EpisodeID, LocID, UserID)
	s DoctorId=$p($g(^SSU("SSUSR",UserID)),"^",14)
	Q:DoctorId="" "-1"
	//s Err=##Class(web.DHCDocOutPatientList).SetArrivedStatus(EpisodeID, DoctorId, LocID, UserID)
	s Err=##Class(web.DHCDocEmergencyPatientList).SetArrivedStatus(EpisodeID, DoctorId, LocID, UserID)
	Q Err
}

/// Descript: 急诊病人列表留观复选框列表
/// W ##Class(web.DHCEMDocMainOutPat).jsonWard(2)	
ClassMethod jsonWard(HospID As %String, TmpArr As %String) As %String
{
	n (HospID, TmpArr,%session)
	s WardID=0 
	F  s WardID=$o(^PAWARD(WardID)) Q:(+WardID=0)  D
    .Q:$p(^PAWARD(WardID),"^",6)'="Y"
    .s WardDesc=$p($g(^PAWARD(WardID)),"^",2)
    .s LocID=$p(^PAWARD(WardID),"^",5)
    .Q:LocID=""
    .Q:$p(^CTLOC(LocID),"^",13)'="EM"
    .Q:$p(^CTLOC(LocID),"^",14)'="Y"
    .Q:'$o(^PAWARD(WardID,"ROOM",0))
    .Q:$p(^CTLOC(LocID),"^",22)'=HospID
    .s DateFrom=$P(^PAWARD(WardID),"^",7)
 	.s DateTo=$P(^PAWARD(WardID),"^",9)
 	.Q:((+$h<DateFrom)&&(DateFrom'=""))!((+$h>DateTo)&&(DateTo'=""))
	.s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
 	.S WardDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",WardDesc)
	.s TmpArr(WardID)=WardDesc
	Q ""
}

/// Descript: 急诊病人列表留观复选框列表
/// W ##Class(web.DHCEMDocMainOutPat).jsonListWard(2)	
ClassMethod jsonListWard(HospID As %String) As %String
{
	n (HospID,%session)
	s Count=0
	w "["
	s WardID=0 
	F  s WardID=$o(^PAWARD(WardID)) Q:(+WardID=0)  D
    .Q:$p(^PAWARD(WardID),"^",6)'="Y"
    .s WardDesc=$p($g(^PAWARD(WardID)),"^",2)
    .s LocID=$p(^PAWARD(WardID),"^",5)
    .Q:LocID=""
    .Q:$p(^CTLOC(LocID),"^",13)'="EM"
    .Q:$p(^CTLOC(LocID),"^",14)'="Y"
    .Q:'$o(^PAWARD(WardID,"ROOM",0))
    .;Q:$p(^CTLOC(LocID),"^",22)'=HospID //hxy 2020-05-27 注释
    .q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",LocID,HospID)'="Y" //hxy 2020-05-27
    .s DateFrom=$P(^PAWARD(WardID),"^",7)
 	.s DateTo=$P(^PAWARD(WardID),"^",9)
 	.Q:((+$h<DateFrom)&&(DateFrom'=""))!((+$h>DateTo)&&(DateTo'=""))
	.s WardDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",WardDesc)
	.s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	.s Data = WardID_"^"_WardDesc
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Data)
	w "]"
	Q ""
}

/// 过号
ClassMethod SetSkipStatus(Adm As %String, LgUserID As %String) As %Status
{
	n (Adm, LgUserID, %session)
	
	s DocDr=$p($g(^SSU("SSUSR",LgUserID)),"^",14)
	Q:DocDr="" "-1"
	
	Set sc=0
	Quit:$g(Adm)="" sc
	;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",Adm,""))
	Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(Adm,DocDr)
	If QueRowId'="" Do
	.Set oref=##Class(User.DHCQueue).%OpenId(QueRowId)
	.Set Status=oref.QueStateDr.PersName
	.Set PAAdmPriority=oref.QueFirstDr.FirstcName
	.Quit:PAAdmPriority="优先"
	.Set called=oref.QueCompDr
	.Quit:called=""
	.If (Status="复诊")!(Status="等候")!(Status="过号") Do
	..Set QueDoc=oref.QueDocDrGetObjectId()
	..Quit:QueDoc=""
	..Quit:(QueDoc'="")&(QueDoc'=DocDr)
	..Do oref.QueRoomDrSetObjectId("")
	..&sql(SELECT ID into :PerStateDr FROM sqluser.dhcPerstate where persname='过号')
	..Do oref.QueStateDrSetObjectId(PerStateDr)
	..Do oref.QueDocDrSetObjectId("")
	..Set oref.QueCompDr=""
	..Set oref.QueStateDate=+$h
	..Set oref.QueStateTime=$p($h,",",2)
	..Set sc = oref.%Save()
 	.Do oref.%Close()
 	b ;data
 	i $G(UserId)="" s UserId=%session.Get("LOGON.USERID")
	i (UserId'="")&&($G(PAAdmPriority)'="优先") d
	.i $G(^DHCDocCall(+$h,UserId))="" s ^DHCDocCall(+$h,UserId)=0
	.s ^DHCDocCall(+$h,UserId)=$I(^DHCDocCall(+$h,UserId))
 	Quit sc
}

/// QQA
/// 设置呼叫状态
ClassMethod SetPatCallStatu(AdmID As %String, UserID As %String) As %String
{
  
	s QueID=$O(^User.DHCQueueI("QuePaadmDrIndex",AdmID,0))
	if (+QueID'=0){
		s Docid=$P($G(^SSU("SSUSR",UserID)),"^",14)
		s Comp=1
		s Wid=""
		&sql(select ID into :Wid from dhcperstate where PersName='等候')
		
		;获取医生站设置诊室IP对照
		s roomdr=""
		s IP=##class(web.DHCDocOutPatientList).GetIPAndName()
		s ID=+$O(^User.DHCRoomCompI("RoomcIpIndex"," "_IP,0))
		if ID'=0  d
		.s roomdr=$listget(^User.DHCRoomCompD(ID),5)
		
		s StsteDr=$List(^User.DHCQueueD(QueID),14)
	    s StsteDEsc=""
	    s:StsteDr'="" StsteDEsc=$List(^User.DHCPerStateD(StsteDr),4) ;队列状态
	    if (StsteDEsc["过号")&&(Wid'="") s StsteDr=Wid
		&sql(Update SQLUser.DHCQueue set QueCompDr=:Comp,QueDocDr=:Docid,QueStateDr=:StsteDr,QueRoomDr=:roomdr where ID=:QueID)
		Q:SQLCODE'=0 "-1^"_SQLCODE
	}else{
		q "-1^不存在队列"
	}
	q "0"
}

/// Descipt:翔安新增的急诊病人查询界面
/// d ##class(%ResultSet).RunQuery("web.DHCDocMainOut","FindCurrentAdmProxy","","","","","O","","2016-08-18","2016-11-26","","","","")
/// d ##class(%ResultSet).RunQuery("web.DHCEMDocMainOutPat","QueryEmDocMainPatListA","","","","O","","2016-08-18","2016-11-26","","","","","","308","2874")
Query QueryEmMainPatListA(PatientNo As %String, PatName As %String, MedicalNo As %String, PatListType As %String, CardNo As %String, StartDate As %Date, EndDate As %Date, OutArrivedQue As %String, OutRegQue As %String, OutConsultation As %String, OutAllPatient As %String, AdmReqNo As %String, LocID As %String, UserID As %String, TmpCondition As %String, StayInWard As %String, AdmVisitStatus As %String, ObsAdmLocID = "") As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PatNo:%String,PatName:%String,PatBDay:%String,PatSex:%String,PAAdmDate:%String,PAAdmTime:%Time,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String,DischargeDate:%String,RegDoctor:%String,Diagnosis:%String,ArrivedDate:%String,ArrivedTime:%String,LeavedDate:%String,LeavedTime:%String,LocSeqNo:%String,PAAdmPriority:%String,WalkStatus:%String,ConsultRoom:%String,ConsultArea:%String,PAAdmReasonCode:%String,StatusCode:%String,PatAge:%String,PriorityCode:%String,Called:%String,RegDocDr:%String,IconProfile:%String,Arrived:%String,1,2,3,PatCardBal:%String,BillType:%String,PatLevel:%String,CardNo:%String,PatGreFlag:%String,PCLvArea:%String,PCLvNurse:%String,PriorityColor:%String")
{
}

ClassMethod QueryEmMainPatListAExecute(ByRef qHandle As %Binary, PatientNo As %String, PatName As %String, MedicalNo As %String, PatListType As %String, CardNo As %String, StartDate As %Date, EndDate As %Date, OutArrivedQue As %String, OutRegQue As %String, OutConsultation As %String, OutAllPatient As %String, AdmReqNo As %String, LocID As %String, UserID As %String, TmpCondition As %String, StayInWard As %String, AdmVisitStatus As %String, ObsAdmLocID = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s StartTime=""                         //遍历的时候查询的开始时间
    i (StartDate="")&&(TmpCondition="") d  //日期的设置
    .s StartDate=+$H-1    
    .s StartTime = $p($H,",",2)
	i (EndDate="")&&(TmpCondition="") s EndDate=+$H    //结束日期
	Set:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate) /// 开始日期
	Set:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate) /// 开始日期
	Set NumCount = 0
	s DocId=$p($g(^SSU("SSUSR",UserID)),"^",14) 	 /// 医生ID 
	
	///统计已诊断的病人
	i (PatListType="Obs") d
	.s LocID=0
	.f  s LocID= $o(^PAADMi("AdmTypeCurrLoc","E",LocID)) q:LocID=""  d
	..q:(ObsAdmLocID'="")&&(LocID'=ObsAdmLocID)
	..d OutOneLocDiagedPat
	i (PatListType'="Obs") d
	.d OutOneLocDiagedPat
	.d OutOneLocNoAdmPat

	///统计留观室离院的病人
	For Date=StartDate:1:EndDate Do
	.Set Time=""  
	.For  Set Time=$O(^PAADMi("TypeDate","E",Date,Time)) Quit:(Time="")  Do
	..Set EpisodeID=0
	..For  Set EpisodeID=$O(^PAADMi("TypeDate","E",Date,Time,EpisodeID)) Quit:(EpisodeID="")  Do
	...s AdmLocID=$p(^PAADM(EpisodeID),"^",4) 	/// 科室
	...q:(ObsAdmLocID'="")&&(AdmLocID'=ObsAdmLocID)
	...s ADMVisitStatusDr = $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1) 	//获取就诊下最后一次的状态
	...s PACVisitStatusDr=$p($g(^DHCADMVisitStatus(+ADMVisitStatusDr)),"^",2)
	...q:PACVisitStatusDr'=6              //最后一次不是离院
	...Do OutputRowNoDoc
	
	
	/// 输出病人列表信息
	s index="" for  s index = $o(^TMP("DHCST","web.DHCEMDocMainOutPat","QueryEmMainPatList",pid,index)) q:index=""  d
	.s index2="" f   s index2=$o(^TMP("DHCST","web.DHCEMDocMainOutPat","QueryEmMainPatList",pid,index,index2)) q:index2=""  d
	..s ^CacheTemp($LIST(qHandle,2),ind) = $g(^TMP("DHCST","web.DHCEMDocMainOutPat","QueryEmMainPatList",pid,index,index2))
	..s ind=ind+1
	
	d ..killTmpGlobal(pid) //k掉临时global

	Quit $$$OK

OutOneLocNoAdmPat
	/// 统计未诊断的病人
	s QueStateDr=""
	For Date=StartDate:1:EndDate Do
	.q:(PatListType="Obs")	;留观患者在已诊里面
	.Set Time=""
	.For  Set Time=$O(^PAADMi("CurrLoc",LocID,Date,Time)) Quit:(Time="")  Do
	..Set EpisodeID=""
	..For  Set EpisodeID=$O(^PAADMi("CurrLoc",LocID,Date,Time,EpisodeID)) Quit:(EpisodeID="")  Do
	...
	...Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(EpisodeID,DocId)
	...Q:QueRowId=""
	...if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	...s StateDesc=""
	...if QueStateDr'="" Set StateDesc=$List(^User.DHCPerStateD(QueStateDr),4)
	...Q:StateDesc="报到"
	...Set Include=""
	...Set QueMarkId=$List(^User.DHCQueueD(QueRowId),8)
	...Set:QueMarkId'="" Include=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,QueMarkId,""))
	...Quit:(Include="")&(PatListType="Per")
	...Set PatPMI=$P($g(^PAADM(EpisodeID)),"^",1)
	...Quit:PatPMI=""
	...Set CurStat=##Class(web.DHCEMDocMainOutPat).GetPatCurStat(EpisodeID)
	...Set WalkStatus=CurStat
	...If CurStat'="" Set CurStat=$P(CurStat,"^",1)
	...If WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
	...Quit:WalkStatus="到达"
	...s DoctorId=$P($g(^PAADM(EpisodeID)),"^",9)   ///主管医生
	...s UnitFlag=""   /// 医疗组
	...s:(PatListType="Grp") UnitFlag=##Class(EMRservice.DAL.GetPaAdmDetail).CheckCTLocMedUnit(DoctorId,DocId,LocID)
	...q:(PatListType="Grp")&(UnitFlag'=1)
	...Do OutputRowNoDoc
	Quit

OutOneLocDiagedPat
	///统计已诊断的病人
	For Date=StartDate:1:EndDate  Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time)) Quit:Time=""  Do
	..Set EpisodeID=0
	..For  Set EpisodeID=$O(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time,EpisodeID)) Quit:EpisodeID=""  Do
	...Set AdmDoctor=$P($g(^PAADM(EpisodeID)),"^",9)
	...Set AdmSeenDate=$P($g(^PAADM(EpisodeID),1),"^",10)
	...Set AdmSeenTime=$P($g(^PAADM(EpisodeID),1),"^",11)
	...Set WalkStatus=##Class(web.DHCEMDocMainOutPat).GetPatCurStat(EpisodeID)
	...If WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)  //到达
	...Set PatQueState=""
	...Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
	...If QueRowId'="" Do
	....Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId,0)
	....Set StatusName=QueObj.QueStateDr.PersName   //状态2
	....Set QueDocId=QueObj.QueDocDrGetObjectId()
	....Set QueMarkId=QueObj.QueMarkDrGetObjectId()
	....s Include=""
	....Set:QueMarkId'="" Include=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,QueMarkId,""))
	....Set IsCESFlag=##Class(DHCDoc.Interface.StandAlone.Service).IsCESFlag("pa_adm",EpisodeID)
	....Quit:(QueDocId'=DocId)&(PatListType="Per")&&(IsCESFlag'=1)
	....If WalkStatus["到达" Set PatQueState="A"
	....s DoctorId=$P($g(^PAADM(EpisodeID)),"^",9)   ///主管医生
	....s UnitFlag=""   /// 医疗组
	....s:(PatListType="Grp") UnitFlag=##Class(EMRservice.DAL.GetPaAdmDetail).CheckCTLocMedUnit(DoctorId,DocId,LocID)
	....q:(PatListType="Grp")&(UnitFlag'=1)&&(IsCESFlag'=1)
	....Do QueObj.%Close()
	....Quit:(PatQueState="")
	....Do OutputRowNoDoc
	Quit

OutputRowNoDoc
    /// 病人就诊信息
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s AdmStatus = $P(^PAADM(EpisodeID),"^",20)
	q:AdmVisitStatus'[AdmStatus
	s mradm=$P(^PAADM(EpisodeID),"^",61) 
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)       //姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)       //登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)         //姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)       //出生日期
	i PatBDay'="" s PatBDay=$zd(PatBDay,3)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	s PAAdCacheDate=$P($g(^PAADM(EpisodeID)),"^",6)
	s PAAdCacheTime=$P($g(^PAADM(EpisodeID)),"^",7)
	s PAAdmDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PAAdCacheDate)  //就诊日期
	s PAAdmTime=$ZT(PAAdCacheTime,2)  //就诊时间
	s Deposit=##class(web.UDHCJFBaseCommon).deposit(EpisodeID) // 患者未结算押金总额
	s PAAdmNo=$P($g(^PAADM(EpisodeID)),"^",81)          
	s Loc=$P($g(^PAADM(EpisodeID)),"^",4)
	s PAAdmDepCodeDR=$P($g(^CTLOC(Loc)),"^",2)
	i PAAdmDepCodeDR["-" s PAAdmDepCodeDR=$p(PAAdmDepCodeDR,"-",2)
	s Doctor=$P($g(^PAADM(EpisodeID)),"^",9)
	I Doctor'="" s PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	E  s PAAdmDocCodeDR=""
	s PAAdmType=$P($g(^PAADM(EpisodeID)),"^",2)
	s PAAdmWard=""
	s WardDr=$P($g(^PAADM(EpisodeID)),"^",70)                                    /// 
	i WardDr'="" s PAAdmWard=$P($g(^PAWARD(WardDr)),"^",2)
	s PAAdmWard=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",PAAdmWard)                       /// 病区
	s:PAAdmWard["-" PAAdmWard=$p(PAAdmWard,"-",2)
	s BedId=$P($g(^PAADM(EpisodeID)),"^",73)
	I BedId'="" s PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)  /// 床号
	E  s PAAdmBed="" 
	s QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
	s QueObj=##Class(User.DHCQueue).%OpenId(QueRowId,0)
	s RegDocCode="", RegDoctor="",RegDocDr="",Called=""
	i QueObj'="" d
	.s QueDocId=QueObj.QueDocDrGetObjectId()
	.s QueMarkId=QueObj.QueMarkDrGetObjectId()
	.s:QueMarkId'="" Include=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,QueMarkId,""))	///医生号别对照
	.s Called=QueObj.QueCompDr
	.s:QueMarkId'="" RegDocDr=QueObj.QueMarkDr.%Id()
	.i RegDocDr'="" D
	..Set RegDoctor=$P($g(^CTPCP(RegDocDr,1)),"^",2)
	..Set RegDocCode=$P($g(^CTPCP(RegDocDr,1)),"^",1)
	s FinancialDischargeFlag=$P($g(^PAADM(EpisodeID)),"^",45)
	s MedicalDischargeFlag=$P($g(^PAADM(EpisodeID)),"^",63)
	s PAAdmStatus=$P($g(^PAADM(EpisodeID)),"^",20)
	s FinalDischargeFlag=$S($g(PAAdmStatus)="D":"Y",1:"N")
	s AdmReason=$P($g(^PAADM(EpisodeID,1)),"^",7)
	I AdmReason'="" s PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	E  s PAAdmReason="",PAAdmReasonCode=""
	s DischargeDate=$P($g(^PAADM(EpisodeID)),"^",17)
	s:DischargeDate'="" DischargeDate=$zd(DischargeDate,3)                /// 出院时间
	s Diagnosis=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID,"","") ;##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm) /// 诊断
	s Seq=EpisodeID
	s PatientMedicare=##Class(web.DHCEMCommonUtil).GetMrNo(EpisodeID)     //病案号
	s LocSeqNo=""
	&SQL(SELECT ID into :RegId FROM SQLUser.DHCRegistrationFee Where RegfeeAdmDr=:EpisodeID)
	i RegId'="" d
	.s LocSeqNo=$List(^User.DHCRegistrationFeeD(RegId),8)
	s IconProfile=""
	s Arrived=""
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)                        /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s WalkStatus=##Class(web.DHCEMDocMainOutPat).GetPatCurStat(EpisodeID)
	i WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
	s AvsID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	s PvsID="",PvStatus=""
	s:AvsID'="" PvsID=$P(^DHCADMVisitStatus(AvsID),"^",2)
   	s:PvsID'="" PvStatus=$p(^DHCPACVisitStatus(PvsID),"^",2)
	s:WalkStatus'="复诊" WalkStatus=PvStatus
	s:WalkStatus="" WalkStatus="等候"
	s PatCardMoney="" //##Class(web.DHCAPPPrintCom).GetPatCardMoney(PatientID) 	    /// 获取卡余额
	s CardNo="" //##Class(web.DHCAPPPrintCom).GetCardNoByRegNo(PatientID)  	        /// 获取卡号
	s EmNurLev=##Class(web.DHCEMDocMainOutPat).GetEmPatCheckLev(EpisodeID)      /// 分级
	s EmPatGreFlag=##Class(web.DHCEMDocMainOutPat).GetEmPatGreenFlag(EpisodeID) /// 绿色通道标示
	s EmPCLvArea=##Class(web.DHCEMDocMainOutPat).GetEmPCLvArea(EpisodeID)       /// 分级去向
	s EmPCLvNurse=##Class(web.DHCEMDocMainOutPat).GetEmPCLvNurse(EpisodeID)     /// 分级护士
	s PAAdmPriority="",PriorityCode="",PriorityColor=""                         /// 优先级、优先级代码、背景色
	s Priority=$P($g(^PAADM(EpisodeID)),"^",33)
	s PriorityColor=""
	i Priority'="" s PAAdmPriority=$p($g(^CT("ACU",Priority)),"^",1),PriorityCode=+$p($g(^CT("ACU",Priority)),"^",1),PriorityColor=$p($g(^CT("ACU",Priority)),"^",11)
	s:Priority="" Priority=5                                                    /// 排序字段为空设置为5
	s EmPCLvArea=$s(PAAdmPriority="1级":"红区",PAAdmPriority="2级":"橙区",PAAdmPriority="3级":"黄区",PAAdmPriority="4级":"绿区",PAAdmPriority="5级":"绿区",1:EmPCLvArea)
	;s WalkStatus=##Class(web.DHCEMDocMainOutPat).GetPatCurStat(EpisodeID)          /// 当前状态
	;i WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
	/// 多语言修改	
	
	S PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	S RegDoctor=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",RegDoctor)
	S PAAdmDepCodeDR=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",PAAdmDepCodeDR)
	S PAAdmDocCodeDR=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",PAAdmDocCodeDR)
	S EmPCLvNurse=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",EmPCLvNurse)
	S Diagnosis=##class(web.DHCEMCommonUtil).GetTransDesc("User.MRCICDDx","MRCIDDesc","",Diagnosis)
	S BillType=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSocialStatus","SSDesc","",BillType)
	s NumCount=NumCount+1
	s OrderStr = PAAdCacheDate_"^"_PAAdCacheTime
	s index=NumCount
	s Data=$LB(PatientID,EpisodeID,mradm,PatNo,PatName,PatBDay,PatSex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,"",PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PatAge,PriorityCode,Called,RegDocDr,PatientMedicare,"",IconProfile,Arrived,"",PatCardMoney,BillType,EmNurLev,CardNo,EmPatGreFlag,EmPCLvArea,EmPCLvNurse,PriorityColor)
	s ^TMP("DHCST","web.DHCEMDocMainOutPat","QueryEmMainPatList",pid,OrderStr,index)=Data
	Quit
}

ClassMethod QueryEmMainPatListAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEmMainPatListAExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QueryEmMainPatListAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEmDocMainPatListAExecute ]
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

/// 空/到达/复诊
/// w ##Class(web.DHCEMDocMainOutPat).GetPatCurStat(4259)
ClassMethod GetPatCurStat(EpisodeID = "") As %String
{
	n (EpisodeID)
	
	s AdmWardId=$P($g(^PAADM(EpisodeID)),"^",70)
	q:+AdmWardId'=0 "^到达"
	
	s QueState=""
	s QueRowId=$o(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
	i QueRowId'="" d
	.s Oref=##Class(User.DHCQueue).%OpenId(QueRowId,0)
	.s QueStateDr=Oref.QueStateDrGetObjectId()
	.s QueState=$lg(^User.DHCPerStateD(QueStateDr),4)
	.;s ^qqa("QueState")=^User.DHCPerStateD(QueStateDr)
	q:QueState="复诊" "^复诊"
	
	;i EpisodeID="" q ""
	;s Compted="",WalkStatus=""
	;s AvsID=""
	;f  s AvsID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,AvsID)) q:(AvsID="")||(Compted'="")  d
	;.s PvsID=$P(^DHCADMVisitStatus(AvsID),"^",2)
   	;.s WalkStatus=$p(^DHCPACVisitStatus(PvsID),"^",1,2)
   	;.s:WalkStatus["到达" Compted="Y"
   	;q:(Compted="Y")&&(QueState["过号") "^复诊"
	s Compted=""
	s:QueState="到达" Compted="Y"
	s:Compted="" Compted = $p(^PAADM(EpisodeID,1),"^",23) 	
	q:Compted="Y" "^到达"    //点击完成就诊
	
	q ""
}

ClassMethod GetPatStat(EpisodeID = "") As %String
{
	n (EpisodeID)
	s AdmWardId=$p(^PAADM(EpisodeID),"^",70)
	
	s QueState="",QueShowState=""
	s QueRowId=$o(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
	i QueRowId'="" d
	.s Oref=##Class(User.DHCQueue).%OpenId(QueRowId,0)
	.s QueStateDr=Oref.QueStateDrGetObjectId()
	.s QueState=$lg(^User.DHCPerStateD(QueStateDr),4)
	.s QueShowState=$lg(^User.DHCPerStateD(QueStateDr),6)
	.;s ^qqa("QueState")=^User.DHCPerStateD(QueStateDr)
	q:(QueState="复诊")&&(+AdmWardId=0) "^"_QueShowState
	
	s WalkStatus=""
	s AvsID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	i AvsID'="" d
	.s PvsID=$P(^DHCADMVisitStatus(AvsID),"^",2)
   	.s WalkStatus=$p(^DHCPACVisitStatus(PvsID),"^",1,2)
	s Compted = $p(^PAADM(EpisodeID,1),"^",23) 	
	s:(Compted="Y")&&(WalkStatus="") WalkStatus="^到达"    //点击完成就诊
	q WalkStatus
}

ClassMethod GetObsPatStat(EpisodeID = "")
{
	n (EpisodeID)
	s WalkStatus=""
	s AvsID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	i AvsID'="" d
	.s PvsID=$P(^DHCADMVisitStatus(AvsID),"^",2)
   	.s WalkStatus=$p(^DHCPACVisitStatus(PvsID),"^",1,2)
   	q WalkStatus
}

/// 判断护理级别Up or Down
/// w ##Class(web.DHCEMDocMainOutPat).GetCareLevelUpOrDown("142261938")
ClassMethod GetCareLevelUpOrDown(EpisodeID)
{
	n (EpisodeID)
	k TMP("GetCareLevelUpOrDown")
	s ret=0
	s CurCareLevel=..GetCareLevel(EpisodeID,+$h)
	q:CurCareLevel="" ret
	s AdmDate=$p(^PAADM(EpisodeID),"^",6)
	q:AdmDate="" ret
	s CareLevel=""
	for date=+$h:-1:AdmDate{
		q:$g(TMP("GetCareLevelUpOrDown",EpisodeID))'=""
		s CareLevel=..GetCareLevel(EpisodeID,date)
		continue:CareLevel=""
		if CareLevel'=CurCareLevel{
			s TMP("GetCareLevelUpOrDown",EpisodeID)=CareLevel
		}
	}
	s CareLevel=$g(TMP("GetCareLevelUpOrDown",EpisodeID))
	q:CareLevel="" ret
	if CurCareLevel<CareLevel s ret=1
	if CurCareLevel>CareLevel s ret=-1
	q ret
}

/// Creator: 		bianshuai
/// CreatDate: 		2019-02-20
/// Description: 	获取病人护理级别
/// Input：			EpisodeID-就诊号
/// Return：		护理级别
/// Other           w ##Class(web.DHCEMDocMainOutPat).getCareLevel("1")
ClassMethod GetCareLevel(EpisodeID, Date)
{
	n (EpisodeID,Date)
	s tjhl=..IfOrddailyExistByConfig(EpisodeID,Date,"CRITICALCARE")
	Q:tjhl=1 "0"
	s yjhl=..IfOrddailyExistByConfig(EpisodeID,Date,"FIRSTCLSCARE")
	Q:yjhl=1 "1"
	s ejhl=..IfOrddailyExistByConfig(EpisodeID,Date,"SECONDCLSCARE")
	Q:ejhl=1 "2"
	s sjhl=..IfOrddailyExistByConfig(EpisodeID,Date,"THIRDCLSCARE")
	Q:sjhl=1 "3"
	Q ""
}

/// Creator: 		bianshuai
/// CreatDate: 		2019-02-20
/// Description: 	指定日期内是否存在配置医嘱
/// Input：			EpisodeID-就诊号
/// Return：		1-是，0-否
/// Other           w ##Class(web.DHCEMDocMainOutPat).getCareLevel("1")
ClassMethod IfOrddailyExistByConfig(EpisodeID, Date, Code) As %String
{
	n (EpisodeID, Date,Code)
	s arcimCodes=##class(Nur.ImageSet).GetArcCode(Code)
	Q:arcimCodes="" 0
	Q ..IfOrddailyExist(EpisodeID,Date,arcimCodes,"true")
}

/// Creator: 		bianshuai
/// CreatDate: 		2019-02-20
/// Description: 	病人是否存在指定医嘱
/// Input：			EpisodeID-就诊号
/// Return：		1-是，0-否
/// Other           w ##Class(web.DHCEMDocMainOutPat).getCareLevel("1")
ClassMethod IfOrddailyExist(EpisodeID, Date, ArcimCodes, TransFlag = "") As %String
{
	n (EpisodeID, Date,ArcimCodes, TransFlag)
	s delim="^"
	i $l(ArcimCodes,"!!")>1 s delim="!!"
 	i $l(ArcimCodes,"^")>1 s delim="^"
 	s num=$l(ArcimCodes,delim)
	s ret=0
	F i=1:1:num Q:ret=1  D
	.s code=$p(ArcimCodes,delim,i)
	.Q:code=""
	.s rowidm=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	.Q:rowidm=""
	.s rowid=rowidm_"||"_"1"
	.s ret=..GetCareType(EpisodeID, Date, rowid, TransFlag)
	Q ret
}

/// Creator: 		bianshuai
/// CreatDate: 		2019-02-20
/// Description: 	病人本次就诊是否有指定医嘱
/// Input：			EpisodeID-就诊号
/// Return：		1-是，0-否
/// Other           w ##Class(web.DHCEMDocMainOutPat).getCareLevel("1")
ClassMethod GetCareType(EpisodeID, Date, ArcimIdStr, TransFlag = "") As %String
{
	n (EpisodeID,Date,ArcimIdStr,TransFlag)
	s EpisodeID=$g(EpisodeID)
	s ArcimIdStr=$g(ArcimIdStr) 
	s retno=0
	Q:(EpisodeID="")||(ArcimIdStr="") 0
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	Q:oeordId="" 0
	s curLocId=$p($g(^PAADM(EpisodeID)),"^",4)
	s num=$l(ArcimIdStr,"^")
	F i=1:1:num Q:retno=1  D
	.s arcimId=$p(ArcimIdStr,"^",i)
	.Q:arcimId=""
	.s oeoriSub=0 
	.F  s oeoriSub=$o(^OEORDi(0,"DateARCIM",Date,arcimId,oeordId,oeoriSub)) Q:(oeoriSub="")!(retno=1)  D
	..;医嘱的病人科室与病人的当前科室不一致就不判断
	..s ordLocId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",3)
	..Q:(TransFlag="true")&&(ordLocId'="")&&(curLocId'=ordLocId)
	..s oeoreSub=0 
	..F  s oeoreSub=$o(^OEORDi(0,"DateARCIM",Date,arcimId,oeordId,oeoriSub,oeoreSub)) Q:(oeoreSub="")!(retno=1)  D
	...s ordStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"BILL")),"^",1)  
	...Q:ordStatusId=""
	...s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
	...Q:(ordStat'="V")&(ordStat'="E")
	...s retno=1
	..

	Q retno
}

/// Decript:是否优先
ClassMethod IsYx(EpisodeID)
{
	n (EpisodeID)
	s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""),-1)
	q:+EmPCLvID=0 0
	s Ret=##Class(web.DHCEMPatCheckLevQuery).IfHaveWaitOutDeal(EmPCLvID,"YX")
	q Ret
}

/// Creator: 	 hxy
/// CreateDate:  2019-11-15
/// Descript:    转科：
/// Input:   	 EpisodeID - 就诊ID
/// w ##Class(web.DHCEMDocMainOutPat).TrsLoc("165")
ClassMethod TrsLoc(EpisodeID As %String, LgUserID As %String, Params As %String) As %String
{
	n (EpisodeID,LgUserID,Params)

	s IsAllowTrsLoc = ##Class(web.DHCEMDocMainOutPat).AllowTrsLoc(EpisodeID,LgUserID)
	q:IsAllowTrsLoc'=0 IsAllowTrsLoc
	
	s LocID=$p(Params,"^",1)
	s PatLoc=$P($g(^PAADM(EpisodeID)),"^",4) //hxy 2019-11-29 st
	q:PatLoc=LocID "当前已在此科室,禁止转诊当前科室！" //ed
	s AdmDoc=$p(Params,"^",2)
	&SQL(SELECT ID into :RegFeeId FROM SQLUser.DHCRegistrationFee Where RegfeeAdmDr=:EpisodeID)
	s ThisASRowId="",ThisSessionTypeDr=""
	s:RegFeeId'="" ThisASRowId=$lg(^User.DHCRegistrationFeeD(RegFeeId),18)
	s:ThisASRowId'="" ThisSessionTypeDr=$P($G(^RBAS(+ThisASRowId,$p(ThisASRowId,"||",2),"DHC")),"^",6)
	S ASRowId=##class(web.DHCOPAdmReg).GetRapidASRowId(LocID,"","","","",AdmDoc)
	s SessionTypeDr=""
	s:ASRowId'="" SessionTypeDr=$P($G(^RBAS(+ASRowId,$p(ASRowId,"||",2),"DHC")),"^",6)
	q:(ThisSessionTypeDr'="")&&(SessionTypeDr'="")&&(ThisSessionTypeDr'=SessionTypeDr) "挂号职称不同,不允许转诊！" 
	
	s curDate=+$h
	s curTime=$p($h,",",2)
	s reqstId=$o(^PAC("REQST",0,"Code","T","")) //PAC_TransfRequestStatus
	s transtypId=$o(^PAC("TRANSTYP",0,"Code","M","")) //PAC_TransType
	s QueRowId=$o(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
	s ret="0"
	TS
	&SQL(update PA_Adm set PAADM_AdmDocCodeDR=:AdmDoc,PAADM_DepCode_DR=:LocID where PAADM_RowID=:EpisodeID)
	i SQLCODE'=0 tro
	i SQLCODE'=0 q "修改PAADM表失败!Code:"_SQLCODE
	&sql(insert into PA_AdmTransaction (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,TRANS_Status_DR,
	TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,TRANS_TransType_DR,
	TRANS_CTCP_DR,TRANS_CTLOC_DR)  
	Values (:EpisodeID,:curDate,:curTime,:reqstId,:curDate,:curTime,:LgUserID,:transtypId,:AdmDoc,:LocID))
	i SQLCODE'=0 tro
	i SQLCODE'=0 q "修改PAAdmTransaction表失败!Code:"_SQLCODE
	
	&sql(UPDATE DHCQueue SET QueDepDr=:LocID,QueMarkDr=:AdmDoc,QueDocDr=null WHERE ID =:QueRowId )
	i SQLCODE'=0 tro
	i SQLCODE'=0 q "修改DHCQueue表失败!Code:"_SQLCODE
	
	TC
	q ret
}

/// Return:0(允许)/其他(不允许)
/// w ##Class(web.DHCEMDocMainOutPat).AllowTrsLoc("2313","1")
ClassMethod AllowTrsLoc(EpisodeID, LgUserID)
{
	n (EpisodeID,LgUserID)
	
	q:EpisodeID="" "就诊不能为空！"
	q:LgUserID="" "未获取到当前登录用户！"
	s IsCESFlag=##Class(DHCDoc.Interface.StandAlone.Service).IsCESFlag("pa_adm",EpisodeID)
	q:IsCESFlag="1" "已经就诊,无法转诊！"
	s Compted="",WalkStatus=""
	s AvsID=""
	f  s AvsID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,AvsID)) q:(AvsID="")||(Compted'="")  d
	.s PvsID=$P(^DHCADMVisitStatus(AvsID),"^",2)
   	.s WalkStatus=$p(^DHCPACVisitStatus(PvsID),"^",1,2)
   	.s:WalkStatus["到达" Compted="Y"
	s:Compted="" Compted = $p(^PAADM(EpisodeID,1),"^",23) 	
	q:Compted="Y" "已经就诊,无法转诊！"
	
	s CurWardId=$p(^PAADM(EpisodeID),"^",70)
	q:CurWardId'="" "已经就诊,无法转诊！"
	
	q 0
}

/// Descript:急诊患者置到达
/// Input: Adm:就诊ID,DocDr:医生ID(User.CTCareProv),LocId:科室ID,UserId:用户Id
/// Return: 1:成功,其他:错误信息
/// w ##Class(web.DHCEMDocMainOutPat).SetArrivedStatus("","","","") 
ClassMethod SetArrivedStatus(Adm As %String, DocDr As %String, LocId As %String, UserId As %String) As %Status
{
	
	Quit:$g(Adm)="" "就诊不能为空!"
	Set:(UserId'="")&&(DocDr="") DocDr=$p($g(^SSU("SSUSR",UserId)),"^",14)
	Ts
	
	s Err=##Class(web.DHCEMInterfaceCom).UpdEmVisitPosition(Adm,UserId)
	Tro:+Err'=0 1
	Quit:+Err'=0 "复诊队列更改位置错误,信息:"_Err
	
	s Err=##Class(web.DHCEMDocMainOutPat).SetDhcQueue(Adm,DocDr,LocId,UserId)
	Tro:Err'=1 1
	Quit:Err'=1 "修改DhcQueue表失败,信息:"_Err
	
	Set Err=##Class(web.DHCEMDocMainOutPat).SetAdmDocId(Adm,LocId,DocDr,UserId)
	Tro:+Err'=0 1
	Quit:+Err'=0 "修改Adm表失败,信息:"_Err
	
	Set CurStat=##Class(web.DHCADMVisitStat).GetPatCurStat(Adm)
	if CurStat="" Do
	.Set Err=##Class(web.DHCADMVisitStat).InsertVisitStat(Adm,"Arrival","","",UserId)
	Tro:+Err'=0 1
	Quit:+Err'=0 "急诊患者状态日志表插入失败!,信息:"_Err
	
	Tc
	Quit 1
}

/// Descript:Queue表设置到达状态
ClassMethod SetDhcQueue(Adm As %String, DocDr As %String, LocId As %String, UserId As %String)
{

	Quit:$g(Adm)="" "就诊不能为空!"
	s sc=1
	Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",Adm,""))
	If QueRowId'="" Do
	.Set oref=##Class(User.DHCQueue).%OpenId(QueRowId)
	.Set QueDoc=oref.QueDocDrGetObjectId()
	.Quit:(QueDoc'="")&(QueDoc'=DocDr)
	.If QueDoc="" do oref.QueDocDrSetObjectId(DocDr)
	.s PatWardId = $p(^PAADM(Adm),"^",70)
	.&sql(SELECT ID into :PerStateDr FROM sqluser.dhcPerstate where persname='到达')
	.if PatWardId="" Do oref.QueStateDrSetObjectId(PerStateDr)
	.s oref.QueCompDr=""
	.Set sc = oref.%Save()
	.Do oref.%Close()
	q sc
}

/// Decript:设置就诊医生和时间
ClassMethod SetAdmDocId(Adm As %String, LocId As %String, DocId As %String, UserId As %String) As %Status
{
	KILL PLIST
	Set PLIST(0)=Adm
	Set PLIST(3)=+$H
	Set PLIST(4)=$p($h,",",2)
	Set PLIST(7)=DocId
	Set PLIST(8)=LocId
	Set PLIST(16)=+$H
	Set PLIST(17)=$p($h,",",2)
	Set PLIST(18)=UserId
	&SQL(UPDATE SQLUSER.PA_Adm Set PAADM_AdmDocCodeDR=:DocId Where PAADM_RowId = :Adm)
	Quit SQLCODE
}

ClassMethod SetComplate(Adm, LgParams)
{
	s LgLocID=$p(LgParams,"^",2)
	s LgUserID=$p(LgParams,"^",4)
	
	s Err=0
	
	ts
	s Err=##Class(web.DHCEMInterfaceCom).UpdEmVisitPosition(Adm,LgUserID)
	tro:+Err'=0 1
	q:+Err'=0 "-1^复诊队列更改位置错误,信息:"_Err
	
	s Err=##Class(web.DHCDocOutPatientList).SetComplate(Adm,LgLocID,LgUserID)
	tro:+Err'=0 1
	q:+Err'=0 "-2^修改就诊状态失败,失败原因:"_$p(Err,"^",2)
	
	tc
	
	q 0
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCEMDocMainOutPat","QueryEmDocMainPatList",pid)
	k ^TMP("DHCST","web.DHCEMDocMainOutPat","QueryEmMainPatList",pid)
}

}
