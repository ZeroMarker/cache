Import sqluser

/// Descript:	实盘窗口相关
/// Creater:	tsr
/// CreateDate: 2018-04-20
Class web.DHCSTMHUI.InStkTkWindow Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新实盘窗口信息
/// Creater:	tsr
/// CreateDate: 2018-04-20
/// Table:		DHC_InStkTkWindow
/// Input:		科室Id,数据Json串:rowid,代码,描述
/// Return: 	RtnObj Json
ClassMethod Save(LocId As %String, Params As %String) As %Library.String
{
	n (LocId,Params,%session)
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
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s Description=Obj.%Get("Description")
		i (Code="")||(Description="") s Sc=RtnObj.Err(-2,"","必填项不能为空!","",0)
		q:RtnObj.success'=0
		s TmpId=..CheckCode($$ALPHAUP^SSUTIL4(Code),LocId)
		i (TmpId'="")&&(TmpId'=RowId) s Sc=RtnObj.Err(-3,"",Description_"代码重复!","",0)
		q:RtnObj.success'=0
		s TmpId=..CheckDesc($$ALPHAUP^SSUTIL4(Description),LocId)
		i (TmpId'="")&&(TmpId'=RowId) s Sc=RtnObj.Err(-4,"",Description_"名称重复!","",0)
		q:RtnObj.success'=0
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Code,Description,LocId)
		e  d
		.s RtnObj=..Insert(Code,Description,LocId)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	增加实盘窗口信息
/// Creater:	tsr
/// CreateDate: 2018-04-27
/// Table:		DHC_InStkTkWindow
/// Input:		代码,描述,科室Id
/// Return:		RtnObj
ClassMethod Insert(Code As %String, Description As %String, LocId As %String) As RtnObj [ Private ]
{
	n (Code,Description,LocId,%session)
	s RtnObj=##class(RtnObj).%New()
	&sql(Insert into DHC_InStkTkWindow
		(STTKW_CTLOC_DR,STTKW_Code,STTKW_Desc)
		values
		(:LocId,:Code,:Description))
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_InStkTkWindow","User.DHCInStkTkWindow","实盘窗口信息",$SYSTEM.SQL.GetROWID(),Description,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新实盘窗口信息
/// Creater:	tsr
/// CreateDate: 2018-04-27
/// Table:		DHC_InStkTkWindow
/// Input:		RowId,代码,描述,科室Id
/// Return:		RtnObj
ClassMethod Update(RowId As %String, Code As %String, Description As %String, LocId As %String) As RtnObj [ Private ]
{
	n (RowId,Code,Description,LocId,%session)
	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_InStkTkWindow",RowId)
	&sql(Update DHC_InStkTkWindow set
		STTKW_Code=:Code,STTKW_Desc=:Description
		where STTKW_RowID=:RowId)
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-22,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_InStkTkWindow","User.DHCInStkTkWindow","实盘窗口信息",RowId,Description,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	验证是否有此实盘窗口代码
/// Creater:	tsr
/// CreateDate: 2018-04-23
/// Table:		DHC_InStkTkWindow
/// Input:		代码,科室Id
ClassMethod CheckCode(Code As %String, LocId As %String) As %Library.String
{
	n (Code,LocId)
	s RowId=""
	&sql(select STTKW_RowID into :RowId from DHC_InStkTkWindow where STTKW_CTLOC_DR=:LocId and STTKW_Code=:Code)
	q RowId
}

/// Descript:	验证是否有此实盘窗口名称
/// Creater:	tsr
/// CreateDate: 2018-04-23
/// Table:		DHC_InStkTkWindow
/// Input:		名称,科室Id
ClassMethod CheckDesc(Description As %String, LocId As %String) As %Library.String
{
	n (Description,LocId)
	s RowId=""
	&sql(select STTKW_RowID into :RowId from DHC_InStkTkWindow where STTKW_CTLOC_DR=:LocId and STTKW_Desc=:Description)
	q RowId
}

/// Descript:	查询实盘窗口信息
/// Creater:	tsr
/// CreateDate:	2018-04-26
/// Table:		DHC_InStkTkWindow
/// Input:		{gUserId:Text,gLocId:Text,gGroupId:Text,gHospId:Text}
/// Return：	实盘窗口信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.InStkTkWindow","SelectAll","{""LocId"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2""}")
Query SelectAll(Params As %String) As Query(ROWSPEC = "RowId,Code,Description") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s PLocId=PJobj.%Get("LocId")
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT STTKW_RowID AS RowId, STTKW_Code AS Code, STTKW_Desc AS Description"
		_" FROM DHC_InStkTkWindow WHERE STTKW_CTLOC_DR="_PLocId
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Code = Result.Data("Code")
		s Description = Result.Data("Description")
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
