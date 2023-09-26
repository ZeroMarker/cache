Import SQLUser

/// Creator: 	bianshuai
/// CreateDate: 2016-04-25
/// Descript: 	检查申请报告
Class web.DHCAPPReport Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 保存检查申请记录
/// w ##Class(web.DHCAPPReport).save("")
ClassMethod save(ListData As %String) As %String
{
	n (ListData)

	s arreqidstr=""
	s Err = 0
	TS
	s Len = $L(ListData,$C(1))   		/// 检查分类数目
	f i=1:1:Len q:Err'=0  d
	.s sListData=$p(ListData,$C(1),i)
	.s arReqID = $p(sListData,"!!",1)  	 /// 检查分类项目ID
	.s mListData = $p(sListData,"!!",2)  /// 申请表主信息
	.s aListData = $p(sListData,"!!",3)  /// 医嘱项关联信息
	.s oListData = $p(sListData,"!!",4)  /// 其他项目数据
	.i arReqID = "" d
	..s arReqID=..Insert(mListData,aListData,oListData)
	.e  d
	..s arReqID=..Update(arReqID,mListData,aListData,oListData)
	.i arReqID<0 s Err=arReqID
	.q:arReqID<0 
	.s arreqidstr=$s(arreqidstr'="":arreqidstr_"^"_arReqID,1:arReqID)  ///申请表ID串
	.
	i Err'=0 tro
	q:Err'=0 Err

	TC
	Q arreqidstr
}

/// Descript: 插入检查申请记录
ClassMethod Insert(mListData As %String, aListData As %String, oListData As %String) As %String
{
	N (mListData, aListData, oListData)
	
	s Err=0
	TS
	/// 检查报告
	s arReqID=..InsAppRep(mListData)
	i arReqID<0 tro
	q:arReqID<0 arReqID
	
	/// 医嘱项目
	f i=1:1:$L(aListData,"&&") q:Err'=0  d
	.s arcListData=$p(aListData,"&&",i)
	.s Err=..InsArcItem(arReqID,arcListData)
	i Err'=0 tro
	q:Err'=0 "-11"

	/// 其他项目
	i oListData'="" d
	.s Err=..InsRepOthOpt(arReqID,oListData)
	i Err'=0 tro
	q:Err'=0 "-12"

	/// 患者现病史
	i $p(mListData,"^",8)'="" d
	.s Err = ..InsPreHis(mListData)
	i Err'=0 tro
	q:Err'=0 "-13"
	
	/// 患者体征
	i $p(mListData,"^",9)'="" d
	.s Err = ..InsPatSigns(mListData)
	i Err'=0 tro
	q:Err'=0 "-14"

	/// 插入医嘱
	s Err = ..InsOrderItems(arReqID,mListData)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	TC
	Q arReqID
}

/// Descript: 更新检查申请记录
ClassMethod Update(arReqID As %String, mListData As %String, aListData As %String, oListData As %String) As %String
{
	N (arReqID, mListData, aListData, oListData)
	s Err=0
	TS
	/// 检查报告
	s Err=..UpdAppRep(arReqID,mListData)
	i Err'=0 tro
	q:Err'=0 "-10"

	/// 删除相关子表
	s Err=..DelRepTable(arReqID)
	i Err'=0 tro
	q:Err'=0 Err

	/// 医嘱项目
	f i=1:1:$L(aListData,"&&") q:Err'=0  d
	.s arcListData=$p(aListData,"&&",i)
	.s Err=..InsArcItem(arReqID,arcListData)
	i Err'=0 tro
	q:Err'=0 "-11"

	/// 其他项目
	i oListData'="" d
	.s Err=..InsRepOthOpt(arReqID,oListData)
	i Err'=0 tro
	q:Err'=0 "-12"

	/// 患者现病史
	i $p(mListData,"^",8)'="" d
	.s Err = ..InsPreHis(mListData)
	i Err'=0 tro
	q:Err'=0 "-13"
	
	/// 患者体征
	i $p(mListData,"^",9)'="" d
	.s Err = ..InsPatSigns(mListData)
	i Err'=0 tro
	q:Err'=0 "-14"
	
	/// 插入医嘱
	s Err = ..InsOrderItems(arReqID,mListData)
	i Err'=0 tro
	q:Err'=0 "-15"
		
	TC
	Q arReqID
}

/// Descript: 保存检查医嘱项信息
ClassMethod InsArcItem(arReqID As %String, arListData As %String) As %String
{
	N (arReqID, arListData)
	
	/// 医嘱项,体位
	s arArcListData=..GetInsArcListData(arListData,"AC_PO")  /// 获取医嘱项,体位
	s arReqArcID=..InsRepArc(arReqID,arArcListData)
	q:arReqArcID<0 arReqArcID
	
	/// 部位
	s arPartListData=..GetInsArcListData(arListData,"PS")  /// 获取部位
	s Err=..InsRepPart(arReqArcID,arPartListData)
	q:Err'=0 "-12"
	
	/// 后处理
	s arDispListData=..GetInsArcListData(arListData,"DM")  /// 获取后处理方法
	s Err=..InsRepDisp(arReqArcID,arDispListData)
	q:Err'=0 "-13"
	
	q 0
}

/// Descript: 插入检查申请
ClassMethod InsAppRep(ListData As %String) As %String
{
	n (ListData)
	s arNo=..GetCurMaxNo("APP"_$zd(+$H,8),"3")   ///单号
	s arArcCatID=$p(ListData,"^",1)     ///医嘱子类
	s arAdmID=$p(ListData,"^",2)        ///Adm
	s arExecLocID=$p(ListData,"^",3)    ///执行科室
	s arEmgFlag=$p(ListData,"^",4)      ///是否加急标志
	s arPurpose=$p(ListData,"^",7)      ///检查目的
	s arCreateDocID=$p(ListData,"^",5)  ///申请医生
	s arCreateDate=+$H   				///申请日期
	s arCreateTime=$p($H,",",2)   		///申请时间
	
	&SQL(Insert Into DHC_AppReport(AR_No,AR_CreateDate,AR_CreateTime,AR_CreateDoc_Dr,AR_ExecLoc_Dr,AR_Adm_Dr,AR_Cat_Dr,AR_EmgFlag,AR_AppointDoc,AR_Purpose)
		values(:arNo,:arCreateDate,:arCreateTime,:arCreateDocID,:arExecLocID,:arAdmID,:arArcCatID,:arEmgFlag,:arAppointDocID,:arPurpose))
	i SQLCODE'=0  q SQLCODE
	q +%ROWID
}

/// Descript: 更新检查申请
ClassMethod UpdAppRep(arReqID As %String, ListData As %String) As %String
{
	n (arReqID, ListData)
	s arArcCatID=$p(ListData,"^",1)     ///医嘱子类
	s arAdmID=$p(ListData,"^",2)        ///Adm
	s arExecLocID=$p(ListData,"^",3)    ///执行科室
	s arEmgFlag=$p(ListData,"^",4)      ///是否加急标志
	s arPurpose=$p(ListData,"^",7)      ///检查目的
	
	&SQL(Update DHC_AppReport set AR_ExecLoc_Dr=:arExecLocID,AR_Adm_Dr=:arAdmID,AR_Cat_Dr=:arArcCatID,AR_EmgFlag=:arEmgFlag,AR_Purpose=:arPurpose 
		Where AR_Rowid=:arReqID)
	q SQLCODE
}

/// Descript: 删除报告
ClassMethod delAppRep(arReqID As %String) As %String
{
	n (arReqID)
	&SQL(delete DHC_AppReport Where AR_Rowid=:arReqID)
	q SQLCODE
}

/// Descript: 检查报告医嘱项记录表
ClassMethod InsRepArc(arParref As %String, ListData As %String) As %String
{
	n (arParref, ListData)
	s arItmmastID=$p(ListData,"^",1)     ///医嘱项ID
	s arPosiID=$p(ListData,"^",2)        ///体位
	s arChildSub=$o(^DHCAPREP(arParref,"AR",""),-1)+1

	&SQL(Insert Into DHC_AppRepArc(AR_ParRef_Dr,AR_ChildSub,AR_Arc_Dr,AR_Pos_Dr)
		values(:arParref,:arChildSub,:arItmmastID,:arPosiID))
	i SQLCODE'=0  q SQLCODE
	q $p(%ROWID,$C(1))
}

/// Descript: 检查报告医嘱项对应部位记录表
ClassMethod InsRepPart(arParref As %String, ListData As %String) As %String
{
	n (arParref, ListData)
	s Len = $L(ListData,"^")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s arPartID=$p(ListData,"^",i)     ///部位
	.s arChildSub=$o(^DHCAPREP(+arParref,"AR",$p(arParref,"||",2),"PA",""),-1)+1
	.
	.&SQL(Insert Into DHC_AppRepPart(AR_ParRef_Dr,AR_ChildSub,AR_Part_Dr)
		values(:arParref,:arChildSub,:arPartID))
	.i SQLCODE'=0 S quitflag="1"
	.
	q quitflag
}

/// Descript: 检查报告检查后处理表
ClassMethod InsRepDisp(arParref As %String, ListData As %String) As %String
{
	n (arParref, ListData)
	s Len = $L(ListData,"^")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s arDispID=$p(ListData,"^",i)     ///部位
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
	s Len = $L(ListData,"$")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s itmListData=$p(ListData,"$",i)      	 ///项目列表
	.s arOptNameID=$p(itmListData,"#",1)     ///项目ID
	.s:arOptNameID["_" arOptNameID=$p(arOptNameID,"_",2)
	.s arOptValID=$p(itmListData,"#",2)      ///项目值
	.q:(arOptValID="N")||(arOptValID="")
	.s arChildSub=$o(^DHCAPREP(arParref,"OT",""),-1)+1
	.
	.&SQL(Insert Into DHC_AppRepOthOpt(AR_ParRef_Dr,AR_ChildSub,AR_Opt_Dr,AR_OptVal)
		values(:arParref,:arChildSub,:arOptNameID,:arOptValID))
	.i SQLCODE'=0 S quitflag="1"
	.
	q quitflag
}

/// Descript: 保存现病史
ClassMethod InsPreHis(ListData As %String) As %String
{
	n (ListData)
	s Err=0
	s arAdmID=$p(ListData,"^",2)       ///就诊ID
	s arHisID=$o(^DHCAPPREH(0,"ADM",arAdmID,""))
	i arHisID = "" d
	.s Err = ..InsRepPreHis(ListData)
	e  d
	.s Err = ..UpdRepPreHis(arHisID, ListData)
	q Err
}

/// Descript: 患者现病史
ClassMethod InsRepPreHis(ListData As %String) As %String
{
	n (ListData)
	s arAdmID=$p(ListData,"^",2)     ///就诊ID
	s arHisDesc=$p(ListData,"^",8)     ///现病史
	
	&SQL(Insert Into DHC_AppPreHis(APH_Adm_Dr,APH_History)
		values(:arAdmID,:arHisDesc))
	q SQLCODE
}

/// Descript: 患者现病史
ClassMethod UpdRepPreHis(arHisID As %String, ListData As %String) As %String
{
	n (arHisID, ListData)
	s arHisDesc=$p(ListData,"^",8)     ///现病史
	
	&SQL(Update DHC_AppPreHis Set APH_History=:arHisDesc Where APH_Rowid =:arHisID)
	q SQLCODE
}

/// Descript: 保存体征
ClassMethod InsPatSigns(ListData As %String) As %String
{
	n (ListData)
	s Err=0
	s arAdmID=$p(ListData,"^",2)       ///就诊ID
	s arSigID=$o(^DHCAPPATSI(0,"ADM",arAdmID,""))
	i arSigID = "" d
	.s Err = ..InsRepPatSigns(ListData)
	e  d
	.s Err = ..UpdRepPatSigns(arSigID, ListData)
	q Err
}

/// Descript: 插入患者体征
ClassMethod InsRepPatSigns(ListData As %String) As %String
{
	n (ListData)
	s arAdmID=$p(ListData,"^",2)     ///就诊ID
	s arSigID=$p(ListData,"^",9)     ///体征
		
	&SQL(Insert Into DHC_AppPatSigns(APS_Adm_Dr,APS_Signs)
		values(:arAdmID,:arSigID))
	q SQLCODE
}

/// Descript: 更新患者体征
ClassMethod UpdRepPatSigns(arSigID As %String, ListData As %String) As %String
{
	n (arSigID, ListData)
	s arSigDesc=$p(ListData,"^",9)     ///体征
	
	&SQL(Update DHC_AppPatSigns Set APS_Signs=:arSigDesc Where APS_Rowid =:arSigID)
	q SQLCODE
}

/// Descript:  准备插入数据
ClassMethod GetInsArcListData(arListData As %String, arType As %String) As %String
{
	n (arListData, arType)
	q:arListData="" ""
	s retListData=""
	s Len = $L(arListData,"^")
	f i=1:1:Len d
	.s ItemLabel = $p(arListData,"^",i)
	.s LabelRowId = $p(ItemLabel,"_",2)
	.i arType [ $p(ItemLabel,"_",1) d
	..s retListData = $s(retListData'="":retListData_"^"_LabelRowId,1:LabelRowId)
	Q retListData
}

/// Descript: 删除申请
ClassMethod DelRepTable(arParref As %String) As %String
{
	n (arParref)
	s SQLCODE=0
	///检查报告医嘱项记录表
	i $d(^DHCAPREP(arParref,"AR",1)) D
	.&SQL(delete from DHC_AppRepArc where AR_ParRef_Dr=:arParref)
	Q:SQLCODE'=0 SQLCODE
	///检查报告其它项目表
	i $d(^DHCAPREP(arParref,"OT",1)) D
	.&SQL(delete from DHC_AppRepOthOpt where AR_ParRef_Dr=:arParref)
	Q:SQLCODE'=0 SQLCODE
	Q 0
}

/// Descript:   取当前不良反应报告最大码
ClassMethod GetCurMaxNo(Prefix As %String, NoLen As %String) As %String
{
	N (Prefix,NoLen)
	S NextNo=""
	L +^DHCPHCMAPP("DHCPHCMADR",Prefix):10 E  Q -100
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
	.L -^DHCPHCMAPP("DHCPHCMADR",Prefix)
	Q:NextNo'="" NextNo

	S Suffix=CurrNo+1
	
	S slen=$L(Suffix)
	S flen=NoLen-slen
	F i=1:1:flen S Suffix="0"_Suffix
	S NextNo=Prefix_Suffix
	L -^DHCPHCMAPP("DHCPHCMADR",Prefix)
	Q NextNo
}

/// Descript:获取当前最大码
/// 科室当前处方最编码
ClassMethod GetMaxCodeByCode(Prefix As %String) As %String
{
	N (Prefix)
	Q:Prefix="" ""
	S adrrcode=""
	&sql(select max(AR_No) into :adrrcode from DHC_AppReport Where AR_No %STARTSWITH %ALPHAUP :Prefix)
	Q adrrcode
}

/// Descript:	生成检查医嘱
ClassMethod InsOrderItems(arReqID As %String, mListData As %String) As %String
{
	n (arReqID,mListData)
	
	/// 根据配置判断是否插入医嘱
	Q 0

	/// 插入医嘱
	s Err = ..InsOeori(arReqID,mListData)
	q:Err'=0 "-15"
		
	/// 插入收费项
	s Err =##Class(web.DHCAPPRepTarItm).InsertRepTarItm(arReqID)
	q:Err'=0 "-16"
	
	q Err
}

/// Descript:	插入医嘱
/// W ##Class(web.DHCAPPReport).InsOeori("24","10515||1^234","16","234")
ClassMethod InsOeori(arReqID As %String, mListData As %String) As %String
{
	n (arReqID,mListData)
	s arEpisodeID=$p(mListData,"^",2)        /// EpisodeID
	s arExecLocID=$p(mListData,"^",3)    	 /// 执行科室
	s arUserID=$p(mListData,"^",5)  		 /// 申请医生
	s arLocID=$p(mListData,"^",6)  		 	 /// 申请科室
	
	s Err=0
	s CH=""
	F  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:(CH="")||(Err'=0)  D
	.s itmmast=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)  /// 医嘱项ID
	.s arReqArcID=arReqID_"||"_CH
	.s itmmaststr = itmmast_"^"_arExecLocID
	.s ret=##Class(web.DHCAPPReport).SaveOrderItems(arEpisodeID,itmmaststr,arUserID,arLocID) /// 插入医嘱
	.i ret=100 s Err=-1
	.q:ret=100
	.s oeori=$p(ret,"*",2)  /// 医嘱ID
	.&SQL(update DHC_AppRepArc set AR_OrdItem=:oeori where AR_RowID=:arReqArcID)
	.
	.i SQLCODE'=0 s Err=-2
	q:Err'=0 Err
	q 0
}

/// Descript:	插入医嘱
/// W ##Class(web.DHCAPPReport).InsOeori("24","10515||1^234","16","234")
ClassMethod SaveOrderItems(EpisodeID As %String, itmmaststr As %String, UserID As %String, LocID As %String) As %String
{
	n (EpisodeID, itmmaststr, UserID, LocID)

	s CareProvID=$p($g(^SSU("SSUSR",UserID)),"^",14)   /// 医生ID
	s OrderPriorId=$O(^OECPR(0,"Code","NORM",0))       /// 优先级
	s SeqNo=1
	s OrderStartDate=$zd(+$h,4)						   /// 医嘱日期
	s OrderStartTime=$zt($p($h,",",2),2)			   /// 医嘱时间
	s BillTypeRowid=$P(^PAADM(EpisodeID,1),"^",7)      /// 费别指针
	s PackQty = 1									   /// 医嘱数量
	s DoseQtySum=PackQty							   /// 基本单位总数量
	
	s ListData="",OrdItemStr=""
	s Len=$L(itmmaststr,$C(1))
	F i=1:1:Len d
	.s itmmastidstr=$p(itmmaststr,$C(1),i)
	.s itmmastid=$p(itmmastidstr,"^",i)
	.s recLocID=$p(itmmastidstr,"^",i)		  	   /// 接收科室
	.s ItemCatDR=$p(^ARCIM(+itmmastid,$p(itmmastid,"||",2),1),"^",10)  /// 医嘱子类ID
	.s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  	   /// 医嘱子类类型
	.s FreqRowid="",InstrRowid="",DurRowid=""
	.s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(itmmastid)
	.i DrgFormRowid'="" d
	..s PHCDRowid=$P(DrgFormRowid,"||",1)
	..s ChildSub=$P(DrgFormRowid,"||",2)
	..s FreqRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",4)  /// 频次
	..s InstrRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",5) /// 用法
	..s DurRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",8)   /// 疗程
	.
	.s ListData=itmmastid_"^"_OrderType_"^"_OrderPriorId_"^"_OrderStartDate_"^"_OrderStartTime_"^"_PackQty_"^"_""_"^"_recLocID_"^"_BillTypeRowid
	.s ListData=ListData_"^"_DrgFormRowid_"^"_""_"^"_""_"^"_""_"^"_DoseQtySum_"^"_FreqRowid_"^"_DurRowid_"^"_InstrRowid_"^"_""_"^"_""_"^"_SeqNo
	.s ListData=ListData_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	.
	.i OrdItemStr = ""  s OrdItemStr = ListData
	.E  s OrdItemStr = OrdItemStr_$C(1)_ListData
	
	q:ListData="" "100"

	s ret=##Class(web.DHCOEOrdItem).SaveOrderItems(EpisodeID, OrdItemStr, UserID, LocID, CareProvID, "")
	q ret
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

Storage Default
{
<Data name="DHCAPPReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCAPPReportD</DataLocation>
<DefaultData>DHCAPPReportDefaultData</DefaultData>
<IdLocation>^web.DHCAPPReportD</IdLocation>
<IndexLocation>^web.DHCAPPReportI</IndexLocation>
<StreamLocation>^web.DHCAPPReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
