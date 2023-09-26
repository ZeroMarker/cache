Import sqluser

/// Descript: 物资待审属性配置信息
/// Creater:	lihui
/// CreateDate:	20190306
Class web.DHCSTMHUI.InciParamRecord Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// creator: lihui
/// date: 20190304
/// description: 查询多级审核维护信息
/// Table: DHC_MatAuditLevel
/// input:  
/// output:
/// others:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.InciParamRecord","Query",^tmpli("Query"))
Query Query(Params As %String) As Query(ROWSPEC = "RowId,INCIPDesc,INCIPParamName,AuditFlag") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	;s ^tmpli("Query")=Params
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId")
	s HospId=PJobj.%Get("Hospital")
	s PDesc=PJobj.%Get("FDesc")
	s PAuditFlag=PJobj.%Get("FAuditFlag")
	s HospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(HospId,gHospId)
	s sqlStr = "SELECT INCIP_RowId As RowId,INCIP_Desc As INCIPDesc, INCIP_ParamName As INCIPParamName, INCIP_ActiveFlag As AuditFlag  FROM DHC_InciParamRecord where 1=1"
	i PDesc'="" d
	.s PDesc=$$ALPHAUP^SSUTIL4(PDesc)
	.s sqlStr=sqlStr_" AND %ALPHAUP(INCIP_Desc) LIKE '%"_PDesc_"%'"
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(result.Next())
	{	
		s RowId=result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_InciParamRecord",RowId,HospId)
		continue:ShowDataFlag="N"
		s INCIPDesc=result.Data("INCIPDesc")
		s INCIPParamName=result.Data("INCIPParamName")
		s AuditFlag=result.Data("AuditFlag")
		continue:(PAuditFlag'="")&&(AuditFlag'=PAuditFlag)
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,INCIPDesc,INCIPParamName,AuditFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:   保存/更新信息(Js调用)
/// Creater:    lihui
/// CreateDate: 20200702
/// w ##class(web.DHCSTMHUI.InciParamRecord).jsSave(^tsr("MainInforec"),^tsr("ListDatarec"))
ClassMethod jsSave(Params As %String, ListData As %String) As %Library.String
{
	n (Params,ListData,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Params,ListData)
	q RtnObj.Json()
}

/// Descript:	保存/更新物资属性信息
/// Creater: lihui
/// CreateDate:	20190306
/// Input: 控件信息串:rowid^字段描述^字段名称^审核标志
/// Output:		
/// Return："" – 成功，非空：失败
/// w ##class(web.DHCSTMHUI.InciParamRecord).Save("")
ClassMethod Save(Params As %String, listData As %String) As %Library.String
{
	n (Params,listData,%session)
	s ^litmp("InciParamRecord1")=Params
	s ^tmpli("InciParamRecord2")=listData
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Params)'=0 RtnObj.Err(-1,"","入参解析失败!")
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(listData)
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Objitm=Obj.%ToJSON()
		i RowId'=""  d
		.s RtnObj=..update(Objitm)
		e  d
		.s RtnObj=..insert(Objitm,gHospId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj
	tc
	q RtnObj
}

/// Descript:更新物资属性信息
/// Creater:lihui
/// CreateDate:	20190306
/// Input:控件信息串:rowid^字段描述^字段名称^审核标志
/// Output:		
/// Return：0 :成功，非0：失败 -1重复;-2 字段不存在
ClassMethod update(Params As %String) As %Library.String
{
	n (Params)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Params)'=0 RtnObj.Err(-1,"","入参解析失败!")
	s RowId=MainPJObj.%Get("RowId")
	if RowId=""  d RtnObj.Err(-1,"","记录不存在","",0) q RtnObj
	s INCIPDesc=MainPJObj.%Get("INCIPDesc")
	if INCIPDesc=""  d RtnObj.Err(-1,"","描述为空","",0) q RtnObj
	s INCIPParamName=MainPJObj.%Get("INCIPParamName")
	if INCIPParamName=""  d RtnObj.Err(-1,"","名称为空","",0) q RtnObj
	s AuditFlag=MainPJObj.%Get("AuditFlag")
	
	s:AuditFlag="" AuditFlag="N"
	s ret=0
	s tmprowid=$o(^DHCINCIP(0,"param",INCIPParamName,""))
	if ((tmprowid'="")&&(tmprowid'=RowId)) d
	.d RtnObj.Err(-2,"","名称重复","",0)
	q:RtnObj.success'=0 RtnObj
	s paramexitret=..CheckInciParam(INCIPParamName)
	if paramexitret'="Y" d
	.d RtnObj.Err(-3,"","名称不存在表中","",0)
	q:RtnObj.success'=0 RtnObj
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_InciParamRecord",RowId)
	&sql(UPDATE DHC_InciParamRecord SET INCIP_Desc=:INCIPDesc,INCIP_ParamName=:INCIPParamName,INCIP_ActiveFlag=:AuditFlag WHERE INCIP_RowId=:RowId)
	if SQLCODE'=0 d
	.d RtnObj.Err(-4,"","更新失败")
	e  d
	.s RtnObj=##class(web.DHCSTMHUI.Log).SaveLog("DHC_InciParamRecord","User.DHCInciParamRecord","物资属性信息审核",RowId,INCIPParamName,"U","",OldJsonStr) 
 	q RtnObj
}

/// Descript:插入物资属性信息
/// Creater:lihui
/// CreateDate:	20190306
/// Input:控件信息串:字段描述^字段名称^审核标志
/// Output:		
/// Return：rowid :成功，其余：失败 -1重复;-2 字段不存在
ClassMethod insert(Params As %String, gHospId As %String) As %Library.String
{
	n (Params,gHospId)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Params)'=0 RtnObj.Err(-1,"","入参解析失败!")
	s INCIPDesc=MainPJObj.%Get("INCIPDesc")
	if INCIPDesc=""  d RtnObj.Err(-1,"","描述为空","",0) q RtnObj
	s INCIPParamName=MainPJObj.%Get("INCIPParamName")
	if INCIPParamName=""  d RtnObj.Err(-1,"","名称为空","",0) q RtnObj
	s AuditFlag=MainPJObj.%Get("AuditFlag")
	
	s:AuditFlag="" AuditFlag="N"
	s ret=0
	s tmprowid=$o(^DHCINCIP(0,"param",INCIPParamName,""))
	if (tmprowid'="") d
	.d RtnObj.Err(-2,"","名称重复","",0)
	q:RtnObj.success'=0 RtnObj
	s paramexitret=..CheckInciParam(INCIPParamName)
	if paramexitret'="Y" d
	.d RtnObj.Err(-3,"","名称不存在表中","",0)
	q:RtnObj.success'=0 RtnObj
	&sql(INSERT INTO DHC_InciParamRecord (INCIP_Desc, INCIP_ParamName, INCIP_ActiveFlag) 
	VALUES(:INCIPDesc,:INCIPParamName,:AuditFlag))
	i SQLCODE'=0  d
 	.d RtnObj.Err(-4,"","保存失败")
	q:RtnObj.success'=0 RtnObj
	s RowId=$SYSTEM.SQL.GetROWID()
	s RtnObj=##class(web.DHCSTMHUI.Log).SaveLog("DHC_InciParamRecord","User.DHCInciParamRecord","物资属性信息审核",$SYSTEM.SQL.GetROWID(),INCIPParamName,"A")
 	q:RtnObj.success'=0 RtnObj
 	s RtnObj.rowid=$p(%ROWID,$c(1))
 	//保存医院关联
 	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_InciParamRecord",RowId,gHospId)
 	i ret<0  d RtnObj.Err(-4,"","关联医院失败"_ret)
 	q RtnObj
}

/// Descript:删除基础数据控件信息
/// Creater:lihui
/// CreateDate:	2017-03-23
/// Input:控件信息串:rowid
/// Output:		
/// Return：0 :成功，非0：失败
ClassMethod delete(rowid As %String) As %Library.String
{
	n (rowid,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	if rowid=""  d RtnObj.Err(-1,"","记录不存在","",0) q RtnObj.Json()
	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_InciParamRecord",rowid)
	&sql(DELETE from DHC_InciParamRecord WHERE INCIP_RowId=:rowid)
	i SQLCODE'=0  d
	.d RtnObj.Err(-2,"","删除失败")
	e  d
	.d ##class(Log).SaveLog("DHC_InciParamRecord","User.DHCInciParamRecord","物资属性信息审核",rowid,"","D",JsonStr)
	q RtnObj.Json()
}

/// 判断字段是否在表结构中存在
ClassMethod CheckInciParam(Param As %String) As %Library.String
{
	n (Param)
	q:Param="" "N"
	s INCItmPropId="User.INCItm||"_Param
	s AddioninfoPropId="User.DHCItmAddionInfo||"_Param
	s flag="N"
	s INCItmret=##class(%Dictionary.PropertyDefinition).%ExistsId(INCItmPropId)
	s Addioninforet=##class(%Dictionary.PropertyDefinition).%ExistsId(AddioninfoPropId)
	i ((INCItmret=1)||(Addioninforet=1)) d
	.s flag="Y"
	q flag
}

/// w ##class(web.DHCSTMHUI.InciParamRecord).CheckInciParamAudit("INCICTUOMDR")
/// 判断字段是否需要审核
ClassMethod CheckInciParamAudit(Param As %String) As %Library.String
{
	n (Param)
	q:Param="" "N"
	s flag="N"
	s tmprowid=$o(^DHCINCIP(0,"param",Param,""))
	q:+tmprowid'>0 flag
	s auditflag=$p(^DHCINCIP(tmprowid),"^",3)
	i auditflag="Y" s flag="Y"
	q flag
}

/// Description:获取字段审核标志
/// Creator:	lxt
/// CreateDate:	20201119
/// Input:		
/// Return:		js-object格式 
/// w ##class(web.DHCSTMHUI.InciParamRecord).GetAuditFlagStr()
ClassMethod GetAuditFlagStr() As %String
{
	s (TitleStr,DataStr)=""
	s RowId=0
	f  s RowId=$o(^DHCINCIP(RowId)) q:RowId=""  d
	.s ParamName=$p(^DHCINCIP(RowId),"^",2)
	.s ActiveFlag=$p(^DHCINCIP(RowId),"^",3)
	.
	.i TitleStr="" d
	..s TitleStr=ParamName
	..s DataStr=ActiveFlag
	.e  d
	..s TitleStr=TitleStr_"^"_ParamName
	..s DataStr=DataStr_"^"_ActiveFlag
	
	s AuditFlagStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q AuditFlagStr
}

}
