Import sqluser

/// Descript:退货原因维护
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
Class web.DHCSTMHUI.INCReasonForRet Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新退货原因
/// Creater:	lihui
/// CreateDate:	20180419
/// Table: INC_ReasonForReturn
/// Input: 数据Json串:rowid,代码,描述
/// Output:		
/// Return：RtnObj Json
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
		s TempCode=$$ALPHAUP^SSUTIL4(Code)
		s TmpId=""
		&sql(select RET_Rowid into :TmpId from INC_ReasonForReturn where RET_Code =:TempCode and RET_StkType="M")
		i (TmpId'="")&&(TmpId'=RowId) d RtnObj.Err(-3,"",Code_"代码重复!")
		continue:RtnObj.success'=0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Description,"INC_ReasonForReturn",gHospId,RowId)
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

/// Descript:	增加退货原因
/// Creater:	lihui
/// CreateDate:	20180419
/// Table: INC_ReasonForReturn
/// Input: 代码,描述
/// Output:		
/// Return：RtnObj
ClassMethod Insert(Code As %String, Description As %String, gHospId) As RtnObj [ Private ]
{
	n (Code,Description,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	s StkType=..sssCode()
	&sql(Insert into INC_ReasonForReturn(RET_Code,RET_Desc,RET_StkType)
	values(:Code,:Description,:StkType))
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RowId=%ROWID
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("INC_ReasonForReturn",RowId,gHospId)
	.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	.q:RtnObj.success'=0
	.s RtnObj=##class(Log).SaveLog("INC_ReasonForReturn","User.INCReasonForReturn","退货原因",$SYSTEM.SQL.GetROWID(),Description,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新退货原因
/// Creater:	lihui
/// CreateDate:	20180419
/// Table:		INC_ReasonForReturn
/// Input:		rowid^代码^描述
/// Return：	RtnObj
ClassMethod Update(RowId As %String, Code As %String, Description As %String) As RtnObj [ Private ]
{
	n (RowId,Code,Description,%session)
	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("INC_ReasonForReturn",RowId)
	&sql(Update INC_ReasonForReturn set RET_Code=:Code,RET_Desc=:Description 
	where RET_Rowid=:RowId)
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-22,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("INC_ReasonForReturn","User.INCReasonForReturn","退货原因",RowId,Description,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	删除退货原因
/// Creater:	lihui
/// CreateDate:	20180419
/// Table: INC_ReasonForReturn
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
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("INC_ReasonForReturn",RowId)
		&sql(Delete from INC_ReasonForReturn where RET_Rowid=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("INC_ReasonForReturn",RowId)
		.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
		.q:RtnObj.success'=0
		.s RtnObj=##class(Log).SaveLog("INC_ReasonForReturn","User.INCReasonForReturn","退货原因",RowId,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	查询退货原因信息
/// Creater:	lihui
/// CreateDate:	20180419
/// Table: INC_ReasonForReturn
/// Input:
/// Output:		
/// Return：退货原因信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INCReasonForRet","SelectAll","RowId","Desc")
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
	s SqlStr = "SELECT RET_Rowid as RowId,RET_Code as Code,RET_Desc as Description,RET_StkType as StkType"
		_" FROM INC_ReasonForReturn"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s Type=..sssCode()
		s StkType=Result.Data("StkType")
		continue:StkType'=Type
		s RowId = Result.Data("RowId")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("INC_ReasonForReturn",RowId,gHospId)
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
