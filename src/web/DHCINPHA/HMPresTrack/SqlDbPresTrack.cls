/// Description:处方追踪操作表结构相关
/// Creator:    hulihua
/// CreateDate: 2017-12-22
/// Table:      DHC_PhaPresTrack-处方追踪主表、DHC_PhaPresTrackItm-处方追踪子表、DHC_PhaPreState-处方状态表
Class web.DHCINPHA.HMPresTrack.SqlDbPresTrack Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:处理处方追踪相关表
/// Creator:	hulihua
/// CreateDate:	2017-12-22
/// Table:      DHC_PhaPresTrack、DHC_PhaPresTrackItm
/// Input:		SqlStr-医嘱ID^执行记录表ID^处方号^状态代码^执行科室ID^执行人ID^执行日期^执行时间，UpdateFlag-更新标志（用于是否更新子表记录的判断）
/// Output:		
/// Return：	0-成功，非0-失败 
/// w ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB("I17122300009^A1^136^1")
ClassMethod HandlePresTrackDB(SqlStr As %String, UpdateFlag As %String = "") As %String
{
	n (SqlStr, UpdateFlag)
	q:SqlStr="" -1
	s Oeori=$p(SqlStr,"^",1)
	s PreStatCode=$p(SqlStr,"^",4)
	q:PreStatCode="" -2
	s PreStatId=$o(^DHCPHAPSTATEi("STATECODE",$$ALPHAUP^SSUTIL4(PreStatCode),""),-1)
	q:PreStatId="" -3
	s ExecuteUserId=$p(SqlStr,"^",6)
	q:ExecuteUserId="" -4
	s PrescNo=$p(SqlStr,"^",3)
	s:(PrescNo="")&&(Oeori'="") PrescNo=$p(^OEORD(+Oeori,"I",$P(Oeori,"||",2),1),"^",14) 	
	q:PrescNo="" -5
	//过滤非草药处方
	s queId=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).PrescCYQueId(PrescNo)
	q:queId="" 0
	s phaptid=$o(^PHAPRESTRACKi("PRESCNO",PrescNo,""),-1)
	s $ZT="Error^DHCSTERROR"
	tstart
	i phaptid'=""  d
	.s ret=..UpdatePresTrack(phaptid,PreStatId)
	e  d
	.s MainData=PrescNo_"^"_PreStatId
	.s ret=..InsertPresTrack(MainData)
	.q:ret'>0
	.s phaptid=ret
	i ret'>0 trollback
	q:ret'>0 ret
	s Oeore=$p(SqlStr,"^",2)
	s ExeLocDr=$p(SqlStr,"^",5)
	s ExecuteDate=$p(SqlStr,"^",7)
	s ExecuteTime=$p(SqlStr,"^",8)
	s DetailData=Oeore_"^"_ExecuteUserId_"^"_PreStatId_"^"_ExeLocDr_"^"_ExecuteDate_"^"_ExecuteTime
	i UpdateFlag="1"  d
	.s phaptch=$o(^PHAPRESTRACKi("LocPreState",ExeLocDr,PreStatId,phaptid,""),-1)
	.i phaptch'=""  d
	..s phaPtiId=phaptid_"||"_phaptch
	..s ret=..UpdatePhaPresTrackItm(phaPtiId,DetailData)
	.e  d
	..s ret=..InsertPhaPresTrackItm(phaptid,DetailData)
	.
	e  d
	.s ret=..InsertPhaPresTrackItm(phaptid,DetailData)
	i ret'=0 trollback
	q:ret'=0 ret
	tcommit
	q 0
}

/// Description:插入处方追踪主表信息
/// Creator:	hulihua
/// CreateDate:	2017-12-22
/// Table:      DHC_PhaPresTrack
/// Input:		mainData-处方号^状态ID		
/// Output:		
/// Return：	大于0-成功，不大于0-失败 
/// w ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).InsertPresTrack("1||1")
ClassMethod InsertPresTrack(mainData As %String) As %String
{
	n (mainData)
	s PrescNo=$p(mainData,"^",1)
	s Ord=$o(^OEORD(0,"PrescNo",PrescNo,""),-1)
	q:Ord="" -1
	s Itm=$o(^OEORD(0,"PrescNo",PrescNo,Ord,""),-1)
	q:Itm="" -2
	s Oeori=Ord_"||"_Itm
	s MOeori=##class(web.DHCSTPIVA).GetMainOeori(Oeori)
	s PreTraStaDr=$p(mainData,"^",2)
	s AdmDr=$p(^OEORD(Ord),"^",1)
	s ret=0
	;初始化一个对象
	s obj=##class(User.DHCPhaPresTrack).%New()
	;对创建的对象的每一个属性进行赋值
	d obj.PHAPTAdmDRSetObjectId(AdmDr)
    d obj.PHAPTMOEORIDRSetObjectId(MOeori)
	d obj.PHAPTNPreStateDRSetObjectId(PreTraStaDr)
	s obj.PHAPTPrescNo=PrescNo
	;持久化对象
	s result=obj.%Save()
	d obj.%Close()
	i $$$ISERR(result) d
	.s obj=""
	.s ret=-3
    q:ret'=0 $SYSTEM.Status.GetErrorText(result)
    s MainId=obj.%Id()
    s obj=""
	q MainId
}

/// Description:更新处方追踪主表信息
/// Creator:	hulihua
/// CreateDate:	2017-12-22
/// Table:      DHC_PhaPresTrack
/// Input:		phaPtId-处方追踪主表ID，mainData-当前状态表ID		
/// Output:		
/// Return：	等于0-成功，非0-失败 
/// w ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).UpdatePresTrack("1","^^4^")
ClassMethod UpdatePresTrack(phaPtId As %String, PreStatId As %String) As %String
{
	n (phaPtId, PreStatId)
	s ret=0
	;初始化一个对象
	s obj=##class(User.DHCPhaPresTrack).%OpenId(phaPtId)
	d obj.PHAPTNPreStateDRSetObjectId(PreStatId)
	;持久化对象
	s result=obj.%Save()
	d obj.%Close()
	s obj=""
	i $$$ISERR(result) d
	.s ret=-1
    q:ret'=0 $SYSTEM.Status.GetErrorText(result)
	q phaPtId
}

/// Description:插入处方追踪子表相关信息
/// Creator:	hulihua
/// CreateDate:	2017-12-22
/// Table:      DHC_PhaPresTrackItm
/// Input:		phaPtId-处方追踪主表ID、detailData-执行记录表ID^处方执行状态ID^处方执行人ID^执行科室ID	
/// Output:		
/// Return：	大于0-成功，小于0-失败 
/// w ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).InsertPhaPresTrackItm("1||1")
ClassMethod InsertPhaPresTrackItm(phaPtId As %String, detailData As %String) As %String
{
	n (phaPtId, detailData)
	s Oeore=$p(detailData,"^",1)
	s ExecuteUserId=$p(detailData,"^",2)
	s PreTraStaDr=$p(detailData,"^",3)
	s ExeLocDr=$p(detailData,"^",4)
	s ExecuteDate=$p(detailData,"^",5)
	s:ExecuteDate="" ExecuteDate=+$h
	s ExecuteTime=$p(detailData,"^",6)
	s:ExecuteTime="" ExecuteTime=$p($h,",",2)
	s ret=0
	;保存对象
    s obj=##class(User.DHCPhaPresTrackItm).%New(phaPtId)
    d obj.PHAPTIPHAPTParRefSetObjectId(phaPtId)
    d obj.PHAPTIOEOREDRSetObjectId(Oeore)
    d obj.PHAPTIExecuteUserDrSetObjectId(ExecuteUserId)
    d obj.PHAPTIPreStateDRSetObjectId(PreTraStaDr)
    d obj.PHAPTIExeLocDRSetObjectId(ExeLocDr)
    s obj.PHAPTIExecuteDate=ExecuteDate
    s obj.PHAPTIExecuteTime=ExecuteTime
	;持久化对象
	s result=obj.%Save()
	d obj.%Close()
	s obj=""
	i $$$ISERR(result) d
	.s ret=-1
	q:ret'=0 $SYSTEM.Status.GetErrorText(result)
	q ret
}

/// Description:更新处方追踪子表相关信息
/// Creator:	hulihua
/// CreateDate:	2018-01-10
/// Table:      DHC_PhaPresTrackItm
/// Input:		phaPtId-处方追踪主表ID、detailData-执行记录表ID^处方执行状态ID^处方执行人ID^执行科室ID	
/// Output:		
/// Return：	大于0-成功，小于0-失败 
/// w ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).InsertPhaPresTrackItm("1||1")
ClassMethod UpdatePhaPresTrackItm(phaPtiId As %String, detailData As %String) As %String
{
	n (phaPtiId, detailData)
	s Oeore=$p(detailData,"^",1)
	s ExecuteUserId=$p(detailData,"^",2)
	s PreTraStaDr=$p(detailData,"^",3)
	s ExeLocDr=$p(detailData,"^",4)
	s ExecuteDate=$p(detailData,"^",5)
	s:ExecuteDate="" ExecuteDate=+$h
	s ExecuteTime=$p(detailData,"^",6)
	s:ExecuteTime="" ExecuteTime=$p($h,",",2)
	s ret=0
	;打开对象
	s obj=##class(User.DHCPhaPresTrackItm).%OpenId(phaPtiId)
    d obj.PHAPTIPHAPTParRefSetObjectId(+phaPtiId)
    d obj.PHAPTIOEOREDRSetObjectId(Oeore)
    d obj.PHAPTIExecuteUserDrSetObjectId(ExecuteUserId)
    d obj.PHAPTIPreStateDRSetObjectId(PreTraStaDr)
    d obj.PHAPTIExeLocDRSetObjectId(ExeLocDr)
    s obj.PHAPTIExecuteDate=ExecuteDate
    s obj.PHAPTIExecuteTime=ExecuteTime
	;持久化对象
	s result=obj.%Save()
	d obj.%Close()
	s obj=""
	i $$$ISERR(result) d
	.s ret=-1
	q:ret'=0 $SYSTEM.Status.GetErrorText(result)
	q ret
}

}
