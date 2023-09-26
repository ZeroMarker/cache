Import sqluser

/// Descript:药品调价原因维护
/// Creater:	LiMingzhong
/// CreateDate:	2012-6-7
Class web.DHCSTMHUI.DHCReasonForAdjustPrice Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新调价原因
/// Creater:	LiMingzhong
/// CreateDate:	2012-6-7
/// Table:DHC_ReasonForAdjustPrice
/// Input:数据串:rowid^代码^描述,rowid^代码^描述
/// Output:		
/// Return："" : 成功，非空：失败 w ##class(web.DHCSTMHUI.DHCReasonForAdjustPrice).Save(^tempxj)
ClassMethod Save(Params As %String, Main As %String) As %Library.String
{
	n (Params,Main,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Type=..sssCode()
	ts
	while(RtnObj.success=0){
		s objStr=PJObj.%Pop()
		q:objStr=""
		
		s RowId=objStr.%Get("RowId")
		s Code=objStr.%Get("Code")
		s Desc=objStr.%Get("Description")
		s Type=..sssCode()
		s TempCode=$$ALPHAUP^SSUTIL4(Code)
		s TmpId=""
		&sql(select REA_RowId into :TmpId from DHC_ReasonForAdjustPrice where REA_Code =:TempCode and REA_StkType="M")
		i (TmpId'="")&&(TmpId'=RowId) d RtnObj.Err(-3,"",Code_"代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Desc,"DHC_ReasonForAdjustPrice",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Desc_" 名称重复!","",0)
		continue:RtnObj.success<0
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Code,Desc)
		e  d
		.s RtnObj=..Insert(Code,Desc,gHospId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	增加调价原因
/// Creater:	LiMingzhong
/// CreateDate:	2012-6-7
/// Table:DHC_ReasonForAdjustPrice
/// Input:代码,描述
/// Output:		
/// Return：rowid
ClassMethod Insert(Code As %String, Desc As %String, gHospId) As RtnObj [ Private ]
{
	n (Code,Desc,gHospId,%session)
	;
	;不能为空项
	s RtnObj=##class(RtnObj).%New()
	i (Code="")||(Desc="") q RtnObj.Err(-1,"","必填项不可为空","",0)
	s StkType=..sssCode()
	&sql(Insert into DHC_ReasonForAdjustPrice(REA_Code,REA_Desc,REA_StkType) values(:Code,:Desc,:StkType))
	i SQLCODE'=0  d
	.s JsonStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(code_"^"_desc,"Code^Description")
	.d RtnObj.Err(-1,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg),JsonStr)
	q:RtnObj.success'=0 RtnObj
	s RowId=$p(%ROWID,$c(1))

	//保存医院关联
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_ReasonForAdjustPrice",RowId,gHospId)
	i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	q:RtnObj.success'=0 RtnObj
	s RtnObj=##class(Log).SaveLog("DHC_ReasonForAdjustPrice","User.DHCReasonForAdjustPrice","调价原因",$SYSTEM.SQL.GetROWID(),Desc,"A")
	q:RtnObj.success'=0 RtnObj
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:	更新调价原因
/// Creater:	LiMingzhong
/// CreateDate:	2012-6-7
/// Table:DHC_ReasonForAdjustPrice
/// Input:rowid^代码^描述
/// Output:		
/// Return：rowid
ClassMethod Update(RowId As %String, Code As %String, Desc As %String) As RtnObj [ Private ]
{
	n (RowId,Code,Desc,%session)
	s RtnObj=##class(RtnObj).%New()
	;不能为空项
	i (Code="")||(Desc="") q RtnObj.Err(-1,"","必填项不可为空","",0)
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_ReasonForAdjustPrice",RowId)
	&sql(Update DHC_ReasonForAdjustPrice set REA_Code=:Code,REA_Desc=:Desc where REA_Rowid=:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-1,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg),OldJsonStr)
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_ReasonForAdjustPrice","User.DHCReasonForAdjustPrice","调价原因",RowId,Desc,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	删除调价原因
/// Creater:	LiMingzhong
/// CreateDate:	2012-6-7
/// Table:DHC_ReasonForAdjustPrice
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
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_ReasonForAdjustPrice",RowId)
		&sql(Delete from DHC_ReasonForAdjustPrice where REA_RowId=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("DHC_ReasonForAdjustPrice",RowId)
		.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
		.q:RtnObj.success'=0
		.s RtnObj=##class(Log).SaveLog("DHC_ReasonForAdjustPrice","User.DHCReasonForAdjustPrice","调价原因",RowId,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	查询调价原因信息
/// Creater:	qiushengxin
/// CreateDate:	20180810
/// Table: DHC_ReasonForAdjustPrice		
/// Return：调价原因信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCReasonForAdjustPrice","SelectAll","RowId","Desc")
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
	s SqlStr = "Select REA_RowId as RowId, REA_Code as Code, REA_Desc as Description,REA_StkType as StkType from DHC_ReasonForAdjustPrice"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s StkType = Result.Data("StkType")
		continue:StkType'=..sssCode()
		s RowId = Result.Data("RowId")
		CONTINUE:+RowId=0
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ReasonForAdjustPrice",RowId,gHospId)
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
