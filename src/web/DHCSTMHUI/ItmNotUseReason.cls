Import sqluser

/// Descript:屏蔽库存项原因维护
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
Class web.DHCSTMHUI.ItmNotUseReason Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新屏蔽库存项原因信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmNotUseReason
/// Input:数据串:rowid^描述,rowid^描述,
/// Output:		
/// Return："" – 成功，
/// 非空：失败
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
		s Description=Obj.%Get("Description")
		i (Description="") s Sc=RtnObj.Err(-2,"","必填项不能为空!","",0)
		q:RtnObj.success'=0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Description,"DHC_ItmNotUseReason",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Description_" 名称重复!","",0)
		continue:RtnObj.success<0
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Description)
		e  d
		.s RtnObj=..Insert(Description,gHospId)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	增加屏蔽原因信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmNotUseReason
/// Input:描述
/// Output:		
/// Return：rowid
ClassMethod Insert(Description As %String, gHospId As %String) As %Library.String [ Private ]
{
	n (Description,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	&sql(Insert into DHC_ItmNotUseReason(DIUR_Desc)values(:Description))
	i SQLCODE'=0  d
	.d RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RowId=%ROWID
	.//保存医院关联
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_ItmNotUseReason",RowId,gHospId)
	.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	.q:RtnObj.success'=0
	.s RtnObj=##class(Log).SaveLog("DHC_ItmNotUseReason","User.DHCItmNotUseReason","不可用原因插入",$SYSTEM.SQL.GetROWID(),Description,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新屏蔽原因信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmNotUseReason
/// Input:rowid,描述
/// Output:		
/// Return：0:成功;非0：失败
ClassMethod Update(RowId As %String, Description As %String) As RtnObj [ Private ]
{
	n (RowId,Description,%session)
	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_ItmNotUseReason",RowId)
	&sql(Update DHC_ItmNotUseReason set DIUR_Desc=:Description where DIUR_Rowid=:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-22,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_ItmNotUseReason","User.DHCItmNotUseReason","不可用原因",RowId,Description,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	删除屏蔽原因信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmNotUseReason
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
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
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_ItmNotUseReason",RowId)
		&sql(Delete from DHC_ItmNotUseReason where DIUR_Rowid=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-3,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("DHC_ItmNotUseReason",RowId)
		.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
		.q:RtnObj.success'=0
		.s RtnObj=##class(Log).SaveLog("DHC_ItmNotUseReason","User.DHCItmNotUseReason","不可用原因",RowId,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	查询屏蔽原因信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmNotUseReason
/// Input:
/// Output:		
/// Return：屏蔽原因信息
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
	
	s SqlStr = "SELECT DIUR_Rowid  RowId,DIUR_Desc Description FROM DHC_ItmNotUseReason"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ItmNotUseReason",RowId,gHospId)
		continue:ShowDataFlag="N"
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
