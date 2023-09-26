Import sqluser

Class web.DHCSTMHUI.DHCINIsTrfAuxByRec Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询可用于出库的入库单
/// Creator:	wangjiabin
/// CreateDate:	2018-07-05
/// Input:		Params({StartDate:开始日期,EndDate:截止日期,RecLoc:入库科室,IngrNo:入库单号,TranFlag:包含已出库})
/// Output:		
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrfAuxByRec","QueryImportForTrans","","","{""RecLoc"":""392"",""gUserId"":""4642"",""gLocId"":""392"",""gGroupId"":""264"",""gHospId"":""2"",""StartDate"":""05/06/2018"",""RequestedLoc"":"""",""Vendor"":"""",""EndDate"":""05/07/2018"",""TranFlag"":""""}")
Query QueryImportForTrans(Params As %String) As Query(ROWSPEC = "RowId,IngrNo,Vendor,RecLoc,PoNo,CreateUser,CreateDate,ReqLoc,Status,StkGrpId,StkGrpDesc,HvFlag")
{
}

ClassMethod QueryImportForTransExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PRecLocId=PJObj.%Get("RecLoc")
	s PIngrNo=PJObj.%Get("IngrNo")
	s PVendorId=PJObj.%Get("Vendor")
	s PTranFlag=PJObj.%Get("TranFlag")
	
	s UserId=PJObj.%Get("gUserId")
	
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	q:PRecLocId="" $$$OK
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	s HospId=..sssHospId(PRecLocId)
	s StkGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,..sssCode(),PRecLocId,"",HospId)
	s result=##class(%Library.ResultSet).%New()
	s sqlStr="select INGR_RowId as RowId,INGR_No IngrNo,INGR_APCVM_DR,INGR_APCVM_DR->APCVM_Name as Vendor,INGR_Loc_Dr->CTLOC_Desc as RecLoc,"
		_"INGR_INPO_DR->INPO_No as PoNo,INGR_CreateUser->SSUSR_NAME AS CreateUser,INGR_CreateDate CreateDate,INGR_Completed Complete,INGR_AuditFlag AuditFlag,"
		_"INGR_SCG_DR,INGR_SCG_DR->SCG_Desc as StkGrp"
		_" from DHC_INGdRec where (INGR_CreateDate between "_PStartDate_" and "_PEndDate_") and INGR_Loc_Dr="_PRecLocId
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	s result.RuntimeMode=0
	s sc=result.Execute()
	If $$$ISERR(sc) q $$$OK
	While(result.Next())
	{
		s IngrId=result.Data("RowId")
		s IngrNo=result.Data("IngrNo")
		s Vendor=result.Data("Vendor")
		s VenId=result.Data("INGR_APCVM_DR")
		s RecLoc=result.Data("RecLoc")
		s RecLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(RecLoc)
		s PoNo=result.Data("PoNo")
		s CreateUser=result.Data("CreateUser")
		s CreateDate=result.Data("CreateDate")
		s CreateDate=..DL2H(CreateDate)
		s Complete=result.Data("Complete")
		continue:Complete'="Y"		;未完成的入库单不能出库
		s AuditFlag=result.Data("AuditFlag")
		continue:AuditFlag'="Y"		;未审核的入库单不能出库
		CONTINUE:(PIngrNo'="")&(IngrNo'=PIngrNo)
		CONTINUE:(PVendorId'="")&(VenId'=PVendorId)
		s StkGrpId=result.Data("INGR_SCG_DR")
		s StkGrpDesc=result.Data("StkGrp")
		CONTINUE:(StkGrpId'="")&&(StkGrpStr'="")&&(("^"_StkGrpStr_"^")'[("^"_StkGrpId_"^"))
		s Initstr=..GetInitByIngrId(IngrId)
		s Init=$p(Initstr,"^",1)
		s ReqLoc=$p(Initstr,"^",2)
		i Init="" d
		.s Status="未转移"
		e  d
		.s Status="已转移"
		continue:(PTranFlag'=1)&(Status="已转移")
		s HvFlag=##class(web.DHCSTMHUI.Common.UtilCommon).GetCertDocHVFlag(IngrId,"G")
		d OutPutRow
	}
	Quit $$$OK

OutPutRow
	s Data=$lb(IngrId,IngrNo,Vendor,RecLoc,PoNo, 
		CreateUser,CreateDate,ReqLoc,Status,StkGrpId,
		StkGrpDesc,HvFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:   根据入库单RowId取得入库单明细信息
/// Creater:zhangdongmei
/// CreateDate:2012-07-27
/// Input:开始行,一页显示记录数,排序字段,排序方向,入库主表id
/// Output:     
/// Return：入库子表id^批号^入库单位Id^入库单位^效期^批次id^入库数量^库存项id^库存项代码
/// ^库存项名称^生产厂家^进价^进价金额^售价^售价金额^批次库存量^占用数量^可用数量^基本单位Id
/// ^包装单位和基本单位转换率
/// d ##class(web.DHCSTMHUI.DHCINIsTrfAuxByRec).QueryImportDetailForTrans("391")
ClassMethod QueryImportDetailForTrans(Parref As %String) As %String
{
	n (Parref)
	q:Parref="" $$$OK

	s result = ##class(%Library.ResultSet).%New()
	s StrSql = "SELECT INGRI_Rowid as Rowid, INGRI_BatchNo, INGRI_CTUOM_DR, INGRI_ExpDate,"
		_"INGRI_INCLB_DR, INGRI_RecQty,initm_INCI_DR,initm_INCI_DR->INCI_Code as IncCode, "
		_"initm_INCI_DR->INCI_Desc as IncDesc,initm_phmnf_dr->PHMNF_Name as Manf,"
		_"initm_realprice,initm_realtotal,initm_saleprice, initm_SpAmt "
		_"FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef in ("_Parref_")"
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	If $$$ISERR(sc) q $$$NullJson
	s count = 0
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{
		s Ingri = result.Data("Rowid")
		s Ingr=$p(Ingri,"||",1)

		s BatchNo=result.Data("INGRI_BatchNo")
		s IngrUomId=result.Data("INGRI_CTUOM_DR")
		s IngrUom=""
		s:IngrUomId'="" IngrUom=$p(^CT("UOM",IngrUomId),"^",2)
		s ExpDate=result.Data("INGRI_ExpDate")
		s ExpDate=..DL2H(ExpDate)
		s BatExp=BatchNo_"~"_ExpDate
		s Inclb=result.Data("INGRI_INCLB_DR")
		s IngrQty = result.Data("INGRI_RecQty")
		s IncId = result.Data("initm_INCI_DR")
		s IncCode = result.Data("IncCode")
		s IncDesc = result.Data("IncDesc")
		s Manf = result.Data("Manf")
		s Rp = result.Data("initm_realprice")
		s RpAmt = result.Data("initm_realtotal")
		s Sp = result.Data("initm_saleprice")
		s SpAmt = result.Data("initm_SpAmt")
		s BUomId=$p(^INCI(IncId,1),"^",10)
		s PurUomId=$p(^INCI(IncId,3),"^",6)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
		s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(Inclb,+$h,IngrUomId)
		s DirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,IngrUomId)
		s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,IngrUomId)
		s InitQty=..GetInitQtyByIngri(Ingri)	//已转移数量
		s RecQty=IngrQty-InitQty //可转移数量
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(IncId)
		s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("G",Ingri)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
		s Data1=Ingri_"^"_BatchNo_"^"_IngrUomId_"^"_IngrUom_"^"_ExpDate_"^"_Inclb_"^"_RecQty_"^"_IncId_"^"_IncCode_"^"_IncDesc
		s Data2=Manf_"^"_Rp_"^"_RpAmt_"^"_Sp_"^"_SpAmt_"^"_BUomId_"^"_ConFac_"^"_StkQty_"^"_DirtyQty_"^"_AvaQty
		s Data3=BatExp_"^"_HVFlag_"^"_HVBarCode_"^"_InitQty_"^"_Spec
		s Data=Data1_"^"_Data2_"^"_Data3
		s count = count+1   
		d json.InsertRowData(Data)
	}
	s Title1="Ingri^BatchNo^UomId^UomDesc^ExpDate^Inclb^Qty:number^IncId^IncCode^IncDesc"
	s Title2="Manf^Rp:number^RpAmt:number^Sp:number^SpAmt:number^BUomId^ConFacPur:number^StkQty:number^DirtyQty:number^AvaQty:number"
	s Title3="BatExp^HVFlag^HVBarCode^InitQty:number^Spec"
	s Title=Title1_"^"_Title2_"^"_Title3
	d json.getJsonData(Title,count)
	k json
	q ""
}

/// 根据入库单id取出库单相关信息
ClassMethod GetInitByIngrId(Ingr)
{
	n (Ingr)
	q:Ingr="" ""

	s (Init,ReqLoc)=""
	s Init=$o(^DHCINIT(0,"INGR",Ingr,0))

	i Init="" d
	.s ch=""
	.f  s ch=$o(^DHCINGR(Ingr,"GRI",ch)) q:ch=""  d
	..s ingri=Ingr_"||"_ch
	..&sql(select INITI_INIT_ParRef into :Init from DHC_InIsTrfItm where INITI_INGRI_DR=:ingri)
	..q:Init'=""
	
	i Init'="" d
	.&sql(select INIT_ToLoc_DR->CTLOC_Desc into :ReqLoc from DHC_InIsTrf where %ID=:Init)
	.s ReqLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLoc)

	q Init_"^"_ReqLoc
}

/// w ##class(web.DHCSTMHUI.DHCINIsTrfAuxByRec).GetInitQtyByIngri("88||1")
ClassMethod GetInitQtyByIngri(Ingri)
{
	n (Ingri)
	q:Ingri="" ""
	s Qty=0
	s Init=""
	f  s Init=$o(^DHCINIT(0,"INGRI",Ingri,Init)) q:+Init=0  d
	.s InitCh=""
	.f  s InitCh=$o(^DHCINIT(0,"INGRI",Ingri,Init,InitCh)) q:+InitCh=0  d
	..s InitQty=$p(^DHCINIT(Init,"ITI",InitCh),"^",1)
	..q:InitQty'>0
	..s Qty=Qty+InitQty
	q Qty
}

}
