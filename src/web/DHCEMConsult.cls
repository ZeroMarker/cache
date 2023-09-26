Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2018-01-22
/// Descript: 		会诊申请业务类
Class web.DHCEMConsult Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descritp:  插入会诊申请内容
/// Input:     mListData-会诊申请内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMConsult).Insert("14","")
ClassMethod Insert(CstID As %String, mListData As %String, OtherParams = "", LgParams = "") As %String
{
	n (CstID, mListData,OtherParams,LgParams)
	/// 申请状态
	i CstID'="" Q:$p(^DHCEMCON(CstID),"^",18)'="" "-1"
	i CstID="" D
	.s CstID=..InsConsult(mListData,OtherParams,LgParams)
	E  D
	.s CstID=..UpdConsult(CstID, mListData)
	Q CstID
}

/// Descritp:  插入会诊申请内容
/// Input:     mListData-会诊申请内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMConsult).InsertCytExn("")
ClassMethod InsConsult(mListData As %String, OtherParams = "", LgParams = "") As %String
{
	N (mListData,OtherParams,LgParams)
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
	
	/// 亚专业指征
	s ListData=$p(mListData,$C(2),3)
	s Err=..InsConInd(CstID, ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/*
	/// 插入医嘱
	s Err = ..InsConOeori(PisID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	*/

	TC
	
	d ##Class(web.DHCEMConsult).OtherInterface(CstID,mListData,OtherParams,LgParams)
	
	Q CstID
}

ClassMethod OtherInterface(CstID, MListData, OtherParams = "", LgParams = "")
{
	n (CstID,MListData,OtherParams,LgParams)
	i OtherParams'="" d
	.d ##Class(web.DHCEMConsult).UpdateBGHandleRec(CstID,MListData,OtherParams,LgParams)
}

/// ;qqa 04-23 修改血糖开关联医嘱
/// ;d #Class(web.DHCEMConsult).UpdateBGHandleRec("54431647","54431647||20/54431647||21","2021-04-19","102866")
ClassMethod UpdateBGHandleRec(CstID, MListData, OtherParams, LgParams)
{
	n (CstID, MListData, OtherParams, LgParams)
	s ListData=$p(MListData,$C(2))
	s EpisodeID=$p(ListData,"^",1)      ///EpisodeID
	s ObsId=$p(OtherParams,"^",1)
	s ObsDate=$p(OtherParams,"^",2)
	s LgUser=$p(LgParams,"^",4)
	s LgHospId=$p(LgParams,"^",1)
	s LgLocId=$p(LgParams,"^",2)
	s Ret=##class(Nur.NIS.Service.VitalSign.BloodGlucoseV2).AddOrUpdateBGHandleRec(EpisodeID,ObsId,ObsDate,CstID,2,"",LgUser,LgLocId,LgHospId)	
	q Ret
}

/// Descritp:  更新会诊申请内容
/// Input:     mListData-会诊申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMConsult).UpdConsult("")
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
	
	/// 亚专业指征
	s ListData=$p(mListData,$C(2),3)
	s Err=..InsConInd(CstID, ListData)
	i Err'=0 tro
	Q:Err'=0 "-13"

	TC
	Q CstID
}

/// Descritp:  插入会诊主表
ClassMethod InsConMaster(mListData As %String) As %String
{
	n (mListData)
	s ListData=$p(mListData,$C(2))
	//s PisNo=##Class(web.DHCAPPExaReport).GetCurMaxNo("CON"_$zd(+$H,8),"5")  ///单号
	s EpisodeID=$p(ListData,"^",1)      ///EpisodeID
	s CsRUserID=$p(ListData,"^",2)      ///申请医生
	s CsRLocID=$p(ListData,"^",3)       ///申请科室
	s CsTrePro=$p(ListData,"^",4)       ///病情及诊疗经过
	s CsPurpose=$p(ListData,"^",5)      ///会诊的理由和目的
	s CsCategory=$p(ListData,"^",6)     ///会诊类别
	s CsNPlace=$p(ListData,"^",7) 		///会诊地点
	s CsType=$p(ListData,"^",8)  	    ///会诊类型
	s CsDocLev="" 					    ///医生级别
	s CsNDate=$p(ListData,"^",9)        ///会诊日期
	i CsNDate'="" s CsNDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(CsNDate)
	s CsNTime=$p(ListData,"^",10)       ///会诊时间
	s:CsNTime'="" CsNTime=$zth(CsNTime,1)
	s CsRStatus=""                      ///申请状态
	s CsEmFlag=$p(ListData,"^",11)      ///是否加急
	s CsOutFlag=$p(ListData,"^",12)     ///是否外院
	s CsUnit=$p(ListData,"^",13)		///外院名称
	s CsDocName=$p(ListData,"^",14)	    ///外院医师
	s CsRemark=$p(ListData,"^",15)	    ///备注
	s CsUser=$p(ListData,"^",16)	    ///联系人
	s CsPhone=$p(ListData,"^",17)	    ///联系电话
	s ShareFlag=""					    ///是否共享
	s MoreFlag=$p(ListData,"^",19)	    ///是否多科
	s CsPropID=$p(ListData,"^",20)	    ///会诊性质
	s CsRDate=+$H   		            ///申请日期
	s CsRTime=$p($H,",",2)              ///申请时间
	s NTimeDiff="" //hxy 2021-05-10 st 会诊时间不能早于当前时间
	s:(CsNTime'="")&&(CsNDate=(+$H)) NTimeDiff=$SYSTEM.SQL.DATEDIFF("ss",CsRDate_","_CsRTime,CsNDate_","_CsNTime)
	q:NTimeDiff<0 "-20" //ed
	&SQL(Insert Into DHC_EmConsult(EC_Adm_Dr,EC_RLoc_Dr,EC_RDate,EC_RTime,EC_RUser_Dr,EC_TrePro,EC_Purpose,EC_Category,EC_DocLev,EC_NDate,EC_NTime,EC_NPlace,EC_RStatus,EC_Type,EC_EmFlag,EC_OutFlag,EC_Unit,EC_DocName,EC_Remark,EC_ConsUser,EC_ConsPhone,EC_ShareFlag,EC_MoreDepFlag,EC_Nat_Dr)
		values(:EpisodeID,:CsRLocID,:CsRDate,:CsRTime,:CsRUserID,:CsTrePro,:CsPurpose,:CsCategory,:CsDocLev,:CsNDate,:CsNTime,:CsNPlace,:CsRStatus,:CsType,:CsEmFlag,:CsOutFlag,:CsUnit,:CsDocName,:CsRemark,:CsUser,:CsPhone,:ShareFlag,:MoreFlag,:CsPropID))
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
	s CsCategory=$p(ListData,"^",6)	  ///会诊类别
	s CsNPlace=$p(ListData,"^",7) 	  ///会诊地点
	s CsType=$p(ListData,"^",8)  	  ///会诊类型
	s CsDocLev=""                     ///医生级别
	s CsNDate=$p(ListData,"^",9)      ///会诊日期
	s CsNDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(CsNDate)
	s CsNTime=$p(ListData,"^",10)     ///会诊时间
	s:CsNTime'="" CsNTime=$zth(CsNTime,1)
	s NTimeDiff="" //hxy 2021-05-10 st 会诊时间不能早于当前时间
	s:(CsNTime'="")&&(CsNDate=(+$H)) NTimeDiff=$SYSTEM.SQL.DATEDIFF("ss",$H,CsNDate_","_CsNTime)
	q:NTimeDiff<0 "-20" //ed
	s CsEmFlag=$p(ListData,"^",11)    ///是否加急
	s CsOutFlag=$p(ListData,"^",12)   ///是否外院
	s CsUnit=$p(ListData,"^",13)	  ///外院名称
	s CsDocName=$p(ListData,"^",14)	  ///外院医师
	s CsRemark=$p(ListData,"^",15)	  ///备注
	s CsUser=$p(ListData,"^",16)	  ///联系人
	s CsPhone=$p(ListData,"^",17)	  ///联系电话
	s ShareFlag=$p(ListData,"^",18)	  ///是否共享
	s MoreFlag=$p(ListData,"^",19)	  ///是否多科
	s CsPropID=$p(ListData,"^",20)	  ///会诊性质
	&SQL(Update DHC_EmConsult Set EC_TrePro=:CsTrePro,EC_Purpose=:CsPurpose,EC_Category=:CsCategory,EC_DocLev=:CsDocLev,
		EC_NDate=:CsNDate,EC_NTime=:CsNTime,EC_NPlace=:CsNPlace,EC_ShareFlag=:ShareFlag,EC_MoreDepFlag=:MoreFlag,EC_ConsUser=:CsUser,EC_ConsPhone=:CsPhone,
		EC_EmFlag=:CsEmFlag,EC_OutFlag=:CsOutFlag,EC_Unit=:CsUnit,EC_DocName=:CsDocName,EC_Remark=:CsRemark,EC_Nat_Dr=:CsPropID Where EC_RowID=:CstID)
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
	.s CstGrpID=$p(ListData,"^",5)     /// 会诊小组
	.s arChildSub=$o(^DHCEMCON(arParref,"I",""),-1)+1
	.
	.&SQL(Insert Into DHC_EmConsultItm(EC_ParRef_Dr,EC_ChildSub,EC_CLoc_Dr,EC_NDoc_Dr,EC_PrvTp_Dr,EC_SubMar_Dr,EC_Grp_Dr)
		values(:arParref,:arChildSub,:CstCLocID,:CstNDocID,:PrvTpID,:SubMarID,:CstGrpID))
	.i SQLCODE'=0 s quitflag="1"
	Q quitflag
}

/// Descritp:  插入会诊指征
ClassMethod InsConInd(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s Len = $L(mListData,"@")
	s quitflag=0
	F i=1:1:Len Q:quitflag'="0"  D
	.s itmID=$p(mListData,"@",i)    /// 亚专业指征
	.Q:itmID=""
	.
	.&SQL(Insert Into DHC_EmConsultInd(EC_ParRef_Dr,EC_IndItm_Dr)values(:arParref,:itmID))
	.i SQLCODE'=0 s quitflag="1"
	.
	Q quitflag
}

/// Descript: 删除会诊申请子表和关联表数据
/// w ##Class(web.DHCEMConsult).DelCstMasSubTable("24")
ClassMethod DelCstMasSubTable(CstID) As %String
{
	n (CstID)
	s SQLCODE=0
	
	///  会诊子表
	i $o(^DHCEMCON(CstID,"I","")) D
	.&SQL(delete from DHC_EmConsultItm where EC_ParRef_Dr=:CstID)
	Q:SQLCODE'=0 SQLCODE
	
	///  会诊指征
	i $o(^DHCEMCONI(0,"ConsInd",CstID,"")) D
	.&SQL(delete from DHC_EmConsultInd where EC_ParRef_Dr=:CstID)
	Q:+$g(SQLCODE)'=0 SQLCODE
	
	Q SQLCODE
}

/// Descritp:  会诊申请单状态
/// w ##class(web.DHCEMConsult).GetIsModFlag(645,"50")
ClassMethod GetIsModFlag(itmID As %String, stCode As %String) As %String
{
	n (itmID, stCode)
	s tID=""
	i itmID["||" D
	.s tID=$p(^DHCEMCON(+itmID,"I",$p(itmID,"||",2)),"^",6)
	i tID="" D
	.s tID=$p(^DHCEMCON(+itmID),"^",18)
	Q:tID="" 0
	s ID=$o(^DHCEMCONS(0,"Code",$$ALPHAUP^SSUTIL4(stCode),""))
	Q:ID'=tID 0
	Q 1
}

/// Descritp:  会诊申请单是否有接收
/// w ##class(web.DHCEMConsult).GetIsHaveModFlag(318,"30")
ClassMethod GetIsHaveModFlag(CstID As %String, stCode As %String) As %String
{
	n (CstID, stCode)
	s ret=0
	s CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")!(ret=1)  D
	.s ItmSta=$p(^DHCEMCON(CstID,"I",CH),"^",6)        /// 子表状态
	.s ItmStaCode=$p($g(^DHCEMCONS(+ItmSta)),"^",1)    /// 子表状态Code
	.s:ItmStaCode=stCode ret=1
	Q ret
}

/// Creator:    hxy
/// CreateDate: 2021-01-09
/// Descritp:  会诊申请单状态日志
ClassMethod GetIsModFlagByLog(itmID As %String, stCode As %String) As %String
{
	n (itmID, stCode)
	s LgID=$o(^DHCEMCONL(0,"Cst",itmID,""),-1) 
	s StatusID=$p(^DHCEMCONL(LgID),"^",3)
	s StatusCode=$p(^DHCEMCONS(StatusID),"^",1)
	Q:StatusCode'=stCode 0
	Q 1
}

/// Creator:    hxy
/// CreateDate: 2021-03-30
/// Descritp:  通过状态code串取会诊申请单状态标志
/// w ##class(web.DHCEMConsult).GetIsModFlagOnStr(113,"80^")
ClassMethod GetIsModFlagOnStr(itmID As %String, stCodeStr As %String) As %String
{
	n (itmID, stCodeStr)
	s ID=$p($g(^DHCEMCON(+itmID,"I",+$p(itmID,"||",2))),"^",6)  /// 会诊状态
	i ID="" s ID=$p(^DHCEMCON(+itmID),"^",18)  /// 会诊状态
	Q:ID="" ""
	s stCode="^"_$p($g(^DHCEMCONS(+ID)),"^",1)_"^"
	Q:stCodeStr'[stCode 0
	Q 1
}

/// Creator:    hxy
/// CreateDate: 2021-06-01
/// Descritp:  通过会诊主表判断日志里子表是不是当前都是该状态code（会诊评价55）,当前到达40不作为当前（因为可随时到达）
/// w ##class(web.DHCEMConsult).GetIsModFlagByLogOnCstID(643,"55")
ClassMethod GetIsModFlagByLogOnCstID(CstID As %String, stCode As %String) As %String
{
	n (CstID, stCode)
	s ret=1
	s CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(ret=0)  D
	.s CstItmDr = CstID_"||"_CH
	.s LgID="",CurCode=""
	.F  s LgID=$o(^DHCEMCONL(0,"Cst",CstItmDr,LgID),-1) Q:(LgID="")||(CurCode'="")  D
	..s StatusID=$p(^DHCEMCONL(LgID),"^",3)        /// 状态ID
	..s StatusCode=$p(^DHCEMCONS(StatusID),"^",1)  /// 状态code
	..q:StatusCode=40
	..s CurCode=StatusCode
	.s:CurCode'=stCode ret=0
	q ret
}

/// CreateDate: 2021-06-01
/// Descritp:  通过会诊主表判断日志里子表是不是当前都是该状态code（会诊评价55）,当前到达40不作为当前（因为可随时到达）
/// w ##class(web.DHCEMConsult).GetItmIdByLogOnCstID(1265,12175,"75")
ClassMethod GetItmIdByLogOnCstID(CstID As %String, UserId As %String, stCode As %String) As %String
{
	n (CstID,UserId, stCode)
	s ret=""
	s CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(ret=0)  D
	.s CstItmDr = CstID_"||"_CH
	.s LgID="",CurCode=""
	.s GrpID=$p(^DHCEMCON(CstID,"I",CH),"^",12)        /// 医生大科 //hxy 2021-06-16 st
	.s GrpLeadDr=$p($g(^DHCEMCG(+GrpID)),"^",5)        /// 医生大科组长
	.s ItmSta=$p(^DHCEMCON(CstID,"I",CH),"^",6)        /// 子表状态
	.s ItmStaCode=$p($g(^DHCEMCONS(+ItmSta)),"^",1)    /// 子表状态Code
	.q:ItmStaCode=40
	.q:stCode'=ItmStaCode
	.q:UserId'=GrpLeadDr
	.s ret=CstID_"||"_CH
	q ret
}

/// Creator:qqa
/// Descritp: 主表ID，判断字表是否都是同一个状态
/// w ##class(web.DHCEMConsult).GetAllConsIsModFlag(1264,75,"1264||2")
ClassMethod GetAllConsIsModFlag(CstID As %String, StCode As %String, ItmID As %String = "") As %String
{
	n (CstID, StCode,ItmID)
	s Ret=1
	s Sub=0
	f  s Sub=$o(^DHCEMCON(CstID,"I",Sub)) q:(Sub="")||(Ret'=1)  d
	.q:(ItmID'="")&&(ItmID'=CstID_"||"_Sub)   ///guoguomin 20211204 根据子表过滤
	.s:'..GetIsModFlag(CstID_"||"_Sub,StCode) Ret=0
	Q Ret
}

/// Descritp:  删除申请单
ClassMethod RemoveCstNo(CstID As %String) As %String
{
	n (CstID)
	/// 申请状态
	Q:$p(^DHCEMCON(CstID),"^",18)'="" "-1"
	&sql(DELETE DHC_EmConsult WHERE EC_RowID =:CstID)
	Q SQLCODE
}

/// Descritp:  发送申请单
/// w ##class(web.DHCEMConsult).SendCstNo("110","2^113^29^12175")
ClassMethod SendCstNo(CstID As %String, LgParam As %String, Risk = "") As %String
{
	n (CstID, LgParam,Risk,%session)
	s Err=0
	s StatusID=..GetConsStatus(20)
	s HospID = $p(LgParam,"^",1)
	s LgLocID= $p(LgParam,"^",2)
	s UserID= $p(LgParam,"^",4)
	
	s IsInsOrd = ##class(web.DHCEMConsult).SendIsInsOrd(CstID,HospID,"R")
	
	/// 申请状态
	Q:$p(^DHCEMCON(CstID),"^",18)'="" "-1"
	
	TS
	/// 修改状态
	s Err = ..InsCsItemStatus(CstID,"",StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11^修改状态失败！"
	
	/// 插入医嘱
	s:IsInsOrd=1 Err = ..InsCstOeori(CstID)
	i Err'=0 tro
	Q:Err="-2" "-2^会诊配置申请需要插入费用医嘱但费用医嘱未配置！"
	Q:Err'=0 "-12^"_Err
	
	/// 插入操作日志
	s Err = ..InsConsultLog(CstID,"",UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13^插入日志失败！"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-14^主表状态修改失败！"
	
	/// 修改会诊的申请时间为发送时间
	s Err = ..InsCsReqTime(CstID)
	i Err'=0 tro
	Q:Err'=0 "-15^修改会诊申请时间失败!"
	
	///医生会诊推送数据给电子病历 hxy 2022-03-02
	s CstEcType = $p(^DHCEMCON(CstID),"^",19)
	i CstEcType["DOC" s Err=##Class(web.DHCEMConsultCom).SetDataForEmr(CstID,"","","发送")
	i Err'=0 tro
	Q:Err'=0 "-16^推送数据给电子病历失败！"
	
	/// 调用平台组方法 hxy 2022-12-23
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(CstID,"",UserID,"AP","20","",LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-17^调用平台状态统一存储接口存储状态失败！"
	
	TC
	
	D ..SendOtherMethod(CstID,UserID,"") ;第三方接口
	
	Q CstID
}

ClassMethod SendCvMessage(CstID, UserID, Risk)
{
	q:+Risk=0 0
	q ##Class(BSP.CV.SRV.Interface).SaveTransConsultation(Risk,CstID, UserID)
}

/// 会诊申请是否是否插入医嘱
/// W ##class(web.DHCEMConsult).SendIsInsOrd(2,2)
ClassMethod SendIsInsOrd(CstID, HospID, Type)
{
	n (CstID, HospID ,Type)
	s InsOrdByType=..SendIsInsOrdByType(CstID, HospID ,Type) //hxy 2021-02-26 add
	s ConfCode="",ConfDocaCode=""
	i Type="R" d
	.s ConfCode="REQORD"
	.s ConfDocaCode="REQORDDOCA"
	i Type="C" d
	.s ConfCode="ACCORD"
	.s ConfDocaCode="ACCORDDOCA"
	s IsDocaCst=""								///抗生素会诊
	s ECType = $P(^DHCEMCON(CstID),"^",19)
	s:ECType="DOCA" IsDocaCst=1
	s Ret=""
	s InsertOrd = ##class(web.DHCEMConsultCom).GetEmSysConfig(ConfCode,HospID)  		//非抗生素申请的时候是否插入医嘱  
	s InsertOrdDOCA = ##class(web.DHCEMConsultCom).GetEmSysConfig(ConfDocaCode,HospID)  //抗生素申请的时候是否插入医嘱  
	s:InsOrdByType=0 InsertOrd=0 //hxy 2021-02-26 add
	s:IsDocaCst=1 Ret=InsertOrdDOCA
	s:IsDocaCst'=1 Ret=InsertOrd
	q Ret
}

/// 会诊申请是否插入医嘱 按患者就诊类型
/// W ##class(web.DHCEMConsult).SendIsInsOrdByType(676,2,"R")
ClassMethod SendIsInsOrdByType(CstID, HospID, Type)
{
	n (CstID, HospID ,Type)
	s ConfCode="",Ret=1
	i Type="R" d
	.s ConfCode="REQORDBYTYPE"
	i Type="C" d
	.s ConfCode="ACCORDBYTYPE"
	s EpisodeID = $P(^DHCEMCON(CstID),"^",1)
	s PatType=##Class(web.DHCEMConsultCom).GetPatType(EpisodeID)
	s TypeStr=##class(web.DHCEMConsultCom).GetEmSysConfig(ConfCode,HospID) //非抗生素申请的时候是否插入医嘱 按患者就诊类型
	s:(TypeStr'="")&(TypeStr'[PatType) Ret=0
	q Ret
}

/// Descritp:  取消申请单
ClassMethod InvCanCstNo(CstID As %String, UserID As %String, LgParam As %String) As %String
{
	n (CstID, UserID,LgParam)
	s ErrMsgTip=..CanCstNo(CstID, UserID,LgParam)
	w ##class(web.DHCAPPJsonCommon).getJsonData("ErrCode^ErrMsg",ErrMsgTip)
	Q ""
}

/// Descritp:  取消申请单
ClassMethod CanCstNo(CstID As %String, UserID As %String, LgParam As %String) As %String
{
	n (CstID, UserID,LgParam)

	s Err=0
	s StatusID=..GetConsStatus(5)
	/// 申请状态
	Q:..IsPermitCancel(CstID) "-1"
	s LgLocID= $p(LgParam,"^",2)
	
	TS
	/// 修改状态
	s Err = ..InsCsItemStatus(CstID,"",StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11^修改状态失败！"
		
	/// 插入操作日志
	s Err = ..InsConsultLog(CstID,"",UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-12^插入日志失败！"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13^主表状态修改失败！"

	/// 调用停医嘱接口
	s Err=..InvCstStopOrder(CstID,UserID)
	i +Err'=0 tro
	Q:+Err'=0 "-14^调用医嘱接口失败："_Err
	
#;	/// 执行信封消息
#;	s Err = ..InvExecMes(CstID,"",UserID,"")
#;	i Err<0 tro
#;	Q:Err<0 "-15"

	/// 医生会诊取消时调用推送数据给电子病历 2022-03-02 st
	s ECType = $p(^DHCEMCON(CstID),"^",19)
	i ECType["DOC" s Err=##Class(web.DHCEMConsultCom).SetDataForEmr(CstID,"","","取消")
	i +Err'=0 tro
	Q:+Err'=0 "-16^推送数据给电子病历失败！" //ed
	
	/// 调用平台组方法 hxy 2022-12-23
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(CstID,"",UserID,"CAP","5","",LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-17^调用平台状态统一存储接口存储状态失败！"
	
	TC
	
	/// 执行信封消息
	D ..InvExecMes(CstID,"",UserID,"C")
	
	Q Err
}

/// Descript:  调用停医嘱接口
/// W ##Class(web.DHCEMConsult).InvCstStopOrder("85722||1","13")
ClassMethod InvCstStopOrder(CstID As %String, LgUserID As %String) As %String
{
	n (CstID, LgUserID)
	s EpisodeID=$p(^DHCEMCON(CstID),"^",1)	    /// 就诊ID
	s PatType=$p(^PAADM(EpisodeID),"^",2)  		/// 病人类型
	s Err=0, CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.s Oeori=$p(^DHCEMCON(CstID,"I",CH),"^",9)  /// 医嘱ID
	.Q:Oeori=""
	.s OeFlag=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)
	.Q:(OeFlag="U")||(OeFlag="D")||(OeFlag="C")
	.Q:OeFlag'="V"
	.i PatType="I" D
	..s Err=##class(appcom.OEOrdItem).CancelMulti(Oeori,LgUserID,"","N") /// 住院撤销医嘱
	.E  D
	..s Err=##Class(appcom.OEOrdItem).StopMulti(Oeori,LgUserID,"","N")   /// 门诊停止医嘱
	s ErrMsg=""
	i Err'=0 s ErrMsg=##Class(web.DHCDocInPatPortalCommon).GetMsg(Err)   /// 错误代码转义
	Q Err_"^"_ErrMsg
}

/// Descritp:  确认申请单
ClassMethod SureCstNo(ItmID As %String, UserID As %String) As %String
{
	n (ItmID, UserID)

	s Err=0
	s StatusID=..GetConsStatus(60)
	Q:ItmID="" "-1"
	/// 申请状态
	Q:'..GetIsModFlag(ItmID,50) "-1"
	
	TS
	/// 修改状态
	s Err = ..UpdCsItemStatus(ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 插入操作日志
	s Err = ..InsConsLog(ItmID,UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(+ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	TC
	Q Err
}

/// Descritp:  确认申请单
/// w ##class(web.DHCEMConsult).SureCstMas(437,12175)
ClassMethod SureCstMas(CstID As %String, UserID As %String, LgParam As %String) As %String
{
	n (CstID, UserID,LgParam)
	s Err=0
	s StatusID=..GetConsStatus(60)
	s LgLocID= $p(LgParam,"^",2)
	/// 申请状态
	;Q:'..GetIsModFlag(CstID,50) "-1"_..GetUnCompLocs(CstID,50) //hxy 2021-01-07 st 注释
	s UnCompStr=..GetUnCompLocs(CstID,50)
	s SureBeforeEva=..GetSureBeforeEva(CstID) //hxy 2021-06-01 st 会诊处理-是否在会诊医师会诊评价后才能确认
	Q:((SureBeforeEva="Y")&('..GetIsModFlagByLogOnCstID(CstID,55)))&('..GetIsModFlag(CstID,61)) "-2" //ed 
	Q:UnCompStr'="" "-1"_UnCompStr
	Q:('..GetIsModFlag(CstID,50))&('..GetIsModFlag(CstID,61)) "-1^" //ed
	
	TS
	/// 修改状态
	s Err = ..InsCsItemStatus(CstID,"",StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 插入操作日志
	s Err = ..InsConsultLog(CstID,"",UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 调用平台组方法 hxy 2022-12-27
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(CstID,"",UserID,"CONCONFIRM","60","",LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-14" //^调用平台状态统一存储接口存储状态失败！
	
	TC
	Q Err
}

/// Creator:    hxy
/// CreateDate: 2021-01-07
/// Descritp:  取消确认申请单
/// w ##class(web.DHCEMConsult).CanSureCstMas(437,12175)
ClassMethod CanSureCstMas(CstID As %String, UserID As %String, LgParam As %String) As %String
{
	n (CstID, UserID,LgParam)

	s Err=0
	s LgLocID= $p(LgParam,"^",2)
	s StatusID=..GetConsStatus(61)
	/// 申请状态
	Q:'..GetIsModFlag(CstID,60)&'..GetIsModFlag(CstID,79) "-1" 
	
	TS
	/// 修改状态
	s Err = ..InsCsItemStatus(CstID,"",StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 插入操作日志
	s Err = ..InsConsultLog(CstID,"",UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 调用平台组方法 hxy 2022-12-28
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(CstID,"",UserID,"CONCCONFIRM","61","",LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-14" //^调用平台状态统一存储接口存储状态失败！
	
	TC
	Q Err
}

/// Descritp:  接受申请单
/// W ##Class(web.DHCEMConsult).AcceptCstNo("12||1","6079")
ClassMethod AcceptCstNo(ItmID As %String, UserID As %String) As %String
{
	n (ItmID, UserID)
	s Err=0
	s StatusID=..GetConsStatus(30)
	/// 申请状态
	Q:('..GetIsModFlag(ItmID,20))&('..GetIsModFlag(ItmID,21)) "-1"
	/// 是否允许接受申请单
	Q:..IsPermitAccept(+ItmID) "-1"
	
	TS
	/// 修改状态
	s Err = ..UpdCsItemStatus(ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 更新时间
	s Err = ..UpdCsItemTime(ItmID,UserID,"")
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 插入操作日志
	s Err = ..InsConsLog(ItmID,UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(+ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-15"
	
	/// 执行请会诊医嘱
	s Err = ..ExeCsMasROeori(+ItmID,ItmID,UserID,"E")
	i Err'=0 tro
	Q:Err'=0 "-16"
	
	TC
	Q Err
}

/// Descritp:  接收申请单
/// InPut:     CstID-会诊ID, ItmID-会诊子表ID, UserID-用户ID
///            注：ItmID 为空时，会同时接收该申请单所有子项目(适用于请会诊医生填写会诊结论情况或MDT申请)
/// OutPut:    0-成功，其他-失败
/// W ##Class(web.DHCEMConsult).AcceptCstMas("216","216||1","2^95^29^10209")
ClassMethod AcceptCstMas(CstID As %String, ItmID As %String, LgParam As %String) As %String
{
	n (CstID, ItmID, LgParam)
	
	s Err=0
	s StatusID=..GetConsStatus(30)
	/// 申请状态
	s CsPointer=$s(ItmID'="":ItmID,1:CstID)
	//Q:('..GetIsModFlag(CsPointer,20))&('..GetIsModFlag(CsPointer,21))&('..GetIsModFlag(CsPointer,35)) "-1"
	/// 是否允许接受申请单

	Q:..IsPermitAccept(CsPointer) "-1"
	
	s HospID = $p(LgParam,"^",1)
	s LgLocID= $p(LgParam,"^",2)
	s UserID=$p(LgParam,"^",4)
	//不能接收医护人员类型配置hxy 2022-08-31
	Q:..IsPrvTpPermitAccept(HospID,UserID) "-4"
	
	///院际和多科申请人填写会诊意见不需要修改完成人
	s NeedUpdCompDoc=##Class(web.DHCEMConsult).NeedUpdCompDoc(+CstID,HospID)
	
	s YuJiConsIsComp=##Class(web.DHCEMConsult).YuJiConsIsCompFlag(+CstID,HospID)
	q:(YuJiConsIsComp'="")&&(YuJiConsIsComp="N") -300
	
	TS
	/// 修改状态
	s Err = ..InsCsItemStatus(CstID,ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11^修改状态失败！"
	
	/// 更新时间
	s:NeedUpdCompDoc Err = ..InsCsItemTime(CstID,ItmID,UserID)
	i Err'=0 tro
	Q:Err'=0 "-14^更新时间失败！"
	
	/// 插入操作日志
	s Err = ..InsConsultLog(CstID,ItmID,UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-15^插入日志失败！"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(+CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-16^主表状态修改失败！"
	
	/// 执行请会诊医嘱
	s Err = ..ExeCsMasROeori(CstID,ItmID,UserID,"E")
	i Err'=0 tro
	Q:Err="-100009" "-100009^非核实状态的医嘱不能执行！返回值："_Err
	Q:Err'=0 "-17^执行会诊医嘱失败！返回值："_Err
	
	/// 调用平台组方法 hxy 2022-12-23
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(CstID,ItmID,UserID,"CONREC","30","",LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-18^调用平台状态统一存储接口存储状态失败！"
	
	TC
	Q Err
}

/// Descritp:  撤销接收
/// InPut:     CstID-会诊ID, ItmID-会诊子表ID, UserID-用户ID
///            注：ItmID 为空时，会同时取消接收该申请单所有子项目(适用于请会诊医生填写会诊结论情况或MDT申请)
/// OutPut:    0-成功，其他-失败
/// W ##Class(web.DHCEMConsult).CanAccCstMas("12","12||1","6079")
ClassMethod RevAccCstMas(CstID As %String, ItmID As %String, UserID As %String, Reason = "", LgParam As %String) As %String
{
	n (CstID, ItmID, UserID,Reason,LgParam)

	s Err=0
	s LgLocID= $p(LgParam,"^",2)
	s RLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	s HospID=$p(^CTLOC(RLocID),"^",22)
	s StatusID=##Class(web.DHCEMConsultWorkFlow).GetWorkFlowLastStCode(CstID, HospID)
	i StatusID="" s StatusID=..GetConsStatus(20)
	/// 申请状态
	s CsPointer=$s(ItmID'="":ItmID,1:CstID)
	Q:('..GetIsModFlag(CsPointer,30))&('..GetIsModFlag(CsPointer,51)) "-1"
	
	TS
	/// 修改状态
	s Err = ..InsCsItemStatus(CstID,ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11^修改状态失败!"
	
	/// 置空会诊人 //hxy 2020-09-25
	s Err = ..UpdCsItemCDoc(ItmID)
	i Err'=0 tro
	Q:Err'=0 "-12^置空会诊人失败！"
		
	/// 插入操作日志
	s ID=..GetConsStatus(35)
	s Err = ..InsConsultLog(CstID,ItmID,UserID,ID,Reason)
	i Err'=0 tro
	Q:Err'=0 "-14^插入日志失败！"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-15^主表状态修改失败！"
	
	/// 执行请会诊医嘱
	s Err = ..ExeCsMasROeori(CstID,ItmID,UserID,"V")
	i Err'=0 tro
	Q:Err'=0 "-16^撤销执行医嘱失败，返回值:"_Err
	
	/// 调用平台组方法 hxy 2022-12-23
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(CstID,ItmID,UserID,"CONCREC","35",Reason,LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-17^调用平台状态统一存储接口存储状态失败！"
	
	TC
	Q Err
}

/// Descritp:  接受申请单
/// W ##Class(web.DHCEMConsult).SaveAccCstNo("12||1","6079")
ClassMethod SaveAccCstNo(ItmID As %String, UserID As %String, Params As %String) As %String
{
	n (ItmID, UserID, Params)
	s Err=0
	s StatusID=..GetConsStatus(30)
	/// 申请状态
	Q:('..GetIsModFlag(ItmID,20))&('..GetIsModFlag(ItmID,21)) "-1"
	Q:..ValiCstTime(+ItmID, Params) "-2"
	TS
	/// 更新发送
	s Err = ..UpdCsItemStatus(ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 更新时间
	s Err = ..UpdCsItemTime(ItmID,UserID,Params)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 插入操作日志
	s Err = ..InsConsLog(ItmID,UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(+ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-14"
	TC
	Q Err
}

/// Descritp:  是否允许接受申请单
/// InPut:     CstID - 会诊ID
/// OutPut:    0-允许,1-不允许
/// W ##Class(web.DHCEMConsult).IsPermitAccept("156||1")
ClassMethod IsPermitAccept(itmID As %String) As %String
{
	n (itmID)
	Q:##Class(web.DHCEMConsultWorkFlow).isWFCompFlag(+itmID)="Y" 0 /// 工作流是否已经审核完
	Q:##Class(web.DHCEMConsultQuery).IsTakAccept(itmID,"30") 0  /// 是否已接收
#;	s MoreFlag=$p(^DHCEMCON(CstID),"^",31)   /// 多科标志
#;	s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
#;	Q:(MoreFlag'="Y")&(CstOutFlag'="Y") 0
#;	Q:$p(^DHCEMCON(CstID),"^",14)'="" 0      /// 审核人
	Q 1
}

/// Descritp:  是否允许取消申请单
/// InPut:     CstID - 会诊ID
/// OutPut:    0-允许,1-不允许
/// W ##Class(web.DHCEMConsult).IsPermitCancel("131")
ClassMethod IsPermitCancel(CstID As %String) As %String
{
	n (CstID)
	Q:($p(^DHCEMCON(CstID),"^",14)'="")&&('..GetIsModFlag(CstID,22)) 1 /// 审核人不为空,并且当前状态不为驳回
	Q:('..GetIsModFlag(CstID,20))&('..GetIsModFlag(CstID,25))&('..GetIsModFlag(CstID,22))&('..GetIsModFlag(CstID,35)) 1
	Q:..GetIsHaveModFlag(CstID,30) 1 //存在接收的会诊
	Q 0
}

/// Descritp:  拒绝申请单
/// W ##Class(web.DHCEMConsult).RefCstNo("66||1","10209")
ClassMethod RefCstNo(ItmID As %String, UserID As %String, Reason = "", LgParam As %String) As %String
{
	n (ItmID, UserID, %session,Reason,LgParam)
	s Err=0

	s StatusID=..GetConsStatus(25)
	/// 申请状态
	s ID=$p(^DHCEMCON(+ItmID,"I",$p(ItmID,"||",2)),"^",6)
	Q:($p(^DHCEMCONS(ID),"^",1)>35)&&($p(^DHCEMCONS(ID),"^",2)'["审核") "-1"
	
	s MoreFlag=$p(^DHCEMCON(+ItmID),"^",31)       /// 多科
	Q:MoreFlag="Y" "-3"
	
	/// 审核标志
	Q:$p(^DHCEMCON(+ItmID),"^",14)'="" "-2"		  /// 已经审核的会诊不允许拒绝
	s ECType = $P(^DHCEMCON(+ItmID),"^",19)
	
	s LgLocID= $p(LgParam,"^",2)
	
	TS
	/// 修改状态
	s Err = ..UpdCsItemStatus(ItmID, StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11^修改状态失败！"

	/// 插入操作日志
	s Err = ..InsConsLog(ItmID,UserID,StatusID,Reason)
	i Err'=0 tro
	Q:Err'=0 "-12^插入日志失败！"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(+ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13^主表状态修改失败！"
	
	/// 执行信封消息
	s Err = ..InvExec(ItmID, UserID)
	i Err<0 tro
	Q:Err<0 "-14^执行信封消息失败！"
	
	///抗生素接口置状态为拒绝
	i ECType="DOCA" s Err = ##class(DHCAnt.KSS.MainBusiness).DBChangeConsultStatusNew(+ItmID,UserID,"R")
	i Err'=0 tro
	Q:Err'=0 "-15^抗生素接口置状态失败,返回值："_Err
	
	/// 调用平台组方法 hxy 2022-12-26
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(+ItmID,ItmID,UserID,"CONREJ","25",Reason,LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-16^调用平台状态统一存储接口存储状态失败！"
	
	TC
	
	/// 小信箱 hxy 2021-04-07 会诊拒收，增加消息推送功能，推送给申请医师，会诊已拒收;
	D ..SendmessageByRej(+ItmID,UserID,Reason,"Ref")
	
	Q Err
}

/// Descritp:  到达申请单
ClassMethod AriCstNoOld(ItmID As %String, UserID As %String) As %String
{
	n (ItmID, UserID)
	s Err=0
	s StatusID=..GetConsStatus(40)
	/// 申请状态
	Q:'..GetIsModFlag(ItmID,30) "-1"
	TS
	/// 变更状态
	s Err = ..UpdCsItemStatus(ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 插入操作日志
	s Err = ..InsConsLog(ItmID,UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(+ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	TC
	Q Err
}

/// Descritp:  到达申请单
ClassMethod AriCstNo(CstID As %String, ItmID As %String, LgParam As %String, ArrDate = "", ArrTime = "") As %String
{
	n (CstID,ItmID,LgParam,ArrDate,ArrTime)
	s Err=0
	s StatusID=..GetConsStatus(40)
	s HospID = $p(LgParam,"^",1)
	s LgLocID= $p(LgParam,"^",2)
	s UserID= $p(LgParam,"^",4)

	/// 申请状态
	s CsPointer=$s(ItmID'="":ItmID,1:CstID)
	s MasStatusId = $p(^DHCEMCON(+CsPointer),"^",18)
	s IsWFCompFlag=##Class(web.DHCEMConsultWorkFlow).isWFCompFlag(+CsPointer)   /// 工作流是否已经审核完
	q:(IsWFCompFlag'="Y")||(MasStatusId="")||(..GetIsModFlag(CsPointer,5))||(..GetIsModFlag(CsPointer,25)) "-1"
	;s IsUseAcc = ##Class(web.DHCEMConsultCom).ConsStatusCodeIsUse(HospID,30)	///是否启用了接收
	;Q:(IsUseAcc=1)&('..GetIsModFlag(CsPointer,30)) "-1"
	;Q:(IsUseAcc'=1)&('..GetIsModFlag(CsPointer,20))&(IsWFCompFlag'="Y") "-1" 
	;Q:(IsUseAcc=1)&('..GetIsModFlagOnStr(CsPointer,"^30^40^50^51^55^56^60^61^70^79^")) "-1"
	;Q:(IsUseAcc'=1)&('..GetIsModFlagOnStr(CsPointer,"^20^30^40^50^51^55^56^60^61^70^79^"))&(IsWFCompFlag'="Y") "-1"
	
	s:ArrDate="" ArrDate=+$h
	s:ArrDate'="" ArrDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(ArrDate)
	i ArrTime="" d
	.s ArrTime=$p($h,",",2)
	e  d
	.s ArrTime=$zth(ArrTime,1)
	q:$SYSTEM.SQL.DATEDIFF("ss",$H,ArrDate_","_ArrTime)>0 "-2" //hxy 2021-05-12 到达时间不能大于当前时间
	s SendTime=$p(^DHCEMCON(CstID),"^",3)_","_$p(^DHCEMCON(CstID),"^",4) /// 申请日期时间
	q:$SYSTEM.SQL.DATEDIFF("ss",SendTime,ArrDate_","_ArrTime)<0 "-3" //hxy 2021-05-12 到达时间不应早于发送时间
	s CompTime="" //hxy 2021-06-09 st
	s:ItmID'="" CompTime=##Class(web.DHCEMConsultQuery).GetCstNodeTime(ItmID,"50") /// 完成时间
	s:ItmID="" CompTime=##Class(web.DHCEMConsultQuery).GetCstNodeTime(CstID_"||1","50") /// 完成时间
	q:(CompTime'="")&&($SYSTEM.SQL.DATEDIFF("ss",CompTime,ArrDate_","_ArrTime)>0) "-4" // 到达时间不应晚于完成时间 //ed
	s CstNote=##class(web.DHCEMCommonUtil).DateLogicalToHtml(ArrDate)_" "_$zt(ArrTime,1) //hxy 2021-05-12 备注当前到达日期
	s AccTime="" // 若存在接收时间，则到达时间不应早于接收时间 2023-02-01 st
	s:ItmID'="" AccTime=##Class(web.DHCEMConsultQuery).GetCstNodeTime(ItmID,"30")
	s:ItmID="" AccTime=##Class(web.DHCEMConsultQuery).GetCstNodeTime(CstID_"||1","30")
	q:(+AccTime'=0)&&($SYSTEM.SQL.DATEDIFF("ss",AccTime,ArrDate_","_ArrTime)<0) "-5" //ed
	TS
	///置会诊子表到达时间
	s Err = ..UpdCstArrDate(CstID,ItmID,UserID,ArrDate,ArrTime)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 插入操作日志
	s Err = ..InsConsultLog(CstID,ItmID,UserID,StatusID,CstNote)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 调用平台组方法 hxy 2022-12-26
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(CstID,ItmID,UserID,"CONARRIVE","40","",LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-13" //^调用平台状态统一存储接口存储状态失败！
	
	TC
	Q Err
}

/// Descritp:  取消到达
ClassMethod CanAriCstNo(CstID As %String, ItmID As %String, LgParam As %String) As %String
{
	n (CstID,ItmID,LgParam)
	s Err=0
	s StatusID=..GetConsStatus(41)
	s UserID= $p(LgParam,"^",4)
	;只有置到达状态的人员可以点击取消到达(谁置谁可取消)
	s AriUser=..GetCstNodeUser(ItmID,"40")
	q:(AriUser'="")&&(AriUser'=UserID) "-1"
	
	TS
	///置会诊子表到达时间
	s Err = ..UpdCstArrDate(CstID,ItmID,UserID,"","")
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 插入操作日志
	s Err = ..InsConsultLog(CstID,ItmID,UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	TC
	Q Err
}

/// Descritp:  完成申请单
ClassMethod CompCstNo(ItmID As %String, LgParam As %String, CstOpinion As %String) As %String
{
	n (ItmID, LgParam, CstOpinion)
	s Err=0
	
	s HospID = $p(LgParam,"^",1)
	s UserID= $p(LgParam,"^",4)

	s InsertOrd = ##class(web.DHCEMConsult).SendIsInsOrd(+ItmID,HospID,"C")   //完成的时候是否插入医嘱  

	s StatusID=..GetConsStatus(50)
	/// 申请状态
	Q:'..GetIsModFlag(ItmID,30) "-1"
	
	TS
	/// 修改状态
	s Err = ..UpdCsItemStatus(ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 插入会诊医嘱
	s:InsertOrd=1 Err = ..InsCstCOeori(ItmID,UserID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 会诊意见
	s Err = ..UpdConsOpin(ItmID,CstOpinion)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 插入操作日志
	s Err = ..InsConsLog(ItmID,UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(+ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 执行请会诊医嘱
	s Err = ..ExeCsMasCOeori(+ItmID,ItmID,UserID,"E")
	i Err'=0 tro
	Q:Err'=0 "-15"
	
	/// 执行信封消息
	s Err = ..InvExec(ItmID, UserID)
	i Err<0 tro
	Q:Err<0 "-16"
	TC
	Q Err
}

/// Descritp:  预完成会诊
/// InPut:     CstID-会诊ID, ItmID-会诊子表ID, UserID-用户ID
///            注：ItmID 为空时，会同时撤销该申请单所有子项目(适用于请会诊医生填写会诊结论情况或MDT申请)
/// OutPut:    0-成功，其他-失败
/// W ##Class(web.DHCEMConsult).PreCompCstMas("","")
ClassMethod PreCompCstMas(CstID, ItmID, CstOpinion, LgParam) As %String
{
	n (CstID,ItmID, CstOpinion,LgParam)
	s HospID = $p(LgParam,"^",1)
	s LgLocID = $p(LgParam,"^",2) /// 登录科室
	s UserID= $p(LgParam,"^",4)
	
	s IsUseAcc = ##Class(web.DHCEMConsultCom).ConsStatusCodeIsUse(HospID,"30")   ///是否启用了接收
	s CsPointer=$s(ItmID'="":ItmID,1:CstID) 
	Q:(IsUseAcc=1)&('..GetIsModFlag(CsPointer,30))&('..GetIsModFlag(CsPointer,51))&('..GetIsModFlag(CsPointer,40)) "-1" //hxy 2021-03-30 add 40 st
	Q:(IsUseAcc'=1)&('..GetIsModFlag(CsPointer,20))&('..GetIsModFlag(CsPointer,21))&('..GetIsModFlag(CsPointer,51))&('..GetIsModFlag(CsPointer,40)) "-1" //ed
	
	///院际会诊是否审核完毕
	s YuJiConsIsComp=##Class(web.DHCEMConsult).YuJiConsIsCompFlag(+CstID,HospID)
	q:(YuJiConsIsComp'="")&&(YuJiConsIsComp="N") -300
	
	s Err=0
	TS
	
	s:ItmID'="" Err = ..UpdConsOpin(ItmID,CstOpinion)   ///单科多科
	s:ItmID="" Err = ..UpdCstNoMdt(CstID,CstOpinion)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	TC
	
	Q Err
}

/// Descritp:  完成会诊
/// InPut:     CstID-会诊ID, ItmID-会诊子表ID, UserID-用户ID
///            注：ItmID 为空时，会同时撤销该申请单所有子项目(适用于请会诊医生填写会诊结论情况或MDT申请)
/// OutPut:    0-成功，其他-失败
/// W ##Class(web.DHCEMConsult).CompCstMas("129","129||1","2^25^29^12624","cs1","","","")
ClassMethod CompCstMas(CstID As %String, ItmID As %String, LgParam As %String, CstOpinion As %String, AntiOpinion = "", CmpDate = "", CmpTime = "") As %String
{
	n (CstID, ItmID, LgParam, CstOpinion,AntiOpinion,CmpDate,CmpTime,%session,%request,%response)
	
	s Err=0
	s StatusID=..GetConsStatus(50)
	s HospID = $p(LgParam,"^",1)
	s LgLocID = $p(LgParam,"^",2) /// 登录科室
	s UserID= $p(LgParam,"^",4)
	
	s:CmpDate'="" CmpDate = ##class(web.DHCAPPCommonUtil).DateHtmlToLogical(CmpDate)
	s:CmpTime'="" CmpTime=$zth(CmpTime,1)
	s:CmpDate="" CmpDate=+$H				 ///完成日期
	s:CmpTime="" CmpTime = $p($H,",",2)		 ///完成日期
	q:(+CmpDate>+$h)||((+CmpDate=+$H)&&(+CmpTime>$p($H,",",2))) "-102"
	s SendCstDateInfo=""					 ///发送时间
	s:ItmID'="" SendCstDateInfo=##Class(web.DHCEMConsultQuery).GetCstNodeCacheTime(ItmID,20)
	s:ItmID="" SendCstDateInfo=##Class(web.DHCEMConsultQuery).GetCstNodeCacheTime(CstID,20)
	s SendDate=$p(SendCstDateInfo,"^",1)
	s SendTime=$p(SendCstDateInfo,"^",2)
	q:(+SendDate>+CmpDate)||((+SendDate=+CmpDate)&&(+SendTime>+CmpTime)) "-101"
	
	s CstEcType = $p(^DHCEMCON(CstID),"^",19)
	s IsDocaCst=""
	s:CstEcType="DOCA" IsDocaCst=1 

	s IsInsOrd = ##class(web.DHCEMConsult).SendIsInsOrd(CstID,HospID,"C")     ///完成的时候是否插入医嘱 
	s IsUseAcc = ##Class(web.DHCEMConsultCom).ConsStatusCodeIsUse(HospID,30)	///是否启用了接收
	
	/// 申请状态
	s CsPointer=$s(ItmID'="":ItmID,1:CstID)
	Q:(IsUseAcc=1)&('..GetIsModFlag(CsPointer,30))&('..GetIsModFlag(CsPointer,51))&('..GetIsModFlag(CsPointer,40)) "-1" //hxy 2021-03-30 add 40 st
	Q:(IsUseAcc'=1)&('..GetIsModFlag(CsPointer,20))&('..GetIsModFlag(CsPointer,21))&('..GetIsModFlag(CsPointer,51))&('..GetIsModFlag(CsPointer,40)) "-1" //ed
	
	s HospID = $p(LgParam,"^",1)
	s UserID=$p(LgParam,"^",4)
	///院际和多科申请人填写会诊意见不需要修改完成人
	s NeedUpdCompDoc=##Class(web.DHCEMConsult).NeedUpdCompDoc(+CstID,HospID)
	
	///院际会诊是否审核完毕
	s YuJiConsIsComp=##Class(web.DHCEMConsult).YuJiConsIsCompFlag(+CstID,HospID)
	q:(YuJiConsIsComp'="")&&(YuJiConsIsComp="N") -300
	
	///会诊完成是否自动执行会诊医嘱 hxy 2021-05-11
	s AccOrdExec=##class(web.DHCEMConsultCom).GetEmSysConfig("ACCORDEXEC",HospID)
	
	TS
	/// 修改状态
	s Err = ..InsCsItemStatus(CstID,ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11^修改状态失败！"
	
	/// 会诊结论
	i (ItmID="")||(IsDocaCst=1) s Err = ..UpdCstNoMdt(CstID,CstOpinion)    ///院外
	i (IsDocaCst=1) s Err = ..UpdCstNoAnti(CstID,AntiOpinion)			   ///DOCA
	i (ItmID'="")&(IsDocaCst'=1) s Err = ..UpdConsOpin(ItmID,CstOpinion)   ///单科多科
	i Err'=0 tro
	Q:Err'=0 "-12^记录会诊结论失败！"
	
	///置会诊完成时间
	s Err = ..UpdCstCmpDate(CstID,ItmID,UserID,CmpDate,CmpTime)
	i Err'=0 tro
	Q:Err'=0 "-18^记录完成时间失败！"
	
	/// 插入会诊医嘱
	s:IsInsOrd=1 Err = ..InsCstMasCOeori(CstID,ItmID,UserID,LgLocID)
	i Err'=0 tro
	Q:Err="-1" "-200^会诊配置完成需要插入费用医嘱但费用医嘱未配置！"
	Q:Err'=0 "-13^"_Err
	
	/// 插入操作日志
	s Err = ..InsConsultLog(CstID,ItmID,UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-14^插入日志失败！"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-15^主表状态修改失败！"
	
	/// 执行请会诊医嘱
	s:AccOrdExec'=1 Err = ..ExeCsMasCOeori(CstID,ItmID,UserID,"E") //hxy 2021-05-11 add :AccOrdExec'=1
	i Err'=0 tro
	Q:Err'=0 "-16^执行医嘱失败！返回值："_Err
	
	i IsDocaCst=1 d   //抗生素接口，置完成状态
	.S Err = ##class(DHCAnt.KSS.MainBusiness).DBChangeConsultStatusNew(CstID,UserID,"E")
	i Err'=0 tro
	Q:Err'=0 "-25^抗生素接口置完成状态失败！"
	
	i (ItmID'="")&&(NeedUpdCompDoc) s Err=..UpdCsItemTime(ItmID,UserID,"")
	i Err'=0 tro
	Q:Err'=0 "-26^记录完成人失败！"
	
	///医生会诊推送数据给电子病历
	i CstEcType["DOC" s Err=##Class(web.DHCEMConsultCom).SetDataForEmr(CstID,CmpDate,CmpTime,"完成")
	i Err'=0 tro
	Q:Err'=0 "-27^推送数据给电子病历失败！"
	
	/// 调用平台组方法 hxy 2022-12-26
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(CstID,ItmID,UserID,"CONCOMPLETED","50","",LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-28^调用平台状态统一存储接口存储状态失败！"
	
	TC
	
	/// 执行信封消息
	D ..InvExecMes(CstID,ItmID,UserID,"Y")
	
	Q Err
}

/// Descritp:  撤销完成
/// InPut:     CstID-会诊ID, ItmID-会诊子表ID, UserID-用户ID
///            注：ItmID 为空时，会同时撤销该申请单所有子项目(适用于请会诊医生填写会诊结论情况或MDT申请)
/// OutPut:    0-成功，其他-失败
/// W ##Class(web.DHCEMConsult).RevCompCstMas("119","119||1","234")
ClassMethod RevCompCstMas(CstID As %String, ItmID As %String, UserID As %String, LgParam As %String) As %String
{
	n (CstID, ItmID, UserID ,%session,LgParam)

	s Err=0
	s StatusID=..GetConsStatus(51)
	s LgLocID= $p(LgParam,"^",2)
	s ECType = $P(^DHCEMCON(CstID),"^",19)
	s IsDocaCst=""
	s:ECType="DOCA" IsDocaCst=1
	/// 申请状态
	s CsPointer=$s(ItmID'="":ItmID,1:CstID)
	Q:'..GetIsModFlag(CsPointer,50)&'..GetIsModFlag(CsPointer,61) "-1" //hxy 2021-01-08 add 61
	
	s CanDocaUpd=""
	s:IsDocaCst=1 CanDocaUpd = ##class(DHCAnt.KSS.MainBusiness).GetAntStatusForNurse(CstID)
	q:(IsDocaCst=1)&&(CanDocaUpd'=1) "-2^抗菌药不允许撤销完成!"   //抗生那边不允许撤销完成
	
	s HospID=##Class(web.DHCEMConsultCom).GetPatHospID(CstID) //hxy 2021-05-11 st
	s AccOrdExec=##class(web.DHCEMConsultCom).GetEmSysConfig("ACCORDEXEC",HospID) //会诊完成是否自动执行会诊医嘱，1:不自动，其他：自动 //ed
	TS
	/// 修改状态
	s Err = ..InsCsItemStatus(CstID,ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11^修改状态失败！"
	
	/// 插入操作日志
	s Err = ..InsConsultLog(CstID,ItmID,UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13^插入日志失败！"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-14^主表状态修改失败！"
	
	/// 执行请会诊医嘱
	s Err = ..ExeCsMasCOeori(CstID,ItmID,UserID,"C",AccOrdExec)
	i Err'=0 tro
	Q:Err'=0 "-15^撤销会诊医嘱失败!返回值:"_Err
	
	i (IsDocaCst=1) s Err = ..UpdCstNoAnti(CstID,"")
	i Err'=0 tro
	Q:Err'=0 "-16^抗菌药结论修改失败！"
	
	i (IsDocaCst=1) s Err = ##class(DHCAnt.KSS.MainBusiness).DBChangeConsultStatusNew(CstID,UserID,"CE")  //抗生素撤销完成置撤销状态
	i Err'=0 tro
	Q:Err'=0 "-17^抗菌药撤销接口撤销失败！"
	
	///置会诊完成时间
	s Err = ..UpdCstCmpDate(CstID,ItmID,UserID,"","")
	i Err'=0 tro
	Q:Err'=0 "-18^记录完成时间失败!"
	
#;	///医生会诊取消完成会诊时调用电子病历接口修改状态 2021-06-04 st
#;	i ECType["DOC" s Err=##Class(web.DHCEMConsultCom).RevCompForEmr(CstID)
#;	i Err'=0 tro
#;	Q:Err'=0 "-19^调用电子病历接口修改状态失败！" //ed
	
	/// 医生会诊取消完成时调用推送数据给电子病历 2022-03-02 st
	i ECType["DOC" s Err=##Class(web.DHCEMConsultCom).SetDataForEmr(CstID,"","","取消完成")
	i Err'=0 tro
	Q:Err'=0 "-19^推送数据给电子病历失败！" //ed
	
	/// 调用平台组方法 hxy 2022-12-26
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(CstID,ItmID,UserID,"CONCCOMPLETED","51","",LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-20^调用平台状态统一存储接口存储状态失败！"
	
	TC
	Q Err
}

/// Descript: 会诊申请插入医嘱
/// w ##Class(web.DHCEMConsult).InsCstOeori("61")
ClassMethod InsCstOeori(CstID As %String) As %String
{
	n (CstID,%session)
	s EpisodeID=$p(^DHCEMCON(CstID),"^",1)   /// 就诊ID
	s EmgFlag=$p(^DHCEMCON(CstID),"^",23)    /// 加急
	s LocID=$p(^DHCEMCON(CstID),"^",2)       /// 科室ID
	s UserID=$p(^DHCEMCON(CstID),"^",5)      /// 用户ID
	s CstOutFlag=$p(^DHCEMCON(CstID),"^",24)     /// 是否院外
	
	s Err=0, CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.Q:$p(^DHCEMCON(CstID,"I",CH),"^",9)'=""
	.s recLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)   /// 接收科室ID
	.i CstOutFlag="Y" s recLocID=LocID 
	.s arcimid=..GetCstOeori(CstID, "A")            /// 提取会诊配置医嘱
	.i arcimid="" s Err="-2"
	.Q:arcimid=""
	.s CstItmID=CstID_"||"_CH
	.s itmmaststr = arcimid_"^"_recLocID_"^"_CstItmID
	.s OrdNotes=""
	.i CstOutFlag'="Y" D
	..s CstLocID = $p(^DHCEMCON(CstID,"I",CH),"^",1)
	..s CstLocDesc = $p($g(^CTLOC(+CstLocID)),"^",2) //hxy 2021-06-17 +$g
	..s OrdNotes = "请"_CstLocDesc_"会诊"
	..i CstLocDesc="" d
	...s LeadLocID = $p(^DHCEMCON(CstID,"I",CH),"^",12)
	...s LeadLocDesc = $p($g(^DHCEMCG(+LeadLocID)),"^",2)  //大科描述
	...s OrdNotes = "请"_LeadLocDesc_"会诊"
	.;s ret=##Class(web.DHCAPPExaReport).SaveOrderItems(EpisodeID,itmmaststr,UserID,LocID,EmgFlag,OrdNotes,"","","","","N") /// 插入医嘱
	.s ret=##Class(web.DHCEMConsult).SaveOrderItems(EpisodeID,itmmaststr,UserID,LocID,EmgFlag,OrdNotes,"","","","","N") /// 插入医嘱
	.i ret=100 s Err=-1
	.Q:ret=100
	.s Oeori=$p(ret,"*",2)  /// 医嘱ID
	.s Err=..UpdConsROeori(CstID_"||"_CH, Oeori)
	.
	Q Err
}

/// Descritp:  插入会诊医嘱
/// ;ItmID: 302||1   4635
/// w ##Class(web.DHCEMConsult).InsCstCOeori("44||1","","")
ClassMethod InsCstCOeori(CstItID As %String, LgUserID As %String, LgLocID As %String) As %String
{
	n (CstItID, LgUserID, LgLocID,%session)
	s CstID=+CstItID, CH=$p(CstItID,"||",2)
	s EpisodeID=$p(^DHCEMCON(CstID),"^",1)   /// 就诊ID
	s EmgFlag=$p(^DHCEMCON(CstID),"^",23)    /// 加急
	s LocID=$p(^DHCEMCON(CstID),"^",2)       /// 科室ID
	s UserID=$p(^DHCEMCON(CstID),"^",5)      /// 用户ID
	s LgHospID=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(LgLocID)
	s COMPORDRECLOC=##class(web.DHCEMConsultCom).GetEmSysConfig("COMPORDRECLOC",LgHospID)	///医嘱接收科室 1：会诊科室，2：申请科室，默认：当前登录科室
	
	s CareProvID=+$p(^DHCEMCON(CstID,"I",CH),"^",2) /// 会诊医生ID
	i CareProvID=0 s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",3)
	s UserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	i UserID="" s UserID=LgUserID
	s recLocID=+$p(^DHCEMCON(CstID,"I",CH),"^",1)   /// 接收科室ID
	s Params=recLocID_"^"_UserID
	s arcimid=..GetCstOeori(CstID, "E", Params)     /// 提取会诊配置医嘱
	i arcimid="" s Err="-1"
	Q:arcimid="" Err
	s OrdRecLocID=$case(COMPORDRECLOC,1:recLocID,2:LocID,:LgLocID)
	s itmmaststr = arcimid_"^"_OrdRecLocID_"^"_CstItID //recLocID   /// 会诊医嘱
	;开单科室和开单人为当前登录科室和登录人,为接口第三个和第四个参数 qqa 2020-09-08
	;s ret=##Class(web.DHCAPPExaReport).SaveOrderItems(EpisodeID,itmmaststr,LgUserID,LgLocID,EmgFlag,"","","","","","N") /// 插入医嘱
	s ret=##Class(web.DHCEMConsult).SaveOrderItems(EpisodeID,itmmaststr,LgUserID,LgLocID,EmgFlag,"","","","","","N") /// 插入医嘱
	i ret=100 s Err=-2
	Q:ret=100 Err
	s Oeori=$p(ret,"*",2)  /// 医嘱ID
	s Err=..UpdConsCOeori(CstID_"||"_CH, Oeori)
	Q:Err'=0 Err
	Q 0
}

/// Descritp:  设置会诊完成时间
ClassMethod UpdCstCmpDate(CstID, CstItmID, UserID, CmpDate, CmpTime) As %String
{
	n (CstID, CstItmID, UserID, CmpDate,CmpTime)
	s Err=0, CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.Q:(CstItmID'="")&(CstItmID'=(CstID_"||"_CH))
	.s Err=..UpdCstItmCmpDate(CstID_"||"_CH, UserID, CmpDate,CmpTime)
	q:Err'=0 Err
	s:CstItmID="" Err=..UpdCstMastCmpDate(CstID,CmpDate,CmpTime)
	
	Q Err
}

/// Descritp:  插入会诊医嘱
ClassMethod InsCstMasCOeori(CstID As %String, ItmID As %String, UserID As %String, LgLocID As %String) As %String
{
	n (CstID, ItmID, UserID, LgLocID,%session)
	s Err=0, CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.Q:(ItmID'="")&(ItmID'=(CstID_"||"_CH))
	.s Err=..InsCstCOeori(CstID_"||"_CH, UserID, LgLocID)
	.
	Q Err
}

/// Descritp:  更新会诊明细
ClassMethod UpdConsROeori(CstItmID As %String, Oeori As %String) As %String
{
	n (CstItmID, Oeori)
	&SQL(update DHC_EmConsultItm set EC_ROeori_Dr=:Oeori where EC_RowID=:CstItmID)
	Q SQLCODE
}

/// Descritp:  更新会诊明细
ClassMethod UpdConsCOeori(CstItmID As %String, Oeori As %String) As %String
{
	n (CstItmID, Oeori)
	&SQL(update DHC_EmConsultItm set EC_COeori_Dr=:Oeori where EC_RowID=:CstItmID)
	Q SQLCODE
}

/// Descritp:  更新会诊意见
ClassMethod UpdConsOpin(CstItmID As %String, Opinion As %String) As %String
{
	n (CstItmID, Opinion)
	&SQL(update DHC_EmConsultItm set EC_Opinion=:Opinion where EC_RowID=:CstItmID)
	Q SQLCODE
}

/// 更新完成时间
ClassMethod UpdCstMastCmpDate(CstID, CmpDate, CmpTime)
{
	n (CstID,CmpDate,CmpTime)
	&SQL(update DHC_EmConsult set EC_CDate=:CmpDate,EC_CTime=:CmpTime where EC_RowID=:CstID)
	Q SQLCODE
}

/// Descritp:  更新会诊明细
ClassMethod UpdConsStatus(CstID As %String, StatusCode As %String) As %String
{
	n (CstID, StatusCode)
	&SQL(update DHC_EmConsult set EC_RStatus=:StatusCode where EC_RowID=:CstID)
	Q SQLCODE
}

/// Descritp:  更新会诊明细状态
ClassMethod UpdCsItemStatus(CstItmID As %String, StatusCode As %String) As %String
{
	n (CstItmID, StatusCode)
	&SQL(update DHC_EmConsultItm set EC_ExeStatus=:StatusCode where EC_RowID=:CstItmID)
	Q SQLCODE
}

/// Descritp:  修改会诊申请状态值
ClassMethod InsCsItemStatus(CstID As %String, ItmID As %String, UserID As %String) As %String
{
	n (CstID, ItmID, UserID)
	s Err=0, CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.Q:(ItmID'="")&(ItmID'=(CstID_"||"_CH))
	.s Err=..UpdCsItemStatus(CstID_"||"_CH, UserID)
	.
	Q Err
}

/// Descritp:  修改会诊申请状态值
ClassMethod InsCsItemSStatus(ItmS As %String, StatusID As %String) As %String
{
	n (ItmS, StatusID)
	s Err=0
	s Len = $L(ItmS,"^")
	F i=1:1:Len Q:Err'=0  D
	.s Itm=$p(ItmS,"^",i)    /// 项目列表
	.s Err=..UpdCsItemStatus(Itm, StatusID)
	Q Err
}

/// Descritp:  发送会诊时,修改会诊申请申请日期时间
ClassMethod InsCsReqTime(CstID As %String) As %String
{
	n (CstID)
	s CsRDate=+$H   		            ///申请日期
	s CsRTime=$p($H,",",2)              ///申请时间
	&SQL(update DHC_EmConsult set EC_RDate=:CsRDate,EC_RTime=:CsRTime where EC_RowID=:CstID)
	Q SQLCODE
}

/// Descritp:  更新会诊结论
ClassMethod UpdCstNoMdt(CstID As %String, CstOpinion As %String) As %String
{
	n (CstID, CstOpinion)
	&SQL(update DHC_EmConsult set EC_TreMeasures=:CstOpinion where EC_RowID=:CstID)
	Q SQLCODE
}

/// Descritp:  更新会诊结论
/// w ##class(web.DHCEMConsult).UpdCstNoAnti("138","Y")
ClassMethod UpdCstNoAnti(CstID As %String, AntiOpinion As %String) As %String
{
	n (CstID, AntiOpinion)
	&SQL(update DHC_EmConsult set EC_ConsentAnti=:AntiOpinion where EC_RowID=:CstID)
	Q SQLCODE
}

/// Descritp:  更新完成时间
ClassMethod UpdCstItmCmpDate(CstItmID, UserID, CmpDate, CmpTime) As %String
{
	n (CstItmID, UserID, CmpDate,CmpTime)
	&SQL(update DHC_EmConsultItm set EC_CompDate=:CmpDate, EC_CompTime=:CmpTime where EC_RowID=:CstItmID)
	Q SQLCODE
}

/// Descritp:  更新时间
ClassMethod UpdCsItemTime(CstItmID As %String, UserID As %String, Parmas As %String) As %String
{
	n (CstItmID, UserID, Parmas)
	s CareProvID=$p($g(^SSU("SSUSR",UserID)),"^",14)
	s PrvTpID=""
	i CareProvID'="" D
	.s PrvTpID=$p(^CTPCP(CareProvID,1),"^",4)

	s CstDate=$p(Parmas,"^",1)
	s:CstDate'="" CstDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(CstDate)
	s CstTime=$p(Parmas,"^",2)
	s:CstTime'="" CstTime=$zth(CstTime,1)
	i CstDate="" s CstDate=+$H   		             ///操作日期
	i CstTime="" s CstTime=$p($H,",",2)              ///操作时间
	&SQL(update DHC_EmConsultItm set EC_PrvTp_Dr=:PrvTpID,EC_CDoc_Dr=:CareProvID, EC_CDate=:CstDate, EC_CTime=:CstTime where EC_RowID=:CstItmID)
	Q SQLCODE
}

/// Descritp:  插入会诊人员及会诊时间
ClassMethod InsCsItemTime(CstID As %String, ItmID As %String, UserID As %String) As %String
{
	n (CstID, ItmID, UserID)
	s Err=0, CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.Q:(ItmID'="")&(ItmID'=(CstID_"||"_CH))
	.s Err=..UpdCsItemTime(CstID_"||"_CH, UserID, "")
	.
	Q Err
}

/// Descritp:  插入会诊医嘱
/// w ##Class(web.DHCEMConsult).GetCstOeori("160","E","121^11885")
ClassMethod GetCstOeori(CstID As %String, InsCstCode As %String, Params As %String = "") As %String
{
	n (CstID, InsCstCode, Params)
	s CurHospID="" //hxy 2019-12-24 st
	s RLocID=$p($g(^DHCEMCON(+CstID)),"^",2)  /// 申请科室
	s CurHospID=$p($g(^CTLOC(RLocID)),"^",22) //ed
	i InsCstCode="A" D
	.s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	.s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	E  D
	.s CstRLocID=$p(Params,"^",1)  /// 会诊科室
	.s CstUserID=$p(Params,"^",2)  /// 会诊医生
	s PrvTpID="",PrvTp=""
	s CareProvID=$p($g(^SSU("SSUSR",+CstUserID)),"^",14)
	i CareProvID'="" s PrvTpID=$p(^CTPCP(CareProvID,1),"^",4)
	s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	s ConsultType=$s(CstOutFlag="Y":"O",1:"I")
	s ConsultType=$p($g(^DHCEMCON(+CstID)),"^",8)   /// 会诊类型 //hxy 2021-02-27
	s CsPropID=$p(^DHCEMCON(CstID),"^",45)   /// 会诊性质
	s TmpID=""
	/// 职称不为空 按照 会诊类型 医生职称 科室 匹配
	i PrvTpID'="" D
	.s ID=""
	.F  s ID=$o(^DHCEMCONSOC(0,"InsType",InsCstCode,ConsultType,CstRLocID,PrvTpID,ID)) Q:ID=""  D
	..s PropID=$p(^DHCEMCONSOC(ID),"^",6)      /// 会诊性质
	..i CsPropID=PropID s TmpID=ID
	..i (PropID="")&(TmpID="") s TmpID=ID
	.
	/// 职称为空
	i TmpID=""  D
	.s ID=""
	.F  s ID=$o(^DHCEMCONSOC(0,"InsTypeLoc",InsCstCode,ConsultType,CstRLocID,ID)) Q:ID=""  D
	..Q:$p(^DHCEMCONSOC(ID),"^",4)'=""         /// 职称
	..s PropID=$p(^DHCEMCONSOC(ID),"^",6)      /// 会诊性质
	..i CsPropID=PropID s TmpID=ID
	..i (PropID="")&(TmpID="") s TmpID=ID
	.
#;	/// 全院 职称不为空
#;	i (PrvTpID'="")&(TmpID="") D
#;	.s ID=""
#;	.F  s ID=$o(^DHCEMCONSOC(0,"InsType",InsCstCode,ConsultType,"ALL",PrvTpID,ID)) Q:ID=""  D
#;	..s PropID=$p(^DHCEMCONSOC(ID),"^",6)      /// 会诊性质
#;	..i CsPropID=PropID s TmpID=ID
#;	..i (PropID="")&(TmpID="") s TmpID=ID
#;	.
	/// 全院 职称不为空 //hxy 2019-12-25
	i (PrvTpID'="")&(TmpID="")&(CurHospID'="") D
	.s ID=""
	.F  s ID=$o(^DHCEMCONSOC(0,"InsTypeHosp",InsCstCode,ConsultType,"ALL",PrvTpID,CurHospID,ID)) Q:ID=""  D
	..s PropID=$p(^DHCEMCONSOC(ID),"^",6)      /// 会诊性质
	..i CsPropID=PropID s TmpID=ID
	..i (PropID="")&(TmpID="") s TmpID=ID
	.
	/// 全院 职称为空
	i TmpID=""  D
	.s ID=""
	.F  s ID=$o(^DHCEMCONSOC(0,"InsTypeLoc",InsCstCode,ConsultType,"ALL",ID)) Q:ID=""  D
	..Q:$p(^DHCEMCONSOC(ID),"^",4)'=""         /// 职称
	..s PropID=$p(^DHCEMCONSOC(ID),"^",6)      /// 会诊性质
	..s HospDr=$p(^DHCEMCONSOC(ID),"^",7)      /// 医院 //hxy 2019-12-24 st
	..s:PropID=0 PropID="" //hxy 2020-03-10
	..i (CsPropID=PropID)&((HospDr=CurHospID)&(CurHospID'="")) s TmpID=ID  ;i CsPropID=PropID s TmpID=ID 
	..i (PropID="")&(TmpID="")&((HospDr=CurHospID)&(CurHospID'="")) s TmpID=ID ;i (PropID="")&(TmpID="") s TmpID=ID //ed
	.
	
	Q:TmpID="" ""
	s itmmastid=$p(^DHCEMCONSOC(TmpID),"^",2)  /// 会诊医嘱
	Q itmmastid
}

/// Descript: 插入会诊审核数据
/// w ##Class(web.DHCEMConsult).InsConsAudit("154","29^95^10209","123^2019-12-26^23:00^95^10209"_$c(2)_"124^221^1^^^154||1")
ClassMethod InsConsAudit(CstID As %String, LgParams As %String, mListData As %String) As %String
{
	n (CstID, LgParams, mListData)
	s Err=0
	s LgLocID= $p(LgParams,"^",2)
	s UserID=$p(LgParams,"^",3) /// 用户ID
	/// 当前会诊状态的下一个状态ID
	s StatusID=##Class(web.DHCEMConsultWorkFlow).GetGrantStCode(CstID, LgParams)
	Q:StatusID="" "-2"
	s ItmID=..GetItmID(StatusID,UserID,mListData) //hxy 2021-06-21 对于大科住院总的审核，特殊处理
	// 申请状态
	Q:..GetIsModFlag(CstID,5) "-3^该会诊已取消!"
	
	s StatusCode=$p(^DHCEMCONS(StatusID),"^",1)
	s NodeCode=""
	s:StatusCode=71 NodeCode="CONDIRAUDIT"
	s:StatusCode=72 NodeCode="CONMEDAUDIT"
	
	TS

	/// 会诊审核
	s CstID=..UpdConsMasNDate(CstID,mListData)
	i CstID<0 tro
	Q:CstID<0 CstID
	
	/// 会诊子表
	s ListData=$p(mListData,$C(2),2)
	s Err=..InsCsItmAudit(CstID, ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/// 修改状态
	i ItmID["^" s Err = ..InsCsItemSStatus(ItmID,StatusID) 
	e  s Err = ..InsCsItemStatus(CstID,ItmID,StatusID)
	;s Err = ..InsCsItemStatus(CstID,"",StatusID) //
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 插入操作日志
	i ItmID["^" s Err = ..InsConsultLogByItmS(ItmID,UserID,StatusID) 
	e  s Err = ..InsConsultLog(CstID,ItmID,UserID,StatusID)
	;s Err = ..InsConsultLog(CstID,"",UserID,StatusID) //
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-15"
	
	/// 小信箱
	s Err = ..InsWebsysMessage(CstID,UserID,"Y")
	i Err<0 tro
	Q:Err<0 "-16"
	
	/// 调用平台组方法 hxy 2022-12-28
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(CstID,"",UserID,NodeCode,StatusCode,"",LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-17" //^调用平台状态统一存储接口存储状态失败！
	TC
	
	/// 小信箱-执行会诊审核消息 2021-04-07
	D ..InvExecAudit(CstID,UserID)
	
	/// 小信箱 2021-04-07 会诊如果是配置需审核流程时，申请医师发送成功后，需要给审核的人员发送消息；
	D ..SendmessageForAuditor(CstID,UserID)

	Q CstID
}

/// Descript: 撤销会诊审核
/// w ##Class(web.DHCEMConsult).InsRevConsAudit("1261","30^53^13236")
ClassMethod InsRevConsAudit(CstID As %String, LgParams As %String) As %String
{
	n (CstID, LgParams)

	s Err=0
	s LgLocID= $p(LgParams,"^",2)
	s UserID=$p(LgParams,"^",3) /// 用户ID
	/// 取当前会诊状态的上一个状态ID
	s StatusID=##Class(web.DHCEMConsultWorkFlow).GetGrantPrevStCode(CstID)
	Q:StatusID="" -1
	;Q:..IsPermitRev(CstID, LgParams) -1
	
	s CycleCode=..GetRevAuditCycleCode(CstID) //hxy 2021-07-16
    s ItmID=..GetItmIdByLogOnCstID(CstID,UserID,75)  //guoguomin 20211202 通过主表id获取大科审核得子表id
    Q:..IsPermitRev(CstID, LgParams,ItmID) -1
    
	s NodeCode=""
	s:CycleCode=801 NodeCode="CONDIRUNAPPROVE" //科主任取消审核
	s:CycleCode=802 NodeCode="CONMEDUNAPPROVE" //医务部取消审核
	
	TS
	
	/// 会诊审核
	s Err=..RevConsMasAudit(CstID)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/// 修改状态
	;s Err = ..InsCsItemStatus(CstID,"",StatusID)
	;i Err'=0 tro
	;Q:Err'=0 "-13"
	
	/// 插入操作日志
	;s ID=..GetConsStatus(80)  /// 取消审核状态
	;s Err = ..InsConsultLog(CstID,"",UserID,ID,"",CycleCode)
	b ;11
    /// 修改状态
	i ItmID["^" s Err = ..InsCsItemSStatus(ItmID,StatusID) 
	e  s Err = ..InsCsItemStatus(CstID,ItmID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 插入操作日志
	s ID=..GetConsStatus(80)  /// 取消审核状态
	i ItmID["^" s Err = ..InsConsultLogByItmS(ItmID,UserID,StatusID,"",CycleCode)
	e  s Err = ..InsConsultLog(CstID,ItmID,UserID,ID,"",CycleCode)
	
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-15"
	
	/// 执行信封消息
	D ..InvExecMes(CstID,"",UserID,"Y")
	i Err<0 tro
	Q:Err<0 "-16"
	
	/// 调用平台组方法 hxy 2022-12-30
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(CstID,"",UserID,NodeCode,CycleCode,"",LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-17" //^调用平台状态统一存储接口存储状态失败！
	
	TC
	
	Q CstID
}

/// Descritp:  是否允许撤销申请
/// InPut:     CstID - 会诊ID
/// OutPut:    0-允许,1-不允许
/// W ##Class(web.DHCEMConsult).IsPermitRev("1264","30^113^12175")
ClassMethod IsPermitRev(CstID As %String, LgParams, ItmID As %String = "") As %String
{
	n (CstID, LgParams,ItmID)
	s StatusCode=##Class(web.DHCEMConsultWorkFlow).GetUserGrantStCode(CstID, LgParams) /// 取用户权限对应会诊工作流状态Code

	Q:'..GetAllConsIsModFlag(CstID,StatusCode,ItmID) 1
	Q 0
}

/// Descript: 修改会诊申请子表
/// w ##Class(web.DHCEMConsult).InsCsRefAudit("91","9056","FF")
ClassMethod InsCsItmAudit(CstID As %String, mListData As %String) As %String
{
	n (CstID, mListData)
	s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	Q:CstOutFlag="Y" 0
	s Err=0
	F i=1:1:$L(mListData,"@") Q:Err'="0"  D
	.s ListData=$p(mListData,"@",i)    /// 项目列表
	.s itmID=$p(ListData,"^",6)        /// 会诊子表ID
	.i itmID="" s Err=..InsConItm(CstID, ListData)
	.E  s Err=..UpdConItm(itmID, ListData)
	.
	Q Err
}

/// Descript: 更新会诊申请子表
/// w ##Class(web.DHCEMConsult).UpdConItm("91","9056","FF")
ClassMethod UpdConItm(itmID As %String, ListData As %String) As %String
{
	n (itmID, ListData)
	s CstCLocID=$p(ListData,"^",1)    /// 会诊科室
	s CstNDocID=$p(ListData,"^",2)    /// 要求会诊医生
	s PrvTpID=$p(ListData,"^",3)      /// 医生职称
	s SubMarID=$p(ListData,"^",4)     /// 亚专业
	s CstGrpID=$p(ListData,"^",5)     /// 会诊小组
	&SQL(Update DHC_EmConsultItm Set EC_CLoc_Dr=:CstCLocID,EC_NDoc_Dr=:CstNDocID,EC_PrvTp_Dr=:PrvTpID,EC_SubMar_Dr=:SubMarID,EC_Grp_Dr=:CstGrpID where EC_RowID=:itmID)
	Q SQLCODE
}

/// Descript: 插入会诊审核数据
/// w ##Class(web.DHCEMConsult).InsCsRefAudit("61")
ClassMethod InsCsRefAudit(CstID As %String, UserID As %String, CstNote As %String, LgParams As %String) As %String
{
	n (CstID, UserID, CstNote,LgParams)

	s Err=0
	s LgLocID= $p(LgParams,"^",2)
	s StatusID=..GetConsStatus(22)
	/// 申请状态
	Q:('..GetIsModFlag(CstID,20))&&('..GetIsModFlag(CstID,71))&&('..GetIsModFlag(CstID,73))&&('..GetIsModFlag(CstID,72)) "-1" //hxy 2020-08-13 原：Q:'..GetIsModFlag(CstID,20) "-1"
	
	s CycleCode=..GetRefAuditCycleCode(CstID) //hxy 2021-07-16
	
	s NodeCode=""
	s:CycleCode=221 NodeCode="CONDIRREJECT" //科主任驳回
	s:CycleCode=222 NodeCode="CONMEDREJECT" //医务部驳回
	
	TS

	/// 修改状态
	s Err = ..InsCsItemStatus(CstID,"",StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 插入操作日志
	s Err = ..InsConsultLog(CstID,"",UserID,StatusID,CstNote,CycleCode)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 医生会诊驳回时调用推送数据给电子病历 2022-03-02 st
	s ECType = $p(^DHCEMCON(CstID),"^",19)
	i ECType["DOC" s Err=##Class(web.DHCEMConsultCom).SetDataForEmr(CstID,"","","驳回")
	i Err'=0 tro
	Q:Err'=0 "-14" //ed
	
	/// 调用平台组方法 hxy 2022-12-30
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(CstID,"",UserID,NodeCode,CycleCode,CstNote,LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-15" //^调用平台状态统一存储接口存储状态失败！
	
	TC
	
	/// 小信箱 hxy 2021-04-07
	D ..SendmessageByRej(CstID,UserID,CstNote)
	/// 小信箱-执行会诊审核消息 2021-04-07
	D ..InvExecAudit(CstID,UserID)
	
	Q Err
}

/// Descript: 会诊审核驳回后，增加消息推送功能，推送给申请医师，当前会诊已驳回并显示驳回原因
///           会诊拒收，增加消息推送功能，推送给申请医师，会诊已拒收;
/// Input : 主表ID，审核人ID/拒绝人ID，(驳回)原因，拒绝接收类型默认空
/// w ##Class(web.DHCEMConsult).SendmessageByRej("134","12175","驳回0407")
/// w ##Class(web.DHCEMConsult).SendmessageByRej("138","13236","拒绝0407","Ref")
ClassMethod SendmessageByRej(CstID, UserID, CstNote, ReType = "") As %String
{
	n (CstID,UserID,CstNote,ReType)
	s EpisodeID = $p(^DHCEMCON(CstID),"^",1)
	s CsRLocID=$p(^DHCEMCON(CstID),"^",2)      ///申请科室
	s ReceiveDocs = $p(^DHCEMCON(CstID),"^",5) ///申请人
	q:(EpisodeID="")||(CsRLocID="")||(ReceiveDocs="") ""
	s MesCode="1220"
	s ToLocRowId=CsRLocID_"|OnlyFlag"
	s CstMes="当前会诊已驳回,原因:"_CstNote
	i ReType="Ref" d
	.s MesCode="1221"
	.s:CstNote="" CstMes="会诊已拒收"
	.s:CstNote'="" CstMes="会诊已拒收,原因:"_CstNote
	s Ret=##class(websys.DHCMessageInterface).Send(CstMes,MesCode,UserID,EpisodeID,"",ReceiveDocs,"",ToLocRowId)
	q Ret
}

/// Descritp:  撤销审核:清审核科室/空审核人/审核日期/申请时间
ClassMethod RevConsMasAudit(CstID As %String) As %String
{
	n (CstID)
	&SQL(Update DHC_EmConsult Set EC_ALoc_Dr=NULL,EC_AUser_Dr=NULL,EC_ADate=NULL,EC_ATime=NULL Where EC_RowID=:CstID)
	 Q SQLCODE
}

/// Descritp:  更新会诊主表会诊日期和会诊地点
ClassMethod UpdConsMasNDate(CstID As %String, mListData As %String) As %String
{
	n (CstID, mListData)
	s ListData=$p(mListData,$C(2))
	s CsNPlace=$p(ListData,"^",1)	  ///会诊地点
	s CsNDate=$p(ListData,"^",2)      ///会诊日期
	s CsNDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(CsNDate)
	s CsNTime=$p(ListData,"^",3)      ///会诊时间
	s:CsNTime'="" CsNTime=$zth(CsNTime,1)
	s LocID=$p(ListData,"^",4)        ///审核科室
	s UserID=$p(ListData,"^",5)       ///审核人
	s CstADate=+$H   		          ///审核日期
	s CstATime=$p($H,",",2)           ///审核时间
	&SQL(Update DHC_EmConsult Set EC_NDate=:CsNDate,EC_NTime=:CsNTime,EC_NPlace=:CsNPlace,EC_ALoc_Dr=:LocID,EC_AUser_Dr=:UserID,EC_ADate=:CstADate,EC_ATime=:CstATime Where EC_RowID=:CstID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descritp:  插入会诊医生操作记录
ClassMethod InsConsLog(CstID As %String, UserID As %String, StatusID As %String, CstNote As %String = "", CycleCode = "") As %String
{
	n (CstID, UserID, StatusID, CstNote,CycleCode)
	s CstDate=+$H   		            ///操作日期
	s CstTime=$p($H,",",2)              ///操作时间
	&SQL(Insert into DHC_EmConsultLog(ECL_Cst_Ref,ECL_User_Dr,ECL_Status_Dr,ECL_Date,ECL_Time,ECL_Notes,ECL_CycleCode) 
		values(:CstID,:UserID,:StatusID,:CstDate,:CstTime,:CstNote,:CycleCode))
	Q SQLCODE
}

/// Descritp:  插入会诊申请操作记录
ClassMethod InsConsultLog(CstID As %String, ItmID As %String, UserID As %String, StatusID As %String, CstNote As %String = "", CycleCode = "") As %String
{
	n (CstID, ItmID, UserID, StatusID, CstNote,CycleCode)
	s CH="", Err=0
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.Q:(ItmID'="")&(ItmID'=(CstID_"||"_CH))
	.s Err=..InsConsLog(CstID_"||"_CH, UserID, StatusID, CstNote,CycleCode)
	.
	Q Err
}

/// Descritp:  插入会诊申请操作记录
ClassMethod InsConsultLogByItmS(ItmS As %String, UserID As %String, StatusID As %String, CstNote As %String = "", CycleCode = "") As %String
{
	n (ItmS, UserID, StatusID, CstNote,CycleCode)
	s Err=0
	s Len = $L(ItmS,"^")
	F i=1:1:Len Q:Err'=0  D
	.s Itm=$p(ItmS,"^",i)
	.s Err=..InsConsLog(Itm, UserID, StatusID, CstNote,CycleCode)
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2018-09-21
/// Descript:   插入会诊打印标志
/// InPut:      CstID - 会诊申请ID
/// OutPut:     0-成功，其他-失败
ClassMethod InsCsMasPrintFlag(CstID As %String) As %String
{
	n (CstID)
	s PrintFlag="Y"        ///审核时间
	&SQL(update DHC_EmConsult set EC_PrintFlag=:PrintFlag Where EC_RowID=:CstID)
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2018-09-28
/// Descript:   修改会诊主表状态
/// InPut:      CstID - 会诊申请ID, StatusID - 状态ID
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMConsult).InsCsMasStatus("2","6")
ClassMethod InsCsMasStatus(CstID As %String, StatusID As %String) As %String
{
	n (CstID, StatusID)
	s CH="", Flag=0, Err=0
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.Q:$p(^DHCEMCON(CstID,"I",CH),"^",6)=StatusID
	.s Flag=1
	.
	i Flag=0 s Err=..UpdConsStatus(CstID, StatusID)
	i (Flag=1)&&(StatusID=23) s Err=..UpdConsStatus(CstID, StatusID)   ///guoguomin 20211204 大科取消审核时候也要变更主表状态
	Q Err
}

/// Descritp:  取消信封消息
/// w ##Class(web.DHCEMConsult).InvExecMes("1129","","12175","C")
ClassMethod InvExecMes(CstID As %String, ItmID As %String, UserID As %String, morMesFlag As %String) As %String
{
	n (CstID, ItmID, UserID, morMesFlag)
	s morMesFlag = $g(morMesFlag)
	Q:$p(^DHCEMCON(CstID),"^",24)="Y" 0      /// 是否院外
	s MoreFlag = $p(^DHCEMCON(CstID),"^",31) /// 是否多科
	Q:(MoreFlag="Y")&(morMesFlag="") 0       /// 多可会诊这里给Y
#;	s CstTypeID=$p(^DHCEMCON(CstID),"^",8)   /// 会诊类型
#;	s isCsAuditFlag=##Class(web.DHCEMConsultCom).isCsAudit(CstTypeID)
#;	Q:(isCsAuditFlag)&(morMesFlag="") 0
	i morMesFlag="C" D ##Class(web.DHCEMConsult).InvExecAudit(CstID, UserID)
	s CH="",Err=0
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.Q:(ItmID'="")&(ItmID'=(CstID_"||"_CH))
	.s Err=..InvExec(CstID_"||"_CH, UserID)
	.
	Q Err
}

/// Descritp:  执行信封消息
/// w ##Class(web.DHCEMConsult).InvExec("3","4634")
ClassMethod InvExec(itmID As %String, UserID As %String) As %String
{
	n (itmID, UserID)
	s EpisodeID = $p(^DHCEMCON(+itmID),"^",1)
	//Q:$p(^DHCEMCON(+itmID),"^",31)="Y" 0    /// 是否多科
	Q:$p(^DHCEMCON(+itmID),"^",24)="Y" 0      /// 是否院外
	s CsPropID=$p(^DHCEMCON(+itmID),"^",45)     /// 会诊性质
	s CsProp=$p($g(^DHCEMCDI(+CsPropID)),"^",2) 	/// 会诊性质
	s MesCode="1014"
	s:CsProp="急会诊" MesCode="1035"				/// 急会诊
	
	//处理消息
	s Ret = ##class(websys.DHCMessageInterface).Exec("",MesCode,EpisodeID,"",itmID,UserID)
	i Ret="-3" s Ret=0    /// -3 未找到消息
	i Ret="-102" s Ret=0  /// -102 消息已执行过
	q:(Ret<0)&&(Ret'=-102)&&(Ret'=-3) Ret
	s:Ret>0 Ret=0 //hxy 2018-12-09  web.DHCEMConsInterface.UpdCstOpinion接口
	q Ret
}

/// Descritp:  请会诊评价
ClassMethod EvaRCstNo(CstID As %String, LgParam As %String, CsEvaParam As %String) As %String
{
	n (CstID, LgParam, CsEvaParam)
	
	s HospID = $p(LgParam,"^",1)
	s LgLocID = $p(LgParam,"^",2) /// 登录科室
	s UserID= $p(LgParam,"^",4)
	
	s Err=0
	s IsUserSure = ##Class(web.DHCEMConsultCom).ConsStatusCodeIsUse(HospID,"60")   ///是否启用了确认
	s StatusID=..GetConsStatus(70)
	/// 申请状态
	Q:(IsUserSure=1)&('..GetIsModFlag(CstID,60))&('..GetIsModFlag(CstID,79)) "-1" //hxy 2021-01-08 add 79
	Q:(IsUserSure'=1)&'..GetIsModFlag(CstID,50)&'..GetIsModFlag(CstID,55)&('..GetIsModFlag(CstID,79)) "-1" //hxy 2021-01-08 add 79
	TS
	/// 修改状态
	s Err = ..InsCsItemStatus(CstID,"",StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 会诊评价
	s Err = ..InsCsMasEva(CstID,CsEvaParam)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 插入操作日志
	s Err = ..InsConsultLog(CstID,"",UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 调用平台组方法 hxy 2022-12-28
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(CstID,"",UserID,"CONDOCEVA","70","",LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-15" //^调用平台状态统一存储接口存储状态失败！
	
	TC
	Q Err
}

/// Creator:    hxy
/// CreateDate: 2021-01-08
/// Descritp:  请会诊评价-取消评价
ClassMethod CanEvaRCstNo(CstID As %String, LgParam As %String) As %String
{
	n (CstID, LgParam)
	
	s HospID = $p(LgParam,"^",1)
	s LgLocID = $p(LgParam,"^",2) /// 登录科室
	s UserID= $p(LgParam,"^",4)
	
	s Err=0
	s StatusID=..GetConsStatus(79)
	/// 申请状态
	Q:('..GetIsModFlag(CstID,70)) "-1"
	TS
	/// 修改状态
	s Err = ..InsCsItemStatus(CstID,"",StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 会诊评价
	s Err = ..InsCsMasEva(CstID,"")
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 插入操作日志
	s Err = ..InsConsultLog(CstID,"",UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 修改会诊主表状态
	s Err = ..InsCsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 调用平台组方法 hxy 2022-12-28
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(CstID,"",UserID,"CONCDOCEVA","79","",LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-15" //^调用平台状态统一存储接口存储状态失败！
	
	TC
	Q Err
}

/// Descritp:  会诊评价
/// w ##Class(web.DHCEMConsult).EvaCstNo("63||1","83","1^会真的非常好")
ClassMethod EvaCstNo(ItmID As %String, UserID As %String, CsEvaParam As %String, LgParam As %String) As %String
{
	n (ItmID, UserID, CsEvaParam,LgParam)

	s Err=0
	s LgLocID= $p(LgParam,"^",2)
	s StatusID=..GetConsStatus(55)
	/// 申请状态
	Q:('..GetIsModFlag(ItmID,50))&('..GetIsModFlagByLog(ItmID,56)) "-1"
	
	TS
#;	/// 修改状态
#;	s Err = ..UpdCsItemStatus(ItmID,StatusID)
#;	i Err'=0 tro
#;	Q:Err'=0 "-11"
	
	/// 会诊评价
	s Err = ..InsCsMasEvaItm(ItmID,CsEvaParam)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 插入操作日志
	s Err = ..InsConsLog(ItmID,UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 调用平台组方法 hxy 2022-12-26
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(+ItmID,ItmID,UserID,"CONEVALUATION","55","",LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-13" //^调用平台状态统一存储接口存储状态失败！
	TC
	Q Err
}

/// Creator:    hxy
/// CreateDate: 2021-01-09
/// Descritp:  取消会诊评价
/// w ##Class(web.DHCEMConsult).CanEvaCstNo("63||1","83")
ClassMethod CanEvaCstNo(ItmID As %String, UserID As %String, LgParam) As %String
{
	n (ItmID, UserID,LgParam)

	s Err=0
	s LgLocID= $p(LgParam,"^",2)
	s StatusID=..GetConsStatus(56)
	/// 申请状态
	Q:('..GetIsModFlagByLog(ItmID,55))&('..GetIsModFlag(ItmID,61)) "-1"
	
	TS
	/// 会诊评价
	s Err = ..InsCsMasEvaItm(ItmID,"")
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 插入操作日志
	s Err = ..InsConsLog(ItmID,UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 调用平台组方法 hxy 2022-12-26
	s Err = ##Class(web.DHCEMConsultCom).UpdateSystemStatus(+ItmID,ItmID,UserID,"CONCEVALUATION","56","",LgLocID) 
	i Err'=0 tro
	Q:Err'=0 "-14" //^调用平台状态统一存储接口存储状态失败！
	TC
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2018-10-14
/// Descript:   插入请会诊评价
/// InPut:      CstID - 会诊申请ID
/// OutPut:     0-成功，其他-失败
ClassMethod InsCsMasEva(CstID As %String, ConsEvaParam As %String) As %String
{
	n (CstID, ConsEvaParam)
	s ConsEvaFlag=$p(ConsEvaParam,"^",1)
	s ConsEvaDesc=$p(ConsEvaParam,"^",2)
	&SQL(update DHC_EmConsult set EC_EvaFlag=:ConsEvaFlag, EC_EvaDesc=:ConsEvaDesc Where EC_RowID=:CstID)
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2018-10-14
/// Descript:   插入会诊评价
/// InPut:      CstID - 会诊申请ID
/// OutPut:     0-成功，其他-失败
ClassMethod InsCsMasEvaItm(CsItmID As %String, ConsEvaParam As %String) As %String
{
	n (CsItmID, ConsEvaParam)
	s ConsEvaFlag=$p(ConsEvaParam,"^",1)
	s ConsEvaDesc=$p(ConsEvaParam,"^",2)
	&SQL(update DHC_EmConsultItm set EC_EvaFlag=:ConsEvaFlag, EC_EvaDesc=:ConsEvaDesc Where EC_RowID=:CsItmID)
	Q SQLCODE
}

/// Descritp:  调用数据的方法发送会诊消息
/// w ##Class(web.DHCEMConsult).InsWebsysMessage("3","4634")
ClassMethod InsWebsysMessage(CstID As %String, UserID As %String, morMesFlag As %String) As %String
{
	n (CstID, UserID, morMesFlag)
	s EpisodeID = $p(^DHCEMCON(CstID),"^",1)
	s CreatDoc = $p(^DHCEMCON(CstID),"^",5)
	s MoreFlag = $p(^DHCEMCON(CstID),"^",31) /// 是否多科
	/// 当前会诊工作流是否已经审核完
	Q:##Class(web.DHCEMConsultWorkFlow).isWFCompFlag(CstID)'="Y" 0
	//Q:(MoreFlag="Y")&(morMesFlag="") 0
	//Q:$p(^DHCEMCON(CstID),"^",24)="Y" 0    /// 是否院外
	s CstTypeID=$p(^DHCEMCON(CstID),"^",8)   /// 会诊类型
	//s isCsAuditFlag=##Class(web.DHCEMConsultCom).isCsAudit(CstTypeID)
	//Q:(isCsAuditFlag)&(morMesFlag="") 0
	
	//处理消息
	//s Ret = ##class(websys.DHCMessageInterface).Exec("","1014",EpisodeID,"",CstID,UserID)
	//q:(Ret<0)&&(Ret'=-102)&&(Ret'=-3) Ret
	//发送消息
	s Ret = ##Class(web.DHCEMConsult).ProSendmessage(CstID, "")
	
	q Ret
}

/// Descritp:  会诊申请的状态代码
/// w ##Class(web.DHCEMConsult).GetConsStatus("1")
ClassMethod GetConsStatus(CstStatCode As %String) As %String
{
	n (CstStatCode)
	s CstStatID=$o(^DHCEMCONS(0,"Code",$$ALPHAUP^SSUTIL4(CstStatCode),""))
	Q CstStatID
}

/// Descritp:  会诊申请的状态ID
/// w ##Class(web.DHCEMConsult).GetConsStatus("1")
ClassMethod GetConsStatusByDesc(CstStatDesc As %String) As %String
{
	n (CstStatDesc)
	s CstStatID=$o(^DHCEMCONS(0,"Desc",$$ALPHAUP^SSUTIL4(CstStatDesc),""))
	Q CstStatID
}

/// Descript: 会诊申请发送到消息
/// Input : 发送医生，就诊，接收医生，科室ID，申请ID
ClassMethod Sendmessage(CreatDoc, EpisodeID, ReceiveDocs, LocID, ConsultID, CsType) As %String
{
	n (CreatDoc, EpisodeID, ReceiveDocs,LocID,ConsultID,CsType)
	q:CreatDoc="" "-1001"
	q:EpisodeID="" "-1002"
	s CsPropID=$p(^DHCEMCON(+ConsultID),"^",45)     /// 会诊性质
	s CsProp=$p($g(^DHCEMCDI(+CsPropID)),"^",2) 	/// 会诊性质
	s MesCode="1014"
	s:CsProp="急会诊" MesCode="1035"				/// 急会诊
	s LinkUrl="dhcem.consultwrite.csp"
	i CsType="NUR" s LinkUrl="dhcem.consultnur.csp"
	s Url=""""_LinkUrl_"?EpidsodeID="_EpisodeID_"&CstID="_+ConsultID_"&CstItmID="_ConsultID_""""
	s Link="{""link"":"_Url_",""BizObjId"":"_""""_ConsultID_""""_",""dialogWidth"":"_1400_",""dialogHeight"":"_600_"}"
	s ToLocRowId=LocID_"|OnlyFlag"
	s Ret=##class(websys.DHCMessageInterface).Send("有会诊申请",MesCode,CreatDoc , EpisodeID,"",ReceiveDocs, Link,ToLocRowId)
	q Ret
}

/// Descript：发送会诊申请消息
/// w ##class(web.DHCEMConsult).ProSendmessage("3")
ClassMethod ProSendmessage(CstID As %String, mFilters As %String) As %String
{
	n (CstID, mFilters)
	s EpisodeID = $p(^DHCEMCON(CstID),"^",1)
	s CreatDoc = $p(^DHCEMCON(CstID),"^",5)
	s CsType = $p(^DHCEMCON(CstID),"^",19)  /// 会诊类型
	s CarePrvType="*DOCTOR*Pharmacist*"
	i CsType="NUR" s CarePrvType="*NURSE*"
	s CsRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	s CsHospID=$p(^CTLOC(CsRLocID),"^",22)  /// 医院ID
	/// 会诊列表是否按职称级别过滤
	s IsFiltPrvTpFlag=##Class(web.DHCEMConsultCom).GetEmSysConfig("ISFILTPRVTP",CsHospID)
	s ReceiveDocs=""
	s Ret=0
	s EcsSub = 0
	f  s EcsSub= $o(^DHCEMCON(CstID,"I",EcsSub)) q:(EcsSub="")||(Ret<0)  d
	.Q:(mFilters'="")&(EcsSub'>mFilters)
	.s Docs=""
	.s LocID = $p(^DHCEMCON(CstID,"I",EcsSub),"^",1)
	.s CTPCPId = $p(^DHCEMCON(CstID,"I",EcsSub),"^",2)
	.s PrvTpID=$p(^DHCEMCON(CstID,"I",EcsSub),"^",11)       /// 职称
	.i (IsFiltPrvTpFlag'=1)&(IsFiltPrvTpFlag'=2) s PrvTpID=""   /// 不按职称过滤则传值为空
	.q:LocID="" 
	.s:CTPCPId'="" Docs = $o(^SSU("SSUSR",0,"CTPCP",CTPCPId,""))
	.s:CTPCPId="" Docs = ##class(web.DHCEMConsult).GetLocDoc(LocID,CarePrvType,PrvTpID,IsFiltPrvTpFlag)
	.Q:Docs=""
	.s Ret = ##Class(web.DHCEMConsult).Sendmessage(CreatDoc,EpisodeID,Docs,LocID,CstID_"||"_EcsSub,CsType)
	q Ret
}

/// Descript：获取科室里里面所有医生或者护士
/// 	Input: LocID , NURSE/DOCTOR
/// w ##class(web.DHCEMConsult).GetLocDoc("3","DOCTOR")
ClassMethod GetLocDoc(LocID, CareType, PrvTpID, IsFiltPrvTpFlag = "") As %String
{
	n (LocID, CareType, PrvTpID,IsFiltPrvTpFlag)
    s RetDocs=""
    q:LocID="" ""
    s ResID="" 
    f  s ResID = $O(^RB("RES",0,"CTLOC",LocID,ResID)) q:ResID=""  d
	.s ResCTPCPDR = $p(^RB("RES",ResID),"^",2)
	.q:+ResCTPCPDR=0
	.;q:+$g(^CTPCP(ResCTPCPDR,1))=0
	.s CarPrvTpDR = $p(^CTPCP(ResCTPCPDR,1),"^",4) ;CTPCP_CarPrvTp_DR-->CT_CarPrvTp
	.q:+CarPrvTpDR=0							/// 职称为空
	.;Q:(PrvTpID'="")&(CarPrvTpDR'=PrvTpID)     /// 按职称过滤 //hxy 2023-02-20 st
	.Q:(PrvTpID'="")&(CarPrvTpDR'=PrvTpID)&(IsFiltPrvTpFlag'=2) /// 按职称过滤
	.s IsEqHigherPrvTp=""
	.s:IsFiltPrvTpFlag=2 IsEqHigherPrvTp=##Class(web.DHCEMConsultQuery).IsEqHigherPrvTp(PrvTpID,CarPrvTpDR)
	.Q:(PrvTpID'="")&('IsEqHigherPrvTp)&(IsFiltPrvTpFlag=2)     /// 按职称和更高职称过滤 //ed
	.s Type = $p(^CT("CPT",CarPrvTpDR),"^",4)		;CTCPT_InternalType
	.q:CareType'[("*"_Type_"*") ;q:Type'=CareType						    /// 按类型过滤
	.s DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",ResCTPCPDR,""))
	.s:RetDocs'="" RetDocs=RetDocs_"^"_DoctorUserDr
	.s:RetDocs="" RetDocs=DoctorUserDr
	q RetDocs
}

/// w ##class(web.DHCEMConsult).SaveCOT("3","DOCTOR")
ClassMethod SaveCOT(Params) As %String
{
	n (Params)
	
	s COTLoc = $p(Params,"^",1)
    s COTUser = $p(Params,"^",2)
    s COTText = $p(Params,"^",3)
    s COTText =  $REPLACE(COTText,$c(10),"\r")
    &sql(INSERT INTO DHC_EmConsOpinionTemp (COT_Text,COT_Loc_Dr,COT_User_Dr) VALUES (:COTText,:COTLoc,:COTUser))
    q SQLCODE
}

/// w ##class(web.DHCEMConsult).DeleteCot("3")
ClassMethod DeleteCot(CotID As %String)
{
	n (CotID)
	&sql(DELETE FROM DHC_EmConsOpinionTemp WHERE COT_RowID =:CotID)
    q SQLCODE
}

// 重发消息时处理之前的消息

// d ##class(websys.DHCMessageInterface).Exec("","1014",adm,"",ConAppID)

/// Descript:    会诊时间是否合理
ClassMethod ValiCstTime(CstID As %String, Parmas As %String) As %String
{
	n (CstID, Parmas)
	Q:Parmas="" 0
	s CstDate=$p(Parmas,"^",1)       ///会诊日期
	s:CstDate'="" CstDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(CstDate)
	Q:CstDate>$p(^DHCEMCON(CstID),"^",3) 0
	Q:CstDate<$p(^DHCEMCON(CstID),"^",3) 1
	s CstTime=$p(Parmas,"^",2)      ///会诊时间
	s:CstTime'="" CstTime=$zth(CstTime,1)
	Q:CstTime>$p(^DHCEMCON(CstID),"^",4) 0
	Q 1
}

/// Descritp:  是否允许操作
/// W ##Class(web.DHCEMConsult).GetIsOperFlag("164||1","6079")
ClassMethod GetIsOperFlag(CstID As %String, stCode As %String) As %String
{
	n (CstID, stCode)
	/// 申请状态
	Q:'..GetIsModFlag(CstID,stCode) ""
	Q 1
}

/// Creator:    bianshuai
/// CreateDate: 2018-11-21
/// Descritp:   执行请会诊医嘱
/// InPut：     ItmID - 会诊子表ID，UserID - 用户ID，ModFlag - 类型(E-执行、V-撤销)
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMConsult).ExeCsMasROeori("92||1","114||77","E")
ClassMethod ExeCsMasROeori(CstID As %String, ItmID As %String, UserID As %String, ModFlag As %String) As %String
{
	n (CstID, ItmID, UserID, ModFlag)
	s CH="", Err=0
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.Q:(ItmID'="")&(ItmID'=(CstID_"||"_CH))
	.s Oeori=$p(^DHCEMCON(CstID,"I",CH),"^",9)   /// 医嘱ID
	.Q:Oeori=""
	.i ModFlag="E" s Err=..Execute(Oeori, UserID) /// 执行医嘱
	.i ModFlag="V" s Err=..Verify(Oeori, UserID)  /// 撤销执行
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2018-11-21
/// Descritp:   执行会诊医嘱
/// InPut：     ItmID - 会诊子表ID，UserID - 用户ID，ModFlag - 类型(E-执行、C-撤销执行)
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMConsult).ExeCsMasCOeori("92||1","114||77","E")
ClassMethod ExeCsMasCOeori(CstID As %String, ItmID As %String, UserID As %String, ModFlag As %String, AccOrdExec = "") As %String
{
	n (CstID, ItmID, UserID, ModFlag,AccOrdExec)
	s Flag=1 //hxy 2021-05-11 st
	s:AccOrdExec=1 Flag=0 //ed
	s CH="", Err=0
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.Q:(ItmID'="")&(ItmID'=(CstID_"||"_CH))
	.s Oeori=$p(^DHCEMCON(CstID,"I",CH),"^",10)   /// 会诊医嘱ID
	.Q:Oeori=""
	.i ModFlag="E" s Err=..Execute(Oeori, UserID) /// 执行医嘱
	.i ModFlag="C" s Err=..CancelMulti(Oeori, UserID, Flag)  /// 撤销医嘱
	s:Err="-100045" Err=Err_" 医嘱"_..GetOrdStatus(Oeori)

	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2018-11-21
/// Descritp:   更新医嘱状态为执行
/// InPut：     Oeori - 医院，UserID - 用户ID
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMConsult).Execute("12||1","6079")
ClassMethod Execute(Oeori As %String, UserID As %String) As %String
{
	n (Oeori, UserID)
	s Err=##Class(appcom.OEOrdItem).Execute(Oeori, UserID)
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2018-11-21
/// Descritp:   医生撤销执行医嘱
/// InPut：     Oeori - 医院，UserID - 用户ID
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMConsult).Verify("12||1","6079")
ClassMethod Verify(Oeori As %String, UserID As %String) As %String
{
	n (Oeori, UserID)
	s Err=##Class(appcom.OEOrdItem).Verify(Oeori, UserID)
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2018-11-21
/// Descritp:   撤销医嘱处理
/// InPut：     Oeori - 医院，UserID - 用户ID, Flag-是否需要撤销执行
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMConsult).CancelMulti("114||92","234",1)
ClassMethod CancelMulti(Oeori As %String, UserID As %String, Flag As %String) As %String
{
	n (Oeori, UserID, Flag)
	s EpisodeID=$p(^OEORD(+Oeori),"^",1)	    /// 就诊ID
	s PatType=$p(^PAADM(EpisodeID),"^",2)  		/// 病人类型
	s Err=0
	i Flag=1 s Err=##Class(appcom.OEOrdItem).Verify(Oeori, UserID)
	Q:Err Err
	i PatType="I" D
	.s Err=##Class(appcom.OEOrdItem).CancelMulti(Oeori, UserID, "", "N") /// 住院撤销医嘱
	E  D
	.s Err=##Class(appcom.OEOrdItem).StopMulti(Oeori, UserID, "", "N")   /// 门诊停止医嘱
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
	.s Err=..InsEmrAutMas(ListData)
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
/// w ##Class(web.DHCEMConsult).InsEmrAutMas("108^157||1^10209^^^2^1")
ClassMethod InsEmrAutMas(mListData As %String) As %String
{
	n (mListData)
	s TakOrd=$p(mListData,"^",7)   ///授权类型1:病历，2:医嘱
	s Err = 0
	TS

	/// 保存病历授权记录
	s Err=..InsEmrAut(mListData)
	i Err'=0 tro
	Q:Err'=0 Err

	/// 调用病历授权接口
	s:TakOrd=1 Err=..InvEmrAut(mListData)
	i Err'=0 tro
	Q:Err'=0 Err
	
	TC
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-14
/// Descritp:   Insert病历授权表
/// InPut：     mListData - 病历信息串
/// OutPut：    0-成功; 其他-不成功
/// w ##Class(web.DHCEMConsult).InsEmrAutMasNoAff("108^157||1^10209^^^2^1")
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
/// Descritp:   Insert病历授权表
/// InPut：     mListData - 病历信息串
/// OutPut：    0-成功; 其他-不成功
/// w ##Class(web.DHCEMConsult).InsEmrAutMas("108^157||1^10209^^^2^1")
ClassMethod InsEmrAutMasAll(Params As %String, LastChild = "") As %String
{
	n (Params,LastChild)
	
	s EpisodeID = $p(Params,"^",1)
	s CstID = $p(Params,"^",2)
	s LgUserID = $p(Params,"^",3)
	s AffTime = $p(Params,"^",4)
	s TakOrd = $p(Params,"^",5)
	
	s Err = 0
	
	TS
	
	s CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.q:(LastChild'="")&(CH'>LastChild) //hxy 2021-07-05
	.s CstItmID = CstID_"||"_CH
	.s LocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)          /// 科室ID
	.s User=""
	.s CareProvID = $p(^DHCEMCON(CstID,"I",CH),"^",3)
	.s:CareProvID="" CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 医生
	.s:CareProvID'="" User=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
	.s:LocID="" Err="1" //hxy 2020-03-05 院际会诊不需开授权
	.q:LocID=""
	.s mListData = EpisodeID_"^"_CstItmID_"^"_LgUserID_"^"_LocID_"^"_User_"^"_AffTime_"^"_TakOrd
	.s Err=##Class(web.DHCEMConsult).InsEmrAutMasNoAff(mListData)
	tro:Err'=0 
	q:Err'=0 Err
	
	TC
	Q Err
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
	s Err=##Class(web.DHCEMConsInterface).OpenEmrAuth(EpisodeID, itmID, mUserID, DeptID, UserID, LimTime)
	Q:+Err=1 0
	Q:+Err=0 "-2"
	Q Err
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
	&SQL(Insert Into DHC_EmConsEmrAut(EC_Cst_Ref,EC_User_Dr,EC_Loc_Dr,EC_Doc_Dr,EC_StartDate,EC_StartTime,EC_EndDate,EC_EndTime,EC_TakTime,EC_TakOrd)
		values(:itmID,:UserID,:DeptID,:mUserID,:StartDate,:StartTime,:EndDate,:EndTime,:Hours,:TakOrd))
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-14
/// Descritp:   关闭病历授权
/// InPut：     mListData - 病历信息串
/// OutPut：    0-成功; 其他-不成功
/// w ##Class(web.DHCEMConsult).ClsCstEmrAutMas("1","27||1")
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
/// w ##Class(web.DHCEMConsult).ClsCstEmrAut("67","148||1","2")
ClassMethod ClsCstEmrAut(EpisodeID As %String, itmID As %String, TakType = "") As %String
{
	n (EpisodeID, itmID,TakType)
	s Err=0
	TS
	/// 关闭病历授权
	s ID=..GetEmrAutID(itmID,TakType)
	i ID'="" s Err=##Class(web.DHCEMConsult).UpdCstEmrAut(ID)
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
/// w ##Class(web.DHCEMConsult).UpdCstEmrAut("114||92")
ClassMethod UpdCstEmrAut(ID As %String) As %String
{
	n (ID)
	s EndDate=+$H   		          /// 结束日期
	s EndTime=$p($H,",",2)            /// 结束时间
	&SQL(Update DHC_EmConsEmrAut Set EC_EndDate=:EndDate, EC_EndTime=:EndTime where EC_RowID=:ID)
	Q SQLCODE
}

/// Descritp: 返回指定会诊子项对应的可用的授权项ID
/// Input:itmID:会诊ID,TakType(1:病历,2:医嘱)
/// w ##Class(web.DHCEMConsult).GetEmrAutID("148||1",1)
ClassMethod GetEmrAutID(itmID As %String, TakType = "") As %String
{
	n (itmID,TakType)
	s ID="",TmpID=""
	F  s ID=$o(^DHCEMCEA(0,"Cst",itmID,ID)) Q:(ID="")||(TmpID'="")  D
	.s HasTakType = $p(^DHCEMCEA(ID),"^",10)
	.q:(TakType'="")&&(TakType'=HasTakType)
	.s EndDate=$p(^DHCEMCEA(ID),"^",7)
	.Q:EndDate<+$H
	.s EndTime=$p(^DHCEMCEA(ID),"^",8)
	.Q:(EndDate=+$H)&(EndTime<=$p($H,",",2))
	.s TmpID=ID
	Q TmpID
}

/// Descritp: 医生是否有录医嘱权限
/// w ##Class(web.DHCEMConsult).HasTakOrdAut("137||1",“2”)
ClassMethod HasTakOrdAut(itmID As %String, TakType = "") As %String
{
	n (itmID,TakType)
	s ID="",TakOrdFlag=0
	F  s ID=$o(^DHCEMCEA(0,"Cst",itmID,ID)) Q:(ID="")||(TakOrdFlag=1)  D
	.s HasTakType = $p(^DHCEMCEA(ID),"^",10)
	.s EndDate=$p(^DHCEMCEA(ID),"^",7)
	.Q:EndDate<+$H
	.s EndTime=$p(^DHCEMCEA(ID),"^",8)
	.Q:(EndDate=+$H)&(EndTime<=$p($H,",",2))
	.Q:(TakType'="")&&(TakType'=HasTakType)  /// 权限
	.s TakOrdFlag=1
	.
	Q TakOrdFlag
}

/// Creator:    bianshuai
/// CreateDate: 2019-07-16
/// Descritp:   修改会诊科室记录
/// InPut：     CstID - 会诊ID，LgParam - 用户登录数据，mListData - 会诊科室列表
/// OutPut：    0-成功; 其他-不成功
/// w ##Class(web.DHCEMConsult).InsCsLocItem("508","2^95^29^10209","93^1009^1^^^^")
ClassMethod InsCsLocItem(CstID As %String, LgParam As %String, mListData As %String) As %String
{
	n (CstID, LgParam, mListData,%session)
	s Err=0
	s LgHospID=$p(LgParam,"^",1) /// 医院ID
	s LgUserID=$p(LgParam,"^",4) /// 用户ID
	/// 是否插入请会诊医嘱
	s InsOrdFlag=..SendIsInsOrd(CstID,LgHospID,"R")
	/// 多科会诊填写标识
	s MulWriFlag=##Class(web.DHCEMConsultCom).GetEmSysConfig("MULWRIFLAG",LgHospID)
	/// 审核的时候是否必须确定人员
	s AudNeedUser=##Class(web.DHCEMConsultCom).GetEmSysConfig("AUDNEEDUSER",LgHospID)
	s AudUserID=$p(^DHCEMCON(CstID),"^",14) // 审核人
	s AppointUser=..GetIfAppointUser(mListData)
	Q:(AudNeedUser=1)&(AudUserID'="")&(AppointUser'=1) "-2"
	/// 申请状态
	Q:..IsPermitModLoc(CstID) "-1"
	TS
	s LastChild=$o(^DHCEMCON(CstID,"I",""),-1)  /// 当前会诊最后一条记录
	/// Descript: 修改会诊申请子表
    s Err=..InsCsItmAudit(CstID, mListData)
    i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 插入医嘱
	i InsOrdFlag=1 s Err=..InsCstOeori(CstID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 执行请会诊医嘱(多科会诊是请会诊医生填写，并且会诊医生已经接收情况)
	i (MulWriFlag=1)&(..GetIsModFlag(CstID,"30")) s Err = ..ExeCsROeori(CstID, LgUserID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 同步会诊申请状态值
	s Err = ..SynCsItemStat(CstID, LgUserID)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	TC
	/// 新增记录发送消息
	D ##Class(web.DHCEMConsult).ProSendmessage(CstID, LastChild)
	Q Err_"^"_LastChild
}

/// Descritp:  是否允许修改科室
/// InPut:     CstID - 会诊ID
/// OutPut:    0-允许,1-不允许
/// W ##Class(web.DHCEMConsult).IsPermitModLoc("131")
ClassMethod IsPermitModLoc(CstID As %String) As %String
{
	n (CstID)
	Q:..GetIsModFlag(CstID,5) 1
	Q 0
}

/// Descritp:  同步会诊申请状态值
ClassMethod SynCsItemStat(CstID As %String, LgUserID As %String) As %String
{
	n (CstID, LgUserID)
	s stID=..GetConsStatus(20)   /// 发送状态
#;	s AuditStID=..GetConsStatus(21)  /// 审核状态
#;	s AUserID=$p(^DHCEMCON(CstID),"^",14)    /// 审核人
	;s stID=$p(^DHCEMCON(+CstID),"^",18)
	s Err=0, CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.Q:$p(^DHCEMCON(CstID,"I",CH),"^",6)'=""
	.s Err=..InsCsItemStat(CstID_"||"_CH, LgUserID, stID)  /// 修改会诊申请状态值
	.Q:Err'=0
	.//i AUserID'="" s Err=..InsCsItemStat(CstID_"||"_CH, AUserID, AuditStID)  /// 修改会诊申请状态值
	.//Q:Err'=0
	.
	Q Err
}

/// Descritp:  修改会诊申请状态值
ClassMethod InsCsItemStat(itemID As %String, LgUserID As %String, StatusID As %String) As %String
{
	n (itemID, LgUserID, StatusID)
	s Err=..UpdCsItemStatus(itemID, StatusID)  /// 更新状态
	Q:Err'=0 Err
	s Err=..InsConsLog(itemID, LgUserID, StatusID, "") /// 插入日志
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2019-07-16
/// Descritp:   执行请会诊医嘱
/// InPut：     ItmID - 会诊子表ID，UserID - 用户ID
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMConsult).ExeCsROeori("92||1","114||77","E")
ClassMethod ExeCsROeori(CstID As %String, UserID As %String) As %String
{
	n (CstID, UserID)
	s CH="", Err=0
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.s Oeori=$p(^DHCEMCON(CstID,"I",CH),"^",9)   /// 医嘱ID
	.Q:Oeori=""
	.Q:..GetOrderStatCode(Oeori)'="V"
	.s Err=..Execute(Oeori, UserID) /// 执行医嘱
	.
	Q Err
}

/// Descript: 医嘱执行状态
ClassMethod GetOrderStatCode(oeori As %String) As %String
{
	n (oeori)
	Q:oeori="" ""
	s ItemStatID=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",13)
	Q:ItemStatID="" ""
	s ExeStatCode=$p(^OEC("OSTAT",ItemStatID),"^",1)
	Q ExeStatCode
}

/// Creator:    bianshuai
/// CreateDate: 2019-07-16
/// Descritp:   删除会诊科室记录
/// InPut：     ItmID - 会诊子表ID，LgUserID - 用户ID
/// OutPut：    0-成功; 其他-不成功
/// w ##Class(web.DHCEMConsult).delCsItem("155||1","10209")
ClassMethod delCsItem(ItmID As %String, LgUserID As %String) As %String
{
	n (ItmID, LgUserID)
	q:'..IfCanDelFlag(ItmID) "-1" //hxy 2021-05-17
	q:##Class(web.DHCEMConsultQuery).IsTakAccept(ItmID,"30") "-2" //是否已接收
	q:##Class(web.DHCEMConsultQuery).GetCstNodeTime(ItmID,"50") "-3" //是否已完成
	s Err=0
	TS
	/// 撤销请会诊医嘱
	s CstID=$p(ItmID,"||",1), CH=$p(ItmID,"||",2)
	s Oeori=$p(^DHCEMCON(CstID,"I",CH),"^",9)   /// 请会诊医嘱ID
		
	/// 删除会诊子表记录
	s Err=..DelCsLocItem(ItmID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 撤销请会诊医嘱
	i Oeori'="" s Err=..CancelMulti(Oeori, LgUserID, 0)    /// 撤销医嘱
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 删除授权
	s Err=..DelCsItemAut(ItmID)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	TC
	/// 取消信封消息
	D ..InvExec(ItmID, LgUserID)
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2019-07-16
/// Descritp:   删除会诊明细项目
/// InPut：     ItmID - 会诊子表ID，LgUserID - 用户ID
/// OutPut：    0-成功; 其他-不成功
/// w ##Class(web.DHCEMConsult).RevCsReqOeori("85||1")
ClassMethod RevCsReqOeori(ItmID As %String, UserID As %String) As %String
{
	n (ItmID, UserID)
	Q:(ItmID="")||(UserID="") -1
	s CstID=$p(ItmID,"||",1), CH=$p(ItmID,"||",2)
	s Oeori=$p(^DHCEMCON(CstID,"I",CH),"^",9)   /// 请会诊医嘱ID
	Q:Oeori="" 0
	s Err=..CancelMulti(Oeori, UserID, 0)       /// 撤销医嘱
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2019-07-16
/// Descritp:   删除会诊明细项目
/// InPut：     ItmID - 会诊子表ID
/// OutPut：    0-成功; 其他-不成功
/// w ##Class(web.DHCEMConsult).DelCsLocItem("85||1")
ClassMethod DelCsLocItem(ItmID As %String) As %String
{
	n (ItmID)
	&SQL(delete DHC_EmConsultItm where EC_RowID=:ItmID)
	Q SQLCODE
}

/// Creator:    乔庆澳
/// CreateDate: 2020-05-07
/// Descritp:   是否允许修改完成医师和职称
/// InPut：     CstID-会诊主表ID
/// OutPut：    1：允许，0：不允许
/// w ##Class(web.DHCEMConsult).NeedUpdCompDoc("214",2)
ClassMethod NeedUpdCompDoc(CstID, LgHospID)
{
	n (CstID,LgHospID)
	s Ret=1
	s MulWriFlag=##Class(web.DHCEMConsultCom).GetEmSysConfig("MULWRIFLAG",LgHospID)  /// 多科会诊填写标识
	s ECMoreDepFlag=$p(^DHCEMCON(CstID),"^",31)
	s CstTypeDesc=""
	s CstTypeDr=$p(^DHCEMCON(+CstID),"^",8)       /// 会诊类型
	s:CstTypeDr'="" CstTypeDesc=$p($g(^DHCEMCDI(CstTypeDr)),"^",2)
	s:CstTypeDesc="院际会诊" Ret=0
	s:(MulWriFlag=1)&&(ECMoreDepFlag="Y") Ret=0
	q Ret
}

/// Creator:    qqa
/// CreateDate: 2020-08-27
/// Descritp:   院际会诊是否已经审核完成
/// InPut：     CstID-会诊主表ID
/// OutPut：    Y：是，N：否，""：非院际会诊
/// w ##Class(web.DHCEMConsult).YuJiConsIsCompFlag("148","2")
ClassMethod YuJiConsIsCompFlag(CstID, LgHospID)
{
	n (CstID,LgHospID)
	s CstTypeDesc=""
	s CstTypeDr=$p(^DHCEMCON(+CstID),"^",8)       /// 会诊类型
	s:CstTypeDr'="" CstTypeDesc=$p($g(^DHCEMCDI(CstTypeDr)),"^",2)
	q:CstTypeDesc'="院际会诊" ""
	s IsWFCompFlag=##Class(web.DHCEMConsultWorkFlow).isWFCompFlag(CstID,LgHospID) /// 当前会诊工作流是否已经审核完
	q IsWFCompFlag
}

/// Creator:    hxy
/// CreateDate: 2020-05-08
/// Descritp:   取多科未完成科室
/// InPut：     CstID-会诊主表ID,"50"
/// OutPut：    ""/科室串
/// w ##Class(web.DHCEMConsult).GetUnCompLocs("536","50")
ClassMethod GetUnCompLocs(CstID As %String, stCode As %String) As %String
{
	n (CstID, stCode)
	s CstID=+CstID
	q:$p(^DHCEMCON(CstID),"^",31)'="Y" "" /// 非多科退出
	s ret=""
	s CH="",Num=0
	f  s CH=$o(^DHCEMCON(CstID,"I",CH)) q:CH=""  d
	.s ID=$p(^DHCEMCON(CstID,"I",CH),"^",6)  /// 状态ID
	.s CompDate=$p(^DHCEMCON(CstID,"I",CH),"^",16)
	.q:CompDate'=""
	.s LocID=$p(^DHCEMCON(CstID,"I",CH),"^",1) /// 科室ID
	.s LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
	.s:Num=0 ret=LocDesc
	.s:Num'=0 ret=ret_"、"_LocDesc
	.s Num=Num+1
	s:ret'="" ret="^,多科会诊仍有 "_ret_" 未完成"
	q ret
}

/// Creator:    hxy
/// CreateDate: 2020-09-25
/// Descritp:   置空会诊人
ClassMethod UpdCsItemCDoc(CstItmID As %String) As %String
{
	n (CstItmID)
	q:+CstItmID=0 0
	s CareProvID=""
	&SQL(update DHC_EmConsultItm set EC_CDoc_Dr=:CareProvID where EC_RowID=:CstItmID)
	Q SQLCODE
}

/// Creator:    hxy
/// CreateDate: 2021-03-02
/// Descritp:   病历授权会诊性质配置小时数
ClassMethod GetHours(CstID As %String) As %String
{
	n (CstID)
	q:+CstID=0 ""
	s CsPropID = $p($g(^DHCEMCON(+CstID)),"^",45) /// 会诊性质 //病历授权会诊性质配置优先于产品功能配置小时数
	s AffTimeBy=##Class(web.DHCEMConsultQuery).GetHoursConfig(CsPropID,"DEFOPENACCHOUR")
	s:+AffTimeBy=0 AffTimeBy=""
	q AffTimeBy
}

/// Creator:    hxy
/// CreateDate: 2021-03-30
/// Descritp:   通过主子表id 取 状态code^状态desc(当前未使用)
/// w ##class(web.DHCEMConsult).GetStCodeDesc(113)
ClassMethod GetStCodeDesc(itmID As %String) As %String
{
	n (itmID)
	q:+itmID=0 ""
	s ret=""
	s ID=$p($g(^DHCEMCON(+itmID,"I",+$p(itmID,"||",2))),"^",6)  /// 会诊状态
	i ID="" s ID=$p(^DHCEMCON(+itmID),"^",18)  /// 会诊状态
	Q:ID="" ""
	s stCode=$p($g(^DHCEMCONS(+ID)),"^",1)
	s stDesc=$p($g(^DHCEMCONS(+ID)),"^",2)
	s ret=stCode_"^"_stDesc
	Q ret
}

/// Creator:    hxy
/// CreateDate: 2021-03-31
/// Descritp:  设置会诊到达时间
ClassMethod UpdCstArrDate(CstID, CstItmID, UserID, ArrDate, ArrTime) As %String
{
	n (CstID, CstItmID, UserID, ArrDate,ArrTime)
	s Err=0, CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(Err'=0)  D
	.Q:(CstItmID'="")&(CstItmID'=(CstID_"||"_CH))
	.s Err=..UpdCstItmArrDate(CstID_"||"_CH, UserID, ArrDate,ArrTime)
	q:Err'=0 Err	
	Q Err
}

/// Creator:    hxy
/// CreateDate: 2021-03-31
/// Descritp:  更新到达时间
ClassMethod UpdCstItmArrDate(CstItmID, UserID, ArrDate, ArrTime) As %String
{
	n (CstItmID, UserID, ArrDate,ArrTime)
	&SQL(update DHC_EmConsultItm set EC_ArrDate=:ArrDate, EC_ArrTime=:ArrTime where EC_RowID=:CstItmID)
	Q SQLCODE
}

/// Descritp:  执行会诊审核信封消息
/// w ##Class(web.DHCEMConsult).InvExecAudit("146","12175")
ClassMethod InvExecAudit(CstID As %String, UserID As %String) As %String
{
	n (CstID,UserID)
	s MesCode="1189"
	s EpisodeID = $p(^DHCEMCON(CstID),"^",1)
	s Ret = ##class(websys.DHCMessageInterface).Exec("",MesCode,EpisodeID,"",CstID,UserID)
	q Ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-07
/// Descript:   会诊如果是配置需审核流程时，申请医师发送成功后，需要给审核的人员发送消息；
/// Input :     会诊主表ID,发送医生
/// w ##class(web.DHCEMConsult).SendmessageForAuditor("146","12175")
ClassMethod SendmessageForAuditor(CstID, CreatDoc) As %String
{
	n (CstID, CreatDoc)
	Q:##Class(web.DHCEMConsultWorkFlow).isWFCompFlag(CstID)="Y" 0 /// 当前会诊工作流是否已经审核完
	s MesCode="1189"
	s EpisodeID = $p(^DHCEMCON(CstID),"^",1)
	s CsType = $p(^DHCEMCON(CstID),"^",19)  /// 会诊类型
	s:CsType="NUR" CsType="Nur"
	s CsRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	s CsHospID=$p(^CTLOC(CsRLocID),"^",22)  /// 医院ID
	s NextFlow=##Class(web.DHCEMConsultWorkFlow).GetNextWorkFlowItem(CstID,CsHospID)
	s GetReceiveDocs=..GetReceiveDocs(NextFlow,CsHospID,CstID)
	q:(EpisodeID="")||(CsRLocID="")||(GetReceiveDocs="##") ""
	s LinkUrl="dhcem.consultaudit.csp"
	s Url=""""_LinkUrl_"?CsType="_CsType_""""
	s Link="{""link"":"_Url_",""BizObjId"":"_""""_CstID_""""_",""dialogWidth"":"_1400_",""dialogHeight"":"_600_"}"
	s ReceiveDocs=$p(GetReceiveDocs,"##",1)
	s ToLocRowId=$p(GetReceiveDocs,"##",2)_"|Logon"
	s Ret=##class(websys.DHCMessageInterface).Send("会诊审核",MesCode,CreatDoc,EpisodeID,"",ReceiveDocs, Link,ToLocRowId)
	q Ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-07
/// Descript:   取所有的User人^所有的科室
/// w ##class(web.DHCEMConsult).GetReceiveDocs("2||2","2")
ClassMethod GetReceiveDocs(NextFlow, HospDr, CstID) As %String
{
	n (NextFlow,HospDr,CstID)
	q:(NextFlow="")||(HospDr="") ""
	s ret="",Docs="",Locs="" //科室按科室Locs，安全组和人员按人员Docs
	s NextStID=$p($g(^DHCEMCONWF(+NextFlow,"I",$p(NextFlow,"||",2))),"^",1) //2021-07-24 大科审核75只发大科组长 st
	s NextStCode=$p($g(^DHCEMCONS(+NextStID)),"^",1)
	q:NextStCode=75 ..GetLeadUsers(CstID)_"##" //ed
	s ID=""
	f  s ID=$o(^DHCEMCONG(0,"WorkItem",NextFlow,ID)) q:ID=""  d
	.q:+ID=0
	.s Date = ^DHCEMCONG(ID)
	.s Type=$p(Date,"^",2)
	.s PointerID=$p(Date,"^",3)
	.s:(Type="G")&&('Docs="") Docs=Docs_"^"_..GetUsersByGroup(PointerID,HospDr) //安全组
	.s:(Type="G")&&(Docs="") Docs=..GetUsersByGroup(PointerID,HospDr) //安全组
	.s:(Type="L")&&(Locs'="") Locs=Locs_"^"_PointerID //科室
	.s:(Type="L")&&(Locs="") Locs=PointerID           //科室
	.s:(Type="U")&&(Docs'="") Docs=Docs_"^"_PointerID //人员
	.s:(Type="U")&&(Docs="") Docs=PointerID           //人员
	s ret=Docs_"##"_Locs
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-07
/// Descript:   通过安全组取所有的User人
/// w ##class(web.DHCEMConsult).GetUsersByGroup(30,2)
ClassMethod GetUsersByGroup(GroupID, HospDr) As %String
{
	n (GroupID,HospDr)
	q:(GroupID="")||(HospDr="") ""
	s ret="", USRRowID=0
	f  s USRRowID=$o(^SSU("SSUSR",0,"Group",GroupID,USRRowID)) q:(USRRowID="")  d //默认安全组
	.s:ret'="" ret=ret_"^"_USRRowID
	.s:ret="" ret=USRRowID
	
	s UserID=0
	f  s UserID = $O(^SSU("SSUSR",UserID))	Quit:UserID=""  d  //其他安全组
	.s Sub=0,Flag=0
	.f  s Sub = $O(^SSU("SSUSR",UserID,"OTHLL",Sub))	Quit:Sub=""  d
	..s OthllInfo=$g(^SSU("SSUSR",UserID,"OTHLL",Sub))
	..s OtherGroupDr=$p(OthllInfo,"^",2)
	..q:OtherGroupDr'=GroupID
	..s Stdate=$p(OthllInfo,"^",4)
	..s Edate=$p(OthllInfo,"^",5)
	..q:(Stdate'="")&&(Stdate>+$h)  //还未开始 
	..q:(Edate'="")&&(Edate<+$h)    //已经结束 
	..s Flag=1
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_User",UserID,HospDr)'="Y"
	.s:(Flag=1)&&(ret'="") ret=ret_"^"_UserID
	.s:(Flag=1)&&(ret="") ret=UserID
	.
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-05017
/// Descript:   通过会诊子表看是否能删除该子表记录（多科判断）
/// w ##class(web.DHCEMConsult).IfCanDelFlag("513||1")
ClassMethod IfCanDelFlag(itmID As %String) As %String
{
	n (itmID)
	s ret=0
	s CstID=+itmID
	s MoreFlag=$p(^DHCEMCON(CstID),"^",31)   /// 多科标志
	q:MoreFlag'="Y" ret
	s CH="",Num=0
	f  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s Num=Num+1
	s:Num>2 ret=1
	Q ret
}

/// Creator:    hxy
/// CreateDate: 2021-05-18
/// Descritp:   删除授权
/// InPut：     ItmID - 会诊子表ID
/// OutPut：    0-成功; 其他-不成功
/// w ##Class(web.DHCEMConsult).DelCsLocItem("85||1")
ClassMethod DelCsItemAut(ItmID As %String) As %String
{
	n (ItmID)
	&SQL(delete DHC_EmConsEmrAut where EC_Cst_Ref=:ItmID)
	s:SQLCODE=100 SQLCODE=0
	Q SQLCODE
}

/// Descript:	插入医嘱
/// W ##Class(web.DHCAPPExaReport).SaveOrderItems("315","58841||1^123","4636","110","","","","","","1")
ClassMethod SaveOrderItems(EpisodeID As %String, itmmaststr As %String, UserID As %String, LocID As %String, arEmgFlag As %String, arExaReqNote As %String, arReqArcID As %String, SpeCode As %String = "", mOeori As %String = "", BillTypeID As %String = "", PPFlag = "Y", InsurFlag As %String = "", ChronicDiagCode As %String = "", ByRef ErrMsg As %String = "") As %String
{
	n (EpisodeID, itmmaststr, UserID, LocID, arEmgFlag, arExaReqNote, arReqArcID, SpeCode, mOeori, BillTypeID, PPFlag, InsurFlag, ChronicDiagCode, ErrMsg, %session)

	s CareProvID=$p($g(^SSU("SSUSR",UserID)),"^",14)   /// 医生ID
	s OrderPriorId=$O(^OECPR(0,"Code","NORM",0))       /// 优先级
	s SeqNo=1
	s OrderStartDate=$zd(+$h,4)						   /// 医嘱日期
	s OrderStartTime=..%ZT(..%SysTime(),2)			   /// 医嘱时间
	s DischargeDateTime=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetDischargeDateTime",EpisodeID)
	s DischargeDate=$p(DischargeDateTime,"^",1)
	s DischargeTime=$p(DischargeDateTime,"^",2)
	if (DischargeDate'="") {
		s OrderStartDate=$zd(DischargeDate,4)
		s OrderStartTime=..%ZT(DischargeTime-1,1)
	}
#;	s EsDischgDate=$p(^PAADM(EpisodeID),"^",59)		   /// 出院日期
#;	s EsDischgTime=$p(^PAADM(EpisodeID),"^",60)        /// 出院时间
#;	i EsDischgDate'="" s OrderStartDate=$zd(EsDischgDate,4)	
#;	i EsDischgTime'="" s OrderStartTime=..%ZT(EsDischgTime,2)
	i BillTypeID="" D
	.s BillTypeID=$P(^PAADM(EpisodeID,1),"^",7)        /// 费别指针
	s PackQty = 1									   /// 医嘱数量
	s DoseQtySum=PackQty							   /// 基本单位总数量
	
	s itmmastid=$p(itmmaststr,"^",1)
	s recLocID=$p(itmmaststr,"^",2)		  	   /// 接收科室
	s EmConsultItm=$p(itmmaststr,"^",3)	
	s ItemCatDR=$p(^ARCIM(+itmmastid,$p(itmmastid,"||",2),1),"^",10)  /// 医嘱子类ID
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  	   /// 医嘱子类类型
	s FreqRowid="",InstrRowid="",DurRowid=""
	s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(itmmastid)
	i DrgFormRowid'="" d
	.s PHCDRowid=$P(DrgFormRowid,"||",1)
	.s ChildSub=$P(DrgFormRowid,"||",2)
	.s FreqRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",4)  /// 频次
	.s InstrRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",5) /// 用法
	.s DurRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",8)   /// 疗程
	/// 病人所属科研项目ID
	s PPID="",IsCheckOrdItemStr="N"
	i PPFlag="Y" D  /// 临床科研标识
	.s PilotProStr=##Class(web.PilotProject.DHCDocPilotProPat).GetPilotProStr(EpisodeID,UserID)
	.s PPID=$P(PilotProStr,$c(1))
	.s IsCheckOrdItemStr="Y"
	s itemPrice=1
	s ListData=itmmastid_"^"_OrderType_"^"_OrderPriorId_"^"_OrderStartDate_"^"_OrderStartTime_"^"_PackQty_"^"_itemPrice_"^"_recLocID_"^"_BillTypeID
	s ListData=ListData_"^"_DrgFormRowid_"^"_arExaReqNote_"^"_""_"^"_""_"^"_DoseQtySum_"^"_FreqRowid_"^"_DurRowid_"^"_InstrRowid_"^"_""_"^"_""_"^"_SeqNo
	s ListData=ListData_"^"_""_"^"_""_"^"_InsurFlag_"^"_""_"^"_""_"^"_""_"^"_""_"^"_SpeCode_"^"_""_"^"_arEmgFlag
	s $p(ListData,"^",46)=OrderStartDate
	s $p(ListData,"^",47)=OrderStartTime
	s $p(ListData,"^",56)=PPID
	s $p(ListData,"^",59)=arReqArcID
	s $p(ListData,"^",39)=mOeori   /// 主医嘱ID
	s $p(ListData,"^",81)=EmConsultItm   /// 会诊子表ID
	s $p(ListData,"^",82)=ChronicDiagCode
	q:ListData="" "100"
#;	s OrdAddCongeriesArr=[]
#;	s OrdAddCongeriesJson=##class(web.DHCOEOrdAppendItem).GetAppendOrdItemArr(EpisodeID,ListData,LocID,.OrdAddCongeriesArr)
#;	k OrdCongeriesArr
#;	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(OrdAddCongeriesJson,.OrdCongeriesArr)
#;	s OrdCounter=""
#;	for {
#;		s OrdCounter=$O(OrdCongeriesArr(OrdCounter))
#;		q:(OrdCounter="")
#;		s ListData=ListData_$C(1)_$g(OrdCongeriesArr(OrdCounter,"OrdListInfo"))
#;	}
#;	s ret=##Class(web.DHCOEOrdItem).SaveOrderItems(EpisodeID, ListData, UserID, LocID, CareProvID, "", "^^^"_IsCheckOrdItemStr_"^"_PPID,.ErrMsg)
	s ret=##Class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(EpisodeID, ListData, UserID, LocID, CareProvID, "", "^^^"_IsCheckOrdItemStr_"^"_PPID,.ErrMsg)
	
	if (ErrMsg'="") s ErrMsg=$p(ErrMsg,$C(1),2)
	Q ret
}

/// 转换为前台展示的时间
ClassMethod %ZT(%Time As %String, TimeFormat As %String = "") As %String
{
    if (..%IsValidMethod("websys.Conversions","TimeLogicalToHtml")){
        quit ##class(websys.Conversions).TimeLogicalToHtml(%Time,TimeFormat)
    }else{
        quit $ZT(%Time,TimeFormat)
    }
}

ClassMethod %IsValidMethod(%ClassName, %MethodName) As %String
{
    quit ##class(websys.Conversions).IsValidMethodName(%ClassName,%MethodName)
}

/// 获取系统格式时间
ClassMethod %SysTime() As %String
{
    quit $P($H,",",2)
}

/// Creator:    hxy
/// CreateDate: 2021-06-02
/// Descritp:   通过会诊主表ID取值SureBeforeEva(会诊处理-是否在会诊医师会诊评价后才能确认)
/// InPut：     CstID - 会诊ID
/// OutPut：    Y-是; 其他-否
/// w ##Class(web.DHCEMConsult).GetSureBeforeEva("645")
ClassMethod GetSureBeforeEva(CstID As %String) As %String
{
	n (CstID)
	s ret="N"
	s CstEcType=$p(^DHCEMCON(CstID),"^",19)   /// 会诊类型
	q:CstEcType'["DOC" ret
	s CstOutFlag=$p(^DHCEMCON(CstID),"^",24)  /// 是否院外
	q:CstOutFlag="Y" ret
	s PatHospID=##Class(web.DHCEMConsultCom).GetPatHospID(CstID) //hxy 2021-06-01 st
	s SureBeforeEva=##Class(web.DHCEMConsultCom).GetEmSysConfig("SUREBEFOREEVA",PatHospID) /// 会诊处理-是否在会诊医师会诊评价后才能确认 1-是
	s WriEvaCsFlag=##Class(web.DHCEMConsultCom).GetEmSysConfig("WRIEVACSFLAG",PatHospID)   /// demo-产品功能配置-是否显示会诊评价 0-不显示
	s UseFlag=$p($g(^DHCEMCONS(..GetConsStatus(55))),"^",3)                                /// demo-会诊评价状态是否启用 Y-启用
	s MulWriFlag=##Class(web.DHCEMConsultCom).GetEmSysConfig("MULWRIFLAG",PatHospID)       /// 多科会诊填写标识 1-申请医生
	s MoreFlag=$p($g(^DHCEMCON(+CstID)),"^",31)                                            /// 多科标志 Y-多科
	s:(SureBeforeEva=1)&&(WriEvaCsFlag'=0)&&(UseFlag="Y")&&((MoreFlag'="Y")||((MoreFlag="Y")&&(MulWriFlag'=1))) ret="Y"
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-06-21
/// Descritp:   获取子表ID
/// InPut：     StatusID 下一状态id, UserID 审核登陆人, mListData审核串
/// OutPut：    子表ID
/// w ##Class(web.DHCEMConsult).GetItmID("35","12175","")
ClassMethod GetItmID(StatusID As %String, UserID As %String, mListData As %String) As %String
{
	n (StatusID,UserID,mListData)
	s ret=""
	s NextStCode=$p($g(^DHCEMCONS(+StatusID)),"^",1)
	q:NextStCode'=75 ret
	s ListDataStr=$p(mListData,$c(2),2) 
	s Len = $L(ListDataStr,"@")
	;F i=1:1:Len Q:ret'=""  D
	F i=1:1:Len  D
	.s ListData=$p(ListDataStr,"@",i)    /// 项目列表
	.s GrpID=$p(ListData,"^",5)    /// 医生大科
	.s GrpLeadDr=$p($g(^DHCEMCG(+GrpID)),"^",5)
	.s ItmDr=$p(ListData,"^",6)    /// 会诊子表Dr
	.;s:UserID=GrpLeadDr ret=ItmDr
	.s:(UserID=GrpLeadDr)&&(ret'="") ret=ret_"^"_ItmDr
	.s:(UserID=GrpLeadDr)&&(ret="") ret=ItmDr
	s:$L(ret,"^")=Len ret=""
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-07-16
/// Descript:   获取驳回的闭环code
/// InPut:      CstID - 会诊申请ID
/// OutPut:     CycleCode
ClassMethod GetRefAuditCycleCode(CstID As %String) As %String
{
	n (CstID)
	s ret="" //会诊闭环code 科主任驳回221，医务部驳回222，用于闭环展示，对会诊无效
	s CstHospID=##Class(web.DHCEMConsultCom).GetPatHospID(CstID)
	;s NextStCode=##Class(web.DHCEMConsultQuery).GetNextStCode(CstID,CstHospID) //取下一个会诊工作流状态Code
	;s:NextStCode="71" ret="221"
	;s:NextStCode="72" ret="222"
	s NextStDesc=##Class(web.DHCEMConsultQuery).GetNextStDesc(CstID,CstHospID) //取下一个会诊工作流状态Desc
	s:NextStDesc="大科审核" NextStDesc="科主任审核" //大科即为科主任
	s StaDesc=$replace(NextStDesc,"审核","驳回")
	s StaDr=..GetConsStatusByDesc(StaDesc)
	s ret=$p($g(^DHCEMCONS(+StaDr)),"^",1)
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-07-16
/// Descript:   获取取消审核的闭环code
/// InPut:      CstID - 会诊申请ID
/// OutPut:     CycleCode
ClassMethod GetRevAuditCycleCode(CstID As %String) As %String
{
	n (CstID)
	s ret="" //会诊闭环code 科主任取消审核801，医务部取消审核802，大科取消审核808 guoguomin
	s CurStDesc=##Class(web.DHCEMConsultQuery).GetCstCurStat(CstID)
	;s:CurStDesc="科主任审核" ret="801"
	;s:CurStDesc="医务部审核" ret="802"
	s CurStDesc=$replace(CurStDesc,"审核","取消审核")
	s StaDr=..GetConsStatusByDesc(CurStDesc)
	s ret=$p($g(^DHCEMCONS(+StaDr)),"^",1)
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-07-24
/// Descript:   取该会诊的所有大科组长
/// w ##class(web.DHCEMConsult).GetLeadUsers("804")
ClassMethod GetLeadUsers(CstID)
{
	n (CstID)
	s ret=""
	s CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s GrpID=$p(^DHCEMCON(CstID,"I",CH),"^",12)        /// 医生大科
	.s GrpLeadDr=$p($g(^DHCEMCG(+GrpID)),"^",5)        /// 医生大科组长
	.s:ret'="" ret=ret_"^"_GrpLeadDr
	.s:ret="" ret=GrpLeadDr
	q ret
}

/// Descritp:  用户职称是否允许接受申请单
/// InPut:     HospID - 医院ID，UserID - 用户ID
/// OutPut:    0-允许,1-不允许
/// W ##Class(web.DHCEMConsult).IsPrvTpPermitAccept("2","18132")
ClassMethod IsPrvTpPermitAccept(HospID As %String, UserID As %String) As %String
{
	n (HospID,UserID)
	s NotPrvTp=##Class(web.DHCEMConsultCom).GetEmSysConfig("CANNOTACCPRVTP",HospID)
	q:NotPrvTp="" 0
	s NotPrvTp=","_NotPrvTp_","
	s PrvTp=","_##Class(web.DHCEMConsultCom).GetPrvTpByUserID(UserID)_","
	q:NotPrvTp[PrvTp 1
	q 0
}

/// Descritp:  是否已指定医生
/// InPut:     mListData
/// OutPut:    0-未指定,1-指定了
/// W ##Class(web.DHCEMConsult).GetIfAppointUser("131")
ClassMethod GetIfAppointUser(mListData As %String) As %String
{
	n (mListData)
	s ret=1
	F i=1:1:$L(mListData,"@") Q:ret'=1  D
	.s ListData=$p(mListData,"@",i)    /// 项目列表
	.q:ListData=""
	.s CstNDocID=$p(ListData,"^",2)    /// 要求会诊医生
	.s:CstNDocID="" ret=0
	Q ret
}

/// Creator:    hxy
/// CreateDate: 2022-10-19
/// Descritp:   医嘱状态
/// InPut:      医嘱ID
/// OutPut:     医嘱状态Desc
/// W ##Class(web.DHCEMConsult).GetOrdStatus("2226||38")
ClassMethod GetOrdStatus(OrdItmRowId As %String) As %String
{
	n (OrdItmRowId)
	s ret=""
	s obj=##class(User.OEOrdItem).%OpenId(OrdItmRowId)
	if $IsObject(obj) {
		s OEORIItemStatDR=obj.OEORIItemStatDR
		s OEORIItemStateDesc=$s($IsObject(OEORIItemStatDR):OEORIItemStatDR.OSTATDesc,1:"")
		s ret=OEORIItemStateDesc
	}
	d obj.%Close()
	q ret
}

/// Creator:      hxy
/// CreateDate:   2023-02-02
/// Descript:     会诊申请指定节点操作人（当前仅用于取消到达）
/// InPut:        itmID - 会诊子表ID, stCode - 状态代码
/// OutPut:       时间
/// w ##Class(web.DHCEMConsultQuery).GetCstNodeUser("2","30")
ClassMethod GetCstNodeUser(itmID As %String, stCode As %String) As %String
{
	n (itmID, stCode)
	Q:itmID="" ""
	Q:stCode="" ""
	Q:$p(^DHCEMCON(+itmID),"^",18)="" ""     /// 会诊状态
	s LgID="",LgUser="",QuitFlag=0
	F  s LgID=$o(^DHCEMCONL(0,"Cst",itmID,LgID),-1) Q:(LgID="")||(LgUser'="")||(QuitFlag=1)  D
	.s StatusID=$p(^DHCEMCONL(LgID),"^",3)  /// 状态
	.i (stCode="30")&($p(^DHCEMCONS(StatusID),"^",1)="35") s QuitFlag=1
	.i (stCode="50")&($p(^DHCEMCONS(StatusID),"^",1)="51") s QuitFlag=1
	.Q:$p(^DHCEMCONS(StatusID),"^",1)'=stCode
	.s LgUser=$p(^DHCEMCONL(LgID),"^",2)    /// 操作人
	Q LgUser
}

ClassMethod SendOtherMethod(CstID, UserID, MorMesFlag, Risk = "")
{
	
	/// 小信箱
	D ..InsWebsysMessage(CstID,UserID,"")
	
	/// 小信箱 2021-04-07 会诊如果是配置需审核流程时，申请医师发送成功后，需要给审核的人员发送消息；
	D ..SendmessageForAuditor(CstID,UserID)
	
	/// 危急值
	D ..SendCvMessage(CstID, UserID,Risk)
}

Storage Default
{
<Data name="DHCEMConsultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMConsultD</DataLocation>
<DefaultData>DHCEMConsultDefaultData</DefaultData>
<IdLocation>^web.DHCEMConsultD</IdLocation>
<IndexLocation>^web.DHCEMConsultI</IndexLocation>
<StreamLocation>^web.DHCEMConsultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
