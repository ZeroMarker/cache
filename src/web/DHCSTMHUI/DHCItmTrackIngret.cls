Import sqluser

/// Descript:	未用高值退库退货
/// Creator:	lxt
/// CreateDate:	2018-09-28
Class web.DHCSTMHUI.DHCItmTrackIngret Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

ClassMethod jsCreatIngRet(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CreatIngRet(Main,Detail)
	q RtnObj.Json()
}

/// Descript:	生成退库退货单
/// Creator:	lxt
/// CreateDate:	2018-09-28
/// Table:		DHC_INistrf,dhc_ingdret
/// Input:		主单信息，明细信息
/// Return：	成功，失败
/// w ##class(web.DHCSTMHUI.DHCItmTrackIngret).CreatIngRet(^templxt("Main"),^templxt("Detail"))
ClassMethod CreatIngRet(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()

	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s MainSc=MainPJObj.%FromJSON(Main)
	i MainSc'=0 d RtnObj.Err(-1,"","入参解析失败!","",0) q RtnObj
	
	s DetailPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s DetailSc=DetailPJObj.%FromJSON(Detail)
	i DetailSc'=0 d RtnObj.Err(-12,"","入参解析失败!","",0) q RtnObj
	
	s FrLoc=MainPJObj.%Get("CurrLoc")
	s ToLoc=MainPJObj.%Get("PhaLoc")
	s Vendor=MainPJObj.%Get("Vendor")
	s StkScg=MainPJObj.%Get("StkScg")
	s gGroupId=MainPJObj.%Get("gGroupId")
	s gUserId=MainPJObj.%Get("gUserId")
	s gHospId=MainPJObj.%Get("gHospId")
	
	s MainInit="{""RowId"":"""",""InitFrLoc"":"""_FrLoc_""","
		_"""InitToLoc"":"""_ToLoc_""",""InitUser"":"""_gUserId_""","
		_"""InitScg"":"""_StkScg_""",""gGroupId"":"""_gGroupId_""","
		_"""gUserId"":"""_gUserId_""",""InitComp"":"""",""InitState"":""11""}"
	
	s MainRet="{""RowId"":"""",""RetLoc"":"""_ToLoc_""",""gHospId"":"""_gHospId_""","
		_"""Vendor"":"""_Vendor_""",""gUserId"":"""_gUserId_""","
		_"""ScgStk"":"""_StkScg_""",""AdjChequeFlag"":""0""}"
	
	s DetailInit=""
	s DetailRet=""
	while(RtnObj.success=0){
		s Obj=DetailPJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s InciId=$p(^DHCIT(RowId),"^",1)
		s HVBarCode=Obj.%Get("Label")
		;s Inclb=$p(^DHCIT(RowId),"^",12)
		s Inclb=Obj.%Get("Inclb")
		s Qty=Obj.%Get("Qty")
		s UomId=$p(^INCI(InciId,1),"^",10)
		
		s Dhcitd=$o(^DHCITD(RowId,"I",0))
		i Dhcitd=""  d tnObj.Err(-11,"","跟踪信息不能为空")
		q:RtnObj.success'=0
		s Ingri=$p(^DHCITD(RowId,"I",Dhcitd),"^",1)
		i Ingri="" d RtnObj.Err(-11,"","未入库不能退","",0)
		q:RtnObj.success'=0
		s Type=$p(^DHCITD(RowId,"I",Dhcitd),"^",2)
		i Type'="G" d RtnObj.Err(-11,"","未入库不能退","",0)
		q:RtnObj.success'=0
		
		s objItm=##class(User.DHCINGdRecItm).%OpenId(Ingri)
		s Rp=objItm.initmrealprice
		s Sp=objItm.initmsaleprice
		
		s Initi="{""RowId"":"""",""Inclb"":"""_Inclb_""",""Qty"":"""_Qty_""","
		s Initi=Initi_"""UomId"":"""_UomId_""",""HVBarCode"":"""_HVBarCode_"""}"
		i DetailInit=""  d
		.s DetailInit="["_Initi
		e  d
		.s DetailInit=DetailInit_","_Initi
		
		s Reti="{""RowId"":"""",""Ingri"":"""_Ingri_""",""Uom"":"""_UomId_""","
		s Reti=Reti_"""Qty"":"""_Qty_""",""Rp"":"""_Rp_""",""Sp"":"""_Sp_""","
		s Reti=Reti_"""HvBarCode"":"""_HVBarCode_"""}"
		i DetailRet=""  d
		.s DetailRet="["_Reti
		e  d
		.s DetailRet=DetailRet_","_Reti
	}
	i DetailInit'="" s DetailInit=DetailInit_"]"
	i DetailRet'="" s DetailRet=DetailRet_"]"
	ts	
	s Params1=gGroupId_"^"_FrLoc_"^"_gUserId_"^"_gHospId
	s AutoCompAfterSaveOUT=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTTRANSFERM","AutoCompAfterSaveOUT",Params1)
	s AutoAckOutAfterCompleted=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTTRANSFERM","AutoAckOutAfterCompleted",Params1)
	s AutoAckInAfterAckOut=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTTRANSFERM","AutoAckInAfterAckOut",Params1)
	s Params2=gGroupId_"^"_ToLoc_"^"_gUserId_"^"_gHospId
	s AutoCompAfterSaveDRET=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTRETURNM","AutoCompAfterSaveDRET",Params2)
	s AutoAuditAfterCompDRET=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTRETURNM","AutoAuditAfterCompDRET",Params2)
	
	s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).Save(MainInit,DetailInit)	//生成退库单
	i RtnObj.success<0 tro  q RtnObj
	s Init=RtnObj.rowid

	i AutoAckOutAfterCompleted'="Y" d
	.s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).TransOutAuditYes(Init,gUserId,"","Y")	//考虑参数设置不自动接收
	i RtnObj.success<0 tro  q RtnObj
	
	s RtnObj=##class(web.DHCSTMHUI.DHCINGdRet).Save(MainRet,DetailRet)		//生成退货单
	i RtnObj.success<0 tro  q RtnObj
	
	s Ingrt=RtnObj.rowid
	s IngrtStr="{""RowId"":"""_Ingrt_""",""gUserId"":"""_gUserId_""",""gGroupId"":"""_gGroupId_"""}"
	i AutoCompAfterSaveDRET'="Y" d
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRet).SetCompleted(IngrtStr)		//退货单完成
	i RtnObj.success<0 tro  q RtnObj
	
	i AutoAuditAfterCompDRET'="Y" d
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRet).Audit(IngrtStr)				//退货单审核
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	s RtnObj.rowid=Init_","_Ingrt  
	q RtnObj
}

/// Descript:	查询退库单主单信息
/// Creator:	lxt
/// CreateDate:	2018-09-28
/// Table:		DHC_InIsTrf
/// Input:		主单Id
/// Return：	查询退库单主单信息
/// w ##class(web.DHCSTMHUI.DHCItmTrackIngret).QueryInit(130)
ClassMethod QueryInit(Init) As %String
{
	n (Init)
	q:Init="" ""
	&sql(SELECT INIT_No,INIT_FrLoc_DR,INIT_ToLoc_DR,INIT_SCG_DR,INIT_Date,INIT_Time 
		into :InitNo,:InitFrLoc,:InitToLoc,:InitStkScg,:InitDate,:InitTime
		FROM DHC_InIsTrf WHERE INIT_RowId=:Init)
	s:InitFrLoc'="" InitFrLoc=$p(^CTLOC(InitFrLoc),"^",2)
	s:InitToLoc'="" InitToLoc=$p(^CTLOC(InitToLoc),"^",2)
	s:InitStkScg'="" InitStkScg=$p(^DHCSCG(InitStkScg),"^",2)
	s:+InitDate'=0 InitDate=..DL2H(InitDate)
	s:+InitTime'=0 InitTime=..DL2H(InitTime)
	
	s Data=Init_"^"_InitNo_"^"_InitFrLoc_"^"_InitToLoc_"^"_InitStkScg_"^"_InitDate_"^"_InitTime
	s Title="Init^InitNo^InitFrLoc^InitToLoc^InitStkScg^InitDate^InitTime"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// Descript:	查询退库单明细信息
/// Creator:	lxt
/// CreateDate:	2018-09-28
/// Table:		DHC_InIsTrfItm
/// Input:		主单Id
/// Return：	查询退库单明细信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCItmTrackIngret","QueryIniti",127)
Query QueryIniti(Init As %String) As Query(ROWSPEC = "RowId,InciId,InciCode,InciDesc,Inclb,Qty:%Float,UomId,UomDesc,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,BatNo,ExpDate,BatExp,Spec,ManfId,ManfDesc,HVBarCode") [ SqlProc ]
{
}

ClassMethod QueryInitiExecute(ByRef qHandle As %Binary, Init As %String) As %Status
{
	n (qHandle,Init)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Init="" $$$OK
	
	s SqlStr="SELECT INITI_RowId,INITI_INCLB_DR,INITI_Qty,INITI_CTUOM_DR,DHCITI_RealPrice,"
		_"DHCITI_RPAmount,DHCITI_SalePrice,DHCITI_SPAmount,initi_inclb_dr->inclb_incib_dr->incib_no batNo,initi_inclb_dr->inclb_incib_dr->incib_expdate expDate "
		_"FROM DHC_InIsTrfItm WHERE INITI_INIT_ParRef="_Init
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId=Result.Data("INITI_RowId")
		s Inclb=Result.Data("INITI_INCLB_DR")
		s Qty=Result.Data("INITI_Qty")
		s UomId=Result.Data("INITI_CTUOM_DR")
		s Rp=Result.Data("DHCITI_RealPrice")
		s RpAmt=Result.Data("DHCITI_RPAmount")
		s Sp=Result.Data("DHCITI_SalePrice")
		s SpAmt=Result.Data("DHCITI_SPAmount")
		s BatNo=Result.Data("batNo")
		s ExpDate=Result.Data("expDate")
		s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		s BatExp=BatNo_"~"_ExpDate
		s UomDesc=$p(^CT("UOM",UomId),"^",2)
		s InciId=+Inclb
		s InciCode=$P(^INCI(InciId,1),"^",1)
		s InciDesc=$P(^INCI(InciId,1),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
		s ManfId=$P(ManfInfo,"^",1)
		s ManfDesc=$P(ManfInfo,"^",2)
		s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("T",RowId)
		d OutPutRowIniti
	}
	Quit $$$OK
OutPutRowIniti
	s Data=$lb(RowId,InciId,InciCode,InciDesc,Inclb,Qty,UomId,UomDesc,Rp,RpAmt,Sp,SpAmt,BatNo,ExpDate,BatExp,Spec,ManfId,ManfDesc,HVBarCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询退货单主单信息
/// Creator:	lxt
/// CreateDate:	2018-09-28
/// Table:		DHC_INGDRET
/// Input:		主单Id
/// Return：	查询退货单主单信息
/// w ##class(web.DHCSTMHUI.DHCItmTrackIngret).QueryIngt(18)
ClassMethod QueryIngt(RetId) As %String
{
	n (RetId)
	q:RetId="" ""
	&sql(SELECT INGRT_NO, INGRT_APCVM_DR, INGRT_Date, INGRT_Time, INGRT_SCG_DR 
		into :RetNo,:RetVendor,:RetDate,:RetTime,:RetStkScg
		FROM DHC_INGDRET WHERE ID=:RetId)
	s:RetVendor'="" RetVendor=$p(^APC("APCVM",RetVendor),"^",3)
	s:RetStkScg'="" RetStkScg=$p(^DHCSCG(RetStkScg),"^",2)
	s:+RetDate'=0 RetDate=..DL2H(RetDate)
	s:+RetTime'=0 RetTime=..DL2H(RetTime)
	
	s Data=RetId_"^"_RetNo_"^"_RetVendor_"^"_RetStkScg_"^"_RetDate_"^"_RetTime
	s Title="RetId^RetNo^RetVendor^RetStkScg^RetDate^RetTime"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// Descript:	查询退货单明细信息
/// Creator:	lxt
/// CreateDate:	2018-09-28
/// Table:		DHC_INGRTITM
/// Input:		主单Id
/// Return：	查询退货单明细信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCItmTrackIngret","QueryIngti","")
Query QueryIngti(RetId As %String) As Query(ROWSPEC = "RowId,InciId,InciCode,InciDesc,Inclb,Qty:%Float,UomId,UomDesc,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,BatNo,ExpDate,BatExp,Spec,ManfId,ManfDesc,HVBarCode") [ SqlProc ]
{
}

ClassMethod QueryIngtiExecute(ByRef qHandle As %Binary, RetId As %String) As %Status
{
	n (qHandle,RetId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:RetId="" $$$OK
	
	s SqlStr="SELECT INGRTI_RowId,INGRTI_RetQty,INGRTI_RetUom_DR,INGRTI_RealPrice,INGRTI_RetAmount,"
		_"INGRTI_SalePrice,INGRTI_SpAmt,INGRTI_MEDRTITM_DR,INGRTI_MEDRTITM_DR->inclb_incib_dr->incib_no batNo,INGRTI_MEDRTITM_DR->inclb_incib_dr->incib_expdate expDate "
		_"FROM DHC_INGRTITM WHERE INGRTI_INGRT_Parref="_RetId
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId=Result.Data("INGRTI_RowId")
		s Inclb=Result.Data("INGRTI_MEDRTITM_DR")
		s Qty=Result.Data("INGRTI_RetQty")
		s UomId=Result.Data("INGRTI_RetUom_DR")
		s Rp=Result.Data("INGRTI_RealPrice")
		s RpAmt=Result.Data("INGRTI_RetAmount")
		s Sp=Result.Data("INGRTI_SalePrice")
		s SpAmt=Result.Data("INGRTI_SpAmt")
		s BatNo=Result.Data("batNo")
		s ExpDate=Result.Data("expDate")
		s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		s BatExp=BatNo_"~"_ExpDate
		s UomDesc=$p(^CT("UOM",UomId),"^",2)
		s InciId=+Inclb
		s InciCode=$P(^INCI(InciId,1),"^",1)
		s InciDesc=$P(^INCI(InciId,1),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
		s ManfId=$P(ManfInfo,"^",1)
		s ManfDesc=$P(ManfInfo,"^",2)
		s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("R",RowId)
		d OutPutRowIngti
	}
	Quit $$$OK
OutPutRowIngti
	s Data=$lb(RowId,InciId,InciCode,InciDesc,Inclb,Qty,UomId,UomDesc,Rp,RpAmt,Sp,SpAmt,BatNo,ExpDate,BatExp,Spec,ManfId,ManfDesc,HVBarCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
