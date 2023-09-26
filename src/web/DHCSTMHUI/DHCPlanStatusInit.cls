Import sqluser

/// Descript:科室采购审核级别维护
/// Creater:	zhangxiao
/// CreateDate:2014-03-18
Class web.DHCSTMHUI.DHCPlanStatusInit Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存科室采购级别
/// Creater:	zx
/// CreateDate:	2018-07-26
/// Table:		DHC_PlanStatusInit
/// Input:		 
/// Return：	消息Json串
ClassMethod Save(LocId, Params) As %Library.String
{
	n (LocId,Params,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s ret=0
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s PsiRowId=Obj.%Get("PsiRowId")
		s PlanStatusId=Obj.%Get("PlanStatusId")
		s GroupId=Obj.%Get("GroupId")
		s ret=..LocRepeat(PsiRowId,LocId,PlanStatusId)
		i ret<0 s Sc=RtnObj.Err(-2,"","该科室的审核级别重复！","",0)
		q:RtnObj.success'=0 
		s ret=..GroupRepeat(LocId,GroupId)
		i ret<0 s Sc=RtnObj.Err(-2,"","该科室中已经为该安全组分配了权限！","",0)
		q:RtnObj.success'=0
		
		i PsiRowId="" d
		.s RtnObj=..Insert(LocId,GroupId,PlanStatusId)
		e  d
		.s RtnObj=..Update(PsiRowId,GroupId,PlanStatusId)
		
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	增加科室采购级别
/// Creater:	zx
/// CreateDate:	2018-07-26
/// Table:		DHC_PlanStatusInit
/// Input:		
/// Output:		
/// Return：	RtnObj
ClassMethod Insert(LocId As %String, GroupId As %String, PlanStatusId As %Integer) As RtnObj
{
	n (LocId,GroupId,PlanStatusId,%session)
	s RtnObj=##class(RtnObj).%New()
	i (LocId="")||(GroupId="")||(PlanStatusId="") d
	.s Sc=RtnObj.Err(-21,"","必填项不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s LocDesc=$p(^CTLOC(LocId),"^",2)
	&sql(Insert into DHC_PlanStatusInit
		(DHCPSI_SSGRP_DR,DHCPSI_DHCPS_DR,DHCPSI_CTLOC_DR)
		values
		(:GroupId,:PlanStatusId,:LocId))
	i SQLCODE'=0  d
	.s Sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_PlanStatusInit","User.DHCPlanStatusInit","科室采购级别",$SYSTEM.SQL.GetROWID(),LocDesc,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新科室采购级别
/// Creater:	zx
/// CreateDate:	2018-07-26
/// Table:		DHC_PlanStatusInit
/// Input:		
/// Output:
/// Return：	RtnObj
ClassMethod Update(RowId As %String, GroupId As %Integer, PlanStatusId As %String) As RtnObj
{
	n (RowId,GroupId,PlanStatusId,%session)
	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_PlanStatusInit",RowId)
	s PlanStatusDesc=""
	s:PlanStatusId'="" PlanStatusDesc=$p(^DHCPS(PlanStatusId),"^",2)
	&sql(Update DHC_PlanStatusInit set 
		DHCPSI_SSGRP_DR=:GroupId,DHCPSI_DHCPS_DR=:PlanStatusId
		where DHCPSI_RowId=:RowId)
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-1,RowId,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_PlanStatusInit","User.DHCPlanStatusInit","科室采购级别",RowId,PlanStatusDesc,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:   判断审核级别下科室是否重复
/// Creater:    taosongrui
/// CreateDate: 2014-03-21
/// Table: DHC_PlanStatusInit
/// Input: 科室id,审核级别id
/// Output:     
/// Return：不重复返回0,重复返回-1,错误返回空
/// w ##class(web.DHCSTMHUI.DHCPlanStatusInit).LocRepeat("","153","1")
ClassMethod LocRepeat(RowId As %String, Loc As %String, Status As %String) As %Library.String
{
	n (RowId,Loc,Status)
	q:Loc="" ""
	q:Status="" ""
	s rett=0
	s StrSql="select DHCPSI_RowId, DHCPSI_CTLOC_DR from DHC_PlanStatusInit where DHCPSI_DHCPS_DR='"_Status_"'"
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q ""
	While(result.Next())
	{	
		s PSIRowid = result.Data("DHCPSI_RowId")
		s SupplyPhaLoc = result.Data("DHCPSI_CTLOC_DR")
		s:(PSIRowid'=RowId)&(SupplyPhaLoc=Loc) rett=-3
	}
	d result.Close()
	q rett
}

/// Descript:   判断科室是否存在相同的安全组
/// Creater:    taosongrui
/// CreateDate: 2014-03-21
/// Table: DHC_PlanStatusInit
/// Input: 科室id,安全组id
/// Output:     
/// Return：不重复返回0,重复返回-4,错误返回空
/// w ##class(web.DHCSTMHUI.DHCPlanStatusInit).GroupRepeat("153","1")
ClassMethod GroupRepeat(Loc As %String, SSGroup As %String) As %Library.String
{
	n (Loc,SSGroup)
	q:Loc="" ""
	q:SSGroup="" ""
	s rett=0
	s StrSql="select DHCPSI_RowId, DHCPSI_SSGRP_DR from DHC_PlanStatusInit where DHCPSI_CTLOC_DR ='"_Loc_"'"
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q ""
	While(result.Next())
	{	
		s PSIRowid = result.Data("DHCPSI_RowId")
		s PSIGroup = result.Data("DHCPSI_SSGRP_DR")
		s:(PSIGroup=SSGroup) rett=-4
	}
	d result.Close()
	q rett
}

/// Descript:	删除科室采购审核级别
/// Creater:	zx
/// CreateDate:	2018-07-26
/// Table:		DHC_PlanStatusInit
/// Input:		
/// Return：	消息Json串
/// w ##class(web.DHCSTMHUI.DHCPlanStatusInit).GroupRepeat("153","1")
ClassMethod Delete(Params As %String) As %Library.String
{
	n (Params,%session)
	;s ^zx(7)=Params
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("PsiRowId")
		q:RowId=""
		s PlanStatusId=Obj.%Get("PlanStatusId")
		s PlanStatusDesc=""
		s:PlanStatusId'="" PlanStatusDesc=$p(^DHCPS(PlanStatusId),"^",2)
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_PlanStatusInit",RowId)
		&sql(Delete from DHC_PlanStatusInit where DHCPSI_RowId=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("DHC_PlanStatusInit","User.DHCPlanStatusInit","科室采购审核级别",RowId,PlanStatusDesc,"D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	查询科室采购级别信息
/// Creater:	张枭
/// CreateDate:	2018-07-26
/// Table:		DHC_PlanStatusInit
/// Input:		
/// Return：	采购级别信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPlanStatusInit","QueryPlanStatus",392)
Query QueryPlanStatus(LocId As %String) As Query(ROWSPEC = "PsiRowId,GroupId,GroupDesc,PlanStatusId,PlanStatusDesc") [ SqlProc ]
{
}

ClassMethod QueryPlanStatusExecute(ByRef qHandle As %Binary, LocId As %String) As %Status
{
	n (qHandle,LocId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr= "select DHCPSI_RowId ,DHCPSI_SSGRP_DR ,DHCPSI_DHCPS_DR ,DHCPSI_CTLOC_DR"
		_" from DHC_PlanStatusInit where DHCPSI_CTLOC_DR='"_LocId_"'"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s PsiRowId = Result.Data("DHCPSI_RowId")
		s GroupId = Result.Data("DHCPSI_SSGRP_DR")
		s GroupDesc=""
		s:GroupId'="" GroupDesc=$p(^SSU("SSGRP",GroupId),"^",1)
		s PlanStatusId=Result.Data("DHCPSI_DHCPS_DR")
		s PlanStatusDesc=""
		s:PlanStatusId'="" PlanStatusDesc=$p(^DHCPS(PlanStatusId),"^",2)
		d OutPutRowPlanStatus
	}
	Quit $$$OK
OutPutRowPlanStatus
	s Data=$lb(PsiRowId,GroupId,GroupDesc,PlanStatusId,PlanStatusDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询安全组可见科室信息
/// Creater:	张枭
/// CreateDate:	2018-07-26
/// Table:		SS_GroupStockLocations
/// Input:		
/// Return：	科室信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPlanStatusInit","QueryGroupLoc","RowId","Desc","{""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""264"",""gHospId"":""2""}","")
Query QueryGroupLoc(Params As %String, GroupId As %String) As Query(ROWSPEC = "RowId,Code,Description") [ SqlProc ]
{
}

ClassMethod QueryGroupLocExecute(ByRef qHandle As %Binary, Params As %String, GroupId As %String) As %Status
{
	n (qHandle,Params,GroupId,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s pLocDescription=PJobj.%Get("LocDescription")
	s pLocDescription=$$ALPHAUP^SSUTIL4(pLocDescription)
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	i GroupId'="" d
	.s SqlStr= "SELECT ST_CTLOC_DR AS RowId,ST_CTLOC_DR->CTLOC_Code AS Code,ST_CTLOC_DR->CTLOC_DESC AS CtDesc FROM SS_GroupStockLocations"_" WHERE ST_ParRef='"_GroupId_"'"
	.i pLocDescription'="" d
	..s SqlStr=SqlStr_" and( %ALPHAUP(ST_CTLOC_DR->CTLOC_Desc) like '%"_pLocDescription_"%'"
	..s SqlStr=SqlStr_" or %ALPHAUP(ST_CTLOC_DR->CTLOC_Code) like '%"_pLocDescription_"%'"
	..s SqlStr=SqlStr_" or %ALPHAUP(ST_CTLOC_DR->CTLOC_ContactName) like '%"_pLocDescription_"%')"
	i GroupId="" d
	.s SqlStr="select CTLOC_RowId as RowId,CTLOC_Code as Code,CTLOC_Desc CtDesc from CT_Loc where 1=1"
	.i pLocDescription'="" d
	..s SqlStr=SqlStr_" and( %ALPHAUP(CTLOC_Desc) like '%"_pLocDescription_"%'"
	..s SqlStr=SqlStr_" or %ALPHAUP(CTLOC_Code) like '%"_pLocDescription_"%'"
	..s SqlStr=SqlStr_" or %ALPHAUP(CTLOC_ContactName) like '%"_pLocDescription_"%')"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("RowId")
		s ret=##class(web.DHCSTMHUI.CTLOC).LocOfHosp(RowId, gHospId)
		continue:(ret'=0)
		s Code = Result.Data("Code")
		s Description = Result.Data("CtDesc")
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Code,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
