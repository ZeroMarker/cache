Import sqluser

/// Descript:科室管理组相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-23
Class web.DHCSTMHUI.LocManGrp Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新管理组
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-23
/// Table:DHC_LocManGrp
/// Input:科室id;管理组id^管理组代码^管理组名称,管理组id^管理组代码^管理组名称
/// Output:		
/// Return：0：成功，
/// -1:科室不能为空
ClassMethod Save(LocId As %String, Params) As %Library.String
{
	n (LocId,Params,%session)
	;s ^tmpqsx("web.DHCSTMHUI.LocManGrp")=LocId_","_Params
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
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
	s Desc=Obj.%Get("Desc")
	s ObjStr=Obj.%ToJSON()
	i RowId=""  d
	.s RtnObj=..Insert(LocId,ObjStr)
	e  d
	.s RtnObj=..Update(ObjStr)
	continue:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	增加管理组定义
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-23
/// Table:DHC_LocManGrp
/// Input:科室id,管理组代码,管理组描述
/// Output:		
/// Return：rowid
/// w ##class(web.DHCSTMHUI.LocManGrp).Insert(262,"1","1")
ClassMethod Insert(LocId As %String, Params As %String) As RtnObj [ Private ]
{
	n (LocId,Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","Insert:参数解析错误!")
	i (LocId="")||(Params="") d
	.s Sc=RtnObj.Err(-21,"","必填项不能为空!","",0)
	s Code=PJObj.%Get("Code")
	s Desc=PJObj.%Get("Desc")
	s RtnObj=..GetManGrpByDesc(LocId,Code,Desc)
	q:RtnObj.success'=0 RtnObj
	&sql(Insert into DHC_LocManGrp(LMG_CTLOC_DR,LMG_Code,LMG_Desc)
	values(:LocId,:Code,:Desc))
	i SQLCODE'=0  d
	.s Sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	s RtnObj=##class(Log).SaveLog("DHC_LocManGrp","User.DHCLocManGrp","科室管理组信息",$SYSTEM.SQL.GetROWID(),Desc,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新管理组定义
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-23
/// Table:DHC_LocManGrp
/// Input:rowid,管理组代码,管理组描述
/// Output:		
/// Return：0:成功
/// d ##class(web.DHCSTMHUI.LocManGrp).Update("{""RowId"":""12"",""Code"":""2"",""Desc"":""管理组1""}")
ClassMethod Update(Params As %String) As RtnObj [ Private ]
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s RowId=PJObj.%Get("RowId")
	s Code=PJObj.%Get("Code")
	s Desc=PJObj.%Get("Desc")
	s RtnObj=..GetManGrpByDesc(RowId,Code,Desc)
	q:RtnObj.success'=0 RtnObj
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_LocManGrp",RowId)
	&sql(Update DHC_LocManGrp set LMG_Code=:Code,LMG_Desc=:Desc where LMG_Rowid=:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-11,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_LocManGrp","User.DHCLocManGrp","科室管理组信息",RowId,Desc,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	删除管理组
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-23
/// Table:DHC_LocManGrp
/// Input:rowid
/// Output:		
/// Return：0,成功,
/// d ##class(web.DHCSTMHUI.LocManGrp).Delete()
ClassMethod Delete(Params As %String) As RtnObj
{
	n (Params,%session)
	;
	;不能为空项
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)

	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s Obj=PJObj.%Pop()
	s RowId=Obj.%Get("RowId")
	q:RowId="" RtnObj.Json()
	s $ZT=..sssError()
	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_LocManGrp",RowId)
	&sql(Delete from DHC_LocManGrp where LMG_ROWID=:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-11,"",$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.d ##class(Log).SaveLog("DHC_LocManGrp","User.DHCLocManGrp","科室管理组信息",RowId,"","D",JsonStr)
	q:RtnObj.success'=0 RtnObj.Json()
	q RtnObj.Json()
}

/// Descript:	查询某科室对应的管理组信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-23
/// Table:DHC_DefLoc
/// Input:主科室id
/// Output:		
/// Return：Rowid^代码^描述
/// 
Query QueryLocMar(LocId As %String) As Query(ROWSPEC = "RowId,Code,Desc") [ SqlProc ]
{
}

ClassMethod QueryLocMarExecute(ByRef qHandle As %Binary, LocId As %String) As %Status
{
	n (qHandle,LocId,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:LocId="" ""
	s count = 0
	s resultString = ""
	s StrSql="select LMG_ROWID as RowId,LMG_Code as Code,LMG_Desc as Description"
		_" from DHC_LocManGrp where LMG_CTLOC_DR='"_LocId_"'"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err q $$$OK
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s Code = result.Data("Code")
		s Desc = result.Data("Description")
		s Data=RowId_"^"_Code_"^"_Desc
		d OutPutMardesc
	}
	Quit $$$OK
	
OutPutMardesc
	s Data=$lb(RowId,Code,Desc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 验证该科室里是否有此管理组
/// Code - 管理组代码
/// Desc - 管理组名称
/// Author:xuejingchao
/// Date:2019-09-05
/// Return:
/// 管理组id -存在
/// 空-不存在
/// w ##class(web.DHCSTMHUI.LocManGrp).GetManGrpByDesc(7,1)
ClassMethod GetManGrpByDesc(RowId As %String, Code As %String, Desc As %String) As RtnObj
{
	n (RowId,Code,Desc)
	s RtnObj=##class(RtnObj).%New()
	i Code="" d RtnObj.Err(-101,"","请输入管理组代码!","",0)
	q:RtnObj.success'=0 RtnObj
	i Desc="" d RtnObj.Err(-101,"","请输入管理组描述!","",0)
	q:RtnObj.success'=0 RtnObj
	&sql(select LMG_Rowid into :rowid from DHC_LocManGrp  where LMG_Code = :Code and LMG_CTLOC_DR = :RowId)
	i (rowid'="")&&(rowid'=RowId) d RtnObj.Err(-102,"","管理组代码重复,请重新输入!","",0)
	q:RtnObj.success'=0 RtnObj
	&sql(select LMG_Rowid into :rowid from DHC_LocManGrp  where LMG_Desc =:Desc and LMG_CTLOC_DR = :RowId)
	i (rowid'="")&&(rowid'=RowId) d RtnObj.Err(-102,"","管理组描述重复,请重新输入!","",0)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

}
