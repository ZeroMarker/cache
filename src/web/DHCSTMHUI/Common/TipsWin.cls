Import sqluser

Class web.DHCSTMHUI.Common.TipsWin Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM, %XML.Adaptor) [ Not ProcedureBlock ]
{

Parameter AppName = "DHCSTTIPSWIN";

/// Descript:	获取提示窗口显示内容
/// Creator:	xuchao
/// CreateDate: 2014-11-17
/// Table:
/// Input:		安全组id,科室id,用户id
/// Output:d ##class(web.DHCSTMHUI.Common.TipsWin).GetTips(^tmpljl)
/// Return:		
ClassMethod GetTips(Params As %String) As %Library.String
{
	n (Params,%session)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s LocId=PJObj.%Get("gLocId")
	s GroupId=PJObj.%Get("gGroupId")
	s UserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	
	s Param=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	s AppName=..%GetParameter("AppName")
	s FilterStr="G,T,R,K,B,M,E,ST,Req,TComp,CONTRACK"
	s VendorQualification=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"VendorQualification",Param)
	s ManfQualification=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"ManfQualification",Param)
	s CertQualification=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"CertQualification",Param)
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,..sssCode(),LocId,"",HospId)
	w "{"
	//1.待办列表
	d ..GetTipsDetail(FilterStr,LocId,VendorQualification,ManfQualification,CertQualification,ScgStr)
	;ps再有新增参数控制,建议此处添加
	//2.供应商资质
	i VendorQualification="Y" d
	.d ..GetVenderTips(HospId)
	//3.生产厂家资质
	i ManfQualification="Y" d
	.d ..GetManfTips(HospId)
	//4.注册证
	i CertQualification="Y" d
	.d ..GetInciCertTips(LocId)
	.d ..GetInciContractTips(LocId)

	w "}"
}

/// w ##class(web.DHCSTMHUI.Common.TipsWin).GetTipsDetail("G,T,R,K,B,M,E,ST,Req,TComp,CONTRACK","163","Y","Y","Y")
ClassMethod GetTipsDetail(FilterStr As %String, LocId As %String, VendorQualification As %String, ManfQualification As %String, CertQualification As %String, ScgStr As %String) As %Library.String
{
	n (FilterStr,LocId,VendorQualification,ManfQualification,CertQualification,ScgStr,%session)
	s Title="App^NodeId^NodeCaption^NodeUrl^TabType^Count"
	w $c(34)_"doc"_$c(34)_":["
	s count=0
	s HospId=..sssHospId(LocId)
	s StkType=..sssCode()
	
	s reqcount=0,hvreqcount=0
	&sql( declare B cursor for 
		select a.%ID req, b.INRQ_SCG_DR ScgId from in_request a join dhc_inrequest b on a.INRQ_RowId=b.INRQ_INRQ_DR
		where inrq_reqloc_dr=:LocId 
		and inrq_usercompleted='Y' 
		and b.INRQ_AuditDate_Prov is not null 
		and isnull(inrq_template,'N')='N'
		and b.INRQ_StkType=:StkType
	) //and INRQ_Status='O'
	&sql(open B)
	f  &sql(fetch B into :req,:ScgId) q:SQLCODE  d
	.q:(##class(web.DHCSTMHUI.DHCINIsTrf).TransferStatus(req)'=0)
	.q:(ScgId'="")&&(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_ScgId_"^"))
	.s IsInclude=""
	.i (ScgId="")&&(ScgStr'="") d
	..s DetailScg=##class(web.DHCSTMHUI.INRequest).GetReqDetailScg(req)
	..s:DetailScg'="" IsInclude=##class(web.DHCSTMHUI.Common.UtilCommon).CheckInList(ScgStr,DetailScg,"^")
	.q:IsInclude=0				//明细过滤
	.s HVFlag=##class(web.DHCSTMHUI.Common.UtilCommon).GetCertDocHVFlag(req,"Req")
	.i HVFlag="Y" s hvreqcount=+hvreqcount+1
	.e  s reqcount=+reqcount+1
	&sql(close B)
	i reqcount>0 d
	.s NodeUrl="dhcstmhui.dhcinistrf.csp"
	.s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl) 
	.q:NodeInfo=""
	.s reqStr=""
	.s reqStr="有 "_reqcount_" 张请求单待出库!"
	.s TabType="SearchReq"
	.d isEmpty
	.s Data="ReqToOut"_"^"_NodeInfo_"^"_TabType_"^"_reqcount
	.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	i hvreqcount>0 d
	.s NodeUrl="dhcstmhui.dhcinistrfhv.csp"
	.s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl) 
	.q:NodeInfo=""
	.s reqStr=""
	.s reqStr="有 "_hvreqcount_" 张请求单(高值)待出库!"
	.s TabType="SearchReq"
	.d isEmpty 
	.s Data="ReqHvToOut"_"^"_NodeInfo_"^"_TabType
	.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	
	;请求单未完成
	s reqListcount=0,hvreqListcount=0
	&sql( declare tipReq cursor for 
		select a.%ID req, b.INRQ_SCG_DR ScgId from in_request a join dhc_inrequest b on a.INRQ_RowId=b.INRQ_INRQ_DR
		where inrq_recloc_dr=:LocId
		and INRQ_Status='O' and nvl(inrq_usercompleted,'')<>'Y' 
		and isnull(inrq_template,'N')='N'
		and b.INRQ_StkType=:StkType
	)
	&sql(open tipReq)
	f  &sql(fetch tipReq into :req,:ScgId) q:SQLCODE  d
	.q:(ScgId'="")&&(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_ScgId_"^"))
	.s IsInclude=""
	.i (ScgId="")&&(ScgStr'="") d
	..s DetailScg=##class(web.DHCSTMHUI.INRequest).GetReqDetailScg(req)
	..s:DetailScg'="" IsInclude=##class(web.DHCSTMHUI.Common.UtilCommon).CheckInList(ScgStr,DetailScg,"^")
	.q:IsInclude=0				//明细过滤
	.s HVFlag=##class(web.DHCSTMHUI.Common.UtilCommon).GetCertDocHVFlag(req,"Req")
	.i HVFlag="Y" s hvreqListcount=+hvreqListcount+1
	.e  s reqListcount=+reqListcount+1
	&sql(close tipReq)
	i reqListcount>0 d
	.s NodeUrl="dhcstmhui.inrequest.csp"
	.s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl) 
	.q:NodeInfo=""
	.s reqListStr=""
	.s reqListStr="有 "_reqListcount_" 张请求单待完成!"
	.s TabType="Search"
	.d isEmpty
	.s Data="ReqComp"_"^"_NodeInfo_"^"_TabType
	.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	i hvreqListcount>0 d
	.s NodeUrl="dhcstmhui.inrequesthv.csp"
	.s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl) 
	.q:NodeInfo=""
	.s reqListStr=""
	.s reqListStr="有 "_hvreqListcount_" 张请求单(高值)待完成!"
	.s TabType="Search"
	.d isEmpty
	.s Data="ReqHvComp"_"^"_NodeInfo_"^"_TabType
	.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	;入库单审核
	s reccount=0
	&sql(declare tipG cursor for
		select %id rowid, INGR_SCG_DR ScgId from DHC_INGdRec
		where INGR_Loc_Dr=:LocId
			and nvl(INGR_Completed,'')='Y' and nvl(INGR_AuditFlag,'')<>'Y'
	)
	&sql(open tipG)
	f  &sql(fetch tipG into :rowid,:ScgId) q:SQLCODE  d
	.;这里可以添加过滤条件
	.q:(ScgId'="")&&(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_ScgId_"^"))
	.s IsInclude=""
	.i (ScgId="")&&(ScgStr'="") d
	..s DetailScg=##class(web.DHCSTMHUI.DHCINGdRec).GetRecDetailScg(rowid)
	..s:DetailScg'="" IsInclude=##class(web.DHCSTMHUI.Common.UtilCommon).CheckInList(ScgStr,DetailScg,"^")
	.q:IsInclude=0				//明细过滤
	.s reccount=+reccount+1
	&sql(close tipG)
	i reccount'=0  d
	.s NodeUrl="dhcstmhui.ingdrecaudit.csp"
	.s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl) 
	.q:NodeInfo=""
	.s Str="有 "_reccount_" 张入库单待审核!"
	.s TabType="Search"
	.d isEmpty
	.s Data="RecAudit"_"^"_NodeInfo_"^"_TabType_"^"_reccount
	.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	;出库单未完成
	s trfcount=0,hvtrfcount=0
	&sql(declare tipTComp cursor for
		select %id rowid,INIT_SCG_DR ScgId from DHC_INIsTrf
		where INIT_FrLoc_DR=:LocId and INIT_State='10'
	)
	&sql(open tipTComp)
	f  &sql(fetch tipTComp into :rowid,:ScgId) q:SQLCODE  d
	.q:(ScgId'="")&&(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_ScgId_"^"))
	.s IsInclude=""
	.i (ScgId="")&&(ScgStr'="") d
	..s DetailScg=##class(web.DHCSTMHUI.DHCINIsTrf).GetInsTrfDetailScg(rowid)
	..s:DetailScg'="" IsInclude=##class(web.DHCSTMHUI.Common.UtilCommon).CheckInList(ScgStr,DetailScg,"^")
	.q:IsInclude=0
	.s HVFlag=##class(web.DHCSTMHUI.Common.UtilCommon).GetCertDocHVFlag(rowid,"T")
	.i HVFlag="Y" s hvtrfcount=+hvtrfcount+1
	.e  s trfcount=+trfcount+1
	&sql(close tipTComp)
	i trfcount>0 d
	.s NodeUrl="dhcstmhui.dhcinistrf.csp"
	.s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl)  
	.q:NodeInfo=""
	.s Str="有 "_trfcount_" 张出库单待完成!"
	.s TabType="Search"
	.d isEmpty
	.s Data="InitComp"_"^"_NodeInfo_"^"_TabType_"^"_trfcount
	.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	i hvtrfcount>0 d
	.s NodeUrl="dhcstmhui.dhcinistrfhv.csp"
	.s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl) 
	.q:NodeInfo=""
	.s Str="有 "_hvtrfcount_" 张出库单(高值)待完成!"
	.s TabType="Search"
	.d isEmpty 
	.s Data="InitHvComp"_"^"_NodeInfo_"^"_TabType_"^"_hvtrfcount
	.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	;出库单审核
	s trfcount=0
	&sql(declare tipT cursor for
		select %id rowid,INIT_SCG_DR ScgId from DHC_INIsTrf
		where INIT_FrLoc_DR=:LocId and INIT_State='11'
	)
	&sql(open tipT)
	f  &sql(fetch tipT into :rowid,:ScgId) q:SQLCODE  d
	.q:(ScgId'="")&&(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_ScgId_"^"))
	.s IsInclude=""
	.i (ScgId="")&&(ScgStr'="") d
	..s DetailScg=##class(web.DHCSTMHUI.DHCINIsTrf).GetInsTrfDetailScg(rowid)
	..s:DetailScg'="" IsInclude=##class(web.DHCSTMHUI.Common.UtilCommon).CheckInList(ScgStr,DetailScg,"^")
	.q:IsInclude=0
	.s trfcount=+trfcount+1
	&sql(close tipT)
	i trfcount'=0  d
	.s NodeUrl="dhcstmhui.dhcinistrfoutaudit.csp"
	.s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl) 
	.q:NodeInfo=""
	.s Str="有 "_trfcount_" 张出库单待审核!"
	.s TabType="Search"
	.d isEmpty
	.s Data="InitOutAudit"_"^"_NodeInfo_"^"_TabType_"^"_trfcount
	.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	;出库单接收
	s trfcount=0
	&sql(declare tipK cursor for
		select %id rowid,INIT_SCG_DR ScgId from DHC_INIsTrf
		where INIT_ToLoc_DR=:LocId and INIT_State='21'
	)
	&sql(open tipK)
	f  &sql(fetch tipK into :rowid,:ScgId) q:SQLCODE  d
	.q:(ScgId'="")&&(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_ScgId_"^"))
	.s IsInclude=""
	.i (ScgId="")&&(ScgStr'="") d
	..s DetailScg=##class(web.DHCSTMHUI.DHCINIsTrf).GetInsTrfDetailScg(rowid)
	..s:DetailScg'="" IsInclude=##class(web.DHCSTMHUI.Common.UtilCommon).CheckInList(ScgStr,DetailScg,"^")
	.q:IsInclude=0
	.s trfcount=+trfcount+1
	&sql(close tipK)
	i trfcount'=0  d
	.s NodeUrl="dhcstmhui.dhcinistrfinaudit.csp"
	.s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl) 
	.q:NodeInfo=""
	.s Str="有 "_trfcount_" 张出库单待接收!"
	.s TabType="Search"
	.d isEmpty
	.s Data="InitInAudit"_"^"_NodeInfo_"^"_TabType_"^"_trfcount
	.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	
	;退货单审核
	s retcount=0
	&sql(declare tipR cursor for
		select %id,INGRT_SCG_DR ScgId from DHC_INGDRET
		where INGRT_CTLOC_DR=:LocId
			and INGRT_Completed='Y' and nvl(INGRT_AuditFlag,'')<>'Y'
	)
	&sql(open tipR)
	f  &sql(fetch tipR into :rowid,:ScgId) q:SQLCODE  d
	.q:(ScgId'="")&&(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_ScgId_"^"))
	.s IsInclude=""
	.i (ScgId="")&&(ScgStr'="") d
	..s DetailScg=##class(web.DHCSTMHUI.DHCINGdRet).GetRetDetailScg(rowid)
	..s:DetailScg'="" IsInclude=##class(web.DHCSTMHUI.Common.UtilCommon).CheckInList(ScgStr,DetailScg,"^")
	.q:IsInclude=0
	.s retcount=+retcount+1
	&sql(close tipR)
	i retcount'=0  d
	.s NodeUrl="dhcstmhui.ingdretaudit.csp"
	.s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl)
	.q:NodeInfo=""
	.s Str="有 "_retcount_" 张退货单待审核!"
	.s TabType="Search"
	.d isEmpty
	.s Data="RetAudit"_"^"_NodeInfo_"^"_TabType_"^"_retcount
	.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	;新建库存项需关联医嘱项
	s incicount=$$GetNewInciNum(HospId,ScgStr)
	i incicount'=0  d
	.s NodeUrl="dhcstmhui.druginfo.csp"
	.s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl) 
	.q:NodeInfo=""
	.s Str="有 "_incicount_" 个新建库存项待关联医嘱项!"
	.s TabType="Search"
	.d isEmpty
	.s Data="ArcToUpdate"_"^"_NodeInfo_"^"_TabType
	.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)

	;过期批次
	s alarmDate=$p($SYSTEM.SQL.DATEADD("mm",3,+$h)," ")	;缺省使用三个月(第二个参数)
	i alarmDate["-" s alarmDate=$zdh(alarmDate,3)
	s ExistExpireFlag=$$IsExistExpire(alarmDate,LocId,ScgStr)
	i ExistExpireFlag="Y" d
	.s NodeUrl="dhcstmhui.locitmexpdate.csp"
	.s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl)
	.q:NodeInfo=""
	.s Str="有批次已过期或即将过期!"
	.s TabType="Search"
	.d isEmpty
	.s Data="InciExpired"_"^"_NodeInfo_"^"_TabType
	.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	;科室库存下限报警
	s LimitFlag=$$IsLimitFlag(LocId,ScgStr)
	i LimitFlag="Y" d
	.s NodeUrl="dhcstmhui.locitmstkqtywarn.csp"
	.s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl) 
	.q:NodeInfo=""
	.s Str="有物资库存低于下限!"
	.s TabType="Search"
	.d isEmpty
	.s Data="LowMinQty"_"^"_NodeInfo_"^"_TabType
	.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	
	;供应商合同过期
	s retcount=0
	&sql(declare tipCONTRACK cursor for
		select %id from DHC_Contrack
		where Cont_CTLOC_DR=:LocId
			and Cont_AuditFlag='Y' and nvl(Cont_StopFlag,'')<>'Y'
	)
	&sql(open tipCONTRACK)
	f  &sql(fetch tipCONTRACK into :rowid) q:SQLCODE  d
	.s Enddate=$p(^DHCSTMCONTRACK(rowid),"^",5)
	.q:Enddate=""
	.q:(Enddate>+$h)
	.s retcount=+retcount+1
	&sql(close tipCONTRACK)
	i retcount'=0 d
	.s NodeUrl="dhcstmhui.contrack.csp"
	.s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl)
	.q:NodeInfo=""
	.s Str="有 "_retcount_" 供应商合同过期!"
	.s TabType="Search"
	.d isEmpty
	.s Data="ConExpired"_"^"_NodeInfo_"^"_TabType
	.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)

	w "],"_$c(34)_"doccount"_$c(34)_":"_count
	q 
isEmpty
	i count'=0 w ","
	s count=count+1
 
GetNewInciNum(HospId,ScgStr)
	;获取新维护的库存项个数
	n (HospId,ScgStr)
	s InciNum=0
	s info="",Flag=""
	f  s info=$o(^DHCITMINFO(info),-1) q:(info="")||(Flag=1)  d
	.q:+info=0
	.s InciCreateDate=$p(^DHCITMINFO(info),"^",94)
	.q:InciCreateDate=""
	.;售价确认标记: 已经确认的,不再提示
	.s AckSpFlag=$p(^DHCITMINFO(info),"^",17)
	.q:AckSpFlag="Y"
	.s inci=$p(^DHCITMINFO(info),"^",1)
	.q:inci=""
	.s arcim=$p(^INCI(inci,1),"^",3)
	.q:arcim'=""
	.s incsc=$p(^INCI(inci,2),"^",2)
	.q:incsc=""
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s ScgId=$p(ScgInfo,"^",5)
	.q:(ScgId'="")&&(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_ScgId_"^"))
	.s IncscStkType=$p($g(^INC("SC",incsc)),"^",3)
	.q:IncscStkType'=..sssCode()
	.s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("INC_Itm",inci,HospId)
	.q:ShowDataFlag="N"
	.
	.s InciNum=InciNum+1
	
	q InciNum
	
IsExistExpire(alarmDate,LocId,ScgStr)
	n (alarmDate,LocId,ScgStr)
	q:LocId="" ""
	s StkType=..sssCode()
	
	s Ret=""
	s Inclb=""
	f  s Inclb=$o(^DHCINCLB(0,"A","Y",LocId,Inclb)) q:(Inclb="")||(Ret="Y")  d
	.s DHCInclb=$o(^DHCINCLB(0,"A","Y",LocId,Inclb,0))
	.q:DHCInclb=""
	.s Inci=$p(Inclb,"||",1),IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	.q:(Inci="")||(IL="")||(LB="")
	.q:'$d(^INCI(Inci,"IL",IL,"LB",LB))
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.q:Incsc=""
	.s IncscStkType=$p(^INC("SC",Incsc),"^",3)
	.q:IncscStkType'=StkType
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgId=$p(ScgInfo,"^",5)
	.q:(ScgId'="")&&(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_ScgId_"^"))
	.s Incib=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
	.s Qty=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",2)
	.s IB=$p(Incib,"||",2)
	.q:(IB="")||(+Qty'>0)
	.s ExpDate=$p(^INCI(Inci,"IB",IB),"^",2)
	.q:(ExpDate="")||(ExpDate>=alarmDate)
	.s Ret="Y"
	
	q Ret

IsLimitFlag(LocId,ScgStr)
	;获取是否有物资库存低于下限
	;Return: Y:有, 其他:无
	n (LocId,ScgStr)
	q:LocId="" ""
	s StkType=..sssCode()
	
	s Ret=""
	s Inci=0
	f  s Inci=$o(^INCI("IL_LOC",LocId,Inci)) q:(Inci="")||(Ret="Y")  d
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.q:Incsc=""
	.s IncscStkType=$p(^INC("SC",Incsc),"^",3)
	.q:IncscStkType'=StkType
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgId=$p(ScgInfo,"^",5)
	.q:(ScgId'="")&&(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_ScgId_"^"))
	.s IL=$o(^INCI("IL_LOC",LocId,Inci,0))
	.q:IL=""
	.s Incil=Inci_"||"_IL
	.s MinQty=$p(^INCI(Inci,"IL",IL),"^",4)
	.q:+MinQty'>0
	.s ILQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,LocId,+$h)
	.i ILQty<=MinQty s Ret="Y" q
	
	q Ret
}

/// d ##class(web.DHCSTMHUI.Common.TipsWin).GetVenderTips(2)
ClassMethod GetVenderTips(HospId = "") As %String
{
	n (HospId,%session)
	s Title="App^Type^IdStr^ExpiredCount^AboutCount^NodeId^NodeCaption^NodeUrl^TabType"
	w ","_$c(34)_"vexp"_$c(34)_":["
	s allcount=0
	s ExpiredCount=0	;已过期数量
	s AboutCount=0		;即将过期数量
	s RowIdStr=""		;供应商RowId,用","拼接(便与菜单跳转后用RowIdStr过滤)
	s Type=..sssCode()
	s TabType="Search"
	
	s STV=0
	f  s STV=$O(^DHCSTV(STV)) q:STV=""  d
	.s RetStr=""
	.s STVVendorDR=$p(^DHCSTV(STV),"^",28)
	.q:'$d(^APC("APCVM",STVVendorDR))
	.s VendorType=$p(^APC("APCVM",STVVendorDR),"^",9)
	.q:VendorType'=Type
	.s VenderCode=$p(^APC("APCVM",STVVendorDR),"^",2)
	.s VenderDesc=$p(^APC("APCVM",STVVendorDR),"^",3)
	.s Status=$p(^APC("APCVM",STVVendorDR),"^",18)
	.q:Status="S"
	.s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("APC_Vendor",STVVendorDR,HospId)
	.q:ShowDataFlag'="Y"
	.s WarnStr=..GetExpiredCertQty("Vendor",STVVendorDR,HospId)
	.s ExpCount=$p(WarnStr,"^",1)
	.s PreExpCount=$p(WarnStr,"^",2)
	.q:(ExpCount=0)&&(PreExpCount=0)
	.s:RowIdStr="" RowIdStr=STVVendorDR
	.i ##class(web.DHCSTMHUI.Common.UtilCommon).FindInList(RowIdStr,STVVendorDR,",")=0  s RowIdStr=RowIdStr_","_STVVendorDR
	.s ExpiredCount=ExpiredCount+ExpCount
	.s AboutCount=AboutCount+PreExpCount
	.s allcount=allcount+1
	s NodeUrl="dhcstmhui.apcvennew.csp"
	s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl) 
	s Data="供应商资质"_"^"_"Ven"_"^"_RowIdStr_"^"_ExpiredCount_"^"_AboutCount_"^"_NodeInfo_"^"_TabType_"^"_allcount
	w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	w "],"_$c(34)_"vexpcount"_$c(34)_":"_allcount
	q
}

/// d ##class(web.DHCSTMHUI.Common.TipsWin).GetManfTips(30)
ClassMethod GetManfTips(HospId = "") As %String
{
	n (HospId,%session)
	s Title="App^Type^IdStr^ExpiredCount^AboutCount^NodeId^NodeCaption^NodeUrl^TabType"
	w ","_$c(34)_"mexp"_$c(34)_":["
	s allcount=0
	s ExpiredCount=0	;已过期数量
	s AboutCount=0		;即将过期数量
	s RowIdStr=""		;生产厂家RowId,用","拼接(便与菜单跳转后用RowIdStr过滤)
	s nowdate=+$H
	s Type=..sssCode()
	s TabType="Search"
	
	s ManfAddId=0
	f  s ManfAddId=$O(^DHCMANF(ManfAddId)) q:ManfAddId=""  d
	.s count=0
	.s RetStr=""
	.s ManfId=$p(^DHCMANF(ManfAddId),"^",1)
	.q:'$d(^PHMNF(ManfId))
	.s Code=$p($g(^PHMNF(ManfId)),"^",1)
	.s Name=$p($g(^PHMNF(ManfId)),"^",2)
	.s STMType=$p(^DHCMANF(ManfAddId),"^",7)
	.q:STMType'=Type
	.s Active=$p(^DHCMANF(ManfAddId),"^",10)
	.q:Active="N"
	.s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("PH_Manufacturer",ManfId,HospId)
	.q:ShowDataFlag'="Y"
	.i $f(Name,"-") s Name=$p(Name,"-",2)
	.s WarnStr=..GetExpiredCertQty("Manf",ManfId,HospId)
	.s ExpCount=$p(WarnStr,"^",1)
	.s PreExpCount=$p(WarnStr,"^",2)
	.q:(ExpCount=0)&&(PreExpCount=0)
	.s:RowIdStr="" RowIdStr=ManfId
	.i ##class(web.DHCSTMHUI.Common.UtilCommon).FindInList(RowIdStr,ManfId,",")=0  s RowIdStr=RowIdStr_","_ManfId
	.s ExpiredCount=ExpiredCount+ExpCount
	.s AboutCount=AboutCount+PreExpCount
	.s allcount=allcount+1
	s NodeUrl="dhcstmhui.phmanfnew.csp"
	s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl)
	s Data="生产企业资质"_"^"_"Manf"_"^"_RowIdStr_"^"_ExpiredCount_"^"_AboutCount_"^"_NodeInfo_"^"_TabType_"^"_allcount
	w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	w "],"_$c(34)_"mexpcount"_$c(34)_":"_allcount
	q
}

/// d ##class(web.DHCSTMHUI.Common.TipsWin).GetInciCertTips(163)
/// 
/// Description:获取物资注册证即将过期的物资数据
/// Creator:	wangjiabin
/// CreateDate:	2017-11-13
/// Input:		科室id, 警示天数
/// Output:		
ClassMethod GetInciCertTips(LocId As %String) As %String
{
	n (LocId,%session)
	s HospId=..sssHospId(LocId)
	s Title="App^Type^IdStr^ExpiredCount^AboutCount^NodeId^NodeCaption^NodeUrl^TabType"
	w ","_$c(34)_"incicert"_$c(34)_":["
	s allcount=0
	s ExpiredCount=0	;已过期数量
	s AboutCount=0		;即将过期数量
	s RowIdStr=""		;库存项RowId,用","拼接(便与菜单跳转后用RowIdStr过滤)
	s nowdate=+$H
	s Type=..sssCode()
	s TabType="Search"
	
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.s RetStr=""
	.q:+Inci'>0
	.s IL=$o(^INCI("IL_LOC",LocId,Inci,0))
	.q:IL=""	;该科室没有库存的,过滤
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgType=$p(ScgInfo,"^",3)
	.q:ScgType'=..sssCode()
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s WarnStr=..CheckInciCert(Inci,"regCert",HospId)
	.s ExpiredFlag=$p(WarnStr,"^",1)
	.s WarnFlag=$p(WarnStr,"^",2)
	.q:(ExpiredFlag="")&&(WarnFlag="")
	.s:RowIdStr="" RowIdStr=Inci
	.i ##class(web.DHCSTMHUI.Common.UtilCommon).FindInList(RowIdStr,Inci,",")=0  s RowIdStr=RowIdStr_","_Inci
	.s:ExpiredFlag="Y" ExpiredCount=ExpiredCount+1
	.s:WarnFlag="Y" AboutCount=AboutCount+1
	.s allcount=allcount+1
	s NodeUrl="dhcstmhui.druginfo.csp"
	s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl)
	s Data="产品注册证"_"^"_"InciCert"_"^"_RowIdStr_"^"_ExpiredCount_"^"_AboutCount_"^"_NodeInfo_"^"_TabType_"^"_allcount
	w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	w "],"_$c(34)_"incicertcount"_$c(34)_":"_allcount
	q
}

/// d ##class(web.DHCSTMHUI.Common.TipsWin).GetInciCertTips(163)
/// 
/// Description:获取物资注册证即将过期的物资数据
/// Creator:	wangjiabin
/// CreateDate:	2017-11-13
/// Input:		科室id, 警示天数
/// Output:		
ClassMethod GetInciContractTips(LocId As %String) As %String
{
	n (LocId,%session)
	s HospId=..sssHospId(LocId)
	s Title="App^Type^IdStr^ExpiredCount^AboutCount^NodeId^NodeCaption^NodeUrl^TabType"
	w ","_$c(34)_"incicontract"_$c(34)_":["
	s allcount=0
	s ExpiredCount=0	;已过期数量
	s AboutCount=0		;即将过期数量
	s RowIdStr=""		;库存项RowId,用","拼接(便与菜单跳转后用RowIdStr过滤)
	s nowdate=+$H
	s Type=..sssCode()
	s TabType="Search"
	
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.s RetStr=""
	.q:+Inci'>0
	.s IL=$o(^INCI("IL_LOC",LocId,Inci,0))
	.q:IL=""	;该科室没有库存的,过滤
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgType=$p(ScgInfo,"^",3)
	.q:ScgType'=..sssCode()
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s WarnStr=..CheckInciCert(Inci,"contract",HospId)
	.s ExpiredFlag=$p(WarnStr,"^",1)
	.s WarnFlag=$p(WarnStr,"^",2)
	.q:(ExpiredFlag="")&&(WarnFlag="")
	.s:RowIdStr="" RowIdStr=Inci
	.i ##class(web.DHCSTMHUI.Common.UtilCommon).FindInList(RowIdStr,Inci,",")=0  s RowIdStr=RowIdStr_","_Inci
	.s:ExpiredFlag="Y" ExpiredCount=ExpiredCount+1
	.s:WarnFlag="Y" AboutCount=AboutCount+1
	.s allcount=allcount+1
	s NodeUrl="dhcstmhui.druginfo.csp"
	s NodeInfo=##class(web.DHCSTMHUI.Menu).GetMenuSecurityByUrl(NodeUrl)
	s Data="产品注册证"_"^"_"InciContract"_"^"_RowIdStr_"^"_ExpiredCount_"^"_AboutCount_"^"_NodeInfo_"^"_TabType_"^"_allcount
	w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	w "],"_$c(34)_"incicontractcount"_$c(34)_":"_allcount
	q
}

/// Descript:	获取过期或即将过期的供应商/生产厂家资质数量
/// CreateDate:	2023-04-25
/// Table:		DHC_CertDetail
/// Input:		机构类型(Vendor/Manf/等), 机构id, ControlType:控制类型(Warn/In/Out/Use)
/// Output:		
/// Return:		过期或即将过期的资质名称(逗号隔开)
ClassMethod GetExpiredCertQty(OrgType As %Integer, OrgId As %String, HospId As %String = "") As %String
{
	n (OrgType,OrgId,HospId)
	q:(OrgType="")||(OrgId="") ""
	s ExpiredCount=0	;已过期数量
	s AboutCount=0		;即将过期数量
	
	s CERTType=""
	f  s CERTType=$o(^User.DHCCertDetailI("OrgType",OrgType,OrgId,CERTType)) q:CERTType=""  d
	.s CertTypeId=""
	.f  s CertTypeId=$o(^User.DHCCertTypeI("TypeCode",OrgType,CERTType,CertTypeId)) q:CertTypeId=""  d
	..s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_CertType",CertTypeId,HospId)
	..q:ShowDataFlag'="Y"
	..s CertTypeInfo=$g(^User.DHCCertTypeD(CertTypeId))
	..s TypeFlag=$lg(CertTypeInfo,7)
	..s WarnDays=$lg(CertTypeInfo,8) 
	..q:TypeFlag'="Y"
	..s CERTRowid=""
	..f  s CERTRowid=$o(^User.DHCCertDetailI("OrgType",OrgType,OrgId,CERTType,CERTRowid)) q:CERTRowid=""  d
	...s CertDetail=^User.DHCCertDetailD(CERTRowid)
	...s DateTo=$lg(CertDetail,9)
	...s BlankedFlag=$l(CertDetail,10)				;长期标记
	...s ShowFlag=$lg(CertDetail,15)
	...q:ShowFlag'="Y"
	...q:(BlankedFlag="Y")||(DateTo="")
	...s AlarmDate=+$h+WarnDays
	...q:DateTo>AlarmDate
	...i DateTo<+$h d
	....s ExpiredCount=ExpiredCount+1
	...e  d
	....s AboutCount=AboutCount+1
	q ExpiredCount_"^"_AboutCount
}

/// 产品资质是否已过期
ClassMethod CheckInciCert(Inci As %String, CERTType As %String = "", HospId As %String = "") As %String
{
	n (Inci,CERTType,HospId)
	q:(Inci="")||(CERTType="") ""
	s ExpiredFlag="",WarnFlag=""
	s CertTypeId=""
	f  s CertTypeId=$o(^User.DHCCertTypeI("TypeCode","Inci",CERTType,CertTypeId)) q:CertTypeId=""  d
	.s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_CertType",CertTypeId,HospId)
	.q:ShowDataFlag'="Y"
	.s CertTypeInfo=$g(^User.DHCCertTypeD(CertTypeId))
	.s TypeFlag=$lg(CertTypeInfo,7)
	.s WarnDays=$lg(CertTypeInfo,8)
	.q:TypeFlag'="Y"
	.s AlarmDate=+$h+WarnDays
	.i CERTType="regCert" d
	..;注册证
	..s InfoId=$o(^DHCITMINFO(0,"INCI",Inci,""))
	..q:InfoId=""
	..s MatRegCertDR=$p($g(^DHCITMINFO(InfoId,1)),"^",18)
	..q:MatRegCertDR=""
	..s RegCertInfo=^DHCMRCT(MatRegCertDR)
	..s CerExpDate=$p(RegCertInfo,"^",20)
	..q:CerExpDate=""
	..i (CerExpDate<+$h) s ExpiredFlag="Y"
	..i (CerExpDate<=AlarmDate)&&(CerExpDate>=+$h) s WarnFlag="Y"
	.e  i CERTType="contract" d
	..;合同
	..s ContractId=$o(^DHCSTMITMCONTRACK(0,"INCI",Inci,0))
	..q:ContractId=""
	..s ContractInfo=^DHCSTMCONTRACK(ContractId)
	..s ContractNo=$p(ContractInfo,"^",1)
	..s ConStartDate=$p(ContractInfo,"^",4)
	..s ConEndDate=$p(ContractInfo,"^",5)
	..q:(ConEndDate="")
	..i (ConEndDate<+$h) s ExpiredFlag="Y"
	..i (ConEndDate<=AlarmDate)&&(ConEndDate>=+$h) s WarnFlag="Y"
	q ExpiredFlag_"^"_WarnFlag
}

}
