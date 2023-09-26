Import sqluser

/// Descript:项目组相关
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-07
Class web.DHCSTMHUI.LocItemGrp Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_LocItemGrp";

/// Descript:	保存/更新项目组信息
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-07
/// Table:DHC_LocItemGrp
/// Return：""：成功，非空：保存失败，请检查代码和描述是否重复
/// w ##class(web.DHCSTMHUI.LocItemGrp).Save("[{""Code"":""XMZ06"",""Desc"":""项目组6"",""Remark"":""备注"",""ActiveFlag"":""Y""}]")
ClassMethod Save(listData As %String, Main As %String) As %Library.String
{
	n (listData,Main,%session)
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(listData)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	s $ZT=..sssError()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s Desc=Obj.%Get("Desc")
		s Active=Obj.%Get("ActiveFlag")
		s Remark=Obj.%Get("Remark")
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",Code,..#AppTable,gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Code_" 代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Desc,..#AppTable,gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Desc_" 名称重复!","",0)
		continue:RtnObj.success<0
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Code,Desc,Active,Remark)
		e  d
		.s RtnObj=..Insert(Code,Desc,Active,Remark,gHospId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	增加项目组信息
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-07
/// Table:DHC_LocItemGrp
/// Input:代码,描述，激活状态，备注
/// Output:		
/// Return：rowid
/// w ##class(web.DHCSTMHUI.LocItemGrp).Insert("XMZ07","项目组7","N","备注1")
ClassMethod Insert(Code As %String, Desc As %String, Active As %String, Remark As %String, gHospId As %String = "") As RtnObj
{
	n (Code,Desc,Active,Remark,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	;不能为空项
	q:Code="" ""
	q:Desc="" ""
	&sql(Insert into DHC_LocItemGrp(LIG_Code,LIG_Desc,LIG_Flag,LIG_ReMark)
	values(:Code,:Desc,:Active,:Remark))
	i SQLCODE'=0  d
	.d RtnObj.Err(-3,..%GetParameter("AppName"),Code_","_Desc_","_Active_","_Remark,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg)) q
	q:RtnObj.success'=0 RtnObj
	s RtnObj.rowid=$p(%ROWID,$c(1))
	//保存医院关联
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP(..#AppTable,RtnObj.rowid,gHospId)
	i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	q:RtnObj.success<0 RtnObj
	s RtnObj=##class(Log).SaveLog("DHC_LocItemGrp","User.DHCLocItemGrp","项目组信息",$SYSTEM.SQL.GetROWID(),Desc,"A")
	q RtnObj
}

/// Descript:	更新项目组信息
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-07
/// Table:DHC_LocItemGrp
/// Input:代码,描述，激活状态，备注
/// Output:		
/// Return：0,成功,
ClassMethod Update(RowId As %String, Code As %String, Desc As %String, Active As %String, Remark As %String) As RtnObj [ Private ]
{
	n (RowId,Code,Desc,Active,Remark,%session)
	
	;不能为空项
	s RtnObj=##class(RtnObj).%New()
	q:Code="" ""
	q:Desc="" ""
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_LocItemGrp",RowId)
	&sql(Update DHC_LocItemGrp set LIG_Code=:Code,LIG_Desc=:Desc,LIG_Flag=:Active,LIG_ReMark=:Remark 
	where LIG_Rowid=:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-3,..%GetParameter("AppName"),Code_","_Desc_","_Active_","_Remark_","_RowId,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg)) q
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_LocItemGrp","User.DHCLocItemGrp","项目组信息",RowId,Desc,"U","",OldJsonStr)
	q RtnObj
}

/// 查询项目组信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocItemGrp","QueryItemGrp","{""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2""}")
Query QueryItemGrp(Params As %String) As Query(ROWSPEC = "RowId,Code,Desc,ActiveFlag,Remark") [ SqlProc ]
{
}

ClassMethod QueryItemGrpExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s Code=PJobj.%Get("Code")
	s Desc=PJobj.%Get("Desc")
	s Active=PJobj.%Get("ActiveStatus")
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s StrSql="select LIG_RowID,LIG_Code,LIG_Desc,LIG_Flag,LIG_ReMark"_
	" from DHC_LocItemGrp where (LIG_Desc like '%"_Desc_"%' OR LIG_Code like '%"_Desc_"%')"
	i Active'=""  d
	.s StrSql=StrSql_" and LIG_Flag = '"_Active_"'"
	s Result=##class(%Library.ResultSet).%New()
	s Result.RuntimeMode=0
	d Result.Prepare(StrSql)
	s Sc=Result.Execute()
	i $$$ISERR(Sc) q $$$OK
	while (Result.Next())
	{
		s RowId = Result.Data("LIG_RowID")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(..#AppTable,RowId,gHospId)
		continue:ShowDataFlag="N"
		s Code = Result.Data("LIG_Code")
		s Desc = Result.Data("LIG_Desc")
		s ActiveFlag = Result.Data("LIG_Flag")
		s Remark=Result.Data("LIG_ReMark")
		
		d OutPutRow
	}
	q $$$OK

OutPutRow
	s Data=$lb(RowId,Code,Desc,ActiveFlag,Remark)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
