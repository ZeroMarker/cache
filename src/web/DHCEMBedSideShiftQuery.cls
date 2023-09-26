Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2018-10-31
/// Descript: 	急诊床旁交班查询类
Class web.DHCEMBedSideShiftQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 	bianshuai
/// CreateDate: 2019-10-31
/// Descript:	获取病人历次交班信息
/// Input:      PatientID - 病人ID，EpisodeID - 就诊ID
/// Output:     
/// W ##Class(web.DHCEMBedSideShiftQuery).JsBsTimeAxis("","167")
ClassMethod JsBsTimeAxis(PatientID As %String, EpisodeID As %String, Type As %String) As %String
{
	n (PatientID, EpisodeID, Type,%session)

	k TmpArr
	s bsID=""
	F  s bsID=$o(^DHCEMBSS(0,"ADM",EpisodeID,bsID)) Q:bsID=""  D
	.Q:$p(^DHCEMBSS(bsID),"^",4)'=Type
	.Q:$p(^DHCEMBSS(bsID),"^",10)'="Y"        /// 完成
	.s bsDate=$p(^DHCEMBSS(bsID),"^",1)       /// 交班日期
	.s:bsDate'="" bsDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(bsDate)
	.s bsSchedule=$p(^DHCEMBSS(bsID),"^",3)   /// 交班班次
	.s bsUserID=$p(^DHCEMBSS(bsID),"^",5)     /// 交班人员
	.s bsUser=$p($g(^SSU("SSUSR",+bsUserID)),"^",2)
	.s bsSchedule=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmTimeInterval","ERDesc","",bsSchedule)
	.s bsUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",bsUser)
	.s CH=$o(^DHCEMBSS(0,"ADM",EpisodeID,bsID,""))
	.s bsItemID=bsID //_"||"_CH
	.s TmpArr("Schedule",bsID)=bsItemID_"^"_bsDate_"^"_bsSchedule_"^"_bsUser
	.
	
	s ListTitle="bsID^bsDate^bsSchedule^bsUser"
	W "["
	s Num=0
	s index=""
	F  s index=$o(TmpArr("Schedule",index)) Q:index=""  D
	.s ListData=$g(TmpArr("Schedule",index))
	.Q:ListData=""
	.s Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	W "]"
	Q ""
}

/// Creator: 	bianshuai
/// CreateDate: 2019-10-31
/// Descript:	获取本次交班内容
/// Input:      bsID - 交班ID
/// Output:     
/// W ##Class(web.DHCEMBedSideShiftQuery).JsBsSchContent("9||1")
ClassMethod JsBsSchContent(BsID As %String, EpisodeID As %String, Pid As %String) As %String
{
	n (BsID, EpisodeID, Pid,%session)

	/// 病人就诊信息
	s PatientID=$p(^PAADM(EpisodeID),"^",1)       /// 病人ID
	s mradm=$P(^PAADM(EpisodeID),"^",61) 
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)   /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)     /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	i PatBDay'="" s PatBDay=$zd(PatBDay,3)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	s PatDocID=$P($g(^PAADM(EpisodeID)),"^",9)          /// 主管医生
	I PatDocID'="" s PatDoc=$P($g(^CTPCP(PatDocID,1)),"^",2)
	E  s PatDoc=""
	//s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
	s BedId=$P($g(^PAADM(EpisodeID)),"^",73)
	I BedId'="" s PatBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)  /// 床号
	E  s PatBed=""
	I (PatBed'["床")&(PatBed'="") s PatBed=PatBed_##class(web.DHCEMCommonUtil).GetTrans("","床")
	s PatWard=""
	s WardDr=$P($g(^PAADM(EpisodeID)),"^",70)
	i WardDr'="" s PatWard=$P($g(^PAWARD(WardDr)),"^",2)                      /// 病区
	s:PatWard["-" PatWard=$p(PAAdmWard,"-",2)
    s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID,"","","","Y")         /// 诊断
	s BalanceAmt=##Class(web.DHCDocOrderCommon).GetCurrentDeposit(EpisodeID)  /// 余额
	s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
	s AdmDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(AdmDate)         /// 就诊日期
	s AdmTime=$ZT($p($g(^PAADM(EpisodeID)),"^",7),2)  /// 就诊时间
	s AdmTime=AdmDate_" "_AdmTime
	s ObsTime=##Class(web.DHCEMInterfaceCom).GetPatObsTime(EpisodeID) /// 滞留时间
#;	s Priority=$P($g(^PAADM(EpisodeID)),"^",33)    /// 级别
#;	i Priority'="" s Priority=$p($g(^CT("ACU",Priority)),"^",1)
	s Priority=##class(web.DHCEMPatCheckLevCom).GetPatPriority(EpisodeID, "") /// 级别
	s Type=##Class(web.DHCEMBedSideShift).GetEmPatType(EpisodeID) /// 病人交班类型
	s bsDate="",bsSchedule="",bsUser="",Background="",Assessment="",Successor="",Suggest="",SchContent=""
	s bsDate=$p(^DHCEMBSS(BsID),"^",1)       /// 交班日期
	s:bsDate'="" bsDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(bsDate)
	s bsSchedule=$p(^DHCEMBSS(BsID),"^",3)   /// 交班班次
	s bsUserID=$p(^DHCEMBSS(BsID),"^",5)     /// 交班人
	s WardID=$p(^DHCEMBSS(BsID),"^",2)       /// 交班病区
	s Ward=$p($g(^PAWARD(WardID)),"^",2)
	s MedGrpID=$p(^DHCEMBSS(BsID),"^",8)    /// 医疗组
	s MedGrp=$p($g(^CTLOC(+MedGrpID,"MU",+$p(MedGrpID,"||",2))),"^",2)
	s bsUser=$p($g(^SSU("SSUSR",+bsUserID)),"^",2)
	s SuccessorID=$p(^DHCEMBSS(BsID),"^",9)   /// 接班人
	s Successor=$p($g(^SSU("SSUSR",+SuccessorID)),"^",2)
	s PatDiag=##class(web.DHCEMCommonUtil).GetTransDesc("User.MRCICDDx","MRCIDDesc","",PatDiag)
	s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	s bsSchedule=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmTimeInterval","ERDesc","",bsSchedule)
	s MedGrp=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCCTLocMedUnit","CTMUDesc","",MedGrp)
	s Ward=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",Ward)
	s SchContent=bsDate_" "_MedGrp_" "_Ward_" "_bsSchedule
	s Pointer=BsID_"^"_EpisodeID
	s BsType=$p(^DHCEMBSS(BsID),"^",4)        /// 交班类型
	s BsiID="", bsItemID=""
	s CH=$o(^DHCEMBSS(0,"ADM",EpisodeID,BsID,""))
	i CH'="" s BsiID=BsID_"||"_CH, bsItemID=BsiID
	i BsiID="" s BsiID=##Class(web.DHCEMBedSideShift).TakPatLastBsID(EpisodeID, BsType)   /// 取病人上次交班记录ID
	i BsiID'="" D
	.s BsID=+BsiID, CH=$p(BsiID,"||",2)
	.s Background=$p(^DHCEMBSS(BsID,"I",CH),"^",4)  /// 背景
	.s Assessment=$p(^DHCEMBSS(BsID,"I",CH),"^",5)  /// 评估
	.i bsItemID'="" s Suggest=$p(^DHCEMBSS(BsID,"I",CH),"^",10)    /// 建议
	.//s SwitchFlag=..btSwitchControl(BsID, CH)     /// 切换按钮控制
	s SwitchFlag=..btSwitchControl(Pointer, Pid)    /// 切换按钮控制
	s Successor=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",Successor)
	s bsUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",bsUser)
	
	s ListData=EpisodeID_"^"_PatientID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatBDay_"^"_PatBed
	s ListData=ListData_"^"_PatDoc_"^"_PatWard_"^"_PatDiag_"^"_BalanceAmt_"^"_AdmTime_"^"_ObsTime_"^"_Type
	s ListData=ListData_"^"_SchContent_"^"_bsSchedule_"^"_bsDate_"^"_bsUser_"^"_Successor_"^"_Background_"^"_Assessment_"^"_Suggest_"^"_SwitchFlag_"^"_Priority
	s ListTitle="EpisodeID^PatientID^PatNo^PatName^PatSex^PatAge^PatBDay^PatBed^PatDoc^PatWard^PatDiag^BalanceAmt^AdmTime^ObsTime^Type^SchContent^Schedule^Date^User^Successor^Background^Assessment^Suggest^SwitchFlag^Priority"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator: 	bianshuai
/// CreateDate: 2019-10-31
/// Descript:	本次交班人数
/// Input:      bsID - 交班ID
/// Output:     
/// W ##Class(web.DHCEMBedSideShiftQuery).TakPatNum("1||1")
ClassMethod TakPatNum(BsID As %String) As %String
{
	n (BsID)
	s CH=0,Num=0
	F  s CH=$O(^DHCEMBSS(BsID,"I",CH)) Q:CH=""  D
	.s EpisodeID=$P(^DHCEMBSS(BsID,"I",CH),"^",1)  /// 就诊ID
	.Q:EpisodeID=""
	.s Num=Num+1
	.
	Q Num
}

/// Descript:  获取病人基本就诊信息
/// W ##Class(web.DHCEMBedSideShiftQuery).GetPatBaseInfo("0005364629")
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
	//s isFlag=..isExist(TEpisodeID) /// 病人是否存在于当前交班记录中
	//i +isFlag=1 w ##Class(web.DHCAPPJsonCommon).getJsonData("ErrCode^ErrMsg","-3^当前病人已经存在待入院管理记录，添加时间为:"_$p(isFlag,"^",2))
	//Q:+isFlag=1 ""
	s ListData=..GetPatEssInfo(PatientID,TEpisodeID)
	s ListTitle="PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatBDay^PatDiags^PatType^PatSLv^PatLv^mradm^BedID^PatBed^BillType^LvDate^LvTime^AdmDays^PatDoc"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descript:  获取病人基本就诊信息
/// W ##Class(web.DHCEMBedSideShiftQuery).GetPatEssInfo("","2")
ClassMethod GetPatEssInfo(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID,%session)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)  /// 出生日期
	i PatBDay'="" s PatBDay=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(PatBDay)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
    s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID,"","","","Y")         /// 诊断
	i $L(PatDiag)>80 s PatDiag=$E(PatDiag,1,80)_"..."
	s PatType=$p(^PAADM(EpisodeID),"^",2) 	           /// 就诊类型
	s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,"")
 	s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	s PatLevel=$p(EncryptLevelInfo,"^",2)
 	s mradm=$p(^PAADM(EpisodeID),"^",61)          	   /// 就诊类型
	//s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
	s BedId=$P($g(^PAADM(EpisodeID)),"^",73)
	i BedId'="" s PatBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)  /// 床号
	E  s PatBed=""
	I (PatBed'["床")&(PatBed'="") s PatBed=PatBed_##class(web.DHCEMCommonUtil).GetTrans("","床")
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)    /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s PatDoc=""
	s AdmDocID=$p(^PAADM(EpisodeID),"^",9)             /// 医生
	s:AdmDocID'="" PatDoc=$p($g(^CTPCP(AdmDocID,1)),"^",2)
	s EmPLvDate="",EmPLvTime="",AdmDays=""
	s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",+EpisodeID,""),-1) /// 分诊ID
	i EmPCLvID'="" D
	.s LvDate=$p(^DHCEMPCL(EmPCLvID),"^",4)   /// 分诊日期
	.s AdmDays=+$H-LvDate_##class(web.DHCEMCommonUtil).GetTrans("","天")                /// 来诊天数
	.i LvDate'="" s LvDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(LvDate)
	.s LvTime=$p(^DHCEMPCL(EmPCLvID),"^",5)   /// 分诊时间
	.s:LvTime'="" LvTime=$zt(LvTime,2)
	.
	s PatDiag=##class(web.DHCEMCommonUtil).GetTransDesc("User.MRCICDDx","MRCIDDesc","",PatDiag)
	s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	s PatDoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",PatDoc)
	s ListData=PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_$g(PatSex)_"^"_PatAge_"^"_PatBDay_"^"_PatDiag_"^"_PatType_"^"_EncryptLevel_"^"_PatLevel_"^"_mradm_"^"_BedId_"^"_PatBed_"^"_BillType
	s ListData=ListData_"^"_$g(LvDate)_"^"_$g(LvTime)_"^"_$g(AdmDays)_"^"_PatDoc
	q ListData
}

/// Creator: 	bianshuai
/// CreateDate: 2019-10-31
/// Descript:	本次交班人数
/// Input:      bsID - 交班ID
/// Output:     
/// W ##Class(web.DHCEMBedSideShiftQuery).JsBsSwitchPat("33","24957549","220861","1")
ClassMethod JsBsSwitchPat(BsID As %String, EpisodeID As %String, Pid As %String, direc As %String) As %String
{
	n (BsID, EpisodeID, Pid, direc)
	Q:direc="" ""
	s bsItemID=""
	s Pointer=BsID_"^"_EpisodeID
	s nextPointer=$o(^TMP("DHCEM","web.DHCEMBedSideShift","XH",Pid,Pointer),direc)
	s EpisodeID=$p(nextPointer,"^",2)
	s CH=$o(^DHCEMBSS(0,"ADM",EpisodeID,BsID,""))
	i CH'="" s bsItemID=BsID_"||"_CH
	s Pointer=BsID_"^"_EpisodeID
	s SwitchFlag=..btSwitchControl(Pointer, Pid)
	s ListData=bsItemID_"^"_EpisodeID_"^"_SwitchFlag
	s ListTitle="bsItemID^EpisodeID^SwitchFlag"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator: 	bianshuai
/// CreateDate: 2019-10-31
/// Descript:	交班项目切换按钮控制
/// Input:      bsID - 交班ID
/// Output:     
/// W ##Class(web.DHCEMBedSideShiftQuery).btSwitchControl("33^24957549","220861")
ClassMethod btSwitchControl(Pointer As %String, Pid As %String) As %String
{
	n (Pointer, Pid)
	Q:Pid="" ""
	s FPointer=$o(^TMP("DHCEM","web.DHCEMBedSideShift","XH",Pid,""))      /// 第一项
	s LPointer=$o(^TMP("DHCEM","web.DHCEMBedSideShift","XH",Pid,""),-1)   /// 最后一项
	s isFlag=0
	i (Pointer=FPointer)&(Pointer=LPointer) s isFlag=-1
	i (Pointer=FPointer)&(Pointer'=LPointer) s isFlag=1
	i (Pointer'=FPointer)&(Pointer=LPointer) s isFlag=2
#;	i BsID="" D
#;	s FirCH=$o(^DHCEMBSS(BsID,"I",""))     /// 第一项
#;	s LastCH=$o(^DHCEMBSS(BsID,"I",""),-1) /// 最后一项
#;	s isFlag=0
#;	i (CH=FirCH)&(CH=LastCH) s isFlag=-1
#;	i (CH=FirCH)&(CH'=LastCH) s isFlag=1
#;	i (CH'=FirCH)&(CH=LastCH) s isFlag=2
	Q isFlag
}

/// Creator: 	bianshuai
/// CreateDate: 2019-11-13
/// Descript:	交班病人查询
/// Input:      bsID - 交班ID
/// Output:     
/// W ##Class(web.DHCEMBedSideShiftQuery).GetEmPatShiftHis("30","1","^^^^^Nur")
ClassMethod GetEmPatShiftHis(rows As %String, page As %String, Params As %String) As %String
{
	n (rows, page, Params,%session)
	
	s End = page*rows
	s Start=(page-1)*rows+1
    
	k TmpArr
	
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
	s pid=$p(Params,"^",7)           /// 计数器
	s argPatNo=$p(Params,"^",8)      /// 登记号
	s LgHospID=$p(Params,"^",9)      /// 登录医院 hxy 2020-06-05

	i pid="" s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
	s Num=0
	F dd=StartDate:1:EndDate D
	.s BsID=""
	.F  s BsID=$o(^DHCEMBSS(0,"CreateDate",dd,BsID)) Q:BsID=""  D
	..Q:$p(^DHCEMBSS(BsID),"^",10)'="Y"     /// 完成
	..s bsDate=$p(^DHCEMBSS(BsID),"^",1)    /// 交班日期
	..s:bsDate'="" bsDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(bsDate)
	..s WardID=$p(^DHCEMBSS(BsID),"^",2)    /// 交班病区
	..Q:(argWardID'="")&(argWardID'=WardID)
	..s PatLocID=$p($g(^PAWARD(+WardID)),"^",5) // 就诊科室 hxy 2020-06-05 st
	..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=LgHospID //ed
	..s bsSchedule=$p(^DHCEMBSS(BsID),"^",3)  /// 交班班次
	..s bsSchedule=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmTimeInterval","ERDesc","",bsSchedule)
	..Q:$p(^DHCEMBSS(BsID),"^",4)'=argEmType
	..Q:(argSchedule'="")&(argSchedule'=bsSchedule)
	..s UserID=$p(^DHCEMBSS(BsID),"^",5)    /// 交班人员
	..s bsUser=$p($g(^SSU("SSUSR",+UserID)),"^",2)
	..s MedGrpID=$p(^DHCEMBSS(BsID),"^",8)  /// 医疗组
	..Q:(argMedGrpID'="")&(argMedGrpID'=MedGrpID)
	..s bsAccUserId=$p(^DHCEMBSS(BsID),"^",9) /// 接班人
	..s bsAccUser=$p($g(^SSU("SSUSR",+bsAccUserId)),"^",2)
	..s CH=0
	..F  s CH=$O(^DHCEMBSS(BsID,"I",CH)) Q:CH=""  D
	...s EpisodeID=$P(^DHCEMBSS(BsID,"I",CH),"^",1)  /// 就诊ID
	.../// 病人就诊信息
	...s PatientID=$P(^PAADM(EpisodeID),"^",1)       /// 病人ID
	...s mradm=$P(^PAADM(EpisodeID),"^",61) 
	...s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 姓名
	...s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)   /// 登记号
	...Q:(argPatNo'="")&(argPatNo'=PatNo)
	...s PatWard=""
	...s WardDr=$P($g(^PAADM(EpisodeID)),"^",70)
	...i WardDr'="" s PatWard=$P($g(^PAWARD(WardDr)),"^",2)                       /// 病区
	...s:PatWard["-" PatWard=$p(PAAdmWard,"-",2)
	...s BedId=$P(^DHCEMBSS(BsID,"I",CH),"^",2)       /// 床号
	...I BedId'="" s PatBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)  /// 床号
	...E  s PatBed=""
	...I (PatBed'["床")&(PatBed'="") s PatBed=PatBed_##class(web.DHCEMCommonUtil).GetTrans("","床")
	...//s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
	...s bsBackground=$P(^DHCEMBSS(BsID,"I",CH),"^",4)  /// 生命体征
	...s bsAssessment=$P(^DHCEMBSS(BsID,"I",CH),"^",5)  /// 交班内容
	...s bsSuggest=$p(^DHCEMBSS(BsID,"I",CH),"^",10)    /// 建议
	...s Type=##Class(web.DHCEMBedSideShift).GetEmPatType(EpisodeID) /// 病人交班类型
	...s Num=Num+1
	...; 多语言
	...s bsUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",bsUser)
	...s bsAccUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",bsAccUser)
	...s ListData=BsID_"||"_CH_"^"_PatientID_"^"_EpisodeID_"^"_mradm_"^"_PatNo_"^"_PatName_"^"_PatBed
	...s ListData=ListData_"^"_bsBackground_"^"_bsAssessment_"^"_bsSuggest_"^"_bsDate_"^"_bsUser_"^"_bsAccUser_"^"_bsSchedule_"^"_pid_"^"_Type
	...s index=bsDate_"^"_Num
	...s TmpArr(index)=ListData
	...s ^TMP("DHCST","web.DHCEMBedSideShiftQuery","GetEmPatShiftHis",pid,index)=ListData
	.

	i Num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	s ListTitle="BsItmID^PatientID^EpisodeID^mradm^PatNo^PatName^PatBed^bsBackground^bsAssessment^bsSuggest^bsDate^bsUser^bsAccUser^bsSchedule^pid^Type"

	W ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
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

/// Creator: 		bianshuai
/// CreateDate: 	2019-11-15
/// Descript: 		急诊交班项目
/// Input:      
/// Output:
/// Others:		W ##Class(web.DHCEMBedSideShiftQuery).JsGetTriWorkLoad("DWL^2^2019-12-05^00:00^2019-12-06^23:00")
ClassMethod JsGetTriWorkLoad(mParams As %String) As %String
{
	n (mParams)

	k TmpArr
	s mCode=$p(mParams,"^",1)   /// 交班类型
	s HospID=$p(mParams,"^",2)  /// 医院ID
	s WardID=$p(mParams,"^",7)  /// 病区ID
	s mID=$o(^DHCEMDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:mID="" ""
	
	/// 抢救留观病区数据
	D ..GetEmSalWardMap(mParams, mID, .TmpArr)
	
	/// 预检分诊数据
	D ..GetNurChkLevMap(mParams, .TmpArr)
	
	//s ListTitle="itmID^itmCode^itmDesc^itmVal"
	s ListTitle="", ListData=""
	s itmID=""
	F  s itmID=$o(^DHCEMDI(0,"Type",mID,itmID)) Q:itmID=""  D
	.Q:$p(^DHCEMDI(itmID),"^",3)'="Y"
	.s itmCode=$p(^DHCEMDI(itmID),"^",1)  //项目代码
	.s itmDesc=$p(^DHCEMDI(itmID),"^",2)  //项目描述
	.s itmVal=+$g(TmpArr(itmCode))
	.//s TmpArr(itmID)=itmID_"^"_itmCode_"^"_itmDesc_"^"_itmVal
	.s ListData=$s(ListTitle'="":ListData_"^"_itmVal,1:itmVal)
	.s ListTitle=$s(ListTitle'="":ListTitle_"^"_"T"_itmID,1:"T"_itmID)
	.
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-15
/// Descript: 	  抢救留观病区数据
/// Input:      
/// Output:
/// Others:		W ##Class(web.DHCEMBedSideShiftQuery).GetEmSalWardMap("WWL^2^2019-11-28^00:00^2019-11-28^23:00^928","2",.TmpArr)
ClassMethod GetEmSalWardMap(mParams As %String, mID As %String, TmpArr) As %String
{
	n (mParams, mID, TmpArr)

	s HospID=$p(mParams,"^",2)      /// 医院ID
	s argLocID=$p(mParams,"^",7)    /// 科室ID
	s MedGrpID=$p(mParams,"^",8)    /// 医疗组ID
	s argWardID=$o(^PAWARD(0,"WARD_LocationDR",+argLocID,""))
	s MedGrpPrvArr=##class(web.DHCEMBedSideShift).GetMedGrpPrv(MedGrpID)  /// 医疗组医生指针列表
	
	k TmpWardArr
	D ..GetLastWardMap("WWL",.TmpArr)      /// 期初数(上次交班记录)
	D ..GetTrsInLocNewMap(mParams,.TmpArr) /// 状态变更记录
	D ##Class(web.DHCEMDocMainOutPat).jsonWard(HospID,.TmpWardArr)

	s WardID=""
	F  s WardID=$o(TmpWardArr(WardID)) Q:WardID=""  D
	.//Q:(argWardID'="")&(argWardID'=WardID)
	.s WardCode=$p(^PAWARD(WardID),"^",1)          /// 病区代码
	.s TmpArr("WardBeds")=..GetWardBedNums(WardID) /// 病区床位数
	.s RoomDr=0
	.F  s RoomDr=$O(^PAADMi("CurrWard",WardID,RoomDr)) Q:RoomDr=""  D
	..s EpisodeID=""
	..F  s EpisodeID=$O(^PAADMi("CurrWard",WardID,RoomDr,EpisodeID)) Q:EpisodeID=""  D
	...Q:$p(^PAADM(EpisodeID),"^",20)'="A"
	...D GetOutMap
	..
	.s CH=0
	.F  s CH=$O(^PAWARDA(WardID,"WADM",CH)) Q:CH=""  D
	..s EpisodeID=$P(^PAWARDA(WardID,"WADM",CH),"^",1)
	..Q:$p(^PAADM(EpisodeID),"^",20)'="A"
	..D GetOutMap
	.
	Q ""
GetOutMap
	s CarePrvID=$p(^PAADM(EpisodeID),"^",9)    /// 医生
	q:(MedGrpID'="")&'$LF($LISTFROMSTRING(MedGrpPrvArr,"^"),CarePrvID)
    s PatientID=$P(^PAADM(EpisodeID),"^",1)       /// 病人ID
	/// 急诊病区总人数(留观+抢救)
    s TmpArr("InitialPats")=$g(TmpArr("InitialPats"))+1
	/// 当前抢救/留察区总人数
    s TmpArr("PreWardAll")=$g(TmpArr("PreWardAll"))+1
    q:(argWardID'="")&(argWardID'=WardID) 0
    /// 单个病区人数
    s TmpArr("Pre_Pats")=$g(TmpArr("Pre_Pats"))+1
    /// 抢救/留察区人数
    s TmpArr("Ward_"_WardCode)=$g(TmpArr("Ward_"_WardCode))+1
    /// 全科需入院总人数
    i $D(^DHCEMWH(0,"ADM",EpisodeID)) s TmpArr("PreToHos")=$g(TmpArr("PreToHos"))+1
    /// 等待入院人数
    i ..isWaitToHos(EpisodeID) s TmpArr("WaitToHos")=$g(TmpArr("WaitToHos"))+1
    /// 当前急诊病区各科室人数
    s LocID=$p(^PAADM(EpisodeID),"^",4)   /// 就诊科室
	s LocCode=$p(^CTLOC(LocID),"^",1)     /// 科室代码
	i $LF($LB("310114","310113","310120","310116"),LocCode) s LocCode="mix"
	s TmpArr("Pre_"_LocCode)=$g(TmpArr("Pre_"_LocCode))+1
	s CareLevel=##Class(Nur.CommonInterface.Patient).getCareLevel(EpisodeID)
	i CareLevel["特级" s TmpArr("NurLevel")=$g(TmpArr("NurLevel"))+1
	i CareLevel["一级" s TmpArr("NurLevel1")=$g(TmpArr("NurLevel1"))+1
	i CareLevel["二级" s TmpArr("NurLevel2")=$g(TmpArr("NurLevel2"))+1
	i CareLevel["三级" s TmpArr("NurLevel3")=$g(TmpArr("NurLevel3"))+1
	/// 涉及医嘱数据
	D ##Class(web.DHCEMBedSideShiftQuery).GetPatOrderMap(EpisodeID,"",.TmpArr)
	s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)  /// 诊断
	/// 消化道出血
	i (PatDiag["消化道出血") s TmpArr("GasHem")=$g(TmpArr("GasHem"))+1
	/// 胃镜检查
	i (PatDiag["消化道出血")&(PatDiag["电子胃镜") s TmpArr("Gastros")=$g(TmpArr("Gastros"))+1
	/// 重大事件报告
	i $D(^DHCEMGPS(0,"PAPMI",PatientID)) s TmpArr("MajorEvent")=$g(TmpArr("MajorEvent"))+1
	/// 危重
	s PatType=##Class(Nur.CommonInterface.Patient).getIllState(EpisodeID)  /// 病人病情
	i PatType'="普通" s TmpArr("CriIll")=$g(TmpArr("CriIll"))+1
#;	/// 新入院
#;	s StayTimes=##Class(web.DHCEMInComUseMethod).GetPatStayTimes(EpisodeID)    /// 留观时间
#;	i $P(StayTimes,"^",1)=+$H s TmpArr("NewInHos")=$g(TmpArr("NewInHos"))+1

	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-15
/// Descript: 	  病区床位数
/// Input:      
/// Output:
/// Others:		W ##Class(web.DHCEMBedSideShiftQuery).GetWardBedNums("15")
ClassMethod GetWardBedNums(WardID As %String) As %String
{
	n (WardID)
	/// 床位数
	s CH=0, Num=0
	F  s CH=$o(^PAWARD(WardID,"BED",CH))  Q:CH=""  D
	.//Q:$p(^PAWARD(WardID,"BED",CH),"^",5)'="A"
	.s Num=Num+1
	.
	Q Num
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-28
/// Descript: 	  取上期交班数据
/// Input:      
/// Output:
/// Others:		W ##Class(web.DHCEMBedSideShiftQuery).GetLastWardMap("WWL",.TmpArr)
ClassMethod GetLastWardMap(Type As %String, TmpArr As %String) As %String
{
	n (Type, TmpArr)
	
	s WLID=$o(^DHCEMDWL(0,"Type",Type,""),-1)
	Q:WLID="" ""
	s CH=""
	F  s CH=$o(^DHCEMDWL(WLID,"I",CH)) Q:CH=""  D
	.s itmID=$p(^DHCEMDWL(WLID,"I",CH),"^",1)  /// id
	.s itmCode=$p(^DHCEMDI(itmID),"^",1)       /// 项目代码
	.Q:itmCode'["Pre_"
	.s itmVal=$p(^DHCEMDWL(WLID,"I",CH),"^",2) /// 值
	.s TmpArr($REPLACE(itmCode,"Pre_","For_"))=itmVal
	.
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-28
/// Descript: 	  按照状态变更记录统计
/// Input:      
/// Output:
/// Others:		W ##Class(web.DHCEMBedSideShiftQuery).GetTrsInLocNewMap("^^2019-11-20^00:00^2019-11-28^00:00",.TmpArr)
ClassMethod GetTrsInLocNewMap(mParams As %String, TmpArr As %String) As %String
{
	n (mParams, TmpArr)
	
	s StartDate=$p(mParams,"^",3)   /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	s StartTime=$p(mParams,"^",4)   /// 开始时间
	i StartTime'="" s StartTime=$zth(StartTime,3)
	s EndDate=$p(mParams,"^",5)     /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s EndTime=$p(mParams,"^",6)     /// 结束时间
	i EndTime'="" s EndTime=$zth(EndTime,3)
	
	s StatCodes=$LB("Salvage","Stay","NearDeathPreDischarge","Inhospital","SignDischarge","AutoDischarge","OrderDischarge","Discharge","DisDeath")
	s LevStatCodes=$LB("Discharge") //"SignDischarge","AutoDischarge","OrderDischarge",
	F dd=StartDate:1:EndDate D
	.s StatDr=""
	.F  s StatDr=$o(^DHCADMVisitStatus(0,"DateStatus",dd,StatDr)) Q:StatDr=""  D
	..s AvsId=""
	..F  s AvsId=$o(^DHCADMVisitStatus(0,"DateStatus",dd,StatDr,AvsId)) Q:AvsId=""  D
	...s EpisodeID=$P(^DHCADMVisitStatus(AvsId),"^",1) /// 就诊ID
	...s PvsId=$P(^DHCADMVisitStatus(AvsId),"^",2)
   	...s StatCode=$P(^DHCPACVisitStatus(PvsId),"^",1)
   	...Q:'$LF(StatCodes,StatCode)
	...s Time=$P(^DHCADMVisitStatus(AvsId),"^",6) /// 时间
	...Q:(dd=StartDate)&(StartTime>Time)&(StartTime'="")
	...Q:(dd=EndDate)&(EndTime<Time)&(EndTime'="")
	...s LocID=$p(^PAADM(EpisodeID),"^",4)     /// 就诊科室
	...s LocCode=$p(^CTLOC(LocID),"^",1) 	   /// 科室代码
	...s LocDesc=$p(^CTLOC(LocID),"^",2) 	   /// 科室描述
	...i $LF($LB("310114","310113","310120","310116"),LocCode) s LocCode="mix"
	.../// 自动离科人数
	...i StatCode="NearDeathPreDischarge" D
	....s TmpArr("Left_"_LocCode)=$g(TmpArr("Left_"_LocCode))+1
	....s TmpArr("DeathPreDis")=$g(TmpArr("DeathPreDis"))+1  /// 自动离院1
	.../// 新入科人数
	...i (StatCode="Salvage")||(StatCode="Stay") D
	....s TmpArr("New_"_LocCode)=$g(TmpArr("Left_"_LocCode))+1 /// 新入各科室
	....s TmpArr("NewWardAll")=$g(TmpArr("NewWardAll"))+1   /// 新入抢救留察
	.../// 新入院人数
	...i StatCode="Inhospital" D
	....s TmpArr("In_"_LocCode)=$g(TmpArr("In_"_LocCode))+1
	....s TmpArr("NewInAll")=$g(TmpArr("NewInAll"))+1
	.../// 离科人数
	...i $LF(LevStatCodes,StatCode) D
	....s TmpArr("Disc_"_LocCode)=$g(TmpArr("Disc_"_LocCode))+1
	....s TmpArr("Disc_All")=$g(TmpArr("Disc_All"))+1  /// 离科
	.../// 死亡
	...i StatCode="DisDeath" D
	....s TmpArr("DisDeath")=$g(TmpArr("DisDeath"))+1
	...
	
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-15
/// Descript: 	  抢救留观待入院数据
/// Input:      
/// Output:
/// Others:		W ##Class(web.DHCEMBedSideShiftQuery).GetPatOrderMap("15","",.TmpArr)
ClassMethod GetPatOrderMap(EpisodeID As %String, TypeID As %String, TmpArr) As %String
{
	n (EpisodeID, TypeID, TmpArr)
	k TmpConfigArr
	D ..GetArcConfig(.TmpConfigArr)     /// 初始化配置数据
	s itemCode=""
	F  s itemCode=$o(TmpConfigArr(itemCode)) Q:itemCode=""   D
	.//Q:'$D(^DHCEMCDI(0,"Code",$$ALPHAUP^SSUTIL4(itemCode)))
	.s arcimCodes=$g(TmpConfigArr(itemCode))
	.Q:arcimCodes=""
	.i ..isExist(EpisodeID, arcimCodes, "") s TmpArr(itemCode)=$g(TmpArr(itemCode))+1
	.
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-15
/// Descript: 	  医嘱项配置数据，以后有必要做配置
/// Input:      
/// Output:
/// Others:		W ##Class(web.DHCEMBedSideShiftQuery).GetArcConfig("191")
ClassMethod GetArcConfig(TmpConfig) As %String
{
	n (TmpConfig)
	/// 监护人次
	s TmpConfig("Care")="310701022A"  ///心电监测（急诊用）
	/// 心脏按压
	s TmpConfig("HeaPre")="330100012"  ///心肺复苏术
	/// 无创通气人数
	s TmpConfig("NonVen")="310603002a^310603002b^310603002c"  ///无创辅助通气,无创辅助通气(包括持续气道正压CPAP),无创辅助通气(双水平气道正压BIPAP)
	/// 灌肠人次
	s TmpConfig("Enema")="121500001a^121500001b"  /// 灌肠(一般灌肠),灌肠(保留灌肠)
	/// 静脉采血
	s TmpConfig("VenBloods")=""  ///用法
	/// 雾化人次
	s TmpConfig("Atomi")="120700001a" /// 雾化吸入
	/// 清创缝合
	s TmpConfig("DebSut")="120500001^120500002^120500003"  ///大,中,小清创缝合
	/// 冰毯降温
	s TmpConfig("IceCool")="121100002"  ///特殊物理降温
	/// 气管插管
	s TmpConfig("EndInt")="330100013^330100014^1701335^1701346^1701347"  ///气管插管术,特殊方法气管插管术,一次性气管插管(史密斯,带囊)(进口,英国),一次性气管插管(Covidien,各规格)(进口,美国),一次性气管插管包(康力,标准型)(国产,山东)
	/// 无创通气时间
	s TmpConfig("NonVen")="310603002a^310603002b^310603002c"  ///医嘱同上，但这个取的是数量
	/// 静脉推注
	s TmpConfig("IntInj")=""   ///用法
	/// 换药人次
	s TmpConfig("Dress")="120600002^120600003^120600004"   ///大中小换药
	/// 洗胃人次
	s TmpConfig("GasLav")="121000001a^121000001b"   ///洗胃,洗胃(使用洗胃机)
	/// 病危人次
	s TmpConfig("CriIll")="21030089"  ///书面病危通知+医生签署病危通知书(怎么取?)
	/// 除颤人次
	s TmpConfig("Defibr")="310702017"   ///心脏电除颤术
	/// 机械通气时间
	s TmpConfig("MecVent")="310603001"   ///呼吸机辅助呼吸小时数+累加数(?)
	/// 胃管人次
	s TmpConfig("Tube")="120900001b"  ///插胃管 不全
	/// 肌肉注射
	s TmpConfig("Intra")=""   ///用法
	/// 皮下注射
	s TmpConfig("SubInj")=""   ///用法
	/// 约束人次
	s TmpConfig("Constr")="21030099" /// 保护性约束护理
	/// 抢救人次
	s TmpConfig("Rescue")="120200001,120200002,120200003" /// 大抢救,中抢救,小抢救
	/// 尿管人次
	s TmpConfig("UriTube")="121600001c^121600001b"  /// 导尿(留置导尿第一次以后),导尿(留置导尿第一次)
	/// 口咽/鼻咽通气管
	s TmpConfig("NasVenTube")="1701330^1701328"  ///口咽通气道(Teleflex,各规格)(进口,美国),鼻咽通气道(Covidien,成人/儿童)(进口,美国)
	/// 高危液体
	s TmpConfig("HighRiskLiq")="2116041^2116013^2040061^2040081^2116062^2111014^2113041^2115033^2112031^2116062^2112012^2102021^2231061^2192048^2131041^2141043^2091042^2091044^2091048^2091049^2340191^2152013^2050051^2050054^2123032^2283012"  
	///盐酸多巴胺注射液,盐酸肾上腺素,盐酸洛贝林,尼可刹米,去甲肾上腺素,去乙酰毛花苷注射液[西地兰][2ml:0.4mg],硝酸甘油注射液,注射用硝普纳,盐酸普罗帕酮注射液,酒石酸去甲肾上腺素注射液,盐酸胺碘酮注射液,硫酸阿托品注射液,氯化钾注射液,胰岛素注射液,碳酸氢钠注射液(2种规格),丙泊酚(4),甘露醇(2),盐酸哌替啶注射液(2),异丙肾上腺素注射液,亚甲蓝注射液
	/// 呼吸机
	s TmpConfig("BreMac")="310603002a^310603002b^310603002c"  ///无创辅助通气,无创辅助通气(包括持续气道正压CPAP),无创辅助通气(双水平气道正压BIPAP)
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-15
/// Descript: 	  抢救留观待入院数据
/// Input:      
/// Output:
/// Others:		W ##Class(web.DHCEMBedSideShiftQuery).isWaitToHos("191")
ClassMethod isWaitToHos(EpisodeID As %String, Type As %String) As %String
{
	n (EpisodeID, Type)
	s quitflag=0
	s WtID=$o(^DHCEMWH(0,"ADM",EpisodeID,""))
	Q:WtID="" 0
    Q:$p(^DHCEMWH(WtID),"^",6)'="Y" 0
	s CH=""
	F  s CH=$o(^DHCEMWH(WtID,"I",CH)) Q:(CH="")||(quitflag=1)  D
	.s InLoc=$p(^DHCEMWH(WtID,"I",CH),"^",1)
	.s CsRes=$p(^DHCEMWH(WtID,"I",CH),"^",2) /// 会诊结果
	.i CsRes="W" s quitflag=1
	.
	Q quitflag
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-15
/// Descript: 	  预检分诊数据
/// Input:      
/// Output:
/// Others:		W ##Class(web.DHCEMBedSideShiftQuery).GetNurChkLevMap("191")
ClassMethod GetNurChkLevMap(mParams As %String, TmpArr) As %String
{
	n (mParams, TmpArr)
	
	s StartDate=$p(mParams,"^",3)   /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	s StartTime=$p(mParams,"^",4)   /// 开始时间
	i StartTime'="" s StartTime=$zth(StartTime,3)
	s EndDate=$p(mParams,"^",5)     /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s EndTime=$p(mParams,"^",6)     /// 结束时间
	i EndTime'="" s EndTime=$zth(EndTime,3)
	b ///UUUU
	F dd=StartDate:1:EndDate D
	.s EmPCLvID = 0
	.F  s EmPCLvID=$o(^DHCEMPCL(0,"CreateDate",dd,EmPCLvID)) Q:EmPCLvID=""  D
	..s CreateDate=$p(^DHCEMPCL(EmPCLvID),"^",4)  /// 分诊日期
	..s CreateTime=$p(^DHCEMPCL(EmPCLvID),"^",5)  /// 分诊时间
	..Q:(CreateDate=StartDate)&(StartTime>CreateTime)&(StartTime'="")
	..Q:(CreateDate=EndDate)&(EndTime<CreateTime)&(EndTime'="")
    ..s EmRecLevel=$p(^DHCEMPCL(EmPCLvID),"^",6)  /// 推荐分级
	..s TmpArr("Lev_"_EmRecLevel)=$g(TmpArr("Lev_"_EmRecLevel))+1
	../// 分级变更
	..i $D(^DHCEMDUPL(0,"PatCheckLev",EmPCLvID)) s TmpArr("UpdLev"_EmRecLevel)=$g(TmpArr("UpdLev"_EmRecLevel))+1
	../// 亚绿色通道
	..s SpecDisCode=##Class(web.DHCEMPatCheckLevQuery).GetEmHisMoreCode(EmPCLvID,"YLTD")
	..i SpecDisCode'="" s TmpArr("YLSTD")=$g(TmpArr("YLSTD"))+1
	..i SpecDisCode="CP" s TmpArr("CP")=$g(TmpArr("CP"))+1  /// 胸痛
	..i SpecDisCode="SC" s TmpArr("SC")=$g(TmpArr("SC"))+1  /// 卒中
	..i SpecDisCode="HRPW" s TmpArr("HRPW")=$g(TmpArr("HRPW"))+1  /// 高危孕产妇
	..i SpecDisCode="ICN" s TmpArr("ICN")=$g(TmpArr("ICN"))+1     /// 危重儿童及新生儿
	../// 中毒人数
	..s EmPoisonFlag=$p(^DHCEMPCL(EmPCLvID),"^",28)   /// 中毒
	..i EmPoisonFlag="Y" s TmpArr("Poison")=$g(TmpArr("Poison"))+1
	../// 重返人数
	..s EmAgainFlag=$p(^DHCEMPCL(EmPCLvID),"^",11) 	/// 重返标识
	..i EmAgainFlag="Y" s TmpArr("Again")=$g(TmpArr("Again"))+1
	../// 三无人数
	..s EmTypeID=+$p(^DHCEMPCL(EmPCLvID),"^",40) 	/// 特殊人群
    ..i $p($g(^DHCEMPT(EmTypeID)),"^",2)["三无" s TmpArr("NonOfs")=$g(TmpArr("NonOfs"))+1
    ../// 重返人数
	..s EmAgainFlag=$p(^DHCEMPCL(EmPCLvID),"^",11) 	/// 重返标识
	..i EmAgainFlag="Y" s TmpArr("Again")=$g(TmpArr("Again"))+1
	../// 院外死亡
	..s EmPatSource=$p(^DHCEMPCL(EmPCLvID),"^",15) 	/// 病人来源
	..i EmPatSource'="" s EmPatSource=$p(^DHCEMPSO(EmPatSource),"^",2)
	..i EmPatSource["院外死亡" s TmpArr("Death")=$g(TmpArr("Death"))+1
	../// 院外死亡
	..s EmPatSource=$p(^DHCEMPCL(EmPCLvID),"^",15) 	/// 病人来源
	..i EmPatSource'="" s EmPatSource=$p(^DHCEMPSO(EmPatSource),"^",2)
	..i EmPatSource["院外死亡" s TmpArr("Death")=$g(TmpArr("Death"))+1
	../// 院外救护车转入
	..i EmPatSource["外院120" s TmpArr("TrsIn")=$g(TmpArr("TrsIn"))+1
	../// 本院出诊人次
	..i EmPatSource["本院120" s TmpArr("VisNum")=$g(TmpArr("VisNum"))+1
	../// 本院出诊人次
	..i EmPatSource["本院120" s TmpArr("VisNum")=$g(TmpArr("VisNum"))+1
	../// ECG标志
	..s ECGFlag=$p(^DHCEMPCL(EmPCLvID),"^",27) 	    /// ECG标志
	..i ECGFlag="Y" s TmpArr("ECG")=$g(TmpArr("ECG"))+1
	../// 就诊科室人数统计
	..s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,""))
	..i EmPccID'="" D
	...s LocID=$p(^DHCEMPCC(EmPccID),"^",3)   /// 就诊科室
	...s LocCode=$p(^CTLOC(LocID),"^",1) 	  /// 科室代码
	...i $LF($LB("310114","310113","310120","310116"),LocCode) s LocCode="mix"
	...s TmpArr("Loc_"_LocCode)=$g(TmpArr("Loc_"_LocCode))+1
	../// 就诊总人次
	..s PatientID = $p(^DHCEMPCL(EmPCLvID),"^",1) /// 病人ID
	..i PatientID'="" s TmpArr("VisTotal")=$g(TmpArr("VisTotal"))+1
	../// 绿色通道人次
	..s EmAdmID=$o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,""))
	..i EmAdmID'="" D
	...s EpisodeID=+$p(^DHCEMPCA(EmAdmID),"^",2)
	...i ##Class(web.DHCEMPatGreenRec).checkGreenRec(EpisodeID) s TmpArr("GreenPass")=$g(TmpArr("GreenPass"))+1
	../// 未就诊人数
	..i ##Class(web.DHCADMVisitStat).GetPatCurStat(EpisodeID)="" D
	...s TmpArr("NoVisNum")=$g(TmpArr("NoVisNum"))+1 
	../// 蛇伤中毒
	..s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)  /// 诊断
	..i (PatDiag["蛇")&(PatDiag["中毒") D
	...s TmpArr("SnakePoison")=$g(TmpArr("SnakePoison"))+1
	../// 响应超时(诊疗时间超过30分钟：分诊-就诊)
	..i ..isOverTime(EpisodeID) D
	...s TmpArr("OTLev_"_EmRecLevel)=$g(TmpArr("OTLev_"_EmRecLevel))+1
	../// 重大事件报告
	..i $D(^DHCEMGPS(0,"PAPMI",PatientID)) s TmpArr("MajorEvent")=$g(TmpArr("MajorEvent"))+1
	../// 外籍
	..s CountryDr=$p(^PAPER(PatientID,"PER",1),"^",8) 	 /// 国家
	..i $p($g(^CT("COU",+CountryDr)),"^",2)'="中国" s TmpArr("Foreign")=$g(TmpArr("Foreign"))+1
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-15
/// Descript: 	  病人就诊是否超时 
/// Input:      
/// Output:
/// Others:		 W ##Class(web.DHCEMBedSideShiftQuery).isOverTime(345)
ClassMethod isOverTime(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s AdmDate=$p(^PAADM(EpisodeID),"^",6)  /// 就诊日期
	s AdmTime=$p(^PAADM(EpisodeID),"^",7)  /// 就诊时间
	s MrID=$o(^MR(EpisodeID,"DIA",0))
	Q:MrID="" 0
	s MrDate=$p(^MR(EpisodeID,"DIA",MrID),"^",7)   /// 日期
	s MrTime=$p(^MR(EpisodeID,"DIA",MrID),"^",8)   /// 时间
	i ((MrDate-AdmDate)*86400+MrTime - AdmTime)/60 >30 Q 1
	Q 0
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-15
/// Descript: 	  病人是否存在某条医嘱
/// Input:      
/// Output:
/// Others:		W ##Class(web.DHCEMBedSideShiftQuery).isExist("","","")
ClassMethod isExist(EpisodeID As %String, ArcimCodes As %String, Type As %String) As %String
{
	n (EpisodeID, ArcimCodes, Type)
	s isFlag=0
	F i=1:1:$l(ArcimCodes,",") Q:isFlag=1  D
	.s itmCode=$p(ArcimCodes,",",i)
	.Q:itmCode=""
	.s itmmastid=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(itmCode),""))
	.Q:itmmastid=""
	.s itmmastver=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(itmCode),itmmastid,""))
	.Q:itmmastver=""
	.s arcimid=itmmastid_"||"_itmmastver
	.s isFlag=##Class(web.DHCSETIMAGE).GetCareTypeByOrd(EpisodeID, arcimid)
	.//i Type="" s isFlag=##Class(web.DHCSETIMAGE).GetCareTypeByOrd(EpisodeID, arcimid)
	.//E  s isFlag=##Class(web.DHCSETIMAGE).GetCareTypeByOrd(EpisodeID, arcimid)
	Q isFlag
}

/// Descript: 急诊病人列表留观复选框列表
/// W ##Class(web.DHCEMBedSideShiftQuery).jsonWard(2, .TmpArr)	
ClassMethod jsonWard(HospID As %String, TmpArr As %String) As %String
{
	n (HospID, TmpArr)
	s WardID=0 
	F  s WardID=$o(^PAWARD(WardID)) Q:(+WardID=0)  D
    .Q:$p(^PAWARD(WardID),"^",6)'="Y"
    .s WardDesc=$p($g(^PAWARD(WardID)),"^",2)
    .s LocID=$p(^PAWARD(WardID),"^",5)
    .Q:LocID=""
    .Q:'$d(^CTLOC(LocID))
    .Q:$p(^CTLOC(LocID),"^",13)'="EM"
    .Q:'$o(^PAWARD(WardID,"ROOM",0))
    .Q:$p(^CTLOC(LocID),"^",22)'=HospID
    .s DateFrom=$P(^PAWARD(WardID),"^",7)
 	.s DateTo=$P(^PAWARD(WardID),"^",9)
 	.Q:((+$h<DateFrom)&&(DateFrom'=""))!((+$h>DateTo)&&(DateTo'=""))
	.s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	.s TmpArr(WardID)=WardDesc
	Q ""
}

/// Descript:  获取打印数据
/// W ##Class(web.DHCEMBedSideShiftQuery).GetPrintDetail("1")
ClassMethod GetPrintDetail(pid As %String) As %String
{
	n (pid)
	
	///转换数据为Json格式
	s ListTitle="BsItmID^PatientID^EpisodeID^mradm^PatNo^PatName^PatBed^bsBackground^bsAssessment^bsSuggest^bsDate^bsUser^bsAccUser^bsSchedule"

	W "[" //输出json前缀串
	s index="",count=0
	F  s index=$o(^TMP("DHCST","web.DHCEMBedSideShiftQuery","GetEmPatShiftHis",pid,index)) Q:index=""  D
	.s ListData=$g(^TMP("DHCST","web.DHCEMBedSideShiftQuery","GetEmPatShiftHis",pid,index))
	.Q:ListData=""
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-15
/// Descript: 	  病人是否有交班日志
/// Input:      
/// Output:
/// Others:		W ##Class(web.DHCEMBedSideShiftQuery).HasLog("")
ClassMethod HasLog(EpisodeID As %String, Type As %String) As %String
{
	n (EpisodeID, Type)
	s isFlag=0
	s bsID=""
	F  s bsID=$o(^DHCEMBSS(0,"ADM",EpisodeID,bsID)) Q:(bsID="")||(isFlag=1)  D
	.Q:$p(^DHCEMBSS(bsID),"^",4)'=Type
	.Q:$p(^DHCEMBSS(bsID),"^",10)'="Y"        /// 完成
	.s isFlag=1
	.
	Q isFlag
}

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	Q ##Class(web.DHCAPPExaRepCom).NewPid()
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCEMBedSideShiftQuery","GetEmPatShiftHis",pid)
	q ""
}

}
