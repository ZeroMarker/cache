Import SQLUser

/// Creator: 	bianshuai
/// CreateDate: 2016-04-25
/// Descript: 	检查申请报告
Class web.DHCAPPExaReport Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 保存检查申请记录
/// w ##Class(web.DHCAPPExaReport).save($LG(^tempqujian("save"),1),$LG(^tempqujian("save"),2),$LG(^tempqujian("save"),3),$LG(^tempqujian("save"),4))
ClassMethod save(pid, ListData, mPatSymData, LgParams, ByRef ErrMsg As %String = "") As %String
{
	n (pid, ListData, mPatSymData,LgParams,ErrMsg,%session)
	s ^tempqujian("save")=$LB(pid,ListData,mPatSymData,LgParams)
	s LgUserID=$P(LgParams,"^",1)
	s LgGroupID=$P(LgParams,"^",2)
	s LgLoc=$P(LgParams,"^",3)
	s LgHospID=$P(LgParams,"^",4)
	s ListData=##Class(web.DHCAPPExaReport).dealInsListData(ListData)

	s arreqidstr=""
	s Err = 0
	b ;092323
	TS
	s Len = $L(ListData,$C(1))   		 /// 检查分类数目
	f i=1:1:Len q:Err'=0  d
	.s sListData=$p(ListData,$C(1),i)
	.s arReqID = $p(sListData,$C(2),1)  	 /// 检查分类项目ID
	.s mListData = $p(sListData,$C(2),2)   /// 申请表主信息
	.s aListData = $p(sListData,$C(2),3)   /// 医嘱项关联信息
	.s ToothInfo= $p(sListData,$C(2),4)
	.i arReqID = "" d
	..s arReqID=..Insert(mListData,aListData,pid,mPatSymData,.ErrMsg,ToothInfo,LgParams)
	.e  d
	..s arReqID=..Update(arReqID,mListData,aListData,pid,mPatSymData,.ErrMsg,ToothInfo,LgParams)
	.i arReqID<0 s Err=arReqID
	.q:arReqID<0 
	.s arreqidstr=$s(arreqidstr'="":arreqidstr_"^"_arReqID,1:arReqID)  ///申请表ID串
	.
	i Err'=0 tro
	q:Err'=0 Err_"^"_ErrMsg

	TC
	//前面insert update方法，在保存医嘱之后已经调用
	//D ##Class(web.DHCAPPExaReport).InvokInterface(arreqidstr,LgUserID)  /// 调用其他相关接口
	Q arreqidstr
}

/// Descript: 插入检查申请记录
ClassMethod Insert(mListData As %String, aListData As %String, pid As %String, mPatSymData As %String, ByRef ErrMsg As %String = "", ToothInfo As %String, LgParams As %String) As %String
{
	N (mListData, aListData, pid, mPatSymData,ErrMsg,LgParams,%session,ToothInfo)
	
	s Err=0 s TmpParam=""
	TS

	/// 检查报告
	s arReqID=..InsAppRep(mListData,mPatSymData)
	i arReqID<0 tro
	q:arReqID<0 arReqID
	/// 医嘱项目
	f i=1:1:$L(aListData,"&&") q:Err'=0  d
	.s arcListData=$p(aListData,"&&",i)
	.s Err=..InsArcItem(arReqID,arcListData,.TmpParam,.ErrMsg,ToothInfo)
	i Err'=0 tro
	q:Err'=0 "-11"

	/// 其他项目
	s oListData=..GetRepOthOpt(pid,aListData)  /// 其他项目取值
	i oListData'="" d
	.s Err=..InsRepOthOpt(arReqID,oListData)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	/// 患者现病史
	i $p(mPatSymData,$C(4),2)'="" d
	.s Err = ..InsPreHis(arReqID, mPatSymData)
	i Err'=0 tro
	q:Err'=0 "-13"
	
	/// 患者体征
	i $p(mPatSymData,$C(4),3)'="" d
	.s Err = ..InsPatSigns(arReqID, mPatSymData)
	i Err'=0 tro
	q:Err'=0 "-14"

	/// 患者主诉
	i $p(mPatSymData,$C(4),4)'="" d
	.s Err = ..InsPatSymptom(arReqID, mPatSymData)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	/// 插入医嘱
	s arSendFlag=$p(^DHCAPREP(arReqID),"^",17) 
	if (arSendFlag'="I"){
		s Err = ..InsOrderItems(arReqID,mListData,.TmpParam,.ErrMsg,LgParams)
		i Err'=0 tro
		q:Err'=0 "-16"
		/// 插入检查申请Html内容表
		s Err = ..InsExaRepContentHtml(arReqID)
		i Err'=0 tro
		q:Err'=0 "-17"
	}

	TC
	Q arReqID
}

/// Descript: 更新检查申请记录
ClassMethod Update(arReqID As %String, mListData As %String, aListData As %String, pid As %String, mPatSymData As %String, ByRef ErrMsg As %String = "", ToothInfo As %String, LgParams As %String) As %String
{
	N (arReqID, mListData, aListData, pid, mPatSymData, ErrMsg , %session,LgParams)
	s Err=0
	TS
	/// 插入医嘱
	s arSendFlag=$p(^DHCAPREP(arReqID),"^",17) 
	s ToothInfo=""
	s arCreateDocID=$p(mListData,"^",5)  ///申请医生
	s DoctorID=##class(web.SSUser).GetDefaultCareProvider(arCreateDocID)
	s practiceFlag=##class(web.DHCOEOrdItem).practice(DoctorID)
	if (arSendFlag="I"){
		s Err=..UpdRepArc(arReqID,aListData,ToothInfo)
		i Err'=0 tro
		q:Err'=0 "-18"
	}
	if ((arSendFlag="I")&&(practiceFlag'=1)){
		&SQL(Update DHC_AppReport set AR_SendFlag="Y",AR_CreateDoc_Dr=:arCreateDocID
		Where AR_Rowid=:arReqID)
		i SQLCODE'=0  q SQLCODE
		s Err = ..InsOrderItems(arReqID,mListData,"",LgParams,.ErrMsg)
		i Err'=0 tro
		q:Err'=0 "-16"
		s Err = ..InsExaRepContentHtml(arReqID)
		i Err'=0 tro
		q:Err'=0 "-17"
	}
	/// 检查报告
	s arReqID=..UpdAppRep(arReqID,mListData,mPatSymData)
	i arReqID<0 tro
	q:arReqID<0 arReqID

	/// 删除相关子表
	s Err=..DelRepTable(arReqID)
	i Err'=0 tro
	q:Err'=0 Err

	/// 其他项目
	s oListData=..GetRepOthOpt(pid, aListData, arReqID)  /// 其他项目取值
	i oListData'="" d
	.s Err=..InsRepOthOpt(arReqID,oListData)
	i Err'=0 tro
	q:Err'=0 "-12"

	/// 患者现病史
	i $p(mPatSymData,$C(4),2)'="" d
	.s Err = ..InsPreHis(arReqID, mPatSymData)
	i Err'=0 tro
	q:Err'=0 "-13"

	/// 患者体征
	i $p(mPatSymData,$C(4),3)'="" d
	.s Err = ..InsPatSigns(arReqID, mPatSymData)
	i Err'=0 tro
	q:Err'=0 "-14"

	/// 患者主诉
	i $p(mPatSymData,$C(4),4)'="" d
	.s Err = ..InsPatSymptom(arReqID, mPatSymData)
	i Err'=0 tro
	q:Err'=0 "-15"
		
	TC
	Q arReqID
}

/// Descript: 保存检查医嘱项信息
ClassMethod InsArcItem(arReqID As %String, arListData As %String, TmpParam As %String, ByRef ErrMsg As %String = "", ToothInfo As %String) As %String
{
	N (arReqID, arListData, TmpParam,ErrMsg,ToothInfo)
	
	s Err=0
	/// 医嘱项,体位
	s arReqArcID=..InsRepArc(arReqID,arListData,ToothInfo)
	q:arReqArcID<0 arReqArcID
	
	s EpisodeID=$p(^DHCAPREP(+arReqArcID),"^",6)
	s ARCIM=$p(^DHCAPREP(+arReqArcID,"AR",$p(arReqArcID,"||",2)),"^",1) 
	
	/// 部位
	s arPartListData=$p(arListData,"^",3)
	s OpenForAllHosp=$p(arListData,"^",14)
	s LogLoc=$p(arListData,"^",15)
	s OpenLogHospStr=OpenForAllHosp_"!"_LogLoc
	s ^tempqujian("OpenLogHospStr")=$lb(arListData)
	f i=1:1:$L(arPartListData,"@") q:Err'=0  d
	.s arPartData=$p(arPartListData,"@",i)
	.;验证附加医嘱是否有效
	.s PartID=$p(arPartData,"$$",1)
	.d ..GetPAAutoAppendOrdStr(EpisodeID,ARCIM,PartID,.ErrMsg,"")
	.i ErrMsg'="" d
	..s Err=-2
	.q:Err'=0
	.s Err=..InsRepPartItem(arReqArcID,arPartData,OpenLogHospStr)
	q:Err'=0 "-12"

	/// 后处理
	s arDispListData=$p(arListData,"^",4)
	s Err=..InsRepDisp(arReqArcID,arDispListData)
	q:Err'=0 "-13"

	/// 加急^费别
	s TmpParam(arReqArcID)=$p(arListData,"^",8,9)
	
	q 0
}

/// Descript: 插入检查申请
ClassMethod InsAppRep(ListData As %String, mPatSymData As %String = "") As %String
{
	n (ListData,mPatSymData,%session)
	s arNo=..GetCurMaxNo("APPI"_$zd(+$H,8),"5")  ///单号
	s arArcCatID= "" //$p(ListData,"^",1)        ///医嘱子类
	s EpisodeID=$p(ListData,"^",1)      ///EpisodeID
	s arExecLocID=$p(ListData,"^",2)    ///执行科室
	s arEmgFlag=$p(ListData,"^",3)      ///是否加急标志
	s arPurpose=""
	if (mPatSymData'="") {
		s arPurpose=$P(mPatSymData,$C(4),5)
		if arPurpose="" s arPurpose=$p(ListData,"^",4)      ///检查目的
	}else{
		if ListData'="" s arPurpose=$p(ListData,"^",4)  
	}
	s arCreateDocID=$p(ListData,"^",5)  ///申请医生
	s arSendFlag=$p(ListData,"^",10)    ///发送状态
	s arPatDiags=$p(ListData,"^",11)    ///病人诊断
	s arPatDiags=$REPLACE(arPatDiags,"-","||")
	s arCreateDate=..%SysDate()   				///申请日期
	s arCreateTime=..%SysTime()   		///申请时间
	s DoctorID=##class(web.SSUser).GetDefaultCareProvider(arCreateDocID)
	s practiceFlag=##class(web.DHCOEOrdItem).practice(DoctorID)
	if (practiceFlag=1){
		s arSendFlag="I"	
	}
	&SQL(Insert Into DHC_AppReport(AR_No,AR_CreateDate,AR_CreateTime,AR_CreateDoc_Dr,AR_ExecLoc_Dr,AR_Adm_Dr,AR_Cat_Dr,AR_EmgFlag,AR_AppointDoc,AR_Purpose,AR_SendFlag,AR_PatDiags)
		values(:arNo,:arCreateDate,:arCreateTime,:arCreateDocID,:arExecLocID,:EpisodeID,:arArcCatID,:arEmgFlag,:arAppointDocID,:arPurpose,:arSendFlag,:arPatDiags))
	i SQLCODE'=0  q SQLCODE
	q +%ROWID
}

/// Descript: 更新检查申请
ClassMethod UpdAppRep(arReqID As %String, ListData As %String, mPatSymData As %String = "") As %String
{
	n (arReqID, ListData,mPatSymData)
	s arArcCatID="" //$p(ListData,"^",1)     ///医嘱子类
	s EpisodeID=$p(ListData,"^",1)       ///EpisodeID
	s arExecLocID=$p(ListData,"^",2)     ///执行科室
	s arEmgFlag=$p(ListData,"^",3)       ///是否加急标志
	s arPurpose=$P(mPatSymData,$C(4),5)
	if arPurpose="" s arPurpose=$p(ListData,"^",4)      ///检查目的
	s arPatDiags=$p(ListData,"^",11)     ///病人诊断
	s arPatDiags=$REPLACE(arPatDiags,"-","||")
	
	&SQL(Update DHC_AppReport set AR_ExecLoc_Dr=:arExecLocID,AR_Adm_Dr=:EpisodeID,AR_Cat_Dr=:arArcCatID,AR_EmgFlag=:arEmgFlag,AR_Purpose=:arPurpose,AR_PatDiags=:arPatDiags
		Where AR_Rowid=:arReqID)
	i SQLCODE'=0  q SQLCODE
	q +%ROWID
}

/// Descript: 删除检查申请报告主表
ClassMethod delAppRep(arReqID As %String) As %String
{
	n (arReqID)
	&SQL(delete DHC_AppReport Where AR_Rowid=:arReqID)
	q SQLCODE
}

/// Descript: 检查报告医嘱项记录表
ClassMethod InsRepArc(arParref As %String, ListData As %String, ToothInfo As %String) As %String
{
	n (arParref, ListData,ToothInfo)
	s arItmmastID=$p(ListData,"^",1)     ///医嘱项ID
	s arPosiID="" //$p(ListData,"^",2)   ///体位
	s arRemark=$p(ListData,"^",5)        ///备注
	s arSpecCode=$p(ListData,"^",7)      ///标本
	s arChildSub=$o(^DHCAPREP(arParref,"AR",""),-1)+1
	s arEmgFlag=$p(ListData,"^",8)      ///标本
	s arCoverMainIns=$p(ListData,"^",10)      ///医保标志
	s arorderstate=$p(ListData,"^",11)      ///医嘱阶段
	s ItemSpecSiteRowid=$p(ListData,"^",12)      ///标本采集部位
	s ItemQty=$p(ListData,"^",13)      ///数量
	&SQL(Insert Into DHC_AppRepArc(AR_ParRef_Dr,AR_ChildSub,AR_Arc_Dr,AR_Pos_Dr,AR_Remark,AR_SpecCode,
	AR_EmgFlag,AR_CoverMainIns,AR_OrderStage,AR_SpecCollectionSite,AR_ToothInfo,AR_Qty)
		values(:arParref,:arChildSub,:arItmmastID,:arPosiID,:arRemark,:arSpecCode,:arEmgFlag,:arCoverMainIns,:arorderstate,:ItemSpecSiteRowid,:ToothInfo,:ItemQty))
	i SQLCODE'=0  q SQLCODE
	q $p(%ROWID,$C(1))
}

/// Descript: 更新检查报告医嘱项记录表
ClassMethod UpdRepArc(RepArcID As %String, ListData As %String, ToothInfo As %String) As %String
{
	n (RepArcID, ListData,ToothInfo)
	s arItmmastID=$p(ListData,"^",1)     ///医嘱项ID
	s arPosiID="" //$p(ListData,"^",2)   ///体位
	s arRemark=$p(ListData,"^",5)        ///备注
	s arSpecCode=$p(ListData,"^",7)      ///标本
	;s arChildSub=$o(^DHCAPREP(arParref,"AR",""),-1)+1
	s arEmgFlag=$p(ListData,"^",8)      ///标本
	s arCoverMainIns=$p(ListData,"^",10)      ///医保标志
	s arorderstate=$p(ListData,"^",11)      ///医嘱阶段
	&SQL(Update DHC_AppRepArc Set AR_Pos_Dr=:arPosiID,AR_Remark=:arRemark,AR_SpecCode=:arSpecCode,
	AR_EmgFlag=:arEmgFlag ,AR_CoverMainIns=:arCoverMainIns ,AR_OrderStage=:arorderstate,AR_ToothInfo=:ToothInfo
	Where AR_ParRef_Dr =:RepArcID and AR_Arc_Dr=:arItmmastID)
	b ;093232323
	i SQLCODE'=0  q SQLCODE
	q 0 //$p(%ROWID,$C(1))
}

/// Descript: 检查报告医嘱项对应部位记录表
ClassMethod InsRepPart(arParref As %String, arPartID As %String, arRemark As %String, arAppendOrderStr As %String = "", OpenLogHospStr As %String = "") As %String
{
	n (arParref, arPartID, arRemark,arAppendOrderStr,OpenLogHospStr)
	s ExeStatus="V"
	s arChildSub=$o(^DHCAPREP(+arParref,"AR",$p(arParref,"||",2),"PA",""),-1)+1
	
	s AppendOrderStr=""
	for i=1:1:$Length(arAppendOrderStr,"&"){
		s OneAppendOrder=$P(arAppendOrderStr,"&",i)
		s OneArcimDr=$P(OneAppendOrder,"|||",1)
		continue:(OneArcimDr="")
		s $P(OneAppendOrder,"|||",3)="Y"
		s $P(OneAppendOrder,"|||",4)=OpenLogHospStr
		if (AppendOrderStr=""){
			s AppendOrderStr=OneAppendOrder
		}else{
			s AppendOrderStr=AppendOrderStr_"&"_OneAppendOrder
		}
	}
	
	s EpisodeID=$p(^DHCAPREP(+arParref),"^",6)
	s ARCIM=$p(^DHCAPREP(+arParref,"AR",$p(arParref,"||",2)),"^",1) 
	s AutoAppendOrdStr=..GetPAAutoAppendOrdStr(EpisodeID,ARCIM,arPartID,"",OpenLogHospStr)
	if (AutoAppendOrdStr'=""){
		if (AppendOrderStr=""){
			s AppendOrderStr=AutoAppendOrdStr
		}else{
			s AppendOrderStr=AppendOrderStr_"&"_AutoAppendOrdStr
		}
	}
	&SQL(Insert Into DHC_AppRepPart(AR_ParRef_Dr,AR_ChildSub,AR_Part_Dr,AR_ExeStatus,AR_Remark,AR_AppendOrderStr)
		values(:arParref,:arChildSub,:arPartID,:ExeStatus,:arRemark,:AppendOrderStr))
	i SQLCODE'=0  q SQLCODE
	q $p(%ROWID,$C(1))
}

/// Descript: 检查报告医嘱项对应部位记录表
ClassMethod InsRepPosi(arParref As %String, ListData As %String) As %String
{
	n (arParref, ListData)
	s Len = $L(ListData,",")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s arPosiID=+$p(ListData,",",i)     ///体位
	.Q:arPosiID=0
	.
	.&SQL(Insert Into DHC_AppRepPos(AR_RepPart_Dr,AR_Pos_Dr) values(:arParref,:arPosiID))
	.i SQLCODE'=0 S quitflag="1"
	.
	q quitflag
}

/// Descript: 检查报告检查后处理表
ClassMethod InsRepDisp(arParref As %String, ListData As %String) As %String
{
	n (arParref, ListData)
	s Len = $L(ListData,"@")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s arDispID=+$p(ListData,"@",i)     ///部位
	.Q:arDispID=0
	.s arChildSub=$o(^DHCAPREP(+arParref,"AR",$p(arParref,"||",2),"DI",""),-1)+1
	.
	.&SQL(Insert Into DHC_AppRepDisp(AR_ParRef_Dr,AR_ChildSub,AR_Disp_Dr)
		values(:arParref,:arChildSub,:arDispID))
	.i SQLCODE'=0 S quitflag="1"
	.
	q quitflag
}

/// Descript: 检查报告其它项目表
ClassMethod InsRepOthOpt(arParref As %String, ListData As %String) As %String
{
	n (arParref, ListData)
	s Len = $L(ListData,"@")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s itmListData=$p(ListData,"@",i)     ///项目列表
	.s itemid=$p(itmListData,"^",1)       ///项目ID
	.s itemval=$p(itmListData,"^",2)      ///项目值
	.s arChildSub=$o(^DHCAPREP(arParref,"OT",""),-1)+1
	.
	.&SQL(Insert Into DHC_AppRepOthOpt(AR_ParRef_Dr,AR_ChildSub,AR_Opt_Dr,AR_OptVal)
		values(:arParref,:arChildSub,:itemid,:itemval))
	.i SQLCODE'=0 S quitflag="1"
	.
	q quitflag
}

/// Descript: 保存检查部位信息
ClassMethod InsRepPartItem(arReqArcID As %String, arPartData As %String, OpenLogHospStr As %String = "") As %String
{
	n (arReqArcID, arPartData, OpenLogHospStr)
	
	/// 部位
	s PartID=$p(arPartData,"$$",1)
	s arRemark=$p(arPartData,"$$",3)
	q:+PartID=0 0
	s AppendOrderStr=$p(arPartData,"$$",4)
	s arPartID=..InsRepPart(arReqArcID,PartID,arRemark,AppendOrderStr,OpenLogHospStr)
	q:arPartID<0 arPartID
	/// 体位
	s arPosiData=$p(arPartData,"$$",2)
	s Err=..InsRepPosi(arPartID,arPosiData)
	q:Err'=0 "-12"

	q 0
}

/// Descript: 保存现病史
ClassMethod InsPreHis(arReqID As %String, ListData As %String) As %String
{
	n (arReqID, ListData)
	s Err=0
	s EpisodeID=$p(ListData,$C(4),1)       ///就诊ID
	//s arHisID=$o(^DHCAPPREH(0,"ADM",EpisodeID,""))
	s arHisID=$o(^DHCAPPREH(0,"REQ",arReqID,""))
	i arHisID = "" d
	.s Err = ..InsRepPreHis(arReqID, ListData)
	e  d
	.s Err = ..UpdRepPreHis(arHisID, ListData)
	q Err
}

/// Descript: 患者现病史
ClassMethod InsRepPreHis(arReqID As %String, ListData As %String) As %String
{
	n (arReqID, ListData)
	s EpisodeID=$p(ListData,$C(4),1)     ///就诊ID
	s arHisDesc=$p(ListData,$C(4),2)     ///现病史
	
	&SQL(Insert Into DHC_AppPreHis(APH_Adm_Dr,APH_History,APH_Req_Dr)
		values(:EpisodeID,:arHisDesc,:arReqID))
	q SQLCODE
}

/// Descript: 患者现病史
ClassMethod UpdRepPreHis(arHisID As %String, ListData As %String) As %String
{
	n (arHisID, ListData)
	s arHisDesc=$p(ListData,$C(4),2)     ///现病史
	
	&SQL(Update DHC_AppPreHis Set APH_History=:arHisDesc Where APH_Rowid =:arHisID)
	q SQLCODE
}

/// Descript: 保存体征
ClassMethod InsPatSigns(arReqID As %String, ListData As %String) As %String
{
	n (arReqID, ListData)
	s Err=0
	s EpisodeID=$p(ListData,$C(4),1)       ///就诊ID
	//s arSigID=$o(^DHCAPPATSI(0,"ADM",EpisodeID,""))
	s arSigID=$o(^DHCAPPATSI(0,"REQ",arReqID,""))
	i arSigID = "" d
	.s Err = ..InsRepPatSigns(arReqID, ListData)
	e  d
	.s Err = ..UpdRepPatSigns(arSigID, ListData)
	q Err
}

/// Descript: 插入患者体征
ClassMethod InsRepPatSigns(arReqID As %String, ListData As %String) As %String
{
	n (arReqID, ListData)
	s EpisodeID=$p(ListData,$C(4),1)       ///就诊ID
	s arPatSigs=$p(ListData,$C(4),3)       ///体征
		
	&SQL(Insert Into DHC_AppPatSigns(APS_Adm_Dr,APS_Signs,APS_Req_Dr)
		values(:EpisodeID,:arPatSigs,:arReqID))
	q SQLCODE
}

/// Descript: 更新患者体征
ClassMethod UpdRepPatSigns(arSigID As %String, ListData As %String) As %String
{
	n (arSigID, ListData)
	s arPatSigs=$p(ListData,$C(4),3)     ///体征
	
	&SQL(Update DHC_AppPatSigns Set APS_Signs=:arPatSigs Where APS_Rowid =:arSigID)
	q SQLCODE
}

/// Descript: 保存患者主诉
ClassMethod InsPatSymptom(arReqID As %String, ListData As %String) As %String
{
	n (arReqID, ListData)
	s Err=0
	s EpisodeID=$p(ListData,$C(4),1)       ///就诊ID
	//s arPatSymID=$o(^DHCAPPATSY(0,"ADM",EpisodeID,""))
	s arPatSymID=$o(^DHCAPPATSY(0,"REQ",arReqID,""))
	i arPatSymID = "" d
	.s Err = ..InsRepPatSymptom(arReqID, ListData)
	e  d
	.s Err = ..UpdRepPatSymptom(arPatSymID, ListData)
	q Err
}

/// Descript: 插入患者主诉
ClassMethod InsRepPatSymptom(arReqID As %String, ListData As %String) As %String
{
	n (arReqID, ListData)
	s EpisodeID=$p(ListData,$C(4),1)       ///就诊ID
	s arPatSymID=$p(ListData,$C(4),4)      ///主诉
		
	&SQL(Insert Into DHC_AppPatSymptom(APS_Adm_Dr,APS_Symptom,APS_Req_Dr)
		values(:EpisodeID,:arPatSymID,:arReqID))
	q SQLCODE
}

/// Descript: 更新患者主诉
ClassMethod UpdRepPatSymptom(arPatSymID As %String, ListData As %String) As %String
{
	n (arPatSymID, ListData)
	s arPatSymptom=$p(ListData,$C(4),4)     ///主诉
	
	&SQL(Update DHC_AppPatSymptom Set APS_Symptom=:arPatSymptom Where APS_Rowid =:arPatSymID)
	q SQLCODE
}

/// Descript: 处理其他项目
ClassMethod GetRepOthOpt(pid As %String, aListData As %String, arReqID As %String = "") As %String
{
	n (pid, aListData, arReqID)
	Q:pid="" ""
	s oListData=""
	f i=1:1:$L(aListData,"&&")  d
	.s mListData=$p(aListData,"&&",i)
	.s itmmastid=$p(mListData,"^",1)  /// 医嘱项目ID
	.Q:itmmastid=""
	.Q:$d(tmpItmmastid(itmmastid))
	.s tmpItmmastid(itmmastid)=""     /// 相同医嘱项目过滤
	.s tmp=""
	.f  s tmp=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,tmp)) Q:tmp=""  D
	..s itmid=""
	..f  s itmid=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,tmp,itmid)) Q:itmid=""  D
	...Q:(arReqID="")&&(itmid'=itmmastid)
	...Q:(arReqID'="")&&(itmid'=arReqID)
	...s mdata=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,tmp,itmid))
	...Q:mdata=""
	...s itemid=$p(mdata,"^",1)   /// 项目ID
	...s itemval=$p(mdata,"^",4)  /// 项目ID
	...Q:itemval=""
	...q:((itemid["||")&&(itemval'="Y"))
	...if ((itemid["||")&&(itemval="Y"))  s itemval=itemid,itemid=+itemid
	...i oListData'="" s oListData=oListData_"@"_itemid_"^"_itemval
	...e  s oListData=itemid_"^"_itemval
	..
	Q oListData
}

/// Descript: 删除申请
ClassMethod DelRepTable(arParref As %String) As %String
{
	n (arParref)
	s SQLCODE=0
	///检查报告医嘱项记录表
	//i $d(^DHCAPREP(arParref,"AR",1)) D
	//.&SQL(delete from DHC_AppRepArc where AR_ParRef_Dr=:arParref)
	//Q:SQLCODE'=0 SQLCODE
	///检查报告其它项目表
	i $d(^DHCAPREP(arParref,"OT",1)) D
	.&SQL(delete from DHC_AppRepOthOpt where AR_ParRef_Dr=:arParref)
	Q:SQLCODE'=0 SQLCODE
	Q 0
}

/// Descript: 保存检查申请Html格式内容
/// W ##Class(web.DHCAPPExaReport).InsExaRepContentHtml("")
ClassMethod InsExaRepContentHtml(arReqID As %String) As %String
{
	n (arReqID)
	s $ZT="RetErrMsg"
	Q:'$d(^DHCAPREP(arReqID)) ""
	s ExaRepNo=$p(^DHCAPREP(arReqID),"^",1)      /// 单号
	/// 通过医嘱ID获取检查申请内容Html
	s ExaRepContent=##Class(web.DHCAPPInterface).GetExaReqHtmlContentCT(arReqID)
	D ..insertHtmlView(ExaRepNo,ExaRepContent)   /// 插入检查申请Html内容表
	s rtn=##Class(web.DHCAPPInterface).SendExaReqIDToPlat(arReqID)
	Q 0
RetErrMsg
	Q -1
}

/// Descript: 插入检查申请Html内容表
ClassMethod insertHtmlView(ExaRepNo As %String, ExaRepContent As %String) As %String
{
	n (ExaRepNo, ExaRepContent)
	&SQL(insert into DHC_AppRepHtmlView(ARHV_RepNo,ARHV_Content) values(:ExaRepNo,:ExaRepContent))
	Q SQLCODE
}

/// Descript:   取当前不良反应报告最大码
ClassMethod GetCurMaxNo(Prefix As %String, NoLen As %String) As %String
{
	N (Prefix,NoLen)
	S NextNo=""
	s Suffix=$I(^DHCPHCMAPP("DHCPHCMADR",Prefix))
	S slen=$L(Suffix)
	S flen=NoLen-slen
	F i=1:1:flen S Suffix="0"_Suffix
	S NextNo=Prefix_Suffix
	q NextNo
}

/// Descript:获取当前最大码
/// 科室当前处方最编码
ClassMethod GetMaxCodeByCode(Prefix As %String) As %String
{
	N (Prefix)
	Q:Prefix="" ""
	S adrrcode="0"
	S PreLen=$L(Prefix)
	//&sql(select max(AR_No) into :adrrcode from DHC_AppReport Where AR_No %STARTSWITH %ALPHAUP :Prefix)
	s ARRowID=""
	for{
		s ARRowID=$O(^DHCAPREP(0,"CreateDate",+$H,ARRowID))
		q:ARRowID=""
		s MaxNo=$P(^DHCAPREP(ARRowID),"^",1)
		continue:MaxNo'[Prefix
		if $E(MaxNo,PreLen+1,$l(MaxNo))>$E(adrrcode,PreLen+1,$l(adrrcode)) s adrrcode=MaxNo
	}
	Q adrrcode
}

/// Descript:	生成检查医嘱
ClassMethod InsOrderItems(arReqID As %String, mListData As %String, TmpParam As %String, ByRef ErrMsg As %String = "", LgParams As %String = "") As %String
{
	n (arReqID,mListData,TmpParam,ErrMsg,LgParams,%session)
	
	/// 根据配置判断是否插入医嘱
	///Q 0
	
	s Err = 0
	
	/// 插入收费项
	s Err = ..InsExaReqTarItem(arReqID)
	q:Err'=0 "-15"

	/// 插入医嘱
	s Err = ..InsOeori(arReqID,mListData,.TmpParam,.ErrMsg,LgParams)
	b ;0932323
	q:Err'=0 "-16"

	q Err
}

/// Descript:	插入医嘱
/// W ##Class(web.DHCAPPExaReport).InsOeori("24","10515||1^234","16","234")
ClassMethod InsOeori(arReqID As %String, mListData As %String, TmpParam As %String, ByRef ErrMsg As %String = "", LgParams As %String = "") As %String
{
	n (arReqID,mListData,TmpParam,ErrMsg,LgParams,%session)
	s arEpisodeID=$p(mListData,"^",1)        /// EpisodeID
	s arExecLocID=$p(mListData,"^",2)    	 /// 执行科室
	s arUserID=$p(mListData,"^",5)  		 /// 申请医生
	s arLocID=$p(mListData,"^",8)  		 	 /// 申请科室
	s arEmgFlag=$p(mListData,"^",3)          /// 是否加急标志
	s PPRowId=$p(mListData,"^",12)  //药理项目ID
	s ChronicDiagCode=$p(mListData,"^",13) //慢特病 
	s EmConsultItm=$p(mListData,"^",14) // 会诊子表ID
	s NotBindLabFee=$p(mListData,"^",15) // 检验不绑定管子费标志
	s Err=0
	s CH="",mOrderItems=""
	F  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:(CH="")||(Err'=0)  D
	.s itmmast=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)  /// 医嘱项ID
	.s arReqArcID=arReqID_"||"_CH
	.s arExaReqNote="" //##Class(web.DHCAPPInterface).GetExaReqPartNote(arReqArcID) /// 备注
	.s arExaReqNote=$p(^DHCAPREP(arReqID,"AR",CH),"^",4) /// 备注
	.s ASStatus=$p(^DHCAPREP(arReqID,"AR",CH),"^",9) /// 状态
	.q:ASStatus="D"
	.s itmmaststr = itmmast_"^"_arExecLocID
	.s SpeCode=$p(^DHCAPREP(arReqID,"AR",CH),"^",7)  //标本Code  SUFAN 2018-02-03
	.s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",1,##Class(LIS.Util.Common).IndexData(SpeCode),""))
	.i $p($g(TmpParam(arReqID_"||"_CH)),"^",1)'="" s arEmgFlag=$p($g(TmpParam(arReqID_"||"_CH)),"^",1) /// 加急标志
	.s BillTypeID=$p($g(TmpParam(arReqID_"||"_CH)),"^",2)                 /// 费别
	.s CoverMainIns=$p(^DHCAPREP(arReqID,"AR",CH),"^",11)  //医保
	.if (CoverMainIns=1) s CoverMainIns="Y"
	.e  s CoverMainIns="N"
	.s OrderStage=$p(^DHCAPREP(arReqID,"AR",CH),"^",12)  //医嘱阶段
	.s ItemSpecSiteRowid=$p(^DHCAPREP(arReqID,"AR",CH),"^",14)  //医嘱标本采集部位
	.s ItemQty=$p(^DHCAPREP(arReqID,"AR",CH),"^",15)  //数量
	.s:+ItemQty=0 ItemQty=1
	.s ListData=..GetOrderItems(arEpisodeID,itmmaststr,arUserID,arLocID,arEmgFlag,arExaReqNote,arReqArcID,SpeCode,"",BillTypeID,CoverMainIns,OrderStage) /// 插入医嘱
	.s $p(ListData,"^",14)=ItemQty
	.s $p(ListData,"^",56)=PPRowId
	.s $p(ListData,"^",81)=EmConsultItm
	.s $p(ListData,"^",82)=ChronicDiagCode
	.s $p(ListData,"^",84)=ItemSpecSiteRowid
	.i mOrderItems="" s mOrderItems=ListData
	.E  s mOrderItems=mOrderItems_$C(1)_ListData
	s CareProvID=$p($g(^SSU("SSUSR",arUserID)),"^",14)   /// 医生ID

	#; s OrdAddCongeriesArr=[],BaseParamJson="{}"
	#; if (NotBindLabFee="Y"){
	#; 	s BaseParamObj=##class(DHCDoc.Util.ArrayData).%New()
	#; 	d BaseParamObj.SetAt(",BF,CT,SP,","DisBindTypeList")
	#; 	s BaseParamJson=BaseParamObj.%ToJSON().Read()
	#; }
	#; s OrdAddCongeriesJson=##class(web.DHCOEOrdAppendItem).GetAppendOrdItemArr(arEpisodeID,mOrderItems,"",.OrdAddCongeriesArr,LgParams,BaseParamJson)
	#; k OrdCongeriesArr
	#; d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(OrdAddCongeriesJson,.OrdCongeriesArr)
	#; s OrdCounter=""
	#; for {
	#; 	s OrdCounter=$O(OrdCongeriesArr(OrdCounter))
	#; 	q:(OrdCounter="")
	#; 	s mOrderItems=mOrderItems_$C(1)_$g(OrdCongeriesArr(OrdCounter,"OrdListInfo"))
	#; } 
	#; s ret=##class(web.DHCOEOrdItem).SaveOrderItems(arEpisodeID, mOrderItems, arUserID, arLocID, CareProvID, "",ExpStr,.ErrMsg)
	s ExpStr="^^^Y^"_PPRowId_"^^^^^"_NotBindLabFee
	s ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(arEpisodeID, mOrderItems, arUserID, arLocID, CareProvID, "",ExpStr,.ErrMsg)
	if (ErrMsg'="") s ErrMsg=$p(ErrMsg,$C(1),2)
	Q:ret=100 "-1"
	//插入检查目的绑定医嘱
	d ..InsertLinkOtherOpt(arReqID,arUserID, arLocID,PPRowId)
	Q 0
}

/// Descript:	取插入医嘱内容
/// W ##Class(web.DHCAPPExaReport).GetOrderItems("315","58841||1^123","4636","110","","","","","","1")
ClassMethod GetOrderItems(EpisodeID As %String, itmmaststr As %String, UserID As %String, LocID As %String, arEmgFlag As %String, arExaReqNote As %String, arReqArcID As %String, SpeCode As %String = "", mOeori As %String = "", BillTypeID As %String = "", CoverMainIns As %String = "", OrderStage As %String = "") As %String
{
	n (EpisodeID, itmmaststr, UserID, LocID, arEmgFlag, arExaReqNote, arReqArcID, SpeCode, mOeori, BillTypeID,CoverMainIns,OrderStage,%session)

	s CareProvID=$p($g(^SSU("SSUSR",UserID)),"^",14)   /// 医生ID
	s OrderPriorId=$O(^OECPR(0,"Code","NORM",0))       /// 优先级
	s SeqNo=$P(arReqArcID,"||",2)
	s OrderStartDate=$zd(+$h,4)						   /// 医嘱日期
	s OrderStartTime=..%ZT(..%SysTime(),1)			   /// 医嘱时间
	s DischargeDateTime=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetDischargeDateTime",EpisodeID)
	s DischargeDate=$p(DischargeDateTime,"^",1)
	s DischargeTime=$p(DischargeDateTime,"^",2)
	if (DischargeDate'="") {
		s OrderStartDate=$zd(DischargeDate,4)
		s OrderStartTime=..%ZT(DischargeTime-1,1)
	}
	/*s EsDischgDate=$p(^PAADM(EpisodeID),"^",59)		   /// 出院日期
	s EsDischgTime=$p(^PAADM(EpisodeID),"^",60)        /// 出院时间
	i EsDischgDate'="" s OrderStartDate=$zd(EsDischgDate,4)	
	i EsDischgTime'="" s OrderStartTime=..%ZT(EsDischgTime,2)*/
	i BillTypeID="" D
	.s BillTypeID=$P(^PAADM(EpisodeID,1),"^",7)        /// 费别指针
	s PackQty = 1									   /// 医嘱数量
	s DoseQtySum=PackQty							   /// 基本单位总数量
	
	s itmmastid=$p(itmmaststr,"^",1)
	s recLocID=$p(itmmaststr,"^",2)		  	   /// 接收科室
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
	//s PPID=##class(web.DHCAPPExaReport).GetPilotProStrByAdm(EpisodeID)
	s itemPrice=1 //##class(web.DHCAPPInterface).GetExaReqCost(itmmastid,"",EpisodeID,"","")
	s ListData=itmmastid_"^"_OrderType_"^"_OrderPriorId_"^"_OrderStartDate_"^"_OrderStartTime_"^"_PackQty_"^"_itemPrice_"^"_recLocID_"^"_BillTypeID
	s ListData=ListData_"^"_DrgFormRowid_"^"_arExaReqNote_"^"_""_"^"_""_"^"_DoseQtySum_"^"_FreqRowid_"^"_DurRowid_"^"_InstrRowid_"^"_""_"^"_""_"^"_SeqNo
	s ListData=ListData_"^"_""_"^"_""_"^"_$g(CoverMainIns)_"^"_""_"^"_""_"^"_""_"^"_""_"^"_SpeCode_"^"_""_"^"_arEmgFlag
	//s $p(ListData,"^",56)=PPID
	s $p(ListData,"^",46)=OrderStartDate
	s $p(ListData,"^",47)=OrderStartTime
	s $p(ListData,"^",59)=arReqArcID
	s $p(ListData,"^",39)=mOeori   /// 主医嘱ID
	s $p(ListData,"^",35)=OrderStage
	Q ListData
}

/// w ##class(web.DHCAPPExaReport).GetPilotProStrByAdm(821)
ClassMethod GetPilotProStrByAdm(EpisodeID)
{
	n (EpisodeID)
	q:+EpisodeID=0 ""
	s PPID=""
	s PatientID = $P(^PAADM(EpisodeID),"^",1)
	s PPRowId=""
	f  s PPRowId=$o(^DHCDocPPP("PapmiDr",0,PatientID,PPRowId)) q:PPRowId=""  d
	.s PPRowItm=""
	.f  s PPRowItm=$o(^DHCDocPPP("PapmiDr",0,PatientID,PPRowId,PPRowItm)) q:PPRowItm=""  d
	..s PPRowSub=0
	..f  s PPRowSub=$o(^DHCDocPPPA(PPRowId,PPRowItm,PPRowSub)) q:PPRowSub=""  d
	...s ActivFlag = $p(^DHCDocPPPA(PPRowId,PPRowItm,PPRowSub),"^",4)
	...q:ActivFlag'="Y"
	...s PPEpisodeID = $p(^DHCDocPPPA(PPRowId,PPRowItm,PPRowSub),"^",1)
	...q:EpisodeID'=PPEpisodeID
	...s PPID = PPRowId
	q PPID
}

/// Descript:	插入医嘱
/// W ##Class(web.DHCAPPExaReport).InsOeori("24","10515||1^234","16","234")
ClassMethod InsOeoriOLD(arReqID As %String, mListData As %String, TmpParam As %String) As %String
{
	n (arReqID,mListData,TmpParam)
	s arEpisodeID=$p(mListData,"^",1)        /// EpisodeID
	s arExecLocID=$p(mListData,"^",2)    	 /// 执行科室
	s arUserID=$p(mListData,"^",5)  		 /// 申请医生
	s arLocID=$p(mListData,"^",8)  		 	 /// 申请科室
	s arEmgFlag=$p(mListData,"^",3)          /// 是否加急标志
	s Err=0
	s CH=""
	F  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:(CH="")||(Err'=0)  D
	.s itmmast=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)  /// 医嘱项ID
	.s arReqArcID=arReqID_"||"_CH
	.s arExaReqNote="" //##Class(web.DHCAPPInterface).GetExaReqPartNote(arReqArcID) /// 备注
	.s arExaReqNote=$p(^DHCAPREP(arReqID,"AR",CH),"^",4) /// 备注
	.s itmmaststr = itmmast_"^"_arExecLocID
	.s SpeCode=$p(^DHCAPREP(arReqID,"AR",CH),"^",7)  //标本Code  SUFAN 2018-02-03
	.s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",1,##Class(LIS.Util.Common).IndexData(SpeCode),""))
	.i $p($g(TmpParam(arReqID_"||"_CH)),"^",1)'="" s arEmgFlag=$p($g(TmpParam(arReqID_"||"_CH)),"^",1) /// 加急标志
	.s BillTypeID=$p($g(TmpParam(arReqID_"||"_CH)),"^",2)                 /// 费别
	.s ret=##Class(web.DHCAPPExaReport).SaveOrderItems(arEpisodeID,itmmaststr,arUserID,arLocID,arEmgFlag,arExaReqNote,arReqArcID,SpeCode,"",BillTypeID) /// 插入医嘱
	.i ret=100 s Err=-1
	.
	Q:Err'=0 Err
	Q 0
}

/// Descript:	插入医嘱
/// W ##Class(web.DHCAPPExaReport).SaveOrderItems("315","58841||1^123","4636","110","","","","","","1")
ClassMethod SaveOrderItems(EpisodeID As %String, itmmaststr As %String, UserID As %String, LocID As %String, arEmgFlag As %String, arExaReqNote As %String, arReqArcID As %String, SpeCode As %String = "", mOeori As %String = "", BillTypeID As %String = "", PPFlag = "Y", InsurFlag As %String = "", ChronicDiagCode As %String = "", ByRef ErrMsg As %String = "", IsCheckOrdItemStr As %String = "Y") As %String
{
	n (EpisodeID, itmmaststr, UserID, LocID, arEmgFlag, arExaReqNote, arReqArcID, SpeCode, mOeori, BillTypeID, PPFlag, InsurFlag, ChronicDiagCode, ErrMsg, IsCheckOrdItemStr,%session)

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
	s PPID=""
	i PPFlag="Y" D  /// 临床科研标识
	.s PilotProStr=##Class(web.PilotProject.DHCDocPilotProPat).GetPilotProStr(EpisodeID,UserID)
	.s PPID=$P(PilotProStr,$c(1))
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
	
	s ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(EpisodeID, ListData, UserID, LocID, CareProvID, "", "^^^"_IsCheckOrdItemStr_"^"_PPID,.ErrMsg)
	
	if (ErrMsg'="") s ErrMsg=$p(ErrMsg,$C(1),2)
	Q ret
}

/// Descript:  判断安全组的权限
ClassMethod CheckLgGroupAuth(arcItmCatID As %String, LgGroupID As %String) As %String
{
	n (arcItmCatID, LgGroupID)
	s quitflag=0
	s ID = ""
	f  s ID=$o(^SSU("SSGRP",LgGroupID,"SSORD",ID)) Q:(ID="")||(quitflag=1)  D
	.s itmCatID=$p(^SSU("SSGRP",LgGroupID,"SSORD",ID),"^",5)
	.q:itmCatID'=arcItmCatID
	.s quitflag=1
	q quitflag
}

/// Descript:  删除指定项目部位
/// W ##Class(web.DHCAPPExaReport).delExaReqItm("84903||1","200")
ClassMethod delExaReqItm(arReqItmID As %String, inPartID As %String) As %String
{
	n (arReqItmID, inPartID)
	s Err=0,Num=0,PartNum=0,arPartID=""
	s arReqID=$p(arReqItmID,"||",1)
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:CH=""  D
	.s Num=Num+1
	.s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)        /// 医嘱项目ID
	.Q:(arReqID_"||"_CH)'=arReqItmID
	.s Sub=""
	.f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	..s PartNum=PartNum+1
	..s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)    /// 部位ID
	..Q:PartID'=inPartID
	..s ExeStatus=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) /// 执行状态
	..i ExeStatus="E" s Err=1
	..s arPartID=arReqID_"||"_CH_"||"_Sub
	.

	Q:Err'=0 Err
	TS
	/// 更新收费项目记录表
	i +inPartID'=0 s Err=##Class(web.DHCAPPExaReport).SetExaReqTarItm(arReqID,CH)
	i Err'=0 tro
	Q:Err'=0 "-12"

	i ((Num=1)&(+inPartID=0))||((PartNum=1)&(+inPartID'=0)) D
	.s Err=..delAppRep(arReqID)         /// 删除检查申请报告主表
	E  D
	.i +inPartID=0 D
	..s Err=..delAppRepArc(arReqItmID)  /// 删除医嘱项目
	.E  D
	..s Err=..delAppRepPart(arPartID)   /// 删除检查申请报告部位表
	
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	TC
	Q Err
}

/// Descript:  撤销选中项目
/// w ##class(web.DHCAPPExaReport).revExaReqItm("2027||1||2","15","18881^189^29")
ClassMethod revExaReqItm(arRepItmID As %String, PartID As %String, LgParam As %String) As %String
{
	n (arRepItmID, PartID, LgParam,%session)
	s ^BIANSHUAI(123)=$lb(arRepItmID, PartID, LgParam)
	s Err=0
	/// 撤销前检查数据
	s Err=..isAllowRevReqItm(arRepItmID, LgParam)
	Q:Err'=0 Err
	s LgUserID=$p(LgParam,"^")
	i PartID = "" D
	./// 调用停医嘱函数
	.s Err=..InvStopOrder(arRepItmID,LgUserID)
	E  D
	.s Err=..revExaReqPart(arRepItmID,PartID,LgUserID)
	.i Err=0 d
	..s arReqID=$p(arRepItmID,"||",1), CH=$p(arRepItmID,"||",2)
	..Q:'$D(^DHCAPREP(arReqID,"AR",CH))
	../// 医嘱ID
	..s Oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)
	../// 医嘱状态
	..Q:##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)'="V"
	..s Ret=##Class(web.DHCAPPInterface).UpdExaReqItmStatus("OCA",arRepItmID,PartID,LgUserID)
	
	;s Ret = ##Class(web.DHCAPPInterface).UpdExaReqItmStatus("OCA",arRepItmID,PartID,LgUserID)  //不用调用修改状态的接口
	
	Q Err
}

/// Descript:  撤销选中项目
ClassMethod revExaReqPart(arPartID As %String, PartID As %String, LgUserID As %String) As %String
{
	n (arPartID, PartID, LgUserID,%session)
	s Err=0
	/// 取检查申请是否可以单部位撤销标志
	s PartTarFlag=..GetPartTarFlag(arPartID)
	i PartTarFlag'="Y" D
	.s Err=..revExaReqPartItm(arPartID,PartID,LgUserID)
	E  D
	.s Err=..revOeoriPartItm(arPartID,PartID,LgUserID)
	Q Err
}

/// Descript:  撤销医嘱项对应的所有部位
ClassMethod revOeoriPartItm(arPartID As %String, PartID As %String, LgUserID As %String) As %String
{
	n (arPartID, PartID, LgUserID,%session)
	s Err=0
	s arReqID=$p(arPartID,"||",1), CH=$p(arPartID,"||",2)
	Q:'$D(^DHCAPREP(arReqID,"AR",CH)) "-11"
	/// 医嘱ID
	s Oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)
	/// 医嘱状态
	Q:##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)'="V" "-12"
	TS
	/// 修改部位的状态和对应执行记录的状态
	s Err=..SetPartExecFlag(arPartID,LgUserID)
	i Err'=0 tro
	Q:Err'=0 "-13"

	/// 更新收费项目记录表
	s Err=..SetExaReqTarItm(arPartID,"")
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 修改医嘱计费状态
	s Err=..ModOeoriBillFlag(arPartID)
	i Err'=0 tro
	Q:Err'=0 "-15"

	/// 停医嘱调用
	s Err=..SetExaReqItmStopOrder(arPartID,LgUserID)
	i Err'=0 tro
	Q:Err'=0 "-16"
	
	/// 停止附加医嘱
	s AppendOrderStr=$p(^DHCAPREP(arReqID,"AR",CH,"PA",$p(arPartID,"||",3)),"^",10)
	for i=1:1:$L(AppendOrderStr,"&"){
		s Oeori=$P(AppendOrderStr,"&",i)
		s EpisodeID=$p(^DHCAPREP(+arReqID),"^",6)	/// 就诊ID
		s PatType=$p(^PAADM(EpisodeID),"^",2)  		/// 病人类型
		i PatType="I" D
		.s ExpStr=PartID
		.s Err1=##class(appcom.OEOrdItem).CancelMulti(Oeori,LgUserID,"","N","","","") /// 住院撤销医嘱
		E  D
		.s ExpStr="0^"_PartID
		.s Err1=##Class(appcom.OEOrdItem).Stop(Oeori,LgUserID,"","","","","","")   /// 门诊停止医嘱
	}
	TC
	Q Err
}

/// Descript: 修改部位的状态和对应执行记录的状态
ClassMethod SetPartExecFlag(arPartID As %String, LgUserID As %String) As %String
{
	n (arPartID, LgUserID,%session)
	s Err=0
	s arReqID=$p(arPartID,"||",1), CH=$p(arPartID,"||",2)
	Q:'$D(^DHCAPREP(arReqID,"AR",CH)) "-11"
	s Sub=""
	F  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:(Sub="")||(Err'=0)  D
	./// 部位ID
	.s PartID=+$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)
	.Q:PartID=0 
	./// 执行状态
	.Q:$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2)="D"
	.s arPartID=arReqID_"||"_CH_"||"_Sub
	./// 设置部位执行状态
	.s Err=..SetExaReqPartStat(arPartID,"D",LgUserID)
	.Q:Err'=0
	./// 修改医嘱执行表状态
	.s Err=..SetPartExecExt(arPartID,PartID,LgUserID)
	.Q:Err'=0
	.
	Q Err
}

/// Descript:  获取检查申请是否可以单部位撤销标志
/// OutPut:    N-允许单部位撤销，Y-全部撤销
/// W ##Class(web.DHCAPPExaReport).GetPartTarFlag("2||1","8038")
ClassMethod GetPartTarFlag(arPartID As %String) As %String
{
	n (arPartID,%session)
	s arReqID=$p(arPartID,"||",1), CH=$p(arPartID,"||",2)
	Q:'$D(^DHCAPREP(arReqID,"AR",CH)) "N"
	/// 就诊ID
	s EpisodeID=$p(^DHCAPREP(arReqID),"^",6)
	/// 病人类型
	Q:$p(^PAADM(EpisodeID),"^",2)'="I" "N"
	/// 医嘱项ID
	s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)
	/// 多部位只收取一个部位价钱
	s TarFlag=##Class(web.DHCAPPExaRepCom).GetItemTarFlag(arcimid)
	/// 医嘱ID
	s Oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)
	Q:Oeori="" "N"
	/// 账单状态
	s TarID=$o(^DHCAPREPTA(0,"OrdItem",Oeori,""),-1)
	Q:TarID="" "N"
	s Billed=$p(^DHCAPREPTA(TarID),"^",9)
	Q:(TarFlag="N")&(Billed="B") "Y"
	Q "N"
}

/// Descript:  撤销选中项目
ClassMethod revExaReqPartItm(arItmPartID As %String, PartID As %String, LgUserID As %String) As %String
{
	n (arItmPartID, PartID, LgUserID,%session)
	s Err=0
	
	/// 检查当前对应部位是否允许停止
	s Err=##Class(web.DHCAPPExaReport).GetPartCurFlag(arItmPartID,PartID)
	Q:Err'=0 Err
	TS
	s Oeori=$p(^DHCAPREP(+arItmPartID,"AR",$p(arItmPartID,"||",2)),"^",3)
	if (Oeori="") {
		;DHC_AppRepPart->AR_ExeStatus、AR_XDate、AR_XUser
		s Err=..SetExaReqPartStat(arItmPartID,"D",LgUserID)
		//&SQL(delete DHC_AppRepPart where  AR_RowID=:arItmPartID)
		i Err'=0 tro
		if (##Class(web.DHCAPPExaReport).GetExaReqItmStat(arItmPartID,"")=0) {
			s arReqItmID=$p(arItmPartID,"||",1,2)
			&SQL(update DHC_AppRepArc set AR_Status="D" where AR_RowID=:arReqItmID)	
			i SQLCODE'=0 tro
			s Err=SQLCODE
		}
		TC
		Q Err
	}
 	; 设置部位执行状态
 	;DHC_AppRepPart->AR_ExeStatus、AR_XDate、AR_XUser
	s Err=..SetExaReqPartStat(arItmPartID,"D",LgUserID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 修改医嘱执行表状态
	s Err=..SetPartExecExt(arItmPartID,PartID,LgUserID)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/// 更新收费项目记录表
	s isFlag=..isUpdTarItm(arItmPartID,PartID) /// 是否需要更新检查申请收费项目表
	i isFlag'=1 s Err=..SetExaReqTarItm(arItmPartID,PartID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 修改医嘱计费状态
	s Err=..ModOeoriBillFlag(arItmPartID)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 停医嘱调用
	s Err=..SetExaReqItmStopOrder(arItmPartID,LgUserID,PartID)
	i Err'=0 tro
	Q:Err'=0 "-15^"_Err
	/// 停医嘱部位
	s AppendOrderStr=$p(^DHCAPREP(+arItmPartID,"AR",$p(arItmPartID,"||",2),"PA",$p(arItmPartID,"||",3)),"^",10)
	for i=1:1:$L(AppendOrderStr,"&"){
		s Oeori=$P(AppendOrderStr,"&",i)
		s EpisodeID=$p(^DHCAPREP(+arItmPartID),"^",6)	/// 就诊ID
		s PatType=$p(^PAADM(EpisodeID),"^",2)  		/// 病人类型
		continue:Oeori=""
		i PatType="I" D
		.s ExpStr=PartID
		.s Err1=##class(appcom.OEOrdItem).CancelMulti(Oeori,LgUserID,"","N","","","") /// 住院撤销医嘱
		E  D
		.s ExpStr="0^"_PartID
		.s Err1=##Class(appcom.OEOrdItem).Stop(Oeori,LgUserID,"","","","","","")   /// 门诊停止医嘱
	}
	TC
	/// 撤销部位时，调用接口发送给PAC
	D ##Class(web.DHCAPPInterface).InvokeRISService(arItmPartID,PartID,LgUserID)
	Q Err
}

/// Descript:  设置部位执行状态
ClassMethod SetExaReqPartStat(arItmPartID As %String, ExeStatus As %String, LgUserID As %String) As %String
{
	n (arItmPartID,ExeStatus,LgUserID)
	s arXDate=..%SysDate()   				///停止日期
	s arXTime=..%SysTime()   		///停止时间
	&SQL(update DHC_AppRepPart set AR_ExeStatus=:ExeStatus,AR_XDate=:arXDate, AR_XTime=:arXTime, AR_XUser=:LgUserID where AR_RowID=:arItmPartID)
	Q SQLCODE
}

/// Descript:  设置部位对应执行记录表执行状态
ClassMethod SetPartExecExt(arPartID As %String, PartID As %String, LgUserID As %String) As %String
{
	n (arPartID,PartID,LgUserID)
	s reqItmID=$p(arPartID,"||",1,2)
	s PartFlag=##Class(web.DHCAPPExaReport).GetExaReqItmStat(reqItmID,"") /// 是否存在非停部位
	s Err=0
	s TarID=""
	F  s TarID=$o(^DHCAPREPTA(0,"ReqItm",reqItmID,TarID)) Q:(TarID="")||(Err'=0)  D
	.s Billed=$p(^DHCAPREPTA(TarID),"^",9)   /// 计费状态
	.Q:(Billed="I")||(Billed="R")
	.s TarType=$p(^DHCAPREPTA(TarID),"^",3)  /// 类型
	.Q:(TarType'="P")&(PartFlag=1)
	.s IPartID=+$p(^DHCAPREPTA(TarID),"^",1) /// pointor 指针
	.Q:(TarType="P")&(IPartID'=PartID)
	.s OrdExecID=$p(^DHCAPREPTA(TarID),"^",10)
	.s Err=..SetExecBilled(OrdExecID,"I")  /// 计费状态 OE_OrdExec
	.Q:Err'=0
	.s Err=##Class(web.DHCAPPInterface).SetExecExtStat(OrdExecID,"D",LgUserID) /// 执行状态 OE_OrdExecExt
	Q Err
}

/// Descript:	设置执行表计费状态
ClassMethod SetExecBilled(OrdExecID As %String, BillFlag As %String) As %String
{
	n (OrdExecID, BillFlag)
	s Ord=$p(OrdExecID,"||",1)
	s Itm=$p(OrdExecID,"||",2)
	s Err=0
	s Sub=0
	F  s Sub=$o(^OEORD(Ord,"I",Itm,"X",Sub)) Q:(Sub="")||(Err'=0)  D
	.s BillFlag=$p(^OEORD(Ord,"I",Itm,"X",Sub),"^",6)  /// 账单状态
	.s IOrdExecID=Ord_"||"_Itm_"||"_Sub
	.Q:(BillFlag="TB")&(OrdExecID'=IOrdExecID)
	.s ExecID=$p(^OEORD(Ord,"I",Itm,"X",Sub),"^",16)  /// 执行状态
	.i BillFlag="B" s BillFlag="I"
	.i BillFlag="TB" s BillFlag="R"
	.s ExeFlag=""
	.i OrdExecID=IOrdExecID s ExeFlag="D"
	.s Err=..UpdExecBilled(IOrdExecID, BillFlag, ExecID, ExeFlag)
	Q Err
}

/// Descript:  设置执行记录表计费状态
ClassMethod UpdExecBilled(OrdExecID As %String, BillFlag As %String, ExecID As %String, ExeFlag As %String) As %String
{
	n (OrdExecID, BillFlag, ExecID, ExeFlag)
	i ExeFlag'="" D
	.s ExecID=$o(^OEC("STAT",0,"Code",$$ALPHAUP^SSUTIL4(ExeFlag),""))
	&SQL(update OE_OrdExec set OEORE_Billed=:BillFlag, OEORE_Order_Status_DR=:ExecID where OEORE_RowId=:OrdExecID)
	Q SQLCODE
}

/// Descript:  删除检查申请报告部位表记录
ClassMethod delAppRepPart(arPartID As %String) As %String
{
	n (arPartID)
	&SQL(delete from DHC_AppRepPart where AR_RowID=:arPartID)
	Q SQLCODE
}

/// Descript:  删除检查申请报告项目表记录
ClassMethod delAppRepArc(arPartID As %String) As %String
{
	n (arPartID)
	&SQL(delete from DHC_AppRepArc where AR_RowID=:arPartID)
	Q SQLCODE
}

/// Descript:  合并相同检查项目
/// 		   规则:1、按照接收科室分组，一个接收科室一个申请单；
///                 2、按照医嘱项分组，同一个医嘱项在体位和后处理相同的情况下(仅部位不同)，为同一个项目
/// W ##Class(web.DHCAPPExaReport).dealInsListData("")
ClassMethod dealInsListData(ListData As %String) As %String
{
	n (ListData)
	
	s pid=##Class(web.DHCAPPExaReportQuery).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
    k itmExaPurp
	s Len = $L(ListData,$C(1))   		 /// 检查分类数目
	f i=1:1:Len  d
	.s sListData=$p(ListData,$C(1),i)
	.s arReqID = $p(sListData,$C(2),1)  	   /// 检查分类项目ID
	.s armListData = $p(sListData,$C(2),2)   /// 申请表主信息
	.s arcListData = $p(sListData,$C(2),3)   /// 医嘱项关联信息
	.s ToothInfo=$p(sListData,$C(2),4)   ///牙位图
	.s arExecLocID=$p(armListData,"^",2)   /// 执行科室
	.s itemExaPurp=$p(armListData,"^",4)   /// 检查目的
	.s arItmmastID=$p(arcListData,"^",1)   /// 医嘱项ID
	.s arPosiList=$p(arcListData,"^",2)    /// 体位
	.s arPartID=+$p(arcListData,"^",3)     /// 部位
	.s arDispList=$p(arcListData,"^",4)    /// 后处理
	.s arRemark=$p(arcListData,"^",5)      /// 备注
	.s arSpecimen=$p(arcListData,"^",6)    /// 标本
	.//s arEmgFlag=$p(armListData,"^",3)     /// 加急标志 检查申请此位置为空 qunianpeng 2018/3/21
	.s arEmgFlag=$p(arcListData,"^",9)
	.s BillTypeID=$p(arcListData,"^",8)    /// 费别
	.s CoverMainIns=$p(arcListData,"^",10)
	.s OrderStageID=$p(arcListData,"^",11)
	.s arcAppendOrderStr = $p(arcListData,"^",12)   /// 附加绑定的医嘱
	.s EmConsultItm=$p(arcListData,"^",13) //会诊子表ID
	.s ItemQty=$p(arcListData,"^",14)		//数量
	.s OpenForAllHosp=$p(arcListData,"^",15)		//跨院
	.s LogLoc=$p(arcListData,"^",16) //按登录科室取接收科室
	.s itemCatID=##Class(web.DHCAPPExaReportQuery).GetArcCat(arItmmastID)
	.s SingFlag=0
	.s subSingFlag=$o(^DHCAPARCCA(0,"SingFlag","Y",arItmmastID,""))
	.if subSingFlag'="" s SingFlag=1
	.s index=arReqID_"^"_arExecLocID_"^"_itemCatID_"^"_SingFlag /// 分单规则
	.i '$d(itmExaPurp(index)) s itmExaPurp(index)=itemExaPurp   /// 重新合并检查目的
	.E  s itmExaPurp(index)=itmExaPurp(index)_"、"_itemExaPurp
	.s index2=arItmmastID_"^"_arDispList_"^"_$s(arPartID=0:arRemark,1:"")_"^"_arSpecimen_"^"_arEmgFlag_"^"_BillTypeID_"^"_CoverMainIns_"^"_OrderStageID_"^"_ItemQty_"^"_OpenForAllHosp_"^"_LogLoc ///_"^"_arcAppendOrderStr   /// 分单项目
	.s index3=arPartID_"$$"_arPosiList_"$$"_$s(arPartID=0:"",1:arRemark)_"$$"_arcAppendOrderStr	/// 分单部位
	.s mListData=arReqID_$c(2)_armListData
	.s ^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid,index)=mListData
	.s ^TMP("DHCST","web.DHCAPPExaReport","dealInsListDataTooth",pid,index)=ToothInfo 
	.s ^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid,index,index2)=""
	.s ^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid,index,index2,index3)=""
	.
	b ;0xxdd
	s ListData=""
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid,index)) Q:index=""  D
	.s itmExaArcList=""
	.s mListData=$g(^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid,index))
	.s ToothInfo=$g(^TMP("DHCST","web.DHCAPPExaReport","dealInsListDataTooth",pid,index))
	.s $p(mListData,"^",4)=$g(itmExaPurp(index))   /// 设置检查目的
	.s index2=""
	.f  s index2=$o(^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid,index,index2)) Q:index2=""  D
	..s itmmmastid=$p(index2,"^",1)    /// 医嘱项ID
	..s itemExaDispID=$p(index2,"^",2) /// 后处理
	..s itemExaRemark=$p(index2,"^",3) /// 备注
	..s itemSpecimen=$p(index2,"^",4)  /// 标本
	..s arEmgFlag=$p(index2,"^",5)     /// 加急标志
	..s BillTypeID=$p(index2,"^",6)    /// 费别     /// 此处后期可进行简化 bianshuai 2018-04-17 $p(index2,"^",2,6)
	..s CoverMainIns=$p(index2,"^",7) 
	..s OrderStageID=$p(index2,"^",8) 
	..s ItemQty=$p(index2,"^",9) 
	..s OpenForAllHosp=$p(index2,"^",10)
	..s LogLoc=$p(index2,"^",11)
	..s arcAppendOrderStr =""
	..
	..s itemExaPartID=""
	..s index3=""   /// 检查项目对应循环部位
	..f  s index3=$o(^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid,index,index2,index3)) Q:index3=""  D
	...i itemExaPartID="" s itemExaPartID=index3
	...E  s itemExaPartID=itemExaPartID_"@"_index3
	...s arcAppendOrderStr =$P(index3,"$$",4)
	..s itmmastList=itmmmastid_"^"_""_"^"_itemExaPartID_"^"_itemExaDispID_"^"_itemExaRemark_"^^"_itemSpecimen_"^"_arEmgFlag_"^"_BillTypeID_"^"_CoverMainIns_"^"_OrderStageID_"^"_arcAppendOrderStr_"^"_ItemQty_"^"_OpenForAllHosp_"^"_LogLoc
	..
	..i itmExaArcList="" s itmExaArcList=itmmastList
	..E  s itmExaArcList=itmExaArcList_"&&"_itmmastList
	.
	.i ListData="" s ListData=mListData_$C(2)_itmExaArcList_$C(2)_ToothInfo
	.E  s ListData=ListData_$C(1)_mListData_$C(2)_itmExaArcList_$C(2)_ToothInfo
	.
	d ..killTmpGlobal(pid) //k掉临时global
	Q ListData
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid)
	q ""
}

/// Descript:  插入收费项目
ClassMethod InsExaReqTarItem(arReqID As %String) As %String
{
	n (arReqID)
	Q:+arReqID=0 ""
	s Err=0
	s EpisodeID=$p(^DHCAPREP(arReqID),"^",6)	/// 就诊ID
	/// 医嘱项对应收费项 + 医嘱项-部位对应收费项
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:(CH="")||(Err'=0)  D
	.s reqItmID=arReqID_"||"_CH
	.s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)            /// 医嘱项ID
	.s Oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)              /// 医嘱ID
	.s Err=..InsTarItmByRepPart(arcimid,Oeori,reqItmID)
	.b ;0933
	.Q:Err'=0
	.
	./// 医嘱项对应收费项目 加收项目
	.s Err=..InsTarItmByArc(arcimid,Oeori,reqItmID)
	.Q:Err'=0
    .
	. ///  后处理对应收费项目
	.s Sub=""
	.f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"DI",Sub)) Q:(Sub="")||(Err'=0)  D
	..s DispID=+$p(^DHCAPREP(arReqID,"AR",CH,"DI",Sub),"^",1)       /// 后处理ID
	..Q:DispID=0
	..s Err=..InsTarItmByDispItm(Oeori,DispID,reqItmID)
	..
	.
	Q Err
}

/// Descript:  插入指定项目的收费项目
ClassMethod InsExaReqTarItemByItm(arReqID As %String, CH As %String, pid As %String) As %String
{
	n (arReqID, CH, pid)
	Q:+arReqID=0 ""
	s Err=0
	s reqItmID=arReqID_"||"_CH
	/// 医嘱项对应收费项 + 医嘱项-部位对应收费项
	s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)            /// 医嘱项ID
	s Oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)              /// 医嘱ID
	s Err=..InsTarItmByRepPart(arcimid,Oeori,reqItmID,pid)
	Q:Err'=0 ""
	
	/// 医嘱项对应收费项目 加收项目
	s Err=..InsTarItmByArc(arcimid,Oeori,reqItmID,pid)
	Q:Err'=0 ""
	
	///  后处理对应收费项目
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"DI",Sub)) Q:(Sub="")||(Err'=0)  D
	.s DispID=+$p(^DHCAPREP(arReqID,"AR",CH,"DI",Sub),"^",1)       /// 后处理ID
	.Q:DispID=0
	.s Err=..InsTarItmByDispItm(Oeori,DispID,reqItmID,pid)
	.

	Q Err
}

/// Descript:  循环部位执行插入操作
ClassMethod InsTarItmByRepPart(arcimid As %String, Oeori As %String, reqItmID As %String, pid As %String = "") As %String
{
	n (arcimid, Oeori, reqItmID, pid)
	
	s PartNum=0     /// 部位数
	s ExPartNum=0   /// 执行部位数
	s ItemNum=0     /// 记录数
	s arReqID=$p(reqItmID,"||",1), CH=$p(reqItmID,"||",2)
	s EpisodeID=$p(^DHCAPREP(arReqID),"^",6)	/// 就诊ID
	/// 计费点为发药计费
	s FeePoint=##Class(web.DHCAPPExaRepCom).GetFeePoint(arcimid,EpisodeID)
	/// 多部位只收取一个部位价钱
	s AdmDepId=$p(^PAADM(EpisodeID),"^",4)
	s HospId=$p(^CTLOC(AdmDepId),"^",22)
	s TarFlag=##Class(web.DHCAPPExaRepCom).GetItemTarFlag(arcimid,HospId)
	s Err=0
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:(Sub="")||(Err'=0)  D
	.s PartID=+$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  /// 部位ID
	.Q:PartID=0
	.s ExaStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2)  /// 执行状态
	.Q:ExaStat="D"
	.s PartQty=$p(^DHCAPPART(PartID),"^",7) 	/// 按部位数循环
	.i TarFlag="N" s PartQty=1     				/// 多部位只收取一个部位价钱时,不按部位数量计算收费项目
	.s ItemNum=ItemNum+1
	.s TPartQty=1   /// 临时部位数量
	.f i=1:1:PartQty Q:Err'=0  D
	..s PartNum=PartNum+1
	..i (PartNum>1)&(TarFlag="N") s TPartQty=0   /// 多部位只收取一个部位价钱
	..s TmpPartNum=PartNum
	..i (FeePoint=1)&(ExaStat="E") s ExPartNum=ExPartNum+1,TmpPartNum=ExPartNum
	..i (FeePoint=1)&(ExaStat'="E") s TmpPartNum=1,ItemNum=1
	../// 医嘱项对应收费项目
	..s Err=..InsTarItmByArcTar(arcimid,Oeori,TmpPartNum,PartID,TPartQty,EpisodeID,reqItmID,pid)
	.Q:Err'=0
	.
	./// 部位绑定收费项目
	.s Err=..InsTarItmByArcItm(arcimid,Oeori,ItemNum,PartID,TPartQty,EpisodeID,reqItmID,pid)
	.Q:Err'=0
	./// 部位对应体位收费项目
	.s arPartID=arReqID_"||"_CH_"||"_Sub
	.s Err=..InsTarItmByArcPosi(arPartID,Oeori,ItemNum,PartID,TPartQty,EpisodeID,reqItmID,pid)
	.Q:Err'=0
	.
	Q Err
}

/// Descript:  插入仅医嘱项目对应收费项目
ClassMethod InsTarItmByArcPosi(arPartID As %String, Oeori As %String, PartNum As %String, PartID As %String, PartQty As %String, EpisodeID As %String, reqItmID As %String, pid As %String) As %String
{
	n (arPartID, Oeori, PartNum, PartID, PartQty, EpisodeID, reqItmID, pid)
	s Err=0
	s arPosiID=""
	f  s arPosiID=$o(^DHCAPREPO(0,"RepPart",arPartID,arPosiID)) Q:(arPosiID="")||(Err'=0)  D
	.s PosiID=$p(^DHCAPREPO(arPosiID),"^",2)
	.Q:PosiID=""
	.s Err=..InsTarItmByPosiItm(Oeori,PosiID,PartID,PartQty,EpisodeID,reqItmID,pid)
	.Q:Err'=0
	Q Err
}

/// Descript:  插入仅医嘱项目对应收费项目
ClassMethod InsTarItmByArcItm(arcimid As %String, Oeori As %String, PartNum As %String, PartID As %String, PartQty As %String, EpisodeID As %String, reqItmID As %String, pid As %String) As %String
{
	n (arcimid, Oeori, PartNum, PartID, PartQty, EpisodeID, reqItmID, pid)
	Q:arcimid="" ""
	s Err=0
	s reqDate=$p(^DHCAPREP(+reqItmID),"^",2)		/// 申请日期
	s TarId=""
	f  s TarId=$o(^DHCAPARCLTA(0,"Arc",arcimid,TarId)) q:(TarId="")||(Err'=0)  d
	.s StartDate=""
	.f  s StartDate=$o(^DHCAPARCLTA(0,"Arc",arcimid,TarId,StartDate)) q:(StartDate="")||(Err'=0)  d
	..Q:StartDate>+reqDate   /// $H - > reqDate
	..s LinkID=""
	..f  s LinkID=$o(^DHCAPARCLTA(0,"Arc",arcimid,TarId,StartDate,LinkID)) q:(LinkID="")||(Err'=0)  d
	...s EndDate=+$p(^DHCAPARCLTA(LinkID),"^",5)   /// 结束日期
	...Q:(EndDate'=0)&&(EndDate<+reqDate)  		   /// $H - > reqDate
	...s LPartID=+$p(^DHCAPARCLTA(LinkID),"^",12)  /// 部位
	...Q:LPartID'=PartID
	...s TarQty=+$p(^DHCAPARCLTA(LinkID),"^",10)   /// 数量
	...s TarQty=$s(TarQty=0:1,1:TarQty)
	...i PartQty=0 s TarQty=0    /// 部位数为0,绑定项目也为0
	...s TarDisc=1   /// 系数
	...s Err=..InsTarItm(Oeori, PartID, "P", TarId, TarQty, TarDisc, reqItmID, pid, 0)
	..
	Q Err
}

/// Descript:  插入仅体位对应收费项目
ClassMethod InsTarItmByPosiItm(Oeori As %String, PosiID As %String, PartID As %String, PartQty As %String, EpisodeID As %String, reqItmID As %String, pid) As %String
{
	n (Oeori, PosiID, PartID, PartQty, EpisodeID, reqItmID, pid)
	Q:+PosiID=0 ""
	s Err=0
	s reqDate=$p(^DHCAPREP(+reqItmID),"^",2)		/// 申请日期
	s TarId=""
	f  s TarId=$o(^DHCAPPOSTAR(0,"Pos",PosiID,TarId)) q:(TarId="")||(Err'=0)  d
	.s StartDate=""
	.f  s StartDate=$o(^DHCAPPOSTAR(0,"Pos",PosiID,TarId,StartDate)) q:(StartDate="")||(Err'=0)  d
	..Q:StartDate>+reqDate                         /// $H - > reqDate
	..s LinkID=""
	..f  s LinkID=$o(^DHCAPPOSTAR(0,"Pos",PosiID,TarId,StartDate,LinkID)) q:(LinkID="")||(Err'=0)  d
	...s EndDate=+$p(^DHCAPPOSTAR(LinkID),"^",5)   /// 结束日期
	...Q:(EndDate'=0)&&(EndDate<+reqDate)          /// $H - > reqDate
	...s TarQty=+$p(^DHCAPPOSTAR(LinkID),"^",10)   /// 数量
	...s TarQty=$s(TarQty=0:1,1:TarQty)
	...i PartQty=0 s TarQty=0    /// 部位数为0,绑定项目也为0
	...s TarDisc=1   /// 系数
    ...s Err=..InsTarItm(Oeori, PartID, "P", TarId, TarQty, TarDisc, reqItmID, pid, 0)
    ..
    Q Err
}

/// Descript:  插入仅后处理对应收费项目
ClassMethod InsTarItmByDispItm(Oeori As %String, DispID As %String, reqItmID As %String, pid As %String = "") As %String
{
	n (Oeori, DispID, reqItmID, pid)
	Q:+DispID=0 ""
	s Err=0
	s reqDate=$p(^DHCAPREP(+reqItmID),"^",2)		/// 申请日期
	s TarId=""
	f  s TarId=$o(^DHCAPMEDTAR(0,"Med",DispID,TarId)) q:(TarId="")||(Err'=0)  d
	.s StartDate=""
	.f  s StartDate=$o(^DHCAPMEDTAR(0,"Med",DispID,TarId,StartDate)) q:(StartDate="")||(Err'=0)  d
	..Q:StartDate>+reqDate                         /// $H - > reqDate
	..s LinkID=""
	..f  s LinkID=$o(^DHCAPMEDTAR(0,"Med",DispID,TarId,StartDate,LinkID)) q:(LinkID="")||(Err'=0)  d
	...s EndDate=+$p(^DHCAPMEDTAR(LinkID),"^",5)   /// 结束日期
	...Q:(EndDate'=0)&&(EndDate<+reqDate)
	...s TarQty=+$p(^DHCAPMEDTAR(LinkID),"^",10)   /// 数量
	...s TarQty=$s(TarQty=0:1,1:TarQty)
	...s TarDisc=1   /// 系数
    ...s Err=..InsTarItm(Oeori, DispID, "D", TarId, TarQty, TarDisc, reqItmID, pid, 0)
    ..
    Q Err
}

/// Descript:  插入仅医嘱项目对应收费项目
ClassMethod InsTarItmByArc(arcimid As %String, Oeori As %String, reqItmID As %String, pid As %String = "") As %String
{
	n (arcimid, Oeori, reqItmID, pid)
	s Err=0
	Q:'$d(^DHCAPREP(+reqItmID,"AR",+$p(reqItmID,"||",2),"PA")) 0  /// 不存在部位时,退出
	s reqDate=$p(^DHCAPREP(+reqItmID),"^",2)	  /// 申请日期
	s StartDate=""
	f  s StartDate=$o(^DHCOLT(0,"ARCIM",arcimid,"Z",StartDate)) Q:(StartDate="")||(Err'=0)  D
	.Q:StartDate>+reqDate		                      /// $H - > reqDate
	.s LkTarID=""
	.f  s LkTarID=$o(^DHCOLT(0,"ARCIM",arcimid,"Z",StartDate,LkTarID)) Q:(LkTarID="")||(Err'=0)   D
	..s EndDate=$p(^DHCOLT(LkTarID),"^",5)
	..i EndDate="" s EndDate=..%SysDate()+31
	..Q:EndDate<+reqDate
	..s TarId=$p(^DHCOLT(LkTarID),"^",2)
	..s TarQty=$p(^DHCOLT(LkTarID),"^",3)   	 /// 收费项目数量
	..s TarQty=TarQty
	..s BillOnceFlag=$p(^DHCOLT(LkTarID),"^",9)  /// 不按部位计价标示
	..Q:BillOnceFlag'="Y"
	..s Err=..InsTarItm(Oeori, "", "D", TarId, TarQty, 1, reqItmID, pid, 0)
	..
	Q Err
}

/// Descript:  插入仅医嘱项目对应收费项目
ClassMethod InsTarItmByArcTar(arcimid As %String, Oeori As %String, PartNum As %String, PartID As %String, PartQty As %String, EpisodeID As %String, reqItmID As %String, pid As %String) As %String
{
	n (arcimid, Oeori, PartNum, PartID, PartQty, EpisodeID, reqItmID, pid)
	s Err=0
	s reqDate=$p(^DHCAPREP(+reqItmID),"^",2)		/// 申请日期
	s StartDate=""
	f  s StartDate=$o(^DHCOLT(0,"ARCIM",arcimid,"Z",StartDate)) Q:(StartDate="")||(Err'=0)  D
	.Q:StartDate>+reqDate    /// $H -> reqDate
	.s LkTarID=""
	.f  s LkTarID=$o(^DHCOLT(0,"ARCIM",arcimid,"Z",StartDate,LkTarID)) Q:(LkTarID="")||(Err'=0)  D
	..s EndDate=$p(^DHCOLT(LkTarID),"^",5)
	..i EndDate="" s EndDate=..%SysDate()+31
	..Q:EndDate<+reqDate    /// $H -> reqDate
	..s TarId=$p(^DHCOLT(LkTarID),"^",2)
	..s TarQty=$p(^DHCOLT(LkTarID),"^",3)        /// 收费项目数量
	..s TarQty=TarQty*PartQty
	..s BillOnceFlag=$p(^DHCOLT(LkTarID),"^",9)  /// 不按部位计价标示
	..Q:BillOnceFlag="Y"
	..s BasFlag=$p(^DHCOLT(LkTarID),"^",8)       /// 基价标志
	..i BasFlag="Y" d
	...s TarDisc=..GetTarDisc(arcimid, PartNum, EpisodeID)
	...s Err=..InsTarItm(Oeori, PartID, "P", TarId, TarQty, TarDisc, reqItmID, pid, 1)
	..E  d
	...s TarDisc=1   /// 系数
	...s Err=..InsTarItm(Oeori, PartID, "P", TarId, TarQty, TarDisc, reqItmID, pid, 1)
	..
	Q Err
}

/// Descript:  插入检查申请收费项目
ClassMethod InsTarItm(Oeori As %String, LinkID As %String, TarType As %String, TarId As %String, TarQty As %String, TarDisc As %String, reqItmID As %String, pid As %String, PartFlag As %String) As %String
{
	n (Oeori, LinkID, TarType, TarId, TarQty, TarDisc, reqItmID, pid, PartFlag)
	s OrdExecID=""   /// 取执行记录临时数据
	i pid'="" s OrdExecID=..GetTmpOrdExec(reqItmID_"^"_TarType_"^"_+LinkID_"^"_TarId, pid)
	i pid'="" Q:OrdExecID="" 0
	s TarUpdateDate=..%SysDate()
	s TarUpdateTime=..%SysTime()
	s TarBilled="TB"   /// 需计费状态
	;全部登记-取消全部登记-撤销部位时,TarBilled改为I,否则再次登记剩余部位时会产生多余的数量为0的账单记录 2020-07-16
	if (OrdExecID'="") {
		s Adm=$P(^OEORD(+OrdExecID),"^",1)
		s AdmType=$p($g(^PAADM(Adm)),"^",2)
		s tmpARTIRowId=$o(^DHCAPREPTA(0,"IndexOrdExec",OrdExecID,""),-1)
		if (tmpARTIRowId'="")&&(AdmType="I") {
			if (##class(DHCDoc.Interface.Inside.Service).GetExecRefundFlag(OrdExecID)="Y") s TarBilled="I"
			//s tmpARTIBilled=$p(^DHCAPREPTA(tmpARTIRowId),"^",9)
			//if (tmpARTIBilled="I") s TarBilled="I"
		}
	}
	&SQL(insert into DHC_AppRepTarItm(ARTI_OrdItem,ARTI_Pointer,ARTI_Type,ARTI_Tar_Dr,ARTI_UpdDate,ARTI_UpdTime,ARTI_Qty,ARTI_Billed,ARTI_Disc,ARTI_OrdExec,ARTI_ReqItm_Dr,ARTI_PartFlag) 
		values(:Oeori,:LinkID,:TarType,:TarId,:TarUpdateDate,:TarUpdateTime,:TarQty,:TarBilled,:TarDisc,:OrdExecID,:reqItmID,:PartFlag))
	Q SQLCODE
}

/// Descript:  插入检查申请收费项系数
ClassMethod GetTarDisc(arcimid As %String, PartNum As %String, EpisodeID As %String) As %String
{
	n (arcimid, PartNum, EpisodeID)
	/// s TarDisc=##Class(web.DHCAPPRepTarItm).GetDisc(arcimid, PartNum, EpisodeID)
	s TarDisc=##Class(web.DHCAPPInterface).GetTarDisc(arcimid, PartNum, EpisodeID)
	Q TarDisc
}

/// Descript:  更新检查申请收费项
ClassMethod SetExaReqTarItm(arItmID As %String, PartID As %String) As %String
{
	n (arItmID, PartID,%session)
	s Err=0
	s arReqID=$p(arItmID,"||",1)
	s CH=$p(arItmID,"||",2)
	Q:(arReqID="")||(CH="") ""
	s oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3) /// 检查申请医嘱ID
	Q:oeori="" ""
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()
	TS
	/// 修改收费项目表状态为I
 	s TarId=""
	f  s TarId=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarId)) Q:(TarId="")||(Err'=0)  D
	.s TarBilled=$p(^DHCAPREPTA(TarId),"^",9)    /// 计费标志
	.Q:(TarBilled="I")||(TarBilled="R")
	.i TarBilled="TB" s TarBilled="R"
	.E  s TarBilled="I"
	.D ..InsTmpOrdExec(TarId,PartID,pid)  /// 准备执行记录临时数据
	.s Err=..UpdExaReqTarItm(TarId,TarBilled)
	.
	i Err'=0 tro
	q:Err'=0 Err
	b //122
	/// 重新计算插入收费项目表
	s ExaReqNoFlag=..GetExaReqItmStat(arReqID_"||"_CH,"")   /// 申请单停止状态 
	i ExaReqNoFlag=1 s Err=..InsExaReqTarItemByItm(arReqID,CH,pid)
	i Err'=0 tro
	q:Err'=0 Err
	b //56
	TC
	Q Err
}

/// Descript:  准备执行记录临时数据,用于插入收费中间表执行记录
ClassMethod InsTmpOrdExec(TarId As %String, PartID As %String, pid As %String) As %String
{
	n (TarId, PartID, pid)
	s TarType=$p(^DHCAPREPTA(TarId),"^",3)    /// 类型
	s TPartID=+$p(^DHCAPREPTA(TarId),"^",1)   /// 部位ID
	Q:(TPartID=PartID)&(TarType="P") ""       /// 筛选部位
	s TarItmID=$p(^DHCAPREPTA(TarId),"^",5)   /// 收费项ID
	s OrdExecID=$p(^DHCAPREPTA(TarId),"^",10) /// 执行记录ID
	s reqItmID=$p(^DHCAPREPTA(TarId),"^",11)  /// 检查项目表ID
	s index=reqItmID_"^"_TarType_"^"_TPartID_"^"_TarItmID
	s ^TMP("DHCAPP","web.DHCAPPExaReport","TarItem",pid,index,TarId)=OrdExecID
}

/// Descript:  取执行记录临时数据,用于插入收费中间表执行记录
ClassMethod GetTmpOrdExec(index As %String, pid As %String) As %String
{
	n (index, pid)
	s TarId=$o(^TMP("DHCAPP","web.DHCAPPExaReport","TarItem",pid,index,""))
	Q:TarId="" TarId
	s OrdExecID=$g(^TMP("DHCAPP","web.DHCAPPExaReport","TarItem",pid,index,TarId))
	k ^TMP("DHCAPP","web.DHCAPPExaReport","TarItem",pid,index,TarId)
	Q OrdExecID
}

/// Descript:  检查申请收费项是否进行打折
ClassMethod isExistTarDisc(oeori As %String) As %String
{
	n (oeori)
	s TarDiscFlag=0
	s TarId=""
	f  s TarId=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarId)) Q:(TarId="")||(TarDiscFlag=1)  D
	.s TarBilled=$p(^DHCAPREPTA(TarId),"^",9)   /// 计费标志
	.Q:TarBilled'="TB"
	.s TarDisc=$p(^DHCAPREPTA(TarId),"^",4)     /// 打折系数
	.Q:TarDisc=1
	.s TarDiscFlag=1
	Q TarDiscFlag
}

/// Descript:  检查申请部位数
ClassMethod GetExaReqPartNum(arReqID As %String, CH As %String) As %String
{
	n (arReqID, CH)
	s PartNum=0
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=+$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  /// 部位ID
	.Q:PartID=0
	.s PartNum=PartNum+1
	
	Q PartNum
}

/// Descript:  更新收费项目计费标志
ClassMethod UpdExaReqTarItm(TarId As %String, TarBilled As %String) As %String
{
	n (TarId, TarBilled)
	s TarUpdateDate=..%SysDate()
	s TarUpdateTime=..%SysTime()
	&SQL(update DHC_AppRepTarItm set ARTI_UpdDate=:TarUpdateDate, ARTI_UpdTime=:TarUpdateTime, ARTI_Billed=:TarBilled where ARTI_RowId=:TarId)
	Q SQLCODE
}

/// Descript:  调用其他关联接口
/// Input:     检查申请ID串
/// w ##Class(web.DHCAPPExaReport).InvokInterface(2585,10209)
ClassMethod InvokInterface(arreqidstr, LgUserID = "") As %String
{
	n (arreqidstr,LgUserID)
	s ^BIANSHUAI(1,1)=$lb(arreqidstr,LgUserID)
	s UserID = LgUserID
	s Len=$L(arreqidstr,"^")
	f m=1:1:Len {
		s arReqID=$p(arreqidstr,"^",m)
		s ARSub=0
		for {
			s ARSub=$o(^DHCAPREP(arReqID,"AR",ARSub))
			q:(ARSub="")
			s OEItemID=$p(^DHCAPREP(arReqID,"AR",ARSub),"^",3)  
			continue:(OEItemID="")
			s UserDeptDR=$P($G(^OEORD(+OEItemID,"I",$P(OEItemID,"||",2),7)),"^",2)
			//插入绑定的医嘱项
			d ..BangLinkOrder(OEItemID, UserID, UserDeptDR)
		}
	}
	
	f m=1:1:Len {
		s arReqID1=$p(arreqidstr,"^",m)
		continue:$p(^DHCAPREP(arReqID1),"^",17)="I"
		/// 发送医嘱ID到供集成平台
		s:UserID="" UserID=$p(^DHCAPREP(arReqID1),"^",4)  //获取发送申请单的人为操作人
		s ret = ##Class(web.DHCAPPInterface).UpdExaReqStatus("AP",arReqID1,UserID)   //修改状态为申请
	}
	f m=1:1:Len {
		s arReqID1=$p(arreqidstr,"^",m)
		continue:$p(^DHCAPREP(arReqID1),"^",17)="I"
		s:UserID="" UserID=$p(^DHCAPREP(arReqID1),"^",4)  //获取发送申请单的人为操作人
		// 发送申请单数据到PAC
		s ret=##Class(web.DHCAPPInterface).SendExaReqNoToPAC(arReqID1)
	}
	
	Q 0
InvokErrMsg
    Q ""
}

/// Descript:  部位全部停止则调用停医嘱函数
/// W ##Class(web.DHCAPPExaReport).SetExaReqItmStopOrder("85725||1","13")
ClassMethod SetExaReqItmStopOrder(arReqItmID As %String, LgUserID As %String, PartID As %String = "") As %String
{
	n (arReqItmID, LgUserID, PartID,%session)
	s Err=0
	s Err=##Class(web.DHCAPPExaReport).GetExaReqItmStat(arReqItmID,"")
	/// 全停止才调用停医嘱接口
	Q:Err=1 0
	/// 调用停医嘱接口
	s Err=##Class(web.DHCAPPExaReport).InvStopOrder(arReqItmID,LgUserID,PartID)
	Q Err
}

/// Descript:  调用停医嘱接口
/// W ##Class(web.DHCAPPExaReport).InvStopOrder("85722||1","13")
ClassMethod InvStopOrder(arReqItmID As %String, LgUserID As %String, PartID As %String = "") As %String
{
	n (arReqItmID, LgUserID, PartID,%session)
	s arReqID=$p(arReqItmID,"||",1)
	s CH=$p(arReqItmID,"||",2)
	Q:'$d(^DHCAPREP(arReqID,"AR",CH)) "-11"
	s EpisodeID=$p(^DHCAPREP(arReqID),"^",6)	/// 就诊ID
	s PatType=$p(^PAADM(EpisodeID),"^",2)  		/// 病人类型
	s Oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)                     /// 医嘱ID
	if Oeori="" d

	.&SQL(update DHC_AppRepArc set AR_Status="D" where AR_RowID=:arReqItmID)

	q:Oeori="" 0
	s OeStat=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)   /// 医嘱状态
	Q:OeStat'="V" "-12"
	
	i PatType="I" D
	.s ExpStr=PartID
	.s Err=##class(appcom.OEOrdItem).CancelMulti(Oeori,LgUserID,"","N","","",ExpStr) /// 住院撤销医嘱
	.if (Err'=0) s Err=..%GetErrCodeMsg(Err,"appcom.OEOrdItem")
	E  D
	.s ExpStr="0^"_PartID
	.s Err=##Class(appcom.OEOrdItem).StopMulti(Oeori,LgUserID,"","N",ExpStr)   /// 门诊停止医嘱
	.if (Err'=0) s Err=..%GetErrCodeMsg(Err,"appcom.OEOrdItem")
	
	D ##Class(RISService.InvokeRISService).DiscontinueAppInfoPACS(Oeori,LgUserID,"")
	Q Err
}

/// Descript:  修改医嘱计费状态
/// W ##Class(web.DHCAPPExaReport).ModOeoriBillFlag("942||1")
ClassMethod ModOeoriBillFlag(arReqItmID As %String) As %String
{
	n (arReqItmID)
	s Err=0
	s arReqID=$p(arReqItmID,"||",1)
	s CH=$p(arReqItmID,"||",2)
	Q:'$d(^DHCAPREP(arReqID,"AR",CH)) "-11"
	s EpisodeID=$p(^DHCAPREP(arReqID),"^",6)	  /// 就诊ID
	s PatType=$p(^PAADM(EpisodeID),"^",2)  		  /// 病人类型
	s Oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)  /// 医嘱ID
	i PatType'="I" D
	.s Err=##Class(web.DHCAPPInterface).modOeoriStat(Oeori,"TB")     /// 修改医嘱计费状态
	Q Err
}

/// Descript:  获取检查申请单部位停止状态
/// W ##Class(web.DHCAPPExaReport).GetExaReqItmStat("85727||1","")
ClassMethod GetExaReqItmStat(arReqItmID As %String, PartID As %String) As %String
{
	n (arReqItmID, PartID)
	s arReqID=$p(arReqItmID,"||",1)
	s CH=$p(arReqItmID,"||",2)
	s Err=0
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:(Sub="")||(Err'=0)  D
	.s sPartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)    /// 部位ID
	.Q:(PartID'="")&(PartID'=sPartID)
	.s ExeStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2)    /// 执行状态
	.Q:ExeStat="D"
	.s Err=1
	Q Err
}

/// Descript:  获取检查申请单部位是否允许撤销
/// W ##Class(web.DHCAPPExaReport).GetPartCurFlag("2||1","8038")
ClassMethod GetPartCurFlag(arReqItmID As %String, PartID As %String) As %String
{
	n (arReqItmID, PartID)
	s arReqID=$p(arReqItmID,"||",1)
	s CH=$p(arReqItmID,"||",2)
	s Sub=$o(^DHCAPREP(0,"Part",PartID,arReqID,CH,""))   /// 检查申请部位表Child
	Q:Sub="" 0
	s CurStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2)  /// 执行状态
	Q:CurStat="V" 0
	Q 1
}

/// Descript:	检查其他项目是否必填
/// W ##Class(web.DHCAPPExaReport).ItmIsRequired("2772")
ClassMethod ItmIsRequired(pid As %String) As %String
{
	n (pid)
	Q:pid="" ""
	s ErrMsg=""
	/// 循环判断当前检查申请其他项目的临时global
	s tmp=""
	f  s tmp=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,tmp)) Q:tmp=""  D
	.s itmid=""
	.f  s itmid=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,tmp,itmid)) Q:itmid=""  D
	..//Q:itmid'=itmmastid
	..s mdata=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,tmp,itmid))
	..Q:mdata=""
	..s itemid=$p(mdata,"^",1)   /// 项目ID
	..s itemval=$p(mdata,"^",4)  /// 项目值
	..s itemtype=$p(mdata,"^",3)
	..q:itemtype="Order"
	..Q:$p(^DHCAPOTHO(itemid),"^",4)'="Y" ///是否必填
	..Q:itemval'=""
	..s itemdesc=$p(^DHCAPOTHO(itemid),"^",2)
	..Q:ErrMsg[itemdesc         /// 存在相同项目时，退出
	..i ErrMsg="" d
	...s ErrMsg=itemdesc
	..E  D
	...s ErrMsg=ErrMsg_"、"_itemdesc
	..
	.
	Q ErrMsg
}

/// Descript:	获取诊断是否已经填写
/// W ##Class(web.DHCAPPExaReport).GetMRDCount("32599")
ClassMethod GetMRDCount(EpisodeID As %String, GroupID As %String, ARCIMRowId As %String = "") As %String
{
	n (EpisodeID,GroupID,ARCIMRowId,%session)
	//体检患者不限制是否有诊断
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	if (AdmType="H") Q "A"
	;GroupID 医生站新增配置可通过安全组判断是否可以在未录入诊断的时候下医嘱
	s MotherAdmID = $p(^PAADM(EpisodeID),"^",75)   //分娩婴儿
	Q:(+MotherAdmID'=0) "A"
	s:$d(%session) GroupID=%session.Get("LOGON.GROUPID"),HospId=%session.Get("LOGON.HOSPID")
	s Count=0
	s:GroupID'="" Count = +..%GetConfig1("OrderLimit",GroupID,HospId) //$g(^DHCDocConfig("OrderLimit",GroupID))
	i Count=0  {
		s OrdNeedMMDiag=0
		;医嘱录入必须有西医诊断子类
	 	s OrdNeedMMDiagCat=..%GetConfig("OrdNeedMMDiagCat",HospId)
	 	if (ARCIMRowId'="") {
		 	s ItemCatRowid=##class(web.DHCDocOrderCommon).GetOrderSubCat(ARCIMRowId)
		 	if ("^"_OrdNeedMMDiagCat_"^")[("^"_ItemCatRowid_"^") s OrdNeedMMDiag=1
		}
		s mrAdm=$p(^PAADM(EpisodeID),"^",61)
		i OrdNeedMMDiag=1 s Count=##Class(web.DHCDocOrderEntry).GetMMDiagnoseCount(mrAdm)
		e  s Count=##Class(web.DHCDocOrderEntry).GetMRDiagnoseCount(mrAdm)
	}
	Q Count
}

/// Descript:	获取医疗结算标志
/// W ##Class(web.DHCAPPExaReport).GetIsMidDischarged("32599")
ClassMethod GetIsMidDischarged(EpisodeID As %String) As %String
{
	n (EpisodeID)
	Q 0
	s PatType=$p(^PAADM(EpisodeID),"^",2) 	           /// 就诊类型
	Q:PatType'="I" 0
	s MidDischargedFlag=##Class(web.DHCDocOrderCommon).GetIsMidDischarged(EpisodeID)
	Q MidDischargedFlag
}

/// Descript:	验证医生录医嘱权限
/// W ##Class(web.DHCAPPExaReport).GetDocPermission("32599")
ClassMethod GetDocPermission(LgGroupID As %String, LgUserID As %String, LgLocID As %String, EpisodeID As %String, arcitemId As %String) As %String
{
	n (LgGroupID, LgUserID, LgLocID, EpisodeID, arcitemId, %session)
	s EpisodeType=$P(^PAADM(EpisodeID),"^",2)      /// 就诊类型
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s DocPerFlag=##Class(web.DHCDocOrderEntry).ValOrd("ARCIM",LgGroupID,arcitemId,EpisodeType,"",LgUserID,LgLocID,"","",PatientID)
	Q:'DocPerFlag 1
	Q 0
}

/// Descript:	验证病人是否允许开医嘱
/// W ##Class(web.DHCAPPExaReport).GetPatNotTakOrdMsg("104","10209","203","628")
ClassMethod GetPatNotTakOrdMsg(LgGroupID As %String, LgUserID As %String, LgLocID As %String, EpisodeID As %String, EmConsultItm As %String = "") As %String
{
	n (LgGroupID, LgUserID, LgLocID, EpisodeID, EmConsultItm, %session)
	Q:EpisodeID="" ""
	s NotTakOrdMsg=##class(web.DHCDocViewDataInit).GetOrdWarning(EpisodeID,..%SessionStr(),EmConsultItm)
	if (NotTakOrdMsg'="") {
		s NotTakOrdMsg=$replace(NotTakOrdMsg,"医嘱","申请")
	}
	if (NotTakOrdMsg="") {
		s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
		if (AdmDate>+$H){
			s AdmDate=..%ZD(AdmDate)
			s NotTakOrdMsg="该病人就诊日期"_AdmDate_"大于今日，请前往医嘱录入界面录入"
		}
	}
	Q NotTakOrdMsg
	
	
	s NotTakOrdMsg=""
	s VisitStatus=$p(^PAADM(EpisodeID),"^",20)  /// 病人当前状态
	s FinFlag=$p(^PAADM(EpisodeID),"^",45)      
	s PAADMDate=$p(^PAADM(EpisodeID),"^",6)     /// 就诊日期
	s PAADMTime=$p(^PAADM(EpisodeID),"^",7)     /// 就诊时间
	s PAADMDocDR=$p(^PAADM(EpisodeID),"^",9)    /// 主管医生
	s PAADMBedDR=$p(^PAADM(EpisodeID),"^",73)   /// 床位
	s today=..%SysDate()
	s DocID=$p(^SSU("SSUSR",LgUserID),"^",14)
 	
 	s PilotAdmInfo=##class(web.PilotProject.DHCDocPilotService).IIsPilotAdm(EpisodeID)
 	s IfPilotAdm=$p(PilotAdmInfo,"^",1)
 	s AdmPPRowId=$p(PilotAdmInfo,"^",2)
 
 	/// 病人类型
 	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
 	
 	/// 住院有主管医生才能录医嘱
 	s CFIPNeedDoctor=..%GetConfig("IPNeedDoctor")
 	
 	/// 是否进行医疗结算.只有护士在医疗结算后可以录入医嘱,医生不许。
	s HaveMidDischarged=0
	i EpisodeID'="" {
	   s HaveMidDischarged=##class(web.DHCDocOrderCommon).GetIsMidDischarged(EpisodeID)
	}
	
	/// 登陆用户身份类型
	s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(LgUserID)
	s CareProvType=$zcvt(CareProvType,"U")
	
	/// 获取病人当前出院状态,调用护理组接口
 	s CurrentDischargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
 	
 	/// 1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
    s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	s OPAdmDayLimit=..%GetConfig("OPAdmDayLimit")
	i OPAdmDayLimit="" s OPAdmDayLimit=1
	/// 不受就诊有效天数限制
    s NoAdmValidDaysLimit=..%GetConfig1("NoAdmValidDaysLimit",LgGroupID)
	
 	/// 系统默认疗程
 	s IPDefaultDurRowId=..%GetConfig("IPDefaultDuration")

  	i (PAAdmType="I") D
  	.i (PAADMBedDR="")&(CurrentDischargeStatus'="B")&(VisitStatus'="P") d
    ..s NotTakOrdMsg="此病人未分配床位,不允许开申请."
 	.i (PAADMDocDR="")&&(CFIPNeedDoctor=1)&&(VisitStatus'="P") D
 	..s NotTakOrdMsg="此病人未分配医生,不允许开申请." 
 	.s OrderUnabled=##class(web.DHCDocOrderCommon).CheckOrderUnabled(EpisodeID)
	.i OrderUnabled=1 D
	..s NotTakOrdMsg="此病人正在结算中,不允许再开申请."
	.i FinFlag="Y" D
	..s NotTakOrdMsg="此病人已结算出院,不允许再开申请."
	.//i ((HaveMidDischarged=1)&&(CareProvType="DOCTOR")&&(PAAdmType="I")&(CurrentDischargeStatus'="B")) D
	.i ((HaveMidDischarged=1)&&(PAAdmType="I")&(CurrentDischargeStatus'="B")) D
	..s NotTakOrdMsg="此病人已做医疗结算,不允许医生再开申请."
	.i ((VisitStatus="D")!(VisitStatus="C"))&(DocID'="")&(CurrentDischargeStatus'="B") D
	..s NotTakOrdMsg="此病人已做最终结算,不允许医护人员再开申请."
	e  d
	.i (" 1 2 "[(" "_GetStayStatusFlag_" "))&&(VisitStatus="D") D
	..s NotTakOrdMsg="此病人已结算出院,不允许再开申请."
	
	i ((VisitStatus="C")!((OPAdmDayLimit'=0)&(today-PAADMDate>(OPAdmDayLimit-1))))&(PAAdmType="O") D
	.s IfPilotAdm=##Class(web.PilotProject.DHCDocPilotProCommon).CheckPilotAdm(EpisodeID)
	.i VisitStatus="C" s warning="此病人已退号,不允许再开申请."
	.e  i (today-PAADMDate>(OPAdmDayLimit-1))&&(IfPilotAdm'=1)&&(NoAdmValidDaysLimit'=1)  s NotTakOrdMsg="此就诊记录的挂号日期在"_OPAdmDayLimit_"天以前,不允许再开申请."
	
	i (PAAdmType="E")&&(" 1 2 "'[(" "_GetStayStatusFlag_" "))&&(IfPilotAdm'=1)&&(NoAdmValidDaysLimit'=1) d
 	.s checkDateStr=##class(web.DHCDocOrderCommon).GetVisitTimeToDay(EpisodeID)
 	.i checkDateStr'=0 d
 	..s checkAdmDate=$p(checkDateStr,"^",2)
 	..s checkAdmDateUom=$p(checkDateStr,"^",3)
 	..s NotTakOrdMsg="此就诊记录的挂号时间在"_checkAdmDate_checkAdmDateUom_"以前,不允许再开申请."
 
	i NotTakOrdMsg="",PAAdmType="I",IPDefaultDurRowId="" D
	.s NotTakOrdMsg="住院没有设定默认的疗程?请与系统维护部门联系."
 	
 	/// 调用医生站新接口
	i (PAAdmType'="I")&&(IfPilotAdm'=1) D
 	.s TakOrdFlag=##Class(web.DHCDocOrderCommon).GetVisitTimeToDay(EpisodeID)
 	.s LimUnit=$p(TakOrdFlag,"^",2)  /// 单位
 	.s LimTime=$p(TakOrdFlag,"^",3)  /// 时间
 	.i (TakOrdFlag[-100)&&(NoAdmValidDaysLimit'=1)&&(IfPilotAdm'=1) D
 	..s NotTakOrdMsg="此就诊记录的挂号时间在"_LimTime_LimUnit_"以前,不允许再开申请."
 	/// 患者状态
	//s Status=##class(web.DHCDocTransfer).GetQueStatusByAdm(EpisodeID)
	//i (Status="报到")&&(##class(web.DHCDocTransfer).GetExaNoCheckinDocCanRecAdm(EpisodeID)'="Y") s NotTakOrdMsg="未报到患者不允许录入医嘱!"
 	if (NotTakOrdMsg="")&&(PAAdmType'="I"){
 		s NotTakOrdMsg=##class(web.DHCDocOutPatientList).CheckIsAdmissions(EpisodeID,LgUserID)
 	}
 	if (NotTakOrdMsg=""){
	 	s NotTakOrdMsg=##Class(web.DHCDocViewDataInit).GetOrdEntryWarning(EpisodeID)
	}
	Q NotTakOrdMsg
}

/// Descript:	验证病人是否允许开医嘱
/// Output:     NotTakOrdMsg - 提示信息
/// W ##Class(web.DHCAPPExaReport).GetPatNotTakOrdMsgArc(1091,"3950||1","",1)
ClassMethod GetPatNotTakOrdMsgArc(EpisodeID As %String, arcitemId As %String, PPRowId As %String = "", AdmReason As %String = "") As %String
{
	n (EpisodeID, arcitemId, PPRowId,AdmReason,%session)
	s ^tempqujian("GetPatNotTakOrdMsgArc")=EpisodeID_","_arcitemId_","_PPRowId_","_AdmReason
 	//s PilotAdmInfo=##class(web.PilotProject.DHCDocPilotService).IIsPilotAdm(EpisodeID)
 	//s IfPilotAdm=$p(PilotAdmInfo,"^",1)
 	//s AdmPPRowId=$p(PilotAdmInfo,"^",2)
 	s Stream=##class(%Stream.GlobalCharacter).%New()
	s ErrCode=0, ErrMsg=""
	if (PPRowId'="") {
	s VisitStatus=$p(^PAADM(EpisodeID),"^",20)  /// 病人当前状态
		/// 临床药理管理 免费医嘱设置
	 	s res=##Class(web.PilotProject.DHCDocPilotProject).CheckIsFreeOrd(EpisodeID,PPRowId,arcitemId,"dhcapp.reportreq.csp")
	 	i ((+res=0)&($p(res,"^",2)'="")||(+res=-1)) s ErrCode=$p(res,"^",1) s ErrMsg=$p(res,"^",2)
 	}
 	if (ErrCode=0){
	 	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	 	s AdmDepId=$p(^PAADM(EpisodeID),"^",4)
		s HospId=$p(^CTLOC(AdmDepId),"^",22)
		b ;09323
	 	if ((AdmType'="I")&&(AdmReason'="")){
		 	s OrderItemCatRowid=$p($g(^ARCIM(+arcitemId,$p(arcitemId,"||",2),1)),"^",10)
			s PrescriptTypes=##Class(web.DHCPAADMPrescType).GetPrescTypeByPAADM(AdmType,AdmReason,HospId)
			for i=1:1:$L(PrescriptTypes,"||") {
				s PrescriptType=$P(PrescriptTypes,"||",i)
				continue:PrescriptType=""
				s BillTypeID2=$P(PrescriptType,"!",5)
				s SubCatIDs=$P(PrescriptType,"!",4)
				if (SubCatIDs=""){
					s BillTypeArr(BillTypeID2) = ""
				}else{
					s BillTypeArr(BillTypeID2) = "^"_SubCatIDs_"^"
				}
			}
			s PrescCheck=""
			s SubCatIDs=$G(BillTypeArr(AdmReason))
			if (SubCatIDs'[("^"_OrderItemCatRowid_"^"))&&(SubCatIDs'=""){
				/*s BillTypeID2=""
				for {
					s BillTypeID2=$O(BillTypeArr(BillTypeID2))
					q:(BillTypeID2="")
					s SubCatIDs=$G(BillTypeArr(BillTypeID2))
					if (SubCatIDs[("^"_OrderItemCatRowid_"^"))||(SubCatIDs=""){
						s PrescCheck=BillTypeID2
					}
				}*/
			}else{
				s PrescCheck=AdmReason
			}
			b ;09323
			if (PrescCheck=""){
				s ErrCode="-1"
				s ErrMsg="此医嘱不符合处方类型"
			}
		 }
		 
	}
	if (ErrCode=0){
		 s PatientID=$p(^PAADM(EpisodeID),"^",1)
		 s AllowOnlyOnceRepeatFlag=##class(web.DHCDocOrderCommon).CheckARCIMAllowOnlyOnce(EpisodeID,arcitemId)
		 if (AllowOnlyOnceRepeatFlag>0) {
			 s ErrCode="-1"
			 if AllowOnlyOnceRepeatFlag=1{
				s ErrMsg="此医嘱已设置一次就诊只允许开一次,此患者在本次就诊中已开过此医嘱,不允许在开!"
			 }else{
			 	s ErrMsg="此医嘱已设置一个患者只允许开一次,此患者在历次或本次就诊中已开过此医嘱,不允许在开!"
			 }
		 }
	}
	if (ErrCode=0){
		s ItemStatus=##Class(web.DHCDocOrderEntry).ValARCItem(arcitemId)
		if (ItemStatus =1){
			s ErrCode="-1"
			s ErrMsg="此医嘱已失效或未到启用时间!"
		}
	}
	
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("ErrCode^ErrMsg",ErrCode_"^"_ErrMsg))
 	Q Stream.Read()
}

/// Descript:	更新检查申请部位表申请退费状态
/// W ##Class(web.DHCAPPExaReport).UpdPartReqFlag("11||1||1","Y")
ClassMethod UpdPartReqFlag(arRowID As %String, reqFlag As %String) As %String
{
	n (arRowID, reqFlag)
	&SQL(update DHC_AppRepPart Set AR_RefReqFlag=:reqFlag where AR_RowID=:arRowID)
	Q SQLCODE
}

/// Descript: 保存检查申请记录
/// w ##Class(web.DHCAPPExaReport).saveDoc("61","32597^391^Y^CT平扫（16排） + DDDD、DDDDE[全腹部(侧卧位,斜位)]^2874^^^308^gggg^N#11207||1^3,5^8038^8@10^2017-02-09^A^Y!!32597^391^Y^CT平扫（16排） + DDDD、DDDDE[上腹部(斜位)]^2874^^^308^gggg^N#11207||1^5^8039^8@10^2017-02-09^A^Y")
ClassMethod saveDoc(pid As %String, ListData As %String, mPatSymData As %String) As %String
{
	n (pid, ListData, mPatSymData,%session)
	s ^temptan("saveDoc")=pid_","_ListData_","_mPatSymData
	s ListData=##Class(web.DHCAPPExaReport).dealInsListDataDoc(ListData)

	s mdata=""
	s Err = 0
	TS
	s Len = $L(ListData,$C(1))   		 /// 检查分类数目
	f i=1:1:Len q:Err'=0  d
	.s sListData=$p(ListData,$C(1),i)
	.s mListData = $p(sListData,$C(2),1)   /// 申请表主信息
	.s aListData = $p(sListData,$C(2),2)   /// 医嘱项关联信息
	.s ToothInfo= $p(sListData,$C(2),3)
	.s ret=..InsertDoc(mListData,aListData,pid,mPatSymData,ToothInfo)
	.i +ret<0 s Err=ret
	.q:+ret<0 
	.s mdata=$s(mdata'="":mdata_"@"_ret,1:ret)  ///申请表ID串
	.
	i Err'=0 tro
	q:Err'=0 Err

	TC
	//D ##Class(web.DHCAPPExaReport).InvokInterface(arreqidstr)  /// 调用其他相关接口
	Q mdata
}

/// Descript: 插入检查申请记录
ClassMethod InsertDoc(mListData As %String, aListData As %String, pid As %String, mPatSymData As %String, ToothInfo As %String = "") As %String
{
	N (mListData, aListData, pid, mPatSymData,ToothInfo,%session)
	s ^tempqujian("InsertDoc")=$lb(mListData, aListData, pid, mPatSymData,ToothInfo)
	s Err=0
	s mdata=""
	TS

	/// 检查报告
	s arReqID=..InsAppRep(mListData)
	i arReqID<0 tro
	q:arReqID<0 arReqID

	/// 医嘱项目
	f i=1:1:$L(aListData,"&&") q:Err'=0  d
	.s arcListData=$p(aListData,"&&",i)
	.s ret=..InsArcItemDoc(arReqID,arcListData,ToothInfo)
	.i +ret<0 s Err="-1"
	.q:+ret<0
	.s mdata=$s(mdata'="":mdata_"@"_ret,1:ret)
	.
	i Err'=0 tro
	q:Err'=0 "-11"

	/// 其他项目
	s oListData=..GetRepOthOpt(pid,aListData)  /// 其他项目取值
	i oListData'="" d
	.s Err=..InsRepOthOpt(arReqID,oListData)
	i Err'=0 tro
	q:Err'=0 "-12"

	/// 患者现病史
	i $p(mPatSymData,$C(4),2)'="" d
	.s Err = ..InsPreHis(arReqID, mPatSymData)
	i Err'=0 tro
	q:Err'=0 "-13"
	
	/// 患者体征
	i $p(mPatSymData,$C(4),3)'="" d
	.s Err = ..InsPatSigns(arReqID, mPatSymData)
	i Err'=0 tro
	q:Err'=0 "-14"

	/// 患者主诉
	i $p(mPatSymData,$C(4),4)'="" d
	.s Err = ..InsPatSymptom(arReqID, mPatSymData)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	/// 插入收费项
	s Err = ..InsExaReqTarItem(arReqID)
	q:Err'=0 "-16"
	TC
	Q mdata
}

/// Descript: 保存检查医嘱项信息
ClassMethod InsArcItemDoc(arReqID As %String, arListData As %String, ToothInfo As %String = "") As %String
{
	N (arReqID, arListData,ToothInfo)
	s Err=0
	/// 医嘱项,体位
	s arReqArcID=..InsRepArc(arReqID,arListData,ToothInfo)
	q:arReqArcID<0 arReqArcID

	/// 部位
	s arPartListData=$p(arListData,"^",3)
	s arPartListData=$REPLACE(arPartListData,"A","@")
	s arPartListData=$REPLACE(arPartListData,"B","$$")
	f i=1:1:$L(arPartListData,"@") q:Err'=0  d
	.s arPartData=$p(arPartListData,"@",i)
	.s Err=..InsRepPartItem(arReqArcID,arPartData)
	q:Err'=0 "-12"

	/// 后处理
	s arDispListData=$p(arListData,"^",4)
	s Err=..InsRepDisp(arReqArcID,arDispListData)
	q:Err'=0 "-13"
	
	/// 医嘱项
	s ItmmastID=$p(arListData,"^",1)
	/// 唯一标示
	s uniqueID=$p(arListData,"^",6)
	q arReqArcID_"^"_ItmmastID_"^"_uniqueID
}

/// Descript:  合并相同检查项目
/// 		   规则:1、按照接收科室分组，一个接收科室一个申请单；
///                 2、按照医嘱项分组，同一个医嘱项在体位和后处理相同的情况下(仅部位不同)，为同一个项目
/// W ##Class(web.DHCAPPExaReport).dealInsListData("")
ClassMethod dealInsListDataDoc(ListData As %String) As %String
{
	n (ListData)
	
	s pid=##Class(web.DHCAPPExaReportQuery).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
    k itmExaPurp
	s Len = $L(ListData,$C(1))   		 /// 检查分类数目
	f i=1:1:Len  d
	.s sListData=$p(ListData,$C(1),i)
	.s armListData = $p(sListData,$C(2),1)   /// 申请表主信息
	.s arcListData = $p(sListData,$C(2),2)   /// 医嘱项关联信息
	.s ToothInfo=$p(sListData,$C(2),3)   ///牙位图
	.s arExecLocID=$p(armListData,"^",2)   /// 执行科室
	.s itemExaPurp=$p(armListData,"^",4)   /// 检查目的
	.s arItmmastID=$p(arcListData,"^",1)   /// 医嘱项ID
	.s arPosiList=$p(arcListData,"^",2)    /// 体位
	.s arPartID=$p(arcListData,"^",3)      /// 部位
	.s arDispList=$p(arcListData,"^",4)    /// 后处理
	.s arReqDate=$p(arcListData,"^",5)     /// 医嘱日期
	.s uniqueID=$p(arcListData,"^",6)      /// 唯一标识
	.s arEmgFlag=$p(arcListData,"^",7)     /// 加急标志
	.s arRemark=$p(arcListData,"^",8)      /// 备注
	.s arcAppendOrderStr=$p(arcListData,"^",9)   /// 附加绑定的医嘱
	.s itemCatID=##Class(web.DHCAPPExaReportQuery).GetArcCat(arItmmastID)
	.s index=arExecLocID_"^"_itemCatID_"^"_arReqDate   /// 分单规则
	.
	.i '$d(itmExaPurp(index)) s itmExaPurp(index)=itemExaPurp   /// 重新合并检查目的
	.E  s itmExaPurp(index)=itmExaPurp(index)_"、"_itemExaPurp
	.
	.i (arEmgFlag="Y")&'$d(itmExaEmgFlag(index)) s itmExaEmgFlag(index)="Y"     /// 加急标志
	.s index2=arItmmastID_"^"_arDispList_"^"_uniqueID_"^"_$s(arPartID="":arRemark,1:"")
	.i arPartID["$$" s index3=arPartID
	.E  D
	..s index3=arPartID_"$$"_arPosiList_"$$"_$s(arPartID=0:"",1:arRemark)_"$$"_arcAppendOrderStr
	.s mListData=armListData
	.s ^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid,index)=mListData
	.s ^TMP("DHCST","web.DHCAPPExaReport","dealInsListDataTooth",pid,index)=ToothInfo 
	.s ^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid,index,index2)=""
	.s ^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid,index,index2,index3)=""
	.

	s ListData=""
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid,index)) Q:index=""  D
	.s itmExaArcList=""
	.s mListData=$g(^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid,index))
	.s $p(mListData,"^",3)=$g(itmExaEmgFlag(index))   /// 设置加急标志
	.s $p(mListData,"^",4)=$g(itmExaPurp(index))      /// 设置检查目的
	.s ToothInfo=$g(^TMP("DHCST","web.DHCAPPExaReport","dealInsListDataTooth",pid,index))
	.s index2=""
	.f  s index2=$o(^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid,index,index2)) Q:index2=""  D
	..s itmmmastid=$p(index2,"^",1)    /// 医嘱项ID
	..s itemExaDispID=$p(index2,"^",2) /// 后处理
	..s itemUniqueID=$p(index2,"^",3)  /// 唯一标识
	..s itemExaRemark=$p(index2,"^",4) /// 备注
	..s arcAppendOrderStr=$p(index2,"^",5)
	..s itemExaPartID=""
	..s index3=""   /// index3 - PartID_"^"_arPosiList
	..f  s index3=$o(^TMP("DHCST","web.DHCAPPExaReport","dealInsListData",pid,index,index2,index3)) Q:index3=""  D
	...i itemExaPartID="" s itemExaPartID=index3
	...E  s itemExaPartID=itemExaPartID_"@"_index3
	..s itmmastList=itmmmastid_"^"_""_"^"_itemExaPartID_"^"_itemExaDispID_"^"_itemExaRemark_"^"_itemUniqueID_"^^^^^^"_arcAppendOrderStr
	..
	..i itmExaArcList="" s itmExaArcList=itmmastList
	..E  s itmExaArcList=itmExaArcList_"&&"_itmmastList
	.
	.i ListData="" s ListData=mListData_$C(2)_itmExaArcList_$C(2)_ToothInfo
	.E  s ListData=ListData_$C(1)_mListData_$C(2)_itmExaArcList_$C(2)_ToothInfo
	.
	d ..killTmpGlobal(pid) //k掉临时global

	Q ListData
}

/// Descript:    修改检查申请 DHC_AppRepArc、DHC_AppRepPart 医嘱执行ID
/// W ##Class(web.DHCAPPExaReport).modRepArc("16||2^8040^30152||71||1") 
ClassMethod modExaRepArc(param As %String) As %String
{
	n (param)
	s arRowID=$p(param,"^",1)   /// 申请记录子表RowId
	s PartID=+$p(param,"^",2)   /// 部位ID
	s arExecID=$p(param,"^",3)  /// 执行ID
	s TarID=$p(param,"^",4)     /// 收费项目表ID
	s arOeori=$p(arExecID,"||",1)_"||"_$p(arExecID,"||",2) 	/// 医嘱ID
	s Err=##Class(web.DHCAPPExaReport).modRepArc(arRowID, arOeori)
	Q:Err="" -1
	Q:'..GetExaReqPartNum(+arRowID,$p(arRowID,"||",2)) 0   /// 部位数为0,不更新部位表
	s Err=##Class(web.DHCAPPExaReport).modTarItm(TarID, arOeori, arExecID)
	Q:Err="" -2
	Q 0
}

/// Descript:  更新申请部位表执行记录ID
ClassMethod modRepArc(arRowID As %String, arOeori As %String) As %String
{
	n (arRowID, arOeori)
	&SQL(update DHC_AppRepArc set AR_OrdItem=:arOeori where AR_RowID=:arRowID)
	Q SQLCODE
}

/// Descript:  更新申请部位表执行记录ID
ClassMethod UpdExaRepPart(arRowID As %String, arExecID As %String) As %String
{
	n (arRowID, arExecID)
	&SQL(update DHC_AppRepPart set AR_OrdExec_Dr=:arExecID where AR_RowID=:arRowID)
	Q SQLCODE
}

/// Descript: 更新检查申请
ClassMethod modExaRepSendFlag(arReqID As %String) As %String
{
	n (arReqID)
	s arSendFlag="Y"
	&SQL(update DHC_AppReport set AR_SendFlag=:arSendFlag where AR_Rowid=:arReqID)
	Q SQLCODE
}

/// Descript:  更新检查申请收费项目
ClassMethod modTarItm(TarId As %String, Oeori As %String, OrdExecID As %String) As %String
{
	n (TarId, Oeori, OrdExecID)
	&SQL(update DHC_AppRepTarItm set ARTI_OrdItem=:Oeori, ARTI_OrdExec=:OrdExecID where ARTI_RowId=:TarId)
	Q SQLCODE
}

/// Descript: 更新检查申请部位表执行记录ID
ClassMethod InsExaReqOrdExeID(arReqID As %String) As %String
{
	n (arReqID)
	s Err=0
	s CH=""
	F  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:(CH="")||(Err'=0)  D
	.s oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)  /// 医嘱ID
	.Q:oeori=""
	.s Sub=""
	.f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:(Sub="")||(Err'=0)  D
	..s PartID=+$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  /// 部位ID
	..Q:PartID=0
	..Q:'$d(^OEORD(+oeori,"I",$p(oeori,"||",2),"X",Sub))
	..s OrdExecID=oeori_"||"_Sub
	..s Err=..UpdExaRepPart(arReqID_"||"_CH_"||"_Sub,OrdExecID)
	.
	Q Err
}

ClassMethod IsAllowRepeatOneday(Inarcimid As %String) As %String
{
	s DHCARCIMRowid=$O(^DHCItmMast("0","ARCIM",Inarcimid,0))
	Q:DHCARCIMRowid="" "N"
	s LabOrdDayAllowRepeat=$p(^DHCItmMast(DHCARCIMRowid),"^",26)
	Q LabOrdDayAllowRepeat //医嘱项扩展设定-允许检验医嘱重复
}

/// Descript:  一天内是否重复开设过此项目
/// W ##Class(web.DHCAPPExaReport).IsRepeatOneday("1647","2755||1","")
ClassMethod IsRepeatOneday(EpisodeID As %String, Inarcimid As %String, InPartID As %String) As %String
{
	n (EpisodeID, Inarcimid, InPartID, %session)
	s ItemCatRowid=$p($g(^ARCIM(+Inarcimid,$p(Inarcimid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	if (OrderType'="L") {
		s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
		s NotAlertRepeatItemCat=..%GetConfig("NotAlertRepeatItemCat",AdmHospitalId)
		Q:(("^"_NotAlertRepeatItemCat_"^")[("^"_ItemCatRowid_"^")) 0
	}
	s quitflag=0
	s arRepID=""
	f  s arRepID=$o(^DHCAPREP(0,"ADM",EpisodeID,arRepID)) Q:(arRepID="")||(quitflag=1)  D
	.s reqData=$p(^DHCAPREP(arRepID),"^",2)		/// 申请日期
	.Q:+$H'=reqData
	.s CH=""
	.f  s CH=$o(^DHCAPREP(arRepID,"AR",CH)) Q:(CH="")||(quitflag=1)  D
	..s arcimid=$p(^DHCAPREP(arRepID,"AR",CH),"^",1)        /// 医嘱项目ID
	..Q:arcimid=""
	..s Oeori=$p(^DHCAPREP(arRepID,"AR",CH),"^",3)     
	..s OeStat=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)   /// 医嘱状态
	..//Q:(OeStat="D")||(OeStat="C")||(OeStat="U")
	..Q:(OeStat'="V")&&(OeStat'="E")
	..Q:Inarcimid'=arcimid
	..i InPartID="" s quitflag=1
	..Q:quitflag=1
	..s Sub=""
	..f  s Sub=$o(^DHCAPREP(arRepID,"AR",CH,"PA",Sub)) Q:(Sub="")||(quitflag=1)  D
	...s PartID=+$p(^DHCAPREP(arRepID,"AR",CH,"PA",Sub),"^",1) /// 部位ID
	...Q:PartID=0
	...Q:$p(^DHCAPREP(arRepID,"AR",CH,"PA",Sub),"^",2)="D"     /// 执行状态
	...Q:InPartID'=PartID
	...s quitflag=1
	..Q:quitflag=1
	.
	Q quitflag
}

/// Creator:    bianshuai
/// CreateDate: 2017-04-11
/// Descript:   项目是否允许进行撤销操作
/// InPut:      arRepItmID-申请子表ROWID
/// OutPut:     0-允许，其他-不允许
/// w ##Class(web.DHCAPPExaReport).isAllowRevReqItm("803||1")
ClassMethod isAllowRevReqItm(arPartID As %String, LgParam As %String) As %String
{
	n (arPartID, LgParam,%session)
	s arReqID=$p(arPartID,"||",1) s CH=$p(arPartID,"||",2)
	Q:'$d(^DHCAPREP(arReqID,"AR",CH)) "-1"
	s EpisodeID=$p(^DHCAPREP(arReqID),"^",6)	  /// 就诊ID
	s PatType=$p(^PAADM(EpisodeID),"^",2)  		  /// 病人类型
	s Oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)  /// 医嘱ID
	s Billed=""
	i Oeori'="" s Billed=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",5) /// 医嘱
	//Q:(PatType'="I")&(Billed="P") "-2"  /// 门急诊已收费的项目不允许进行撤销操作
	Q:(PatType'="I")&&(##class(web.UDHCStopOrderLook).IsPayCanStopOrder(Oeori)=1) "-2"
	/// 判断是否此医嘱的执行记录是否已执行过收费
	//s TarFlag=##Class(appcom.OEOrdItem).Executed(Oeori)
	//Q:(PatType="I")&(TarFlag=1) "-3"
	Q:(PatType="I")&(..GetOrdExecFlag(arPartID)) "-4"
	/// 医嘱状态
	//Q:(PatType="I")&(##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)="E") 0
	/// 停医嘱权限判断
	s LgUserID=$p(LgParam,"^",1) s LgCtLocID=$p(LgParam,"^",2) s LgGroupID=$p(LgParam,"^",3)
	i ((PatType="I")&&(Oeori'="")) {
		s Err=##Class(web.DHCAPPExaReport).GetExaReqItmStat(arPartID,"")
		if (Err'=1) {
			s flag=##Class(web.DHCDocMain).CheckCancelOrder(Oeori,LgUserID,LgCtLocID,LgGroupID,.msg)
			if (+flag'=1){
				q msg
				}
		}
	}
	
	i Oeori'="" Q:('##Class(web.DHCAPPExaReportQuery).GetStopPermission(Oeori, LgUserID)) "-5"
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2017-05-18
/// Descript:   医嘱的性别/年龄限制
/// OutPut:     1 限制,0非限制
/// w ##Class(web.DHCAPPExaReport).GetItmLimitMsg("803||1","")
ClassMethod GetItmLimitMsg(EpisodeID As %String, itmmastid As %String) As %String
{
	n (EpisodeID, itmmastid)
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s HospID=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s ret=##Class(web.DHCDocOrderCommon).GetItemAgeSexRestriction(itmmastid,PatientID,HospID)
	Q:+ret=0 ""
	if ($p(ret,$C(2),3)'=""){
		s ret="被限制使用："_$p(ret,$C(2),3)
	}else{
		s ret="被限制使用："_$p(ret,$C(2),2)
	}
	
	Q ret
}

/// Creator:    bianshuai
/// CreateDate: 2017-08-03
/// Descript:   取部位对应的执行记录是否已经执行
/// InPut:      arPartID-申请项目子表ROWID
/// OutPut:     0-未知，1-已执行
/// w ##Class(web.DHCAPPExaReport).GetOrdExecFlag("13||1||1")
ClassMethod GetOrdExecFlag(arPartID As %String) As %String
{
	n (arPartID)
	s OrdExecFlag=0
	s arReqID=$p(arPartID,"||",1), CH=+$p(arPartID,"||",2), Sub=+$p(arPartID,"||",3)
	Q:'$D(^DHCAPREP(arReqID,"AR",CH)) "0"
	Q:'$D(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) "0"
	s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)    /// 部位ID
	s TrID=""
	F  s TrID=$o(^DHCAPREPTA(0,"ReqItm",arReqID_"||"_CH,TrID)) Q:(TrID="")||(OrdExecFlag=1)  D
	.Q:$p(^DHCAPREPTA(TrID),"^",3)'="P"      /// 类型
	.Q:$p(^DHCAPREPTA(TrID),"^",1)'=PartID
	.s OrdExecID=$p(^DHCAPREPTA(TrID),"^",10)
	.s Ord=+OrdExecID, Itm=$p(OrdExecID,"||",2), Sub=$p(OrdExecID,"||",3)
	.s ExecID=$p(^OEORD(Ord,"I",Itm,"X",Sub),"^",16)  /// 执行状态
	.Q:ExecID=""
	.s ExCode=$p(^OEC("STAT",ExecID),"^",1)
	.i ExCode="F" s OrdExecFlag=1
	.
	Q OrdExecFlag
}

/// Creator:    bianshuai
/// CreateDate: 2017-08-28
/// Descript:  	是否需要更新检查申请收费项目表
///            	撤销部位不造成收费项目变化时，不更新收费项目表
/// InPut:      arPartID - 检查申请部位表ID, PartID - 部位ID
/// OutPut:     1 - 不需要更新,  其他 - 需要更新
/// w ##Class(web.DHCAPPExaReport).isUpdTarItm("298")
ClassMethod isUpdTarItm(arPartID As %String, PartID As %String) As %String
{
	n (arPartID, PartID)
	s QuitFlag=0
	s arReqID=$p(arPartID,"||",1)
	s CH=$p(arPartID,"||",2)
	Q:(arReqID="")||(CH="") ""
	s PartFlag=..GetExaReqItmStat(arPartID,"")  /// 是否存在非停部位
	Q:PartFlag'=1 ""
	s oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3) /// 检查申请医嘱ID
	Q:oeori="" ""
 	s TarId=""
	f  s TarId=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarId)) Q:(TarId="")||(QuitFlag'=0)  D
	.s TarBilled=$p(^DHCAPREPTA(TarId),"^",9)    /// 计费标志
	.Q:(TarBilled="I")||(TarBilled="R")
	.s TarType=$p(^DHCAPREPTA(TarId),"^",3)  	 /// 类型
	.Q:TarType'="P"
	.s IPartID=$p(^DHCAPREPTA(TarId),"^",1) 	 /// pointor 指针
	.Q:(TarType="P")&(IPartID'=PartID)
	.s QuitFlag=1
	i QuitFlag=1 Q "0"
	Q "1"
}

/// ===============================================安徽省立增加保存模板的功能===============================================
/// Table:DHC_AppPatSymTemp
/// Descript:保存主诉模板
/// w ##class(web.DHCAPPExaReport).SavePatSymModel(^Tempscl("SavePatSymModel"))
ClassMethod SavePatSymModel(params As %String) As %String
{
	n (params)
	s EpisodeID=$p(params,"^",1)
	s PatStmTom=$p(params,"^",2)
	s amSaveas=$p(params,"^",3)
	s amPointer=$p(params,"^",4)
	q:$d(^DHCAPPATSYT(0,"Text",$System.Encryption.SHA1Hash(PatStmTom),amPointer)) -1
	s:amSaveas="" amSaveas=$p(^CTLOC(amPointer),"^",2)
	s amOpuser=$p(params,"^",5)
	&sql(insert into DHC_AppPatSymTemp (AM_Adm_Dr,AM_Text,AM_SaveAs,AM_Pointer,AM_OpUser) values (:EpisodeID,:PatStmTom,:amSaveas,:amPointer,:amOpuser))
	q SQLCODE
}

/// 删除主诉模板
/// w ##class(web.DHCAPPExaReport).DeletePatSymTom("","") 
ClassMethod DeletePatSymTom(amRowId As %String, OpUserId As %String) As %String
{
	n (amRowId,OpUserId)
	&sql(delete from DHC_AppPatSymTemp where AM_RowID=:amRowId and AM_OpUser=:OpUserId)
	q SQLCODE
}

/// 保存现病史模板
/// w ##class(web.DHCAPPExaReport).SavePreHis("32595^wrw^User^2874^2874")
ClassMethod SavePreHis(params As %String) As %String
{
	n (params)
	s EpisodeID=$p(params,"^",1)
	s PatPreHis=$p(params,"^",2)
	s apSaveas=$p(params,"^",3)
	s apPointer=$p(params,"^",4)
	q:$d(^DHCAPPREHT(0,"Text",PatPreHis,apPointer)) -1
	s:apSaveas="" apSaveas=$p(^CTLOC(apPointer),"^",2)
	s apOpuser=$p(params,"^",5)
	&sql(insert into DHC_AppPreHisTemp (AP_Adm_Dr,AP_Text,AP_SaveAs,AP_Pointer,AP_OpUser) values (:EpisodeID,:PatPreHis,:apSaveas,:apPointer,:apOpuser))
	q SQLCODE
}

/// 删除现病史
ClassMethod DeletePreHis(apRowId As %String, OpUserId As %String) As %String
{
	n (apRowId,OpUserId)
	&sql(delete from DHC_AppPreHisTemp where AP_RowID=:apRowId and AP_OpUser=:OpUserId)
	q SQLCODE
}

/// 保存体征模板
/// w ##class(web.DHCAPPExaReport).SaveSignModel("32595^gfdf^^306^2874")
ClassMethod SaveSignModel(params As %String) As %String
{
	n (params)
	s EpisodeID=$p(params,"^",1)
	s PatSign=$p(params,"^",2)
	s aptSaveas=$p(params,"^",3)
	s aptPointer=$p(params,"^",4)
	q:$d(^DHCAPATST(0,"Text",PatSign,aptPointer)) -1
	s:aptSaveas="" aptSaveas=$p(^CTLOC(aptPointer),"^",2)
	s aptOpuser=$p(params,"^",5)
	&sql(insert into DHC_AppPatSignsTemp (APT_Adm_Dr,APT_Text,APT_SaveAs,APT_Pointer,APT_OpUser) values (:EpisodeID,:PatSign,:aptSaveas,:aptPointer,:aptOpuser))
	q SQLCODE
}

/// 删除体征
ClassMethod DeleteSign(aptRowId As %String, OpUserId As %String) As %String
{
	n (aptRowId,OpUserId)
	&sql(delete from DHC_AppPatSignsTemp where APT_RowID=:aptRowId and APT_OpUser=:OpUserId)
	q SQLCODE
}

/// 保存检查目的模板
/// w ##class(web.DHCAPPExaReport).SavePurModel("289^777^孙凤霞^359^359")
ClassMethod SavePurModel(params As %String) As %String
{
	n (params)
	s EpisodeID=$p(params,"^",1)
	s PatPur=$p(params,"^",2)
	s aptSaveas=$p(params,"^",3)
	s aptPointer=$p(params,"^",4)
	q:$d(^DHCAPPPUR(0,"Text",PatPur,aptPointer)) -1
	s:aptSaveas="" aptSaveas=$p(^CTLOC(aptPointer),"^",2)
	s aptOpuser=$p(params,"^",5)
	&sql(insert into DHC_AppPatPurTemp (APT_Adm_Dr,APT_Text,APT_SaveAs,APT_Pointer,APT_OpUser) values (:EpisodeID,:PatPur,:aptSaveas,:aptPointer,:aptOpuser))
	q SQLCODE
}

/// 删除检查目的
ClassMethod DeletePur(aptRowId As %String, OpUserId As %String) As %String
{
	n (aptRowId,OpUserId)
	&sql(delete from DHC_AppPatPurTemp where APT_RowID=:aptRowId and APT_OpUser=:OpUserId)
	q SQLCODE
}

/// ===========================================保存检查分类模板====================================
/// sufan  新增保存检查分类模板的方法
/// Descript : 保存检查分类模板
/// Others   ：w ##Class(web.DHCAPPExaReport).SaveExaTree("个人模板^个人模板^0^^1^User^2874^User^2874$$头部^头部^968^^1^User^2874^User^2874$$鼻骨侧位^鼻骨侧位^991^^1^User^2874")
ClassMethod SaveExaTree(params As %String) As %String
{
	n (params)
  	s Err=0
  	q:($p($p(params,"$$",1),"^",1)="个人模板")||($p($p(params,"$$",1),"^",1)="科室模板") -3
  	S Err=..isExistPersonModel(params)       ///判断是否存在个人模板字段，返回该记录的ID
  	i Err'=0  d
  	.s length=$l(params,"$$")
  	.f j=1:1:length  d
  	..s sListData=$p(params,"$$",j)
  	..s ListData=$p(sListData,"^",1,2)_"^"_Err_"^"_$p(sListData,"^",4,7)
  	..s Err=..InsTraTreeAdd(ListData)
  	e  d    
  	.s ListData="个人模板"_"^"_"个人模板"_"^"_"0"_"^"_$p($p(params,"$$",1),"^",4,7)
  	.s Err=..InsTraTreeAdd(ListData)
	.s len=$L(params,"$$")
	.f i=1:1:len d
	..s mListData=$p(params,"$$",i)
	..s hListData=$p(mListData,"^",1,2)_"^"_Err_"^"_$p(mListData,"^",4,7)
	..s Err=..InsTraTreeAdd(hListData)
	Q Err
}

/// 判断是否存在个人模板字段
ClassMethod isExistPersonModel(params As %String) As %String
{
	n (params)
	s ListData=$p(params,"$$",1)
	s ret=0
	s SPointer=$p(ListData,"^",7)
	i $d(^DHCAPPTRA(0,"Code","个人模板")) d
	.s RowId=""
	.f  s RowId=$o(^DHCAPPTRA(0,"Code","个人模板",RowId)) q:RowId=""  d
	..s Pointer=$p(^DHCAPPTRA(RowId),"",9)
	..s ret=RowId
	..q:Pointer=SPointer 
	q ret
}

/// Descript: 保存分类树
/// w ##Class(web.DHCAPPExaReport).InsTraTreeAdd("ECT检查^复合线路显像^8003^^65$$ECT检查^ECT检查(个人)^8002^65$$101002B^骨科二病区(个人)^0^65")
ClassMethod InsTraTreeAdd(mListData As %String) As %String
{
	n (mListData)
	s Err=0
	s TraCode=$p(mListData,"^",1)       // 分类代码
	s TraDesc=$p(mListData,"^",2)       // 分类描述
	s TraLastLevID=$p(mListData,"^",3)  // 上级ID
	s TraAlias=$p(mListData,"^",4)      // 别名
	s HospID=$p(mListData,"^",5)        // 医院id
	s SaveAs=$p(mListData,"^",6)
	s Pointer=$p(mListData,"^",7)
	s Err=..isExistCurItem(TraLastLevID,mListData)   ///判断是否存在相同的分类
	q:Err'=0 Err
	s OrdNum=..GetMaxOrdNum(TraLastLevID)        //序号
	&sql(insert into DHC_AppTreeAdd (TRA_Code,TRA_Desc,TRA_LastRowid,TRA_Hosp_Dr,TRA_OrdNum,TRA_Alias,TRA_SaveAs,TRA_Pointer)
	  values (:TraCode,:TraDesc,:TraLastLevID,:HospID,:OrdNum,:TraAlias,:SaveAs,:Pointer))
 	Q %ROWID
}

/// 判断是否存在相同的分类
/// w ##Class(web.DHCAPPExaReport).isExistCurItem(968,"CT^CT^968^^1^User^2874")
ClassMethod isExistCurItem(LastLevID As %String, ListData As %String) As %String
{
	n (LastLevID, ListData)
	s ret=0
	s itemDesc=$p(ListData,"^",2)                ///分类描述
	s Pointer=$p(ListData,"^",7)
	s ID="" ,Ordnum=""
	f  s Ordnum=$o(^DHCAPPTRA(0,"SaveAs",Pointer,LastLevID,Ordnum)) q:(Ordnum="")||(ret'=0)  d
	.f  s ID=$o(^DHCAPPTRA(0,"SaveAs",Pointer,LastLevID,Ordnum,ID)) q:(ID="")||(ret'=0)  D
	..s TraCatDesc=$p(^DHCAPPTRA(ID),"^",2)          ///通过遍历获取分类描述
	..s SPointer=$p(^DHCAPPTRA(ID),"^",9)
	..Q:itemDesc'=TraCatDesc
	..s ret=ID
	Q ret
}

/// sufan  2017-1-20  
/// Descript: 保存分类关联医嘱
/// w ##Class(web.DHCAPPExaReport).SaveTraTreeLink("961^155||1^")
ClassMethod SaveTraTreeLink(params As %String) As %String
{
	n (params)
  	s Err=0
	s len=$L(params,"&&")
	f i=1:1:len d
	.s mListData=$p(params,"&&",i)
	.s Err=..InsTraTreeLink(mListData)
	Q Err
}

/// Descript: 保存分类关联医嘱
/// w ##Class(web.DHCAPPExaReport).InsTraTreeLink("960^155||1^")
ClassMethod InsTraTreeLink(mListData As %String) As %String
{
	n (mListData)
	s Err=0
	s TraID=$p(mListData,"^",1)            /// 主表ID
	s ItmmastID=$p(mListData,"^",2)        /// 医嘱项ID
	s PartID=$p(mListData,"^",3)           /// 部位ID
	s StDate=..%SysDate()
	s Err=..isExistSameItmCat(mListData)
	q:Err'=0 -2
    s OrdNum=..GetMaxOrdsubNum(TraID)
	s ChildSub=$o(^DHCAPPTRA(TraID,"I",""),-1)+1
	&sql(insert into DHC_AppTreeLink(TRA_Add_ParRef,TRA_ChildSub,TRA_Part_Dr,TRA_Arc_Dr,TRA_StDate,TRA_OrdNum) 
		values(:TraID,:ChildSub,:PartID,:ItmmastID,:StDate,:OrdNum))
    Q SQLCODE
}

/// 判断同意级别下，是否存在相同的医嘱项
/// w ##Class(web.DHCAPPExaReport).isExistSameItmCat("961^155||1^")
ClassMethod isExistSameItmCat(mListData As %String) As %String
{
	n (mListData)
	s flag=0
	s TraID=$p(mListData,"^",1)            /// 主表ID
	s ItmmastID=$p(mListData,"^",2)        /// 医嘱项ID
	s Sub=""
	f  s Sub=$o(^DHCAPPTRA(TraID,"I",Sub)) q:(Sub="")||(flag=1)  d
	.s ArcID=$p(^DHCAPPTRA(TraID,"I",Sub),"^",2)
	.q:ItmmastID'=ArcID
	.s flag=1
	q flag
}

/// 分类项目存在时，返回存在分类的Id
/// w ##Class(web.DHCAPPExaReport).GetExacatId("909")
ClassMethod GetExacatId(TraId)
{
	n (TraId)
	s ret=0
	s ExacatDesc=$p(^DHCAPPTRA(TraId),"^",1)
	s STraID=""
	f  s STraID=$o(^DHCAPPTRA(0,"Code",ExacatDesc,STraID)) q:STraID=""  d
	.s SaveAs=$p(^DHCAPPTRA(STraID),"^",8)
	.s ret=STraID
	.q:SaveAs="User"
	q ret
}

/// 获取分类顺序号
ClassMethod GetMaxOrdNum(Lastlevid As %String) As %String
{
	n (Lastlevid)
	s maxnum=0
	i +Lastlevid=0  d
	.s TraID="",Ordnum=""
	.f  s Ordnum=$o(^DHCAPPTRA(0,"LastRowid",Lastlevid,Ordnum)) q:Ordnum=""  d
	..f  s TraID=$o(^DHCAPPTRA(0,"LastRowid",Lastlevid,Ordnum,TraID))  q:TraID=""  d
	...s maxnum=maxnum+1
	...;i ordnum>maxnum s maxnum=ordnum
	e  d
	.s TraID="",Ordnum=""
	.f  s Ordnum=$o(^DHCAPPTRA(0,"LastRowid",Lastlevid,Ordnum)) q:Ordnum=""  d
	..f  s TraID=$o(^DHCAPPTRA(0,"LastRowid",Lastlevid,Ordnum,TraID)) q:TraID=""  d
	...s ordnum=$p(^DHCAPPTRA(+TraID),"^",6)
	...i ordnum>maxnum s maxnum=ordnum
	s maxnum=maxnum+1
	q maxnum
}

/// 取子表的顺序号
/// w ##class(web.DHCAPPExaReport).GetMaxOrdsubNum(13)
ClassMethod GetMaxOrdsubNum(TraID As %String) As %String
{
	n (TraID)
	s maxnum=0
	s CH=""
	f  s CH=$o(^DHCAPPTRA(TraID,"I",CH))  q:CH=""  d
	.s ordnum=$p(^DHCAPPTRA(TraID,"I",CH),"^",5)
	.i ordnum>maxnum s maxnum=ordnum
	s maxnum=maxnum+1
	q maxnum
}

/// Creator：   bianshuai
/// CreatDate： 2018-12-13
/// Descript:   修改检查申请单、医嘱表打印标志
/// Input：	    ExaReqID - 申请单ID, PrtUserID - 操作人
/// Return：    0：成功，其他：不成功
/// w ##Class(web.DHCAPPExaReport).InsExaRepPrtFlag("618","4647")
ClassMethod InsExaRepPrtFlag(ExaReqID As %String, PrtUserID As %String) As %String
{
	n (ExaReqID,PrtUserID)
	s Err=0
	Q:$p(^DHCAPREP(ExaReqID),"^",22)'="" 0
	TS
	/// 修改申请单打印标志
	s Err = ..UpdNurPrtInfo(ExaReqID,PrtUserID)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	/// 修改医嘱表打印标志
	s Err = ..InsOrdPrtFlag(ExaReqID,PrtUserID)
	i Err'=0 tro
	q:Err'=0 "-12"
		
	TC
	Q Err
}

/// Creator：   sufan
/// CreatDate： 2018-02-05
/// Descript:   更新打印人、打印日期、打印时间
/// Table：     DHC_AppReport  
/// Input：	    ExaReqID：申请单ID   
/// Return：    0：成功，其他：不成功
/// w ##Class(web.DHCAPPExaReport).UpdNurPrtInfo("568!568||2||1","")
ClassMethod UpdNurPrtInfo(ExaReqID As %String, PrtUserID As %String) As %String
{
	n (ExaReqID,PrtUserID)
	s PrtDate=..%SysDate()
	s PrtTime=..%SysTime()
	&SQL(Update DHC_AppReport set AR_NurPrtUserId=:PrtUserID, AR_NurPrtDate =:PrtDate,AR_NurPrtTime=:PrtTime 
		Where AR_Rowid=:ExaReqID)
	q SQLCODE
}

/// Creator：   bianshuai
/// CreatDate： 2018-12-13
/// Descript:   修改检查申请单医嘱打印标志  
/// Input：	    ID - 申请单ID，UserID - 操作人  
/// Return：    0：成功，其他：失败
/// w ##Class(web.DHCAPPExaReport).InsOrdPrtFlag("","")
ClassMethod InsOrdPrtFlag(ID As %String, UserID As %String) As %String
{
	n (ID, UserID)
	s EpisodeID=$p(^DHCAPREP(ID),"^",6)	     /// 就诊ID
	s CH="",mListData="",TraType="",OrdType="",Err=0
	F  s CH=$o(^DHCAPREP(ID,"AR",CH)) Q:(CH="")||(Err'=0)  D
	.s itmmastid=$p(^DHCAPREP(ID,"AR",CH),"^",1)  /// 医嘱项ID
	.i TraType="" s TraType=##Class(web.DHCAPPExaReportQuery).GetTraType(itmmastid)
	.s Oeori=$p(^DHCAPREP(ID,"AR",CH),"^",3)           /// 医嘱ID
	.i mListData'="" s mListData=mListData_"^"_Oeori
	.E  s mListData=Oeori

	s TraType=$s(TraType="E":"JCDMZ",1:"JYDO") /// 医生站接口代码 JCDMZ-检查、JYDO-检验
	s menuOERalation=""
	for i=1:1:$L(mListData,"^") {
		s LoopData=TraType_"."_$P(mListData,"^",i)_$C(2)_"true"
		if (menuOERalation=""){
			s menuOERalation=LoopData
		}else{
			s menuOERalation=menuOERalation_$C(1)_LoopData
		}
	}
	//s selectedListRows=EpisodeID_TraType_ID
	s selectedListRows=""
	/// 调用医生站接口
	//D ##Class(DHCDoc.OPDoc.PrintHistory).Record(mListData,TraType_"."_$REPLACE(mListData,"^",$C(2)_TraType_"."),"NULL",EpisodeID_TraType_ID)
	D ##Class(DHCDoc.OPDoc.PrintHistory).Record(mListData,menuOERalation,"NULL",selectedListRows)
	Q Err
}

/// Creator:     bianshuai
/// CreateDate:  2018-03-10
/// Descript:    住院急诊留观押金控制
/// w ##Class(web.DHCAPPExaReport).GetArrearsManage("279","104","266","16")
ClassMethod GetArrearsManage(EpisodeID As %String, LgGroupID As %String, LgLocID As %String, amount As %String) As %String
{
	n (EpisodeID, LgGroupID, LgLocID, amount,%session)
	s ^tempqujian("GetArrearsManage")=$LB(EpisodeID, LgGroupID, LgLocID, amount)
	s PatType=$p(^PAADM(EpisodeID),"^",2)  		  /// 病人类型
	s VisitStatus=$p(^PAADM(EpisodeID),"^",20)    /// 病人当前状态
	Q:VisitStatus="P" ""
 	/// 住院急诊留观押金控制
 	s NotDoCheckDeposit=+..%GetConfig1("NotDoCheckDeposit",LgGroupID)
 	Q:NotDoCheckDeposit=1 ""
 	/// 补录模式
    /// s SupplementMode=..%GetConfig1("SupplementMode",%session.Get("LOGON.GROUPID"))
    /// Q:SupplementMode=1 ""
    /// 1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
    s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
    Q:(PatType'="I")&(GetStayStatusFlag'=1)&(GetStayStatusFlag'=2) ""
    /// 是否进行欠费控制及科室是否进行欠费控制
    s CheckIPDeposit=..%GetConfig("CheckIPDeposit")
    Q:CheckIPDeposit'=1 ""
    s CheckIPLocDeposit=##Class(web.UDHCJFARREARSMANAGE).CheckLoc(LgLocID)
    Q:CheckIPLocDeposit'=0 ""
    s retDetail=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(EpisodeID, +amount, "OE")
    Q:retDetail="" ""
    Q:$p(retDetail,"^",5)'="C" ""
    Q:$p(retDetail,"^",6)="N" $p(retDetail,"^",1)_"押金余额不足" ///_$p(retDetail,"^",1)
    //s retDetail=##Class(web.UDHCJFARREARSMANAGE).CheckOrderE($p(retDetail,"^",3), itmmastid)
    //Q:retDetail=0 "押金余额不足"_$p(retDetail,"^",1)
    Q ""
}

/// 判断检验项目是否重复
/// w ##class(web.DHCAPPExaReport).IsRepeatLabSpec("4830||1","4831||1"_$C(1)_"SP004")
ClassMethod IsRepeatLabSpec(Inarcimid As %String, ArcimInfo As %String) As %String
{
	s isRepFlag=0
	s HospID=%session.Get("LOGON.HOSPID")
	/*;使用按医院区分检验设置(全局)
    s UseHospSepLabConfig=..%GetConfig("UseHospSepLabConfig")
    if (UseHospSepLabConfig="1"){
	    s CFNotCheckSameSpecItem=##Class(DHCDoc.DHCDocConfig.DocConfig).GetLabOtherCheck("NotCheckSameLabSpecItem",HospID)
	}else{*/
		;不允许重复的检验项
        s CFNotCheckSameSpecItem=..%GetConfig("NotCheckSameLabSpecItem",HospID)
	//}
	Q:CFNotCheckSameSpecItem=1 isRepFlag
	s OrderLabSpec=##class(web.DHCDocOrderCommon).GetLabSpec(Inarcimid,HospID)
	for i=1:1:$L(OrderLabSpec,$C(2)){
        s ArrData=$p(OrderLabSpec,$C(2),i)
        if ($P(ArrData,$C(3),5)= "Y") {
            s LabSpecRowid = $P(ArrData,$C(3),1)
            q
        }
    }
    s OrderLabExCodeStr=""
	s LabExCode=##class(web.DHCDocOrderCommon).GetExCode(Inarcimid)
	for i=1:1:$l(ArcimInfo,"^") {
		s oneArcimInfo=$p(ArcimInfo,"^",i)
		s ArcimRowId=$p(oneArcimInfo,$C(1),1)
		s OrderLabSpecRowid=$p(oneArcimInfo,$C(1),2)
		s OrderLabExCode=##Class(web.DHCDocOrderCommon).GetExCode(ArcimRowId)
		if ((OrderLabExCode'="") && (OrderLabSpecRowid = LabSpecRowid)) {
			if (OrderLabExCodeStr = "") {
                s OrderLabExCodeStr = OrderLabExCode
            } else {
                s OrderLabExCodeStr = OrderLabExCodeStr_"^"_OrderLabExCode
            }
		}
	}
    if (OrderLabExCodeStr'=""){
		s ret =##Class(web.DHCDocOrderCommon).CheckRepeatLabSpec(OrderLabExCodeStr, LabExCode)
		s isRepFlag=$P(ret,"^",1)
	}
	Q isRepFlag
}

ClassMethod GetExaRepSendFlag(arReqID As %String) As %String
{
	n (arReqID)
	s arSendFlag=$p(^DHCAPREP(arReqID),"^",17)  //检验检查
	Q arSendFlag
}

ClassMethod GetExaInsuFlag(arRepID As %String) As %String
{
	n (arRepID)
	s CH=$o(^DHCAPREP(arRepID,"AR",0))
	Q:CH="" ""
	s CoverMainIns=$p(^DHCAPREP(arRepID,"AR",CH),"^",11)  //医保
	Q CoverMainIns
}

// w ##class(web.DHCAPPExaReport).ISChronicOrdItm(1026,"C10010","4517||1")

ClassMethod ISChronicOrdItm(AdmDr As %String, ChronicCode As %String, sendArcimStr As %String) As %String
{
	s NotMatchMsg=""
	for i=1:1:$l(sendArcimStr,"^") {
		s oneSendArcimStr=$p(sendArcimStr,"^",i)
		s arcimRowId=$p(oneSendArcimStr,"!",1)
		s itemBillTypeID=$p(oneSendArcimStr,"!",2)
		s arcimCode=$p(^ARCIM(+arcimRowId,$p(arcimRowId,"||",2),1),"^",1)
		s ret=##class(insuqc.service.chronic.ServicePort).ISChronicOrdItm(AdmDr,ChronicCode,arcimCode,"",itemBillTypeID)
		if (ret=0) {
			s OrderName=$p(^ARCIM(+arcimRowId,$p(arcimRowId,"||",2),1),"^",2)
			if (NotMatchMsg="") s NotMatchMsg=OrderName
			else  s NotMatchMsg=NotMatchMsg_"、"_OrderName
		}
	}
	if (NotMatchMsg'="") s NotMatchMsg=NotMatchMsg_" 医嘱与慢特病不匹配,无法开出！"
	Q NotMatchMsg
}

/// w ##class(web.DHCAPPExaReport).BangLinkOrder("2529||157",12175,115)
ClassMethod BangLinkOrder(OEItemID, UserID, LocID)
{
	n (OEItemID, UserID, LocID)
	q:OEItemID="" ""
	s ^tempqujina("BangLinkOrder",OEItemID)=OEItemID_","_UserID_","_LocID
	s Adm=$P(^OEORD(+OEItemID),"^",1)
	s PAPMIRowid=$P(^PAADM(Adm),"^",1)
	s PatDOB=$P($G(^PAPER(PAPMIRowid,"ALL")),"^",6)
	s Age=$$CalAge^at182(PatDOB,+$H,"","","")
	s Age=$p(Age,"|",12)
	s CurrData=+$P($ZD(+$H,3),"-",3)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(Adm)
	s ExpStr=Adm_"^"_LocID_"^0"
	s OEOrdStr=""
	
	//s Sttdate=..%ZD(+$H)
	//s Stttime=..%ZT(..%SysTime())
	
	s Sttdate=$p($G(^OEORD(+OEItemID,"I",$P(OEItemID,"||",2),1)),"^",9)
	s Sttdate=..%ZD(Sttdate)
	s Stttime=$p($G(^OEORD(+OEItemID,"I",$P(OEItemID,"||",2),1)),"^",10)
	s Stttime=..%ZT(Stttime)
	
	s Orddate=$p($G(^OEORD(+OEItemID,"I",$P(OEItemID,"||",2),3)),"^",7)
	s Orddate=..%ZD(Sttdate)
	s Ordtime=$p($G(^OEORD(+OEItemID,"I",$P(OEItemID,"||",2),1)),"^",17)
	s Ordtime=..%ZT(Ordtime)
	s CoverMainIns=$p($g(^OEORD(+OEItemID,"I",$P(OEItemID,"||",2),3)),"^",3)
	s arEmgFlag=""

	s DrgFormRowid=""
	s SeqNo=1000
	s BillTypeRowid=$p(^PAADM(Adm,1),"^",7)
	s OrderBillTypeRowid=$p($G(^OEORD(+OEItemID,"I",$P(OEItemID,"||",2),11)),"^",18)
	//取主医嘱费别
	i OrderBillTypeRowid'="" s BillTypeRowid=OrderBillTypeRowid
	s PPRowId=$p($G(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),"DHC")),"^",10)
	s arExaReqNote=""
	s DurRowid=""
	s InstrRowid=""
	s NORMPriorId=$O(^OECPR(0,"Code","NORM",0))
	s ONEPriorId=$O(^OECPR(0,"Code","ONE",0))  
	s ARRowid=""
	s rtn=1
	for {
		s ARRowid=$O(^DHCAPREP(0,"OrdItem",OEItemID,ARRowid))
		q:ARRowid=""
		;q:rtn'=1
		s ARSub=""
		for {
			s ARSub=$O(^DHCAPREP(0,"OrdItem",OEItemID,ARRowid,ARSub))
			q:ARSub=""
			s ARCIM=$p(^DHCAPREP(ARRowid,"AR",ARSub),"^",1) 
			/*
			s AppendOrderStr=$p(^DHCAPREP(ARRowid,"AR",ARSub),"^",13) 
			if (AppendOrderStr'=""){
				//手工绑定的医嘱
				for i=1:1:$Length(AppendOrderStr,"&"){
					s OneAppendOrderStr=$P(AppendOrderStr,"&")
					s ArcimDr=$P(OneAppendOrderStr,"|||",1)
					s Qty=$P(OneAppendOrderStr,"|||",2)
					d SetOEOrdStr
				}
			}
			*/
			s APartRowid=""
			for {
				s APartRowid=$o(^DHCAPREP(+ARRowid,"AR",ARSub,"PA",APartRowid))
				q:APartRowid=""
				;q:rtn'=1
				s PartID=$p(^DHCAPREP(ARRowid,"AR",ARSub,"PA",APartRowid),"^",1)    /// 部位ID
				s AppendOrderStr=$p(^DHCAPREP(ARRowid,"AR",ARSub,"PA",APartRowid),"^",9)
				if (AppendOrderStr'=""){
					//手工绑定的医嘱
					for ii=1:1:$Length(AppendOrderStr,"&"){
						s OneAppendOrderStr=$P(AppendOrderStr,"&",ii)
						s ArcimDr=$P(OneAppendOrderStr,"|||",1)
						s Qty=$P(OneAppendOrderStr,"|||",2)
						s OpenLogHospStr=$P(OneAppendOrderStr,"|||",4)
						s OpenForAllHosp=$P(OpenLogHospStr,"!",1)
						s LogLoc=$P(OpenLogHospStr,"!",2)
						s OEOrdStr=""
						d SetOEOrdStr
						if (OEOrdStr'=""){
							s CareProvID=$p($g(^SSU("SSUSR",UserID)),"^",14)   /// 医生ID
							s ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(Adm, OEOrdStr, UserID, LocID, CareProvID, "", "^^^1")
							i ret=100 {
								s rtn=0
								q 
							}
							s OeorderStr=""
							f k=1:1:$l(ret,"^") {
								s ArcimRowId=$p($p(ret,"^",k),"*",1)
								s newOrdIdDR=$p($p(ret,"^",k),"*",2)
								i ArcimRowId="" continue
								if (OeorderStr="") {s OeorderStr=newOrdIdDR}else{s OeorderStr=OeorderStr_"&"_newOrdIdDR}
							}
							if (OeorderStr'=""){
								s arItmPartID=ARRowid_"||"_ARSub_"||"_APartRowid
								&SQL(update DHC_AppRepPart set AR_AppendOEOrderStr=:OeorderStr where AR_RowID=:arItmPartID)
							}
						}
					}
				}
			}
		}
	}
	q rtn
SetOEOrdStr
	q:(ArcimDr="")
	q:(Qty="")
	s ItemCatDR=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",10)  /// 医嘱子类ID
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  
	if (OrderType="R"){
		s OrderPriorId=ONEPriorId
	}else{
		s OrderPriorId=NORMPriorId
		
	}
	if (LogLoc=""){
		Set RecDepRowid=$$GetRecloc^DHCDocOrderCommonNew(Adm,ArcimDr,OpenForAllHosp)
	}else{
		Set RecDepRowid=$$GetLocRecLoc^DHCDocOrderCommonNew(LogLoc,ArcimDr,OpenForAllHosp,"",AdmType)
		}
	
	s Check =##Class(web.DHCDocOrderCommon).CheckStockEnough(ArcimDr, Qty, RecDepRowid,AdmType,ExpStr)
	if (+Check>0){
		s SeqNo=SeqNo+1
		s ListData=ArcimDr_"^"_OrderType_"^"_OrderPriorId_"^"_Sttdate_"^"_Stttime_"^"_Qty_"^"_""_"^"_RecDepRowid_"^"_BillTypeRowid
		s ListData=ListData_"^"_DrgFormRowid_"^"_arExaReqNote_"^"_""_"^"_""_"^"_""_"^"_""_"^"_DurRowid_"^"_InstrRowid_"^"_""_"^"_""_"^"_SeqNo
		s ListData=ListData_"^"_""_"^"_""_"^"_$g(CoverMainIns)_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"
		s $p(ListData,"^",46)=Orddate
		s $p(ListData,"^",47)=Ordtime
		s $p(ListData,"^",58)="RPB"
		s $p(ListData,"^",39)=OEItemID
		s $p(ListData,"^",56)=PPRowId
		if (OEOrdStr=""){s OEOrdStr=ListData}else{s OEOrdStr=OEOrdStr_$C(1)_ListData}
	}
	q
}

/// 获取检查医嘱配置-医嘱项关联-医嘱部位关联中，配置为自动绑定的医嘱项目
/// output：医嘱项id|||数量|||是否手工绑定&医嘱项id|||数量|||是否手工绑定&。。。。
ClassMethod GetPAAutoAppendOrdStr(EpisodeID, ARCIM, arPartID, ByRef ErrMsg As %String = "", OpenLogHospStr As %String = "") As %String
{
	n (EpisodeID,ARCIM,arPartID,ErrMsg,OpenLogHospStr)
	s AutoAppendOrdStr="",Age="",AdmLocDr=""
	if EpisodeID'=""{
		s PAPMIRowid=$P(^PAADM(EpisodeID),"^",1)
		s PatDOB=$P($G(^PAPER(PAPMIRowid,"ALL")),"^",6)
		s Age=$$CalAge^at182(PatDOB,+$H,"","","")
		s Age=$p(Age,"|",12)
		s AdmLocDr=$P(^PAADM(EpisodeID),"^",4)
	}
	s CurrData=+$P($ZD(+$H,3),"-",3)
	
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ExpStr=EpisodeID_"^"_AdmLocDr_"^0"
	s PartDesc=""
	s:arPartID'="" PartDesc=$p($g(^DHCAPPART(arPartID)),"^",2)
	s OrderName=$P(^ARCIM(+ARCIM,$P(ARCIM,"||",2),1),"^",2)
	//获取手工绑定的医嘱
	s LinkRowid=""
	for {
		s LinkRowid=$O(^DHCAPARCLARCi("ArcPart",ARCIM,arPartID,LinkRowid))
		q:LinkRowid=""
		s Arcim=$P(^DHCAPARCLARC(LinkRowid),"^",1)
		s Qty=$P(^DHCAPARCLARC(LinkRowid),"^",10)
		s AgeLimits=$p(^DHCAPARCLARC(LinkRowid),"^",12) 	///add by tanjishan 2020-06
		s DateLimits=$p(^DHCAPARCLARC(LinkRowid),"^",13)
		s ByHandle=$p(^DHCAPARCLARC(LinkRowid),"^",14)
		if (ByHandle="Y"){
			continue
		}
		if (AgeLimits'=""){
			if (Age<$P(AgeLimits,"-",1))||(Age>$P(AgeLimits,"-",2)){
				continue
			}
		}
		if (DateLimits'=""){
			if (CurrData<$P(DateLimits,"-",1))||(CurrData>$P(DateLimits,"-",2)){
				continue
			}
		}
		//s BillUOM=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
		if EpisodeID'=""{
			s BillUOM=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(Arcim,AdmType)
			s BillUOMDesc=$P(^CT("UOM",BillUOM),"^",1)
			s ArcimDesc=$P(^ARCIM(+Arcim,$P(Arcim,"||",2),1),"^",2)
			s RecDepRowid=$$GetRecloc^DHCDocOrderCommonNew(EpisodeID,Arcim)
			s Check =##Class(web.DHCDocOrderCommon).CheckStockEnough(Arcim, Qty, RecDepRowid,AdmType,ExpStr)
			if (+Check<=0){
				if (ErrMsg=""){
					s ErrMsg=ArcimDesc
				}else{
					s ErrMsg=ErrMsg_","_ArcimDesc
				}
			}
		}
		s ArcimDr=Arcim
		s Qty=Qty
		if (AutoAppendOrdStr=""){
			s AutoAppendOrdStr=ArcimDr_"|||"_Qty_"|||N"_"|||"_OpenLogHospStr
		}else{
			s AutoAppendOrdStr=AutoAppendOrdStr_"&"_ArcimDr_"|||"_Qty_"|||N"_"|||"_OpenLogHospStr
		}
	}
	if (ErrMsg'=""){
		s ErrMsg=OrderName_PartDesc_" 附加医嘱:"_ErrMsg_",没有库存，无法开立！"
	}
	q AutoAppendOrdStr
}

/// 获取手工选择的附加医嘱信息
ClassMethod GetAppendOrderStr(AppendOrderStr As %String) As %String
{
	Set langid=..%LanguageID()
	s (AppendOrder,AppendOrderIDStr)=""
	for i=1:1:$Length(AppendOrderStr,"&"){
		s OneAppendOrderStr=$P(AppendOrderStr,"&",i)
		s ArcimDr=$P(OneAppendOrderStr,"|||",1)
		s Qty=$P(OneAppendOrderStr,"|||",2)
		s HandleFlag=$P(OneAppendOrderStr,"|||",3)
		continue:(HandleFlag'="Y")
		continue:(ArcimDr="")
		s AppendOrder=$P(^ARCIM(+ArcimDr,$P(ArcimDr,"||",2),1),"^",2)
		s AppendOrder=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",AppendOrder,langid)
		s AppendOrderIDStr=ArcimDr
	}
	q AppendOrder_"^"_AppendOrderIDStr
}

/// 判断是否有库存可以勾选
ClassMethod CheckInsExaOtherOptStockEnough(EpisodeID, OtherOptID, LocID)
{
	n (EpisodeID,OtherOptID,LocID,%session)
	q:EpisodeID="" ""
	s id=+OtherOptID
	s idsub=$P(OtherOptID,"||",2)
	s Arcim=$P(^DHCAPOTHO(id,"I",idsub),"^",3)
	s ArcimDesc=$P(^ARCIM(+Arcim,$P(Arcim,"||",2),1),"^",2)
	s AdmLocDr=$P(^PAADM(EpisodeID),"^",4)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ExpStr=EpisodeID_"^"_AdmLocDr_"^0"
	s Qty=$P(^DHCAPOTHO(id,"I",idsub),"^",4)
	if Qty="" s Qty=1
	s RecDepRowid=$$GetRecloc^DHCDocOrderCommonNew(EpisodeID,Arcim)
	s Check =##Class(web.DHCDocOrderCommon).CheckStockEnough(Arcim, Qty, RecDepRowid,AdmType,ExpStr)
	s rtn =""
	if (+Check<=0){
		s rtn =Arcim_",没有库存，无法开立！"
		}
	q rtn
}

ClassMethod InsertLinkOtherOpt(arReqID, UserID, LocID, PPRowId As %String = "")
{
	n (arReqID, UserID, LocID,PPRowId)
	s SeqNo=0
	s Adm=$p(^DHCAPREP(arReqID),"^",6)
	s CH=""
	s NORMPriorId=$O(^OECPR(0,"Code","NORM",0))
	s ONEPriorId=$O(^OECPR(0,"Code","ONE",0))  
	s Sttdate= ..%ZD(+$H)
	s Stttime=..%ZT($P($H,",",2))
	s arEmgFlag=""
	s CoverMainIns=..GetExaInsuFlag(arReqID)
	i CoverMainIns=1 s CoverMainIns="Y"
	e  s CoverMainIns="N"
	s DrgFormRowid=""
	s BillTypeRowid=$p(^PAADM(Adm,1),"^",7)
	if PPRowId'=""{
		s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
		s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(Adm)
		s CFPilotPatAdmReason=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("PilotPatAdmReason","","",AdmHospitalId)
 		s CFIPPilotPatAdmReason=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("IPPilotPatAdmReason","","",AdmHospitalId)
 		if AdmType="I"{
	 		s BillTypeRowid=CFIPPilotPatAdmReason
	 	}
	 	else{
			s BillTypeRowid=CFPilotPatAdmReason
		}
		
	}
	s arExaReqNote=""
	s DurRowid=""
	s InstrRowid="" 
	s SeqNo=0
	f  {
		s CH=$o(^DHCAPREP(arReqID,"OT",CH)) Q:CH=""  D
		s itemval=$p(^DHCAPREP(arReqID,"OT",CH),"^",2)
		continue:itemval'["||"
		s ArcimDr=$P(^DHCAPOTHO(+itemval,"I",$P(itemval,"||",2)),"^",3)
		continue:+ArcimDr=0
		s Qty=$P(^DHCAPOTHO(+itemval,"I",$P(itemval,"||",2)),"^",4)
		if Qty="" s Qty=1
		s SeqNo=SeqNo+1
		s ItemCatDR=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",10)  /// 医嘱子类ID
		s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  
		if (OrderType="R"){
			s OrderPriorId=ONEPriorId
		}else{
			s OrderPriorId=NORMPriorId	
		}
		Set RecDepRowid=$$GetRecloc^DHCDocOrderCommonNew(Adm,ArcimDr)
		s ListData=ArcimDr_"^"_OrderType_"^"_OrderPriorId_"^"_Sttdate_"^"_Stttime_"^"_Qty_"^"_""_"^"_RecDepRowid_"^"_BillTypeRowid
		s ListData=ListData_"^"_DrgFormRowid_"^"_arExaReqNote_"^"_""_"^"_""_"^"_""_"^"_""_"^"_DurRowid_"^"_InstrRowid_"^"_""_"^"_""_"^"_SeqNo
		s ListData=ListData_"^"_""_"^"_""_"^"_$g(CoverMainIns)_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"
		;s $p(ListData,"^",58)="RPB"
		s $p(ListData,"^",46)=Sttdate
		s $p(ListData,"^",47)=Stttime
		s $p(ListData,"^",56)=PPRowId
		;if (mOrderItems=""){s mOrderItems=ListData}else{s mOrderItems=mOrderItems_$C(1)_ListData}
		s CareProvID=$p($g(^SSU("SSUSR",UserID)),"^",14)   /// 医生ID
		s ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(Adm, ListData, UserID, LocID, CareProvID, "", "^^^")
		i ret=100 {
			s rtn=0
			q 
		}
		s OeorderStr=""
		s ARRowID=arReqID_"||"_CH
		f k=1:1:$l(ret,"^") {
			s ArcimRowId=$p($p(ret,"^",k),"*",1)
			s newOrdIdDR=$p($p(ret,"^",k),"*",2)
			i ArcimRowId="" continue
			&SQL(update DHC_AppRepOthOpt set AR_OrdItem=:newOrdIdDR where AR_RowID=:ARRowID)
			
		}
	}
	q 0
}

}
