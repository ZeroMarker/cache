Import sqluser

/// Descript:报损原因维护
/// Creater:	LiangQiang
/// CreateDate:	2013-12-26
/// wangjiabin 2014-01-11 修改insert时处理stktype, 取值过滤等
Class web.DHCSTMHUI.INCReasonForScrap Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新报损原因
/// Creater:	LiangQiang
/// CreateDate:	2013-12-26
/// Table:DHC_IncReasonForStockScrap
/// Input:数据串:rowid^代码^描述,rowid^代码^描述
/// Output:		
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
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	s $ZT=..sssError()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s Desc=Obj.%Get("Description")
		s TmpId=""
		&sql(select REASON_ScrapRowID into :TmpId from DHC_IncReasonForStockScrap where REASON_ScrapCode =:Code and REASON_ScrapType="M")
		i (TmpId'="")&&(TmpId'=RowId) d RtnObj.Err(-3,"",Code_"代码重复!","",0)
		continue:RtnObj.success'=0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Desc,"DHC_IncReasonForStockScrap",gHospId,RowId)
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

/// Descript:	增加报损原因
/// Creater:	LiangQiang
/// CreateDate:	2013-12-26
/// Table:DHC_IncReasonForStockScrap
/// Input:代码,描述
/// Output:		
/// Return：rowid
ClassMethod Insert(code As %String, desc As %String, gHospId) As RtnObj [ Private ]
{
	n (code,desc,gHospId,%session)
	;
	;不能为空项
	s RtnObj=##class(RtnObj).%New()
	i (code="")||(desc="") q RtnObj.Err(-1,"","必填项不可为空","",0)
	s stktype=..sssCode()
	&sql(Insert into DHC_IncReasonForStockScrap(REASON_ScrapCode,REASON_ScrapDesc,REASON_ScrapType)
	values(:code,:desc,:stktype))
	i SQLCODE'=0  d
	.s JsonStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(code_"^"_desc,"Code^Description")
	.d RtnObj.Err(-1,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg),JsonStr)
	q:RtnObj.success'=0 RtnObj
	s RowId=$p(%ROWID,$c(1))

	//保存医院关联
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_IncReasonForStockScrap",RowId,gHospId)
	i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	q:RtnObj.success'=0 RtnObj
	s RtnObj=##class(Log).SaveLog("DHC_IncReasonForStockScrap","User.DHCIncReasonForStockScrap","库存报损原因",RowId,desc,"A")
	q:RtnObj.success'=0 RtnObj
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:	更新报损原因
/// Creater:	LiangQiang
/// CreateDate:	2013-12-26
/// Table:DHC_IncReasonForStockScrap
/// Input:rowid^代码^描述
/// Output:		
/// Return：rowid
ClassMethod Update(rowid As %String, code As %String, desc As %String) As RtnObj [ Private ]
{
	n (rowid,code,desc,%session)
	s RtnObj=##class(RtnObj).%New()
	;不能为空项
	i (code="")||(desc="") q RtnObj.Err(-1,"","必填项不可为空","",0)
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_IncReasonForStockScrap",rowid)
	&sql(Update DHC_IncReasonForStockScrap set REASON_ScrapCode=:code,REASON_ScrapDesc=:desc
	where REASON_ScrapRowID=:rowid)
	i SQLCODE'=0  d
	.d RtnObj.Err(-1,"","更新失败!")
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_IncReasonForStockScrap","User.DHCIncReasonForStockScrap","库存报损原因",rowid,desc,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	删除报损原因
/// Creater:	LiangQiang
/// CreateDate:	2013-12-26
/// Table:DHC_IncReasonForStockScrap
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
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_IncReasonForStockScrap",RowId)
		&sql(Delete from DHC_IncReasonForStockScrap where REASON_ScrapRowID=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("DHC_IncReasonForStockScrap",RowId)
		.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
		.q:RtnObj.success'=0
		.s RtnObj=##class(Log).SaveLog("DHC_IncReasonForStockScrap","User.DHCIncReasonForStockScrap","库存报损原因",RowId,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	查询报损原因信息
/// Creater:	qiushengxin
/// CreateDate:	20180805
/// Table: DHC_IncReasonForStockScrap
/// Input:
/// Output:		
/// Return：报损原因信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INCReasonForScrap","SelectAll","RowId","Desc")
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
	s SqlStr = "SELECT REASON_ScrapRowID as RowId,REASON_ScrapCode as Code,REASON_ScrapDesc as Description,REASON_ScrapType as StkType"
		_" FROM DHC_IncReasonForStockScrap"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s StkType = Result.Data("StkType")
		continue:StkType'=..sssCode()
		s RowId = Result.Data("RowId")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_IncReasonForStockScrap",RowId,gHospId)
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
