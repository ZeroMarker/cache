Import sqluser

/// Descript: PDA菜单管理
/// Creater:	lihui
/// CreateDate:	20210708
Class web.DHCSTMHUI.PDAMenu Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	安全组
/// Creater:	lihui
/// CreateDate:	20210708
/// Table: ss_group
/// Input: 
/// Output:		
/// Return：安全组id,代码,名称
/// w ##class(web.DHCSTMHUI.PDAMenu).GetGroup("0","30","")
Query GetGroup(Params As %String) As websys.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetGroupExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 $$$OK
	s desc=PJObj.%Get("GroupDescription")
	s StrSql="SELECT SSGRP_RowId AS RowId, SSGRP_Desc AS Description FROM SS_Group"
	s json = ##class(Code.JsonObj).%New()
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(result.Next())
	{
		s RowId = result.Data("RowId")
	    s Description = result.Data("Description")
	    continue:(desc'="")&&(Description'[desc)
		d OutPutGroup
	}
	Quit $$$OK
OutPutGroup
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存/更新菜单
/// Creater:	lihui
/// CreateDate:	20210831
/// Table: PDA_MenuConfig
/// Input: 安全组id
/// Output:		
/// Return：0：成功，非0：保存失败
/// w ##class(web.DHCSTMHUI.PDAMenu).Save("1","[{""Desc"":""验收"",""Code"":""RecAcceptMenu"",""Active"":""Y""}]")
ClassMethod Save(GroupId As %String, Params As %String) As %Library.String
{
	n (GroupId,Params,%session)
	s ^litmp("web.DHCSTMHUI.PDAMenu")=$lb(GroupId,Params)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Rowid=Obj.%Get("Rowid")
		s Code=Obj.%Get("Code")
		q:Code=""
		s UseFlag="Y"
		s Active=Obj.%Get("Active")
		i Rowid'="" d
		.s RtnObj=..Update(GroupId,Rowid,Code,Active)
		e  d
		.s RtnObj=..Insert(GroupId,Code,Active)
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// 更新方法
/// Creater:	lihui
/// CreateDate:	20210831
/// Table: PDA_MenuConfig
/// Input: 安全组id PDA_MenuConfig的ID 代码 激活标志
/// w ##class(web.DHCSTMHUI.PDAMenu).Update()
ClassMethod Update(GroupId As %String, Rowid As %String, Code As %String, Active As %String) As RtnObj [ Private ]
{
	n (GroupId,Rowid,Code,Active,%session)
	s RtnObj=##class(RtnObj).%New()
 	i ((GroupId="")||(Rowid="")||(Code="")) d
 	.s Sc=RtnObj.Err(-2,"","必填项不能为空!","",0)
 	q:RtnObj.success'=0 RtnObj
 	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("PDA_MenuConfig",Rowid)
 	&sql(select PDAMC_RowId into :rowid from PDA_MenuConfig  where PDAMC_Group_Dr = :GroupId and PDAMC_Code = :Code)
	i (SQLCODE=0)&&(rowid'=Rowid) d RtnObj.Err(-102,"","信息重复,请重新输入!","",0)
	q:RtnObj.success'=0 RtnObj
	s Desc=..GetDescbycode(Code)
	q:Desc="" RtnObj.Err(-2,"","菜单名称不存在!","",0)
	&sql(Update PDA_MenuConfig set PDAMC_Code=:Code,PDAMC_Desc=:Desc,PDAMC_ActiveFlag=:Active where PDAMC_RowId=:Rowid)
 	i SQLCODE'=0  d
 	.d RtnObj.Err(-2,"","更新表失败 SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
 	.s RtnObj=##class(Log).SaveLog("PDA_MenuConfig","User.PDAMenuConfig","PDA菜单维护",Rowid,Code,"U","",OldJsonStr)
    q:RtnObj.success'=0 RtnObj
 	q RtnObj
}

/// Descript:	增加PDA菜单
/// Creater:	lihui
/// CreateDate:	20210831
/// Table: PDA_MenuConfig
/// Input: 安全组id 代码 激活标志
/// Output:		
/// Return：w ##class(web.DHCSTMHUI.PDAMenu).Insert()
ClassMethod Insert(GroupId As %String, Code As %String, Active As %String) As RtnObj [ Private ]
{
	n (GroupId,Code,Active)
	s RtnObj=##class(RtnObj).%New()
 	i ((GroupId="")||(Code="")) d
 	.s Sc=RtnObj.Err(-1,"","必填项不能为空!","",0)
 	q:RtnObj.success'=0 RtnObj
 	
 	&sql(select PDAMC_RowId into :rowid from PDA_MenuConfig  where PDAMC_Group_Dr = :GroupId and PDAMC_Code = :Code)
	i (SQLCODE=0) d RtnObj.Err(-102,"","信息重复,请重新输入!","",0)
	q:RtnObj.success'=0 RtnObj
	s Desc=..GetDescbycode(Code)
	q:Desc="" RtnObj.Err(-1,"","菜单名称不存在!","",0)
	
 	&sql(Insert into PDA_MenuConfig(PDAMC_Group_Dr,PDAMC_Code,PDAMC_Desc,PDAMC_ActiveFlag)
 	values(:GroupId,:Code,:Desc,:Active))
 	i SQLCODE'=0  d
 	.d RtnObj.Err(-1,"","新增失败:SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
 	.s RtnObj=##class(Log).SaveLog("PDA_MenuConfig","User.PDAMenuConfig","PDA菜单维护",$SYSTEM.SQL.GetROWID(),Code,"A")
 	q:RtnObj.success'=0 RtnObj
 	q RtnObj
}

/// Descript:	删除支配科室定义
/// Creater:	lihui
/// CreateDate:	20210831
/// Table: PDA_MenuConfig
/// Input: rowid
/// Output:		
/// Return：0,成功,
/// w ##class(web.DHCSTMHUI.PDAMenu).Delete(^tmplh(555))
ClassMethod Delete(Params As %String) As RtnObj
{
	n (Params,%session)
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
		s Rowid=Obj.%Get("Rowid")
		q:Rowid=""
		s Code=Obj.%Get("Code")
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("PDA_MenuConfig",Rowid)
		&sql(Delete from PDA_MenuConfig where PDAMC_RowId=:Rowid)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("PDA_MenuConfig","User.PDAMenuConfig","PDA菜单维护",Rowid,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	查询某安全组对应的菜单
/// Creater:	lihui
/// CreateDate:	20210831
/// Table: PDA_MenuConfig
/// Input: 安全组id
/// Output:		
/// Return：Rowid^支配科室id^支配科室代码^支配科室描述
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.PDAMenu","Query",128)
Query Query(GroupId As %String) As websys.Query(ROWSPEC = "Rowid,Code,Desc,Active,XSCode") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, GroupId As %String) As %Status
{
	n (qHandle,GroupId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:GroupId="" ""
	s Rowid=""
	f  s Rowid=$o(^User.PDAMenuConfigI("IndexPDAMCGroupDr",GroupId,Rowid)) q:Rowid=""  d
	.s menuinfo=^User.PDAMenuConfigD(Rowid)
	.s Code=$lg(menuinfo,3)
	.s XSCode=Code
	.s Desc=$lg(menuinfo,4)
	.s Active=$lg(menuinfo,5)
	.s Data=Rowid_"^"_Code_"^"_Desc_"^"_Active_"^"_XSCode
	.d OutPutPDAMenu
	
	Quit $$$OK
OutPutPDAMenu
	s Data=$lb(Rowid,Code,Desc,Active,XSCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod GetDescbycode(Code As %String) As %String
{
	n (Code)
	q:Code="" ""
	s desc=""
	i Code="INRequestMenu" s desc="申请"
	i Code="INReqByCodeMenu" s desc="扫码申请"
	i Code="RecAcceptMenu" s desc="验收"
	i Code="INGdRecMenu" s desc="入库"
	i Code="INIsTrfMenu" s desc="出库"
	i Code="INGdRecSCIMenu" s desc="SCI入库"
	i Code="INStkTkMenu" s desc="盘点"
	i Code="StockQueryMenu" s desc="查询库存"
	q desc
}

}
