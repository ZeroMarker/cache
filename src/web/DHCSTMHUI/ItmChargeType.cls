Import sqluser

/// Descript:收费类型维护
/// Creater:    zhangxiao
/// CreateDate: 2015-11-3
Class web.DHCSTMHUI.ItmChargeType Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新收费类型
/// Creater:    zhangxiao
/// CreateDate: 2015-11-3
/// Table:DHC_ItmChargeType
/// Input:数据串:rowid^代码^描述,rowid^代码^描述
/// Output:     
/// Return："" : 成功，非空：失败
/// w ##class(web.DHCSTMHUI.ItmChargeType).Save("[{""RowId"":""4"",""Code"":""4"",""Description"":""SSSS""}]")
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
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s Description=Obj.%Get("Description")
		
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",Code,"DHC_ItmChargeType",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Code_" 代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Description,"DHC_ItmChargeType",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Description_" 名称重复!","",0)
		continue:RtnObj.success<0
		
		s ObjStr=Obj.%ToJSON()
		i RowId'=""  d
		.s RtnObj=..Update(ObjStr)
		e  d
		.s RtnObj=..Insert(ObjStr,gHospId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:   增加收费类型
/// Creater:    zhangxiao
/// CreateDate: 2015-11-3
/// Table:DHC_ItmChargeType
/// Input:代码,描述
/// Output:     
/// Return：rowid
ClassMethod Insert(Params As %String, gHospId As %String) As RtnObj [ Private ]
{
	n (Params,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","Insert:参数接触错误!")
	s Code=PJObj.%Get("Code")
	s Description=PJObj.%Get("Description")
	i (Code="")||(Description="") q RtnObj.Err(-1,"","必填项不可为空","",0)
	&sql(Insert into DHC_ItmChargeType (ICT_Code,ICT_Desc) values (:Code,:Description))
	i SQLCODE'=0 q RtnObj.Err(-2,"","Insert失败:"_SQLCODE_":"_$g(%msg))
	s RowId=$p(%ROWID,$c(1))
	//保存医院关联
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_ItmChargeType",RowId,gHospId)
	i ret<0 q RtnObj.Err(-11,"","关联医院失败"_ret)
	s RtnObj=##class(Log).SaveLog("DHC_ItmChargeType","User.DHCItmChargeType","支付方式信息",RowId,Description,"A")
	q:RtnObj.success'=0 RtnObj
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:   更新收费类型
/// Creater:    zhangxiao
/// CreateDate: 2015-11-3
/// Table:DHC_ItmChargeType
/// Input:代码,描述
/// Output:     
/// Return：rowid
ClassMethod Update(Params As %String) As RtnObj [ Private ]
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s RowId=PJObj.%Get("RowId")
	s Code=PJObj.%Get("Code")
	s Description=PJObj.%Get("Description")
	i (Code="")||(Description="")||(RowId="") d
	.s RtnObj.success=-1
	.s RtnObj.msg="必填项不可为空"
	q:RtnObj.success'=0 RtnObj
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_ItmChargeType",RowId)
	&sql(Update DHC_ItmChargeType set ICT_Code=:Code,ICT_Desc=:Description where ICT_RowId=:RowId)
	i SQLCODE'=0 q RtnObj.Err(-1,RowId,"Update失败!",Params)
	s RtnObj=##class(Log).SaveLog("DHC_ItmChargeType","User.DHCItmChargeType","支付方式信息",RowId,Description,"U","",OldJsonStr)
	q RtnObj
}

///  Descript:   删除收费类型
/// Creater:     zhangxiao
/// CreateDate: 2015-11-3
/// Table:DHC_ItmChargeType
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid,%session)
	q:rowid="" ""
	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_ItmChargeType",rowid)
	&sql(Delete from DHC_ItmChargeType where ICT_RowId=:rowid)
	q:SQLCODE'=0 SQLCODE
	d ##class(Log).SaveLog("DHC_ItmChargeType","User.DHCItmChargeType","支付方式信息",rowid,"","D",JsonStr)
	q 0
}

/// Descript:	查询收费类型信息
/// Creater:	qiushengxin
/// CreateDate:	20180809
/// Table: DHC_ItmChargeType
/// Input:
/// Output:		
/// Return：收费类型信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ItmChargeType","SelectAll","","")
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
	s SqlStr = "select ICT_RowId as RowId, ICT_Code as Code,ICT_Desc as Description from DHC_ItmChargeType "
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		CONTINUE:+RowId=0
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ItmChargeType",RowId,gHospId)
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
