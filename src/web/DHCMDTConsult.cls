Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript: 		mdt会诊申请业务类
Class web.DHCMDTConsult Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descritp:  	    插入会诊申请内容
/// Input:    		mListData-会诊申请内容
/// Ouput:     		申请单ID
/// w ##Class(web.DHCMDTConsult).Insert("14","")
ClassMethod Insert(CstID As %String, mListData As %String) As %String
{
	n (CstID, mListData)
	i CstID="" D
	.s CstID=..InsConsult(mListData)
	E  D
	.s CstID=..UpdConsult(CstID, mListData)
	Q CstID
}

/// Descritp:  插入会诊申请内容
/// Input:     mListData-会诊申请内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCMDTConsult).InsertCytExn("")
/// w ##Class(web.DHCMDTConsult).InsConsult("27234024^876^191^fsa^saf^1诊室^^^^^1^37469^^23^1094^17^4^2348^17^7^877^17^7^1005^17^20^3813^15^")
ClassMethod InsConsult(mListData As %String) As %String
{
	N (mListData)
	s StatusID=""
	s Err=0
	TS

	/// 会诊申请
	s ListData=$p(mListData,$C(2),1)
	s CstID=..InsConMaster(ListData)
	
	i CstID<0 tro
	Q:CstID<0 CstID

	/// 会诊子表
	s ListData=$p(mListData,$C(2),2)
	s Err=..InsConItm(CstID, ListData)
	i Err'=0 tro
	Q:Err'=0 "-11"
			
	/// 外院专家
	s ListData=$p(mListData,$C(2),3)
	s Err=..InsOuterExpert(CstID, ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	///状态置为保存
	s Err=..InsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	TC
	D ##Class(web.DHCMDTInterface).SendMsgProxy(CstID,"R") /// 调用短信平台接口
	Q CstID
}

/// Descritp:  更新会诊申请内容
/// Input:     mListData-会诊申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCMDTConsult).UpdConsult("")
ClassMethod UpdConsult(CstID As %String, mListData As %String) As %String
{
	N (CstID, mListData)
	s Err=0
	TS

	/// 病理内容
	s ListData=$p(mListData,$C(2),1)
	s CstID=..UpdConMaster(CstID,ListData)
	i CstID<0 tro
	Q:CstID<0 CstID
	
	/// 删除相关字表内容重新插入
	s Err=..DelCstMasSubTable(CstID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 会诊子表
	s ListData=$p(mListData,$C(2),2)
	s Err=..InsConItm(CstID, ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/// 外院专家
	s ListData=$p(mListData,$C(2),3)
	s Err=..InsOuterExpert(CstID, ListData)
	i Err'=0 tro
	Q:Err'=0 "-13"
	TC
	Q CstID
}

/// Descritp:  插入会诊主表
/// w ##Class(web.DHCMDTConsult).InsConMaster("")
ClassMethod InsConMaster(mListData As %String) As %String
{
	n (mListData)
	s ListData=$p(mListData,$C(2))
	s EpisodeID=$p(ListData,"^",1)    ///EpisodeID
	s CsRUserID=$p(ListData,"^",2)    ///申请医生
	s CsRLocID=$p(ListData,"^",3)     ///申请科室
	s CsTrePro=$p(ListData,"^",4)     ///病人病情
	s CsPurpose=$p(ListData,"^",5)    ///会诊目的
	s CsNPlace=$p(ListData,"^",6) 	  ///会诊地点
	s CsNDate=$p(ListData,"^",7)      ///会诊日期
	s:CsNDate'="" CsNDate=##class(web.DHCMDTCom).DateHtmlToLogical(CsNDate)
	s CsNTime=$p(ListData,"^",8)      ///会诊时间
	i CsNTime["-" s CsNTime=$p(CsNTime,"-",1)
	s:CsNTime'="" CsNTime=$zth(CsNTime,3)
	s Contacts=$p(ListData,"^",9)	  ///联系人
	s CsPhone=$p(ListData,"^",10)	  ///联系电话
	s GroupID=$p(ListData,"^",11)	  ///疑难病种
	s RBResID=$p(ListData,"^",12)	  ///资源ID
	s AppSclID=$p(ListData,"^",13)	  ///资源字表ID
	s mdtTimes=$p(ListData,"^",14)	  ///第几次会诊
	s PatientID=$p(ListData,"^",15)	  ///病人ID
	s CsRDate=+$H   		          ///申请日期
	s CsRTime=$p($H,",",2)            ///申请时间
	&SQL(Insert Into DHC_MDTConsult(MC_Adm_Dr,MC_RLoc_Dr,MC_RDate,MC_RTime,MC_RUser_Dr,MC_TrePro,MC_Purpose,MC_NPlace,MC_NDate,MC_NTime,MC_Contacts,
		MC_ConsPhone,MC_Group_Dr,MC_RBRes_Dr,MC_AppSc_Dr,MC_Times,MC_Patient_Dr)
		values(:EpisodeID,:CsRLocID,:CsRDate,:CsRTime,:CsRUserID,:CsTrePro,:CsPurpose,:CsNPlace,:CsNDate,:CsNTime,:Contacts,:CsPhone,:GroupID,
		:RBResID,:AppSclID,:mdtTimes,:PatientID))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descritp:  更新会诊主表
ClassMethod UpdConMaster(CstID As %String, mListData As %String) As %String
{
	n (CstID, mListData)
	s ListData=$p(mListData,$C(2))
	s CsTrePro=$p(ListData,"^",4)     ///病情及诊疗经过
	s CsPurpose=$p(ListData,"^",5)    ///会诊的理由和目的
	s CsNPlace=$p(ListData,"^",6) 	  ///会诊地点
	s CsNDate=$p(ListData,"^",7)      ///会诊日期
	s:CsNDate'="" CsNDate=##class(web.DHCMDTCom).DateHtmlToLogical(CsNDate)
	s CsNTime=$p(ListData,"^",8)      ///会诊时间
	i CsNTime["-" s CsNTime=$p(CsNTime,"-",1)
	s:CsNTime'="" CsNTime=$zth(CsNTime,3)
	s Contacts=$p(ListData,"^",9)	  ///联系人
	s CsPhone=$p(ListData,"^",10)	  ///联系电话
	s GroupID=$p(ListData,"^",11)	  ///疑难病种
	s RBResID=$p(ListData,"^",12)	  ///资源ID
	s AppSclID=$p(ListData,"^",13)	  ///资源子表ID
	s mdtTimes=$p(ListData,"^",14)	  ///第几次会诊
	&SQL(Update DHC_MDTConsult Set MC_TrePro=:CsTrePro, MC_Purpose=:CsPurpose,MC_NDate=:CsNDate, MC_NTime=:CsNTime, MC_NPlace=:CsNPlace, MC_Contacts=:Contacts, MC_ConsPhone=:CsPhone, MC_Group_Dr=:GroupID
		, MC_AppSc_Dr=:AppSclID, MC_Times=:mdtTimes Where MC_RowID=:CstID)  /// MC_RBRes_Dr=:RBResID,
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descritp:  插入会诊子表内容
ClassMethod InsConItm(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s Len = $L(mListData,"@")
	s quitflag=0
	F i=1:1:Len Q:quitflag'="0"  D
	.s ListData=$p(mListData,"@",i)    /// 项目列表
	.s CstCLocID=$p(ListData,"^",1)    /// 会诊科室
	.s CstNDocID=$p(ListData,"^",2)    /// 要求会诊医生
	.s PrvTpID=$p(ListData,"^",3)      /// 医生职称
	.s SubMarID=$p(ListData,"^",4)     /// 亚专业
	.s arChildSub=$o(^DHCMDTCON(arParref,"I",""),-1)+1
	.
	.&SQL(Insert Into DHC_MDTConsultItm(MC_ParRef_Dr,MC_ChildSub,MC_CLoc_Dr,MC_NDoc_Dr,MC_PrvTp_Dr,MC_SubMar_Dr)
		values(:arParref,:arChildSub,:CstCLocID,:CstNDocID,:PrvTpID,:SubMarID))
	.i SQLCODE'=0 s quitflag="1"
	Q quitflag
}

/// Creator:     bianshuai
/// CreateDate:  2020-08-21
/// Descritp:    插入外院专家
/// w ##class(web.DHCMDTConsult).InsOuterExpert("130","^乔庆澳^37^1^")
ClassMethod InsOuterExpert(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s mListData=..DealOuterExp(arParref, mListData) /// 处理外院专家
	s Len = $L(mListData,"@")
	s quitflag=0
	F i=1:1:Len Q:quitflag'="0"  D
	.s ListData=$p(mListData,"@",i)    /// 项目列表
	.s OutExpID=$p(ListData,"^",1)     /// 会诊科室
	.q:+OutExpID=0
	.;这里获取一个空闲的用户
	.s freeUserId = ##class(web.DHCMDTConsult).freeUser()
	.&SQL(Insert Into DHC_MDTConOuterExp(MD_ParRef_Dr,MD_OutExp_Dr,MD_User_Dr)
		values(:arParref,:OutExpID,:freeUserId))
	.i SQLCODE'=0 s quitflag="1"
	Q quitflag
}

/// Descript: 删除会诊申请子表和关联表数据
/// w ##Class(web.DHCEMConsult).DelCstMasSubTable("24")
ClassMethod DelCstMasSubTable(CstID) As %String
{
	n (CstID)
	s SQLCODE=0
	
	///  会诊子表
	i $o(^DHCMDTCON(CstID,"I","")) D
	.&SQL(delete from DHC_MDTConsultItm where MC_ParRef_Dr=:CstID)
	Q:SQLCODE'=0 SQLCODE
	
	///  外院专家
	i $D(^DHCMDTCOE(0,"ParRef",CstID)) D
	.&SQL(delete from DHC_MDTConOuterExp where MD_ParRef_Dr=:CstID)
	Q:SQLCODE'=0 SQLCODE
	
	Q SQLCODE
}

/// Creator:     bianshuai
/// CreateDate:  2020-08-21
/// Descritp:    处理外院专家
ClassMethod DealOuterExp(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s Len = $L(mListData,"@")
	s Err=0
	F i=1:1:Len Q:Err'="0"  D
	.s ListData=$p(mListData,"@",i)    /// 项目列表
	.Q:$p(ListData,"^",2)=""
	.s OutExpID=$p(ListData,"^",1)     /// 外院专家
	.i OutExpID="" D
	..s OutExpID=..InsOuterExpDic(arParref, ListData) 
	.s $p(ListData,"^",1)=OutExpID, $p(mListData,"@",i)=ListData
	.
	Q mListData
}

/// Creator:     bianshuai
/// CreateDate:  2020-08-21
/// Descritp:    新建外院专家
/// w ##Class(web.DHCMDTConsult).GetCurMaxCode("US"_$zd(+$H,8),"3")
ClassMethod InsOuterExpDic(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s DisGrpID=$p(^DHCMDTCON(arParref),"^",16)    /// 疑难病种
	s CsRLocID=$p(^DHCMDTCON(arParref),"^",2)     /// 申请科室
	s HospID=$p(^CTLOC(CsRLocID),"^",22)          /// 医院ID
	s userName=$p(mListData,"^",2)     /// 外院名称
	s LocID=$p(mListData,"^",3)        /// 外院科室
	s PrvTpID=$p(mListData,"^",4)      /// 医生职称
	s TelPhone=$p(mListData,"^",5)     /// 联系电话
	s userCode=..GetCurMaxCode("US","3")   ///工号
	
	s hasDataId=##Class(web.DHCMDTExpertMan).hasDataId(LocID_"^"_PrvTpID_"^"_userName_"^"_HospID)
	
	///  维护专家字典
	s mParam="^"_userCode_"^"_userName_"^^"_PrvTpID_"^^"_LocID_"^"_TelPhone_"^Y^"_HospID
	
	s OutExpID=""
	i hasDataId="" d
	.s OutExpID=##Class(web.DHCMDTExpertMan).insert(mParam)
	i hasDataId'="" d
	.s OutExpID=hasDataId
	Q:OutExpID<0 OutExpID
	/// 专家与病种关联
	s mParam="^"_DisGrpID_"^"_OutExpID
	s Err=##class(web.DHCMDTGroup).InsOutExp(mParam)
	Q:Err'=0 Err
	
	Q OutExpID
}

/// Creator:    bianshuai
/// CreateDate: 2019-04-19
/// Descript:   发送申请单
/// InPut:      CstID - mdt申请ID, LgParam - 登录信息串
/// OutPut:     0-成功，其他-失败
/// w ##class(web.DHCMDTConsult).SendCstNo("35","2^4^29^15222","16.22.86.105")
ClassMethod SendCstNo(CstID As %String, LgParam As %String, IpAddress As %String = "") As %String
{
	n (CstID, LgParam, IpAddress, %session)

	s StatusID=..GetConsStatus(20) /// 发送
	s HospID=$p(LgParam,"^",1)   /// 医院ID
	s UserID=$p(LgParam,"^",4)    /// 用户ID
	s HasCenter=##Class(web.DHCMDTCom).GetEmSysConfig("HASCENTER",HospID)  //是否具有会诊中心 
	s $ZT="SendErrorMsg"
	/// 申请状态
	Q:$p(^DHCMDTCON(CstID),"^",12)'="" -1   //不为保存状态退出
	s Err=0
	TS
	/// 修改状态
	s Err = ..InsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 预约资源
	i HasCenter=0 s Err=##Class(web.DHCMDTInterface).InvDocApp(CstID, LgParam)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 插入日志
	s Err = ..InsConsLog(CstID,UserID,StatusID,"")
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	///推送消息给电子病历
	s Err=##Class(web.DHCMDTInterface).SendEmrData(CstID)
	i Err'=0 tro
	q:Err'=0 "-14^推送给电子病历数据错误!"
	
	TC
	/// 信封消息
	i HasCenter=0 D ##Class(web.DHCMDTInterface).SendCsReqMsg(CstID)
	Q CstID
SendErrorMsg
	Q "-99"
}

/// Descritp:  接收申请单
/// InPut:     CstID-会诊ID, UserID-用户ID
/// OutPut:    0-成功，其他-失败
/// W ##Class(web.DHCMDTConsult).AcceptCstMas("6","876")
ClassMethod AcceptCstMas(CstID As %String, LgUserID As %String) As %String
{
	n (CstID, LgUserID)

	s Err=0
	s StatusID=..GetConsStatus(50)
	/// 是否允许接受申请单
	Q:(..IsPermitAccept(CstID, LgUserID)) "-2"
	TS
#;	/// 修改状态
#;	s Err = ..InsMasStatus(CstID,ItmID,StatusID)
#;	i Err'=0 tro
#;	Q:Err'=0 "-11"
	
	/// 插入日志
	s itmID=..GetMdtCsItemID(CstID, LgUserID)
	s Err=..InsConsLog(itmID,LgUserID,StatusID,"")
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	TC
	Q Err
}

/// Descritp:  不能参见会诊原因
/// InPut:     CstID-会诊ID, UserID-用户ID
/// OutPut:    0-成功，其他-失败
/// W ##Class(web.DHCMDTConsult).RefCstMas("11","876","今天要出急诊无时间参加，请要求其他专家，谢谢！")
ClassMethod RefCstMas(CstID As %String, LgUserID As %String, CstNote As %String) As %String
{
	n (CstID, LgUserID, CstNote)

	s Err=0
	s StatusID=..GetConsStatus(60)
	/// 是否有权限拒绝申请
	Q:(..IsPermitRef(CstID, LgUserID)) "-1"
	/// 申请状态
	//Q:('..GetIsModFlag(CstID,30)) "-2"
	TS
	
	/// 插入日志
	s itmID=..GetMdtCsItemID(CstID, LgUserID)
	s Err = ..InsConsLog(itmID,LgUserID,StatusID,CstNote)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	///执行消息
	s Err=##Class(web.DHCMDTInterface).InvExecMes(CstID, LgUserID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	TC
	
	Q Err
}

/// Descritp:  是否允许接受申请单
/// InPut:     CstID - 会诊ID
/// OutPut:    0-允许,1-不允许
/// W ##Class(web.DHCEMConsult).IsPermitAccept("12")
ClassMethod IsPermitAccept(CstID As %String, LgUserID As %String) As %String
{
	n (CstID, LgUserID)
	Q:(..GetCsAcceptFlag(CstID, LgUserID)) 1
	Q 0
}

/// Descritp:  是否允许接受申请单
/// InPut:     CstID - 会诊ID
/// OutPut:    0-允许,1-不允许
/// W ##Class(web.DHCEMConsult).IsPermitRef("12")
ClassMethod IsPermitRef(CstID As %String, LgUserID As %String) As %String
{
	n (CstID, LgUserID)
	s item=..GetMdtCsItemID(CstID, LgUserID)  /// 对应会诊子表ID
	Q:item="" 1
	Q 0
}

/// Descritp:  评估(完成)申请单
/// Input:     CstID - 会诊ID, LgParam - 登录信息, ListData - 病情摘要^会诊目的^会诊意见^会诊讨论^会诊科室
/// w ##class(web.DHCMDTConsult).CompCstNo("7","P","3^191^299^876","")
ClassMethod CompCstNo(CstID As %String, WriType As %String, LgParam As %String, mListData As %String) As %String
{
	n (CstID, WriType, LgParam, mListData)

	s Err=0
	s StCode=$s(WriType="P":"40",WriType="E":"80",1:"") /// 操作类型
	i WriType'="S" s StatusID=..GetConsStatus(StCode)   /// 完成	
	s LgHospID= $p(LgParam,"^",1)        /// 医院ID
	s LgUserID= $p(LgParam,"^",4)        /// 用户ID
	/// 申请状态
	/// 是否有疑难病会诊中心
	s HasCenter=##Class(web.DHCMDTCom).GetEmSysConfig("HASCENTER",LgHospID)
	i HasCenter'=0 s stCodes="30^40^35"
	E  s stCodes="20^40^35"
	;Q:(WriType="P")&('..GetIsTakOperFlag(CstID,stCodes)) "-1^非"
	;Q:(WriType="E")&('..GetIsTakOperFlag(CstID,"30^40^75")) "-1^非安排和取消完成状态,不允许完成!"
	s IsValid=##class(web.DHCMDTConsult).ValidStatus(CstID,80)
	q:IsValid'=0 "-1^"_IsValid
	s Err=0
	TS
	
	/// 修改状态
	i WriType'="S" D
	.s Err = ..InsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11^状态更改失败!"
	
	/// 插入日志
	i WriType'="S" D
	.s Err = ..InsConsLog(CstID,LgUserID,StatusID,"")
	i Err'=0 tro
	Q:Err'=0 "-12^日志插入失败!"
	
	///会诊意见
	s Err = ..InsMdtConsult(CstID, mListData)
	i Err'=0 tro
	Q:Err'=0 "-13^会诊意见存储失败!"
	
	/// 执行会诊医嘱
	i WriType="E" D
	.s Err = ..ExeCsCOeori(CstID,LgUserID,"E")
	i Err'=0 tro
	Q:Err'=0 "-14^执行会诊医嘱失败!"
	
	///推送消息给电子病历
	i WriType="E" D
	.s Err=##Class(web.DHCMDTInterface).SendEmrData(CstID)
	i Err'=0 tro
	q:Err'=0 "-15^推送给电子病历数据错误!"
	
	///执行消息
	i WriType'="S" D
	.s Err=##Class(web.DHCMDTInterface).InvExecMes(CstID, LgUserID)
	i Err'=0 tro
	q:Err'=0 "-15^执行消息失败!"
	
	///发送完成的消息
	s:WriType="E" Err=##Class(web.DHCMDTConsult).SendMdtCstCompMes(CstID, LgUserID)
	i Err'=0 tro
	q:Err'=0 "-16^推送完成消息异常!"
	
	///发送完成的消息
	s:WriType="E" Err=..ClearAssUser(CstID)
	i Err'=0 tro
	q:Err'=0 "-17^取消外院专家关联账号失败!"
	
	
	TC

	Q 0
}

/// Descritp:  完成的时候提醒会诊医生会诊已经完成
/// Input:     CstID - 会诊ID, LgUserID - 当前登录人
/// w ##class(web.DHCMDTConsult).SendMdtCstCompMes("110","13247")
ClassMethod SendMdtCstCompMes(CstID, LgUserID)
{
	s CH="",Err=0
	F  s CH=$o(^DHCMDTCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.s Err=..SendMdtCstComp(CstID_"||"_CH, LgUserID)
	.
	Q Err
}

/// Creator:     乔庆澳
/// CreateDate:  2020-07-07
/// Descript:    发送申请消息
/// Input :      
/// w ##Class(web.DHCMDTInterface).InvExec("3","4634")
ClassMethod SendMdtCstComp(CstItmID, LgUserID) As %String
{
	n (CstItmID,LgUserID)
	q:CstItmID="" "-1001"
	q:LgUserID="" "-1002"
	s EpisodeID = $p(^DHCMDTCON(+CstItmID),"^",1) 
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s AdmHospID=##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
	
	s ID=+CstItmID
	s CH=$p(CstItmID,"||",2)
	s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",2)     /// 医生
	q:CareProvID="" 0								 /// 完成未确定医师的不发送信息
	s:CareProvID'="" CareProv=$p($g(^CTPCP(CareProvID,1)),"^",2)
	s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	s ReceiveDocs=CsUserID
	s LocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)   
	s PreTime=##Class(web.DHCMDTCom).GetPreDateInfo(ID)
	s PreDate=$p(PreTime,"^",1)
	s LinkUrl="dhcmdt.execonclusion.csp"
	s LinkUrl=""""_LinkUrl_"?EpidsodeID="_EpisodeID_"&showModel=3&ID="_+CstItmID_""""
	s Link="{""link"":"_LinkUrl_",""BizObjId"":"_""""_CstItmID_""""_",""dialogWidth"":"_1400_",""dialogHeight"":"_600_"}"
	s ToLocRowId=LocID_"|OnlyFlag"
	s MesNotes="患者"_PatName_"于"_PreDate_"日的MDT会诊已经完成!"
	s Ret=##class(websys.DHCMessageInterface).Send(MesNotes,"1177",LgUserID,EpisodeID,"",ReceiveDocs, Link,ToLocRowId)
	q:Ret<0 Ret
	;s Ret=##Class(web.DHCMDTInterface).SendSmsServiceByUserIDs(ReceiveDocs,AdmHospID,MesNotes)
	q:Ret<0 Ret
	q 0
}

/// Descritp:  评估(完成)申请单
/// Input:     CstID - 会诊ID, ListData - 病情摘要^会诊目的^会诊意见^会诊讨论
ClassMethod InsMdtConsult(CstID As %String, mListData As %String) As %String
{
	n (CstID, mListData)
	s CsTrePro=$p(mListData,"^",1)    /// 病情摘要
	s CsPurpose=$p(mListData,"^",2)   /// 会诊目的
	s TreMeasures=$p(mListData,"^",3) /// 会诊意见
	s DisProcess=$p(mListData,"^",4)  /// 会诊讨论
	s mdtSuppsnote=$p(mListData,"^",5)  /// 会诊讨论
	s mdtTumorFlag=$p(mListData,"^",7)  /// 会诊讨论
	&SQL(Update DHC_MDTConsult Set MC_TrePro=:CsTrePro, MC_Purpose=:CsPurpose, MC_TreMeasures=:TreMeasures,
	 MC_DisProcess=:DisProcess,MC_SuppNotes=:mdtSuppsnote,MC_TumStage=:mdtTumorFlag Where MC_RowID=:CstID)
	Q SQLCODE
}

/// Descript:取消会诊
/// w ##class(web.DHCMDTConsult).CancelMdtCons(21,"2^4^29^15222")
ClassMethod CancelMdtCons(CstID, LgParam)
{
	n (CstID, LgParam)
	s Err=0
	s StatusID=..GetConsStatus(10)  //取消
#;	s AppAdmID=$p(^DHCMDTCON(CstID),"^",20)
#;	Q:AppAdmID'="" "-1"
	s HospID=$p(LgParam,"^",1)   /// 医院ID
	s HasCenter=##Class(web.DHCMDTCom).GetEmSysConfig("HASCENTER",HospID)  //是否具有会诊中心 
	s IsValid = ##class(web.DHCMDTConsult).ValidStatus(CstID,10)
	q:IsValid'=0 "-1^"_IsValid
	/// 申请状态
	Q:(..IsPermitCancel(CstID,HasCenter)) "-2^医嘱已经交费,先退费再做取消!"
	Q:(..IsExecOrder(CstID)) "-3^医嘱已经执行,无法撤销!"
	s Err=0
	TS
	/// 取消预约
	i HasCenter=0 s Err=##Class(web.DHCMDTInterface).InvDocRet(CstID, LgParam) /// 退号
	i Err'=0 tro
	Q:Err'=0 "-11^取消预约失败!"
	
	/// 修改状态
	s Err = ..InsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-12^修改状态失败!"
	
	/// 插入日志
	s LgUserID= $p(LgParam,"^",4) /// 用户ID
	s Err = ..InsConsLog(CstID,LgUserID,StatusID,"")
	i Err'=0 tro
	Q:Err'=0 "-13^插入日志失败!"
	
	///执行消息
	s Err=##Class(web.DHCMDTInterface).InvExecMes(CstID, LgUserID)
	i Err'=0 tro
	Q:Err'=0 "-14^执行消息失败!"
	
	TC
	Q 0
}

/// Descript:取消安排
/// w ##class(web.DHCMDTConsult).CancelArrange("130","2^227^297^13835")
ClassMethod CancelArrange(CstID, LgParams)
{
	n (CstID, LgParams)
	
	s Err=0
	s StatusID=..GetConsStatus(25)  ///取消安排
	s HospID=$p(LgParams,"^",1)  	/// 医院ID
	s LgUserID= $p(LgParams,"^",4) /// 用户ID
	s HasCenter=##Class(web.DHCMDTCom).GetEmSysConfig("HASCENTER",HospID)  //是否具有会诊中心 
	q:HasCenter=0 "-99^当前模式不需要安排,无法进行取消安排!"
	s IsValid = ##class(web.DHCMDTConsult).ValidStatus(CstID,25)
	q:IsValid'=0 "-1^"_IsValid
	/// 申请状态
	Q:(..IsPermitCancel(CstID,HasCenter)) "-2^医嘱已经交费,退费后可自动取消,禁止取消安排,如需修改日期和地点,通过修改资源功能实现!"
	Q:(..IsExecOrder(CstID)) "-3^医嘱已经执行,无法取消安排!"
	s Err=0
	TS
	/// 取消预约
	i HasCenter'=0 s Err=##Class(web.DHCMDTInterface).InvDocRet(CstID, LgParams) /// 退号
	i Err'=0 tro
	Q:Err'=0 "-11^取消预约失败!"
	
	/// 修改状态
	s Err = ..InsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-12^修改状态失败!"
	
	/// 插入日志
	
	s Err = ..InsConsLog(CstID,LgUserID,StatusID,"")
	i Err'=0 tro
	Q:Err'=0 "-13^插入日志失败!"
	
	///取消关联的费用
	s Err=##Class(web.DHCMDTConsult).DelOrdBill(CstID)
	i Err'=0 tro
	Q:Err'=0 "-15^费用关联撤销失败!"
	
	///执行消息
	s Err=##Class(web.DHCMDTInterface).InvExecMes(CstID, LgUserID)
	i Err'=0 tro
	Q:Err'=0 "-14^执行消息失败!"
	
	/// 收回关联院外账号
	s Err = ..ClearAssUser(CstID)
	i Err'=0 tro
	Q:Err'=0 "-15^取消外院专家关联账号失败!"
	
	TC
	Q 0
}

/// Descript:删除费用关联
/// Other:
ClassMethod DelOrdBill(CstID)
{
	n (CstID)
	&sql(DELETE DHC_MDTOrdBill WHERE MO_Cons_Dr = :CstID )
	q SQLCODE
}

ClassMethod InsAppoint(CstID, UserID, IpAddress)
{
	n (CstID,UserID,IpAddress)
	s AppSclID = $p(^DHCMDTCON(CstID),"^",18)
	q:AppSclID="" -1
	s AdmID = $p(^DHCMDTCON(CstID),"^",1)
	s PatID = $p(^PAADM(AdmID),"^",1)
	s Notes="MDT会诊,会诊ID为"_CstID
	b ;1
	s Ret = ##class(web.DHCOPAdmReg).OPAppDocBroker(PatID,AppSclID,"",UserID,"DOC","APP","",IpAddress,Notes) 		;医生站接口
	b ;2
	q:+Ret'=0 -2  
	
	s AppointDr = $p(Ret,"^",2)
	&sql(UPDATE DHC_MDTConsult SET MC_Appoint_Dr =:AppointDr WHERE MC_RowID=:CstID )
	q:SQLCODE'=0 -3
	q 0
}

/// Creator:    bianshuai
/// CreateDate: 2019-04-19
/// Descript:   修改mdt主表状态
/// InPut:      CstID - mdt申请ID, mdtStatusID - 状态ID
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCMDTConsult).InsMasStatus("10","4")
ClassMethod InsMasStatus(ID As %String, mdtStatusID As %String) As %String
{
	n (ID, mdtStatusID)
	&SQL(update DHC_MDTConsult set MC_ExeStatus=:mdtStatusID where MC_RowID=:ID)
	Q SQLCODE
}

/// Descritp:   更新会诊结论
/// OutPut:     0-成功，其他-失败
/// w ##class(web.DHCMDTConsult).UpdCstOpinion("37","会诊意见")
ClassMethod UpdCstOpinion(ID As %String, Opinion As %String) As %String
{
	n (ID, Opinion)
	&SQL(UPDATE DHC_MDTConsult SET MC_TreMeasures =:Opinion WHERE MC_RowID = :ID)
	Q SQLCODE
}

/// Creator:    qqa
/// CreateDate: 2019-04-25
/// Descript:   修改mdt主表预约产生的Adm
/// InPut:      CstID - mdt申请ID, AppAdm - 就诊ID
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCMDTConsult).InsMasAppAdm("2","6")
ClassMethod InsMasAppAdm(ID As %String, AppAdm As %String) As %String
{
	n (ID, AppAdm)
	&SQL(update DHC_MDTConsult set MC_AppAdm_Dr=:AppAdm where MC_RowID=:ID)
	Q SQLCODE
}

/// Descritp:  会诊申请的状态代码
/// w ##Class(web.DHCMDTConsult).GetConsStatus("1")
ClassMethod GetConsStatus(CstStatCode As %String) As %String
{
	n (CstStatCode)
	s CstStatID=$o(^DHCMDTS(0,"Code",$$ALPHAUP^SSUTIL4(CstStatCode),""))
	Q CstStatID
}

/// Descritp:  插入会诊医生操作记录
ClassMethod InsConsLog(CstID As %String, UserID As %String, StatusID As %String, CstNote As %String = "") As %String
{
	n (CstID, UserID, StatusID, CstNote)
	s CstDate=+$H   		            ///操作日期
	s CstTime=$p($H,",",2)              ///操作时间
	&SQL(INSERT INTO DHC_MDTLog (ML_Cst_Ref,ML_User_Dr,ML_Status_Dr,ML_Date,ML_Time,ML_Notes) 
		VALUES
		(:CstID,:UserID,:StatusID,:CstDate,:CstTime,:CstNote))
	Q SQLCODE
}

/// Descript: 会诊申请插入医嘱
/// w ##Class(web.DHCMDTConsult).InsCstOeori("61")
ClassMethod InsCstOeori(CstID As %String, LgParams As %String) As %String
{
	n (CstID, LgParams)
	s Err=0
	s HospID=$p(LgParams,"^",1)     /// 医院ID
	s HasCenter=##Class(web.DHCMDTCom).GetEmSysConfig("HASCENTER",HospID)  //是否具有会诊中心
	s LgLocID=$p(LgParams,"^",2)   /// 科室ID
	s UserID=$p(LgParams,"^",4)    /// 用户ID
	s DisGrpID=$p(^DHCMDTCON(CstID),"^",16)    /// 疑难病种
	s EpisodeID=$p(^DHCMDTCON(CstID),"^",20)   /// 预约就诊ID
	i +EpisodeID=0 s EpisodeID=$p(^DHCMDTCON(CstID),"^",1)   /// 申请就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 	   /// 就诊科室
	s RecLocID=PatLocID, LocID=LgLocID    /// PatLocID
	//i HasCenter=0 s RecLocID=LgLocID, LocID=LgLocID
	i UserID="" s UserID=$p(^DHCMDTCON(CstID),"^",5)       /// 申请人
	s BillTypeID=$p(^PAADM(EpisodeID,1),"^",7) /// 费别ID
	s EmgFlag=""
	s MDRowID=""
	F  s MDRowID=$o(^DHCMDTOC(0,"Group",DisGrpID,MDRowID)) Q:(MDRowID="")||(Err'=0)  D
	.s ArciID=$p(^DHCMDTOC(MDRowID),"^",2)
	.s PackQty=+$p(^DHCMDTOC(MDRowID),"^",3)
	.s:+PackQty=0 PackQty=1
	.s ItmMaststr=""
	.s ItmMaststr=ArciID_"^"_RecLocID
	.s OrdNotes="MDT多学科会诊"
	.s Ret=##Class(web.DHCMDTCom).SaveOrderItems(EpisodeID,ItmMaststr,UserID,LocID,EmgFlag,OrdNotes,"","","",BillTypeID,PackQty) /// 插入医嘱
	.i Ret=100 s Err=-1
	.Q:Ret=100
	.s Oeori=$p(Ret,"*",2)  /// 医嘱ID
	.s Err=..InsConsOeori(CstID, Oeori)
	.
	Q Err
}

/// Descript: 记录会诊申请产生会诊费的ID
/// w ##Class(web.DHCMDTConsult).InsCstOeori("61")
ClassMethod InsConsOeori(CstID, Oeori)
{
	n (CstID,Oeori)
	s OrdBill="N"
	&sql(INSERT INTO DHC_MDTOrdBill (MO_Cons_Dr,MO_OrdItm_Dr) 
		VALUES (:CstID,:Oeori))
	q SQLCODE
}

/// Descript: 记录会诊申请产生会诊费的ID
/// w ##Class(web.DHCMDTConsult).UpdConsOeori("130||2","Y")
/// Creator:MDT会诊发送消息
/// Creat
/// w ##class(web.DHCMDTConsult).InsWebsysMessage(5)
ClassMethod InsWebsysMessage(CstID)
{
	n (CstID)
	s CreatLocID=$p(^DHCMDTCON(CstID),"^",2)
	s CreatDoc = $p(^DHCMDTCON(CstID),"^",5)
	s EpisodeID = $p(^DHCMDTCON(CstID),"^",20) /// 就诊ID
	s PreTime=""
	s AppScDr = $p(^DHCMDTCON(CstID),"^",18)   /// 资源表ID
	s:AppScDr'="" PreTime =$p(^RBAS(+AppScDr,$p(AppScDr,"||",2)),"^",1)
	s:PreTime'="" PreTime=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(PreTime)
	
	s Ret=0
	s Title = "您申请的"_PreTime_"的MDT会诊,病人已缴费,可告知科秘!"
	s Ret = ##Class(web.DHCMDTConsult).Sendmessage(CreatDoc,EpisodeID,CreatDoc,CreatLocID,CstID,Title)
	
	s Sub = 0
	f  s Sub= $o(^DHCMDTCON(CstID,"I",Sub)) q:(Sub="")||(Ret<0)  d
	.s Docs=""
	.s LocID = $p(^DHCMDTCON(CstID,"I",Sub),"^",1)
	.s CTPCPId = $p(^DHCMDTCON(CstID,"I",Sub),"^",2)
	.s CarePrvType =$p(^DHCMDTCON(CstID,"I",Sub),"^",4)
	.q:LocID="" 
	.s:CTPCPId'="" Docs = $o(^SSU("SSUSR",0,"CTPCP",CTPCPId,""))
	.s:CTPCPId="" Docs = ##class(web.DHCMDTConsult).GetLocDoc(LocID,CarePrvType)
	.Q:Docs=""
	.s Title = "有"_PreTime_"的MDT会诊,病人已缴费,请等待科秘与您联系!"
	.s Ret = ##Class(web.DHCMDTConsult).Sendmessage(CreatDoc,EpisodeID,Docs,LocID,CstID_"||"_Sub,Title)
	
	q Ret
}

/// Descript：获取科室里里面所有医生或者护士
/// 	Input: LocID , NURSE/DOCTOR
/// w ##class(web.DHCMDTConsult).GetLocDoc("3","DOCTOR")
ClassMethod GetLocDoc(LocID, CareType) As %String
{
	n (LocID,CareType)
    s RetDocs=""
    q:LocID="" ""
    s ResID="" 
    f  s ResID = $O(^RB("RES",0,"CTLOC",LocID,ResID)) q:ResID=""  d
	.s ResCTPCPDR = $p(^RB("RES",ResID),"^",2)
	.q:+ResCTPCPDR=0
	.;q:+$g(^CTPCP(ResCTPCPDR,1))=0
	.s CarPrvTpDR = $p(^CTPCP(ResCTPCPDR,1),"^",4) ;CTPCP_CarPrvTp_DR-->CT_CarPrvTp
	.q:+CarPrvTpDR=0
	.s Type = $p(^CT("CPT",CarPrvTpDR),"^",4)		;CTCPT_InternalType
	.q:Type'=CareType
	.s DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",ResCTPCPDR,""))
	.s:RetDocs'="" RetDocs=RetDocs_"^"_DoctorUserDr
	.s:RetDocs="" RetDocs=DoctorUserDr
	q RetDocs
}

/// Descript: 会诊申请发送到消息
/// Input : 发送医生，就诊，接收医生，科室ID，申请ID
ClassMethod Sendmessage(CreatDoc, EpisodeID, ReceiveDocs, LocID, ConsultID, Title) As %String
{
	n (CreatDoc, EpisodeID, ReceiveDocs,LocID,ConsultID,Title)
	q:CreatDoc="" "-1001"
	q:EpisodeID="" "-1002"
	
	s Url=""
	s Link="{""link"":"_Url_",""BizObjId"":"_""""_ConsultID_""""_",""dialogWidth"":"_1400_",""dialogHeight"":"_600_"}"
	s ToLocRowId=LocID_"|OnlyFlag"
	s Ret=##class(websys.DHCMessageInterface).Send(Title,"1177",CreatDoc , EpisodeID,"",ReceiveDocs, Link,ToLocRowId)
	q Ret
}

/// Descritp:  执行信封消息
/// w ##Class(web.DHCMDTConsult).InvExec("14","1")
ClassMethod InvExec(CstID As %String, UserID As %String) As %String
{
	n (CstID, UserID)
	s Ret=0
	s EpisodeID = $p(^DHCMDTCON(CstID),"^",20)
	s Sub = 0
	f  s Sub= $o(^DHCMDTCON(CstID,"I",Sub)) q:(Sub="")||(Ret<0)  d
	.s itmID = CstID_"||"_Sub
	.s Ret = ##class(websys.DHCMessageInterface).Exec("","1014",EpisodeID,"",itmID,UserID)                                                                       ;//处理消息	
	.i Ret="-3" s Ret=0    /// -3 未找到消息
	.i Ret="-102" s Ret=0  /// -102 消息已执行过
	.i Ret>0 s Ret=0
	
	s Ret = ##class(websys.DHCMessageInterface).Exec("","1014",EpisodeID,"",+itmID,UserID)                                                                       ;//处理消息	
	i Ret="-3" s Ret=0    /// -3 未找到消息
	i Ret="-102" s Ret=0  /// -102 消息已执行过
	i Ret>0 s Ret=0
	
	q Ret
}

/// Description: 修改MDT会诊实际到达医生
/// Creator:     qqa
/// CreateDate:  2019-04-28
/// Table:       
/// Input:  	 params:
/// Output:   	 保存成功 0, 其他 失败
/// Others:		 w ##class(web.DHCMDTConsult).SaveItms("19","19||5^1^主任医师^^本院^113^中医科门诊^965^齐鑫^0")
ClassMethod SaveItms(CstID, Params)
{
  	n (CstID,Params)
	s $Zt="Err"
  	TStart
  	s Ret=0
  	s Len=$l(Params,"$$")
  	for i=1:1:Len d
  	.q:Ret<0
  	.s Str=$p(Params,"$$",i)
  	.s Ret=..SaveOrUpdateItm(CstID,Str)
	i Ret<0 TRollback
	TCOMMIT
	q Ret
Err
	TRollback
	q -1
}

ClassMethod SaveOrUpdateItm(CstID, Params)
{
	n (CstID,Params)
	q:Params=""
	s CstItmID = $p(Params,"^",1)     ///会诊子表ID
	s CstCLocID = $p(Params,"^",4)    /// 会诊科室
	s CstNDocID = $p(Params,"^",6)    /// 要求会诊医生
	s PrvTpID=$p(Params,"^",8)      /// 医生职称
	s SubMarID=""   
	s ChildSub=$o(^DHCMDTCON(CstID,"I",""),-1)+1
	s Ret=0
	b ;err
	i CstItmID="" d
	.&SQL(Insert Into DHC_MDTConsultItm(MC_ParRef_Dr,MC_ChildSub,MC_CLoc_Dr,MC_NDoc_Dr,MC_PrvTp_Dr,MC_SubMar_Dr)
		values(:CstID,:ChildSub,:CstCLocID,:CstNDocID,:PrvTpID,:SubMarID))
	.s Ret=SQLCODE
	i CstItmID'="" d
	.b ;err2
	.&SQL(update DHC_MDTConsultItm set MC_CLoc_Dr=:CstCLocID,MC_NDoc_Dr=:CstNDocID,MC_PrvTp_Dr=:PrvTpID,
	MC_SubMar_Dr=:SubMarID where MC_RowID=:CstItmID )
	.s Ret=SQLCODE
	
	q Ret
}

ClassMethod RemoveCstItm(CstItmID)
{
	n (CstItmID)
	&sql(DELETE DHC_MDTConsultItm WHERE MC_RowID=:CstItmID)
	q SQLCODE
}

/// Creator:    qqa
/// CreateDate: 2019-05-15
/// Descript:   插入会诊打印标志
/// InPut:      CstID - 会诊申请ID,PrintFlag-Z:知情同意书,Y:申请单
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCMDTConsult).InsMakRes("151","Y")
ClassMethod InsCsMasPrintFlag(CstID As %String, PrintFlag As %String = "") As %String
{
	n (CstID,PrintFlag)
	q:PrintFlag=""
	s PrintFlag = $p(^DHCMDTCON(CstID),"^",15)_PrintFlag
	&SQL(update DHC_MDTConsult set MC_PrintFlag=:PrintFlag Where MC_RowID=:CstID)
	Q SQLCODE
}

/// Descript:   安排 - 修改会诊资源
/// w ##Class(web.DHCMDTConsult).InsMakRes("63","2^227^297^13835","01/07/2021^00:00-23:59^3159||95^三楼会议室","6^81^1^@27^1313^1^@53^128^1^@94^224^1^@121^237^1^@170^1017^1^")
ClassMethod InsMakRes(CstID As %String, LgParams As %String, makResParams As %String, makLocParams As %String, makOuterExp = "") As %String
{
	n (CstID, LgParams, makResParams, makLocParams,makOuterExp,%session)
	s Err=0
	s StatusID=..GetConsStatus(30)   	   /// 发送
	s IsValid = ##class(web.DHCMDTConsult).ValidStatus(CstID,30)
	q:IsValid'=0 "-1^"_IsValid
	s LocAddr=$p(makResParams,"^",4)  ;会诊地址
	
	s $ZT="MakResErrorMsg"
	TS
	
	/// 修改状态
	s Err = ..InsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11^修改状态失败!"
	
	/// 删除相关字表内容重新插入
	s Err=..DelCstMasSubTable(CstID)
	i Err'=0 tro
	Q:Err'=0 "-12^删除相关子表失败!"
	
	/// 修改会诊地址
	s Err=..UpdConsAddr(CstID, LocAddr)
	i Err'=0 tro
	Q:Err'=0 "-18^修改会诊地址失败!"
	
	/// 修改专家组
	s Err=..InsItmLoc(CstID, makLocParams)
	i Err'=0 tro
	Q:Err'=0 "-13^修改专家组失败!"
	
	/// 修改资源
	s Err=..InsCsMakRes(CstID, makResParams)
	i Err'=0 tro
	Q:Err'=0 "-14^修改资源失败!"
	
	/// 外院专家
	s Err=..InsOuterExpert(CstID, makOuterExp)
	i Err'=0 tro
	Q:Err'=0 "-17^插入外院专家失败!"
	
	/// 预约资源
	s Err=##Class(web.DHCMDTInterface).InvDocApp(CstID, LgParams)
	i Err'=0 tro
	Q:Err'=0 "-15^产生预约资源,生成费用失败,失败信息:"_Err
	
	/// 插入日志
	s LgUserID=$p(LgParams,"^",4)  /// 用户ID
	s Err = ..InsConsLog(CstID,LgUserID,StatusID,"")
	i Err'=0 tro
	Q:Err'=0 "-16^插入日志异常!"
	TC
	/// 信封消息
	D ##Class(web.DHCMDTInterface).SendCsReqMsg(CstID)
	
	Q 0
MakResErrorMsg
	tro
	Q "-99"
}

/// Descript:修改会诊地址
ClassMethod UpdConsAddr(CstID, LocAddr)
{
	n (CstID, LocAddr)
	q:LocAddr="" 0
	&sql(UPDATE DHC_MDTConsult SET MC_NPlace=:LocAddr WHERE MC_RowID=:CstID)
	q SQLCODE
}

/// Descript:   删除本次存储会诊子表不存在记录
ClassMethod delItmLoc(ID As %String, mListData As %String) As %String
{
	n (ID, mListData)
	s Err=0
	
	k TmpArr
	F i=1:1:$L(mListData,"@")  D
	.s ListData=$p(mListData,"@",i)    /// 项目列表
	.s itmID=$p(ListData,"^",5)
	.Q:itmID=""
	.s CsNDocID=$p(ListData,"^",2)     /// 会诊医生
	.s TmpArr(itmID)=CsNDocID
	.
	
	s Flag=1
	s CH=""
	F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.Q:$d(TmpArr(ID_"||"_CH))&(+$p(^DHCMDTCON(ID,"I",CH),"^",2)=$g(TmpArr(ID_"||"_CH)))
	.i $d(TmpArr(ID_"||"_CH))&(+$p(^DHCMDTCON(ID,"I",CH),"^",2)'=$g(TmpArr(ID_"||"_CH))) s Flag=0
	.s Err=..deleteCsItem(ID_"||"_CH, Flag)
	.
	Q Err
}

/// Descript: 删除会诊申请子表和关联表数据
/// w ##Class(web.DHCMDTConsult).deleteCsItem("24")
ClassMethod deleteCsItem(itmID As %String, Flag As %String) As %String
{
	n (itmID, Flag)
	s SQLCODE=0
	
	///  会诊子表
	i (Flag = 1)&($d(^DHCMDTCON(+itmID,"I",$p(itmID,"||",2)))) D
	.&SQL(delete from DHC_MDTConsultItm where MC_RowID=:itmID)
	Q:SQLCODE'=0 SQLCODE
	
	///  会诊子表
	s ID=$o(^DHCMDTL(0,"CstRef",itmID,""))
	i ID'="" &SQL(delete from DHC_MDTLog where ML_Cst_Ref=:itmID)
	Q:SQLCODE'=0 SQLCODE
	
	Q SQLCODE
}

/// Descript:   修改会诊预约资源
ClassMethod InsCsMakRes(ID As %String, makResParams As %String) As %String
{
	n (ID, makResParams)
	s mdtPreDate=$p(makResParams,"^",1)      /// 日期
	s:mdtPreDate'="" mdtPreDate=##class(web.DHCMDTCom).DateHtmlToLogical(mdtPreDate)
	s mdtPreTime=$p(makResParams,"^",2)      /// 时间
	s:mdtPreTime["-" mdtPreTime=$p(mdtPreTime,"-",1)
	s:mdtPreTime'="" mdtPreTime=$zth(mdtPreTime,3)
	s mdtMakResID=$p(makResParams,"^",3)     /// 资源ID
	&SQL(Update DHC_MDTConsult Set MC_NDate=:mdtPreDate, MC_NTime=:mdtPreTime, MC_AppSc_Dr=:mdtMakResID Where MC_RowID=:ID)
	Q SQLCODE
}

/// Descript:   修改会诊专家组
ClassMethod InsItmLoc(ID As %String, mListData As %String, makOuterExp = "") As %String
{
	n (ID, mListData,makOuterExp)
	s Err=0
#;	s Err=..InsConItm(ID, mListData)
#;	Q Err
	F i=1:1:$L(mListData,"@") Q:Err'="0"  D
	.s ListData=$p(mListData,"@",i)    /// 项目列表
	.q:ListData=""
	.s itmID=$p(ListData,"^",5)
	.I itmID="" D
	..s Err=..InsConItm(ID, ListData)
	.E  D
	..s Err=..UpdConItm(itmID, ListData)
	.
	q:Err'=0 Err
	s Err=..InsOuterExpert(ID, makOuterExp)
	Q Err
}

/// Descript:   修改会诊专家组
ClassMethod UpdConItm(ID As %String, ListData As %String) As %String
{
	n (ID, ListData)
	s CstCLocID=$p(ListData,"^",1)    /// 会诊科室
	s CstNDocID=$p(ListData,"^",2)    /// 要求会诊医生
	s PrvTpID=$p(ListData,"^",3)      /// 医生职称
	s SubMarID=$p(ListData,"^",4)     /// 亚专业
	&SQL(update DHC_MDTConsultItm set MC_CLoc_Dr=:CstCLocID, MC_NDoc_Dr=:CstNDocID, MC_PrvTp_Dr=:PrvTpID, MC_SubMar_Dr=:SubMarID where MC_RowID=:ID )
	Q SQLCODE
}

/// Descritp:  会诊申请单状态
/// w ##Class(web.DHCMDTConsult).GetIsModFlag("5","20")
ClassMethod GetIsModFlag(itmID As %String, stCode As %String) As %String
{
	n (itmID, stCode)
	s tID=""
	i itmID["||" D
	.s tID=$p(^DHCMDTCON(+itmID,"I",$p(itmID,"||",2)),"^",6)
	i tID="" D
	.s tID=$p(^DHCMDTCON(+itmID),"^",12)
	Q:tID="" 0
	s ID=$o(^DHCMDTS(0,"Code",$$ALPHAUP^SSUTIL4(stCode),""))
	Q:ID'=tID 0
	Q 1
}

/// Descritp:  会诊申请单状态
/// w ##Class(web.DHCMDTConsult).GetMdtCsItemID("5","876")
ClassMethod GetMdtCsItemID(ID As %String, LgUserID As %String) As %String
{
	n (ID, LgUserID)
	s CH="", itmID=""
	F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:(CH="")||(itmID'="")  D
	.s CareProvID=+$p(^DHCMDTCON(ID,"I",CH),"^",2)
	.Q:LgUserID'=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.s itmID=ID_"||"_CH
	.
	Q itmID
}

/// Descritp:  当前用户接收MDT会诊状态
/// OutPut:    0-未接收，1-已接受,
/// w ##Class(web.DHCMDTConsult).GetCsAcceptFlag("67","13236")
ClassMethod GetCsAcceptFlag(ID As %String, LgUserID As %String) As %String
{
	n (ID, LgUserID)
	s item=..GetMdtCsItemID(ID, LgUserID)  /// 对应会诊子表ID
	Q:item="" 0
	s LgID="", QuitFlag=0, RefFlag=0
	F  s LgID=$o(^DHCMDTL(0,"CstRef",item,LgID),-1) Q:(LgID="")||(QuitFlag=1)||(RefFlag=1)  D
	.s LsID=$p(^DHCMDTL(LgID),"^",3)
	.Q:LsID=""
	.i $p(^DHCMDTS(LsID),"^",1)=60 s RefFlag=1
	.Q:$p(^DHCMDTS(LsID),"^",1)'=50
	.s QuitFlag=1
	.
	Q QuitFlag
}

/// Descritp:  当前用户接收MDT会诊状态
/// OutPut:    0-未接收，1-已接受,2-已拒绝
/// w ##Class(web.DHCMDTConsult).GetCsAcceptFlagNew("67","13236")
ClassMethod GetCsAcceptFlagNew(ID As %String, LgUserID As %String) As %String
{
	n (ID, LgUserID)
	s item=..GetMdtCsItemID(ID, LgUserID)  /// 对应会诊子表ID
	Q:item="" 0
	
	s Ret=0
	s LgID=""
	F  s LgID=$o(^DHCMDTL(0,"CstRef",item,LgID),-1) Q:(LgID="")||(Ret'=0)  D
	.s LsID=$p(^DHCMDTL(LgID),"^",3)
	.Q:LsID=""
	.i $p(^DHCMDTS(LsID),"^",1)=60 s Ret=2
	.i $p(^DHCMDTS(LsID),"^",1)=50 s Ret=1
	.
	Q Ret
}

/// Descritp:  当前用户接收MDT会诊状态和备注
/// OutPut:    0-未接收，1-已接受,2-已拒绝
/// Return:    状态
/// w ##Class(web.DHCMDTConsult).GetCsAcceptNotes("67","1323")
ClassMethod GetCsAcceptNotes(ID As %String, LgUserID As %String) As %String
{
	n (ID, LgUserID)
	s item=..GetMdtCsItemID(ID, LgUserID)  /// 对应会诊子表ID
	q:item="" ""
	
	s RetStatus="",RetNotes=""
	s LgID=""
	F  s LgID=$o(^DHCMDTL(0,"CstRef",item,LgID),-1) Q:(LgID="")||(RetStatus'="")  D
	.s LsID=$p(^DHCMDTL(LgID),"^",3)
	.Q:LsID=""
	.s Notes=$p(^DHCMDTL(LgID),"^",6)
	.i $p(^DHCMDTS(LsID),"^",1)=60 s RetStatus="已拒绝",RetNotes=Notes
	.i $p(^DHCMDTS(LsID),"^",1)=50 s RetStatus="已接收",RetNotes=Notes
	.
	Q RetStatus_"^"_RetNotes
}

/// Descritp:  取会诊医生的操作内容
/// OutPut:    0-未接收，1-已接受
/// w ##Class(web.DHCMDTConsult).GetCsDocRes("16||4","876")
ClassMethod GetCsDocRes(itmId As %String, LgUserID As %String) As %String
{
	n (itmId, LgUserID)
	s LgID="", AccFlag=0, Notes=""
	F  s LgID=$o(^DHCMDTL(0,"CstRef",itmId,LgID),-1) Q:(LgID="")||(AccFlag=1)||(Notes'="")  D
	.s LsID=$p(^DHCMDTL(LgID),"^",3)
	.Q:LsID=""
	.Q:$p(^DHCMDTL(LgID),"^",2)'=LgUserID
	.i $p(^DHCMDTS(LsID),"^",1)=50 s AccFlag=1
	.i $p(^DHCMDTS(LsID),"^",1)=60 s Notes=$p(^DHCMDTL(LgID),"^",6)
	.
	Q AccFlag_"^"_Notes
}

/// Descritp:  是否允许操作
/// W ##Class(web.DHCMDTConsult).GetIsOperFlag("10","20")
ClassMethod GetIsOperFlag(CstID As %String, stCode As %String) As %String
{
	n (CstID, stCode)
	/// 申请状态
	Q:'..GetIsModFlag(CstID,stCode) 0
	Q 1
}

/// Descritp:  是否允许操作
/// W ##Class(web.DHCMDTConsult).GetIsTakOperFlag("10","20")
ClassMethod GetIsTakOperFlag(CstID As %String, stCodes As %String) As %String
{
	n (CstID, stCodes)
	s Flag=0
	F i=1:1:$L(stCodes,"^") Q:Flag=1  D
	.s stCode=$p(stCodes,"^",i)
	.Q:'..GetIsModFlag(CstID,stCode)
	.s Flag=1
	Q Flag
}

/// Descritp:  退号(同时取消会诊申请)
/// W ##Class(web.DHCMDTConsult).RetMakRes("67","2^95^29^10209")
ClassMethod RetMakRes(CstID As %String, LgParams As %String) As %String
{
	n (CstID, LgParams)
	s Err=0
	s HospID=$p(LgParams,"^",1)      /// 医院ID
	s StatusID=..GetConsStatus(10)  /// 撤销状态ID

	s HasCenter=##Class(web.DHCMDTCom).GetEmSysConfig("HASCENTER",HospID)  //是否具有会诊中心 
	/// 申请状态
	s IsValid = ##class(web.DHCMDTConsult).ValidStatus(CstID,10)
	q:IsValid'=0 "-1^"_IsValid
	Q:(..IsPermitCancel(CstID,HasCenter)) "-2^医嘱已经交费,先退费再做取消!"
	Q:(..IsExecOrder(CstID)) "-3^医嘱已经执行,无法撤销!"
	TS
	s Err=##Class(web.DHCMDTInterface).InvDocRet(CstID, LgParams) /// 退号
	i Err'=0 tro
	Q:Err'=0 "-11^退号失败!"
	
	/// 修改状态
	s Err = ..InsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-12^修改状态失败!"
	
	/// 插入日志
	s LgUserID=$p(LgParams,"^",4)  /// 用户ID
	s Err = ..InsConsLog(CstID,LgUserID,StatusID,"")
	i Err'=0 tro
	Q:Err'=0 "-13^插入日志失败!"
	TC
	Q Err
}

/// Descritp:  修改预约资源时间
/// W ##Class(web.DHCMDTConsult).TakMakResDate("103","3^191^299^876","02/08/2019^08:00^37469||43")
ClassMethod TakMakResDate(mdtID As %String, LgParams As %String, makResParams As %String) As %String
{
	n (mdtID, LgParams, makResParams)
	
	s Err=0
	s LgHospID=$p(LgParams,"^",1)  /// 医院ID
	/// 是否有疑难病会诊中心
	s HasCenter=##Class(web.DHCMDTCom).GetEmSysConfig("HASCENTER",LgHospID)
	i HasCenter'=0 s stCodes="30^40"
	E  s stCodes="20^40"
	Q:'..GetIsTakOperFlag(mdtID,stCodes) "-1"

	TS
	/// 修改资源
	s Err=..InsCsMakRes(mdtID, makResParams)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	s LgUserID=$p(LgParams,"^",4)  /// 用户ID
	s mdtMakResID=$p(makResParams,"^",3) /// 预约资源ID
	s Err=##Class(web.DHCMDTInterface).TakMakResDate(mdtID, mdtMakResID, LgUserID) /// 修改资源
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 插入日志
	s LgUserID=$p(LgParams,"^",4)  /// 用户ID
	s Err = ..InsConsLog(mdtID,LgUserID,"","修改预约时间")
	i Err'=0 tro
	Q:Err'=0 "-13"
	TC
	Q Err
}

/// Descritp:  插入会诊主表
/// w ##Class(web.DHCMDTConsult).InsConNotes("")
ClassMethod InsConNotes(mdtID As %String, mData As %String) As %String
{
	n (mdtID,mData)
	&SQL(Update DHC_MDTConsult Set MC_Notes=:mData Where MC_RowID=:mdtID)
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2018-11-21
/// Descritp:   执行会诊医嘱
/// InPut：     mdtID - 会诊ID，UserID - 用户ID，ModFlag - 类型(E-执行、C-撤销执行)
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCMDTConsult).ExeCsCOeori("27","12176","C")
ClassMethod ExeCsCOeori(mdtID As %String, UserID As %String, ModFlag As %String) As %String
{
	n (mdtID, UserID, ModFlag)
	s Err=0, BillId=""
	f  s BillId=$o(^DHCMDTORD(0,"IndexCst",mdtID,BillId)) Q:BillId=""  D
	.s Oeori=$p(^DHCMDTORD(BillId),"^",2)  /// 医嘱ID
	.q:Oeori=""
	.s OeFlag=..GetOrdStCode(Oeori)        /// 医嘱状态
	.
	.q:(OeFlag'="V")&&(ModFlag="E")
	.q:(OeFlag'="E")&&(ModFlag="C")
	.i ModFlag="E" s Err=..Execute(Oeori, UserID) /// 执行医嘱
	.i ModFlag="C" s Err=..CancelMulti(Oeori, UserID, 1)  /// 撤销医嘱
	q Err
}

/// Creator:    bianshuai
/// CreateDate: 2018-11-21
/// Descritp:   更新医嘱状态为执行
/// InPut：     Oeori - 医院，UserID - 用户ID
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCMDTConsult).Execute("12||1","6079")
ClassMethod Execute(Oeori As %String, UserID As %String) As %String
{
	n (Oeori, UserID)
	s Err=##Class(appcom.OEOrdItem).Execute(Oeori, UserID)
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2018-11-21
/// Descritp:   撤销医嘱处理
/// InPut：     Oeori - 医院，UserID - 用户ID, Flag-是否需要撤销执行
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCMDTConsult).CancelMulti("114||92","234",1)
ClassMethod CancelMulti(Oeori As %String, UserID As %String, Flag As %String) As %String
{
	n (Oeori, UserID, Flag)
	s EpisodeID=$p(^OEORD(+Oeori),"^",1)	    /// 就诊ID
	s PatType=$p(^PAADM(EpisodeID),"^",2)  		/// 病人类型
	s Err=0
	i Flag=1 s Err=##Class(appcom.OEOrdItem).Verify(Oeori, UserID)
	Q:Flag=1 Err
	i PatType="I" D
	.s Err=##Class(appcom.OEOrdItem).CancelMulti(Oeori, UserID, "", "N") /// 住院撤销医嘱
	E  D
	.s Err=##Class(appcom.OEOrdItem).StopMulti(Oeori, UserID, "", "N")   /// 门诊停止医嘱
	Q Err
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-12
/// Descript:    医嘱当前状态
/// W ##Class(web.DHCMDTConsult).GetOrdStCode("85722||1")
ClassMethod GetOrdStCode(Oeori As %String) As %String
{
	n (Oeori)
	Q:Oeori="" ""
	s itmID=$p($g(^OEORD(+Oeori,"I",$p(Oeori,"||",2),1)),"^",13)
	Q:itmID="" ""
	s ExeCode=$p(^OEC("OSTAT",itmID),"^",1)
	Q ExeCode
}

/// Descript:   修改会诊专家组会诊意见
ClassMethod UpdConItmOpion(ItmID As %String, mdtOpinion As %String, IsOutDoc = "N") As %String
{
	n (ItmID, mdtOpinion,IsOutDoc)
	i IsOutDoc="N" d
	.&SQL(UPDATE DHC_MDTConsultItm SET MC_Opinion=:mdtOpinion WHERE MC_RowID=:ItmID )
	i IsOutDoc="Y" d
	.&SQL(UPDATE DHC_MDTConOuterExp SET MD_Opinion=:mdtOpinion WHERE MD_RowID=:ItmID )
	Q SQLCODE
}

/// Creator:     yangyongtao
/// CreateDate:  2020-04-21
/// Descritp:    判断是否所有的专家CA签名
/// InPut：      ID - 会诊ID
/// OutPut：     未签名的专家串; 空：所有专家已经签名
/// W ##Class(web.DHCMDTConsult).IsExpCASign("137")
ClassMethod IsExpCASign(ID As %String)
{
	N (ID)
	S UserStr=""
	s Num=0
	S ExpUserDrStr=..GetExpUserArr(ID)
	S Len=$L(ExpUserDrStr,"!!")
	F i=1:1:Len   d
	.S ExpUserArr=$p(ExpUserDrStr,"!!",i)
	.S CsUserID=$p(ExpUserArr,"^",1)
	.S CsUser=$p(ExpUserArr,"^",2)
	.S ItmID=$p(ExpUserArr,"^",3)
	.s SignFlag=..GetCASign(ItmID)
    .Q:SignFlag=1
    .I UserStr="" S UserStr=CsUser
    .E  S UserStr=UserStr_","_CsUser
	Q UserStr
}

/// Creator:     yangyongtao
/// CreateDate:  2020-04-21
/// Descritp:    获取所有的MDT专家用户
/// InPut：      ID - 会诊ID
/// OutPut：     专家串
/// W ##Class(web.DHCMDTConsult).GetExpUserArr("137")
ClassMethod GetExpUserArr(ID As %String)
{
	N (ID)
	S UserArr=""
	S CH=""
	F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	.s CsLocID=$p($g(^DHCMDTCON(ID,"I",CH)),"^",1)       /// 会诊科室
	.s CareProvID=+$p($g(^DHCMDTCON(ID,"I",CH)),"^",2)
	.s PrvTpID=$p(^DHCMDTCON(ID,"I",CH),"^",4)       /// 职称
	.i CareProvID=0 s CareProvID=+$p($g(^DHCMDTCON(ID,"I",CH)),"^",3)
	.s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	.s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.S ItmID=ID_"||"_CH
	.I UserArr=""  S UserArr=CsUserID_"^"_CsUser_"^"_ItmID
	.E  S UserArr=UserArr_"!!"_CsUserID_"^"_CsUser_"^"_ItmID
	Q UserArr
}

/// Creator:     yangyongtao
/// CreateDate:  2020-04-21
/// Descritp:    判断专家是否签名
/// InPut：      ID - 会诊ID
/// OutPut：     SignFlag:0 未签名，SignFlag=1:已签名
/// W ##Class(web.DHCMDTConsult).GetCASign("137")
ClassMethod GetCASign(ItmID)
{
	N (ItmID)
	S SignFlag="0"
	S MSID=""
	F  s MSID=$o(^DHCMDTSV(0,"SorType","B",ItmID,MSID)) Q:(MSID="")||(SignFlag=1)  D
	.S SourceID=$p(^DHCMDTSV(MSID),"^",10)
	.I ItmID=SourceID S SignFlag=1
	Q SignFlag
}

/// Creator: 	 yangyongtao
/// CreateDate:  2020-06-30
/// Descript:    是否所有专家填写会诊意见内容
/// Return       1:无，0:有
/// w ##Class(web.DHCMDTConsult).getCsOpiFlag("")
ClassMethod getCsOpiFlag(CstID)
{
	n (CstID)
	S OpiFlag=1
	S CH=""
	F  s CH=$o(^DHCMDTCON(CstID,"I",CH)) Q:(CH="")||(OpiFlag=0)  D
	.s Opinion=$p($g(^DHCMDTCON(CstID,"I",CH)),"^",6)
	.I Opinion="" S OpiFlag=0
	Q OpiFlag
}

/// Creator:    bianshuai
/// CreateDate: 2020-04-08
/// Descript:   批量删除专家
/// InPut:      mdtIds-会诊ID串,mCareProvID-医护人员ID
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCMDTConsult).RevCsCareProv("25^24^23^22^20")
ClassMethod RevCsCareProv(mdtIds As %String, mCareProvID As %String) As %String
{
	n (mdtIds, mCareProvID)
	s Err=0
	TS
	f i=1:1:$L(mdtIds,"^") Q:Err'=0  D
	.s ID=$p(mdtIds,"^",i) Q:ID=""
	.s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	.s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	.s AppScDr = $p(^DHCMDTCON(ID),"^",18)   /// 资源表ID 
	.s PreTime=##Class(web.DHCMDTCom).JsMakResPreTime(AppScDr) /// 预约时间
	.s CH=""
	.f  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:(CH="")||(Err'=0)  D
	..q:mCareProvID'=$p(^DHCMDTCON(ID,"I",CH),"^",2)
	..s IsConssignIn=##class(web.DHCMDTCom).UserIsConssignIn(ID_"||"_CH)
	..s:IsConssignIn Err="患者"_PatName_PreTime_"的MDT会诊已经签到,无法删除!"
	..q:Err'=0
	..s Err=..RemoveCstItm(ID_"||"_CH)  /// 删除会诊专家
	.
	i Err'=0 Tro
	Q:Err'=0 Err
	TC
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2020-04-08
/// Descritp:   是否允许删除会诊专家
/// InPut:      mdtIds-会诊ID串,mCareProvID-医护人员ID
/// OutPut:     空-允许,不为空-不允许
/// W ##Class(web.DHCMDTConsult).IsPermitDel("25", "1353")
ClassMethod IsPermitDel(mdtIds As %String, mCareProvID As %String) As %String
{
	n (mdtIds, mCareProvID)
	s TmpMes=""
	F i=1:1:$L(mdtIds,"^") D
	.s ID=$p(mdtIds,"^",i) Q:ID=""
	.s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	.s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	.s CH="",Num=0
	.F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	..s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",2)     /// 医生
	..Q:mCareProvID=CareProvID
	..s Num=Num+1
	.i Num<3 s TmpMes=$s(TmpMes="":PatName,1:TmpMes_"、"_PatName)
	.
	Q TmpMes
}

/// Creator:    bianshuai
/// CreateDate: 2020-04-08
/// Descript:   批量保存专家
/// InPut:      mdtIds-会诊ID串, mLocParams-科室列表
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCMDTConsult).InsLocParams(72,"","^李四^37^^")
ClassMethod InsLocParams(mdtIds As %String, mLocParams As %String, makOuterExp = "") As %String
{
	n (mdtIds, mLocParams,makOuterExp)

	s Err=0
	TS
	F i=1:1:$L(mdtIds,"^") Q:Err'=0  D
	.s ID=$p(mdtIds,"^",i) Q:ID=""
	.s Err=..InsItmLoc(ID, mLocParams,makOuterExp)  /// 修改专家组
	.
	i Err'=0 Tro
	Q:Err'=0 Err
	TC
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2020-04-29
/// Descript:   取备注
/// InPut:      mdtIds-会诊ID
/// OutPut:     
/// w ##Class(web.DHCMDTConsult).GetConNotes("")
ClassMethod GetConNotes(mdtID As %String) As %String
{
	n (mdtID)
	s Notes=$p(^DHCMDTCON(mdtID),"^",24)     /// 备注
	Q Notes
}

/// Creator:    bianshuai
/// CreateDate: 2020-06-28
/// Descritp:   取消申请
/// InPut:      CsID - 会诊ID, UserID - 用户, HospID - 用户ID
/// OutPut:     0-成功, 其他-失败
/// W ##Class(web.DHCMDTConsult).RevCsREQ("417||3")
ClassMethod RevCsREQ(CsID As %String, UserID As %String, HospID As %String) As %String
{
	n (CsID, UserID, HospID)
	
	s HasCenter=##Class(web.DHCMDTCom).GetEmSysConfig("HASCENTER",HospID)  //是否具有会诊中心
	s Err=0
	/// 申请状态
	Q:(HasCenter'=0)&('..GetIsModFlag(CsID,30)) "-1"
	Q:(HasCenter=0)&('..GetIsModFlag(CsID,20)) "-1"
	TS
	/// 修改状态
	s StatusID=..GetConsStatus(10)  /// 撤销状态ID
	s Err = ..InsMasStatus(CsID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 插入日志
	s Err = ..InsConsLog(CsID,UserID,StatusID,"")
	i Err'=0 tro
	Q:Err'=0 "-13"
	TC
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2020-06-28
/// Descritp:   是否允许取消申请单
/// InPut:      CsID - 会诊ID
/// OutPut:     0-允许,1-不允许
/// W ##Class(web.DHCMDTConsult).IsPermitCancel("417||3")
ClassMethod IsPermitCancel(mdtID As %String, HasCenter) As %String
{
	n (mdtID, HasCenter)
	s EpisodeID=$p(^DHCMDTCON(mdtID),"^",1)    /// 申请就诊ID
	s PatType=$p($g(^PAADM(EpisodeID)),"^",2)  /// 病人类型
	Q:(PatType="I")&(HasCenter=0) 0
	s BillId=$o(^DHCMDTORD(0,"IndexCst",mdtID,""))
	Q:BillId="" 0
	s Oeori=$p(^DHCMDTORD(BillId),"^",2)
	Q:Oeori="" 0
	s OrdBilled=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",5)
	Q:OrdBilled'="P" 0
	Q 1
}

/// Creator:    bianshuai
/// CreateDate: 2020-06-28
/// Descritp:   会诊医嘱是否执行
/// InPut:      CsID - 会诊ID
/// OutPut:     0-允许,1-不允许
/// W ##Class(web.DHCMDTConsult).IsExecOrder("417||3")
ClassMethod IsExecOrder(mdtID As %String) As %String
{
	n (mdtID)
	s BillId=$o(^DHCMDTORD(0,"IndexCst",mdtID,""))
	Q:BillId="" 0
	s Oeori=$p(^DHCMDTORD(BillId),"^",2)
	Q:Oeori="" 0
	s ord=+Oeori, itm=$p(Oeori,"||",2)
	s sub=$o(^OEORD(ord,"I",itm,"X",0))
	Q:sub="" 0
	s execStatusId=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",16) //执行状态
	Q:execStatusId="" 0
    Q:$p($g(^OEC("STAT",execStatusId)),"^",1)="F" 1
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2020-07-28
/// Descritp:   会诊签到
/// InPut：     
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCMDTConsult).ExeCsCOeori("92||1","114||77","E")
ClassMethod SignIn(itemId As %String, userID As %String, Flag As %String) As %String
{
	n (itemId, userID, Flag)
	s statusID=..GetConsStatus(70)  /// 签到
	i Flag="Y" D
	.s Err=..InsConsLog(itemId, userID, statusID, "签到")
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2020-06-28
/// Descritp:   驳回
/// InPut:      mdtID - 会诊ID
/// OutPut:     0-允许,1-不允许
/// W ##Class(web.DHCMDTConsult).InsRefReason("")
ClassMethod InsRefReason(mdtID As %String, refReason As %String, userID As %String) As %String
{
	n (mdtID, refReason, userID)
	s statusID=..GetConsStatus(5)  /// 驳回状态ID
	s IsValid = ##class(web.DHCMDTConsult).ValidStatus(mdtID,5)
	q:IsValid'=0 "-1^"_IsValid
	
	s Err=0
	
	TS
	
	/// 修改状态
	s Err = ..InsMasStatus(mdtID,statusID)
	i Err'=0 tro
	Q:Err'=0 "-12^修改状态异常!"
	
	/// 插入日志
	s Err = ..InsConsLog(mdtID,userID,statusID,"")
	i Err'=0 tro
	Q:Err'=0 "-13^插入日志错误!"
	
	/// 收回关联院外账号
	s Err = ..ClearAssUser(mdtID)
	i Err'=0 tro
	Q:Err'=0 "-14^取消外院专家关联账号失败!"
	TC
	Q 0
}

/// w ##Class(web.DHCMDTConsult).ClearAssUser("35")
ClassMethod ClearAssUser(mdtID)
{
	n (mdtID)
	q:'$d(^DHCMDTCOE(0,"ParRef",mdtID)) 0
	
	&SQL(UPDATE DHC_MDTConOuterExp SET MD_User_Dr=NUll WHERE MD_ParRef_Dr=:mdtID )
	q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-14
/// Descritp:   Insert病历授权表
/// InPut：     mListData - 病历信息串
/// OutPut：    0-成功; 其他-不成功
/// w ##Class(web.DHCMDTConsult).InsEmrAutMasAll("1^18^10209^72^1")
ClassMethod InsEmrAutMasAll(Params As %String) As %String
{
	n (Params)
	
	s EpisodeID = $p(Params,"^",1)
	s CstID = $p(Params,"^",2)
	s LgUserID = $p(Params,"^",3)	
	s AffTime = $p(Params,"^",4)
	s TakOrd = $p(Params,"^",5)
	s Err = 0
	TS
	
	s CH=""
	F  s CH=$o(^DHCMDTCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.s CstItmID = CstID_"||"_CH
	.s LocID=$p(^DHCMDTCON(CstID,"I",CH),"^",1)          /// 科室ID
	.s User=""
	.s CareProvID = $p(^DHCMDTCON(CstID,"I",CH),"^",3)
	.s:CareProvID="" CareProvID=$p(^DHCMDTCON(CstID,"I",CH),"^",2)     /// 医生
	.s:CareProvID'="" User=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
	.s:LocID="" Err="1" //hxy 2020-03-05 院际会诊不需开授权
	.q:LocID=""
	.s mListData = EpisodeID_"^"_CstItmID_"^"_LgUserID_"^"_LocID_"^"_User_"^"_AffTime_"^"_TakOrd
	.s Err=##Class(web.DHCMDTConsult).InsEmrAutMasNoAff(mListData)
	tro:Err'=0 
	q:Err'=0 Err
	
	TC
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-14
/// Descritp:   Insert病历授权表
/// InPut：     mListData - 病历信息串
/// OutPut：    0-成功; 其他-不成功
/// w ##Class(web.DHCEMConsult).InvEmrAutMas("1^27||1^10209^124^10485^2")
ClassMethod InvEmrAutMas(mListData As %String) As %String
{
	n (mListData)
	s Err=0
	TS
	
	s Len=$L(mListData,"#")
	F i=1:1:Len Q:Err'=0  D
	.s ListData=$p(mListData,"#",i)
	.s Err=..InsEmrAutMasNoAff(ListData)
	.
	i Err'=0 tro
	Q:Err'=0 Err
	
	TC
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-14
/// Descritp:   Insert病历授权表
/// InPut：     mListData - 病历信息串
/// OutPut：    0-成功; 其他-不成功
/// w ##Class(web.DHCMDTConsult).InsEmrAutMasNoAff("108^157||1^10209^^^2^1")
ClassMethod InsEmrAutMasNoAff(mListData As %String) As %String
{
	n (mListData)
	s TakOrd=$p(mListData,"^",7)   ///授权类型1:病历，2:医嘱
	s Err = 0
	
	/// 保存病历授权记录
	s Err=..InsEmrAut(mListData)
	Q:Err'=0 Err

	/// 调用病历授权接口
	s:TakOrd=1 Err=..InvEmrAut(mListData)
	Q:Err'=0 Err

	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-14
/// Descritp:   关闭病历授权
/// InPut：     mListData - 病历信息串
/// OutPut：    0-成功; 其他-不成功
/// w ##Class(web.DHCMDTConsult).ClsCstEmrAut("67","148||1","2")
ClassMethod ClsCstEmrAut(EpisodeID As %String, itmID As %String, TakType = "") As %String
{
	n (EpisodeID, itmID,TakType)
	s Err=0
	TS
	/// 关闭病历授权
	s ID=..GetEmrAutID(itmID,TakType)
	i ID'="" s Err=##Class(web.DHCMDTConsult).UpdCstEmrAut(ID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 调用电子病历接口
	s:TakType=1 Err=##Class(web.DHCEMConsInterface).CloseEmrAuth(EpisodeID, itmID)
	s:TakType'=1 Err=1
	i Err'=1 tro
	Q:Err'=1 "-12"
	
	TC
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-14
/// Descritp:   关闭病历授权
/// InPut：     mListData - 病历信息串
/// OutPut：    0-成功; 其他-不成功
/// w ##Class(web.DHCMDTConsult).ClsCstEmrAutMas("1","27||1")
ClassMethod ClsCstEmrAutMas(mListData As %String) As %String
{
	n (mListData)
	s Err=0
	TS
	
	s Len=$L(mListData,"#")
	F i=1:1:Len Q:Err'=0  D
	.s ListData=$p(mListData,"#",i)
	.s EpisodeID=$p(ListData,"^",1)
	.s itmID=$p(ListData,"^",2)
	.s TakType=$p(ListData,"^",3)
	.s Err=..ClsCstEmrAut(EpisodeID, itmID,TakType)
	.
	i Err'=0 tro
	Q:Err'=0 Err
	
	TC
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-14
/// Descritp:   关闭病历授权
/// InPut：     mListData - 病历信息串
/// OutPut：    0-成功; 其他-不成功
/// w ##Class(web.DHCMDTConsult).UpdCstEmrAut("114||92")
ClassMethod UpdCstEmrAut(ID As %String) As %String
{
	n (ID)
	s EndDate=+$H   		          /// 结束日期
	s EndTime=$p($H,",",2)            /// 结束时间
	&SQL(Update DHC_MDTConsEmrAut Set MC_EndDate=:EndDate, MC_EndTime=:EndTime where MC_RowID=:ID)
	Q SQLCODE
}

/// Descritp: 返回指定会诊子项对应的可用的授权项ID
/// Input:itmID:会诊ID,TakType(1:病历,2:医嘱)
/// w ##Class(web.DHCMDTConsult).GetEmrAutID("148||1",1)
ClassMethod GetEmrAutID(itmID As %String, TakType = "") As %String
{
	n (itmID,TakType)
	s ID="",TmpID=""
	F  s ID=$o(^DHCMDTCEA(0,"Cst",itmID,ID)) Q:(ID="")||(TmpID'="")  D
	.s HasTakType = $p(^DHCMDTCEA(ID),"^",10)
	.q:(TakType'="")&&(TakType'=HasTakType)
	.s EndDate=$p(^DHCMDTCEA(ID),"^",7)
	.Q:EndDate<+$H
	.s EndTime=$p(^DHCMDTCEA(ID),"^",8)
	.Q:(EndDate=+$H)&(EndTime<=$p($H,",",2))
	.s TmpID=ID
	Q TmpID
}

/// Descritp: 返回指定会诊子项对应的可用的授权项ID
/// Input:itmID:会诊ID,TakType(1:病历,2:医嘱)
/// w ##Class(web.DHCMDTConsult).GetEmrAutIDByLoc("12","95")
ClassMethod GetEmrAutIDByLoc(CstID As %String, LgCtLocID As %String, TakType = "") As %String
{
	n (CstID,LgCtLocID,TakType)
	s CH="",EmrAutID="",TmpID="" 
	F  s CH=$o(^DHCMDTCON(CstID,"I",CH)) Q:CH=""  D
	.s CstItmID = CstID_"||"_CH
	.s LocID=$p(^DHCMDTCON(CstID,"I",CH),"^",1)          /// 科室ID
	.q:LocID'=LgCtLocID
	.s EmrAutID=CstItmID
	q:EmrAutID="" ""
	s TmpID=..GetEmrAutID(EmrAutID)
	Q TmpID
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-14
/// Descritp:   插入病历授权表
/// InPut：     mListData - 病历信息串
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMConsult).InsEmrAut("114||92","234")
ClassMethod InsEmrAut(mListData As %String) As %String
{
	n (mListData)
	s itmID=$p(mListData,"^",2)       /// itmID
	s UserID=$p(mListData,"^",3)      /// 授权人
	s DeptID=$p(mListData,"^",4)      /// 权限授予科室
	s mUserID=$p(mListData,"^",5)     /// 权限授予医生
	s Hours=+$p(mListData,"^",6)      /// 授权时间
	s TakOrd=$p(mListData,"^",7)      /// 权限类型 1:病历，2:医嘱
	s StartDate=+$H   		          /// 开始日期
	s StartTime=$p($H,",",2)          /// 开始时间
	s EndDate=+$H + $p((Hours/24),".") /// 结束日期
	s EndTime=$p($H,",",2)+((Hours#24)*3600) /// 结束时间
	i EndTime > 86400 D
	.s EndDate=EndDate+1
	.s EndTime=EndTime - 86400
	&SQL(Insert Into DHC_MDTConsEmrAut(MC_Cst_Ref,MC_User_Dr,MC_Loc_Dr,MC_Doc_Dr,MC_StartDate,MC_StartTime,MC_EndDate,MC_EndTime,MC_TakTime,MC_TakOrd)
		values(:itmID,:UserID,:DeptID,:mUserID,:StartDate,:StartTime,:EndDate,:EndTime,:Hours,:TakOrd))
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-14
/// Descritp:   调用病历授权接口
/// InPut：     mListData - 病历信息串
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMConsult).InvEmrAut("114||92","234")
ClassMethod InvEmrAut(mListData As %String) As %String
{
	n (mListData)
	s EpisodeID=$p(mListData,"^",1)   /// 就诊ID
	s itmID=$p(mListData,"^",2)       /// itmID
	s mUserID=$p(mListData,"^",3)     /// 授权人
	s DeptID=$p(mListData,"^",4)      /// 权限授予科室
	s UserID=$p(mListData,"^",5)      /// 权限授予医生
	s LimTime=$p(mListData,"^",6)     /// 授权时间
	s Err=##Class(web.DHCMDTInterface).OpenEmrAuth(EpisodeID, itmID, mUserID, DeptID, UserID, LimTime)
	Q:+Err=1 0
	Q:+Err=0 "-2"
	Q Err
}

/// Descript:   取当前最大工号
ClassMethod GetCurMaxCode(Prefix As %String, NoLen As %String) As %String
{
	N (Prefix,NoLen)
	S NextNo=""
	L +^DHCMDT("UserCode",Prefix):10 E  Q -100
	S PreLen=$L(Prefix)
	S MinSuffix=1
	F i=1:1:NoLen-1 S MinSuffix="0"_MinSuffix
	S MinNo=Prefix_MinSuffix	//最小码
	S CurLen=PreLen+NoLen	    //单号长度
	///表里记录的最大码
	S CurrMaxNo=..GetMaxCodeByCode(Prefix)
	S CurPrefix=$E(CurrMaxNo,1,PreLen)
	S CurrNo=$E(CurrMaxNo,PreLen+1,CurLen)

	i Prefix'=CurPrefix D
	.S NextNo=MinNo
	.L -^DHCMDT("UserCode",Prefix)
	Q:NextNo'="" NextNo

	S Suffix=CurrNo+1
	
	S slen=$L(Suffix)
	S flen=NoLen-slen
	F i=1:1:flen S Suffix="0"_Suffix
	S NextNo=Prefix_Suffix
	L -^DHCMDT("UserCode",Prefix)
	Q NextNo
}

/// Descript: 获取当前最大码
ClassMethod GetMaxCodeByCode(Prefix As %String) As %String
{
	n (Prefix)
	Q:Prefix="" ""
	S adrrcode=""
	&sql(select max(MD_Code) into :adrrcode from DHC_MDTOuterExpert Where MD_Code %STARTSWITH %ALPHAUP :Prefix)
	Q adrrcode
}

ClassMethod DeleteOuterExpert(ID)
{
	n (ID)
	&sql(DELETE DHC_MDTOuterExpert WHERE MD_RowID=:ID)
	Q SQLCODE
}

ClassMethod DeleteOuterExp(ID)
{
	n (ID)
	&sql(DELETE DHC_MDTConOuterExp WHERE MD_RowID=:ID)
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2020-04-08
/// Descript:   是否存在指定科室专家
/// InPut:      mdtIds-会诊ID串, mLocParams-科室列表
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCMDTConsult).IsExistLoc("25^24^23^22^20")
ClassMethod isExistLoc(ID As %String, mCareProvID As %String) As %String
{
	n (ID, mCareProvID)

	s Err=0
	s CH=""
	F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.Q:mCareProvID'=$p(^DHCMDTCON(ID,"I",CH),"^",2)
	.s Err=1
	.
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2021-02-19
/// Descript:   预约地点占用情况
/// InPut:      mdtPreData-预约日期, mdtPreTime-预约时段, itemAddr-地点
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCMDTConsult).GetItemOcc("30/06/2021","08:30-11:00","三楼会议室")
ClassMethod GetItemOcc(mdtPreData As %String, mdtPreTime As %String, itemAddr As %String) As %String
{
	n (mdtPreData, mdtPreTime, itemAddr)
	s mdtPreData=##class(web.DHCMDTCom).DateHtmlToLogical(mdtPreData)
	s Err=0, mdtDisGroup=""
	s ID=""
	F  s ID=$o(^DHCMDTCON(0,"NDate",mdtPreData,ID)) Q:ID=""  D
	.s CstStatusID=$p(^DHCMDTCON(ID),"^",12)     /// 状态ID
	.q:+CstStatusID=0
	.s CstStatusCode=$p(^DHCMDTS(CstStatusID),"^",1)
	.q:CstStatusCode<30  	;安排状态之前
	.Q:$p(^DHCMDTCON(ID),"^",10)'=itemAddr     /// 会诊地点
	.s mdtMakResID=$p(^DHCMDTCON(ID),"^",18)   /// 预约资源ID
	.s PreTime=##Class(web.DHCMDTCom).JsMakResPreTime(mdtMakResID)  /// 预约时间
	.s PreDate=$p(PreTime," "), PreTime=$p(PreTime," ",2)
	.Q:PreTime'=mdtPreTime
	.s DisGrpID=$p(^DHCMDTCON(ID),"^",16)      /// 疑难病种
	.s mdtDisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	.
	i mdtDisGroup'="" s Msg=""""_mdtDisGroup_"会诊""占用"
	E  s Msg="未占用"
	Q Msg
}

/// Creator:    bianshuai
/// CreateDate: 2021-04-12
/// Descritp:   修改会诊状态
/// InPut:      CsID - 会诊ID, UserID - 用户, sCode - 状态
/// OutPut:     0-成功, 其他-失败
/// W ##Class(web.DHCMDTConsult).modConsultStatus("417||3")
ClassMethod modConsultStatus(CstID As %String, userID As %String, stCodes As %String, WriType As %String) As %String
{
	n (CstID, userID, stCodes, WriType)
	
	s Err=0
	
	/// 申请状态
	;Q:('..GetIsTakOperFlag(CstID,stCodes)) "-1"
	
	s stCode=$s(WriType="P":"35",WriType="E":"75",1:"") /// 操作类型
	q:stCode="" "-1^状态code获取失败"
	s IsValid=##class(web.DHCMDTConsult).ValidStatus(CstID,stCode)
	q:IsValid'=0 "-2^"_IsValid
	ts
	/// 修改状态
	s statusID=..GetConsStatus(stCode)
	s Err = ..InsMasStatus(CstID,statusID)
	i Err'=0 tro
	q:Err'=0 "-12^修改状态失败!"
	
	/// 插入日志
	s Err = ..InsConsLog(CstID,userID,statusID,"")
	i Err'=0 tro
	q:Err'=0 "-13^插入日志表异常!"
	
	s Err=##Class(EMRservice.HISInterface.Event.MDTConsult).CancelCompletion(CstID)
	i Err'=1 tro
	q:Err'=1 "-14^将电子病历会诊记录状态改为取消完成失败!"
	
	/// 撤销执行会诊医嘱
	s Err = ..ExeCsCOeori(CstID,userID,"C")
	i Err'=0 tro
	Q:Err'=0 "-15^执行会诊医嘱失败!"
	
	tc
	
	Q 0
}

/// Descript:   安排 - 修改会诊资源,安排使用
/// w ##Class(web.DHCMDTConsult).InsMakResss("48","93^1009^1^@94^1^1^@94^135^2^","22^对对对^10^6^@23^屈年鹏^15^2^")
ClassMethod InsMakResss(CstID As %String, makLocParams As %String, makOuterExp As %String) As %String
{
	n (CstID, makLocParams, makOuterExp)
	
	s Err=0
#;	s StatusID=..GetConsStatus(30)   	   /// 发送
	/// 申请状态
	//Q:('..GetIsModFlag(CstID,20)) "-1"
	TS
	
#;	/// 修改状态
#;	s Err = ..InsMasStatus(CstID,StatusID)
#;	i Err'=0 tro
#;	Q:Err'=0 "-11"
	
	/// 删除相关字表内容重新插入
	s Err=..DelCstMasSubTable(CstID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	b ////BBBB
	/// 修改专家组
	s Err=..InsConItm(CstID, makLocParams)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 外院专家
	s Err=..InsOuterExpert(CstID, makOuterExp)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	TC
	Q Err
}

/// 验证能否进行当前状态改变
/// w ##class(web.DHCMDTConsult).ValidStatus(41,50)
ClassMethod ValidStatus(ID, ToStatusIdCode)
{
	n (ID,ToStatusIdCode)
	s StatusID=..GetConsStatus(ToStatusIdCode) 
	q:+StatusID="" "获取改变状态字典Id异常"
	s Status=$p(^DHCMDTS(StatusID),"^",2)
	
	s NowStatusId=$p(^DHCMDTCON(ID),"^",12)
	q:(ToStatusIdCode=10)&&(+NowStatusId=0) 0	;未发送的会诊允许取消
	s MustStatusId=$p(^DHCMDTS(StatusID),"^",5)
	q:MustStatusId="" 0
	q:(","_MustStatusId_",")'[(","_NowStatusId_",") "非"_##class(web.DHCMDTConsStatus).GetSupState(MustStatusId)_"状态,不允许"_Status
	q 0
}

/// Descript:修改专家使用
/// 
ClassMethod DeletConsItm(CstItmID)
{
	n (CstItmID)
	s IsConssignIn =##class(web.DHCMDTCom).UserIsConssignIn(CstItmID)
	q:IsConssignIn "已经签到,无法删除!"
	
	s Err=##class(web.DHCMDTConsult).RemoveCstItm(CstItmID)
	q:Err'=0 "删除会诊子记录失败,Code:"_Err
	q 0
}

/// Descript:当前专家是否会诊完成专家
/// w ##class(web.DHCMDTConsult).IsCompUser(41,50)
ClassMethod IsCompUser(CstID, UserID)
{
	n (CstID,UserID)
	s Ret=0
	s LgNode=##Class(web.DHCMDTCom).GetCsNodeTime(CstID,"80") 
	s CstCUserID=$p(LgNode,"^",1)   	/// 完成医师
	s:UserID=CstCUserID Ret=1
	s CompUser=$p(LgNode,"^",2)
	q Ret_"^"_CompUser
}

/// Descript:默认值获取
/// w ##class(web.DHCMDTConsult).AllParams("")
ClassMethod AllParams(EpisodeID)
{
	n (EpisodeID)
	
	s PatientID = $p(^PAADM(EpisodeID),"^",1)
	s CalculateGroupId = ##class(web.DHCMDTPreconditions).check(EpisodeID)
	q CalculateGroupId
}

/// w ##class(web.DHCMDTConsult).SendVcUrl(40,"")
ClassMethod SendVcUrl(MdtID, LgParams)
{
	n (MdtID,LgParams)
	
	;新接口
	q ##class(web.DHCMDTConsult).SendVcUrlNew(MdtID,2)
	
	s EpisodeID = $p(^DHCMDTCON(+MdtID),"^",1) 
	s AdmDate=$P($G(^PAADM(EpisodeID)),"^",6)
	s AdmTime=$P($G(^PAADM(EpisodeID)),"^",7)
	s:AdmDate'="" AdmDate=$zd(AdmDate,3)
	s:AdmTime'="" AdmTime=$zt(AdmTime,2)
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s CstRUserID=$p(^DHCMDTCON(MdtID),"^",5)  /// 申请医生
	s CstRUser=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	s CH="",Err=0
	f  s CH=$o(^DHCMDTCON(MdtID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.s CareProvID=$p(^DHCMDTCON(MdtID,"I",CH),"^",2)     /// 医生
	.i +CareProvID=0 s CareProvID=$p(^DHCMDTCON(MdtID,"I",CH),"^",3) 
	.q:CareProvID=""
	.s CsLocID=$p(^DHCMDTCON(MdtID,"I",CH),"^",1)       /// 会诊科室
	.s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	.s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	.s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.q:CsUserID=""
	.s UserCode=$p(^SSU("SSUSR",CsUserID),"^",1)
	.s PhoneNo=$p(^SSU("SSUSR",CsUserID),"^",99)
	.q:PhoneNo=""
	.b ;errqqq
	.s Data=UserCode_"^"_CstRUser_"^"_PhoneNo_"^"_CsUser_"^"_CsLocDesc_"^"_AdmDate_"^"_AdmTime_"^"_PatName_"^"_MdtID
	.d ##class(web.DHCMDTExternalServices).CallInterface(Data)
	.;s Ret=##class(websys.DHCMessageInterface).Send("")
	
	Q Err
}

/// Input：	MdtID 会诊ID
/// 		Type 1:缴费通知,2:开启视频通知
/// w ##class(web.DHCMDTConsult).SendVcUrlNew(40,1)
ClassMethod SendVcUrlNew(MdtID, Type = "1")
{
	n (MdtID,Type)
	
	s EpisodeID = $p(^DHCMDTCON(+MdtID),"^",1) 
	s AdmDate=$P($G(^PAADM(EpisodeID)),"^",6)
	s AdmTime=$P($G(^PAADM(EpisodeID)),"^",7)
	s:AdmDate'="" AdmDate=$zd(AdmDate,3)
	s:AdmTime'="" AdmTime=$zt(AdmTime,2)
	s AppScDr = $p(^DHCMDTCON(MdtID),"^",18)   /// 资源表ID
	s PreDateTime=##Class(web.DHCMDTCom).JsMakResPreTime(AppScDr) /// 预约时间
	s PreDate=$p(PreDateTime," ",1)
	s PreTime=$p(PreDateTime," ",2)
	
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s CstRUserID=$p(^DHCMDTCON(MdtID),"^",5)  /// 申请医生
	s CstRUserCode=$p($g(^SSU("SSUSR",CstRUserID)),"^",1)
	s CstRUser=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	s Err=0
	
	;院内专家
	s CH=""
	f  s CH=$o(^DHCMDTCON(MdtID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.s CareProvID=$p(^DHCMDTCON(MdtID,"I",CH),"^",2)     /// 医生
	.i +CareProvID=0 s CareProvID=$p(^DHCMDTCON(MdtID,"I",CH),"^",3) 
	.q:CareProvID=""
	.s CsLocID=$p(^DHCMDTCON(MdtID,"I",CH),"^",1)     /// 会诊科室
	.s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)     /// 会诊医生
	.s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	.s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.q:CsUserID=""
	.s UserCode=$p(^SSU("SSUSR",CsUserID),"^",1)
	.s PhoneNo=$p(^SSU("SSUSR",CsUserID),"^",99)
	.q:PhoneNo=""
	.s DocType=0
	.s Data=CstRUserCode_"^"_CstRUser_"^"_PhoneNo_"^"_CsUser_"^"_CsLocDesc_"^"_AdmDate_"^"_AdmTime_"^"_PatName_"^"_MdtID_"^"_PreDate_"^"_PreTime_"^"_DocType
	.s Data=Data_"^"_UserCode
	.d:Type=1 ##class(web.DHCMDTExternalServices).CallMdtPatPayMoney(Data)
	.d:Type=2 ##class(web.DHCMDTExternalServices).CallDocOpenMeet(Data)
	
	;外院专家
	s CsExpID="0"
	f  s CsExpID=$o(^DHCMDTCOE(0,"ParRef",MdtID,CsExpID)) Q:CsExpID=""  D
	.s UserID=$p(^DHCMDTCOE(CsExpID),"^",2)
	.s CsUserID=$p(^DHCMDTCOE(CsExpID),"^",4)
	.q:UserID=""
	.q:'$d(^DHCMDTOUTEXP(UserID))
	.s CsUser=$p(^DHCMDTOUTEXP(UserID),"^",2)   /// 姓名
	.s PrvTpID=$p(^DHCMDTOUTEXP(UserID),"^",4)    /// 职称
	.s PrvTp=$p($g(^CT("CPT",+PrvTpID)),"^",2)
	.s CsLocID=$p(^DHCMDTOUTEXP(UserID),"^",6)      /// 科室ID
	.s CsLocDesc=$p($g(^DHCMDTDI(+CsLocID)),"^",2)
	.s PhoneNo=$p(^DHCMDTOUTEXP(UserID),"^",7)   /// 电话
	.q:PhoneNo=""
	.s ParID=$p($g(^DHCMDTDI(+CsLocID)),"^",6)      /// 外院
	.q:ParID=""
	.s HospDesc=$p(^DHCMDTDI(ParID),"^",2)        /// 外院	
	.s UserCode=$p(^SSU("SSUSR",+CsUserID),"^",1)
	.s DocType=1
	.s Data=CstRUserCode_"^"_CstRUser_"^"_PhoneNo_"^"_CsUser_"^"_CsLocDesc_"^"_AdmDate_"^"_AdmTime_"^"_PatName_"^"_MdtID_"^"_PreDate_"^"_PreTime_"^"_DocType
	.s Data=Data_"^"_UserCode
	.d:Type=1 ##class(web.DHCMDTExternalServices).CallMdtPatPayMoney(Data)
	.d:Type=2 ##class(web.DHCMDTExternalServices).CallDocOpenMeet(Data)
	
	Q Err
}

/// Descript:修改会诊意见
/// Other: w ##class(web.DHCMDTConsult).UpdConItmOpionUserCode("5","ys02","讨论")
ClassMethod UpdConItmOpionUserCode(MdtID, UserCode, MdtOpinion)
{
	n (MdtID,UserCode,MdtOpinion)
	q:UserCode="" 0
	s SSUSRRowId = $o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
	q:SSUSRRowId="" "code"_UserCode_"未找到关联的用户"
	s CstItmId=..GetCstItmIdByUser(MdtID,SSUSRRowId)
	q:CstItmId="" "此人未在会诊专家队列中!"
	s Ret=##class(web.DHCMDTConsult).UpdConItmOpion(CstItmId,MdtOpinion)
	q Ret
}

/// w ##class(web.DHCMDTConsult).GetCstItmIdByUserCode("5","ys0")
ClassMethod GetCstItmIdByUserCode(ID, UserCode)
{
	n (ID,UserCode)
	q:UserCode="" 0
	s UserID = $o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
	q:UserID="" "code"_UserCode_"未找到关联的用户!"
	s RetItmId=##class(web.DHCMDTConsult).GetCstItmIdByUser(ID,UserID)
	q:RetItmId="" "此会诊无此会诊专家!"
	q 0_"^"_RetItmId
}

/// w ##class(web.DHCMDTConsult).GetCstItmIdByUser("5","12176")
ClassMethod GetCstItmIdByUser(ID, UserId)
{
	n (ID,UserId)
	s RetItmId=""
	s CH=""
	F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:(CH="")||(RetItmId'="")  D
	.s CareProv=""
	.s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",2)     /// 医生
	.s:CareProvID'="" CareProv=$p($g(^CTPCP(CareProvID,1)),"^",2)
	.s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.q:UserId'=CsUserID
	.s RetItmId=ID_"||"_CH
	q RetItmId
}

/// 院外专家关联一个账号
/// w ##class(web.DHCMDTConsult).freeUser()
ClassMethod freeUser()
{
	k TMPData("code")
	f i=1:1:100 d
	.i i<10 s no="0"_i
	.e  s no=i
	.s TMPData("code","WYZJ"_no)=""
	
	
	s ret=""
	s code=""
	f  s code = $o(TMPData("code",code)) q:(code="")||(ret'="")  d
	.s userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",code,""))
	.q:+userId=0
	.q:$d(^DHCMDTCOE(0,"User",userId))	;已经使用的不再返回
	.s ret = userId
	q ret
}

}
