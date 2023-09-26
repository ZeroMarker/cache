Import sqluser

/// Descript:订单取消原因维护
/// Creater:	qiushengxin
/// CreateDate:	2018-04-28
Class web.DHCSTMHUI.InPoReasonForCancel Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新订单取消原因
/// Creater:	qiushengxin
/// CreateDate:	2018-04-28
/// Table:		INC_POCanc_FullFillReason
/// Input:		数据串:rowid^代码^描述,rowid^代码^描述
/// Output:		
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
		continue:RtnObj.success'=0
		s TmpId=$o(^INC("CFR",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
		i (TmpId'="")&&(TmpId'=RowId) d RtnObj.Err(-3,RowId,Code_" 代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Description,"INC_POCanc_FullFillReason",gHospId,RowId)
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

/// Descript:	增加订单取消原因
/// Creater:	qiushengxin
/// CreateDate:	2018-04-28
/// Table: 		INC_POCanc_FullFillReason
/// Input: 		代码,描述
/// Output:		
/// Return：	RtnObj
/// d ##class(web.DHCSTMHUI.InPoReasonForCancel).Insert("2","生产厂家有误")
ClassMethod Insert(Code As %String, Description As %String, gHospId) As RtnObj [ Private ]
{
	n (Code,Description,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	s StkType=..sssCode()
	&sql(Insert into INC_POCanc_FullFillReason(CFR_Code,CFR_Desc,CFR_StkType)
	values(:Code,:Description,:StkType))
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.//保存医院关联
	.s RowId=%ROWID
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("INC_POCanc_FullFillReason",RowId,gHospId)
	.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	.q:RtnObj.success'=0
	.s RtnObj=##class(Log).SaveLog("INC_POCanc_FullFillReason","User.INCPOCancFullFillReason","订单取消原因",$SYSTEM.SQL.GetROWID(),Description,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新订单取消原因
/// Creater:	qiushengxin
/// CreateDate:	2018-04-28
/// Table:		INC_POCanc_FullFillReason
/// Input:		rowid^代码^描述
/// Return：	RtnObj
ClassMethod Update(RowId As %String, Code As %String, Description As %String) As RtnObj [ Private ]
{
	n (RowId,Code,Description,%session)
	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("INC_POCanc_FullFillReason",RowId)
	&sql(Update  INC_POCanc_FullFillReason set CFR_Code=:Code,CFR_Desc=:Description
	where  CFR_Rowid=:RowId)
	i SQLCODE'=0  d
	.s SC=RtnObj.Err(-22,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("INC_POCanc_FullFillReason","User.INCPOCancFullFillReason","订单取消原因",RowId,Description,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	删除订单取消原因
/// Creater:	qiushengxin
/// CreateDate:	2018-04-28
/// Table: 		INC_POCanc_FullFillReason
/// Input:		Rowid
/// Return：	消息Json串
ClassMethod Delete(Params As %String) As %Library.String
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
		q:RowId=""
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("INC_POCanc_FullFillReason",RowId)
		&sql(Delete from INC_POCanc_FullFillReason where CFR_Rowid=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("INC_POCanc_FullFillReason",RowId)
		.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
		.q:RtnObj.success'=0
		.s RtnObj=##class(Log).SaveLog("INC_POCanc_FullFillReason","User.INCPOCancFullFillReason","订单取消原因",RowId,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	查询订单取消原因信息
/// Creater:	qiushengxin
/// CreateDate:	2018-04-28
/// Table: 		INC_POCanc_FullFillReason
/// Input:
/// Output:		
/// Return：
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.InPoReasonForCancel","SelectAll","","")
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
	s Type=..sssCode()
	s SqlStr = "SELECT CFR_Rowid as RowId,CFR_Code as Code,CFR_Desc as Description,CFR_StkType as StkType"
		_" FROM INC_POCanc_FullFillReason where CFR_StkType='"_Type_"'"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("INC_POCanc_FullFillReason",RowId,gHospId)
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

}
