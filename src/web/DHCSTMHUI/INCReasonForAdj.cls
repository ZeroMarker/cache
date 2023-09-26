Import sqluser

/// Descript:库存调整原因维护
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
Class web.DHCSTMHUI.INCReasonForAdj Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新调整原因
/// Creater:	liuhui
/// CreateDate:	2018-05-11
/// Table:INC_ReasonForAdjustment
/// Input:数据串:rowid^代码^描述,rowid^代码^描述
/// Output:	w ##class(web.DHCSTMHUI.INCReasonForAdj).Save("[{""Code"":""21"",""Description"":""报损1""}]")	
/// Return："" : 成功，非空：失败
ClassMethod Save(Params As %String, Main As %String) As %Library.String
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
		i (Code="")||(Description="") d RtnObj.Err(-2,"","必填项不能为空!","",0)
		q:RtnObj.success'=0
		s TempCode=$$ALPHAUP^SSUTIL4(Code)
		s TmpId=""
		&sql(select ADJ_RowId into :TmpId from INC_ReasonForAdjustment where ADJ_Code =:TempCode and ADJ_StkType="M")
		i (TmpId'="")&&(TmpId'=RowId) d RtnObj.Err(-3,"",Code_"代码重复!","",0)
		continue:RtnObj.success'=0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Description,"INC_ReasonForAdjustment",gHospId,RowId)
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

/// Descript:	增加调整原因
/// Creater:	liuhui
/// CreateDate:	2018-05-11
/// Table:INC_ReasonForAdjustment
/// Input:代码,描述
/// Output:	w #class(web.DHCSTMHUI.INCReasonForAdj).Insert(21,"报损1")
/// Return：rowid
ClassMethod Insert(code As %String, desc As %String, gHospId) As %Library.String [ Private ]
{
	n (code,desc,gHospId,%session)

	s RtnObj=##class(RtnObj).%New()
	s type=..sssCode()
	&sql(Insert into INC_ReasonForAdjustment(ADJ_Code,ADJ_Desc,ADJ_StkType)
	values(:code,:desc,:type))
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	//保存医院关联
	s RowId=%ROWID
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("INC_ReasonForAdjustment",RowId,gHospId)
	i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	q:RtnObj.success'=0 RtnObj
	s RtnObj=##class(Log).SaveLog("INC_ReasonForAdjustment","User.INCReasonForAdjustment","库存调整原因",RowId,desc,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新调整原因
/// Creater:	liuhui
/// CreateDate:	2018-05-11
/// Table:INC_ReasonForAdjustment
/// Input:rowid^代码^描述
/// Output:		
/// Return：rowid
ClassMethod Update(rowid As %String, code As %String, desc As %String) As %Library.String [ Private ]
{
	n (rowid,code,desc,%session)
	;
	;不能为空项
	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("INC_ReasonForAdjustment",rowid)
	&sql(Update INC_ReasonForAdjustment set ADJ_Code=:code,ADJ_Desc=:desc
	where ADJ_Rowid=:rowid)
	i SQLCODE'=0  d
	.d RtnObj.Err(-22,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("INC_ReasonForAdjustment","User.INCReasonForAdjustment","库存调整原因",rowid,desc,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	删除调整原因
/// Creater:	liuhui
/// CreateDate:	2018-0-11
/// Table:INC_ReasonForAdjustment
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
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
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("INC_ReasonForAdjustment",RowId)
		&sql(Delete from INC_ReasonForAdjustment where ADJ_Rowid=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("INC_ReasonForAdjustment",RowId)
		.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
		.q:RtnObj.success'=0
		.s RtnObj=##class(Log).SaveLog("INC_ReasonForAdjustment","User.INCReasonForAdjustment","调整原因",RowId,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	查询调整原因信息
/// Creater:	liuhui
/// CreateDate:	20180511
/// Table: INC_ReasonForAdjustment
/// Input:
/// Output:		
/// Return：调整原因信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INCReasonForAdj","SelectAll","RowId","Desc")
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
	s SqlStr = "SELECT ADJ_Rowid as rowid,ADJ_Code as Code,ADJ_Desc as Description,ADJ_StkType as StkType"
		_ " FROM INC_ReasonForAdjustment "
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s StkType = Result.Data("StkType")
		continue:StkType'=..sssCode()
		s RowId = Result.Data("rowid")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("INC_ReasonForAdjustment",RowId,gHospId)
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
