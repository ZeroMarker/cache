Import sqluser

/// Descript:出入库类型相关
/// Creater:张枭
/// CreateDate:	2018-04-19
Class web.DHCSTMHUI.DHCOpType Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新出入库类型信息
/// Creater:	张枭
/// CreateDate:	2018-04-19
/// Table:		DHC_OperateType
/// Input:		数据Json串:rowid,代码,描述,类型
/// Return：	RtnObj Json
/// w ##class(web.DHCSTMHUI.DHCOpType).Save("[{""Code"":""3"",""Description"":""222"",""Type"":""OM""}]")
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
		s Type=Obj.%Get("Type")
		s DefaultFlag=Obj.%Get("DefaultFlag")
		i (Code="")||(Description="")||(Type="") s Sc=RtnObj.Err(-2,"","必填项不能为空!","",0)
		q:RtnObj.success'=0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",Code,"DHC_OperateType",gHospId,RowId,Type)
		i ret>0 d RtnObj.Err(-2,RowId,Code_" 代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Description,"DHC_OperateType",gHospId,RowId,Type)
		i ret>0 d RtnObj.Err(-2,RowId,Description_" 名称重复!","",0)
		continue:RtnObj.success<0
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Code,Description,Type,DefaultFlag)
		e  d
		.s RtnObj=..Insert(Code,Description,Type,gHospId,DefaultFlag)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	增加出入库类型信息
/// Creater:	张枭
/// CreateDate:	2018-04-19
/// Table:		DHC_OperateType
/// Input:		代码,描述,类型
/// Output:		
/// Return：	RtnObj
ClassMethod Insert(Code As %String, Description As %String, Type As %String, gHospId, DefaultFlag = "N") As RtnObj [ Private ]
{
	n (Code,Description,Type,gHospId,DefaultFlag,%session)
	s RtnObj=##class(RtnObj).%New()
	&sql(Insert into DHC_OperateType
		(IPT_Code,IPT_Desc,IPT_Type,IPT_Default)
		values
		(:Code,:Description,:Type,:DefaultFlag))
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.//保存医院关联
	.s RowId=%ROWID
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_OperateType",RowId,gHospId)
	.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	.q:RtnObj.success'=0
	.s RtnObj=##class(Log).SaveLog("DHC_OperateType","User.DHCOperateType","出入库类型信息",$SYSTEM.SQL.GetROWID(),Description,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新出入库类型信息
/// Creater:	张枭
/// CreateDate:	2018-04-19
/// Table:		DHC_OperateType
/// Input:		rowid,代码,描述,类型
/// Return：	RtnObj
ClassMethod Update(RowId As %String, Code As %String, Description As %String, Type As %String, DefaultFlag = "N") As RtnObj [ Private ]
{
	n (RowId,Code,Description,Type,DefaultFlag,%session)
	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_OperateType",RowId)
	&sql(Update DHC_OperateType set 
		IPT_Code=:Code,IPT_Desc=:Description,IPT_Type=:Type,IPT_Default=:DefaultFlag 
		where IPT_RowId=:RowId)
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-22,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_OperateType","User.DHCOperateType","出入库类型",RowId,Description,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	删除出入库类型
/// Creater:	张枭
/// CreateDate:	2018-05-03
/// Table: DHC_OperateType
/// Input:		Rowid
/// Return：	消息Json串
/// 
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
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_OperateType",RowId)
		&sql(Delete from DHC_OperateType where IPT_RowId=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("DHC_OperateType","User.DHCOperateType","出入库类型",RowId,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	查询出入库类型
/// Creater:	张枭
/// CreateDate:	2018-04-19
/// Table:		DHC_OperateType
/// Input:		{Desc:Text}
/// Return：	出入库类型信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCOpType","SelectAll","RowId","Desc","")
Query SelectAll(Params As %String) As Query(ROWSPEC = "RowId,Code,Description,Type,TypeDesc,DefaultFlag") [ SqlProc ]
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
	s SqlStr="SELECT IPT_Rowid as RowId,IPT_Code as Code,IPT_Desc as Description,IPT_Type as Type,IPT_Default DefaultFlag"
			_"  FROM DHC_OperateType "
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_OperateType",RowId,gHospId)
		continue:ShowDataFlag="N"
		s Code = Result.Data("Code")
		s Description = Result.Data("Description")
		s Type = Result.Data("Type")
		continue:(Type'="IM")&&(Type'="OM")
		s TypeDesc=""
		s:Type="IM" TypeDesc="入库"
		s:Type="OM" TypeDesc="出库"
		s DefaultFlag=Result.Data("DefaultFlag")
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Code,Description,Type,TypeDesc,DefaultFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
