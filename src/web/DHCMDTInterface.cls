Import sqluser

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript: 	 MDT会诊申请接口类
Class web.DHCMDTInterface Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:    bianshuai
/// CreateDate: 2019-04-15
/// Descript:   ""
/// InPut:      mListData - ""
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMConsInterface).Insert("")
ClassMethod Insert(mListData As %String) As %String
{
	n (mListData)
	s $ZT="ErrorMsg"
	s Err=0
	Q Err
ErrorMsg
	Q "-99"
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-12
/// Descritp:    取消信封消息
/// w ##Class(web.DHCMDTInterface).InvExecMes("3","4634")
ClassMethod InvExecMes(CstID As %String, UserID As %String) As %String
{
	n (CstID, UserID)
	s CH="",Err=0
	F  s CH=$o(^DHCMDTCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.//Q:(ItmID'="")&(ItmID'=(CstID_"||"_CH))
	.s Err=..InvExec(CstID_"||"_CH, UserID)
	.
	Q Err
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-12
/// Descritp:    执行信封消息
/// w ##Class(web.DHCMDTInterface).InvExec("3","4634")
ClassMethod InvExec(itmID As %String, UserID As %String) As %String
{
	n (itmID, UserID)
	s EpisodeID = $p(^DHCMDTCON(+itmID),"^",1)
	//处理消息
	s Ret = ##class(websys.DHCMessageInterface).Exec("","1014",EpisodeID,"",itmID,UserID)
	i Ret="-3" s Ret=0    /// -3 未找到消息
	i Ret="-102" s Ret=0  /// -102 消息已执行过
	q:(Ret<0)&&(Ret'=-102)&&(Ret'=-3) Ret
	s:Ret>0 Ret=0 //hxy 2018-12-09  web.DHCEMConsInterface.UpdCstOpinion接口
	q Ret
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-12
/// Descript:    发送申请消息
/// Input :      发送医生，就诊，接收医生，科室ID，申请ID
/// w ##Class(web.DHCMDTInterface).InvExec("3","4634")
ClassMethod SendMsgToDoc(CsRUserID As %String, EpisodeID As %String, ReceiveDocs As %String, LocID As %String, mdtID As %String, LinkFlag As %String) As %String
{
	n (CsRUserID, EpisodeID, ReceiveDocs,LocID, mdtID, LinkFlag)
	q:CsRUserID="" "-1001"
	q:EpisodeID="" "-1002"
	i LinkFlag=1 s LinkUrl="dhcmdt.platform.csp"
	E  s LinkUrl=""
	i LinkUrl'="" s LinkUrl=""""_LinkUrl_"?EpidsodeID="_EpisodeID_"&CstID="_+mdtID_""""
	s Link="{""link"":"_LinkUrl_",""BizObjId"":"_""""_mdtID_""""_",""dialogWidth"":"_1400_",""dialogHeight"":"_600_"}"
	s ToLocRowId=LocID_"|OnlyFlag"
	s Ret=##class(websys.DHCMessageInterface).Send("有MDT申请","1177",CsRUserID , EpisodeID,"",ReceiveDocs, Link,ToLocRowId)
	q Ret
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-12
/// Descript：   发送申请消息
/// w ##class(web.DHCMDTInterface).SendCsReqMsg("3")
ClassMethod SendCsReqMsg(mdtID As %String, mFlag As %String = "") As %String
{
	n (mdtID, mFlag)
	s EpisodeID = $p(^DHCMDTCON(mdtID),"^",1)  /// 就诊ID
	s CsRUserID = $p(^DHCMDTCON(mdtID),"^",5)  /// 创建人
	s ReceiveDocs=""
	i mFlag=3  D
	.s contUserInfo=##Class(web.DHCMDTCom).GetDisGrpConsUserID(mdtID) /// 联络员
	.s LocID=$p(contUserInfo,"^",1),userID=$p(contUserInfo,"^",2)
	.Q:userID=""
	.s Err=..SendMsgToDoc(CsRUserID,EpisodeID,userID,LocID,mdtID,1)
	E  D
	.s CH=0, Err=0
	.F  s CH=$o(^DHCMDTCON(mdtID,"I",CH)) Q:(CH="")  D   /// ||(Err'=0)
	..s LocID=$p(^DHCMDTCON(mdtID,"I",CH),"^",1)      /// 会诊科室
	..s CareProvID=$p(^DHCMDTCON(mdtID,"I",CH),"^",2) /// 会诊医生
	..Q:LocID="" 
	..s userID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	..Q:userID=""
	..s Err=..SendMsgToDoc(CsRUserID,EpisodeID,userID,LocID,mdtID_"||"_CH,0)
	.
	Q Err
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-12
/// Descript:    调用停医嘱接口
/// W ##Class(web.DHCMDTInterface).InvStopOrder("85722","13")
ClassMethod InvStopOrder(mdtID As %String, LgUserID As %String) As %String
{
	n (mdtID, LgUserID)
	s Err=0, BillId=""
	F  s BillId=$o(^DHCMDTORD(0,"IndexCst",mdtID,BillId)) Q:BillId=""  D
	.s Oeori=$p(^DHCMDTORD(BillId),"^",2)  /// 医嘱ID
	.Q:Oeori=""
	.//s OeFlag=..GetOrderStatCode(Oeori)    /// 医嘱状态
	.//Q:OeFlag'="V"
	.s Err=##Class(DHCDoc.Interface.Inside.MDT.Service).StopOrd(Oeori,LgUserID) /// 停医嘱
	.
	Q Err
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-12
/// Descript:    医嘱当前状态
/// W ##Class(web.DHCMDTInterface).GetOrderStatCode("85722||1")
ClassMethod GetOrderStatCode(Oeori As %String) As %String
{
	n (Oeori)
	Q:Oeori="" ""
	s itmID=$p($g(^OEORD(+Oeori,"I",$p(Oeori,"||",2),1)),"^",13)
	Q:itmID="" ""
	s ExeCode=$p(^OEC("OSTAT",itmID),"^",1)
	Q ExeCode
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-17
/// Descript:    调用预约挂号接口
/// W ##Class(web.DHCMDTInterface).InvDocApp("33","876^299^191^3")
ClassMethod InvDocApp(CstID As %String, LgParams As %String) As %String
{
	n (CstID, LgParams, %session)
	s Err=0
	s HospID=$p(LgParams,"^",1)     /// 医院ID
	s HasCenter=##Class(web.DHCMDTCom).GetEmSysConfig("HASCENTER",HospID)  //是否具有会诊中心
	s EpisodeID=$p(^DHCMDTCON(CstID),"^",1)    /// 申请就诊ID
	s PatType=$p($g(^PAADM(+EpisodeID)),"^",2) /// 病人类型  /// bianshuai 2020-02-24
	TS

	/// 调用挂号接口
	i ((PatType'="I")&((HasCenter=0)||(HasCenter=2)))||(HasCenter=1) s Err=..InvReg(CstID, LgParams)

	i Err'=0 tro
	Q:Err'=0 "挂号失败,失败信息:"_Err
	
	/// 生成会诊医嘱
	s Err=##Class(web.DHCMDTConsult).InsCstOeori(CstID, LgParams)
	i Err'=0 tro
	Q:Err'=0 "插入会诊费用医嘱失败,失败信息:"_Err
	TC
	Q 0
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-17
/// Descript:    调用挂号接口
/// W ##Class(web.DHCMDTInterface).InvReg("33","876^299^191^3")
ClassMethod InvReg(CstID As %String, LgParams As %String) As %String
{
	n (CstID, LgParams, %session)
	
	/// 调用挂号接口
	s AdmID=..InvDocAppReg(CstID, LgParams)
	Q:AdmID=-204 "挂号失败,失败信息:预约渠道为空！"
	Q:+AdmID<0 "挂号失败,失败信息:"_AdmID
	
	/// 预约就诊ID
	s Err=##Class(web.DHCMDTConsult).InsMasAppAdm(CstID,AdmID)
	Q:Err'=0 "记录预约就诊ID失败!"
	
	Q 0
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-17
/// Descript:    调用预约挂号接口
/// W ##Class(web.DHCMDTInterface).InvDocAppReg("85722||1","13")
ClassMethod InvDocAppReg(CstID As %String, LgParams As %String) As %String
{
	n (CstID, LgParams, %session)
	s EpisodeID=$p(^DHCMDTCON(CstID),"^",1)	/// 就诊ID
	s PatientID=$p(^DHCMDTCON(CstID),"^",26) ///病人ID
	s MakResID=$p(^DHCMDTCON(CstID),"^",18)	/// 预约资源ID
	s LgHospID=$p(LgParams,"^",1)  /// 医院ID
	s LgLocID=$p(LgParams,"^",2)   /// 科室ID
	s LgGroupID=$p(LgParams,"^",3) /// 安全组ID
	s LgUserID=$p(LgParams,"^",4)  /// 用户ID
	s BillTypeID=$P(^PAADM(EpisodeID,1),"^",7) /// 费别指针
	s FeeStr="1||1||0||0"
	/// 调用挂号接口 -202 无号
	s ret=##Class(DHCDoc.Interface.Inside.MDT.Service).OPRegist(PatientID, MakResID, BillTypeID, FeeStr, "", LgUserID, LgGroupID, LgLocID, LgHospID)
	s ErrorCode=$p(ret,"$",1) /// 错误代码
	Q:+ErrorCode<0 ErrorCode
	s EpisodeID=+$p(ret,"$",2) /// 就诊ID
	Q EpisodeID
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-17
/// Descript:    调用预约退号接口
/// W ##Class(web.DHCMDTInterface).InvDocRetReg("33","876")
ClassMethod InvDocRetReg(CstID As %String, LgParams As %String) As %String
{
	n (CstID, LgParams)
	s EpisodeID=$p(^DHCMDTCON(CstID),"^",20)	/// 就诊ID
	s LgHospID=$p(LgParams,"^",1)  /// 医院ID
	s LgLocID=$p(LgParams,"^",2)   /// 科室ID
	s LgGroupID=$p(LgParams,"^",3) /// 安全组ID
	s LgUserID=$p(LgParams,"^",4)  /// 用户ID
	/// 调用挂号接口
	s ret=##Class(DHCDoc.Interface.Inside.MDT.Service).CancelOPRegist(EpisodeID, LgUserID, LgGroupID, LgLocID, "", LgHospID)
	Q +ret
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-17
/// Descript:    调用退号接口
/// W ##Class(web.DHCMDTInterface).InvDocRet("36","876")
ClassMethod InvDocRet(CstID As %String, LgParams As %String) As %String
{
	n (CstID, LgParams)
	s Err=0
	TS
	/// 调用退号接口(释放号别资源)
	s EpisodeID=$p(^DHCMDTCON(CstID),"^",20)	/// 就诊ID
	i +EpisodeID'=0 s Err=..InvDocRetReg(CstID, LgParams)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 调用停医嘱接口
	s LgUserID=$p(LgParams,"^",4)  /// 用户ID
	s Err=..InvStopOrder(CstID, LgUserID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	TC
	Q Err
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-18
/// Descript:    修改预约资源时间
/// W ##Class(web.DHCMDTInterface).TakMakResDate("55","20/07/2019")
ClassMethod TakMakResDate(mdtID As %String, MakResID As %String, LgUserID As %String) As %String
{
	n (mdtID, MakResID, LgUserID)
	s EpisodeID=$p(^DHCMDTCON(mdtID),"^",20)	/// 就诊ID
	Q:EpisodeID="" 0
	s BillId="", OrderList=""
	F  s BillId=$o(^DHCMDTORD(0,"IndexCst",mdtID,BillId)) Q:BillId=""  D
	.s Oeori=$p(^DHCMDTORD(BillId),"^",2)  /// 医嘱ID
	.Q:Oeori=""
	.s OrderList=$s(OrderList="":Oeori,1:OrderList_"^"_Oeori)
	.
	/// 修改就诊与医嘱日期
	s ret=##Class(DHCDoc.Interface.Inside.MDT.Service).ChangeDate(EpisodeID, OrderList, MakResID, LgUserID)
	s Err=+$p(ret,"^",1) /// 返回值
	Q Err
}

/// Creator:     qqa
/// CreateDate:  2019-04-25
/// Descript:    挂号回调接口
/// Return  :    0:成功，其他：失败
/// W ##Class(web.DHCMDTInterface).InsetMdtAppAdm("3112||1||8")
ClassMethod InsetMdtAppAdm(MCAppointID As %String) As %String
{
	n (MCAppointID)

	q:'$d(^DHCMDTCON(0,"Appoint",MCAppointID)) 0
	s CstID = $o(^DHCMDTCON(0,"Appoint",MCAppointID,""),-1)
	b ;err
	s ID=+MCAppointID
	s Itm = $p(MCAppointID,"||",2)
	s Sub = $p(MCAppointID,"||",3)
	s AdmID = $P(^RBAS(ID,Itm,"APPT",Sub),"^",4)
	s Err=0
	ts
	s Err = ##Class(web.DHCMDTConsult).InsMasAppAdm(CstID,AdmID)   //记录预约产生的就诊ID
	i Err'=0 tro 1
	q:Err'=0 "-1"
	
	s Err = ##Class(web.DHCMDTConsult).InsCstOeori(CstID, "")
	i Err'=0 tro 1
	q:Err'=0 "-2"
	tc
	
	Q Err
}

/// Creator:     qqa
/// CreateDate:  2019-04-25
/// Descript:    会诊医嘱收费调用
/// Input   : Ords(ord1^ord2...),P(交钱)/C(退钱)
/// Return  : 0:成功，其他：失败
/// W ##Class(web.DHCMDTInterface).MdtConsOrdPayMoney("","P")
ClassMethod MdtConsOrdPayMoney(Ords As %String, Model As %String) As %String
{
	n (Ords,Model)
	q:Ords="" 0
	s Bill=""
	s:Model="P" Bill="Y"
	s:Model="C" Bill="N"
	s TMPCstList=""
	s Len = $l(Ords,"^")
	s Err=0
	f i=1:1:Len q:Err'=0  d
	.s OrdItm = $p(Ords,"^",i)
	.q:OrdItm="" 
	.q:'$d(^DHCMDTORD(0,"IndexOrd",OrdItm))
	.s MORowID = $o(^DHCMDTORD(0,"IndexOrd",OrdItm,""),-1)
	.s CstID = $p(^DHCMDTORD(MORowID),"^",1)
	.s TMPCstList(CstID)=""
	.s Err = ##Class(web.DHCMDTConsult).UpdConsOeori(MORowID,Bill)
	q:Err'=0 Err
	
	s CstID=""
	f  s CstID = $o(TMPCstList(CstID)) q:(CstID="")||(Err'=0)  d
	.s PayMony = ##Class(web.DHCMDTCom).GetConsIsPayMoney(CstID)
	.q:PayMony'=1
	.s Err = ##class(web.DHCMDTConsult).InsWebsysMessage(CstID)
	.q:+Err'=0
	.;给外院专家推一个消息下载app
	.s Err = ##class(web.DHCMDTConsult).SendOuterDocMessage(CstID)
	.
	.
	
	Q Err
}

ClassMethod SendOuterDocMessage(MdtID)
{
	q ##class(web.DHCMDTConsult).SendVcUrlNew(MdtID,1)
}

/// Creator:     qqa
/// Descript:	推链接给会诊专家
/// Input:		会诊ID
/// Return:		0/其他(成功/失败)
/// W ##Class(web.DHCMDTInterface).SendVcUrl("1")
ClassMethod SendVcUrl(MdtID)
{
	
	q ##class(web.DHCMDTConsult).SendVcUrl(MdtID,"")
}

/// Creator:     qqa
/// CreateDate:  2019-04-25
/// Descript:    判断医嘱是否是MDT会诊医嘱
/// Input   : 	 MDT会诊
/// Return  :    0:非MDT会诊医嘱，1：MDT会诊医嘱
/// W ##Class(web.DHCMDTInterface).IsMdtOrd("1||1")
ClassMethod IsMdtOrd(OrdItm As %String) As %String
{
	n (OrdItm)
	s Ret=0
	s:$d(^DHCMDTCON(0,"ReqOrd",OrdItm)) Ret=1
	Q Ret
}

/// Creator:     qqa
/// CreateDate:  2019-04-25
/// Descript:    判断就诊是否MDT预约产生的就诊
/// Input   : 	 就诊ID
/// Return  :    0:非MDT会诊就诊，1：MDT会诊产生的就诊
/// W ##Class(web.DHCMDTInterface).IsMdtAppAdm(AdmID)
ClassMethod IsMdtAppAdm(AdmID As %String) As %String
{
	n (AdmID)
	s Ret=0
	s:$d(^DHCMDTCON(0,"AppAdm",AdmID)) Ret=1
	Q Ret
}

/// Creator:    	bianshuai
/// CreateDate: 	2019-07-09
/// Descript:   	MDT收费成功时，发短信给病人
/// InPut:      	CstID - 会诊申请ID, Type - 消息类型
/// OutPut:     	0-成功，其他-失败
/// w ##Class(web.DHCMDTInterface).SendMsgProxy("7","R")
ClassMethod SendMsgProxy(ID As %String, Type As %String) As %String
{
	n (ID, Type)
	s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	/// 病人信息
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s TelH=$p($g(^PAPER(PatientID,"PER",1)),"^",11) /// 电话
	s CsUserID=$p(^DHCMDTCON(ID),"^",5)             /// 申请医生
	s CstRUser=$p($g(^SSU("SSUSR",+CsUserID)),"^",2)
	s DisGrpID=$p(^DHCMDTCON(ID),"^",16)            /// 疑难病种
	s DisGroup=$p($g(^DHCMDTG(+DisGrpID)),"^",2)
	s CsNPlace=$p(^DHCMDTCON(ID),"^",10)    /// 会诊地点
	s CsRLocID=$p(^DHCMDTCON(ID),"^",2)     /// 申请科室
	s HospID=$p(^CTLOC(CsRLocID),"^",22)    /// 医院ID
	s HospDesc=$p($g(^CT("HOSP",+HospID)),"^",2)
	s CsNDate=$p(^DHCMDTCON(ID),"^",8)      /// 会诊日期
	s mdtMakResID = $p(^DHCMDTCON(ID),"^",18)       /// 资源表ID
	s CsDataTimeRange=##Class(web.DHCMDTCom).JsMakResDateTime(mdtMakResID)
	s CsDataRange=$p(CsDataTimeRange,"^",1) /// 日期
	s CsTimeRange=$p(CsDataTimeRange,"^",2) /// 时间
	s CsTimeWeek=$p(CsDataTimeRange,"^",3)  /// 周几
	s CsData=CsDataRange
	s AssTime=CsDataRange_"("_CsTimeWeek_")" /// 评估时间 日期(周几)几时几分
	s CsTime=CsDataRange_"("_CsTimeWeek_")"_" "_CsTimeRange  /// 会诊时间 日期(周几)几时几分

	s mTemp=..GetSysMsgTemp(Type, HospID)   /// 短消息模板
	Q:mTemp="" ""
	s mTemp=$REPLACE(mTemp, "{ 病人姓名 }", PatName)   /// 病人姓名
	s mTemp=$REPLACE(mTemp, "{ 申请医师 }", CstRUser)  /// 申请医师
	s mTemp=$REPLACE(mTemp, "{ 病种名称 }", DisGroup)  /// 疑难病种
	s mTemp=$REPLACE(mTemp, "{ 会诊日期 }", CsNDate)   /// 会诊日期
	s mTemp=$REPLACE(mTemp, "{ 会诊时间 }", CsTime)    /// 会诊时间
	s mTemp=$REPLACE(mTemp, "{ 会诊地点 }", CsNPlace)  /// 会诊地点
	s mTemp=$REPLACE(mTemp, "{ 医院名称 }", HospDesc)  /// 医院名称
	s mTemp=$REPLACE(mTemp, "{", """_..Format(")
	s mTemp=$REPLACE(mTemp, "}", ")_""")
	x "s mListData="_""""_mTemp_""""

#;	/// MDT发送申请时，发短信给病人
#;	if (Type = "R"){
#;		s mListData="尊敬的"_PatName_"，您好，北京协和医院"_CstRUser_"医生已为您申请"_DisGroup_"疑难病会诊，请您持患者本人身份证到门诊楼四层疑难病会诊中心办理预约手续，"
#;		s mListData=mListData_"预约时间：工作日上午8:30-11:30，下午13:30-16:00。会诊申请三个工作日内有效,未在规定时间内办理预约手续，会诊申请将自动作废。"
#;		s mListData=mListData_"（此信息不作为预约成功的标志,准确的会诊日期以疑难病会诊中心通知为准）"
#;	}
#;	
#;	/// MDT收费成功时，发短信给病人
#;	if (Type = "F"){
#;		s mListData="尊敬的"_PatName_"，您好，您已成功预约北京协和医院"_DisGroup_"疑难病会诊，地点：门诊楼四层疑难病会诊中心。请您务必携带好相关资料，准时于"_AssTime_"到我中心进行会诊前评估问诊，"
#;		s mListData=mListData_"并于"_CsTime_"准时参加会诊。北京协和医院疑难病会诊中心"
#;	}
#;	
#;	/// 评估问诊前一日，系统自动向患者推送提醒信息
#;	if (Type = "A"){
#;		s mListData="尊敬的"_PatName_"，提醒您携带诊疗相关资料，准时于"_AssTime_"于门诊楼四层疑难病会诊中心，进行"_DisGroup_"疑难病会诊前评估问诊。特别提示：未完成会诊前评估问诊的患者将无法进行会诊。"
#;	}
#;	
#;	/// 患者会诊前一日，系统自动向患者推送提醒信息
#;	if (Type = "C"){
#;		s mListData="尊敬的"_PatName_"，您好，您预约了北京协和医院"_DisGroup_"疑难病会诊，提醒您携带相关资料，准时于"_CsTime_"进行会诊，地点：门诊楼四层疑难病会诊中心。"
#;	}
#;	
#;	/// 评估问诊和会诊前一日，系统自动向患者推送提醒信息
#;	if (Type = "T"){
#;		s mListData="尊敬的"_PatName_"，您好，您预约了北京协和医院"_DisGroup_"疑难病会诊，提醒您携带相关资料，准时于"_CsTime_"到达门诊楼四层疑难病会诊中心，"
#;		s mListData=mListData_"进行会诊前评估；并于当日"_CsTime_"同一地点进行会诊。特别提示：未完成会诊前评估问诊的患者将无法进行会诊。"
#;	}
	
	i $L(TelH)=11 D ..TakMsgToPat(TelH, mListData)
	Q 0
}

/// Descript:    调用短信平台接口
ClassMethod TakMsgToPat(TelH As %String, mListData As %String) As %String
{
	n (TelH, mListData)
	s $zt="LinkErrMsg"
	i $L(TelH)=11 D ##class(DHCENS.REG.BO.SendSMSMessageInfo).SendMessageInfo(TelH, mListData)
	Q 0
LinkErrMsg
    Q "-1"
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-08-07
/// Descript:   	短消息模板
/// InPut:      	Type - 消息类型
/// OutPut:     	消息模板，空
/// w ##Class(web.DHCMDTInterface).GetSysMsgTemp("7")
ClassMethod GetSysMsgTemp(mType As %String, HospID As %String) As %String
{
	n (mType, HospID)
	s mTempID=$o(^DHCMDTSMST(0,"Code",$$ALPHAUP^SSUTIL4(mType),HospID,""))
	Q:mTempID="" ""
	s mTemp=$g(^DHCMDTSMST(mTempID,"I",1))
	Q mTemp
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-08-07
/// Descript:   	格式化
/// InPut:      	data - 待格式化数据
/// OutPut:     	格式化后数据
/// w ##Class(web.DHCMDTInterface).Format("7")
ClassMethod Format(resDate As %String) As %String
{
	n (resDate)
	s resDate=$SYSTEM.SQL.YEAR(resDate)_"年"_$SYSTEM.SQL.MONTH(resDate)_"月"_$SYSTEM.SQL.DAYOFMONTH(resDate)_"日"
	Q resDate
}

/// Creator:     qqa
/// CreateDate:  2019-04-25
/// Descript:    通过预约ID获取MDT会诊ID
/// Input   : 	 MDT就诊ID
/// Return  :    "":非MDT预约就诊，>0:MDT会诊ID
/// W ##Class(web.DHCMDTInterface).GetMdtIdAppAdm(472)
ClassMethod GetMdtIdAppAdm(AppAdmID As %String) As %String
{
	n (AppAdmID)
	s CstID=""
	q:'$d(^DHCMDTCON(0,"AppAdm",AppAdmID)) ""
	s CstID = $o(^DHCMDTCON(0,"AppAdm",AppAdmID,""))
	q CstID
}

/// Creator:     qqa
/// CreateDate:  2019-06-20
/// Descript:    病例修改会诊意见后回调接口
/// Input   : 	 会诊组唯一标识，病历实例ID
/// Return  :    0:成功，其他:失败
/// W ##Class(web.DHCMDTInterface).IsMdtAppAdm(AdmID)
ClassMethod MedHisUpdOpin(CstID, InstanceID)
{
	n (CstID,InstanceID)
	;董工提供获取数据的接口
	s Opinion=""
	s Ret = ##class(web.DHCMDTConsult).UpdCstOpinion(CstID,Opinion)
	q Ret
}

/// Creator:     qqa
/// CreateDate:  2019-06-20
/// Descript:    病例返回InstanceID
/// Input   : 	 会诊组唯一标识，病历实例ID，UserID
/// Return  :    0:成功，其他:失败
/// W ##Class(web.DHCMDTInterface).UpdMedHisInstanceId(CstID,InstanceID)
ClassMethod UpdMedHisInstanceId(CstID, InstanceID, UserID = "")
{
	n (CstID,InstanceID,UserID)
	q:CstID="" -1
	q:InstanceID="" -2
	&SQL(UPDATE DHC_MDTConsult SET MC_Instance_Dr =:InstanceID WHERE MC_RowID = :CstID)
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2019-07-18
/// Descript:   通过会诊ID或者病种ID获取需要挂的号别
/// w ##Class(web.DHCMDTInterface).JsGetResWeekPlan("","2","1")
ClassMethod JsGetResWeekPlan(CstID As %String, DisGrpID As %String, offset As %String) As %String
{
	n (CstID, DisGrpID, offset)
	s StartDate=+$H+(7-$SYSTEM.SQL.DAYOFWEEK(+$H))+(7*(offset-1))+1 /// 开始日期
	s EndDate=StartDate+6 /// 结束日期
	i offset=0 s StartDate=+$H
	s ListTitle="",ListData=""
	F dd=StartDate:1:EndDate D
	.s Week=($SYSTEM.SQL.DAYOFWEEK(dd)-1)
	.s ListTitle=$s(ListTitle="":"Week_"_Week,1:ListTitle_"^"_"Week_"_Week)
	.s ListData=$s(ListData="":$p($zd(dd,3),"-",2,3),1:ListData_"^"_$p($zd(dd,3),"-",2,3))
	.
	w ##Class(web.DHCAPPJsonCommon).getJsonChildPrefixSign(ListTitle,ListData)
	w ",""items"":"
	D ##Class(web.DHCMDTInterface).JsGetWeekPlan(CstID, DisGrpID, StartDate, EndDate)
	w "}"
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2019-07-18
/// Descript:   通过会诊ID或者病种ID获取需要挂的号别
/// w ##Class(web.DHCMDTConsultQuery).JsGetWeekPlan("","2")
ClassMethod JsGetWeekPlan(CstID As %String, DisGrpID As %String, StartDate As %String, EndDate As %String) As %String
{
	n (CstID, DisGrpID, StartDate, EndDate)
	s:CstID'="" DisGrpID=$p(^DHCMDTCON(CstID),"^",16)
	Q:+DisGrpID=0 ""
	s ID=$o(^DHCMDTCP(0,"Group",DisGrpID,""),-1) 
	s LocID=$p(^DHCMDTCP(ID),"^",2)    /// 科室ID
	s PrvID=$p(^DHCMDTCP(ID),"^",3)    /// 号别ID
	s HospID=$p(^CTLOC(LocID),"^",22)  /// 医院ID
	//s StartDate=+$H, EndDate=+$H+7   /// 一周
	s result=##Class(%Library.ResultSet).%New("DHCDoc.Interface.Inside.MDT.Service:FindRBASList")
	Set sc=result.Execute(LocID,PrvID,StartDate,EndDate,"",HospID)   //DOC是诊间预约
 	If $$$ISERR(sc) Quit ""
    Set colNum=result.GetColumnCount() //列数
 	w "["
	s count=0,del=""""
	While(result.Next())
	{ 	
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		
		s CsDate=$p(result.%GetData(4),$C(13,10)) /// 日期
		Continue:(CsDate="")
		
		s TimeRange=$p(result.%GetData(3),$C(13,10)) /// 时间范围
		s CsDate=##class(web.DHCMDTCom).DateHtmlToLogical(CsDate)
		s Week="Week_"_($SYSTEM.SQL.DAYOFWEEK(CsDate)-1)
		s Week=Week_"_"_$s(TimeRange="上午":"AM",1:"PM")
		s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)  /// 病种专业组
		s CsTime=$p($p(result.%GetData(8),$C(13,10)),"-",1)
		s ret=ret_","_del_"DisGroup"_del_":"_del_DisGroup_del_","_del_"Week"_del_":"_del_Week_del_","_del_"CsTime"_del_":"_del_CsTime_del
		
		s count=count+1
		If count=1 Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	}
	w "]"
	Do result.Close()
	Q ""
}

/// Creator:     qqa
/// CreateDate:  2019-06-20
/// Descript:    获取MDT会诊数据
/// Input   : 	 会诊组唯一标识
/// Return  : 患者姓名^性别^年龄^出生日期^卡号^病案号
/// 				^联系电话^通讯地址^邮编^主持人描述^
/// 				会诊日期^会诊地址^病情摘要^会诊目的^
/// 				会诊意见^科室1&用户1&用户职称1@科室2&用户2&用户职称2
/// 				^登记号^就诊科室^病区^床号^诊断^会诊类别^申请科室
/// 				^申请医生
/// W ##Class(web.DHCMDTInterface).GetMdtConsData(1)
ClassMethod GetMdtConsData(ID) As %String
{
	n (ID)
	Q:'$D(^DHCMDTCON(ID)) ""
	s EpisodeID=$p(^DHCMDTCON(ID),"^",1)      /// 就诊ID
	s AppAdmID =$p(^DHCMDTCON(ID),"^",20)
	s PatientID=$p(^DHCMDTCON(ID),"^",26)
	s:EpisodeID'="" PatientID = $p(^PAADM(EpisodeID),"^",1) ///患者ID	
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	   /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	s PatSex=""
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID)  /// 年龄
	s Birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	i Birthday'="" s Birthday=$zd(Birthday,3)
	s IdentNo=$p(^PAPER(PatientID,"ALL"),"^",9)         /// 身份证号
	s NationDr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  /// 民族
	s CountryDr=$p(^PAPER(PatientID,"PER",1),"^",8) 	/// 国家
	s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	s PatCardNo=""
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
	s:CardNoID'="" PatCardNo=$p($g(^DHCCARD("CF",PatientID)),"^",2) 			 /// 卡号
	s MedicalNo=##Class(web.DHCMDTCom).IGetMrNoByEpisodeID(EpisodeID)  /// 病案号
	s PostCode=""
	s DHCPerID =$o(^DHCPERSON(0,"PAPERSON",PatientID,""),-1)
	s:DHCPerID'="" PostCode=$p(^DHCPERSON(DHCPerID),"^",8)
	s PatType=$p($g(^PAADM(+EpisodeID)),"^",2)     /// 就诊类型
	s CstRLocID=$p(^DHCMDTCON(ID),"^",2)      /// 申请科室
	s CstRLoc=""
	s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	s CsHospID=$p(^CTLOC(CstRLocID),"^",22)  /// 医院ID
	s CstRDate=$p(^DHCMDTCON(ID),"^",3)      /// 申请日期
	s:CstRDate'="" CstRDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)
	s CstRTime=$p(^DHCMDTCON(ID),"^",4)      /// 申请时间
	s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	s CstRUser=""
	s CstUserID=$p(^DHCMDTCON(ID),"^",5)    /// 申请医生
	s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	s CstTrePro=$p(^DHCMDTCON(ID),"^",6)    /// 病情及诊疗经过
	s CstPurpose=$p(^DHCMDTCON(ID),"^",7)   /// 会诊的理由和目的
	s CstNDate=$p(^DHCMDTCON(ID),"^",8)     /// 会诊日期
	s:CstNDate'="" CstNDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)
	s PreDate="",PreTime=""
	s PreDateInfo = ##Class(web.DHCMDTCom).GetPreDateInfo(ID) ///预约时间
	s PreDate = $p(PreDateInfo,"^",1)
	s PreTimeRange = $p(PreDateInfo,"^",2)
	s CstNTime=$p(^DHCMDTCON(ID),"^",9)     /// 会诊时间
	s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	s CstNPlace=$p(^DHCMDTCON(ID),"^",10)   /// 会诊地点
	s TreMeasures=$p(^DHCMDTCON(ID),"^",11) /// 最终治疗措施
	s CstUser=$p(^DHCMDTCON(ID),"^",13)     /// 联系人
	s CstPhone=$p(^DHCMDTCON(ID),"^",14)    /// 联系电话
	s HostDes=##class(web.DHCMDTCom).ConsCompUser(ID)		/// 主持人
	s PreDateTime=PreDate_" "_PreTimeRange
	
	s Loc=$P($g(^PAADM(AppAdmID)),"^",4)
	s PAAdmDepCodeDR=$P($g(^CTLOC(Loc)),"^",2)
	i PAAdmDepCodeDR["-" s PAAdmDepCodeDR=$p(PAAdmDepCodeDR,"-",2)
	s AdmWard="",AdmSeatNo="",AdmDiag=""
	
	s ConsLocs=""
	s CH=""
	i ID'="" D
	.F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	..s LocDesc=""
	..s LocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)          /// 科室ID
	..s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	..s CareProv=""
	..s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",2)     /// 医生
	..s:CareProvID'="" CareProv=$p(^CTPCP(CareProvID,1),"^",2)
	..s PrvTpID="",PrvTp=""
	..s PrvTpID=$p(^DHCMDTCON(ID,"I",CH),"^",4)       /// 职称
	..i PrvTpID'="" s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	..s:ConsLocs'="" ConsLocs=ConsLocs_"@"_LocID_"&"_PrvTp_"&"_CareProv
	..s:ConsLocs="" ConsLocs=LocID_"&"_PrvTp_"&"_CareProv
	s ListData=PatName_"^"_PatSex_"^"_PatAge_"^"_Birthday_"^"_PatCardNo_"^"_MedicalNo_"^"_PatTelH
	s ListData=ListData_"^"_Address_"^"_PostCode_"^"_HostDes_"^"_PreDateTime_"^"_CstNPlace
	s ListData=ListData_"^"_CstTrePro_"^"_CstPurpose_"^"_TreMeasures
	s ListData=ListData_"^"_ConsLocs_"^"_PatNo_"^"_PAAdmDepCodeDR_"^"_AdmWard_"^"_AdmSeatNo
	s ListData=ListData_"^"_AdmDiag_"^"_"MDT会诊"_"^"_CstRLoc_"^"_CstRUser
	Q ListData
}

/// Creator:     qqa
/// CreateDate:  2019-06-20
/// Descript:    获取MDT会诊数据
/// Input   : 	 MDT预约就诊ID
/// Return  : 患者姓名^性别^年龄^出生日期^卡号^病案号
/// 				^联系电话^通讯地址^邮编^主持人描述^
/// 				会诊日期^会诊地址^病情摘要^会诊目的^
/// 				会诊意见^科室1&用户1&用户职称1@科室2&用户2&用户职称2
/// 				^登记号^就诊科室^病区^床号^诊断^会诊类别^申请科室
/// 				^申请医生
/// W ##Class(web.DHCMDTInterface).GetMdtConsDataInAppAdmID(9660900)
ClassMethod GetMdtConsDataInAppAdmID(AppAdmID) As %String
{
	n (AppAdmID)
	s CstID = ##Class(web.DHCMDTInterface).GetMdtIdAppAdm(AppAdmID)
	q:+CstID=0 ""
	s Ret=##Class(web.DHCMDTInterface).GetMdtConsData(CstID)
	q Ret
}

/// Creator:     qqa
/// CreateDate:  2019-06-20
/// Descript:    获取MDT会诊数据
/// Input   : 	 InstanceID
/// Return  : 科室ID^科室描述^UserID^UserName!!科室ID1^科室描述1^UserID1^UserName1...
/// W ##Class(web.DHCMDTInterface).GetMdtConsLocInfoByInstanceID("49928||1")
ClassMethod GetMdtConsLocInfoByInstanceID(InstanceID) As %String
{
	n (InstanceID)
	q:'$d(^DHCMDTCON(0,"IndexInstance",InstanceID)) ""
	s Ret=""
	s ID = $o(^DHCMDTCON(0,"IndexInstance",InstanceID,""))
	s CH=""
	i ID'="" D
	.F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	..s LocDesc=""
	..s LocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)          /// 科室ID
	..s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	..s CareProv="",UserID=""
	..s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",2)     /// 医生
	..s:CareProvID'="" CareProv=$p(^CTPCP(CareProvID,1),"^",2)
	..s:CareProvID'="" UserID=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
	..s Tmp=LocID_"^"_LocDesc_"^"_UserID_"^"_CareProv
	..s:Ret'="" Ret=Ret_"!!"_Tmp
	..s:Ret="" Ret=Tmp
	q Ret
}

/// Creator:     qqa
/// CreateDate:  2018-12-24
/// Descript:    通过会诊申请医嘱查找MDT会诊是否未完成
/// InPut:       医嘱ID
/// OutPut:      0-完成，1-未完成, ""-不存在会诊
/// w ##Class(web.DHCMDTInterface).IsCompMdtConsByOrd("9624820||137")
ClassMethod IsCompMdtConsByOrd(OrderID As %String) As %String
{
	n (OrderID)
	Q:OrderID="" 0
	/// 请会诊医嘱
	s ID=$o(^DHCMDTORD(0,"IndexOrd",OrderID,""))
	q:ID="" 0
	s CstID=$p(^DHCMDTORD(ID),"^",1)
	s MLRowID = $o(^DHCMDTL(0,"CstRef",CstID,""),-1)
	s Status=$p(^DHCMDTL(MLRowID),"^",3)
	s:Status'="" Status=$p($g(^DHCMDTS(+Status)),"^",2)
	q:Status="撤销" 0   ///撤销状态医嘱会更改为撤销
	q:Status="完成" 0
	Q 1
}

/// Creator:    qqa
/// CreateDate: 2019-10-31
/// Descript:   医嘱是否是MDT会诊医嘱
/// InPut:      Oeori - 医嘱ID,
/// OutPut:     1-是; 0-不是
/// w ##Class(web.DHCMDTInterface).IsCstOeori("")
ClassMethod IsCstOeori(Oeori As %String) As %String
{
	n (Oeori)
	Q:Oeori="" 0
	/// 请会诊医嘱
	s ID=$o(^DHCMDTORD(0,"IndexOrd",Oeori,""))  
	Q:ID'="" 1
	Q 0
}

/// Creator:      bianshuai
/// CreateDate:   2018-04-25
/// Descript:     取病人MDT会诊列表【电子病历资源界面调用】
/// InPut:        EpisodeID - 就诊ID
/// OutPut:       病人ID^姓名^登记号^性别^科室^病区^费别^床号^出生日期^联系方式^地址^病案号^诊断^就诊ID^申请科室ID^申请科室^申请日期^申请时间^申请人ID^申请人^简要病历^会诊目的^要求会诊日期^要求会诊时间^要求会诊地点^最终治疗措施^联系人^联系电话^打印标志^疑难病种^会诊讨论内容^补充内容^患者第几次会诊次数^会诊医生^会诊科室
/// D ##Class(%ResultSet).RunQuery("web.DHCMDTInterface","QryPatMDTConsList","94")
Query QryPatMDTConsList(EpisodeID As %String) As websys.Query(ROWSPEC = "IPatientID:%String,PatName:%String,PatNo:%String,PatSex:%String,PatLoc:%String,PatWard:%String,BillType:%String,PatBed:%String,PatBod:%String,PatTelH:%String,PatAddr:%String,MedicareNo:%String,PatDiagDesc:%String,EpisodeID:%String,CstRLocID:%String,CstRLoc:%String,CstRDate:%String,CstRTime:%String,CstUserID:%String,CstRUser:%String,CstTrePro:%String,CstPurpose:%String,CstNDate:%String,CstNTime:%String,CstNPlace:%String,TreMeasures:%String,CstUser:%String,CstPhone:%String,PrintFlag:%String,DisGroup:%String,DisProcess:%String,Suppnotes:%String,MCTimes:%String,CstPrvArr:%String,CstLocArr:%String")
{
}

ClassMethod QryPatMDTConsListExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    k TmpArr

    /// 会诊申请列表
	D ..GetPatMDTConsult(EpisodeID, .TmpArr)
	
    s index=""
	F  s index=$o(TmpArr(index))  Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpPatExaArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-25
/// Descript:   取病人MDT会诊列表
/// InPut:      EpisodeID - 就诊ID
/// OutPut:     会诊内容内容，空
/// w ##Class(web.DHCMDTInterface).GetPatMDTConsult("")
ClassMethod GetPatMDTConsult(EpisodeID As %String, TmpArr As %String = "") As %String
{
	n (EpisodeID, TmpArr)
	s Num=0
	s ID=""
	F  s ID=$o(^DHCMDTCON(0,"Adm",EpisodeID,ID)) Q:ID=""  D
	.s EpisodeID=$p(^DHCMDTCON(ID),"^",1)   /// 就诊ID
	.s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) ///年龄
	.s PatLoc=""
	.s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	.s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	.s PatWard=""
	.s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	          /// 病区ID
	.s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	.s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	.s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	.s BedId=$p(^PAADM(EpisodeID),"^",73) 				/// 床号ID
    .s PatBed=""
    .s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
    .s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	/// 电话 
	.s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	.s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	.i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	.s MedicareNo=##Class(web.DHCMDTCom).IGetMrNoByEpisodeID(EpisodeID)  ///病案号
	.s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")   /// 诊断
	.s CstRLocID=$p(^DHCMDTCON(ID),"^",2)   /// 申请科室
	.s CstRLoc=""
	.s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	.s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	.s CstRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)	
	.s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	.s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	.s CstRUser=""
	.s CstUserID=$p(^DHCMDTCON(ID),"^",5)   /// 申请医生
	.s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	.s CstTrePro=$p(^DHCMDTCON(ID),"^",6)   /// 病情及诊疗经过
	.s CstPurpose=$p(^DHCMDTCON(ID),"^",7)  /// 会诊的理由和目的
	.s CstNDate=$p(^DHCMDTCON(ID),"^",8)    /// 会诊日期
	.s CstNDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)	
	.s CstNTime=$p(^DHCMDTCON(ID),"^",9)   /// 会诊时间
	.s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	.s CstNPlace=$p(^DHCEMCON(ID),"^",10)  /// 会诊地点
	.s TreMeasures=$p(^DHCMDTCON(ID),"^",11)  /// 最终治疗措施
	.s CstUser=$p(^DHCMDTCON(ID),"^",13)      /// 联系人
	.s CstPhone=$p(^DHCMDTCON(ID),"^",14)     /// 联系电话
	.s PrintFlag=$p(^DHCMDTCON(ID),"^",15)    /// 打印标志
	.s DisGrpID=$p(^DHCMDTCON(ID),"^",16)     /// 疑难病种
	.s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	.s DisProcess=$p(^DHCMDTCON(ID),"^",23)    /// 会诊讨论内容
	.s Suppnotes=$p(^DHCMDTCON(ID),"^",25)     /// 补充内容
	.s MCTimes=$p(^DHCMDTCON(ID),"^",22)       /// 患者第几次会诊次数
	.s CstPrvArr="",CstLocArr=""
	.s CH=""
	.F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	..s CsLocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)       /// 会诊科室
	..s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	..s:CsLocDesc["-" CsLocDesc=$p(CsLocDesc,"-",2)
	..s CareProvID=+$p(^DHCMDTCON(ID,"I",CH),"^",2)
	..i CareProvID=0 s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",3) 
	..s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	..s CstPrvArr=$s(CstPrvArr="":CsUser,1:CstPrvArr_"、"_CsUser)
	..s CstLocArr=$s(CstLocArr="":CsLocDesc,1:CstLocArr_"、"_CsLocDesc)
	.s Num=Num+1
	.s ListData=PatientID_"^"_PatName_"^"_PatNo_"^"_PatSex_"^"_PatLoc_"^"_PatWard_"^"_BillType_"^"_PatBed_"^"_PatBod_"^"_PatTelH_"^"_PatAddr_"^"_MedicareNo_"^"_PatDiagDesc
    .s ListData=ListData_"^"_EpisodeID_"^"_CstRLocID_"^"_CstRLoc_"^"_CstRDate_"^"_CstRTime_"^"_CstUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose_"^"_CstNDate_"^"_CstNTime
    .s ListData=ListData_"^"_CstNPlace_"^"_TreMeasures_"^"_CstUser_"^"_CstPhone_"^"_PrintFlag_"^"_DisGroup_"^"_DisProcess_"^"_Suppnotes_"^"_MCTimes_"^"_CstPrvArr_"^"_CstLocArr
	.s TmpArr(Num)=ListData
	.

    Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2020-04-22
/// Descritp:   MDT医嘱对应会诊是否已撤销
/// InPut:      oeori - 医嘱ID
/// OutPut:     1-是, 0-否
/// W ##Class(web.DHCMDTInterface).GetCsRevFlagByOeori("417||3")
ClassMethod GetCsRevFlagByOeori(oeori As %String) As %String
{
	n (oeori)
	Q:oeori="" 1
	s ID=$o(^DHCMDTORD(0,"IndexOrd",oeori,""))
	Q:ID="" 1
	s CsID=$p(^DHCMDTORD(ID),"^",1)
	s statusID=$p(^DHCMDTCON(CsID),"^",12)   /// 状态ID
	Q:$p($g(^DHCMDTS(+statusID)),"^",2)="撤销" 1
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2020-04-22
/// Descritp:   MDT预约号对应会诊是否已撤销
/// InPut:      EpisodeID - 就诊ID
/// OutPut:     1-是, 0-否
/// W ##Class(web.DHCMDTInterface).GetCsRevFlagByAdm("")
ClassMethod GetCsRevFlagByAdm(EpisodeID As %String) As %String
{
	n (EpisodeID)
	Q:EpisodeID="" 1
	s ID=$o(^DHCMDTCON(0,"AppAdm",EpisodeID,""))
	Q:ID="" 1
	s statusID=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	Q:$p($g(^DHCMDTS(+statusID)),"^",2)="撤销" 1
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2020-06-28
/// Descritp:   停止MDT会诊医嘱时，取消申请
/// InPut:      oeori - 医嘱ID
/// OutPut:     0-取消成功, -1-取消失败
/// W ##Class(web.DHCMDTInterface).CancelCsREQ("417||3")
ClassMethod CancelCsREQ(Oeori As %String, UserID As %String) As %String
{
	n (Oeori, UserID)
	Q:Oeori="" 0
	s ID=$o(^DHCMDTORD(0,"IndexOrd",Oeori,""))
	Q:ID="" 0
	s CsID=$p(^DHCMDTORD(ID),"^",1)
	s RecLocID=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",6)
	s HospID=$p(^CTLOC(RecLocID),"^",22)
	Q:..GetCsRevFlagByOeori(Oeori) 0  /// 已撤销退出
	Q:##Class(web.DHCMDTConsult).RevCsREQ(CsID, UserID, HospID) -1
	Q 0
}

/// Creator:      bianshuai
/// CreateDate:   2020-08-07
/// Descritp:     系统任务，3日内会诊未完成时，提醒MDT秘书
/// InPut:      
/// OutPut:       0-成功，-99-失败
/// W ##Class(web.DHCMDTInterface).InvSystemTask("")
ClassMethod InvSystemTask() As %String
{
	//s $ZT="ErrMsgSysTask"
	k TmpArr
    s StartDate=+$H-3, EndDate=+$H
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"NDate",dd,ID)) Q:ID=""  D
	..s statusID=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	..Q:$p($g(^DHCMDTS(+statusID)),"^",1)=80
	..s CsRUserID=$p(^DHCMDTCON(ID),"^",5)   /// 申请医生
	..s GrpLeaInfo=##Class(web.DHCMDTCom).GetDisGrpConsUserID(ID)
	..s userID=$p(GrpLeaInfo,"^",2) /// MDT专家组组长
	..s TelH=$p(^SSU("SSUSR",userID),"^",99) /// 电话
	..Q:TelH=""
	..s TmpArr(TelH)=$g(TmpArr(TelH))+1
	.

	s index=""
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s TelH=index
	.s WComNum=$g(TmpArr(index))
	.s mListData="您有"_WComNum_"条待完成MDT会诊，请及时处理！"
	.i $L(TelH)=11 D ..TakMsgToPat(TelH, mListData)
	.
	Q 0
	
ErrMsgSysTask
	Q "-99"
}

/// Creator:    bianshuai
/// CreateDate: 2020-08-13
/// Descritp:   发送会诊信息【远程会诊平台接口】
/// InPut:      ID - 会诊ID
/// OutPut:     申请单信息, 空
/// W ##Class(web.DHCMDTInterface).SendCsToRCP("417||3")
ClassMethod SendCsToRCP(ID As %String) As %String
{
	n (ID)
	
	/// 会诊单内容
	D ..GetCsContent(ID, .TmpArr)
	
	/// 远程平台接口
	
	Q 1
}

/// Creator:    bianshuai
/// CreateDate: 2020-08-13
/// Descritp:   会诊申请单内容
/// InPut:      ID - 会诊ID
/// OutPut:     申请单信息, 空
/// W ##Class(web.DHCMDTInterface).GetCsContent("417||3")
ClassMethod GetCsContent(ID As %String) As %String
{
	n (ID)
	Q:'$D(^DHCMDTCON(ID)) ""
	s EpisodeID=$p(^DHCMDTCON(ID),"^",1)      /// 就诊ID
	s PatientID = $p(^PAADM(EpisodeID),"^",1) ///患者ID	
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	   /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	s PatSex=""
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	s PatSex=##class(web.DHCMDTCom).GetMulLanTrsDesc("Sex","EN",PatSex)  /// 多语言支持
	s PatAge=##class(web.DHCMDTCom).GetPapmiAge(EpisodeID)  /// 年龄 //ed
	s Birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	i Birthday'="" s Birthday=$zd(Birthday,3)
	s IdentNo=$p(^PAPER(PatientID,"ALL"),"^",9)         /// 身份证号
	s NationDr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  /// 民族
	s CountryDr=$p(^PAPER(PatientID,"PER",1),"^",8) 	/// 国家
	s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s PatBill=##class(web.DHCDoc.OP.AjaxInterface).GetAdmReason(EpisodeID)    /// 费别
	s PatCardNo=""
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
	s:CardNoID'="" PatCardNo=$p($g(^DHCCARD("CF",PatientID)),"^",2)         /// 卡号
	s MedicalNo=##Class(web.DHCMDTCom).IGetMrNoByEpisodeID(EpisodeID)       /// 病案号
	s PatDiagDesc=##class(web.DHCDoc.OP.AjaxInterface).GetMRAdmDiagnosis(EpisodeID)   /// 诊断
	s PostCode=""
	s PatType=$p(^PAADM(EpisodeID),"^",2)     /// 就诊类型
	s CstRLocID=$p(^DHCMDTCON(ID),"^",2)      /// 申请科室
	s CstRLoc=""
	s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	s:CstRLoc["-" CstRLoc=$p(CstRLoc,"-",2)
	s CstRLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","EN",CstRLoc)  /// 多语言支持
	s CsHospID=$p(^CTLOC(CstRLocID),"^",22)  /// 医院ID
	s CstRDate=$p(^DHCMDTCON(ID),"^",3)      /// 申请日期
	s:CstRDate'="" CstRDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)
	s CstRTime=$p(^DHCMDTCON(ID),"^",4)      /// 申请时间
	s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	s CstRUser=""
	s CstUserID=$p(^DHCMDTCON(ID),"^",5)    /// 申请医生
	s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	s CstRUser=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","EN",CstRUser)  /// 多语言支持
	s CstTrePro=$p(^DHCMDTCON(ID),"^",6)    /// 病情及诊疗经过
	s CstPurpose=$p(^DHCMDTCON(ID),"^",7)   /// 会诊的理由和目的
	s CstNDate=$p(^DHCMDTCON(ID),"^",8)     /// 会诊日期
	s:CstNDate'="" CstNDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstNDate)
	s PreDate="",PreTime=""
	s PreTime = ##Class(web.DHCMDTCom).GetPreDateInfo(ID) ///预约时间
	s PreDate = $p(PreTime,"^",1)
	s PreTimeRange = $p(PreTime,"^",2)
	s CstNTime=$p(^DHCMDTCON(ID),"^",9)     /// 会诊时间
	s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	s CstNPlace=$p(^DHCMDTCON(ID),"^",10)   /// 会诊地点
	s TreMeasures=$p(^DHCMDTCON(ID),"^",11) /// 最终治疗措施
	s CstUser=$p(^DHCMDTCON(ID),"^",13)     /// 联系人
	s CstPhone=$p(^DHCMDTCON(ID),"^",14)    /// 联系电话
	s PrintFlag=$p(^DHCMDTCON(ID),"^",15)   /// 打印标志
	s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	s RBResID=$p(^DHCMDTCON(ID),"^",17)       /// 资源ID
	s PrvLocID=$p($g(^RB("RES",+RBResID)),"^",1)
	s PrvID=$p($g(^RB("RES",RBResID)),"^",2)
	s PrvDesc="",PrvLoc=""
	s:PrvID'="" PrvDesc=$p($g(^CTPCP(PrvID,1)),"^",2)
	s:PrvLocID'="" PrvLoc=$p(^CTLOC(PrvLocID),"^",2)
	s DisProcess=$p(^DHCMDTCON(ID),"^",23)    /// 会诊讨论内容
	s suppnotes=$p(^DHCMDTCON(ID),"^",25)     /// 补充内容
	s CstStatus=$p(^DHCMDTCON(ID),"^",12)     /// 状态ID
	s:CstStatus'="" CstStatus=$P(^DHCMDTS(CstStatus),"^",2)
	s MCTimes=$p(^DHCMDTCON(ID),"^",22)    /// 患者第几次会诊次数
    s ListData=EpisodeID_"^"_PatType_"^"_CstRLocID_"^"_CstRLoc_"^"_CstRDate_"^"_CstRTime_"^"_CstUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose_"^"_CstNDate_"^"_CstNTime
    s ListData=ListData_"^"_CstNPlace_"^"_CstUser_"^"_CstPhone_"^"_TreMeasures_"^"_DisGrpID_"^"_DisGroup_"^"_PrvDesc_"^"_isOpiEditFlag_"^"_CstStatus_"^"_CsHospID_"^"_IsPerAccFlag
	s ListData=ListData_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_Birthday_"^"_PatCardNo_"^"_MedicalNo_"^"_PatTelH_"^"_PostCode_"^"_Address_"^"_PreDate_"^"_PreTimeRange_"^"_PatDiagDesc
	s ListData=ListData_"^"_DisProcess_"^"_MCTimes_"^"_PatNo_"^"_PatBill_"^"_suppnotes_"^"_RBResID
	
	Q ListData
}

/// Creator:    bianshuai
/// CreateDate: 2020-08-13
/// Descritp:   发送信息到移动端APP【远程会诊平台接口】
/// InPut:      mdtID - 会诊ID, msgType - 消息类型
/// OutPut:     申请单信息, 空
/// W ##Class(web.DHCMDTInterface).SendMsgToRCP("417||3")
ClassMethod SendMsgToRCP(id As %String, msgType As %String) As %String
{
	n (id, msgType)
	
	Q 1
}

/// Creator:    bianshuai
/// CreateDate: 2020-08-13
/// Descritp:   同步会诊状态【远程会诊平台接口】
/// InPut:      mdtID - 会诊ID, sCode - 状态代码
/// OutPut:     申请单信息, 空
/// W ##Class(web.DHCMDTInterface).SynCsStatusToRCP("417||3")
ClassMethod SynCsStatusToRCP(id As %String, sCode As %String) As %String
{
	n (id, sCode)
	
	/// 远程会诊接口
	
	Q 1
}

/// Creator:    bianshuai
/// CreateDate: 2020-08-13
/// Descritp:   将移动端专家会诊意见更新到院内会诊单【远程会诊平台接口】
/// InPut:      CsID - 会诊ID, userCode - 工号, userOpinion - 建议
/// OutPut:     申请单信息, 空
/// W ##Class(web.DHCMDTInterface).InsExpProFroRemote("417||3")
ClassMethod InsExpProFroRemote(mdtID As %String, userCode As %String, userOpinion As %String) As %String
{
	n (mdtID, userCode, userOpinion)
	
	s userType="I"
	i '$D(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode))) s userType="O"
	
	/// 申请关联专家id
	s itmid=..GetCsExpItemID(mdtID, userCode)
	Q:itmid="" -1
	 /// 插入专家建议
	s Err=..InsCsExpPro(itmid, userType, userOpinion)
	
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2020-08-13
/// Descritp:   将移动端专家会诊意见更新到院内会诊单【远程会诊平台接口】
/// InPut:      CsID - 会诊ID
/// OutPut:     申请单信息, 空
/// W ##Class(web.DHCMDTInterface).GetCsExpItemID("417||3")
ClassMethod GetCsExpItemID(mdtID As %String, userCode As %String) As %String
{
	n (mdtID, userCode)
	s itmid=""
	i userType="I"
	.s CH=""
	.F  s CH=$o(^DHCMDTCON(mdtID,"I",CH)) Q:(CH="")||(itmid'="")  D
	..s CareProvID=+$p(^DHCMDTCON(mdtID,"I",CH),"^",2)
	..i CareProvID=0 s CareProvID=$p(^DHCMDTCON(mdtID,"I",CH),"^",3) 
	..Q:$p($g(^CTPCP(+CareProvID,1)),"^",1)'=userCode
	..s itmid=ID_"||"_CH
	.
	E  D
	.s repid=""
	.F  s repid=$o(^DHCMDTCEP(0,"OutExp",mdtID,repid)) Q:(repid="")||(itmid'="")  D
	..s userID=+$p(^DHCMDTCEP(repid),"^",2)
	..Q:$p(^SSU("SSUSR",userID),"^",1)'=userCode
	..s itmid=ID
	.
	Q itmid
}

/// Creator:    bianshuai
/// CreateDate: 2020-08-13
/// Descritp:   插入专家建议
/// InPut:      itmid - 会诊子表ID, userType - 专家类型, userOpinion - 专家建议
/// OutPut:     0-成功, 其他-失败
/// W ##Class(web.DHCMDTInterface).InsCsExpPro("")
ClassMethod InsCsExpPro(itmid As %String, userType As %String, userOpinion As %String) As %String
{
	n (id, userType, userOpinion)
	i userType="I" D
	.&SQL(update dhc_mdtconsultitm set mc_opinion=:userOpinion where mc_rowid=:id)
	E  D
	.&SQL(update dhc_mdtconouterexp set md_opinion=:userOpinion where md_rowid=:id)
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2019-01-21
/// Descript:   病历授权
/// InPut:      EpisodeID - 就诊ID,
/// OutPut:     0 此就诊没有病历; 1-授权成功; -1-授权失败
/// w ##Class(web.DHCMDTInterface).OpenEmrAuth("")
ClassMethod OpenEmrAuth(EpisodeID As %String, CstID As %String, LgUserID As %String, DeptID As %String, UserID As %String, LimTime As %String) As %String
{
	n (EpisodeID, CstID, LgUserID, DeptID, UserID, LimTime)
 	///	AEpisodeID:           就诊ID (不能为空)
    /// AAppointCateCharpter: 1、病历ID串(病历ID^病历ID) 2、ALL(全部病历)
    /// ARequestUserID:       获得权限的医护人员UserID (不能为空)
    /// ARequestDeptID:       获得权限的科室ID (不能为空)
    /// AActions:             view (授予的病历操作权限，不能为空)
    /// AAppointUserID:       进行授权的医护人员UserID (不能为空)
    /// AAppointType:         0-对ARequestUserID进行授权; 1-对ARequestDeptID进行授权
    /// AAppointSpan:         数字-授权时长，单位为小时 (例：时长6小时，参数为6)
    /// AStatus:              IC-会诊授权;IP-检查授权;IL-检验授权 (不能为空)
    /// AObjID:               具体模块的业务ID(会诊申请ID，不能为空)
    s AppointType=0
    i UserID="" s AppointType=1, UserID="-1"
	s Err=##Class(EMRservice.InterfaceService.Appoint).addAppoint(EpisodeID,"ALL",UserID,DeptID,"view",LgUserID,AppointType,LimTime,"IC",CstID)
	Q Err
}

/// Creator:      bianshuai
/// CreateDate:   2021-04-30
/// Descript:     MDT会诊日志
/// InPut:        mOeori - 医嘱ID, TmpArr
/// OutPut:       
/// w ##Class(web.DHCMDTInterface).GetCsNodeStr("",.TmpArr)
ClassMethod GetCsNodeStr(mOeori As %String, ByRef TmpArr, mdtID = "") As %String
{
	n (mOeori, TmpArr ,mdtID)
	q:(mOeori="")&&(mdtID="") ""	
	i mdtID="" d
	.s ID=$o(^DHCMDTORD(0,"IndexOrd",mOeori,""))
	.s mdtID=$p(^DHCMDTORD(ID),"^",1)       /// 会诊ID
	q:+mdtID=0 ""
	
	s StatusID=$p(^DHCMDTCON(mdtID),"^",12)   /// 状态ID
	q:$p($g(^DHCMDTS(+StatusID)),"^",2)="撤销" 0 /// 已撤销退出 
	
	
	q:$p(^DHCMDTCON(+mdtID),"^",12)="" ""  /// 会诊状态
	s RefID=+mdtID
	d SetItmData
	s CH=0
	f  s CH=$o(^DHCMDTCON(+mdtID,"I",CH)) q:CH=""  d
	.s RefID=+mdtID_"||"_CH
	.d SetItmData
	b ;data
	q ""
	
SetItmData
	s LgID=""
	F  s LgID=$o(^DHCMDTL(0,"CstRef",RefID,LgID)) Q:LgID=""  D
	.s StD=$p(^DHCMDTL(LgID),"^",3)  /// 状态
	.q:StD=""
	.s StCode=$p(^DHCMDTS(StD),"^",1)
	.s StDesc=$p(^DHCMDTS(StD),"^",2)
	.s LgUserID=$p(^DHCMDTL(LgID),"^",2)    /// 操作人
	.s LgUser=$p($g(^SSU("SSUSR",+LgUserID)),"^",2)
	.s LgDate=$p(^DHCMDTL(LgID),"^",4)    /// 日期
	.s LgDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(LgDate)
	.s LgTime=$p(^DHCMDTL(LgID),"^",5)    /// 时间	
	.s:LgTime'="" LgTime=$zt(LgTime,1)
	.s LgNote=$p(^DHCMDTL(LgID),"^",6)    /// 备注
	.;Q:$D(TmpArr(StCode))
	.
	.s TmpArr(StCode,LgDate,LgTime)=LgUser_"^^^"_LgNote_"^"_StDesc
	q ""
}

/// Creator:      bianshuai
/// CreateDate:   2021-04-30
/// Descript:     MDT会诊内容
/// InPut:        mOeori - 医嘱ID, TmpArr
/// OutPut:       
/// w ##Class(web.DHCMDTInterface).GetMulCsDetail("","","12")
ClassMethod GetMulCsDetail(mOeori As %String, ByRef TmpArr, mdtID = "") As %String
{
	n (mOeori,TmpArr,mdtID)
	q:(mOeori="")&&(mdtID="") ""
	s ID=""	
	i mdtID="" d
	.s ID=$o(^DHCMDTORD(0,"IndexOrd",mOeori,""))
	.q:ID=""
	.s mdtID=$p(^DHCMDTORD(ID),"^",1)       /// 会诊ID
	q:+mdtID=0 ""
	
	s StatusID=$p(^DHCMDTCON(mdtID),"^",12)   /// 状态ID
	q:$p($g(^DHCMDTS(+StatusID)),"^",2)="撤销" 0 /// 已撤销退出 
	
	q:$p(^DHCMDTCON(+mdtID),"^",12)="" ""  /// 会诊状态
	s ReqLocID=$p(^DHCMDTCON(mdtID),"^",2)    /// 申请科室
	s ReqLocDesc=""
	s:ReqLocID'="" ReqLocDesc=$p(^CTLOC(ReqLocID),"^",2)
	s:ReqLocDesc["-" ReqLocDesc=$p(ReqLocDesc,"-",2)
	s ReqDate=$p(^DHCMDTCON(mdtID),"^",3)    /// 申请日期
	s:ReqDate'="" ReqDate=##Class(web.DHCMDTCom).DateLogicalToHtml(ReqDate)
	s ReqTime=$p(^DHCMDTCON(mdtID),"^",4)    /// 申请时间
	s:ReqTime'="" ReqTime=$zt(ReqTime,1)
	s ReqTime=ReqDate_" "_ReqTime
	s ReqUserID=$p(^DHCMDTCON(mdtID),"^",5)  /// 申请医生
	s ReqUser=$p($g(^SSU("SSUSR",ReqUserID)),"^",2)
	s CareProvID=$p(^SSU("SSUSR",ReqUserID),"^",14)
	s PrvTpID=+$p(^CTPCP(CareProvID,1),"^",4)       /// 职称
	i PrvTpID'=0 s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	s CstPlace=$p(^DHCMDTCON(mdtID),"^",10)   /// 会诊地点
	s LgCsNode=##Class(web.DHCMDTCom).GetCsNodeTime(mdtID,"80")
	s CompTime=$p(LgCsNode,"^",3)_" "_$p(LgCsNode,"^",4)
	s DisGrpID=$p(^DHCMDTCON(mdtID),"^",16)    /// 疑难病种
	s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	s TmpArr(mdtID)=ReqLocDesc_"^"_ReqTime_"^"_ReqUser_"^"_$g(PrvTp)_"^"_DisGroup_"^"_CompTime_"^"_CstPlace

	/// 专家列表
	s CH=""
	F  s CH=$o(^DHCMDTCON(mdtID,"I",CH)) Q:CH=""  D
	.s LocDesc=""
	.s LocID=$p(^DHCMDTCON(mdtID,"I",CH),"^",1)          /// 科室ID
	.s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s CareProv=""
	.s CareProvID=$p(^DHCMDTCON(mdtID,"I",CH),"^",2)     /// 医生
	.s:CareProvID'="" CareProv=$p($g(^CTPCP(CareProvID,1)),"^",2)
	.s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.s PrvTpID="",PrvTp=""
	.s PrvTpID=+$p(^DHCMDTCON(mdtID,"I",CH),"^",4)       /// 职称
	.i PrvTpID'=0 s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	.s HosID="I", HosType="组内"
	.s DisGrpID=$p(^DHCMDTCON(mdtID),"^",16)    /// 疑难病种
	.i +CsUserID'=0 D
	.i '$d(^DHCMDTG(0,"User",+CsUserID,DisGrpID)) s HosID="O", HosType="院内"
	.E  D
	..i ##Class(web.DHCMDTConsultQuery).isTakLocGroupRel(DisGrpID, LocID)=0 s HosID="O", HosType="院内"
	.s TmpArr(mdtID,HosType,CH)=LocDesc_"^"_PrvTp_"^"_CareProv
	.
	
	Q ""
}

/// Creator:qqa
/// CreatDate:2021-07-29
/// w ##Class(web.DHCMDTInterface).SendEmrData("110")
ClassMethod SendEmrData(CstID)
{
	n (CstID)
	s EpisodeID=$p(^DHCMDTCON(CstID),"^",1)      /// 就诊ID
	s AppEpisodeID=$p(^DHCMDTCON(CstID),"^",20)   /// 预约就诊ID
	i AppEpisodeID'="" d
	.s AppAdmType=$p(^PAADM(+AppEpisodeID),"^",2)
	.q:AppAdmType'="I"
	.s EpisodeID=AppEpisodeID
	
	
	
	s APatientID=$p(^PAADM(EpisodeID),"^",1)
	s AEpisodeID=EpisodeID
	s AConsultID=CstID
	s AApplyDate=$p(^DHCMDTCON(CstID),"^",3)
	s AApplyTime=$p(^DHCMDTCON(CstID),"^",4)
	s CstRUserID=$p(^DHCMDTCON(CstID),"^",5)  /// 申请医生
	s AApplyDoctor=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	s AFinishDate=+$h
	s AFinishTime=$p($h,",",2)
	s AConsultLoc="",AConsultDoctor="" ;会诊科室，会诊医生
	s CH=""
	f  s CH=$o(^DHCMDTCON(CstID,"I",CH)) Q:CH=""  D
	.s CsLocID=$p(^DHCMDTCON(CstID,"I",CH),"^",1)       ;会诊科室
	.s CareProvID=+$p(^DHCMDTCON(CstID,"I",CH),"^",2)
	.i CareProvID=0 s CareProvID=$p(^DHCMDTCON(CstID,"I",CH),"^",3) 
	.s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    	;会诊医生
	.s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	.s:AConsultLoc'="" AConsultLoc=AConsultLoc+";"+CsLocDesc
	.s:AConsultLoc="" AConsultLoc=CsLocDesc
	.s:AConsultDoctor'="" AConsultDoctor=AConsultDoctor+";"+CsUser
	.s:AConsultDoctor="" AConsultDoctor=CsUser
	s DisGrpID=$p(^DHCMDTCON(CstID),"^",16)   /// 疑难病种
	s AConsultType=$p(^DHCMDTG(DisGrpID),"^",2)
	s CstRLocID=$p(^DHCMDTCON(CstID),"^",2)
	s AApplyLoc=$p($g(^CTLOC(+CstRLocID)),"^",2)
	s AConDestination=""
	s AAttitude=""
	s AConsultStatus="完成"
	
	s Ret=##Class(EMRservice.HISInterface.Event.MDTConsult).SetData(APatientID,AEpisodeID,AConsultID,AApplyDate,
		AApplyTime,AApplyDoctor,AFinishDate,AFinishTime,AConsultDoctor,AConsultType,AConsultLoc,
		AApplyLoc,AConDestination,AAttitude,AConsultStatus)
	q:Ret'=1 -1
	q 0
}

/// Creator:      qqa
/// CreateDate:   2021-10-11
/// Descript:     取病人MDT会诊列表【移动端调用】
/// InPut:        开始日期^结束日期^登陆用户ID(必传)^登陆科室ID(必传)^队列类型(必传 1:本人申请,2:本人会诊,3:本组会诊,4:本科申请)^患者登记号(过滤条件)^患者姓名(过滤条件)^收费状态(过滤条件 Y/N)
/// OutPut:       会诊ID^就诊ID^登记号^姓名^性别^年龄^科室^电话^出生日期^地址^申请科室^费别^病案号^诊断^申请日期^申请时间^申请人ID^申请人^是否会诊专家(1:是,其他:否)
/// 				  ^病情及诊疗经过^会诊的理由和目的^是否联络人^是否是外院专家
/// D ##Class(%ResultSet).RunQuery("web.DHCMDTInterface","QryMDTConsList","2023-03-15^2023-03-23^18302^189^4^^^")
Query QryMDTConsList(Params As %String) As websys.Query(ROWSPEC = "ID,EpisodeID,PatNo,PatName,PatSex,PatAge,PatLoc,PatTelH,PatBod,PatAddr,CstRLoc,BillType,MedicareNo,PatDiag,CstRDate,CstRTime,CstRUserID,CstRUser,IsCsUser,CstTrePro,CstPurpose,IsContact,IsWaiYuanDoc")
{
}

ClassMethod QryMDTConsListExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	
	s ^qqa("Params") = Params
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    k TmpArr
    
    
	s rows=999,page=1
	s StDate=$p(Params,"^",1)
	s EndDate=$p(Params,"^",2)
	s LgUserID=$p(Params,"^",3)
	s LgLocID=$p(Params,"^",4)
	s ShowModel=$p(Params,"^",5) /// 显示内容：1(本人发送) 2(本人接收) 其他：查询所有
	s PatNo=$p(Params,"^",6)
	s PatName=$p(Params,"^",7)
	s ChargeFlag=$p(Params,"^",8)
	s LgHospID=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(LgLocID)
	s AllParams=StDate_"^"_EndDate_"^^"_PatNo_"^^^"_ShowModel_"^"_LgUserID_"^"_PatName_"^"_ChargeFlag_"^1^"_LgLocID_"^"_LgHospID
	
	
    /// 会诊申请列表
	D ##Class(web.DHCMDTConsultQuery).JsGetMdtQuery(rows,page,AllParams,"1",.TmpArr)
	
    s index=""
	F  s index=$o(TmpArr(index),-1)  Q:index=""  D
	.s ListData=$g(TmpArr(index),-1)
	.Q:ListData=""
	.b ;errData
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:      qqa
/// CreateDate:   2021-10-11
/// Descript:     获取MDT会诊信息
/// InPut:        
/// OutPut:		"就诊ID^就诊类型^申请科室ID^申请科室^申请日期^申请时间^申请医生ID^申请医生^病情摘要^会诊目的^申请日期^申请时间^会诊地点^联系人^联系电话^最终治疗措施^疑难病种ID^疑难病种"
/// 				"^号别^是否可编辑^状态^医院ID^允许接受^患者姓名^患者性别^患者年龄^出生日期^卡号^病案号^手机号^Post标志^患者住址^预约日期^预约资源时间^诊断描述^会诊讨论^会诊次数^登记号"
/// 				"^费别^补充内容^资源ID^肿瘤状态^专家列表(科室1#职称1#医生1#类型1!!科室2#职称2#医生2#类型2...)"
/// w ##Class(web.DHCMDTInterface).GetMdtData(14)
ClassMethod GetMdtData(ID)
{
	s CstData=##Class(web.DHCMDTConsultQuery).JsGetMdtObj(ID,1)
	
	s AllDoc=""
	k TmpArr
	Do ##Class(web.DHCMDTConsultQuery).JsonQryConsult(ID,"","","","I",1,.TmpArr)
	s groupDoc=..GetDocList(.TmpArr)
	s:AllDoc'="" AllDoc=AllDoc_"!!"_groupDoc
	s:AllDoc="" AllDoc=groupDoc
	
	k TmpArr
	Do ##Class(web.DHCMDTConsultQuery).JsonQryConsult(ID,"","","","O",1,.TmpArr)
	s hospDoc=..GetDocList(TmpArr)
	i hospDoc'="" d
	.s:AllDoc'="" AllDoc=AllDoc_"!!"_hospDoc
	.s:AllDoc="" AllDoc=hospDoc
	
	k TmpArr
	Do ##Class(web.DHCMDTConsultQuery).JsonQryConsult(ID,"","","","E",1,.TmpArr)
	s outHospDoc=..GetDocList(TmpArr)
	i outHospDoc'="" d
	.s:AllDoc'="" AllDoc=AllDoc_"!!"_outHospDoc
	.s:AllDoc="" AllDoc=outHospDoc
	b ;err
	s RetData = CstData_"^"_AllDoc
	q RetData
}

/// Descript:获取MDT会诊信息中科室字符串拼接  
ClassMethod GetDocList(TmpArr)
{
	s Ret=""
	s Index=""
	f  s Index=$o(TmpArr(Index)) q:Index=""  d
	.s ItmData=TmpArr(Index)
	.s Loc=$p(ItmData,"^",3)
	.q:Loc=""
	.s Prv=$p(ItmData,"^",7)
	.s Doc=$p(ItmData,"^",5)
	.s Type=$p(ItmData,"^",11)
	.s Itm=Loc_"#"_Prv_"#"_Doc_"#"_Type
	.s:Ret'="" Ret=Ret_"!!"_Itm
	.s:Ret="" Ret=Itm
	q Ret
}

/// Creator:      qqa
/// CreateDate:   2021-10-11
/// Descript:     获取指令query
/// InPut:        
/// OutPut:       语音指令code,语音内容,操作指令code,操作指令内容,连接地址
/// D ##Class(%ResultSet).RunQuery("web.DHCMDTInterface","QryMDTConsInstList")
Query QryMDTConsInstList() As websys.Query(ROWSPEC = "Code,Desc,ParCode,ParDesc,Url")
{
}

ClassMethod QryMDTConsInstListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    k TmpArr
    
    s mID=18,h=0
    s ID="0"
	F  s ID=$o(^DHCMDTDI(0,"Type",mID,ID)) Q:ID=""  D
	.s Code=$p(^DHCMDTDI(ID),"^",1)    //代码
	.s Desc=$p(^DHCMDTDI(ID),"^",2)    //描述
	.s ActCode=$p(^DHCMDTDI(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$p(^DHCMDTDI(ID),"^",4)  //医院
	.s HospDesc=""
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s ParID=$p(^DHCMDTDI(ID),"^",6)
	.q:ParID=""
	.s ParCode=$p(^DHCMDTDI(ParID),"^",1)    //代码
	.s ParDesc=$p(^DHCMDTDI(ParID),"^",2)    //描述
	.s Url = $p(^DHCMDTDI(ParID),"^",7)
	.s h=h+1
	.s ListData=Code_"^"_Desc_"^"_ParCode_"^"_ParDesc_"^"_Url
	.s TmpArr(ParID,ID)=ListData
   
   	s parID=""
   	f  s parID=$o(TmpArr(parID))  q:parID=""  d
    .s index=""
	.f  s index=$o(TmpArr(parID,index))  Q:index=""  D
	..s ListData=$g(TmpArr(parID,index))
	..q:ListData=""
	..s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	..s ind=ind+1
	..

	k TmpArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:      qqa
/// CreateDate:   2021-10-18
/// Descript:     会诊讨论内容
/// InPut:        MDT会诊ID,用户Code
/// OutPut:       讨论内容
///  w ##Class(web.DHCMDTInterface).GetCstOpinion(16,"ys02")
ClassMethod GetCstOpinion(ID, UserCode)
{
	q:UserCode="" 0
	s SSUSRRowId = $o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
	q:SSUSRRowId="" ""
	s CstItmID=##class(web.DHCMDTConsult).GetCstItmIdByUser(ID,SSUSRRowId)
	q:CstItmID="" ""
	s CH=$p(CstItmID,"||",2)
	s Opinion = $p($g(^DHCMDTCON(ID,"I",CH)),"^",6)
	q Opinion
}

/// Creator:qqa
/// CreatDate: 2022-09-01
/// Descript: 提供给移动端，通过手机号获取对应的外院专家信息
/// Rturn: SSUserID^Code^PassWord/""
/// w ##class(web.DHCMDTInterface).OutDocByPhoneNo("18684962546")
ClassMethod OutDocByPhoneNo(PhoneNo)
{
	n (PhoneNo)

	q:PhoneNo="" ""
	s Ret=""
	s MDRowID = 0
	f{
		s MDRowID=$o(^DHCMDTOUTEXP(0,"Phone",PhoneNo,MDRowID))
		q:MDRowID=""
		s OutExpID=0
		f {
			s OutExpID = $o(^DHCMDTCOE(0,"OutExp",MDRowID,OutExpID))
			q:OutExpID=""
			s UserID=$p(^DHCMDTCOE(OutExpID),"^",4)
			continue:UserID=""
			s UserCode = $p(^SSU("SSUSR",UserID),"^",1)
			s UserPass = $p(^SSU("SSUSR",UserID),"^",3)
			s Ret=UserID_"^"_UserCode_"^"_UserPass
			q
		}
		q:Ret'=""
	}
	q Ret
}

}
