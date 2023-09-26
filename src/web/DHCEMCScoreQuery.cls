Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descript: 	评分查询类
Class web.DHCEMCScoreQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descript:   取评分数据
/// w ##Class(web.DHCEMCScoreQuery).JsGetScore("10","1","")
ClassMethod JsGetScore(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params,%session)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-30
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s argPatNo=$p(Params,"^",3)    /// 登记号
	s mEpisodeID=$p(Params,"^",4)  /// 就诊ID
	s LgHospID=$p(Params,"^",5)  /// 医院ID
	k TmpArr
    s Num=0
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCEMCS(0,"Date",dd,ID)) Q:ID=""  D
	..s EpisodeID=$p(^DHCEMCS(ID),"^",1)      /// 就诊ID
	..s EmPCLvID="",PCAID=""
	..s:EpisodeID="" EmPCLvID=$p(^DHCEMCS(ID),"^",8)      /// 预检分级ID
	..s:EmPCLvID'="" PCAID = $o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,""))
	..s:PCAID'="" EpisodeID = $p(^DHCEMPCA(PCAID),"^",2)
	..Q:(mEpisodeID'="")&(mEpisodeID'=EpisodeID)
	..q:EpisodeID=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) //hxy 2020-06-09 st
	..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)  
	..q:CurHospID'=LgHospID //ed
	../// 病人信息
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..Q:(argPatNo'="")&(argPatNo'=PatNo)
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) ///年龄
    ..s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
    ..i PatBed'["床" s PatBed=PatBed_##class(web.DHCEMCommonUtil).GetTrans("","床")
    ..s Date=$p(^DHCEMCS(ID),"^",2)    /// 操作日期
	..s:Date'="" Date=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(Date)
	..s Time=$p(^DHCEMCS(ID),"^",3)    /// 操作时间
	..s:Time'="" Time=$zt(Time,2)
	..s UserID=$p(^DHCEMCS(ID),"^",4)  /// 操作医生
	..s User=$p($g(^SSU("SSUSR",UserID)),"^",2)
	..s User=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",User)
	..s Type=$p(^DHCEMCS(ID),"^",5)     /// 类型
	..s ScoreID=$p(^DHCEMCS(ID),"^",6)  /// 评分表ID
	..s ScoreCode=$p(^DHCEMCSS(ScoreID),"^",1) /// 代码
	..s ScoreDesc=$p(^DHCEMCSS(ScoreID),"^",2) /// 描述
	..s ScoreDesc=##class(web.DHCEMCommonUtil).GetTrans("dhcemc.scorepersys.csp",ScoreDesc)
	..s ScoreVal=$p(^DHCEMCS(ID),"^",7) /// 分值
	..s Num=Num+1
	..s ListData=ID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_Date_"^"_Time_"^"_User_"^"_Type_"^"_ScoreID_"^"_ScoreCode_"^"_ScoreDesc_"^"_ScoreVal
	..s TmpArr(Num)=ListData
	..
	
	i Num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^EpisodeID^PatNo^PatName^PatSex^Date^Time^User^Type^ScoreID^ScoreCode^ScoreDesc^ScoreVal"

	W ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TmpArr(index),-1) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W "]}"
	Q ""
}

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descript:   取评分数据
/// w ##Class(web.DHCEMCScoreQuery).JsGetFormScore(170)
ClassMethod JsGetFormScore(ID As %String) As %String
{
	n (ID)
	s del=""""
	W "{"
	s Score=$p(^DHCEMCS(ID),"^",7)       /// 分值
	w del_"Score"_del_":"_Score
	w ",""items"":"
	D ..JsGetFormItem(ID)
	W "}"
	Q ""
}

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descript:   取评分数据
/// w ##Class(web.DHCEMCScoreQuery).JsGetFormItem(170)
ClassMethod JsGetFormItem(ID As %String) As %String
{
	n (ID)
	s ListTitle="key^val^type"
	W "["
	s itmID="",Num=0
	F  s itmID=$o(^DHCEMCSI(0,"Score",ID,itmID)) Q:itmID=""  D
	.s key=$p(^DHCEMCSI(itmID),"^",2)  /// key
	.s val=$p(^DHCEMCSI(itmID),"^",3)  /// val
	.s type=$p(^DHCEMCSI(itmID),"^",4) /// type
	.s ListData=key_"^"_val_"^"_type
	.s Num=Num+1
	.i Num=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	W "]"
	Q ""
}

}
