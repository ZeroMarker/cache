Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2018-10-26
/// Descript: 	急诊待入院管理
Class web.DHCEMWaitToHosPat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descritp:  插入待入院信息
/// Input:     mListData-登记内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMWaitToHosPat).Insert("14","")
ClassMethod Insert(WtID As %String, mListData As %String) As %String
{
	n (WtID, mListData)
	i WtID="" D
	.s WtID=..InsWaitToHos(mListData)
	E  D
	.s WtID=..UpdWaitToHos(WtID, mListData)
	Q WtID
}

/// Descritp:  插入待入院信息
/// Input:     mListData-会诊申请内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMWaitToHosPat).InsWaitToHos("")
ClassMethod InsWaitToHos(mListData As %String) As %String
{
	N (mListData)
	s Err=0
	TS

	/// 插入待入院主表
	s WtID=..InsWaitMas(mListData)
	i WtID<0 tro
	Q:WtID<0 WtID

	/// 插入待入院子表
	s mListData=$p(mListData,"#",2)
	s Err=..InsWaitItm(WtID, mListData)
	i Err'=0 tro
	Q:Err'=0 "-11"

	TC
	Q WtID
}

/// Descritp:  修改待入院信息
/// Input:     mListData-会诊申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMWaitToHosPat).UpdWaitToHos("")
ClassMethod UpdWaitToHos(WtID As %String, mListData As %String) As %String
{
	N (WtID, mListData)
	s Err=0
	TS

	/// 修改待入院主表
	s WtID=..UpdWaitMas(WtID,mListData)
	i WtID<0 tro
	Q:WtID<0 WtID
	
	/// 删除相关字表内容重新插入
	s Err=..DelWaitMasSubTable(WtID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 插入待入院子表
	s mListData=$p(mListData,"#",2)
	s Err=..InsWaitItm(WtID, mListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	TC
	Q CstID
}

/// Descritp:  插入登记主表
ClassMethod InsWaitMas(mListData As %String) As %String
{
	n (mListData)
	s EpisodeID=$p(mListData,"^",1)   ///EpisodeID
	s RUserID=$p(mListData,"^",2)     ///申请医生
	s RLocID=$p(mListData,"^",3)      ///申请科室
	s ResType=$p(mListData,"^",4)     ///呼吸类型
	s Enabled="Y"					  ///是否可用
	s RDate=+$H   		              ///申请日期
	s RTime=$p($H,",",2)              ///申请时间
	&SQL(Insert Into DHC_EmWaitToHos(EW_Adm_Dr,EW_RLoc_Dr,EW_ResType,EW_RDate,EW_RTime,EW_RUser_Dr,EW_Enabled)
		values(:EpisodeID,:RLocID,:ResType,:RDate,:RTime,:RUserID,:Enabled))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descritp:  修改登记主表
ClassMethod UpdWaitMas(WtID As %String, mListData As %String) As %String
{
	n (WtID, mListData)
	s ResType=$p(mListData,"^",4)     ///呼吸类型
	&SQL(update  DHC_EmWaitToHos set EW_ResType=:ResType where EW_RowID=:WtID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descritp:  插入待入院子表
ClassMethod InsWaitItm(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s Len = $L(mListData,"@")
	s quitflag=0
	F i=1:1:Len Q:quitflag'="0"  D
	.s ListData=$p(mListData,"@",i)  /// 项目列表
	.s LocID=$p(ListData,"^",1)      /// 会诊科室
	.Q:LocID=""
	.s CsRes=$p(ListData,"^",2)      /// 要求会诊医生
	.s WardID=$p(ListData,"^",3)     /// 会诊病区
	.s arChildSub=$o(^DHCEMWH(arParref,"I",""),-1)+1
	.
	.&SQL(Insert Into DHC_EmWaitToHosItm(EW_ParRef_Dr,EW_ChildSub,EW_Loc_Dr,EW_CsRes,EW_Ward_Dr)
		values(:arParref,:arChildSub,:LocID,:CsRes,:WardID))
	.i SQLCODE'=0 s quitflag="1"
	Q quitflag
}

/// Descript: 删除待入院子表和关联表数据
/// w ##Class(web.DHCEMWaitToHosPat).DelWaitMasSubTable("24")
ClassMethod DelWaitMasSubTable(WtID) As %String
{
	n (WtID)
	
	s SQLCODE=0
	///  会诊子表
	i $o(^DHCEMWH(WtID,"I","")) D
	.&SQL(delete from DHC_EmWaitToHosItm where EW_ParRef_Dr=:WtID)
	Q:SQLCODE'=0 SQLCODE
	
	Q SQLCODE
}

/// Descript:  设置急诊待入院管理
/// w ##Class(web.DHCEMWaitToHosPat).delWaitToHos("24")
ClassMethod delWaitToHos(WtID As %String, mRemark As %String) As %String
{
	n (WtID, mRemark)
	s Enabled="N"
	&SQL(update DHC_EmWaitToHos set EW_Enabled=:Enabled, EW_DelReason=:mRemark where EW_RowID=:WtID)
	Q SQLCODE
}

/// Descript:  获取病人待入院登记信息
/// W ##Class(web.DHCEMWaitToHosPat).GetWaitHosPatInfo("0000000012")
ClassMethod GetWaitHosPatInfo(WtID As %String) As %String
{
	n (WtID,%session)
	Q:'$D(^DHCEMWH(WtID)) ""
	s EpisodeID=$p(^DHCEMWH(WtID),"^",1)   /// 就诊ID
	s ListData=..GetPatEssInfo("",EpisodeID)
	s ResType=$p(^DHCEMWH(WtID),"^",8)   /// 呼吸类型
	s ListData=ListData_"^"_WtID_"^"_ResType
	s CH="",LocListArr=""
	F  s CH=$o(^DHCEMWH(WtID,"I",CH)) Q:CH=""  D
	.s InLoc=$p(^DHCEMWH(WtID,"I",CH),"^",1)
	.s CsRes=$p(^DHCEMWH(WtID,"I",CH),"^",2)
	.s InWard=$p(^DHCEMWH(WtID,"I",CH),"^",3)
	.S Ward=""
	.I InWard'="" s Ward=$p($g(^CTLOC(InWard)),"^",2)  /// 拟入院病区 
	.s ListData=ListData_"^"_InLoc_"^"_CsRes_"^"_InWard_"^"_Ward
	s ListTitle="PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatBDay^PatDiags^PatType^PatSLv^PatLv^mradm^PatBed^BillType^LvDate^LvTime^AdmDays^PatDoc^WtID^ResType^InLoc_1^CsRes_1^InWard_1^Ward_1^InLoc_2^CsRes_2^InWard_2^Ward_2^InLoc_3^CsRes_3^InWard_3^Ward_3"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descript:  获取病人基本就诊信息
/// W ##Class(web.DHCEMWaitToHosPat).GetPatBaseInfo("0000000043")
ClassMethod GetPatBaseInfo(PatientNo As %String, LgHospID = "") As %String
{
	n (PatientNo,LgHospID,%session)
	s PatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
	i PatientID="" w ##Class(web.DHCAPPJsonCommon).getJsonData("ErrCode^ErrMsg","-1^登记号有误")
	Q:PatientID="" ""
	s TEpisodeID=##class(web.DHCEMInComUseMethod).GetPatObsingAdm(PatientID)
	i TEpisodeID="" w ##Class(web.DHCAPPJsonCommon).getJsonData("ErrCode^ErrMsg","-2^病人非留观病人")
	Q:TEpisodeID="" ""
	s DepCodeDR=$p(^PAADM(TEpisodeID),"^",4) //hxy 2020-06-02 st
	s HospDr=$p($g(^CTLOC(+DepCodeDR)),"^",22)
	i (LgHospID'="")&(LgHospID'=HospDr)  w ##Class(web.DHCAPPJsonCommon).getJsonData("ErrCode^ErrMsg","-4^非本院留观患者")
	Q:(LgHospID'="")&(LgHospID'=HospDr) "" //ed
	s isFlag=..isExistWaitToHos(TEpisodeID) /// 当前病人是否存在申请记录
	i +isFlag=1 w ##Class(web.DHCAPPJsonCommon).getJsonData("ErrCode^ErrMsg","-3^当前病人已经存在待入院管理记录，添加时间为:"_$p(isFlag,"^",2))
	Q:+isFlag=1 ""
	s IsDeathFalg = ##class(web.DHCEMNurExecImg).GetPatIsDeath(TEpisodeID)
	i +IsDeathFalg=1 w ##Class(web.DHCAPPJsonCommon).getJsonData("ErrCode^ErrMsg","-4^当前患者已故,请核实患者状态")
	Q:+IsDeathFalg=1 ""
	
	s ListData=..GetPatEssInfo(PatientID,TEpisodeID)
	s ListTitle="PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatBDay^PatDiags^PatType^PatSLv^PatLv^mradm^PatBed^BillType^LvDate^LvTime^AdmDays^PatDoc"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descript:  获取病人基本就诊信息
/// W ##Class(web.DHCEMWaitToHosPat).GetPatEssInfo("","2")
ClassMethod GetPatEssInfo(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID,%session)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	s PatSex=""
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)  /// 出生日期
	i PatBDay'="" s PatBDay=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(PatBDay)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID,"","","","Y") /// 诊断
	i $L(PatDiag)>80 s PatDiag=$E(PatDiag,1,80)_"..."
	s PatType=$p(^PAADM(EpisodeID),"^",2) 	           /// 就诊类型
	s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,"")
 	s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	s PatLevel=$p(EncryptLevelInfo,"^",2)
 	s mradm=$p(^PAADM(EpisodeID),"^",61)          	   /// 就诊类型
	s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)    /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s PatDoc=""
	s AdmDocID=$p(^PAADM(EpisodeID),"^",9)             /// 医生
	s:AdmDocID'="" PatDoc=$p($g(^CTPCP(AdmDocID,1)),"^",2)
	s EmPLvDate="",EmPLvTime="",AdmDays=""
	s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",+EpisodeID,""),-1) /// 分诊ID
	s AdmDays=+##class(web.DHCDoc.OP.AjaxInterface).GetPatAdmDays(+EpisodeID) //_"天"
	s LvDate = $p(^PAADM(EpisodeID),"^",6)
	i LvDate'="" s LvDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(LvDate)
	s LvTime=$p(^PAADM(EpisodeID),"^",7) 
	s:LvTime'="" LvTime=$zt(LvTime,2)
	i EmPCLvID'="" D
	.;s LvDate=$p(^DHCEMPCL(EmPCLvID),"^",4)   /// 分诊日期
	.;s AdmDays=+$H-LvDate_"天"                /// 来诊天数
	.;i LvDate'="" s LvDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(LvDate)
	.;s LvTime=$p(^DHCEMPCL(EmPCLvID),"^",5)   /// 分诊时间
	.;s:LvTime'="" LvTime=$zt(LvTime,2)
	.
	s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex) //hxy 2022-12-13
	s PatDoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",PatDoc) 
	s ListData=PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_$g(PatSex)_"^"_PatAge_"^"_PatBDay_"^"_PatDiag_"^"_PatType_"^"_EncryptLevel_"^"_PatLevel_"^"_mradm_"^"_PatBed_"^"_BillType
	s ListData=ListData_"^"_$g(LvDate)_"^"_$g(LvTime)_"^"_$g(AdmDays)_"^"_PatDoc
	q ListData
}

/// Descript: 取待入院管理数据
/// w ##Class(web.DHCEMWaitToHosPat).JsGetWaitToHosPatObj("24")
ClassMethod JsGetWaitToHosPatObj(WtID) As %String
{
	n (WtID)
	Q:'$D(^DHCEMWH(WtID)) ""
	s EpisodeID=$p(^DHCEMWH(WtID),"^",1)   /// 就诊ID
	s RLocID=$p(^DHCEMWH(WtID),"^",2)      /// 申请科室
	s RLocDesc=""
	s:RLocID'="" RLocDesc=$p(^CTLOC(RLocID),"^",2)
	s RDate=$p(^DHCEMWH(WtID),"^",3)       /// 申请日期
	s:RDate'="" CstRDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)
	s RTime=$p(^DHCEMWH(WtID),"^",4)       /// 申请时间
	s:RTime'="" CstRTime=$zt(CstRTime,1)
	s RUser=""
	s UserID=$p(^DHCEMWH(WtID),"^",5)      /// 申请医生
	s:UserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	
    s ListData=EpisodeID_"^"_RLocID_"^"_RLocDesc_"^"_RDate_"^"_RTime_"^"_UserID_"^"_User
	s ListTitle="EpisodeID^RLocID^RLocDesc^CstRDate^CstRTime^UserID^User"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descript: 取待入院管理数据
/// w ##Class(web.DHCEMWaitToHosPat).JsGetWaitToHosPatList("10","1","")
ClassMethod JsGetWaitToHosPatList(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params,%session)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=+$H-1
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=+$H
	s argLocID=$p(Params,"^",3)  /// 登记科室
	s aPatName=$p(Params,"^",4)  /// 病人姓名
	s aPatNo=$p(Params,"^",5)    /// 登记号
	s aEmPcLv=$p(Params,"^",6)   /// 当前级别
	s WalkStatus=$p(Params,"^",7) /// 病人状态
	s LgHospID=$p(Params,"^",8) /// 病人状态 //hxy 2020-06-03
	
    s Num=0
	F dd=StartDate:1:EndDate D
	.s WtID=""
	.F  s WtID=$o(^DHCEMWH(0,"CreateDate",dd,WtID)) Q:WtID=""  D
	..Q:$p(^DHCEMWH(WtID),"^",6)'="Y"
	..s EpisodeID=$p(^DHCEMWH(WtID),"^",1)        /// 就诊ID
	../// 病人信息
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..Q:(aPatName'="")&(PatName'[aPatName)
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..Q:(aPatNo'="")&(PatNo'=aPatNo)
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..;s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) ///年龄
	..s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID)
	..s PatLoc=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	..;Q:(argLocID'="")&(argLocID'=PatLocID)
	..s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	..s PatWard=""
	..s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	           /// 病区ID
	..s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	..s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	..s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
    ..s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
    ..i PatBed="" D
    ...s PatBed=$p(^PAADM(EpisodeID),"^",73) 		      /// 床号
	...i PatBed'="" s PatBed=$p(^PAWARD($p(PatBed,"||",1),"BED",$p(PatBed,"||",2)),"^",1)
    ..s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话 
	..s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	 /// 家庭住址
	..s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	..i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	..s MedicareNo=##Class(web.DHCEMCommonUtil).GetMrNo(EpisodeID) /// 病案号
	..s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID,"","","","Y")       /// 诊断
	..s RLocID=$p(^DHCEMWH(WtID),"^",2)     /// 申请科室
	..Q:(argLocID'="")&(argLocID'=RLocID)
	..s CurHospID=$p($g(^CTLOC(+RLocID)),"^",22) //hxy 2020-06-03 申请科室为登录科室
	..q:CurHospID'=LgHospID //ed
	..s RLocDesc=""
	..s:RLocID'="" RLocDesc=$p(^CTLOC(RLocID),"^",2)
	..s RDate=$p(^DHCEMWH(WtID),"^",3)    /// 申请日期
	..s:RDate'="" RDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(RDate)
	..s RTime=$p(^DHCEMWH(WtID),"^",4)    /// 申请时间
	..s:RTime'="" RTime=$zt(RTime,1)
	..s UserID=$p(^DHCEMWH(WtID),"^",5)   /// 申请医生
	..s RUser=$p($g(^SSU("SSUSR",UserID)),"^",2)
	..s PatDoc=""
	..s AdmDocID=$p(^PAADM(EpisodeID),"^",9)             /// 医生
	..s:AdmDocID'="" PatDoc=$p($g(^CTPCP(AdmDocID,1)),"^",2)
	..s EmPLvDate="",EmPLvTime="",AdmDays="",LvDate="",LvTime="",EmNurLev="",TmpLvDate="",TmpLvTime=""
	..s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",+EpisodeID,""),-1) /// 分诊ID
	..i EmPCLvID'="" D
	...s LvDate=$p(^DHCEMPCL(EmPCLvID),"^",4)   /// 分诊日期
	...s TmpLvDate=LvDate
	...s AdmDays=+$H-LvDate_"天"                /// 来诊天数
	...i LvDate'="" s LvDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(LvDate)
	...s LvTime=$p(^DHCEMPCL(EmPCLvID),"^",5)   /// 分诊时间
	...s TmpLvTime=LvTime
	...s:LvTime'="" LvTime=$zt(LvTime,2)
	...s EmNurLev=##Class(web.DHCEMDocMainOutPat).GetEmPatCheckLev(EpisodeID)      /// 分级
	..s EmCurLev=""
	..s Priority=$P($g(^PAADM(EpisodeID)),"^",33) /// 当前级别
	..i Priority'="" s EmCurLev=$p($g(^CT("ACU",+Priority)),"^",1)
	..i +EmCurLev=0 s EmCurLev=""
	..Q:(aEmPcLv'="")&(aEmPcLv'=+EmCurLev)
	..s CH="",LocListArr=""
	..F  s CH=$o(^DHCEMWH(WtID,"I",CH)) Q:CH=""  D
	...s InLoc=$p(^DHCEMWH(WtID,"I",CH),"^",1)
	...s InLoc=$p(^CTLOC(InLoc),"^",2)  /// 拟入院科室
	...s InLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",InLoc) 
	...s CsRes=$p(^DHCEMWH(WtID,"I",CH),"^",2)
	...s WardDr=$p(^DHCEMWH(WtID,"I",CH),"^",3)   //拟入院病区
	...S InWard=""
	...I WardDr'="" s InWard=$p($g(^CTLOC(WardDr)),"^",2)  /// 拟入院病区
	...s:InWard'="" InWard=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",InWard) 
#;	...s CsRes=$s(CsRes="N":"未会诊",CsRes="A":"同意",CsRes="W":"待定",CsRes="M":"多科会诊决定",1:"")  /// 拟入院科室
	...s LocListArr=$s(LocListArr="":InLoc_"^"_CsRes_"^"_InWard,1:LocListArr_"^"_InLoc_"^"_CsRes_"^"_InWard)
	..s PatStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(EpisodeID)          /// 当前状态
	..Q:(WalkStatus'="")&(WalkStatus'=$P(PatStatus,"^",1))
	..i PatStatus'="" s PatStatus=$P(PatStatus,"^",2)
	..//s StrTime=##class(web.DHCEMPatOverview).getPatKeepTime(EpisodeID)  //滞留时间
	..s StrTime=..GetPatKeepTimeDay(EpisodeID) /// 就诊天数
	..S ResType=$p(^DHCEMWH(WtID),"^",8)                                 //呼吸类型
	..;s ResType=$s(ResType="1":"有创",ResType="2":"无创",ResType="3":"鼻导管",ResType="4":"无",1:"")  //呼吸类型
	..s PatWard=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",PatWard) //hxy 2022-12-13
	..s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	..s PatDoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",PatDoc)
	..s RLocDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",RLocDesc) //ed
	..s Num=Num+1
	..s ListData=WtID_"^"_PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatWard_"^"_PatBed_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	..s ListData=ListData_"^"_RLocDesc_"^"_BillType_"^"_MedicareNo_"^"_PatDiag_"^"_RDate_"^"_RTime_"^"_RUser_"^"_LvDate_" "_LvTime_"^"_AdmDays_"^"_PatDoc_"^"_EmNurLev_"^"_EmCurLev
	..s ListData=ListData_"^"_PatStatus_"^"_StrTime_"^"_ResType_"^"_LocListArr
	..s index=$p(LocListArr,"^",1)_"^"_sexId_"^"_TmpLvDate_"^"_TmpLvTime_"^"_Num
	..s TMPListData(index)=ListData
	..
	
	i Num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	
	s ListTitle="WtID^PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^PatWard^PatBed^PatTelH^PatBod^PatAddr"
	s ListTitle=ListTitle_"^RLocDesc^BillType^MedicareNo^PatDiag^RDate^RTime^RUser^LvDate^AdmDays^PatDoc^EmNurLev^EmCurLev"
	s ListTitle=ListTitle_"^PatStatus^StrTime^ResType^InLoc_1^CsRes_1^InWard_1^InLoc_2^CsRes_2^InWard_2^InLoc_3^CsRes_3^InWard_3"

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
}

/// Descript: 取指定病人待入院数据
/// w ##Class(web.DHCEMWaitToHosPat).GetPatWaitToHos("")
ClassMethod GetPatWaitToHos(EpisodeID As %String) As %String
{
	n (EpisodeID,%session)
	s WtID="",LocListArr=""
	F  s WtID=$o(^DHCEMWH(0,"ADM",EpisodeID,WtID)) Q:WtID=""  D
	.Q:$p(^DHCEMWH(WtID),"^",6)'="Y"
	.s CH=""
	.F  s CH=$o(^DHCEMWH(WtID,"I",CH)) Q:CH=""  D
	..s InLoc=$p(^DHCEMWH(WtID,"I",CH),"^",1)
	..Q:InLoc=""
	..s InLoc=$p(^CTLOC(InLoc),"^",2)  /// 拟入院科室
	..s CsRes=$p(^DHCEMWH(WtID,"I",CH),"^",2)
	..s CsRes=$s(CsRes="N":"未会诊",CsRes="A":"同意",CsRes="W":"待定",CsRes="M":"多科会诊决定",1:"")  /// 拟入院科室
	..s CsRes=##class(web.DHCEMCommonUtil).GetTrans("dhcem.bedsideshiftsdoc.csp",CsRes)
	..s InLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",InLoc)
	..s LocListArr=$s(LocListArr="":InLoc_"："_CsRes,1:LocListArr_"；"_InLoc_"："_CsRes)
	.
	Q LocListArr
}

/// Descript: 当前病人是否存在申请记录
/// w ##Class(web.DHCEMWaitToHosPat).isExistWaitToHos("")
ClassMethod isExistWaitToHos(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s WtID="", isFlag=0,RTime="" 
	F  s WtID=$o(^DHCEMWH(0,"ADM",EpisodeID,WtID)) Q:(WtID="")||(isFlag=1)  D
	.Q:$p(^DHCEMWH(WtID),"^",6)'="Y"
	.s RTime=$p(^DHCEMWH(WtID),"^",3)       /// 申请日期
	.s isFlag=1
	s:RTime'="" RTime=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(RTime)
 	Q isFlag_"^"_RTime
}

/// Descript: 已就诊天数
/// w ##class(web.DHCEMWaitToHosPat).GetPatKeepTime(140000491)
ClassMethod GetPatKeepTime(EpisodeID As %String) As %String
{
	n (EpisodeID)
	Q:EpisodeID="" ""
	s LvDate = $p(^PAADM(EpisodeID),"^",6)
	s LvTime = $p(^PAADM(EpisodeID),"^",7)
	;s LvDate="",LvTime=""
	;s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",+EpisodeID,""),-1) /// 分诊ID
	;i EmPCLvID'="" D
	;.s LvDate=$p(^DHCEMPCL(EmPCLvID),"^",4)   /// 分诊日期
	;.s LvTime=$p(^DHCEMPCL(EmPCLvID),"^",5)   /// 分诊时间
	;.
	s AdmTime=((+$H-LvDate)*24)+(($p($h,",",2)-LvTime)\(60*60))
	i AdmTime<24 d
	.s AdmTime = AdmTime_"小时"
	e  d
	.s AdmTime = AdmTime\24_"天"
	Q AdmTime
}

/// Descript: 已就诊天数：当天算一天
/// w ##class(web.DHCEMWaitToHosPat).GetPatKeepTime(140000491)
ClassMethod GetPatKeepTimeDay(EpisodeID As %String) As %String
{
	n (EpisodeID)
	Q:EpisodeID="" ""
	s LvDate = $p(^PAADM(EpisodeID),"^",6)
	s LvTime = $p(^PAADM(EpisodeID),"^",7)
	s AdmTime=((+$H-LvDate)*24)+(($p($h,",",2)-LvTime)\(60*60))
	s AdmTime = AdmTime\24+1 //_"天"
	Q AdmTime
}

/// Descritp:	科室
/// w ##Class(web.DHCEMWaitToHosPat).JsonLoc(2)
ClassMethod JsonLoc(q As %String = "", HospID As %String, Type As %String) As %String
{
	n (q, HospID, Type,%session)

	s input=q 
	s input=$ZCVT(input,"U")
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT CTLOC_ROWID as locDr,CTLOC_DateActiveTo as DateActiveTo,CTLOC_DESC as locDesc,CTLOC_Hospital_DR as HospitalId FROM CT_LOC"
	i input'=""  d
	.s sqlStr=sqlStr_" WHERE UPPER(CTLOC_ContactName) LIKE """_""_input_""_"%"_""" OR CTLOC_Desc LIKE """_""_input_""_"%"_""_""" "

    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s curDate=$p(($h),",",1)
	w "["
	While(result.Next())
	{	
		s locDr = result.Data("locDr")
		s locDesc = result.Data("locDesc")
		s DateActiveTo=result.Data("DateActiveTo")
		i DateActiveTo'="" continue:DateActiveTo<curDate //过期退出
		continue:(HospID'="")&(HospID'=$p(^CTLOC(locDr),"^",22))
		continue:(locDesc["停")||(locDesc["工作量")
		continue:'$D(^PAC("ADMLOC",0,"AdmType",Type,locDr))
		s locDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",locDesc) //hxy 2022-12-13
		s tmp=locDr_"^"_locDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

Storage Default
{
<Data name="DHCEMWaitToHosPatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMWaitToHosPatD</DataLocation>
<DefaultData>DHCEMWaitToHosPatDefaultData</DefaultData>
<IdLocation>^web.DHCEMWaitToHosPatD</IdLocation>
<IndexLocation>^web.DHCEMWaitToHosPatI</IndexLocation>
<StreamLocation>^web.DHCEMWaitToHosPatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
