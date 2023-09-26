Import sqluser

/// Descript:招标级别维护
Class web.DHCSTMHUI.ITMPBLEVEL Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新招标级别信息
/// Creator:	wangjiabin
/// CreateDate:	2018-10-31
/// Table:		DHC_ItmPBLevel
/// Input:		"[{""RowId"":""4"",""Code"":""ZBJB01"",""Desc"":""招标一级"",""DateFrom"":""13/07/2016"",""DateTo"":""30/09/2017""}]"
/// Output:		
/// Return:		RtnObj.Json()
/// w ##class(web.DHCSTMHUI.ITMPBLEVEL).Save("[{""RowId"":""4"",""Code"":""ZBJB01"",""Desc"":""招标一级"",""DateFrom"":""13/07/2016"",""DateTo"":""30/09/2017""}]")
ClassMethod Save(Params As %String, Main As %String) As %Library.String
{
	n (Params,Main,%session)

	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","参数解析错误!").Json()
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s Desc=Obj.%Get("Desc")
		s Code=$$ALPHAUP^SSUTIL4(Code)
		s Desc=$$ALPHAUP^SSUTIL4(Desc)
		i (Code="")||(Desc="") d RtnObj.Err(-10,RowId,"代码或名称不可为空!","",0)
		continue:RtnObj.success<0
		
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",Code,"DHC_ItmPBLevel",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Code_" 代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Desc,"DHC_ItmPBLevel",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Desc_" 名称重复!","",0)
		continue:RtnObj.success<0
		
		s ObjStr=Obj.%ToJSON()
		i RowId="" d
		.s RtnObj=..Insert(ObjStr,gHospId)
		e  d
		.s RtnObj=..Update(ObjStr)
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	增加招标级别信息
/// Creator:	wangjiabin
/// CreateDate:	2018-10-31
/// Input:		Obj格式字符串
/// Output:		
/// Return:		RtnObj
ClassMethod Insert(Params, gHospId) As RtnObj [ Private ]
{
	n (Params,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Code=PJObj.%Get("Code")
	s Desc=PJObj.%Get("Desc")
	s DateFrom=PJObj.%Get("DateFrom")
	s DateTo=PJObj.%Get("DateTo")
	s DateFrom=..DH2L(DateFrom)
	s DateTo=..DH2L(DateTo)
	
	&sql(Insert into DHC_ItmPBLevel
		(PBL_Code,PBL_Desc,PBL_DateFrom,PBL_DateTo)
		values
		(:Code,:Desc,:DateFrom,:DateTo)
	)
	i SQLCODE'=0 q RtnObj.Err(-1,"","Insert失败!",Params)
	s RowId=$p(%ROWID,$c(1))
	//保存医院关联
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_ItmPBLevel",RowId,gHospId)
	i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	q:RtnObj.success<0 RtnObj
	s RtnObj=##class(Log).SaveLog("DHC_ItmPBLevel","User.DHCItmPBLevel","招标级别",RowId,Desc,"A")
	q:RtnObj.success<0 RtnObj
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:	更新招标级别信息
/// Creator:	wangjiabin
/// CreateDate:	2018-10-31
/// Input:		Obj格式字符串
/// Output:		
/// Return:		RtnObj
ClassMethod Update(Params) As RtnObj [ Private ]
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s RowId=PJObj.%Get("RowId")
	s Code=PJObj.%Get("Code")
	s Desc=PJObj.%Get("Desc")
	s DateFrom=PJObj.%Get("DateFrom")
	s DateTo=PJObj.%Get("DateTo")
	s DateFrom=..DH2L(DateFrom)
	s DateTo=..DH2L(DateTo)
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_ItmPBLevel",RowId)
	&sql(Update DHC_ItmPBLevel
		set PBL_Code=:Code,PBL_Desc=:Desc,PBL_DateFrom=:DateFrom,PBL_DateTo=:DateTo
		where PBL_Rowid=:RowId
	)
	i SQLCODE'=0 q RtnObj.Err(-2,RowId,"Update失败!",Params)
	s RtnObj=##class(Log).SaveLog("DHC_ItmPBLevel","User.DHCItmPBLevel","招标级别",RowId,Desc,"U","",OldJsonStr)
	q RtnObj
}

/// Descript:	删除招标级别信息
/// Creator:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmPBLevel
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid,%session)
	;
	;不能为空项
	q:rowid="" ""
	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_ItmPBLevel",rowid)
	s Err=0
	s $ZT=..sssError()
	&sql(Delete from DHC_ItmPBLevel where PBL_Rowid=:rowid)
	i SQLCODE'=0  d
	.s Err=-1
	e  d
	.d ##class(Log).SaveLog("DHC_ItmPBLevel","User.DHCItmPBLevel","招标级别",rowid,"","D",JsonStr)
	q Err
}

/// Descript:	查询招标级别信息
/// Creator:	wangjiabin
/// CreateDate:	2018-10-31
/// Table:		DHC_ItmPBLevel
/// Input:
/// Output:		
/// Return:		招标级别信息json
ClassMethod SelectAll(Params As %String)
{
	n (Params,%session)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s result=##class(%Library.ResultSet).%New()
	s sqlStr="SELECT PBL_Rowid as RowId,PBL_Code,PBL_Desc,PBL_DateFrom,PBL_DateTo"  
		_" FROM DHC_ItmPBLevel"
	d result.Prepare(sqlStr)
	s result.RuntimeMode=0
	d result.Execute()
	s count=0
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{
		s RowId=result.Data("RowId")
		CONTINUE:+RowId=0
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ItmPBLevel",RowId,gHospId)
		continue:ShowDataFlag="N"
		s Code=result.Data("PBL_Code")
		s Desc=result.Data("PBL_Desc")
		s DateFrom=result.Data("PBL_DateFrom")
		s DateTo=result.Data("PBL_DateTo")
		s DateFrom=..DL2H(DateFrom)
		s DateTo=..DL2H(DateTo)
		s DataStr=RowId_"^"_Code_"^"_Desc_"^"_DateFrom_"^"_DateTo
		s count=count+1
		d json.InsertRowData(DataStr)
	}
	d result.Close()
	s TitleStr="RowId^Code^Desc^DateFrom^DateTo"
	d json.getJsonData(TitleStr,count)
	k json
	q ""
}

}
