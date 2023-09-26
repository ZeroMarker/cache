Import sqluser

Class web.DHCSTMHUI.DHCINGdRetAuxByRec Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询入库单
/// Creater:	wangjiabin
/// CreateDate:	2015-07-28
/// Input:		开始行,一页显示记录数,排序字段,排序方向,
/// 			开始日期^截止日期^入库单号^供应商id^科室id^包含已退货, UserId
/// Output:     
/// Return:		入库主表id^入库单号^供应商^入库科室^请求科室^订单号^制单人^制单日期^出库状态
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINGdRetAuxByRec","QueryIngrForRet",^templxt("1111"))
Query QueryIngrForRet(Params As %String) As Query(ROWSPEC = "IngrId,IngrNo,VendorDesc,RecLoc,PoNo,CreateUser,CreateDate,ReqLoc,Status,ScgStk,StkGrpDesc,Vendor")
{
}

ClassMethod QueryIngrForRetExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s StartDate=PJobj.%Get("StartDate")
	s EndDate=PJobj.%Get("EndDate")
	s RecLocId=PJobj.%Get("RetLoc")
	s VendorId=PJobj.%Get("Vendor")	
	s IngrtFlag=PJobj.%Get("IngrtFlag")
	s HvFlag=PJobj.%Get("HvFlag")
	s User=PJobj.%Get("gUserId")
	s gHospId=PJobj.%Get("gHospId")
	s No=PJobj.%Get("No")
	s PInciId=PJobj.%Get("InciId")
	s PInciDesc=PJobj.%Get("InciDesc")
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	q:RecLocId="" $$$OK
	s pHospId=..sssHospId(RecLocId)
	s:pHospId="" pHospId=gHospId
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s StkGrp=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(User,..sssCode(),RecLocId,"",pHospId)
	
	s sqlStr = "select INGR_RowId as Rowid,INGR_No,INGR_APCVM_DR,INGR_APCVM_DR->APCVM_Name as Vendor,"_
		"INGR_Loc_Dr->CTLOC_Desc as RecLoc,INGR_INPO_DR->INPO_No as PoNo, ingr_reqloc_dr->CTLOC_Desc as ReqLoc,"_
		"INGR_CreateUser->SSUSR_NAME AS CreateUser, INGR_CreateDate,"_
		"INGR_Completed,INGR_AuditFlag,INGR_SCG_DR,INGR_SCG_DR->SCG_Desc as StkGrp "_
		"from DHC_INGdRec where (INGR_CreateDate between "_StartDate_" and "_EndDate_") and INGR_Loc_Dr="_RecLocId
	
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err q $$$OK
	While(result.Next())
	{
		s IngrId = result.Data("Rowid")
		s Flag=..IsExistInci(IngrId,PInciDesc)
		continue:Flag'="Y"
		s IngrNo = result.Data("INGR_No")
		s Vendor = result.Data("Vendor")
		s VenId=result.Data("INGR_APCVM_DR")
		s RecLoc = result.Data("RecLoc")
		s RecLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(RecLoc)
		s PoNo = result.Data("PoNo")
		s CreateUser = result.Data("CreateUser")
		s CreateDate = result.Data("INGR_CreateDate")
		s Complete = result.Data("INGR_Completed")
		continue:Complete'="Y"    ;未完成的入库单不能出库
		s ReqLoc = result.Data("ReqLoc")
		s ReqLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLoc)
		s Audit=result.Data("INGR_AuditFlag")
		continue:Audit'="Y"   ;未审核的入库单不能出库
		CONTINUE:(No'="")&(IngrNo'=No)
		CONTINUE:(VendorId'="")&(VenId'=VendorId)
		s StkGrpId=result.Data("INGR_SCG_DR")
		s StkGrpDesc=result.Data("StkGrp")
		CONTINUE:(StkGrp'="")&&(StkGrpId'="")&&(("^"_StkGrp_"^")'[("^"_StkGrpId_"^"))
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		
		s Status=..IsExistIngrt(IngrId)		;1:有退货单, 0:无退货单
		continue:(IngrtFlag=1)&&(Status'=1)
		continue:(IngrtFlag'=1)&&(Status=1)
		s Hv=##class(web.DHCSTMHUI.Common.UtilCommon).GetCertDocHVFlag(IngrId,"G")		;Y 高值, N 非高值
		continue:(HvFlag'=Hv)

		d OutPutRow1
	}
	Quit $$$OK

OutPutRow1
	s Data=$lb(IngrId,IngrNo,Vendor,RecLoc,PoNo,CreateUser,CreateDate,ReqLoc,Status,StkGrpId,StkGrpDesc,VenId)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	根据入库单RowId取得入库单明细信息
/// Creator:	wangjiabin
/// CreateDate:	2015-07-28
/// Input:		入库主表id
/// Output:     
/// Return：	入库子表id^批号^入库单位Id^入库单位^效期^批次id^入库数量^库存项id^库存项代码
/// ^库存项名称^生产厂家^进价^进价金额^售价^售价金额^批次库存量^占用数量^可用数量^基本单位Id
/// ^包装单位和基本单位转换率
Query QueryIngrDetailForRet(Parref As %String) As Query(ROWSPEC = "Ingri,BatchNo,Uom,UomDesc,ExpDate,Inclb,RecQty:%Float,IncId,IncCode,IncDesc,Manf,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,BUomId,ConFac:%Float,StkQty:%Float,DirtyQty:%Float,AvaQty:%Float,BatExp,HVFlag,HvBarCode")
{
}

ClassMethod QueryIngrDetailForRetExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	s StrSql = "SELECT INGRI_Rowid as Rowid, INGRI_BatchNo, INGRI_CTUOM_DR, INGRI_ExpDate,"
		_"INGRI_INCLB_DR, INGRI_RecQty,initm_INCI_DR,initm_INCI_DR->INCI_Code as IncCode, "
		_"initm_INCI_DR->INCI_Desc as IncDesc,initm_phmnf_dr->PHMNF_Name as Manf,"
		_"initm_realprice,initm_realtotal,initm_saleprice, initm_SpAmt "
		_"FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef= "_Parref
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err q $$$OK
	While(result.Next())
	{
		s Ingri = result.Data("Rowid")
		s BatchNo = result.Data("INGRI_BatchNo")
		s IngrUomId = result.Data("INGRI_CTUOM_DR")
		s IngrUom=""
		s:IngrUomId'="" IngrUom=$p(^CT("UOM",IngrUomId),"^",2)
		s ExpDate=result.Data("INGRI_ExpDate")
		s:+ExpDate'=0 ExpDate=..DL2H(ExpDate)
		s BatExp=BatchNo_"~"_ExpDate
		s Inclb=result.Data("INGRI_INCLB_DR")
		s RecQty = result.Data("INGRI_RecQty")
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
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(IncId)
		s HvBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("G",Ingri)
		
		;根据barcode状态,进行过滤
		s dhcit=$o(^DHCITD(0,"Type","G","Pointer",Ingri,0))
		s (dhcitInclb,dhcitCurrLoc,dhcitStatus,dhcitdType,isLastAudit)=""
		i dhcit'="" d
		.s dhcitStatus=$p(^DHCIT(dhcit),"^",5)
		.s dhcitInclb=$p(^DHCIT(dhcit),"^",12)
		.s:dhcitInclb'="" dhcitCurrLoc=$p(^INCI(+dhcitInclb,"IL",$p(dhcitInclb,"||",2)),"^",1)
		.s lastCh=$o(^DHCITD(dhcit,"I",""),-1)
		.q:lastCh=""
		.s dhcitdType=$p(^DHCITD(dhcit,"I",lastCh),"^",2)
		.s dhcitd=dhcit_"||"_lastCh
		.s lastAuditInfo=##class(web.DHCSTMHUI.DHCItmTrack).IsDetailAudit(dhcitd)
		.s isLastAudit=$p(lastAuditInfo,"^",1)
		;高值--不可用,已出库,最后明细未审核等情况, 均过滤
		continue:(HvBarCode'="")&&((dhcitStatus'="Enable")||(dhcitdType="T")||(isLastAudit="N"))
		s IngrLoc=$p(^DHCINGR(Parref),"^",13)
		continue:(HvBarCode'="")&&(dhcitCurrLoc'=IngrLoc)		;高值--条码当前科室不是入库科室的过滤
		d OutPutRow2
	}
	Quit $$$OK

OutPutRow2
	s Data=$lb(Ingri,BatchNo,IngrUomId,IngrUom,ExpDate,Inclb,RecQty,IncId,IncCode,IncDesc,Manf,Rp,RpAmt,Sp,SpAmt,BUomId,ConFac,StkQty,DirtyQty,AvaQty,BatExp,HVFlag,HvBarCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 判断入库明细是否有退货单存在
ClassMethod IsExistIngrt(ingr As %String) As %String
{
	n (ingr)
	s ret=0
	s ch=0
	f  s ch=$o(^DHCINGR(ingr,"GRI",ch)) q:(ch="")||(ret'=0)  d
	.s ingri=ingr_"||"_ch
	.s ingrt=$o(^INGRT(0,"INGRI",ingri,0))
	.s:ingrt'="" ret=1
	.q:ret'=0
	
	q ret
}

/// 判断入库明细是否该物资
ClassMethod IsExistInci(ingr As %String, incidesc As %String) As %String
{
	n (ingr,incidesc)
	q:incidesc="" "Y"
	q:ingr="" "Y"
	s flag="N"
	s ch=0
	f  s ch=$o(^DHCINGR(ingr,"GRI",ch)) q:(ch="")||(flag="Y")  d
	.s inci=$p(^DHCINGR(ingr,"GRI",ch),"^",25)
	.q:inci=""
	.s incDesc=$p($g(^INCI(inci,1)),"^",2)
	.i incDesc[incidesc s flag="Y" q 
	b ;
	q flag
}

}
