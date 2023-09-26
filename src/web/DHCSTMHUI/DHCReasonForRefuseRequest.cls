Import sqluser

/// Descript:	请求单拒绝原因维护
/// Creater:	lxt
/// CreateDate:	2018-05-03
Class web.DHCSTMHUI.DHCReasonForRefuseRequest Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询原因信息
/// Creater:	lxt
/// CreateDate:	2018-05-03
/// Table:		DHC_ReasonForRefuseRequest
/// Input:		排序，查询条件
/// Return：	原因信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCReasonForRefuseRequest","SelectAll","","","")
Query SelectAll(Params As %String) As Query(ROWSPEC = "RowId,Code,Description") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	
	s type=..sssCode()
	s SqlStr="SELECT RF_RowId as RowId, RF_Code as Code, RF_Desc as Description"
	        _" from DHC_ReasonForRefuseRequest where RF_StkType='"_type_"'"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ReasonForRefuseRequest",RowId,gHospId)
		continue:ShowDataFlag="N"
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

/// Descript:	保存原因信息
/// Creater:	lxt
/// CreateDate:	2018-05-03
/// Table:		DHC_ReasonForRefuseRequest
/// Input:		数据Json串:rowid,代码,描述
/// Return：	RtnObj Json
ClassMethod Save(Params, Main As %String) As %Library.String
{
	n (Params,Main,%session)
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
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
		s TempId=$o(^INC("RFRQ",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
		i (TempId'="")&&(TempId'=RowId) d RtnObj.Err(-2,RowId,Code_" 代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Description,"DHC_ReasonForRefuseRequest",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Description_" 名称重复!","",0)
		continue:RtnObj.success<0
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Code,Description)
		e  d
		.s RtnObj=..Insert(Code,Description,gHospId)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	更新原因信息
/// Creater:	lxt
/// CreateDate:	2018-05-03
/// Table:		DHC_ReasonForRefuseRequest
/// Input:		rowid^代码^描述
/// Return：	RtnObj
ClassMethod Update(RowId As %String, Code As %String, Description As %String) As RtnObj [ Private ]
{
	n (RowId,Code,Description,%session)
	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_ReasonForRefuseRequest",RowId)
	&sql(Update DHC_ReasonForRefuseRequest set 
		RF_Code=:Code,RF_Desc=:Description
		where RF_RowId=:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-22,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_ReasonForRefuseRequest","User.DHCReasonForRefuseRequest","请求单拒绝原因",RowId,Description,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	增加原因信息
/// Creater:	lxt
/// CreateDate:	2018-05-03
/// Table:		DHC_ReasonForRefuseRequest
/// Input:		代码,描述	
/// Return：	RtnObj
ClassMethod Insert(Code As %String, Description As %String, gHospId) As RtnObj [ Private ]
{
	n (Code,Description,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	s type=..sssCode()
	&sql(Insert into DHC_ReasonForRefuseRequest
		(RF_Code,RF_Desc,RF_StkType)
		values
		(:Code,:Description,:type))
	i SQLCODE'=0  d
	.d RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_ReasonForRefuseRequest","User.DHCReasonForRefuseRequest","请求单拒绝原因",$SYSTEM.SQL.GetROWID(),Description,"A")
	.q:RtnObj.success'=0
	.//保存医院关联
	.s RowId=%ROWID
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_ReasonForRefuseRequest",RowId,gHospId)
	.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	删除原因信息
/// Creater:	lxt
/// CreateDate:	2018-05-03
/// Table:		DHC_ReasonForRefuseRequest
/// Input:		RowId	
/// Return：	RtnObj
ClassMethod Delete(Params) As %Library.String
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
		s RowId=Obj.%Get("RowId")
		i (RowId="") s Sc=RtnObj.Err(-2,"","没有需要删除信息!","",0)
		q:RtnObj.success'=0
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_ReasonForRefuseRequest",RowId)
		&sql(Delete from DHC_ReasonForRefuseRequest where RF_RowId=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-3,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("DHC_ReasonForRefuseRequest",RowId)
		.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
		.q:RtnObj.success'=0
		.s RtnObj=##class(Log).SaveLog("DHC_ReasonForRefuseRequest","User.DHCReasonForRefuseRequest","请求单拒绝原因",RowId,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

}
