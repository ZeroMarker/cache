Import sqluser

/// Descript:科室扩充信息相关
Class web.DHCSTMHUI.CTLOC Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:保存/更新科室扩充信息
/// Creator:	wangjiabin
/// CreateDate:	2018-11-05
/// Table:		DHCST_CtLoc
/// Input:
/// Output:		RtnObj.Json()
/// w ##class(web.DHCSTMHUI.CTLOC).Save(392,1) 
ClassMethod Save(Params As %String) As %Library.String
{
	n (Params,%session)
	;s ^tmpzx(23)=Params
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success<0 RtnObj.Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s LocId=Obj.%Get("LocId")
		i LocId="" d RtnObj.Err(-1,"","科室参数错误",Obj.%ToJSON())
		continue:RtnObj.success<0
		
		s SlgId=Obj.%Get("SlgId")
		s LigId=Obj.%Get("LigId")
		s MainLocId=Obj.%Get("MainLocId")
		s Type=Obj.%Get("Type")
		s Active=Obj.%Get("Active")
		s ReqAllItm=Obj.%Get("ReqAllItm")
		s ReportSeq=Obj.%Get("ReportSeq")
		s PrintMode=Obj.%Get("PrintMode")
		s AutoMonFlag=Obj.%Get("AutoMonFlag")
		s StockControlFlag=Obj.%Get("StockControlFlag")
		
		s RowId=$o(^DHCLOC(0,"LOC",LocId,0))
		i RowId="" d
		.s LocObj=##class(User.DHCSTCtLoc).%New()
		.d LocObj.DHCLocCtlocdrSetObjectId(LocId)
		e  d
		.s LocObj=##class(User.DHCSTCtLoc).%OpenId(RowId)
		.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("User.DHCSTCtLoc",RowId)
		d LocObj.DHCLocSLGDrSetObjectId(SlgId)
		d LocObj.DHCLocLIGDrSetObjectId(LigId)
		d LocObj.DHCLocMainLocDRSetObjectId(MainLocId)
		s LocObj.DHCLocType=Type
		s LocObj.DHCLocFlag=Active
		s LocObj.DHCLocReqAllItm=ReqAllItm
		s LocObj.DHCReportSeq=ReportSeq
		s LocObj.DHCLocBillPrtMode=PrintMode
		s LocObj.DHCLocAutoMonFlag=AutoMonFlag
		s LocObj.DHCLocStockControlFlag=StockControlFlag
		s Sc=LocObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-10,"","保存失败!",Obj.%ToJSON())
		continue:RtnObj.success<0
		
		i RowId="" d
		.s RtnObj=##class(web.DHCSTMHUI.Log).SaveLog("DHCST_CtLoc","User.DHCSTCtLoc","科室附加信息",RowId,LocId,"A")
		e  d
		.s RtnObj=##class(web.DHCSTMHUI.Log).SaveLog("DHCST_CtLoc","User.DHCSTCtLoc","科室附加信息",RowId,LocId,"U","",OldJsonStr)
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Description:获取科室扩充信息
/// Creator:	wangjiabin
/// CreateDate:	2018-11-05
/// Table:		DHCST_CtLoc
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.CTLOC","Query","{""Slg"":"""",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2"",""Lig"":"""",""MainLoc"":"""",""Type"":"""",""Hospital"":"""",""Active"":"""",""ReqAllItm"":"""",""MonFlag"":"""",""LocCode"":"""",""LocDesc"":""""}")
Query Query(Params As %String) As Query(ROWSPEC = "LocId,LocCode,LocDesc,LigId,LigDesc,SlgId,SlgDesc,Type,Active,ReqAllItm,ReportSeq,MainLocId,MainLocDesc,PrintMode,AutoMonFlag,StockControlFlag") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s gHospId=PJObj.%Get("gHospId")
	s PLocCode=PJObj.%Get("LocCode")
	s PLocCode=$$ALPHAUP^SSUTIL4(PLocCode)
	s PLocDesc=PJObj.%Get("LocDesc")
	s PLocDesc=$$ALPHAUP^SSUTIL4(PLocDesc)
	s PSlg=PJObj.%Get("Slg")
	s PLig=PJObj.%Get("Lig")
	s PType=PJObj.%Get("Type")
	s PActive=PJObj.%Get("Active")
	s PMainLoc=PJObj.%Get("MainLoc")
	s PReqAllItm=PJObj.%Get("ReqAllItm")
	s PMonFlag=PJObj.%Get("MonFlag")
	s HospId=PJObj.%Get("Hospital")
	i HospId'="" s gHospId=HospId	//使用选择的医院ID
	
	s StrSql="select a.CTLOC_RowId as LocId,a.CTLOC_Code as LocCode,a.CTLOC_Desc as LocDesc,"
		_"b.DHCLoc_RowId as DHCLocRowId,"
		_"b.DHCLoc_LIG_Dr as LigId,b.DHCLoc_LIG_Dr->LIG_Desc as LigDesc,"
		_"b.DHCLoc_SLG_Dr as SlgId,b.DHCLoc_SLG_Dr->SLG_Desc as SlgDesc,"
		_"b.DHCLoc_Type as Type,b.DHCLoc_Flag as Active,b.DHCLoc_ReqAllItm as ReqAllItm,"
		_"b.DHCLoc_MainLoc_DR as MainLocId,b.DHCLoc_MainLoc_DR->CTLOC_Desc as MainLocDesc,"
		_"b.DHCLoc_ReportSeq as ReportSeq,b.DHCLoc_BillPrtMode as PrintMode,"
		_"b.DHCLoc_AutoMonFlag as AutoMonFlag,b.DHCLoc_StockControlFlag as StockControlFlag "
		_" from CT_Loc a Left join DHCST_CtLoc b on a.CTLOC_Rowid=b.DHCLoc_Ctloc_dr where 1=1 "
	i PLocCode'=""  d
	.s StrSql=StrSql_" and %ALPHAUP(a.CTLOC_Code) like '%"_PLocCode_"%'"
	i PSlg'="" d
	.s StrSql=StrSql_" and b.DHCLoc_SLG_Dr = '"_PSlg_"'"
	i PLig'="" d
	.s StrSql=StrSql_" and b.DHCLoc_LIG_Dr = '"_PLig_"'"
	i PMainLoc'="" d
	.s StrSql=StrSql_" and b.DHCLoc_MainLoc_DR = '"_PMainLoc_"'"
	i PType'="" d
	.s StrSql=StrSql_" and b.DHCLoc_Type = '"_PType_"'"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(result.Next())
	{
		s DHCLocRowId=result.Data("DHCLocRowId")
		s LocId=result.Data("LocId")
		s ret=..LocOfHosp(LocId, gHospId)
		continue:(ret'=0)
		s LocCode=result.Data("LocCode")
		s LocDesc=result.Data("LocDesc")
		s ContactName=$p(^CTLOC(LocId),"^",43)
		s PLocDesc=$$ALPHAUP^SSUTIL4(PLocDesc)
		s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
		s ContactName=$$ALPHAUP^SSUTIL4(ContactName)
		continue:(PLocDesc'="")&&(LocDesc'[PLocDesc&&(ContactName'[PLocDesc))
		s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
		s LigId=result.Data("LigId")
		s LigDesc=result.Data("LigDesc")
		s SlgId=result.Data("SlgId")
		s SlgDesc=result.Data("SlgDesc")
		s Type=result.Data("Type")
		s Active=result.Data("Active")
		s:DHCLocRowId="" Active="Y"
		continue:(PActive'="")&&(Active'=PActive)
		s ReqAllItm=result.Data("ReqAllItm")
		s:ReqAllItm="" ReqAllItm="N"
		continue:(PReqAllItm'="")&&(ReqAllItm'=PReqAllItm)
		s ReportSeq=result.Data("ReportSeq")
		s MainLocId=result.Data("MainLocId")
		s MainLocDesc=result.Data("MainLocDesc")
		s MainLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(MainLocDesc)
		s PrintMode=result.Data("PrintMode")
		s AutoMonFlag=result.Data("AutoMonFlag")
		s:AutoMonFlag="" AutoMonFlag="N"
		continue:(PMonFlag'="")&&(AutoMonFlag'=PMonFlag)
		s StockControlFlag=result.Data("StockControlFlag")
		s:StockControlFlag="" StockControlFlag="Y"

		d OutPutRow
	}
	d result.Close()
	quit $$$OK
OutPutRow
	s Data=$lb(LocId,LocCode,LocDesc,LigId,LigDesc,
		SlgId,SlgDesc,Type,Active,ReqAllItm,
		ReportSeq,MainLocId,MainLocDesc,PrintMode,AutoMonFlag,
		StockControlFlag
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	安全组能访问的科室
/// Creater:	qiushengxin
/// CreateDate:	2018-10-10
/// Table:CT_Loc
/// Output:		
/// Return：科室id^科室代码^科室描述
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.CTLOC","QueryLocM","{""Code"":"""",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""57903"",""Description"":"""",""Hospital"":""10""}")
Query QueryLocM(StrFilter As %String) As Query(ROWSPEC = "RowId,Code,Description") [ SqlProc ]
{
}

ClassMethod QueryLocMExecute(ByRef qHandle As %Binary, StrFilter As %String) As %Status
{
	n (qHandle,StrFilter,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(StrFilter)
	s LocCode=PJobj.%Get("Code")
	s LocDesc=PJobj.%Get("Description")
	s GroupId=PJobj.%Get("gGroupId")
	s gHospId=PJobj.%Get("gHospId")
	s HospId=PJobj.%Get("Hospital")
	i HospId'="" s gHospId=HospId	//使用选择的医院ID
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s StrSql="SELECT ST_CTLOC_DR AS RowId,ST_CTLOC_DR->CTLOC_Code AS Code,ST_CTLOC_DR->CTLOC_DESC AS Description FROM SS_GroupStockLocations"
		_" WHERE ST_ParRef='"_GroupId_"'"
	i LocDesc'=""  d
	.s StrSql=StrSql_" and ST_CTLOC_DR->CTLOC_Desc like '%"_LocDesc_"%'"_" OR  ST_CTLOC_DR->CTLOC_Code like '%"_LocDesc_"%'"
	d Result.Prepare(StrSql)
	d Result.Execute()
	While(Result.Next())
	{
		s Active=""
		s RowId = Result.Data("RowId")
		s ret=..LocOfHosp(RowId, gHospId)
		continue:(ret'=0)
		s LocRowId=$o(^DHCLOC(0,"LOC",RowId,""))
		s:LocRowId'="" Active=$p(^DHCLOC(LocRowId),"^",4)
		continue:Active="N"
		s Code = Result.Data("Code")
		s Description = Result.Data("Description")
		s Data=RowId_"^"_Code_"^"_Description
		d OutPutLoc
	}
	Quit $$$OK
	
OutPutLoc
	s Data=$lb(RowId,Code,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取打印模式
/// Creator:	wanajiabin
/// CreateDate:	2018-05-08
/// Input:		LocId:科室rowid, ScgId:类组rowid
/// Output:		打印模式
/// w ##class(web.DHCSTMHUI.CTLOC).GetModByLocScg(392,1)
ClassMethod GetModByLocScg(LocId As %String, ScgId As %String) As %String
{
	n (LocId,ScgId)
	s PtMod=""
	q:LocId="" ""
	&sql(select DHCLoc_BillPrtMode into :PtMod from DHCST_CtLoc where DHCLoc_Ctloc_dr=:LocId)
	i ScgId'="" d
	.s (PtModeId,PtMode)=""
	.&sql(select PRT_RowId,PRT_PrtMode into :PtModeId, :PtMode from DHC_StkLocBillPrintMode where PRT_CTLOC_DR=:LocId and PRT_SCG_DR=:ScgId)
	.i PtModeId'="" d
	..s PtMod=PtMode
	q PtMod
}

/// Description:发送科室信息到平台
/// Creator:	tsr
/// CreatDate:	2019-05-29
ClassMethod SendLocInfo(LocIdStr As %String) As %String
{
	n (LocIdStr)
	q:LocIdStr="" -1
	s ret=##class(web.DHCSTMHUI.ServiceForSCI).getHopLoc(LocIdStr)
	q ret
}

/// Description: 科室区分医院
/// Creater: lihui
/// CreateDate: 20200403
/// Table:		CT_Loc
/// Input:		科室Id,医院Id
/// Return:		0-属于;非零-不属于
/// w ##class(web.DHCSTMHUI.CTLOC).LocOfHosp(20,2)
ClassMethod LocOfHosp(Locid, HospId) As %String
{
	n (Locid,HospId,%session)
	q:Locid="" -1
	//q:HospId="" -2 院区为空不再过滤科室
	q:HospId="" 0
	s Param=""
	s IfFlowDBPConfig=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTCOMMONM","IfFlowDBPConfig",Param)
	s HospAutFlag=##class(web.DHCSTMHUI.MatForBDPData).GetHospAutFlag(HospId)
	s LocHospid=..sssHospId(Locid)
	q:(HospAutFlag="Y")&&(HospId'=LocHospid) -3
	q 0
}

}
