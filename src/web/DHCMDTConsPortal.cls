Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript: 		mdt会诊中心
Class web.DHCMDTConsPortal Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		加载MDT当天会诊记录
/// w ##Class(web.DHCMDTConsPortal).JsGetDailyConsult("2023-03-17")
ClassMethod JsGetDailyConsult(mParam As %String) As %String
{
	n (mParam,%session)
	s ShowDate=$p(mParam,"^",1)
	s:ShowDate'="" ShowDate=##class(web.DHCMDTCom).DateHtmlToLogical(ShowDate)
	s:ShowDate="" ShowDate=+$h
	
	s ID=0, Num=0
	f  s ID=$o(^DHCMDTCON(0,"NDate",ShowDate,ID)) Q:ID=""  D
	.s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	./// 病人信息
	.s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatAge=##Class(web.DHCMDTCom).GetPapmiAge(EpisodeID) ///年龄
	.;s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	.s PatLoc=""
	.s PatLocID=$p(^PAADM(EpisodeID),"^",4) 	  /// 就诊科室
	.s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	.s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)    /// 费别
	.s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	.s CstRLocID=$p(^DHCMDTCON(ID),"^",2)   /// 申请科室
	.s CstRLoc=""
	.s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	.s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	.s:CstRDate'="" CstRDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)
	.s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	.s:CstRTime'="" CstRTime=$zt(CstRTime,2)
	.s CstRTime=CstRDate_" "_CstRTime
	.s CstRUserID=$p(^DHCMDTCON(ID),"^",5)   /// 申请医生
	.s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	.s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	.s PrvID=$p(^DHCMDTCON(ID),"^",17)       /// 资源号别
	.s PrvDesc=$p($g(^CTPCP(PrvID,1)),"^",2)
	.s StatID=$p(^DHCMDTCON(ID),"^",12)           /// 申请状态ID
	.s StatDesc=$p($g(^DHCMDTS(+StatID)),"^",2)   /// 申请状态
	.Q:(StatDesc="撤销")||(StatDesc="发送")
	.s DisGroup=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCMDTGroup","MDDesc","",DisGroup) //hxy 2023-01-03
	.s Num=Num+1
	.s ListData=ID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_BillType_"^"_CstRLoc
	.s ListData=ListData_"^"_CstRDate_"^"_CstRTime_"^"_DisGroup_"^"_PrvDesc_"^"_StatDesc
	.s TMPListData(Num)=ListData
	.
	
	/// 转换数据为Json格式
	s ListTitle="ID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^BillType^CstRLoc^CstRDate^CstRTime^DisGroup^PrvDesc^StatDesc"
	W "["
	s index="",count=0
	F  s index=$o(TMPListData(index),-1) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		待处理申请(仅显示7天内的申请记录)
/// w ##Class(web.DHCMDTConsPortal).JsGetWaitProREQ("")
ClassMethod JsGetWaitProREQ(mParam As %String, LgParam = "") As %String
{
	n (mParam,LgParam,%session)
	s LgHospID=$p(LgParam,"^",1)
	s Num=0,StartDate=+$H-7,EndDate=+$H
	F dd=StartDate:1:EndDate D
	.s ID=0
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D  //F  s ID=$o(^DHCMDTCON(ID)) Q:ID=""  D
	..s CsStatID=$p(^DHCMDTCON(ID),"^",12)        /// 申请状态
	..s StatusCode=$p($g(^DHCMDTS(+CsStatID)),"^",1)
	..Q:(StatusCode'=20)&&(StatusCode'=25)     /// 非申请状态不显示
	..s Status=$p($g(^DHCMDTS(+CsStatID)),"^",2) 
	..s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	../// 病人信息
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatAge=##Class(web.DHCMDTCom).GetPapmiAge(EpisodeID) ///年龄
	..;s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	..s PatLoc=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 	  /// 就诊科室
	..s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	..s PatLoc = ##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",PatLoc)
	..s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)    /// 费别
	..s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	..s CstRLocID=$p(^DHCMDTCON(ID),"^",2)   /// 申请科室
	..s HospitalID=$p(^CTLOC(CstRLocID),"^",22)
	..q:(LgHospID'="")&&(LgHospID'=HospitalID)  ///多院区过滤
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s CstRLoc = ##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",CstRLoc)
	..s:CstRLoc["-" CstRLoc=$p(CstRLoc,"-",2)
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..s:CstRDate'="" CstRDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)
	..s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,2)
	..s CstRTime=CstRDate_" "_CstRTime
	..s CstRUserID=$p(^DHCMDTCON(ID),"^",5)   /// 申请医生
	..s CstRUser=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	..s CstRUser=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CstRUser)
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	..s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	..s PrvID=$p(^DHCMDTCON(ID),"^",17)       /// 资源号别
	..s PrvDesc=$p($g(^CTPCP(PrvID,1)),"^",2)
	..s mdtMakResID=$p(^DHCMDTCON(ID),"^",18)   /// 预约资源ID
	..s DisGroup=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCMDTGroup","MDDesc","",DisGroup) //hxy 2023-01-03
	..s Num=Num+1
	..s ListData=ID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_BillType_"^"_CstRLoc_"^"_CstRUser
	..s ListData=ListData_"^"_CstRDate_"^"_CstRTime_"^"_DisGroup_"^"_PrvDesc_"^"_DisGrpID_"^"_mdtMakResID_"^"_Status
	..s TMPListData(Num)=ListData
	.
	
	/// 转换数据为Json格式
	s ListTitle="ID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^BillType^CstRLoc^CstRUser^CstRDate^CstRTime^DisGroup^PrvDesc"
				_"^DisGrpID^mdtMakResID^Status"
	W "["
	s index="",count=0
	F  s index=$o(TMPListData(index),-1) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		本月MDT会诊病种分布
/// w ##Class(web.DHCMDTConsPortal).JsGetDisGrpCharts("")
ClassMethod JsGetDisGrpCharts(mParam As %String) As %String
{
	n (mParam,%session)
	s StartDate=..monStartDate() /// 开始日期
	s EndDate=..monEndDate()     /// 结束日期
	k TmpArr
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"NDate",dd,ID)) Q:ID=""  D
	..s StatID=$p(^DHCMDTCON(ID),"^",12)        /// 申请状态ID
	..Q:$p($g(^DHCMDTS(+StatID)),"^",1)'="80"
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	..s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	..s DisGroup=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCMDTGroup","MDDesc","",DisGroup) //hxy 2023-01-03
	..i $D(TmpArr(DisGrpID)) s $p(TmpArr(DisGrpID),"^",3)=$p(TmpArr(DisGrpID),"^",3)+1
	..E  s TmpArr(DisGrpID)=DisGroup_"^"_"病种"_"^"_1
	.
	
	/// 转换数据为Json格式
	s ListTitle="name^group^value"
	W "["
	s Num=0
	s index=""
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	W "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		本周安排
/// w ##Class(web.DHCMDTConsPortal).JsGetWeekPlan("2")
ClassMethod JsGetWeekPlan(mParam As %String) As %String
{
	n (mParam)
	s WeekLimit=$p(mParam,"^",1)
	s StartDate=..weekStartDate(WeekLimit) /// 开始日期
	s EndDate=..weekEndDate(WeekLimit)     /// 结束日期
	
	k TmpArr
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"NDate",dd,ID)) Q:ID=""  D
	..s StatID=$p(^DHCMDTCON(ID),"^",12)           /// 申请状态ID
	..s StatCode=$p($g(^DHCMDTS(+StatID)),"^",1)   /// 申请状态
	..Q:StatCode<"30"
	..s AppScDr = $p(^DHCMDTCON(ID),"^",18)   /// 资源表ID
	..s id=+AppScDr, CH=$p(AppScDr,"||",2)
	..s MakResDate=$p($g(^RBAS(id,CH)),"^",1) /// 预约日期
	..s Week="Week_"_($SYSTEM.SQL.DAYOFWEEK(MakResDate)-1)
	..s CsDataTimeRange=##Class(web.DHCMDTCom).JsMakResDateTime(AppScDr)
	..s CsDataRange=$p(CsDataTimeRange,"^",1) /// 日期
	..s CsTimeRange=$p(CsDataTimeRange,"^",2) /// 时间
	..s TimeRange=$p(CsTimeRange," ",2)
	..s Time=$p(TimeRange,"-",1)
	..s Time=$zth(Time)
	..s Week=Week_"_"_$s($zt(Time,3)["AM":"AM",1:"PM")
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	..s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	..s DisGroup=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCMDTGroup","MDDesc","",DisGroup) //hxy 2023-01-03
	..i $D(TmpArr(DisGrpID_"^"_Week)) s $p(TmpArr(DisGrpID_"^"_Week),"^",4)=$p(TmpArr(DisGrpID_"^"_Week),"^",4)+1
	..E  s TmpArr(DisGrpID_"^"_Week)=DisGroup_"^"_TimeRange_"^"_Week_"^"_1
	.
	/// 转换数据为Json格式
	s ListTitle="DisGroup^TimeRange^Week^value"
	W "["
	s index="",count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W "]"
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2019-07-18
/// Descript:   日期
/// w ##Class(web.DHCMDTConsPortal).JsGetWeekDate()
ClassMethod JsGetWeekDate() As %String
{
	s StartDate=+$H+(7-$SYSTEM.SQL.DAYOFWEEK(+$H))-6 /// 开始日期
	s EndDate=StartDate+6 /// 结束日期
	s ListTitle="",ListData=""
	F dd=StartDate:1:EndDate D
	.s Week=($SYSTEM.SQL.DAYOFWEEK(dd)-1)
	.s ListTitle=$s(ListTitle="":"Week_"_Week,1:ListTitle_"^"_"Week_"_Week)
	.s ListData=$s(ListData="":$p($zd(dd,3),"-",2,3),1:ListData_"^"_$p($zd(dd,3),"-",2,3))
	.
	w ##Class(web.DHCAPPJsonCommon).getJsonChildPrefixSign(ListTitle,ListData)
	w "}"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		本周安排
/// w ##Class(web.DHCMDTConsPortal).JsGetWeekPlan("")
ClassMethod JsGetWeekPlans(mParam As %String) As %String
{
	n (mParam)
	s StartDate=..weekStartDate() /// 开始日期
	s EndDate=..weekEndDate()     /// 结束日期
	k TmpArr
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"NDate",dd,ID)) Q:ID=""  D
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..s Week="Week_"_($SYSTEM.SQL.DAYOFWEEK(CstRDate)-1)
	..s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	..s Week=Week_"_"_$s($zt(CstRTime,3)["AM":"AM",1:"PM")
	..s:CstRDate'="" CstRDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)
	..s:CstRTime'="" CstRTime=$zt(CstRTime,2)
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	..s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	..s TmpArr(ID)=DisGroup_"^"_CstRTime_"^"_Week
	.
	/// 转换数据为Json格式
	s ListTitle="DisGroup^CstRTime^Week"
	W "["
	s index="",count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		初始化当前日期
/// w ##Class(web.DHCMDTConsPortal).JsGetCurDaily()
ClassMethod JsGetCurDaily() As %String
{
	Q $SYSTEM.SQL.MONTH(+$H)_"-"_$SYSTEM.SQL.DAYOFMONTH(+$H)
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		取当前月起始日期
/// w ##Class(web.DHCMDTConsPortal).monStartDate()
ClassMethod monStartDate() As %String
{
	s FristDate=$SYSTEM.SQL.YEAR(+$H)_"-"_$SYSTEM.SQL.MONTH(+$H)_"-01"
	s FristDate=$zdh(FristDate,3)
	Q FristDate
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		取当前月结束日期
/// w ##Class(web.DHCMDTConsPortal).monEndDate()
ClassMethod monEndDate() As %String
{
	s EndDate=$SYSTEM.SQL.LASTDAY(+$H)
	Q EndDate
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		取当前月起始日期
/// w ##Class(web.DHCMDTConsPortal).weekStartDate()
ClassMethod weekStartDate(WeekLimit = 0) As %String
{
	s FristDate=+$H-$SYSTEM.SQL.DAYOFWEEK(+$H)+1+(7*WeekLimit)
	Q FristDate
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		取当前月结束日期
/// w ##Class(web.DHCMDTConsPortal).weekEndDate()
ClassMethod weekEndDate(WeekLimit = 0) As %String
{
	s EndDate=+$H+(7-$SYSTEM.SQL.DAYOFWEEK(+$H))+(7*WeekLimit)
	Q EndDate
}

/// Creator: 		yangzongyi
/// CreateDate: 	2019-07-23
/// Descript:		统计门诊，住院，初诊，复诊。
/// w ##Class(web.DHCMDTConsPortal).JsGetGrpCharts("2019-07-1,2019-07-31")
ClassMethod JsGetGrpCharts(mParam As %String) As %String
{
	n (mParam)
	s StartDate=..monStartDate() /// 开始日期
	s EndDate=..monEndDate()     /// 结束日期
	k TmpArr
	s TmpArr("初诊")="初诊"_"^"_0
	s TmpArr("复诊")="复诊"_"^"_0
	s TmpArr("门诊")="门诊"_"^"_0
	s TmpArr("住院")="住院"_"^"_0
    F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"NDate",dd,ID)) Q:ID=""  D
	..s StatID=$p(^DHCMDTCON(ID),"^",12)        /// 申请状态ID
	..Q:$p($g(^DHCMDTS(+StatID)),"^",1)'="80"
	..s EpisodeID=$P(^DHCMDTCON(ID),"^",1)      //就诊号
	..s admtype=$p(^PAADM(EpisodeID),"^",2)     //就诊类型
	..s admtypes=""
	..s:admtype="O" admtypes ="门诊" //门诊类型
	..s:admtype="I" admtypes ="住院" //住院类型
	..;s PatientID=$p(^PAADM(EpisodeID),"^",1) //病人表ID
	..;s Num= ##Class(web.DHCMDTConsPortal).JsGetEpisodeNum(PatientID)
	..s Num= ##Class(web.DHCMDTConsultQuery).GetMdtCsTimes(EpisodeID)
	..i Num=1 s fEpis="初诊"
	..E  s fEpis="复诊"
	..i $d(TmpArr(admtypes))  d
	...S $p(TmpArr(admtypes),"^",2)=$p(TmpArr(admtypes),"^",2)+1
	..i $d(TmpArr(fEpis))  d
	...S $p(TmpArr(fEpis),"^",2)=$p(TmpArr(fEpis),"^",2)+1
	/// 转换数据为Json格式
	s ListTitle="name^value"
	W "["
	s num=0
	s index=""
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s num=num+1
	.I num=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	W "]"
	Q ""
}

/// Creator: 		yangzongyi
/// CreateDate: 	2019-07-23
/// Descript:		统计门诊，住院，初诊，复诊。
/// w ##Class(web.DHCMDTConsPortal).JsGetGrpJsonData("2019-07-1,2019-07-31")
ClassMethod JsGetGrpJsonData(mParam As %String) As %String
{
	n (mParam)
	s StartDate=..monStartDate() /// 开始日期
	s EndDate=..monEndDate()     /// 结束日期
	k TmpArr,TmpAllArr
	s AllNumber=0
	s TmpArr("初诊")="初诊"_"^"_0
	s TmpArr("复诊")="复诊"_"^"_0
	s TmpArr("门诊")="门诊"_"^"_0
	s TmpArr("住院")="住院"_"^"_0
    F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"NDate",dd,ID)) Q:ID=""  D
	..s StatID=$p(^DHCMDTCON(ID),"^",12)        /// 申请状态ID
	..Q:$p($g(^DHCMDTS(+StatID)),"^",1)'="80"
	..s EpisodeID=$P(^DHCMDTCON(ID),"^",1) //就诊号
	..s admtype=$p(^PAADM(EpisodeID),"^",2) //就诊类型
	..s admtypes=""
	..s:admtype="O" admtypes ="门诊" //门诊类型
	..s:admtype="I" admtypes ="住院" //住院类型
	..s Num= ##Class(web.DHCMDTConsultQuery).GetMdtCsTimes(EpisodeID)
	..i Num=1 s fEpis="初诊"
	..E  s fEpis="复诊"
	..s AllNumber=AllNumber+1
	..i $d(TmpArr(admtypes))  d
	...S $p(TmpArr(admtypes),"^",2)=$p(TmpArr(admtypes),"^",2)+1
	..i $d(TmpArr(fEpis))  d
	...S $p(TmpArr(fEpis),"^",2)=$p(TmpArr(fEpis),"^",2)+1
	
	s index=""
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.i AllNumber=0 s AllNumber=1
	.s index1=$s(index="初诊":1,index="复诊":2,index="门诊":3,index="住院":4,1:"99"_index)
	.s TmpAllArr(index1)=ListData_"^"_($fn(+$p(ListData,"^",2)/AllNumber,"",2)*100)_"%"
	
	/// 转换数据为Json格式
	s ListTitle="name^value^range"
	
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s num=0
	s index=""
	F  s index=$o(TmpAllArr(index)) Q:index=""  D
	.s ListData=$g(TmpAllArr(index))
	.Q:ListData=""
	.s num=num+1
	.I num=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(num)
	Q ""
}

ClassMethod JsGetEpisodeNum(PatientID As %String) As %String
{
	
	s EpisodeID="",Num=0
	F  s EpisodeID=$o(^PAPERdr(PatientID,"ADM","O",EpisodeID)) Q:EpisodeID=""  D
	 .s Num=Num+1
	q Num
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		本周安排
/// w ##Class(web.DHCMDTConsPortal).JsGetWeekDay()
ClassMethod JsGetWeekDay(WeekLimit = 0) As %String
{
	s NowWeekDay=$SYSTEM.SQL.DAYOFWEEK(+$H-1)
	s WeekOne=+$H-NowWeekDay+1+(7*WeekLimit)
	s WeekTwo=+$H-NowWeekDay+2+(7*WeekLimit)
	s WeekThree=+$H-NowWeekDay+3+(7*WeekLimit)
	s WeekFour=+$H-NowWeekDay+4+(7*WeekLimit) 
	s WeekFive=+$H-NowWeekDay+5+(7*WeekLimit)
	s WeekOne=##Class(web.DHCMDTCom).DateLogicalToHtml(WeekOne)
	s WeekTwo=##Class(web.DHCMDTCom).DateLogicalToHtml(WeekTwo)
	s WeekThree=##Class(web.DHCMDTCom).DateLogicalToHtml(WeekThree)
	s WeekFour=##Class(web.DHCMDTCom).DateLogicalToHtml(WeekFour)
	s WeekFive=##Class(web.DHCMDTCom).DateLogicalToHtml(WeekFive)
	Q WeekOne_"^"_WeekTwo_"^"_WeekThree_"^"_WeekFour_"^"_WeekFive
}

}
