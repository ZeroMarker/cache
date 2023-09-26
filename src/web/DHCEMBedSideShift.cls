Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2018-01-04
/// Descript: 	急诊床旁交班业务类
Class web.DHCEMBedSideShift Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descritp:  插入急诊床旁交班表
/// Input:     mListData-登记内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMBedSideShift).Insert("","^55^早班^2019-11-05^DOC^10209","")
ClassMethod Insert(BsID As %String, mParams As %String, Pid As %String) As %String
{
	n (BsID, mParams, Pid)
	s Err=0
	i BsID="" s Err=..isExist(mParams)   /// 判断重复
	Q:Err'=0 Err
	k TmpArr
	//D ..GetWardPat(mParams, .TmpArr)   /// 提取交班数据
	D ..GetLinkItem(mParams, .TmpArr)    /// 提取交班关联项数据
	i BsID="" D
	.s BsID=..InsBedMas(mParams, .TmpArr)
	Q BsID
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-01-04
/// Descritp:    插入交班表
/// Input:       mListData-交班内容
/// Ouput:       申请单ID
/// w ##Class(web.DHCEMBedSideShift).InsBedMas("")
ClassMethod InsBedMas(mListData As %String, TmpArr As %String) As %String
{
	N (mListData, TmpArr)
	s Err=0
	TS

	/// 插入交班主表
	s BsID=..InsBedShiftMas(mListData)
	i BsID<0 tro
	Q:BsID<0 BsID

	/// 插入交班子表
	s index=""
	F  s index=$o(TmpArr("Pat",index)) Q:(index="")||(Err'=0)  D
	.s mListData=$g(TmpArr("Pat",index))
	.Q:mListData=""
	.s Err=..InsBedItem(BsID, mListData)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 插入关联项目
	s mListData=$g(TmpArr("LinkItem"))
	s Err=..InsLinkItem(BsID, mListData)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	TC
	Q BsID
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-01-04
/// Descritp:    修改交班表
/// Input:       mListData-登记内容
/// Ouput:       申请单ID
/// w ##Class(web.DHCEMBedSideShift).UpdBedMas("")
ClassMethod UpdBedMas(BsID As %String, mListData As %String) As %String
{
	N (BsID, mListData)
	s Err=0
	TS

	/// 修改交班主表
	s BsID=..UpdBedShiftMas(BsID,mListData)
	i BsID<0 tro
	Q:BsID<0 BsID

#;	/// 删除相关字表内容重新插入
#;	s Err=..DelMasSubTable(BsID)
#;	i Err'=0 tro
#;	Q:Err'=0 "-11"
#;	
#;	/// 插入交班子表
#;	s ListData=$p(mListData,"^",6)
#;	s Err=..InsBedItem(BsID, ListData)
#;	i Err'=0 tro
#;	Q:Err'=0 "-12"
	
	TC
	Q BsID
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-01-04
/// Descritp:    插入交班主表
ClassMethod InsBedShiftMas(mListData As %String) As %String
{
	n (mListData)
	s MedGrpID=$p(mListData,"^",1)   /// 医疗组
	s WardID=$p(mListData,"^",2)     /// 留观区ID
	s Schedule=$p(mListData,"^",3)   /// 班次
	s WrDate=$p(mListData,"^",4)     /// 交班日期
	s Type=$p(mListData,"^",5)       /// 交班类型
	s UserID=$p(mListData,"^",6)     /// 交班人员ID
	s CompFlag="N"

	i WrDate'="" s WrDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(WrDate)
	s CrDate=+$H   		             /// 创建日期
	s CrTime=$p($H,",",2)            /// 创建时间
	
	&SQL(Insert Into DHC_EmBedSideShift(EM_WrDate,EM_Ward_Dr,EM_Schedule,EM_Type,EM_User_Dr,EM_MedGrp_ID,EM_CrDate,EM_CrTime,EM_CompFlag)
		values(:WrDate,:WardID,:Schedule,:Type,:UserID,:MedGrpID,:CrDate,:CrTime,:CompFlag))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-01-04
/// Descritp:    修改交班主表
ClassMethod UpdBedShiftMas(BsID As %String, mListData As %String) As %String
{
	n (BsID, mListData)
	s WrDate=$p(mListData,"^",1)     /// 交班日期
	s WardID=$p(mListData,"^",2)     /// 交班病区ID
	s Schedule=$p(mListData,"^",3)   /// 班次
	i WrDate'="" s WrDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(WrDate)
	&SQL(Update DHC_EmBedSideShift Set EM_Ward_Dr=:WardID,EM_Schedule=:Schedule,EM_WrDate=:WrDate Where EM_RowID=:BsID)
	Q BsID
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-01-04
/// Descritp:    插入交班子表
ClassMethod InsBedItem(BsID As %String, mListData As %String) As %String
{
	n (BsID, mListData)
	s Err=0
	s EpisodeID=$p(mListData,"^",1) /// 就诊ID
	Q:$d(^DHCEMBSS(0,"ADM",EpisodeID,BsID)) "-1"
	s BedID=$p(mListData,"^",2)     /// 床号ID
	s arChildSub=$o(^DHCEMBSS(BsID,"I",""),-1)+1
	
	&SQL(Insert Into DHC_EmBedSideShiftItem(EM_ParRef_Dr,EM_ChildSub,EM_Adm_Dr,EM_Bed_Dr)
		values(:BsID,:arChildSub,:EpisodeID,:BedID))
	i SQLCODE'=0 s Err="1"
	Q Err
}

/// Creator: 	 bianshuai
/// CreateDate:  2020-03-09
/// Descritp:    插入交班子表
ClassMethod isPatExist(BsID As %String, EpisodeID As %String, Pid As %String) As %String
{
	n (BsID, EpisodeID, Pid)
	Q:'$D(^TMP("DHCEM","web.DHCEMBedSideShift","XH",Pid,BsID_"^"_EpisodeID)) 0
	Q 1
}

/// Creator: 	 bianshuai
/// CreateDate:  2020-03-09
/// Descritp:    插入交班子表
ClassMethod InsPatToShift(BsID As %String, mListData As %String, Pid As %String) As %String
{
	n (BsID, mListData, Pid)
	s EpisodeID=$p(mListData,"^",1)      /// 就诊ID
	Q:..isPatExist(BsID, EpisodeID, Pid) "-1"
	s Err=..InsBedItem(BsID, mListData)  /// 插入交班子表
	Q Err
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-01-04
/// Descritp:    保存交班内容
ClassMethod InsPatShiftItem(BsItmID As %String, mListData As %String) As %String
{
	n (BsItmID, mListData)
	s Err=0
	s bsBackground=$p(mListData,"^",1) /// 背景 生命体征
	s bsAssessmen=$p(mListData,"^",2)  /// 评估
	s bsSuggest=$p(mListData,"^",3)    /// 建议
	&SQL(Update DHC_EmBedSideShiftItem Set EM_VitalSign=:bsBackground,EM_Contents=:bsAssessmen,EM_Suggest=:bsSuggest where EM_RowID=:BsItmID)
	//Q SQLCODE
	Q %ROWID
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-01-04
/// Descritp:    插入交班子表
ClassMethod InsBsItem(BsID As %String, mListData As %String) As %String
{
	n (BsID, mListData)
	s Err=0
	s bsBackground=$p(mListData,"^",1) /// 背景 生命体征
	s bsAssessmen=$p(mListData,"^",2)  /// 评估
	s bsSuggest=$p(mListData,"^",3)    /// 建议
	s EpisodeID=$p(mListData,"^",4)    /// 就诊ID
	s BedID=$P($g(^PAADM(EpisodeID)),"^",73) /// 床号ID
	s arChildSub=$o(^DHCEMBSS(BsID,"I",""),-1)+1
	
	&SQL(Insert Into DHC_EmBedSideShiftItem(EM_ParRef_Dr,EM_ChildSub,EM_Adm_Dr,EM_Bed_Dr,EM_VitalSign,EM_Contents,EM_Suggest)
		values(:BsID,:arChildSub,:EpisodeID,:BedID,:bsBackground,:bsAssessmen,:bsSuggest))
	i SQLCODE'=0 s Err="1"
	Q %ROWID
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-01-04
/// Descritp:    插入交班表
/// Input:       mListData-交班内容
/// Ouput:       申请单ID
/// w ##Class(web.DHCEMBedSideShift).saveBsItem("")
ClassMethod saveBsItem(BsID As %String, BsItmID As %String, mListData As %String) As %String
{
	n (BsID, BsItmID, mListData)
	s Err=0
	/// 插入交班主表
	i BsItmID'="" D
	.s BsItmID=..InsPatShiftItem(BsItmID, mListData)
	E  D
	.s BsItmID=..InsBsItem(BsID, mListData)
	Q BsItmID
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-01-04
/// Descript:    删除子表和关联表数据
/// w ##Class(web.DHCEMBedSideShift).DelMasSubTable("24")
ClassMethod DelMasSubTable(BsID As %String) As %String
{
	n (BsID)
	
	s SQLCODE=0
	///  交班子表
	i $o(^DHCEMBSS(BsID,"I","")) D
	.&SQL(delete from DHC_EmBedSideShiftItem where EM_ParRef_Dr=:BsID)
	Q:SQLCODE'=0 SQLCODE
	
	Q SQLCODE
}

/// Descript: 删除交班记录表
/// w ##Class(web.DHCEMBedSideShift).DelBedSideShift("24")
ClassMethod DelBedSideShift(BsID As %String) As %String
{
	n (BsID)
	&SQL(delete from DHC_EmBedSideShift where EM_RowID=:BsID)
	Q SQLCODE
}

/// Descript: 删除子表
/// w ##Class(web.DHCEMBedSideShift).DelBsPat("24")
ClassMethod DelBsPat(bsItemID As %String) As %String
{
	n (bsItemID)
	&SQL(delete from DHC_EmBedSideShiftItem where EM_RowID=:bsItemID)
	Q SQLCODE
}

/// Descript: 删除关联项目表
/// w ##Class(web.DHCEMBedSideShift).DelBsLinkItem("24")
ClassMethod DelBsLinkItem(BsID As %String) As %String
{
	n (BsID)
	///  交班子表
	i $o(^DHCEMSLI(0,"Parref",BsID,"")) D
	.&SQL(delete from DHC_EmShiftLinkItem where EM_ParRef_Dr=:BsID)
	Q:+$g(SQLCODE)'=0 SQLCODE
	Q 0
}

/// Descript:  删除交班记录
/// w ##Class(web.DHCEMBedSideShift).deleteBs("24")
ClassMethod deleteBs(BsID As %String) As %String
{
	n (BsID)
	s Err=0
	
	TS
	/// 删除交班
	s Err=..DelBedSideShift(BsID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 删除关联项目
	s Err=..DelBsLinkItem(BsID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	TC
	Q Err
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-11-13
/// Descritp:    交班确认
/// Input:       BsID - 交班ID, mListData - 关联项目
/// Ouput:       申请单ID
/// w ##Class(web.DHCEMBedSideShift).InsBsSure("13","^T38@45#T39@5#T40@6#T41@6")
ClassMethod InsBsSure(BsID As %String, mListData As %String) As %String
{
	n (BsID, mListData)

	s Err=0
	/// 是否允许交班确认
	Q:..IsPermitSure(BsID) "-1"
	
	TS

	/// 修改工作量主表
	s Err=..SureComplete(BsID, mListData)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 删除关联项目重新插入
	s Err=..DelBsLinkItem(BsID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 插入关联项目
	s ListData=$p(mListData,"^",2)
	s Err=..InsLinkItem(BsID, ListData)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	TC
	Q Err
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-11-13
/// Descritp:    是否允许交班确认
/// InPut:       BsID - 交班ID
/// OutPut:      0-允许, 1-不允许
/// W ##Class(web.DHCEMBedSideShift).IsPermitSure("12")
ClassMethod IsPermitSure(BsID As %String) As %String
{
	n (BsID)
	Q:'$D(^DHCEMBSS(BsID,"I")) 1
	s CH=0, WriFlag=0
	F  s CH=$O(^DHCEMBSS(BsID,"I",CH)) Q:(CH="")||(WriFlag=1)  D
	.s bsBackground=$P(^DHCEMBSS(BsID,"I",CH),"^",4)  /// 生命体征
	.s bsAssessment=$P(^DHCEMBSS(BsID,"I",CH),"^",5)  /// 交班内容
	.s bsSuggest=$p(^DHCEMBSS(BsID,"I",CH),"^",10)    /// 建议
	.Q:(bsBackground'="")||(bsAssessment'="")||(bsSuggest'="")
	.s WriFlag=1
	Q WriFlag
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-11-13
/// Descritp:    签名验证
/// InPut:       userName - 姓名，passWord - 密码
/// OutPut:      0-成功, 其他-失败
/// W ##Class(web.DHCEMBedSideShift).IsValPassWord("105732","1")
ClassMethod IsValPassWord(userCode As %String, passWord As %String, recUserCode = "", recPassWord = "", lgHospID = "") As %String
{
	n (userCode, passWord,recUserCode,recPassWord,lgHospID,%session)
	s ret=##Class(web.DHCEMSkinTest).ConfirmPassWord(userCode, passWord)
	q:$p(ret,"^")'=0 "交班人"_ret

	s isHasThisHospManag=##class(web.DHCEMCommonUtil).UserIsHasThisHospManag(recUserCode,"",lgHospID)
	q:isHasThisHospManag'="Y" "接班人没有当前院区的登录权限!"
	s ret=##Class(web.DHCEMSkinTest).ConfirmPassWord(recUserCode, recPassWord)
	q:$p(ret,"^")'=0 "接班人"_ret
	q 0
}

/// Creator: 	 bianshuai
/// CreateDate:  2020-02-21
/// Descritp:    验证接班人是否填写正确
/// InPut:       userName - 姓名
/// OutPut:      其他-成功, 空-失败
/// W ##Class(web.DHCEMBedSideShift).IsValAccUser("105732")
ClassMethod IsValAccUser(userName As %String) As %String
{
	n (userName)
	s userID=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(userName),""))
	Q userID
}

/// Descritp:  确认完成
ClassMethod SureComplete(BsID As %String, mListData As %String) As %String
{
	n (BsID, mListData)
	s RecUserCode=$p(mListData,"^",1)
	s RecUserId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(RecUserCode),""))
	s CompFlag="Y"
	&SQL(Update DHC_EmBedSideShift Set EM_RecUser_Dr=:RecUserId, EM_CompFlag=:CompFlag Where EM_RowID=:BsID)
	Q SQLCODE
}

/// Descritp:  插入关联项目
ClassMethod InsLinkItem(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s Len = $L(mListData,"#")
	s quitflag=0
	F i=1:1:Len Q:quitflag'="0"  D
	.s mdata=$p(mListData,"#",i) /// 项目列表
	.s ItemID=$p(mdata,"@",1)    /// 项目ID
	.s ItemID=$tr(ItemID,"T","")
	.s ItemVal=$p(mdata,"@",2)   /// 项目值
	.Q:ItemVal=""
	.
	.&SQL(Insert Into DHC_EmShiftLinkItem(EM_ParRef_Dr,EM_Item_Dr,EM_ItemVal)
		values(:arParref,:ItemID,:ItemVal))
	.i SQLCODE'=0 s quitflag="1"
	Q quitflag
}

/// Descript: 急诊留观病区病人列表
/// w ##class(web.DHCEMBedSideShift).GetEmPatList("30","1","15")
ClassMethod GetEmPatList(rows As %String, page As %String, Params As %String) As %String
{
	n (rows, page, Params,%session)
	s BsID=$p(Params,"^",1)  /// 交班子表ID
	i $p($g(^DHCEMBSS(+BsID)),"^",10)="Y" D
	.D ..GetEmShiftPatList(rows, page, Params)
	E  D
	.D ..GetEmWardPatList(rows, page, Params)
	Q ""
}

/// Descript: 急诊交班病人列表
/// w ##class(web.DHCEMBedSideShift).GetEmShiftPatList("30","1","5")
ClassMethod GetEmShiftPatList(rows As %String, page As %String, Params As %String) As %String
{
	n (rows, page, Params,%session)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	
	k TMPArrList
	s BsID=+$p(Params,"^",1) /// 交班子表ID
	s CH=0,TotalNum=0,del=""""
	F  s CH=$O(^DHCEMBSS(BsID,"I",CH)) Q:CH=""  D
	.Q:BsID=0
	.s EpisodeID=$P(^DHCEMBSS(BsID,"I",CH),"^",1)  /// 就诊ID
	./// 病人就诊信息
	.s PatientID=$P(^PAADM(EpisodeID),"^",1)       /// 病人ID
	.s mradm=$P(^PAADM(EpisodeID),"^",61) 
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 姓名
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)   /// 登记号
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)     /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)       /// 出生日期
	.i PatBDay'="" s PatBDay=$zd(PatBDay,3)
	.s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	.s PAAdmDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml($P($g(^PAADM(EpisodeID)),"^",6))  //就诊日期
	.s PAAdmTime=$ZT($P($g(^PAADM(EpisodeID)),"^",7),2)  //就诊时间
	.s PatDocID=$P($g(^PAADM(EpisodeID)),"^",9)
	.I PatDocID'="" s PatDoc=$P($g(^CTPCP(PatDocID,1)),"^",2)
	.E  s PatDoc=""
	.s PatLoc=""
	.s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	.s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	.s PatWard=""
	.s WardDr=$P($g(^PAADM(EpisodeID)),"^",70)
	.i WardDr'="" s PatWard=$P($g(^PAWARD(WardDr)),"^",2)                       /// 病区
	.s:PatWard["-" PatWard=$p(PAAdmWard,"-",2)
	.s BedId=$P(^DHCEMBSS(BsID,"I",CH),"^",2)       /// 床号
	.I BedId'="" s PatBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)  /// 床号
	.E  s PatBed=""
	.I (PatBed'["床")&(PatBed'="") s PatBed=PatBed_##class(web.DHCEMCommonUtil).GetTrans("","床")
	.//s PatBed=##Class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
	.s WaitToHos=##Class(web.DHCEMWaitToHosPat).GetPatWaitToHos(EpisodeID)  /// 待入院信息
	.S CurrAmt=##class(web.DHCDocOrderCommon).GetCurrentDeposit(EpisodeID)  /// 余额
	.s BsPatDiag=$P(^DHCEMBSS(BsID,"I",CH),"^",3)   /// 诊断
	.i BsPatDiag="" s BsPatDiag=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm)  /// 诊断
	.s BsVitalSign=$P(^DHCEMBSS(BsID,"I",CH),"^",4) /// 生命体征
	.s BsContents=$P(^DHCEMBSS(BsID,"I",CH),"^",5)  /// 交班内容
	.s BsNotes=$P(^DHCEMBSS(BsID,"I",CH),"^",6)     /// 备注
	.s BsMedHis=$p(^DHCEMBSS(BsID,"I",CH),"^",7)    /// 病史
	.s BsTreatMet=$p(^DHCEMBSS(BsID,"I",CH),"^",8)  /// 治疗
	.s BsCotNumber=$p(^DHCEMBSS(BsID,"I",CH),"^",9) /// 联系方式
	.s BsSuggest=$p(^DHCEMBSS(BsID,"I",CH),"^",10)  /// 建议
	.s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)  /// 费别
	.s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	.s Priority=$P($g(^PAADM(EpisodeID)),"^",33)    /// 级别
	.i Priority'="" s Priority=$p($g(^CT("ACU",Priority)),"^",1)
	.s WriFlag="N"
	.i (BsSuggest'="")||(BsContents'="") s WriFlag="Y"
	.s ObsTime=##Class(web.DHCEMInterfaceCom).GetPatObsTime(EpisodeID) /// 滞留时间
	.s CompFlag="" //$p(^DHCEMBSS(BsID),"^",10)   /// 完成状态
	.s WaitToHos=##Class(web.DHCEMWaitToHosPat).GetPatWaitToHos(EpisodeID)  /// 取指定病人待入院数据
	.s Type=..GetEmPatType(EpisodeID) /// 病人交班类型
	.s TotalNum=TotalNum+1
	.; 多语言
	.s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	.s PatWard=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",PatWard)
	.s PatDoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",PatDoc)
	.s BsPatDiag=##class(web.DHCEMCommonUtil).GetTransDesc("User.MRCICDDx","MRCIDDesc","",BsPatDiag)
	.S PatLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",PatLoc)
	
	.s ListData=BsID_"||"_CH_"^"_PatientID_"^"_EpisodeID_"^"_mradm_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatBDay_"^"_PatAge_"^"_PAAdmDate_"^"_PAAdmTime_"^"_PatDoc_"^"_PatWard_"^"_Priority
	.s ListData=ListData_"^"_PatBed_"^"_BsPatDiag_"^"_BillType_"^"_BsVitalSign_"^"_BsContents_"^"_BsNotes_"^"_BsMedHis_"^"_BsTreatMet_"^"_BsCotNumber_"^"_WaitToHos_"^"_CurrAmt_"^"_BsSuggest
	.s ListData=ListData_"^"_WriFlag_"^"_ObsTime_"^"_CompFlag_"^"_WaitToHos_"^"_PatLoc_"^"_Type
	.s TMPArrList(TotalNum)=ListData
	.
	b ;err1
	i TotalNum=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(TotalNum) //输出json结尾符
	Q:TotalNum=0 ""
	
	///转换数据为Json格式
	s ListTitle="BsItmID^PatientID^EpisodeID^mradm^PatNo^PatName^PatSex^PatBDay^PatAge^PAAdmDate^PAAdmTime^mainDoc^PatWard^PatLev^PatBed^PatDiag^BillType^BsBackground^BsAssessment^BsNotes^BsMedHis^BsTreatMet^BsCotNumber^WaitToHos^CurrAmt^BsSuggest^WriFlag^ObsTime^CompFlag^WaitToHos^PatLoc^Type"

	W ##class(web.DHCAPPJsonCommon).getJsonStartSign(TotalNum) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPArrList(index)) Q:index=""  D
	.s ListData=$g(TMPArrList(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]}"
	Q ""
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-12-11
/// Descript:    急诊留观病区病人列表
/// w ##class(web.DHCEMBedSideShift).GetEmWardPatList("60","1","33")
ClassMethod GetEmWardPatList(rows As %String, page As %String, Params As %String) As %String
{
	n (rows, page, Params,%session)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s BsID=$p(Params,"^",1)              /// 交班子表ID
	i BsID="" w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出json结尾符
	Q:BsID="" ""
	s mBsID=BsID
    s WardID=$p(^DHCEMBSS(BsID),"^",2)    /// 交班科室
	s MedGrpID=$p(^DHCEMBSS(BsID),"^",8)  /// 医疗组
	s MedGrpPrvArr=..GetMedGrpPrv(MedGrpID)  /// 医疗组医生指针列表
	s Pid=$p(Params,"^",2) /// 计数器
	i Pid="" s Pid=##Class(web.DHCAPPExaRepCom).NewPid()
    d ..killTmpGlobal(Pid) //k掉临时global
	
    k TmpArr, TmpBsArr
    
    s num=0,del=""""
    /// 交班本病人
    s CH=0
	F  s CH=$O(^DHCEMBSS(BsID,"I",CH)) Q:CH=""  D
	.s EpisodeID=$P(^DHCEMBSS(BsID,"I",CH),"^",1)  /// 就诊ID
	.s TmpArr(EpisodeID)=EpisodeID_"^"_BsID_"||"_CH
	
	/// 留观/抢救病区病人
	s RoomDr=0
	F  s RoomDr=$o(^PAADMi("CurrWard",WardID,RoomDr)) Q:RoomDr=""  D
	.s EpisodeID=""
	.F  s EpisodeID=$O(^PAADMi("CurrWard",WardID,RoomDr,EpisodeID)) Q:EpisodeID=""  D
	..Q:$P(^PAADM(EpisodeID),"^",20)'="A"
	..s CarePrvID=$p(^PAADM(EpisodeID),"^",9)    /// 医生
	..Q:(MedGrpID'="")&'$LF($LISTFROMSTRING(MedGrpPrvArr,"^"),CarePrvID)
	..i '$D(TmpArr(EpisodeID)) s TmpArr(EpisodeID)=EpisodeID
	.
	
	/// 等候区病人
	s CH=0
	F  s CH=$O(^PAWARDA(WardID,"WADM",CH)) Q:CH=""  D
	.s EpisodeID=$P(^PAWARDA(WardID,"WADM",CH),"^",1)
	.Q:$P(^PAADM(EpisodeID),"^",20)'="A"
	.s CarePrvID=$p(^PAADM(EpisodeID),"^",9)    /// 医生
	.Q:(MedGrpID'="")&'$LF($LISTFROMSTRING(MedGrpPrvArr,"^"),CarePrvID)
	.i '$D(TmpArr(EpisodeID)) s TmpArr(EpisodeID)=EpisodeID
	.
	
	s index=""
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s EpisodeID=$p($g(TmpArr(index)),"^",1) /// 就这ID
	.s BsiID=$p($g(TmpArr(index)),"^",2)     /// 交班本
	.s bsItemID=BsiID
	./// 病人就诊信息
	.s PatientID=$P(^PAADM(EpisodeID),"^",1)       /// 病人ID
	.s mradm=$P(^PAADM(EpisodeID),"^",61) 
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 姓名
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)   /// 登记号
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)     /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)       /// 出生日期
	.i PatBDay'="" s PatBDay=$zd(PatBDay,3)
	.;s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	.s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	.s PAAdmDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml($P($g(^PAADM(EpisodeID)),"^",6))  //就诊日期
	.s PAAdmTime=$ZT($P($g(^PAADM(EpisodeID)),"^",7),2)  //就诊时间
	.s PatDocID=$P($g(^PAADM(EpisodeID)),"^",9)
	.i PatDocID'="" s PatDoc=$P($g(^CTPCP(PatDocID,1)),"^",2)
	.E  s PatDoc=""
	.s PatLoc=""
	.s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	.s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	.s PatWard=""
	.s WardDr=$P($g(^PAADM(EpisodeID)),"^",70)
	.i WardDr'="" s PatWard=$P($g(^PAWARD(WardDr)),"^",2)                       /// 病区
	.s:PatWard["-" PatWard=$p(PAAdmWard,"-",2)
	.s WaitToHos=##Class(web.DHCEMWaitToHosPat).GetPatWaitToHos(EpisodeID)  /// 待入院信息
	.s CurrAmt=##class(web.DHCDocOrderCommon).GetCurrentDeposit(EpisodeID)  /// 余额
	.s BedId=""
	.s Type=$p(^DHCEMBSS(BsID),"^",4)    /// 交班类型
	.s BsPatDiag="", BsVitalSign="", BsContents="", BsNotes="", BsMedHis="", BsTreatMet="", BsCotNumber="", BsSuggest=""
	.i BsiID="" s BsiID=..TakPatLastBsID(EpisodeID, Type)  /// 取病人上次交班记录ID
	.i BsiID'="" D
	..s BsID=+BsiID, CH=$p(BsiID,"||",2)
	..s BsPatDiag=$P(^DHCEMBSS(BsID,"I",CH),"^",3)   /// 诊断
	..s BsVitalSign=$P(^DHCEMBSS(BsID,"I",CH),"^",4) /// 生命体征
	..s BsContents=$P(^DHCEMBSS(BsID,"I",CH),"^",5)  /// 交班内容
	..s BsNotes=$P(^DHCEMBSS(BsID,"I",CH),"^",6)     /// 备注
	..s BsMedHis=$p(^DHCEMBSS(BsID,"I",CH),"^",7)    /// 病史
	..s BsTreatMet=$p(^DHCEMBSS(BsID,"I",CH),"^",8)  /// 治疗
	..s BsCotNumber=$p(^DHCEMBSS(BsID,"I",CH),"^",9) /// 联系方式
	..i bsItemID'="" s BsSuggest=$p(^DHCEMBSS(BsID,"I",CH),"^",10)  /// 建议
	.i BedId="" s BedId=$P($g(^PAADM(EpisodeID)),"^",73)
	.i BedId'="" s PatBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)  /// 床号
	.E  s PatBed=""
	.i (PatBed'["床")&(PatBed'="") s PatBed=PatBed_##class(web.DHCEMCommonUtil).GetTrans("","床")
	.//s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
	.i BsPatDiag="" s BsPatDiag=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm)  /// 诊断
	.s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)  /// 费别
	.s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	.s Priority=$P($g(^PAADM(EpisodeID)),"^",33)    /// 级别
	.i Priority'="" s Priority=$p($g(^CT("ACU",Priority)),"^",1)
	.s WriFlag="N"
	.i (bsItemID'="")&((BsSuggest'="")||(BsContents'="")) s WriFlag="Y"
	.//i bsItemID'="" s WriFlag="Y"
	.s ObsTime=##Class(web.DHCEMInterfaceCom).GetPatObsTime(EpisodeID) /// 滞留时间
	.s CompFlag="" //$p(^DHCEMBSS(BsID),"^",10)   /// 完成状态
	.s WaitToHos=##Class(web.DHCEMWaitToHosPat).GetPatWaitToHos(EpisodeID)  /// 取指定病人待入院数据
	.s Type=..GetEmPatType(EpisodeID) /// 病人交班类型
	.s num=num+1
	
	.; 多语言
	.s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	.s PatWard=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",PatWard)
	.s PatDoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",PatDoc)
	.s BsPatDiag=##class(web.DHCEMCommonUtil).GetTransDesc("User.MRCICDDx","MRCIDDesc","",BsPatDiag)
	.S PatLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",PatLoc)
	.s ListData=bsItemID_"^"_PatientID_"^"_EpisodeID_"^"_mradm_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatBDay_"^"_PatAge_"^"_PAAdmDate_"^"_PAAdmTime_"^"_PatDoc_"^"_PatWard_"^"_Priority
	.s ListData=ListData_"^"_PatBed_"^"_BsPatDiag_"^"_BillType_"^"_BsVitalSign_"^"_BsContents_"^"_BsNotes_"^"_BsMedHis_"^"_BsTreatMet_"^"_BsCotNumber_"^"_WaitToHos_"^"_CurrAmt_"^"_BsSuggest
	.s ListData=ListData_"^"_WriFlag_"^"_ObsTime_"^"_CompFlag_"^"_WaitToHos_"^"_PatLoc_"^"_Type
	.s TmpBsArr(mBsID_"^"_EpisodeID)=ListData
	.s ^TMP("DHCEM","web.DHCEMBedSideShift","XH",Pid,mBsID_"^"_EpisodeID)=""
	.

	i num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(num) //输出json结尾符
	Q:num=0 ""
	
	///转换数据为Json格式
	s ListTitle="BsItmID^PatientID^EpisodeID^mradm^PatNo^PatName^PatSex^PatBDay^PatAge^PAAdmDate^PAAdmTime^mainDoc^PatWard^PatLev^PatBed^PatDiag^BillType^BsBackground^BsAssessment^BsNotes^BsMedHis^BsTreatMet^BsCotNumber^WaitToHos^CurrAmt^BsSuggest^WriFlag^ObsTime^CompFlag^WaitToHos^PatLoc^Type"

	W ##class(web.DHCAPPJsonCommon).getJsonStartSign(num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TmpBsArr(index)) Q:index=""  D
	.s ListData=$g(TmpBsArr(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	w ","_del_"Pid"_del_":"_Pid
	w "}"
	Q ""
}

/// Descript: 医疗组医生指针列表
/// w ##class(web.DHCEMBedSideShift).GetMedGrpPrv("229||1")
ClassMethod GetMedGrpPrv(MedGrpID As %String) As %String
{
	n (MedGrpID)
	Q:MedGrpID="" ""
	s LocID=+MedGrpID, CH=$p(MedGrpID,"||",2)
	s ListData=""
	s Sub=0
	F  s Sub=$o(^CTLOC(LocID,"MU",CH,"CP",Sub)) Q:Sub=""  D
	.s CareProv=$p(^CTLOC(LocID,"MU",CH,"CP",Sub),"^",1)
	.s ListData=$s(ListData="":CareProv,1:ListData_"^"_CareProv)
	.
	Q ListData
}

/// Descript: 急诊交班列表
/// w ##class(web.DHCEMBedSideShift).GetEmShiftList("30","1","2019-11-12^2019-11-13^^^^Nur")
ClassMethod GetEmShiftList(rows As %String, page As %String, Params As %String) As %String
{
	n (rows, page, Params,%session)

	s End = page*rows
	s Start=(page-1)*rows+1

	k TMPArrList
	
	s StartDate=$p(Params,"^",1)      /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-1
    s EndDate=$p(Params,"^",2)        /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s argWardID=$p(Params,"^",3)     /// 交班病区
	s argSchedule=$p(Params,"^",4)   /// 交班班次
	s argMedGrpID=$p(Params,"^",5)   /// 医疗组
	s argEmType=$p(Params,"^",6)     /// 交班类型
	s LgHospID=$p(Params,"^",7)      /// 登录医院 hxy 2020-06-03
	
	s Num=0
	F dd=StartDate:1:EndDate D
	.s BsID=""
	.F  s BsID=$o(^DHCEMBSS(0,"CreateDate",dd,BsID)) Q:BsID=""  D
	..s WrDate=$p(^DHCEMBSS(BsID),"^",1)    /// 交班日期
	..s:WrDate'="" WrDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(WrDate)
	..s WardID=$p(^DHCEMBSS(BsID),"^",2)    /// 交班病区
	..Q:(argWardID'="")&(argWardID'=WardID)
	..s CurLocID=$p($g(^PAWARD(+WardID)),"^",5) //hxy 2020-06-03 st 多院区
	..s CurHospID=$p($g(^CTLOC(+CurLocID)),"^",22)
	..q:CurHospID'=LgHospID //ed
	..;s Ward=$p($g(^PAWARD(+WardID)),"^",2) /// 病区描述
	..s Ward=$p($g(^PAWARD(WardID)),"^",2)	/// add by dl 2019-05-01 留观区取的是科室列表配置,是CT_Loc表数据
	..s Schedule=$p(^DHCEMBSS(BsID),"^",3)  /// 交班班次
	..s Schedule=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmTimeInterval","ERDesc","",Schedule)
	..Q:$p(^DHCEMBSS(BsID),"^",4)'=argEmType
	..Q:(argSchedule'="")&(argSchedule'=Schedule)
	..s UserID=$p(^DHCEMBSS(BsID),"^",5)    /// 交班人员
	..s UserName=$p($g(^SSU("SSUSR",+UserID)),"^",2)
	..s CrDate=$p(^DHCEMBSS(BsID),"^",6)    /// 创建日期
	..s:CrDate'="" CrDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CrDate)
	..s CrTime=$p(^DHCEMBSS(BsID),"^",7)    /// 创建时间
	..s MedGrpID=$p(^DHCEMBSS(BsID),"^",8)  /// 医疗组
	..Q:(argMedGrpID'="")&(argMedGrpID'=MedGrpID)
	..s MedGrp=$p($g(^CTLOC(+MedGrpID,"MU",+$p(MedGrpID,"||",2))),"^",2)
	..s:CrTime'="" CrTime=$zt(CrTime,1)
	..s PatNum=##Class(web.DHCEMBedSideShiftQuery).TakPatNum(BsID)  /// 本次交班病人数
	..s bsAccUserID=$p(^DHCEMBSS(BsID),"^",9) /// 接班人
	..s bsAccUser=$p($g(^SSU("SSUSR",+bsAccUserID)),"^",2)
	..s bsStatus=$p(^DHCEMBSS(BsID),"^",10) /// 交班状态
	..; 多语言
	..s Ward=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",Ward)
	..s UserName=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",UserName)
	..s MedGrp=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCCTLocMedUnit","CTMUDesc","",MedGrp)
	..s bsAccUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",bsAccUser)
	..s Num=Num+1
	..s ListData=BsID_"^"_WrDate_"^"_WardID_"^"_Ward_"^"_Schedule_"^"_UserName_"^"_CrDate_"^"_CrTime_"^"_MedGrpID_"^"_MedGrp_"^"_PatNum_"^"_bsAccUser_"^"_bsStatus
	..s ListData=ListData_"^"_bsAccUserID
	..s TMPArrList(Num)=ListData
	.
		
	i Num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	s ListTitle="BsID^bsDate^bsWardID^bsWard^bsSchedule^bsUser^bsCreateDate^bsCreateTime^bsMedGrpID^bsMedGrp^bsPatNum^bsAccUser^bsStatus"
	s ListTitle=ListTitle_"^bsAccUserID"

	W ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPArrList(index)) Q:index=""  D
	.s ListData=$g(TMPArrList(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]}"
	Q ""
}

/// Descript: 获取交班信息
/// w ##class(web.DHCEMBedSideShift).JsGetEmShiftObj("29")
ClassMethod JsGetEmShiftObj(BsID As %String) As %String
{
	n (BsID,%session)
	s WrDate=$p(^DHCEMBSS(BsID),"^",1)    /// 交班日期
	s WrDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(WrDate)  //就诊日期
	s WardID=$p(^DHCEMBSS(BsID),"^",2)    /// 交班科室
	s Schedule=$p(^DHCEMBSS(BsID),"^",3)  /// 交班班次
	s EmType=$p(^DHCEMBSS(BsID),"^",4)    /// 交班类型
	s UserID=$p(^DHCEMBSS(BsID),"^",5)    /// 交班人员
	s UserCode=$p($g(^SSU("SSUSR",+UserID)),"^",1)
	s UserName=$p($g(^SSU("SSUSR",+UserID)),"^",2)
	s MedGrpID=$p(^DHCEMBSS(BsID),"^",8)    /// 医疗组
	s RecUserID=$p(^DHCEMBSS(BsID),"^",9)     /// 接班人
	s RecUserCode="",RecUser=""
	i RecUserID'="" d
	.s RecUserCode=$p($g(^SSU("SSUSR",+RecUserID)),"^",1)
	.s RecUser=$p($g(^SSU("SSUSR",+RecUserID)),"^",2)
	s CompFlag=$p(^DHCEMBSS(BsID),"^",10)   /// 完成状态
	s UserName=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",UserName)
	s RecUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",RecUser)
	s Schedule=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmTimeInterval","ERDesc","",Schedule)
	s ListData=WrDate_"^"_WardID_"^"_Schedule_"^"_EmType_"^"_UserName_"^"_MedGrpID_"^"_CompFlag_"^"_RecUser_"^"_UserCode_"^"_RecUserCode
	s ListTitle="WrDate^WardID^Schedule^EmType^UserName^MedGrpID^CompFlag^RecUser^UserCode^RecUserCode"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descript: 提取导出急诊交班明细列表
/// w ##class(web.DHCEMBedSideShift).GetExpEmShiftDetail("75")
ClassMethod GetExpEmShiftDetail(BsID As %String) As %String
{
	n (BsID,%session)

	k TMPArrList
	s CH=0,Num=0
	F  s CH=$O(^DHCEMBSS(BsID,"I",CH)) Q:CH=""  D
	.s EpisodeID=$P(^DHCEMBSS(BsID,"I",CH),"^",1)  /// 就诊ID
	./// 病人就诊信息
	.s PatientID=$P(^PAADM(EpisodeID),"^",1)       /// 病人ID
	.s mradm=$P(^PAADM(EpisodeID),"^",61) 
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 姓名
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)   /// 登记号
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)     /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)       /// 出生日期
	.i PatBDay'="" s PatBDay=$zd(PatBDay,3)
	.;s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	.s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	.s PAAdmDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml($P($g(^PAADM(EpisodeID)),"^",6))  //就诊日期
	.s PAAdmTime=$ZT($P($g(^PAADM(EpisodeID)),"^",7),2)  //就诊时间
	.s PatDocID=$P($g(^PAADM(EpisodeID)),"^",9)
	.I PatDocID'="" s PatDoc=$P($g(^CTPCP(PatDocID,1)),"^",2)
	.E  s PatDoc=""
	.s PatLoc=""
	.s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	.s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	.s PatWard=""
	.s WardDr=$P($g(^PAADM(EpisodeID)),"^",70)
	.i WardDr'="" s PatWard=$P($g(^PAWARD(WardDr)),"^",2)                       /// 病区
	.s:PatWard["-" PatWard=$p(PAAdmWard,"-",2)
	.s BedId=$P(^DHCEMBSS(BsID,"I",CH),"^",2)       /// 床号
	.I BedId'="" s PatBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)  /// 床号
	.E  s PatBed=""
	.I (PatBed'["床")&(PatBed'="") s PatBed=PatBed_##class(web.DHCEMCommonUtil).GetTrans("","床")
	.//s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
	.s BsPatDiag=$P(^DHCEMBSS(BsID,"I",CH),"^",3)   /// 诊断
	.i BsPatDiag="" s BsPatDiag=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm)  /// 诊断
	.s WaitToHos=##Class(web.DHCEMWaitToHosPat).GetPatWaitToHos(EpisodeID)  /// 待入院信息
	.s bsBackground=$P(^DHCEMBSS(BsID,"I",CH),"^",4)  /// 生命体征
	.s bsAssessment=$P(^DHCEMBSS(BsID,"I",CH),"^",5)  /// 交班内容
	.s bsSuggest=$p(^DHCEMBSS(BsID,"I",CH),"^",10)    /// 建议
	.s ObsTime=##Class(web.DHCEMInterfaceCom).GetPatObsTime(EpisodeID) /// 滞留时间
	.s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)                        /// 费别
	.s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	.s Num=Num+1
	.; 多语言
	.s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	.s PatWard=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",PatWard)
	.s PatDoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",PatDoc)
	.s BsPatDiag=##class(web.DHCEMCommonUtil).GetTransDesc("User.MRCICDDx","MRCIDDesc","",BsPatDiag)
	.s ListData=BsID_"||"_CH_"^"_PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatBDay_"^"_PatAge_"^"_PAAdmDate_"^"_PAAdmTime_"^"_PatDoc_"^"_PatWard
	.s ListData=ListData_"^"_PatBed_"^"_BsPatDiag_"^"_BillType_"^"_bsBackground_"^"_bsAssessment_"^"_bsSuggest_"^"_WaitToHos_"^"_ObsTime_"^"_PatLoc
	.i PatBed="" s PatBed=999
	.s index=+PatBed_"^"_EpisodeID
	.s TMPArrList(index)=ListData
	.
	
	///转换数据为Json格式
	s ListTitle="BsItmID^PatientID^EpisodeID^PatNo^PatName^PatSex^PatBDay^PatAge^PAAdmDate^PAAdmTime^PatDoc^PatWard^PatBed^PatDiag^BillType^bsBackground^bsAssessment^bsSuggest^WaitToHos^ObsTime^PatLoc"

	W "[" //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPArrList(index)) Q:index=""  D
	.s ListData=$g(TMPArrList(index))
	.Q:ListData=""
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	Q ""
}

/// Descript: 	交班关联项目
/// w ##class(web.DHCEMBedSideShift).JsGetLnkItemObj("52")
ClassMethod JsGetLnkItemObj(BsID As %String) As %String
{
	n (BsID)
	s ListTitle="itmID^itmVal"
	w "["
	s ID="", count=0
	F  s ID=$o(^DHCEMSLI(0,"Parref",BsID,ID)) Q:ID=""  D
	.s itmID=$p(^DHCEMSLI(ID),"^",2)  /// 项目ID
	.s itmVal=$p(^DHCEMSLI(ID),"^",3) /// 项目
	.s ListData="T"_itmID_"^"_itmVal
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	Q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(Pid) As %String
{
	N (Pid)
	k ^TMP("DHCEM","web.DHCEMBedSideShift",Pid)
	k ^TMP("DHCEM","web.DHCEMBedSideShift","XH",Pid)
	Q ""
}

/// 判断添加重复数据
/// w ##class(web.DHCEMBedSideShift).isExist("","2019-07-16^55^中班^^11843^")
ClassMethod isExist(mListData As %String) As %String
{
   n (mListData)
   s Err=0
   s MedGrpID=$p(mListData,"^",1)    /// 医疗组ID
   s WardID=$p(mListData,"^",2)      /// 交班科室ID
   s Schedule=$p(mListData,"^",3)    /// 班次
   s WrDate=$p(mListData,"^",4)      /// 交班日期
   i WrDate'="" s WrDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(WrDate)
   s BsID=""
   f  s BsID = $o(^DHCEMBSS(0,"CreateDate",WrDate,BsID)) Q:(BsID="")||(Err'=0)  D
   .q:$p(^DHCEMBSS(BsID),"^",8)'=MedGrpID         /// 医疗组
   .q:$p(^DHCEMBSS(BsID),"^",2)'=WardID           /// 交班科室
   .q:$p(^DHCEMBSS(BsID),"^",3)'=Schedule         /// 交班班次
   .s Err="-1"  //当天同一个交班科室，班次只能保存一次
   .
   q Err
}

/// Creator: 	bianshuai
/// CreateDate: 2018-01-04
/// Descript:   急诊留观病区病人列表
/// w ##class(web.DHCEMBedSideShift).GetWardPat("^191^^")
ClassMethod GetWardPat(Params As %String, TmpArr) As %String
{
	n (Params, TmpArr)
	s MedGrpID=$p(Params,"^",1)    /// 医疗组
	s WardID=$p(Params,"^",2)      /// 留观病区
	s MedGrpPrvArr=..GetMedGrpPrv(MedGrpID)  /// 医疗组医生指针列表
	s TotalNum=0,del=""""
	s RoomDr=0
	F  s RoomDr=$o(^PAADMi("CurrWard",WardID,RoomDr)) Q:RoomDr=""  D
	.s EpisodeID=""
	.F  s EpisodeID=$O(^PAADMi("CurrWard",WardID,RoomDr,EpisodeID)) Q:EpisodeID=""  D
	..s CarePrvID=$p(^PAADM(EpisodeID),"^",9)    /// 医生
	..Q:(MedGrpID'="")&'$LF($LISTFROMSTRING(MedGrpPrvArr,"^"),CarePrvID)
	..//Q:$P(^PAADM(EpisodeID),"^",20)'="A"
    ../// 病人就诊信息
	..s PatientID=$P(^PAADM(EpisodeID),"^",1)    /// 病人ID
	..s mradm=$P(^PAADM(EpisodeID),"^",61)
	..s BedId=$P($g(^PAADM(EpisodeID)),"^",73)
	..s PatDocID=$P($g(^PAADM(EpisodeID)),"^",9) /// 主管医生
	..s TmpArr("Pat",EpisodeID)=EpisodeID_"^"_BedId_"^"_PatientID
	.
	s CH=0
	F  s CH=$O(^PAWARDA(WardID,"WADM",CH)) Q:CH=""  D
	.s EpisodeID=$P(^PAWARDA(WardID,"WADM",CH),"^",1)
	.s CarePrvID=$p(^PAADM(EpisodeID),"^",9)    /// 医生
	.Q:(MedGrpID'="")&'$LF($LISTFROMSTRING(MedGrpPrvArr,"^"),CarePrvID)
	.//Q:$P(^PAADM(EpisodeID),"^",20)'="A"
    ./// 病人就诊信息
	.s PatientID=$P(^PAADM(EpisodeID),"^",1)    /// 病人ID
	.s mradm=$P(^PAADM(EpisodeID),"^",61)
	.s BedId=$P($g(^PAADM(EpisodeID)),"^",73)
	.s PatDocID=$P($g(^PAADM(EpisodeID)),"^",9) /// 主管医生
	.s TmpArr("Pat",EpisodeID)=EpisodeID_"^"_BedId_"^"_PatientID
	.
	Q ""
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-12-06
/// Descript:    交班本关联项目
/// w ##class(web.DHCEMBedSideShift).GetLinkItem("^191^P班^2019-12-06^Nur^1320^BSN^2",.TmpArr)
ClassMethod GetLinkItem(Params As %String, TmpArr) As %String
{
	n (Params, TmpArr)
	//s ^BIANSHUAI(123)=$lb(Params, TmpArr)
	k TmpItemArr
	s MedGrpID=$p(Params,"^",1)  /// 医疗组
	s WardID=$p(Params,"^",2)    /// 留观病区
	s Schedule=$p(Params,"^",3)  /// 班次
	s WrDate=$p(Params,"^",4)    /// 交班日期
	s Type=$p(Params,"^",5)      /// 交班类型
	s mCode=$p(Params,"^",7)     /// 关联项类型
	s HospID=$p(Params,"^",8)    /// 医院ID
	s mID=$o(^DHCEMDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:mID="" ""
	s LocID=$p(^PAWARD(WardID),"^",5) /// 病区对应科室
	s mParams=""
	s WrTimes=..GetTimesInterval(Type, Schedule, WrDate)
	s $p(mParams,"^",2)=HospID     /// 医院ID
	s $p(mParams,"^",3)=$p(WrTimes,"^",1)     /// 开始日期
	s $p(mParams,"^",4)=$p(WrTimes,"^",2)     /// 开始时间
	s $p(mParams,"^",5)=$p(WrTimes,"^",3)     /// 结束日期
	s $p(mParams,"^",6)=$p(WrTimes,"^",4)     /// 结束时间
	s $p(mParams,"^",7)=LocID      /// 病区ID
	s $p(mParams,"^",8)=MedGrpID   /// 医疗组
	/// 抢救留观病区数据
	D ##Class(web.DHCEMBedSideShiftQuery).GetEmSalWardMap(mParams, mID, .TmpItemArr)

	s ListTitle="", ListData=""
	s itmID=""
	F  s itmID=$o(^DHCEMDI(0,"Type",mID,itmID)) Q:itmID=""  D
	.Q:$p(^DHCEMDI(itmID),"^",3)'="Y"
	.s itmCode=$p(^DHCEMDI(itmID),"^",1)  /// 项目代码
	.s mItem=itmID_"@"_+$g(TmpItemArr(itmCode))
	.s TmpArr("LinkItem")=$s($g(TmpArr("LinkItem"))="":mItem,1:$g(TmpArr("LinkItem"))_"#"_mItem)
	.

	Q ""
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-12-06
/// Descript:    取病人上次交班记录ID
/// w ##Class(web.DHCEMBedSideShift).TakPatLastBsID("")
ClassMethod TakPatLastBsID(EpisodeID As %String, Type As %String) As %String
{
	n (EpisodeID, Type)
	Q:EpisodeID="" ""
	s ID="", BsID=""
	F  s ID=$o(^DHCEMBSS(0,"ADM",EpisodeID,ID),-1) Q:(ID="")||(BsID'="")  D
	.Q:$p(^DHCEMBSS(ID),"^",4)'=Type
	.s CH=$o(^DHCEMBSS(0,"ADM",EpisodeID,ID,""),-1)
	.Q:CH=""
	.s BsID=ID_"||"_CH
	Q BsID
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-12-06
/// Descript:    取交班时间
/// w ##Class(web.DHCEMBedSideShift).GetTimesInterval("Doc","","2020-01-01")
ClassMethod GetTimesInterval(Type As %String, Schedule As %String, WrDate As %String) As %String
{
	n (Type, Schedule, WrDate)
	s ID=$o(^DHCEMTI(0,"Desc",$$ALPHAUP^SSUTIL4(Schedule),""))
	Q:ID="" ""
	s StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(WrDate)
	s StartTime=$p(^DHCEMTI(ID),"^",3)	/// 开始时间
	s EndTime=$p(^DHCEMTI(ID),"^",4)	/// 结束时间
	i EndTime<StartTime s EndDate=StartDate+1
	E  s EndDate=StartDate
	s StartDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(StartDate)
	s EndDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(EndDate)
	s:StartTime'="" StartTime=$zt(StartTime,2)
	s:EndTime'="" EndTime=$zt(EndTime,2)
	Q StartDate_"^"_EndTime_"^"_EndDate_"^"_EndTime
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-12-06
/// Descript:    取急诊病人类型
/// w ##Class(web.DHCEMBedSideShift).GetEmPatType("Doc")
ClassMethod GetEmPatType(EpisodeID As %String) As %String
{
	n (EpisodeID,%session)
	s TypeArr=""
	s PatTyp=##Class(Nur.CommonInterface.Patient).getIllState(EpisodeID)  /// 病人病情
	//Q:(PatTyp'="")&(PatTyp'="普通") PatTyp
	i (PatTyp'="")&(PatTyp'="普通") s TypeArr=PatTyp
	s TypeArr=##class(web.DHCEMCommonUtil).GetTrans("dhcem.pattimeaxis.csp",TypeArr)
	s PatTyp=##Class(Nur.CommonInterface.Patient).getCareLevel(EpisodeID)  /// 护理级别
	//Q:PatTyp'="" PatTyp
	s PatTyp=##class(web.DHCEMCommonUtil).GetTrans("dhcem.pattimeaxis.csp",PatTyp)
	i PatTyp'="" s TypeArr=$s(TypeArr="":PatTyp,1:TypeArr_","_PatTyp)
	s StayTimes=##Class(web.DHCEMInComUseMethod).GetPatStayTimes(EpisodeID)    /// 留观时间
	//Q:$P(StayTimes,"^",1)=+$H "新入院"
	i $P(StayTimes,"^",1)=+$H s TypeArr=$s(TypeArr="":PatTyp,1:TypeArr_","_PatTyp)
	Q TypeArr
}

}
