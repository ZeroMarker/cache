Import sqluser

/// Creator: 	yangyongyao
/// CreateDate: 2019-12-07
/// Descript: 	急诊院前出诊记录表
Class web.DHCEMPreHosVis Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descritp:  插入急诊院前出诊信息
/// Input:     mListData-登记内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMPreHosVis).Insert("20","李四^女^23^111^222^11/03/2020^16:37^10218^222^333^1^11843^^")
ClassMethod Insert(VisID As %String, mListData As %String) As %String
{
	n (VisID, mListData)
	//s ^yangyongtao("Insert")=mListData
	i VisID="" D
	.s VisID=..InsHosVis(mListData)
	E  D
	.s VisID=..UpdHosVis(VisID, mListData)
	Q VisID
}

/// Descritp:  插入急诊院前出诊信息
/// Input:     mListData-院前出诊内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMPreHosVis).InsHosVis("")
ClassMethod InsHosVis(mListData As %String) As %String
{
	N (mListData)
	s Err=0
	TS

	/// 插入院前出诊主表
	s VisID=..InsPreHosVis(mListData)
	i VisID<0 tro
	Q:VisID<0 VisID

	TC
	Q VisID
}

/// Descritp:  修改院前出诊信息
/// Input:     mListData-院前出诊内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMPreHosVis).UpdHosVis("")
ClassMethod UpdHosVis(VisID As %String, mListData As %String) As %String
{
	N (VisID, mListData)
	s Err=0
	TS

	/// 修改院前出诊主表
	s VisID=..UpdPreHosVis(VisID,mListData)
	i VisID<0 tro
	Q:VisID<0 VisID

	TC
	Q VisID
}

/// Descritp:  插入出诊主表
ClassMethod InsPreHosVis(mListData As %String) As %String
{
	n (mListData)
	s PatName=$p(mListData,"^",1)    	/// 病人姓名
	s PatSex=$p(mListData,"^",2)     	/// 性别
	s PatAge=$p(mListData,"^",3)     	/// 年龄
	s VisPlace=$p(mListData,"^",4)   	/// 出诊地点
	s VisRea=$p(mListData,"^",5)       	/// 出诊事由
	s VisDate=$p(mListData,"^",6)   	/// 接通知日期
	s:VisDate'="" VisDate= ##class(web.DHCAPPCommonUtil).DateHtmlToLogical(VisDate)	
	s VisTime=$p(mListData,"^",7)     	/// 接通知时间
	s:VisTime'="" VisTime=$zth(VisTime,2)
	s RecUser=$p(mListData,"^",8)      	/// 接通知者
	s CallerName=$p(mListData,"^",9)    /// 呼救者姓名
	;S:RecUser'="" RecUser=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(RecUser),""))
	s CallerPhone=$p(mListData,"^",10)  /// 联系电话
	s VisSource=$p(mListData,"^",11)   	/// 信息来源 
	s CrateUser=$p(mListData,"^",12)   	/// 登记人
	s CreateDate=+$H   		            /// 登记日期
	s CreateTime=$p($H,",",2)           /// 登记时间
	q:(VisDate>CreateDate) "-1001"
	q:(VisDate=CreateDate)&&(VisTime>CreateTime) "-1002"
	s LgHospID=$p(mListData,"^",15)   	/// 医院 hxy 2020-06-04
	&SQL(Insert Into DHC_EmPreHosVis(EM_PatName,EM_PatSex,EM_PatAge,EM_VisPlace,EM_VisRea,
	EM_VisDate,EM_VisTime,EM_RecUser_Dr,EM_Name,EM_Phone,EM_Source,EM_RUser_Dr,EM_RDate,EM_RTime,EM_Hosp_Dr)
		values(:PatName,:PatSex,:PatAge,:VisPlace,:VisRea,:VisDate,:VisTime,:RecUser,:CallerName,
		:CallerPhone,:VisSource,:CrateUser,:CreateDate,:CreateTime,:LgHospID))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descritp:  修改出诊主表
ClassMethod UpdPreHosVis(VisID As %String, mListData As %String) As %String
{
	n (VisID, mListData)
	s PatName=$p(mListData,"^",1)    	/// 病人姓名
	s PatSex=$p(mListData,"^",2)     	/// 性别
	s PatAge=$p(mListData,"^",3)     	/// 年龄
	s VisPlace=$p(mListData,"^",4)   	/// 出诊地点
	s VisRea=$p(mListData,"^",5)       	/// 出诊事由
	s VisDate=$p(mListData,"^",6)   	/// 接通知日期
	s:VisDate'="" VisDate= ##class(web.DHCAPPCommonUtil).DateHtmlToLogical(VisDate)	
	s VisTime=$p(mListData,"^",7)     	/// 接通知时间
	s:VisTime'="" VisTime=$zth(VisTime,2)
	s RecUser=$p(mListData,"^",8)      	/// 接通知者
	;S:RecUser'="" RecUser=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(RecUser),""))
	s CallerName=$p(mListData,"^",9)    /// 呼救者姓名
	s CallerPhone=$p(mListData,"^",10)  /// 联系电话
	s VisSource=$p(mListData,"^",11)   	/// 信息来源 
	s CrateUser=$p(mListData,"^",12)   	/// 登记人
	s CreateDate=$p(^DHCEMPHV(VisID),"^",12) /// 登记日期
	s CreateTime=$p(^DHCEMPHV(VisID),"^",13) /// 登记时间
	q:(VisDate>CreateDate) "-1003"
	q:(VisDate=CreateDate)&&(VisTime>CreateTime) "-1004"
	
	&SQL(Update DHC_EmPreHosVis Set EM_PatName=:PatName,EM_PatSex=:PatSex,EM_PatAge=:PatAge,EM_VisPlace=:VisPlace,EM_VisRea=:VisRea,
	EM_VisDate=:VisDate,EM_VisTime=:VisTime,EM_RecUser_Dr=:RecUser,EM_Name=:CallerName,EM_Phone=:CallerPhone,EM_Source=:VisSource,
	EM_RUser_Dr=:CrateUser Where EM_RowID=:VisID)
	Q VisID
}

/// Descript: 删除急诊救护车派车管理数据
/// w ##Class(web.DHCEMPreHosVis).delDisAmbMan("24")
ClassMethod delDisAmbMan(ID As %String) As %String
{
	
    N (ID)
	&SQL(delete from DHC_EmPreHosVis where EM_RowID=:ID)
	Q SQLCODE
    /*
	s Err=0
	TS

	/// 删除院前出诊记录主表
	s VisID=..DelPreHosVis(ID)
	i VisID<0 tro
	Q:VisID<0 VisID
	
	/// 删除派车表
	S MaID=0
	I $d(^DHCEMDAM(0,"HOSVIS",VisID)) D   
    .s MaID=$o(^DHCEMDAM(0,"HOSVIS",VisID,""))
	.s MaID=..DelDispatCar(ID)
	.i MaID<0 tro
	Q:MaID<0 MaID
	
	/// 删除随车人员表
	s Err=..DelEmAccPer(MaID)
	i Err'=0 tro
	Q:Err'=0 "-13"

   /// 删除登记表
    S RegID=0
    I $d(^DHCEMPHR(0,"DISAMB",MaID)) D   
	.S RegID=$o(^DHCEMPHR(0,"DISAMB",MaID,"")) //登记ID
	.s Err=..DelPreHosReg(ID)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 删除登记子表表数据
	s Err=..DelRegSubTable(ID)
	i Err'=0 tro
	Q:Err'=0 "-15"

	TC
	Q Err
	*/
}

/// 删除出诊记录表
ClassMethod DelPreHosVis(VisID As %String) As %String
{
	n (VisID)
	&SQL(delete from DHC_EmPreHosVis where EM_RowID=:VisID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript: 删除派车表
ClassMethod DelDispatCar(MaID As %String) As %String
{
	n (MaID)
	&SQL(delete from DHC_EmDisAmbMan where ED_RowID=:MaID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:删除随车人员表
ClassMethod DelEmAccPer(MaID As %String) As %String
{
	n (MaID)
	&SQL(delete from DHC_EmAccPerson where EM_ParRef_Dr=:MaID)
	Q SQLCODE
}

/// Descript: 删除登记表
ClassMethod DelPreHosReg(RegID As %String) As %String
{
	n (VisID)
	&SQL(delete from DHC_EmPreHosReg where EM_RowID=:VisID)
	Q SQLCODE
}

/// Descript: 删除登记子表表数据
/// w ##Class(web.DHCEMPreHosReg).DelCstMasSubTable("24")
ClassMethod DelRegSubTable(RegID) As %String
{
	n (RegID)
	s SQLCODE=0
	///  登记子表
	i $o(^DHCEMPHRI(RegID,"I","")) D
	.&SQL(delete from DHC_EmPreHosRegItem where EW_ParRef_Dr=:RegID)
	Q:SQLCODE'=0 SQLCODE
	Q SQLCODE
}

/// Descript:  取急诊院前出诊数据
/// W ##Class(web.DHCEMPreHosVis).GetPreHosVisInfo("12")
ClassMethod GetPreHosVisInfo(VisID As %String) As %String
{
	n (VisID)
	Q:'$D(^DHCEMPHV(VisID)) ""
	s PatName=$p(^DHCEMPHV(VisID),"^",3)    	/// 病人姓名
	s PatSex=$p(^DHCEMPHV(VisID),"^",4)     	/// 性别
	s PatAge=$p(^DHCEMPHV(VisID),"^",5)     	/// 年龄
	s VisPlace=$p(^DHCEMPHV(VisID),"^",6)   	/// 出诊地点
	s VisRea=$p(^DHCEMPHV(VisID),"^",7)       	/// 出诊事由
	s VisDate=$p(^DHCEMPHV(VisID),"^",8)   		/// 出诊日期
	s:VisDate'="" VisDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(VisDate)
	s VisTime=$p(^DHCEMPHV(VisID),"^",9)     	/// 出诊时间
	s:VisTime'="" VisTime=$zt(VisTime,2)
	s RecUserID=$p(^DHCEMPHV(VisID),"^",11)      	/// 接通知者
	s RecUser=""
	S:RecUserID'="" RecUser=$p(^SSU("SSUSR",RecUserID),"^",2)
	s CallerName=$p(^DHCEMPHV(VisID),"^",1)    /// 呼救者姓名
	s CallerPhone=$p(^DHCEMPHV(VisID),"^",2)  	/// 联系电话
	s VisSource=$p(^DHCEMPHV(VisID),"^",10)   	/// 信息来源 
	s CreateUser=$p(^DHCEMPHV(VisID),"^",14)   	/// 登记人
	s CreateDate=$p(^DHCEMPHV(VisID),"^",12)   	/// 登记日期
	s:CreateDate'="" CreateDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(CreateDate)
	s CreateTime=$p(^DHCEMPHV(VisID),"^",13)     /// 登记时间
	s:CreateTime'="" CreateTime=$zt(CreateTime,2)
	
	s MaID=$o(^DHCEMDAM(0,"HOSVIS",VisID,""))
	s RegID="",PatientID="",PatNo=""
	s:MaID'="" RegID=$o(^DHCEMPHR(0,"DISAMB",MaID,"")) //登记ID
	i RegID'="" D 
	.s EpisodeID=$p(^DHCEMPHR(RegID),"^",1)
	.q:+EpisodeID=0
	.s PatientID=$p(^PAADM(EpisodeID),"^",1)
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
	
	s ListData=PatName_"^"_PatSex_"^"_PatAge_"^"_VisPlace_"^"_VisRea
	s ListData=ListData_"^"_VisDate_"^"_VisTime_"^"_RecUserID_"^"_RecUser_"^"_CallerName_"^"_CallerPhone
	s ListData=ListData_"^"_VisSource_"^"_CreateUser_"^"_CreateDate_"^"_CreateTime_"^"_VisID_"^"_PatNo
	s ListTitle="PatName^PatSex^PatAge^VisPlace^VisRea^VisDate^VisTime^RecUserID^RecUser^CallerName^CallerPhone^VisSource^CreateUser^CreateDate^CreateTime^VisID"
	s ListTitle=ListTitle_"^PatNo"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descritp:	获取系统日期时间
/// w ##Class(web.DHCEMPreHosVis).GetSystemTime()
ClassMethod GetSystemTime() As %String
{
	s SystemDate=+$H
	s SystemDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(SystemDate)
	s SystemTime=$zt($p($H,",",2),2)
	s ListData=SystemDate_"^"_SystemTime
	w ##class(web.DHCAPPJsonCommon).getJsonData("SystemDate^SystemTime",SystemDate_"^"_SystemTime)
	q ""
}

/// Descript: 取急诊出诊记录管理数据
/// w ##Class(web.DHCEMPreHosVis).JsGetPreHosVisList("10","1","2019-12-01^2019-12-13")
ClassMethod JsGetPreHosVisList(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params,%session)
    s ^yangyongtao("JsGetPreHosVisList")=$lb(rows,page,Params)
	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-1
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s argLocID=$p(Params,"^",3)  /// 登记科室
	s aPatName=$p(Params,"^",4)  /// 病人姓名
	s mMtType=$p(Params,"^",5)   /// 类型
	s aPatNo=$p(Params,"^",6)    /// 登记号
	s LgHospID=$p(Params,"^",7)    /// 医院 hxy 2020-06-04
    s Num=0
	F dd=StartDate:1:EndDate D
	.s VisID=""
	.F  s VisID=$o(^DHCEMPHV(0,"CreateDate",dd,VisID)) Q:VisID=""  D
	..s CurHospID=$p(^DHCEMPHV(VisID),"^",15) //hxy 2020-06-04 st
	..q:CurHospID'=LgHospID //ed
	..S papRowid="",EpisodeID="",PatNo="",PatName="",PatSex="",PatAge="",PatLoc="",PatWard="",PatBed="",PatTelH="",PatBod="",PatAddr=""
	..S BillType="",MedicareNo="",PatDiag=""
	..S VISDr="",PACDr="",PACStaDesc=""
	..s PatName=$p(^DHCEMPHV(VisID),"^",3)    	/// 病人姓名
	..Q:(aPatName'="")&(PatName'[aPatName)
	..s PatSex=$p(^DHCEMPHV(VisID),"^",4)     	/// 性别
	..s PatAge=$p(^DHCEMPHV(VisID),"^",5)     	/// 年龄
	..s VisPlace=$p(^DHCEMPHV(VisID),"^",6)   	/// 出诊地点
	..s VisRea=$p(^DHCEMPHV(VisID),"^",7)       	/// 出诊事由
	..s VisDate=$p(^DHCEMPHV(VisID),"^",8)   		/// 出诊日期
	..s:VisDate'="" VisDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(VisDate)
	..s VisTime=$p(^DHCEMPHV(VisID),"^",9)     	/// 出诊时间
	..s:VisTime'="" VisTime=$zt(VisTime,2)
	..s RecUserID=$p(^DHCEMPHV(VisID),"^",11)      	/// 接通知者
	..s RecUser=""
	..s:RecUserID'="" RecUser=$p(^SSU("SSUSR",RecUserID),"^",2)
	..s CallerName=$p(^DHCEMPHV(VisID),"^",1)    /// 呼救者姓名
	..s CallerPhone=$p(^DHCEMPHV(VisID),"^",2)  	/// 联系电话
	..s VisSource=$p(^DHCEMPHV(VisID),"^",10)   	/// 信息来源 
	..s UserID=$p(^DHCEMPHV(VisID),"^",14)   	/// 登记人
	..s VisCrUser=$p($g(^SSU("SSUSR",UserID)),"^",2)
	..s VisCrDate=$p(^DHCEMPHV(VisID),"^",12)   	/// 登记日期
	..s:VisCrDate'="" VisCrDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(VisCrDate)
	..s VisCrTime=$p(^DHCEMPHV(VisID),"^",13)     /// 登记时间
	..s:VisCrTime'="" VisCrTime=$zt(VisCrTime,2)
	
    ..S MaID="", RDate="",RTime="",RUser="",MtType="",MtNotes="",RLocDesc=""
    ..s SCDoc="",SCNur="",SCDri="",UserID="",UserDocID="",UserNurID=""
    ..S ArrDate="",ArrTime="",DepartDate="",DepartTime="",RegID="",BackDate="",BackTime=""
    ..I $d(^DHCEMDAM(0,"HOSVIS",VisID)) D
    ...s MaID=$o(^DHCEMDAM(0,"HOSVIS",VisID,""))
	..i MaID'="" D
	...s RLocID=$p(^DHCEMDAM(MaID),"^",2)     /// 申请科室
	...Q:(argLocID'="")&(argLocID'=RLocID)
	...s:RLocID'="" RLocDesc=$p(^CTLOC(RLocID),"^",2)
	...s RDate=$p(^DHCEMDAM(MaID),"^",3)    /// 登记日期
	...s:RDate'="" RDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(RDate)
	...s RTime=$p(^DHCEMDAM(MaID),"^",4)    /// 登记时间
	...s:RTime'="" RTime=$zt(RTime,1)
	...s UserID=$p(^DHCEMDAM(MaID),"^",5)   /// 登记人
	...s RUser=$p($g(^SSU("SSUSR",UserID)),"^",2)
	...s MtType=$p(^DHCEMDAM(MaID),"^",6)   /// 类型
	
	...s MtNotes=$p(^DHCEMDAM(MaID),"^",7)  /// 备注
	...s SCDocdr=$o(^DHCEMACCPi(0,"ParType",MaID,"医生",""))
	...i SCDocdr'="" d
	....s SSDocUser=$p($g(^DHCEMACCP(SCDocdr)),"^",3)
	....s:SSDocUser'="" UserDocID=$o(^SSU("SSUSR",0,"CTPCP",SSDocUser,""))
	....s:UserDocID'="" SCDoc=$p(^SSU("SSUSR",UserDocID),"^",2)
	...s SCNurdr=$o(^DHCEMACCPi(0,"ParType",MaID,"护士",""))
	...i SCNurdr'="" d
	....s SSNurUser=$p($g(^DHCEMACCP(SCNurdr)),"^",3)
	....s:SSNurUser'="" UserNurID=$o(^SSU("SSUSR",0,"CTPCP",SSNurUser,""))
	....s:UserNurID'="" SCNur=$p(^SSU("SSUSR",UserNurID),"^",2)
	...s SCDridr=$o(^DHCEMACCPi(0,"ParType",MaID,"司机",""))
	...i SCDridr'="" d
	....s SCDri=$p($g(^DHCEMACCP(SCDridr)),"^",2)
	...I $d(^DHCEMPHR(0,"DISAMB",MaID)) D
	....S RegID=$o(^DHCEMPHR(0,"DISAMB",MaID,"")) //登记ID
	...I RegID'="" D 
	....S EpisodeID=$p(^DHCEMPHR(RegID),"^",1)
	....S:EpisodeID'="" papRowid=$p(^PAADM(EpisodeID),"^",1)
	....S:papRowid'="" PatNo=$p(^PAPER(papRowid,"PAT",1),"^",1)
    ....s:EpisodeID'="" VISDr=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	....s:VISDr'="" PACDr=$p($g(^DHCADMVisitStatus(VISDr)),"^",2)
	....s:PACDr'="" PACStaDesc=$p($g(^DHCPACVisitStatus(PACDr)),"^",2) //状态描述
	....s ItemData=##Class(web.DHCEMPreHosReg).GetHosRegItem(RegID)
 	....s:ItemData["^" ArrDate=$p(ItemData,"^",1)
	....s:ItemData["^" ArrTime=$p(ItemData,"^",2)
	....s:ItemData["^" DepartDate=$p(ItemData,"^",3)
	....s:ItemData["^" DepartTime=$p(ItemData,"^",4)
	....s:ItemData["^" BackDate=$p(ItemData,"^",5)
	....s:ItemData["^" BackTime=$p(ItemData,"^",6)
	..Q:(aPatNo'="")&(aPatNo'=PatNo)
	..Q:(mMtType'="")&(mMtType'=MtType)
	..;s MtType=$s(MtType="Y":"院外",MtType="N":"院内",1:"")
	..s RUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",RUser) //hxy 2022-12-07 st
	..s RecUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",RecUser)
	..s SCDoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",SCDoc) 
	..s SCNur=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",SCNur) //ed
	..s Num=Num+1
	..s ListData=MaID_"^"_EpisodeID_"^"_PatNo_"^"_PACStaDesc_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatWard_"^"_PatBed_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	..s ListData=ListData_"^"_RLocDesc_"^"_BillType_"^"_MedicareNo_"^"_PatDiag_"^"_RDate_"^"_RTime_"^"_RUser_"^"_MtType_"^"_MtNotes_"^"_SCDoc_"^"_SCNur_"^"_SCDri
	..s ListData=ListData_"^"_VisID_"^"_VisPlace_"^"_VisRea_"^"_VisDate_"^"_VisTime_"^"_RecUserID_"^"_RecUser_"^"_CallerName_"^"_CallerPhone
	..s ListData=ListData_"^"_RegID_"^"_ArrDate_"^"_ArrTime_"^"_DepartDate_"^"_DepartTime_"^"_BackDate_"^"_BackTime_"^"_VisCrDate_"^"_VisCrTime
	
	..s TMPListData(Num)=ListData
	..
	
	i Num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	s ListTitle="MaID^EpisodeID^PatNo^PACStaDesc^PatName^PatSex^PatAge^PatLoc^PatWard^PatBed^PatTelH^PatBod^PatAddr^RLocDesc^BillType^MedicareNo^PatDiag^RDate^RTime^RUser^MtType^MtNotes^ScDoc^ScNur^ScDri"
    s ListTitle=ListTitle_"^PhvID^VisPlace^VisRea^VisDate^VisTime^RecUserID^RecUser^CallerName^CallerPhone"
    s ListTitle=ListTitle_"^RegID^ArrDate^ArrTime^DepartDate^DepartTime^BackDate^BackTime^VisCrDate^VisCrTime"
	W ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPListData(index),-1) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W "]}"
	Q ""
	/*
	..s EpisodeID=$p(^DHCEMDAM(MaID),"^",1)        /// 就诊ID
	..i EpisodeID'="" D
	...s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)     /// 病人ID
	...s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	...Q:(aPatName'="")&(PatName'[aPatName)
	...s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	...Q:(aPatNo'="")&(aPatNo'=PatNo)
	...s PatSex=""
	...s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	...i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	...s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) ///年龄
	...s PatLoc=""
	...s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	...Q:(argLocID'="")&(argLocID'=PatLocID)
	...s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	...s PatWard=""
	...s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	           /// 病区ID
	...s:PatWardID'="" PatWard=$p($g(^PAWARD(PatWardID)),"^",2) /// 病区描述
	...s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	...s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
    ...s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
    ...s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话 
	...s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	 /// 家庭住址
	...s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	...i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	...s MedicareNo=##Class(web.DHCEMCommonUtil).GetMrNo(EpisodeID) /// 病案号
	...s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)       /// 诊断
	*/
}

/// Creator:      yangyongtao
/// CreateDate:   2019-12-09
/// Descript:     急诊救护车派车单打印
/// InPut:        MaID
/// w ##Class(web.DHCEMPreHosVis).PrintDisAmbMan("21")
ClassMethod PrintDisAmbMan(VisID As %String)
{
	n (VisID)
	//出诊信息
	S PatNo=""
	s PatName=$p(^DHCEMPHV(VisID),"^",3)    	/// 病人姓名
	s PatSex=$p(^DHCEMPHV(VisID),"^",4)     	/// 性别
	s PatAge=$p(^DHCEMPHV(VisID),"^",5)     	/// 年龄
	s VisPlace=$p(^DHCEMPHV(VisID),"^",6)   	/// 出诊地点
	s VisRea=$p(^DHCEMPHV(VisID),"^",7)       	/// 出诊事由
	s VisDate=$p(^DHCEMPHV(VisID),"^",8)   		/// 出诊日期
	s:VisDate'="" VisDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(VisDate)
	s VisTime=$p(^DHCEMPHV(VisID),"^",9)     	/// 出诊时间
	s:VisTime'="" VisTime=$zt(VisTime,2)
	s RecUser=$p(^DHCEMPHV(VisID),"^",11)      	/// 接通知者
	s:RecUser'="" RecUser=$p(^SSU("SSUSR",RecUser),"^",2)
	s CallerName=$p(^DHCEMPHV(VisID),"^",1)    /// 呼救者姓名
    s CallerPhone=$p(^DHCEMPHV(VisID),"^",2)  	/// 联系电话
	s VisSource=$p(^DHCEMPHV(VisID),"^",10)   	/// 信息来源 
	s VisSource=$s(VisSource="1":"120急救中心",VisSource="2":"其他",1:"")
	s UserID=$p(^DHCEMPHV(VisID),"^",14)   	/// 登记人
	s VisCrUser=$p($g(^SSU("SSUSR",UserID)),"^",2)
	s VisCrDate=$p(^DHCEMPHV(VisID),"^",12)   	/// 登记日期
	s:VisCrUser'="" VisCrUser=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(VisCrUser)
	s VisCrTime=$p(^DHCEMPHV(VisID),"^",13)     /// 登记时间
	s:VisCrTime'="" VisCrTime=$zt(VisCrTime,2)
	S MaID="", RDate="",RTime="",RUser="",MtType="",MtNotes="",RLocDesc=""
    s SCDoc="",SCNur="",SCDri=""
    S ArrDate="",ArrTime="",RegID=""
    s EpisodeID="",PatNo=""
    s DepartDate="",DepartTime="",BackDate="",BackTime=""
    I $d(^DHCEMDAM(0,"HOSVIS",VisID)) D   //派车信息
    .s MaID=$o(^DHCEMDAM(0,"HOSVIS",VisID,""))
	i MaID'="" D
	.s RDate=$p(^DHCEMDAM(MaID),"^",3)    /// 登记日期
	.s MtType=$p(^DHCEMDAM(MaID),"^",6)   /// 类型
	.s MtType=$s(MtType="Y":"院外",MtType="N":"院内",1:"")
	.s MtNotes=$p(^DHCEMDAM(MaID),"^",7)  /// 备注
	.s SCDocdr=$o(^DHCEMACCPi(0,"ParType",MaID,"医生",""))
	.i SCDocdr'="" d
	..q:'$d(^DHCEMACCP(SCDocdr))
	..s SSUser=$p(^DHCEMACCP(SCDocdr),"^",3)
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",SSUser,""))
	..s SCDoc=$p(^SSU("SSUSR",UserID),"^",2)
	.s SCNurdr=$o(^DHCEMACCPi(0,"ParType",MaID,"护士",""))
	.i SCNurdr'="" d
	..q:'$d(^DHCEMACCP(SCNurdr))
	..s SSUser=$p(^DHCEMACCP(SCNurdr),"^",3)
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",SSUser,""))
	..s SCNur=$p(^SSU("SSUSR",UserID),"^",2)
	.s SCDridr=$o(^DHCEMACCPi(0,"ParType",MaID,"司机",""))
	.i SCDridr'="" d
	..q:'$d(^DHCEMACCP(SCDridr))
	..s SCDri=$p(^DHCEMACCP(SCDridr),"^",2)
	.I $d(^DHCEMPHR(0,"DISAMB",MaID)) D   //登记信息
	..S RegID=$o(^DHCEMPHR(0,"DISAMB",MaID,"")) //登记ID
	.I RegID'="" D 
	..S EpisodeID=$p(^DHCEMPHR(RegID),"^",1)
	..s papRowid=""
	..S:EpisodeID'="" papRowid=$p(^PAADM(EpisodeID),"^",1)
	..S:papRowid'="" PatNo=$p(^PAPER(papRowid,"PAT",1),"^",1)
	..s ItemData=##Class(web.DHCEMPreHosReg).GetHosRegItem(RegID)
    ..S:ItemData["^" ArrDate=$p(ItemData,"^",1)  //到达日期
    ..S:ItemData["^" ArrTime=$p(ItemData,"^",2)  //到达时间
    ..s:ItemData["^" DepartDate=$p(ItemData,"^",3)  //出诊日期（发车）
	..s:ItemData["^" DepartTime=$p(ItemData,"^",4)  //出诊时间（发车）
	..s:ItemData["^" BackDate=$p(ItemData,"^",5)  //返院日期（发车）
	..s:ItemData["^" BackTime=$p(ItemData,"^",6)  //返院时间（发车）
	
	s ListData=PatNo_"^"_VisID_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_VisID_"^"_VisPlace_"^"_VisRea_"^"_VisDate_"^"_VisTime_"^"_RecUser_"^"_CallerName_"^"_CallerPhone
	s ListData=ListData_"^"_MaID_"^"_MtType_"^"_MtNotes_"^"_SCDoc_"^"_SCNur_"^"_SCDri
	s ListData=ListData_"^"_RegID_"^"_ArrDate_"^"_ArrTime_"^"_DepartDate_"^"_DepartTime_"^"_BackDate_"^"_BackTime
	s ListTitle="PatNo^VisID^PatName^PatSex^PatAge^VisID^VisPlace^VisRea^VisDate^VisTime^RecUser^CallerName^CallerPhone"
	s ListTitle=ListTitle_"^MaID^MtType^MtNotes^SCDoc^SCNur^SCDri"
	s ListTitle=ListTitle_"^RegID^ArrDate^ArrTime^DepartDate^DepartTime^BackDate^BackTime"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// w ##Class(web.DHCEMPreHosVis).PrintDisAmbMan("14")
ClassMethod GetAllUser(q, LgHospID)
{
	n (q,LgHospID,%session)
	w "["
	s Count=0
	s ID=""
	f  s ID=$o(^SSU("SSUSR",ID)) q:ID=""  d
	.s Name=$p(^SSU("SSUSR",ID),"^",2)
	.s Name=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",Name) //hxy 2022-12-07
	.s ShowFlag=##class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_User",ID,LgHospID)
	.q:ShowFlag'="Y" //hxy 2020-06-02 add
	.q:(q'="")&&(Name'[q)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s TmpDate=ID_"^"_Name
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",TmpDate)
	w "]"
	q ""
}

}
