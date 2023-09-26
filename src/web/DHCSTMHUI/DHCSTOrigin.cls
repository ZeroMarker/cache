Import sqluser

/// Descript:	产地信息相关
/// Creater:	tsr
/// CreateDate: 2018-04-20
Class web.DHCSTMHUI.DHCSTOrigin Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新产地信息
/// Creater:	tsr
/// CreateDate: 2018-04-20
/// Table:		DHC_STOrigin
/// Input:		数据Json串:rowid,代码,描述,类型,医院ID
/// Return: 	RtnObj Json
/// d ##class(web.DHCSTMHUI.DHCSTOrigin).Save("[{""RowId"":""1"",""Code"":""6666"",""Description"":""深圳"",""HospId"":""3"",""HospDesc"":""东华标准版数字化医院[分院]""}]")
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
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	s HospMsg=""
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType("DHC_STOrigin")
	i TableType="C" s HospMsg="该数据属于管控类型数据,请联系相关人员进行授权!"
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s Description=Obj.%Get("Description")
		i (Code="")||(Description="") d RtnObj.Err(-2,"","必填项不能为空!","",0)
		q:RtnObj.success'=0
		
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",Code,"DHC_STOrigin",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Code_" 代码重复!"_HospMsg,"",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Description,"DHC_STOrigin",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Description_" 名称重复!"_HospMsg,"",0)
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

/// Descript:	增加产地信息
/// Creater:	tsr
/// CreateDate: 2016-09-20
/// Table:		DHC_STOrigin
/// Input:		代码,描述,医院ID
/// Return:		RtnObj
ClassMethod Insert(Code As %String, Description As %String, gHospId As %String) As RtnObj [ Private ]
{
	n (Code,Description,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	s Type=..sssCode()
	s QPAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Description,3,"",50)
	s SPAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Description,4)
	s Alias=Code_"/"_Description_"/"_SPAlias_"/"_QPAlias
	&sql(Insert into DHC_STOrigin
		(Orig_Code,Orig_Name,Orig_Type,Orig_Alias)
		values
		(:Code,:Description,:Type,:Alias))
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RowId=$p(%ROWID,$c(1))
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_STOrigin",RowId,gHospId)
	.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	.q:RtnObj.success'=0
	.s RtnObj=##class(Log).SaveLog("DHC_STOrigin","User.DHCSTOrigin","产地信息",$SYSTEM.SQL.GetROWID(),Description,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新产地信息
/// Creater:	tsr
/// CreateDate: 2016-09-20
/// Table:		DHC_STOrigin
/// Input:		RowId,代码,描述,类型,医院ID
/// Return:		RtnObj
ClassMethod Update(RowId As %String, Code As %String, Description As %String) As RtnObj [ Private ]
{
	n (RowId,Code,Description,%session)
	s RtnObj=##class(RtnObj).%New()
	s Type=..sssCode()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_STOrigin",RowId)
	s QPAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Description,3,"",50)
	s SPAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Description,4)
	s Alias=Code_"/"_Description_"/"_SPAlias_"/"_QPAlias
	&sql(Update DHC_STOrigin set
		Orig_Code=:Code,Orig_Name=:Description,Orig_Type=:Type,Orig_Alias=:Alias
		where Orig_RowId=:RowId)
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-22,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_STOrigin","User.DHCSTOrigin","产地信息",RowId,Description,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	查询产地信息
/// Creater:	tsr
/// CreateDate:	2018-04-20
/// Table:		DHC_STOrigin
/// Input:		{Code:Text,Desc:Text,HospId:Text}
/// Return：	单位信息
Query SelectAll(Params As %String) As Query(ROWSPEC = "RowId,Code,Description,HospId,HospDesc") [ SqlProc ]
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
	s PCode=PJobj.%Get("Code")
	s PDescription=PJobj.%Get("Description")
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Type=..sssCode()
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr="SELECT Orig_RowId as RowId, Orig_Code as Code, Orig_Name as Description, Orig_Hosp_Dr as HospId"
		_" FROM DHC_STOrigin WHERE Orig_Type='"_Type_"'"
	i PDescription'="" d
	.s PDescription=$$ALPHAUP^SSUTIL4(PDescription)
	.s SqlStr=SqlStr_" and (%ALPHAUP(Orig_Alias) like '%"_PDescription_"%'"_" OR %ALPHAUP(Orig_Code) like '%"_PDescription_"%')"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Code = Result.Data("Code")
		s Description = Result.Data("Description")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_STOrigin",RowId,gHospId)
		continue:ShowDataFlag="N"
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Code,Description,HospId,$g(HospDesc))
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description: 产地区分医院
/// Creater: lihui
/// CreateDate: 20200403
/// Table:		dhc_stvendor
/// Input:		产地Id,医院Id
/// Return:		0-属于;非零-不属于
/// w ##class(web.DHCSTMHUI.DHCSTOrigin).OriginOfHosp(20,2)
ClassMethod OriginOfHosp(Origin, HospId) As %String
{
	n (Origin,HospId,%session)
	q:Origin="" -1
	q:HospId="" -2
	;s HospAutFlag=##class(web.DHCSTMHUI.MatForBDPData).GetHospAutFlag(HospId)
	;q:(HospAutFlag'="Y") -4
	s TmpHospId=""
	&sql(SELECT Orig_Hosp_Dr into :TmpHospId FROM DHC_STOrigin WHERE Orig_RowId=:Origin)
	q:(HospId'=TmpHospId)&&(TmpHospId'="") -3
	q 0
}

}
