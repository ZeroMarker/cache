Import sqluser

/// Descript:采购审核级别维护
/// Creater:	zhangxiao
/// CreateDate:2014-03-17
Class web.DHCSTMHUI.DHCPlanStatus Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新采购审核级别
/// Creater:	zhangxiao
/// CreateDate:	2018-05-21
/// Table: DHC_PlanStatus
/// Input: 数据Json串:rowid,代码,描述,最大金额
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
		s MaxAmt=Obj.%Get("MaxAmt")
		i (Code="")||(Description="") s Sc=RtnObj.Err(-2,"","必填项不能为空!","",0)
		q:RtnObj.success'=0
		s TmpId=..CheckCode(Code)
		i (TmpId'="")&&(TmpId'=RowId) s Sc=RtnObj.Err(-3,"",Description_"代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Description,"DHC_PlanStatus",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Description_" 名称重复!","",0)
		continue:RtnObj.success<0
	 	
	 	q:RtnObj.success'=0
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Code,Description,MaxAmt)
		e  d
		.s RtnObj=..Insert(Code,Description,MaxAmt,gHospId)
		q:RtnObj.success'=0
		
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	增加采购审核级别
/// Creater:	zhangxiao
/// CreateDate:	2018-05-21
/// Table: DHC_PlanStatus
/// Input: 代码,描述,最大金额
/// Output:		
/// Return：RtnObj
ClassMethod Insert(Code As %String, Description As %String, MaxAmt As %String, gHospId As %String) As RtnObj [ Private ]
{
	n (Code,Description,MaxAmt,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	s Type=..sssCode()
	&sql(Insert into DHC_PlanStatus(DHCPS_Code,DHCPS_Desc,DHCPS_MaxAmtAuthorized,DHCPS_StkType)
	values(:Code,:Description,:MaxAmt,:Type))
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RowId=%ROWID
	.//保存医院关联
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_PlanStatus",RowId,gHospId)
	.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	.s RtnObj=##class(Log).SaveLog("DHC_PlanStatus","User.DHCPlanStatus","采购审核级别",$SYSTEM.SQL.GetROWID(),Description,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新退货原因
/// Creater:	lihui
/// CreateDate:	20180419
/// Table:		INC_ReasonForReturn
/// Input:		rowid^代码^描述
/// Return：	RtnObj
ClassMethod Update(RowId As %String, Code As %String, Description As %String, MaxAmt As %String) As RtnObj [ Private ]
{
	n (RowId,Code,Description,MaxAmt,%session)
	s RtnObj=##class(RtnObj).%New()
 	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_PlanStatus",RowId)
 	&sql(Update DHC_PlanStatus set DHCPS_Code=:Code,DHCPS_Desc=:Description,DHCPS_MaxAmtAuthorized=:MaxAmt
 	where DHCPS_RowId=:RowId)
 	i SQLCODE'=0  d
 	.s sc=RtnObj.Err(-22,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
    .s RtnObj=##class(Log).SaveLog("DHC_PlanStatus","User.DHCPlanStatus","采购审核级别",RowId,Description,"U","",OldJsonStr)
    q:RtnObj.success'=0 RtnObj
 	q RtnObj
}

/// 验证采购审核级别中代码是否重复
/// Author:taosongrui
/// Date:2014-03-21
/// Return:
/// 货位码id -存在
/// 空-不存在
ClassMethod CheckCode(Code As %String) As %String
{
 n (Code)
 s type=..sssCode()
 s rowid=""
  &sql(select DHCPS_RowId into :rowid from DHC_PlanStatus where DHCPS_Code=:Code and DHCPS_StkType=:type)
  q rowid
}

/// 验证采购审核级别中名称是否重复
/// Author:taosongrui
/// Date:2014-03-21
/// Return:
/// 货位码id -存在
/// 空-不存在
ClassMethod CheckDesc(Desc As %String) As %String
{
 n (Desc)
 s type=..sssCode()
 s rowid=""
  &sql(select DHCPS_RowId into :rowid from DHC_PlanStatus where DHCPS_Desc=:Desc and DHCPS_StkType=:type)
  q rowid
}

/// Descript:	查询采购审核级别
/// Creater:	zhangxiao
/// CreateDate:	2018-05-21
/// Table: DHC_PlanStatus
/// Input:
/// Output:		
/// Return：审核级别信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPlanStatus","SelectAll","RowId","Desc")
Query SelectAll(Params As %String) As Query(ROWSPEC = "RowId,Code,Description,MaxAmt:%Float") [ SqlProc ]
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
	
	s Type=..sssCode()
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT DHCPS_RowId as RowId,DHCPS_Code as Code,DHCPS_Desc as Description,DHCPS_MaxAmtAuthorized as MaxAmt"
		_" FROM DHC_PlanStatus where DHCPS_StkType='"_Type_"'" 
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_PlanStatus",RowId,gHospId)
		continue:ShowDataFlag'="Y"
		s Code = Result.Data("Code")
		s Description = Result.Data("Description")
		s MaxAmt = Result.Data("MaxAmt")
		d OutPutRow
 	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Code,Description,MaxAmt)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	删除采购审核级别
/// Creater:	zhangxiao
/// CreateDate:	2018-05-21
/// Table: DHC_PlanStatus
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
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_PlanStatus",RowId)
		&sql(Delete from DHC_PlanStatus where DHCPS_RowId=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("DHC_PlanStatus","User.DHCPlanStatus","采购审核级别",RowId,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

}
