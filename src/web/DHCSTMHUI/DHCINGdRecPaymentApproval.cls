Import sqluser

/// 入库单付款审批
Class web.DHCSTMHUI.DHCINGdRecPaymentApproval Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询待审核入库\退货单信息
/// Creator: 	tsr
/// CreatDate: 	2018-06-08
/// Table: 		dhc_ingdrecitm,dhc_ingrtitm
/// Input: 		采购科室Id,Params对象
Query DHCGRApproval(Params As %String) As Query(ROWSPEC = "RowId,GRNo,Vendor,VendorDesc,CreateUser,CreateDate,AuditUser,AuditDate,AuditTime,ReqLocDesc,ScgDesc,Qty:%Float,RpAmt:%Float,SpAmt:%Float,AuditFlag,PayedFlag,Type") [ SqlProc ]
{
}

ClassMethod DHCGRApprovalExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s pIngrLoc=PJObj.%Get("IngrLoc")
	s pVendor=PJObj.%Get("Vendor")
	s pReqLoc=PJObj.%Get("ReqLoc")
	s pInvNo=PJObj.%Get("InvNo")
	s pAuditFlag=PJObj.%Get("AuditFlag")
	s pInvFlag=PJObj.%Get("InvFlag")
	s pHvFlag=PJObj.%Get("HvFlag")
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	q:pIngrLoc="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s StkType=..sssCode()
	
	//检索入库信息
	s SqlStr="select ingri_ingr_parref Ingr,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_no GRNo,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_apcvm_dr Vendor,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_apcvm_dr->apcvm_name VendorDesc,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_createdate CreateDate,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_createtime CreateTime,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_createuser->ssusr_name CreateUser,"
	s SqlStr=SqlStr_"initm_invno InvNo,"
	s SqlStr=SqlStr_"initm_INCI_DR Inci,"
	s SqlStr=SqlStr_"ingri_ingr_parref->INGR_ReqLoc_Dr ReqLoc,"
	s SqlStr=SqlStr_"ingri_ingr_parref->INGR_ReqLoc_Dr->CTLOC_Desc ReqLocDesc,"
	s SqlStr=SqlStr_"ingri_ingr_parref->INGR_PayAllowed AuditFlag,"
	s SqlStr=SqlStr_"ingri_ingr_parref->INGR_PayAllowUser->SSUSR_Name AuditUser,"
	s SqlStr=SqlStr_"ingri_ingr_parref->INGR_PayAllowDate AuditDate,"
	s SqlStr=SqlStr_"ingri_ingr_parref->INGR_PayAllowTime AuditTime,"
	s SqlStr=SqlStr_"ingri_ingr_parref->INGR_SCG_DR Scg"
	s SqlStr=SqlStr_" From dhc_ingdrecitm"
	s SqlStr=SqlStr_" where ingri_ingr_parref->ingr_date between "_StartDate_" and "_EndDate
	s SqlStr=SqlStr_" and ingri_ingr_parref->ingr_loc_dr="_pIngrLoc
	s SqlStr=SqlStr_" and ingri_ingr_parref->INGR_StkType='"_StkType_"'"
	i pVendor'="" d
	.s SqlStr=SqlStr_" and ingri_ingr_parref->ingr_apcvm_dr="_pVendor
	s xrs=##class(%ResultSet).%New()
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s Ingr=xrs.Data("Ingr")
		continue:$d(XAmt(Ingr))
		
		s IngrGiftFlag=$p(^DHCINGR(Ingr),"^",31)
		continue:(IngrGiftFlag="Y")		;过滤捐赠物资
		
		s InvNo=xrs.Data("InvNo")
		s Inci=xrs.Data("Inci")
		s ReqLoc=xrs.Data("ReqLoc")
		continue:(pReqLoc'="")&&(pReqLoc'=ReqLoc)
		s AuditFlag=xrs.Data("AuditFlag")
		s:AuditFlag="" AuditFlag="N"
		continue:(pAuditFlag'="")&&(pAuditFlag'=AuditFlag)
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
		continue:(pHvFlag'="")&&(pHvFlag'=HVFlag)
		continue:(pInvFlag="Y")&&(InvNo="")
		continue:(pInvFlag="N")&&(InvNo'="")
		continue:(pInvNo'="")&&(pInvNo'=InvNo)
		s ReqLocDesc=xrs.Data("ReqLocDesc")
		s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
		s GRNo=xrs.Data("GRNo")
		s Vendor=xrs.Data("Vendor")
		s VendorDesc=xrs.Data("VendorDesc")
		s Type="G"
		s CreateUser=xrs.Data("CreateUser")
		s CreateDate=xrs.Data("CreateDate")
		s CreateTime=xrs.Data("CreateTime")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		s AuditUser=xrs.Data("AuditUser")
		s AuditDate=xrs.Data("AuditDate")
		s AuditTime=xrs.Data("AuditTime")
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s:AuditTime'="" AuditTime=..TL2H(AuditTime)
		s Scg=xrs.Data("Scg")
		s ScgDesc=$s(Scg'="":$p(^DHCSCG(Scg),"^",2),1:"")
		s GRAmt=##class(web.DHCSTMHUI.DHCINGdRecInv).GetGRAmt(Ingr,Type)
		s RpAmt=$p(GRAmt,"^",1)
		s SpAmt= $p(GRAmt,"^",2)
		s Qty=$p(GRAmt,"^",3)
		s PayedAmt= ##class(web.DHCSTMHUI.DHCINGdRecInv).PayedAmt(Ingr,Type)
		s XAmt(Ingr)=RpAmt_"^"_SpAmt_"^"_Qty_"^"_PayedAmt
		s PayedFlag="N"
		i $zabs(PayedAmt)>=$zabs(RpAmt) s PayedFlag="Y"
		d OutPutRow
	}
	d xrs.Close()
	k XAmt
	
	//检索退货信息
	s SqlStr="select ingrti_ingrt_parref Ingr,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_no GRNo,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_apcvm_dr Vendor,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_apcvm_dr->apcvm_name VendorDesc,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_date CreateDate,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_time CreateTime,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_ssusr_dr->ssusr_name CreateUser,"
	s SqlStr=SqlStr_"ingrti_invno InvNo,"
	s SqlStr=SqlStr_"INGRTI_INGRI_DR Ingri,"
	s SqlStr=SqlStr_"INGRTI_INGRI_DR->initm_INCI_DR Inci,"
	s SqlStr=SqlStr_"INGRTI_INGRI_DR->ingri_ingr_parref->INGR_ReqLoc_Dr ReqLoc,"
	s SqlStr=SqlStr_"INGRTI_INGRI_DR->ingri_ingr_parref->INGR_ReqLoc_Dr->CTLOC_Desc ReqLocDesc,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_PayAllowed AuditFlag,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->INGRT_PayAllowUser_DR->SSUSR_Name AuditUser,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->INGRT_PayAllowDate AuditDate,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->INGRT_PayAllowTime AuditTime,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->INGRT_SCG_DR Scg"
	s SqlStr=SqlStr_" From dhc_ingrtitm"
	s SqlStr=SqlStr_" where ingrti_ingrt_parref->ingrt_auditdate between  "_StartDate_" and "_EndDate
	s SqlStr=SqlStr_" and  ingrti_ingrt_parref->ingrt_ctloc_Dr= "_pIngrLoc
	s SqlStr=SqlStr_" and  ingrti_ingrt_parref->INGRT_StkType= '"_StkType_"'"
	i pVendor'="" d
	.s SqlStr=SqlStr_" and ingrti_ingrt_parref->ingrt_apcvm_dr="_pVendor	
	s xrs=##class(%ResultSet).%New()
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s Ingr=xrs.Data("Ingr")
		continue:$d(XAmt(Ingr))
		
		s IngrtGiftFlag=..GetIngrtGiftFlag(Ingr)
		continue:(IngrtGiftFlag="Y")		;过滤均为捐赠物资的退货单
		
		s InvNo=xrs.Data("InvNo")
		s Inci=xrs.Data("Inci")
		s ReqLoc=xrs.Data("ReqLoc")
		continue:(pReqLoc'="")&&(pReqLoc'=ReqLoc)
		s AuditFlag=xrs.Data("AuditFlag")
		s:AuditFlag="" AuditFlag="N"
		continue:(pAuditFlag'="")&&(pAuditFlag'=AuditFlag)
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
		continue:(pHvFlag'="")&&(pHvFlag'=HVFlag)
		continue:(pInvFlag="Y")&&(InvNo="")
		continue:(pInvFlag="N")&&(InvNo'="")
		continue:(pInvNo'="")&&(pInvNo'=InvNo)
		s ReqLocDesc=xrs.Data("ReqLocDesc")
		s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
		s GRNo=xrs.Data("GRNo")
		s Vendor=xrs.Data("Vendor")
		s VendorDesc=xrs.Data("VendorDesc")
		s Type="R"
		s CreateUser=xrs.Data("CreateUser")
		s CreateDate=xrs.Data("CreateDate")
		s CreateTime=xrs.Data("CreateTime")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		s AuditUser=xrs.Data("AuditUser")
		s AuditDate=xrs.Data("AuditDate")
		s AuditTime=xrs.Data("AuditTime")
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s:AuditTime'="" AuditTime=..TL2H(AuditTime)
		s Scg=xrs.Data("Scg")
		s ScgDesc=$s(Scg'="":$p(^DHCSCG(Scg),"^",2),1:"")
		s GRAmt=##class(web.DHCSTMHUI.DHCINGdRecInv).GetGRAmt(Ingr,Type)
		s RpAmt=$p(GRAmt,"^",1)
		s SpAmt= $p(GRAmt,"^",2)
		s Qty=$p(GRAmt,"^",3)
		s PayedAmt= ##class(web.DHCSTMHUI.DHCINGdRecInv).PayedAmt(Ingr,Type)
		s XAmt(Ingr)=RpAmt_"^"_SpAmt_"^"_Qty_"^"_PayedAmt
		s PayedFlag="N"
		s RpAmt=-RpAmt
		s SpAmt=-SpAmt
		s Qty=-Qty
		i $zabs(PayedAmt)>=$zabs(RpAmt) s PayedFlag="Y"
		d OutPutRow
	} 

	Quit $$$OK
OutPutRow
	s Data=$lb(Ingr,GRNo,Vendor,VendorDesc,CreateUser,CreateDate,AuditUser,AuditDate,AuditTime,ReqLocDesc,ScgDesc,Qty,RpAmt,SpAmt,AuditFlag,PayedFlag,Type)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询待审核入库\退货单明细信息
/// Creator: 	tsr
/// CreatDate: 	2018-06-11
/// Table: 		dhc_ingdrecitm,dhc_ingrtitm
/// Input: 		业务单Id,业务类型
Query QueryDetail(Parref As %String, Type As %String) As Query(ROWSPEC = "RowId,IncId,Code,Description,Spec,UomDesc,BatchNo,ExpDate,Qty:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,InvAmt:%Float,InvNo,InvDate,Manf,SxNo,Type") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Parref As %String, Type As %String) As %Status
{
	n (qHandle,Parref,Type)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	q:Parref="" $$$OK

	//检索入库明细信息
	i Type="G"
	{
		s SqlStr = "SELECT INGRI_Rowid as RowId, INGRI_BatchNo, INGRI_CTUOM_DR, INGRI_ExpDate, INGRI_RecQty,"
			_"initm_INCI_DR, initm_INCI_DR->INCI_Code as IncCode, initm_INCI_DR->INCI_Desc as IncDesc,"
			_"initm_invmoney, initm_invno, initm_phmnf_dr, initm_phmnf_dr->PHMNF_Name as Manf,"
			_"initm_realprice, initm_realtotal, initm_saleprice, initm_SpAmt, initm_invdate, initm_sxno "
			_"FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef= "_Parref
		s result=##class(%ResultSet).%New()
		s result=##class(%Library.ResultSet).%New()
		d result.RuntimeModeSet(0)
		d result.Prepare(SqlStr)
		s sc=result.Execute()
		i $$$ISERR(sc) q $$$OK
		while (result.Next())
		{
			s RowId = result.Data("RowId")
			s IncId = result.Data("initm_INCI_DR")
			s Code = result.Data("IncCode")
			s Description = result.Data("IncDesc")
			s BatchNo = result.Data("INGRI_BatchNo")
			s UomId = result.Data("INGRI_CTUOM_DR")
			s UomDesc=$s(UomId'="":$p(^CT("UOM",UomId),"^",2),1:"")
			s ExpDate=result.Data("INGRI_ExpDate")
			s:ExpDate'="" ExpDate=..DL2H(ExpDate)
			s Qty = result.Data("INGRI_RecQty")
			s Rp = result.Data("initm_realprice")
			s RpAmt = result.Data("initm_realtotal")
			s Sp = result.Data("initm_saleprice")
			s SpAmt = result.Data("initm_SpAmt")
			s InvAmt = result.Data("initm_invmoney")
			s InvNo = result.Data("initm_invno")
			s InvDate = result.Data("initm_invdate")
			s:InvDate'="" InvDate=..DL2H(InvDate)
			s SxNo = result.Data("initm_sxno")
			s ManfId = result.Data("initm_phmnf_dr")
			s Manf = result.Data("Manf")
			s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)  
			d OutPutRowDetail
		}
		d result.Close()
	}
	
	i Type="R"
	{
		s SqlStr = "SELECT INGRTI_RowId AS RowId, INGRTI_INGRI_DR, INGRTI_INGRI_DR->initm_phmnf_dr->phmnf_name Manf,"
			_"INGRTI_RetQty, INGRTI_RetUom_DR, INGRTI_RetAmount, INGRTI_MEDRTITM_DR, INGRTI_Sxno,"
			_"INGRTI_RealPrice, INGRTI_SalePrice, INGRTI_SpAmt, INGRTI_InvNo, INGRTI_InvAmt, INGRTI_InvDate "
			_"FROM DHC_INGRTITM WHERE INGRTI_INGRT_Parref="_Parref
		s result=##class(%ResultSet).%New()
		s result=##class(%Library.ResultSet).%New()
		d result.RuntimeModeSet(0)
		d result.Prepare(SqlStr)
		s sc=result.Execute()
		i $$$ISERR(sc) q $$$OK
		while (result.Next())
		{
			s RowId = result.Data("RowId")
			s Ingri = result.Data("INGRTI_INGRI_DR")
			s IngrGiftFlag=$p(^DHCINGR(+Ingri),"^",31)
			continue:(IngrGiftFlag="Y")					;过滤捐赠物资
			s Inclb = result.Data("INGRTI_MEDRTITM_DR")
			s IncId = +Inclb
			s Code=$p($G(^INCI(IncId,1)),"^",1)
			s Description=$p($G(^INCI(IncId,1)),"^",2)
			s UomId = result.Data("INGRTI_RetUom_DR")
			s UomDesc=$s(UomId'="":$p(^CT("UOM",UomId),"^",2),1:"")
			s InclbObj=##class(User.INCItmLcBt).%OpenId(Inclb)
			s BatchNo=InclbObj.INCLBINCIBDR.INCIBNo
			s ExpDate=InclbObj.INCLBINCIBDR.INCIBExpDate
			s:ExpDate'="" ExpDate=..DL2H(ExpDate)
			s Qty = result.Data("INGRTI_RetQty")
			s Rp = result.Data("INGRTI_RealPrice")
			s RpAmt = result.Data("INGRTI_RetAmount")
			s Sp = result.Data("INGRTI_SalePrice")
			s SpAmt = result.Data("INGRTI_SpAmt")
			s InvAmt = result.Data("INGRTI_InvAmt")
			s InvNo = result.Data("INGRTI_InvNo")
			s InvDate = result.Data("INGRTI_InvDate")
			s:InvDate'="" InvDate=..DL2H(InvDate)
			s SxNo = result.Data("INGRTI_Sxno")
			s Manf = result.Data("Manf")
			s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)  
			d OutPutRowDetail
		}
		d result.Close()
	}
	Quit $$$OK

OutPutRowDetail
	s Data=$lb(RowId,IncId,Code,Description,Spec,UomDesc,BatchNo,ExpDate,Qty,Rp,RpAmt,Sp,SpAmt,InvAmt,InvNo,InvDate,Manf,SxNo,Type)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	多选查询待审核入库\退货单明细信息
/// Creator: 	lihui
/// CreatDate: 	20210323
/// Table: 		dhc_ingdrecitm,dhc_ingrtitm
/// Input: 		业务单Id,业务类型
Query QueryDetails(Params As %String) As Query(ROWSPEC = "RowId,IncId,Code,Description,Spec,UomDesc,BatchNo,ExpDate,Qty:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,InvAmt:%Float,InvNo,InvDate,Manf,SxNo,Type") [ SqlProc ]
{
}

ClassMethod QueryDetailsExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	;s ^litmp("QueryDetails")=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Parref=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
	//检索入库明细信息
	i Type="G"
	{
		s SqlStr = "SELECT INGRI_Rowid as RowId, INGRI_BatchNo, INGRI_CTUOM_DR, INGRI_ExpDate, INGRI_RecQty,"
			_"initm_INCI_DR, initm_INCI_DR->INCI_Code as IncCode, initm_INCI_DR->INCI_Desc as IncDesc,"
			_"initm_invmoney, initm_invno, initm_phmnf_dr, initm_phmnf_dr->PHMNF_Name as Manf,"
			_"initm_realprice, initm_realtotal, initm_saleprice, initm_SpAmt, initm_invdate, initm_sxno "
			_"FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef= "_Parref
		s result=##class(%ResultSet).%New()
		s result=##class(%Library.ResultSet).%New()
		d result.RuntimeModeSet(0)
		d result.Prepare(SqlStr)
		s sc=result.Execute()
		i $$$ISERR(sc) d RtnObj.Err(-1,RowId,"查询失败")
		q:RtnObj.success'=0
		while (result.Next())
		{
			s RowId = result.Data("RowId")
			s IncId = result.Data("initm_INCI_DR")
			s Code = result.Data("IncCode")
			s Description = result.Data("IncDesc")
			s BatchNo = result.Data("INGRI_BatchNo")
			s UomId = result.Data("INGRI_CTUOM_DR")
			s UomDesc=$s(UomId'="":$p(^CT("UOM",UomId),"^",2),1:"")
			s ExpDate=result.Data("INGRI_ExpDate")
			s:ExpDate'="" ExpDate=..DL2H(ExpDate)
			s Qty = result.Data("INGRI_RecQty")
			s Rp = result.Data("initm_realprice")
			s RpAmt = result.Data("initm_realtotal")
			s Sp = result.Data("initm_saleprice")
			s SpAmt = result.Data("initm_SpAmt")
			s InvAmt = result.Data("initm_invmoney")
			s InvNo = result.Data("initm_invno")
			s InvDate = result.Data("initm_invdate")
			s:InvDate'="" InvDate=..DL2H(InvDate)
			s SxNo = result.Data("initm_sxno")
			s ManfId = result.Data("initm_phmnf_dr")
			s Manf = result.Data("Manf")
			s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)  
			d OutPutRowDetails
		}
		d result.Close()
	}
	i Type="R"
	{
		s SqlStr = "SELECT INGRTI_RowId AS RowId, INGRTI_INGRI_DR, INGRTI_INGRI_DR->initm_phmnf_dr->phmnf_name Manf,"
			_"INGRTI_RetQty, INGRTI_RetUom_DR, INGRTI_RetAmount, INGRTI_MEDRTITM_DR, INGRTI_Sxno,"
			_"INGRTI_RealPrice, INGRTI_SalePrice, INGRTI_SpAmt, INGRTI_InvNo, INGRTI_InvAmt, INGRTI_InvDate "
			_"FROM DHC_INGRTITM WHERE INGRTI_INGRT_Parref="_Parref
		s result=##class(%ResultSet).%New()
		s result=##class(%Library.ResultSet).%New()
		d result.RuntimeModeSet(0)
		d result.Prepare(SqlStr)
		s sc=result.Execute()
		i $$$ISERR(sc) d RtnObj.Err(-1,RowId,"查询失败")
		q:RtnObj.success'=0
		while (result.Next())
		{
			s RowId = result.Data("RowId")
			s Ingri = result.Data("INGRTI_INGRI_DR")
			s IngrGiftFlag=$p(^DHCINGR(+Ingri),"^",31)
			continue:(IngrGiftFlag="Y")					;过滤捐赠物资
			s Inclb = result.Data("INGRTI_MEDRTITM_DR")
			s IncId = +Inclb
			s Code=$p($G(^INCI(IncId,1)),"^",1)
			s Description=$p($G(^INCI(IncId,1)),"^",2)
			s UomId = result.Data("INGRTI_RetUom_DR")
			s UomDesc=$s(UomId'="":$p(^CT("UOM",UomId),"^",2),1:"")
			s InclbObj=##class(User.INCItmLcBt).%OpenId(Inclb)
			s BatchNo=InclbObj.INCLBINCIBDR.INCIBNo
			s ExpDate=InclbObj.INCLBINCIBDR.INCIBExpDate
			s:ExpDate'="" ExpDate=..DL2H(ExpDate)
			s Qty = result.Data("INGRTI_RetQty")
			s Rp = result.Data("INGRTI_RealPrice")
			s RpAmt = result.Data("INGRTI_RetAmount")
			s Sp = result.Data("INGRTI_SalePrice")
			s SpAmt = result.Data("INGRTI_SpAmt")
			s InvAmt = result.Data("INGRTI_InvAmt")
			s InvNo = result.Data("INGRTI_InvNo")
			s InvDate = result.Data("INGRTI_InvDate")
			s:InvDate'="" InvDate=..DL2H(InvDate)
			s SxNo = result.Data("INGRTI_Sxno")
			s Manf = result.Data("Manf")
			s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)  
			d OutPutRowDetails
		}
		d result.Close()
	}
}
	Quit $$$OK
OutPutRowDetails
	s Data=$lb(RowId,IncId,Code,Description,Spec,UomDesc,BatchNo,ExpDate,Qty,Rp,RpAmt,Sp,SpAmt,InvAmt,InvNo,InvDate,Manf,SxNo,Type)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	审核入库单\退货单
/// Creator: 	tsr
/// CreatDate: 	2018-06-11
/// Table: 		DHC_InGdrec,DHC_InGdRet
/// Input: 		
ClassMethod Audit(Main As %String, Detail As %String) As %String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s gUserId=PJObj.%Get("gUserId")
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s params=..sssParamStr()
	s RecPayTrans=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTPAYM","RecPayTrans",params)
	
	tstart
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
		s Msg="审核失败!"
		i Type="G" d
		.s Ret=..AuditIng(RowId,gUserId,.Msg)
		i Type="R" d
		.s Ret=..AuditRet(RowId,gUserId,.Msg)
		i Ret'=0 s Sc=RtnObj.Err(-3,"",Msg)
		q:RtnObj.success'=0
		
		s ret=0
		i RecPayTrans=2 d
		.s ret=##class(web.DHCSTMHUI.DHCINGdRecInv).InsertPayTrans(RowId,Type)
		i ret'=0 d RtnObj.Err(-4,"","插入金额流水失败"_ret)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tcommit
	q RtnObj.Json()
}

/// Descript:	入库单付款审批
/// Creator: 	tsr
/// CreatDate: 	2018-06-11
/// Table: 		DHC_InGdrec
/// Input: 		入库主表Id,审核人Id
ClassMethod AuditIng(Ingr As %String, UserId As %String, Msg As %String) As %String
{
	n (Ingr,UserId,Msg)
	q:##class(web.DHCSTMHUI.Common.AppCommon).Lock(##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")_Ingr)<0 -99
	s AllowFlag=..AllowApproval(Ingr,.Msg)
	i AllowFlag<0 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")_Ingr) q -1
	s Allow="Y",AllowDate=+$h,AllowTime=$p($h,",",2)
	&sql(update DHC_InGdrec set INGR_PayAllowed=:Allow,INGR_PayAllowUser=:UserId,INGR_PayAllowDate=:AllowDate,INGR_PayAllowTime=:AllowTime
		where INGR_Rowid=:Ingr)
	i SQLCODE'=0 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")_Ingr) q -2
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")_Ingr)
	q 0
}

/// Descript:	退货单付款审批
/// Creator: 	tsr
/// CreatDate: 	2018-06-11
/// Table: 		DHC_InGdRet
/// Input: 		退货主表Id,审核人Id
ClassMethod AuditRet(Ingrt As %String, UserId As %String, Msg As %String) As %String
{
	n (Ingrt,UserId,Msg)
	q:##class(web.DHCSTMHUI.Common.AppCommon).Lock(##class(web.DHCSTMHUI.DHCINGdRet).%GetParameter("AppName")_Ingrt)<0 -99
	s AllowFlag=..AllowApprovalRet(Ingrt,.Msg)
	i AllowFlag<0  d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(##class(web.DHCSTMHUI.DHCINGdRet).%GetParameter("AppName")_Ingrt) q -1
	s Allow="Y",AllowDate=+$h,AllowTime=$p($h,",",2)
	&sql(update DHC_InGdRet set INGRT_PayAllowed=:Allow,INGRT_PayAllowDate=:AllowDate,INGRT_PayAllowTime=:AllowTime,INGRT_PayAllowUser_DR=:UserId
		where %ID=:Ingrt)
	i SQLCODE'=0 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(##class(web.DHCSTMHUI.DHCINGdRet).%GetParameter("AppName")_Ingrt) q -2
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(##class(web.DHCSTMHUI.DHCINGdRet).%GetParameter("AppName")_Ingrt)
	q 0
}

/// Descript:	判断入库单是否可付款审批
/// Creator: 	tsr
/// CreatDate: 	2018-06-11
/// Table: 		DHC_InGdrec
/// Input: 		入库主表Id
/// Return:		0-允许付款审批;-1-不存在此入库单;-2-此入库单未审核;-3-已付款审批
ClassMethod AllowApproval(Ingr As %String, Msg As %String) As %String
{
	n (Ingr,Msg)
	s (PayAllowed,AuditFlag)=""
	&sql(select ingr_payallowed,ingr_auditflag into :PayAllowed,:AuditFlag 
		From dhc_ingdrec where %id=:Ingr)
	i SQLCODE'=0 d
	.s Msg="不存在此入库单!"
	q:SQLCODE'=0 -1
	i AuditFlag'="Y" d
	.s Msg="此入库单未审核!"
	q:AuditFlag'="Y" -2
	i PayAllowed="Y" d
	.s Msg="此入库单已付款审批!"
	q:PayAllowed="Y" -3
	q 0
}

/// Descript:	判断退货单是否可付款审批
/// Creator: 	tsr
/// CreatDate: 	2018-06-11
/// Table: 		DHC_InGdRet
/// Input: 		退货主表Id
/// Return:		0-允许付款审批;-1-不存在此退货单;-2-此退货单未审核;-3-已付款审批
ClassMethod AllowApprovalRet(Ingrt As %String, Msg As %String) As %String
{
	n (Ingrt,Msg)
	s (PayAllowed,AuditFlag)=""
	&sql(select ingrt_payallowed,ingrt_auditflag into :PayAllowed,:AuditFlag 
	From dhc_ingdret where %id=:Ingrt)
	i SQLCODE'=0 d
	.s Msg="不存在此退货单!"
	q:SQLCODE'=0 -1
	i AuditFlag'="Y" d
	.s Msg="此退货单未审核!"
	q:AuditFlag'="Y" -2
	i PayAllowed="Y" d
	.s Msg="此退货单已付款审批!"
	q:PayAllowed="Y" -3
	q 0
}

/// Descript:	取消审核入库单\退货单
/// Creator: 	tsr
/// CreatDate: 	2018-06-11
/// Table: 		DHC_InGdrec,DHC_InGdRet
/// Input: 		
ClassMethod CanAudit(Detail As %String) As %String
{
	n (Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s params=..sssParamStr()
	s RecPayTrans=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTPAYM","RecPayTrans",params)
		
	tstart
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
		s Msg="取消审核失败!"
		i Type="G" d
		.s Ret=..CanAuditIng(RowId,.Msg)
		i Type="R" d
		.s Ret=..CanAuditRet(RowId,.Msg)
		i Ret'=0 s Sc=RtnObj.Err(-3,"",Msg)
		q:RtnObj.success'=0
		
		s ret=0
		i RecPayTrans=2 d
		.s ret=##class(web.DHCSTMHUI.DHCINGdRecInv).InsertPayTrans(RowId,Type)
		i ret'=0 d RtnObj.Err(-4,"","插入金额流水失败"_ret)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tcommit
	q RtnObj.Json()
}

/// Descript:	入库单取消付款审批
/// Creator: 	tsr
/// CreatDate: 	2018-06-11
/// Table: 		DHC_InGdrec
/// Input: 		入库主表Id
ClassMethod CanAuditIng(Ingr As %String, Msg As %String) As %String
{
	n (Ingr,Msg)
	q:##class(web.DHCSTMHUI.Common.AppCommon).Lock(##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")_Ingr)<0 -99
	s AllowFlag=..AllowCanAuditIng(Ingr,.Msg)
	i AllowFlag<0 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")_Ingr) q -1
	s PayAllowed=$p(^DHCINGR(Ingr),"^",22)
	i PayAllowed'="Y" d
	.s Msg="此入库单未付款审批!"
	q:PayAllowed'="Y" -2
	&sql(update DHC_InGdrec set INGR_PayAllowed=null,INGR_PayAllowUser=null,INGR_PayAllowDate=null,INGR_PayAllowTime=null
		where INGR_Rowid=:Ingr)
	i SQLCODE'=0 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")_Ingr) q -3
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")_Ingr)
	q 0
}

/// Descript:	退货单取消付款审批
/// Creator: 	tsr
/// CreatDate: 	2018-06-11
/// Table: 		DHC_InGdRet
/// Input: 		退货主表Id
ClassMethod CanAuditRet(Ingrt As %String, Msg As %String) As %String
{
	n (Ingrt,Msg)
	q:##class(web.DHCSTMHUI.Common.AppCommon).Lock(##class(web.DHCSTMHUI.DHCINGdRet).%GetParameter("AppName")_Ingrt)<0 -99
	s AllowFlag=..AllowCanAuditRet(Ingrt,.Msg)
	i AllowFlag<0 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(##class(web.DHCSTMHUI.DHCINGdRet).%GetParameter("AppName")_Ingrt) q -1
	s PayAllowed=$p(^INGRT(Ingrt),"^",12)
	i PayAllowed'="Y" d
	.s Msg="此退货单未付款审批!"
	q:PayAllowed'="Y" -2
	&sql(update DHC_InGdret set INGRT_PayAllowed=null,INGRT_PayAllowDate=null,INGRT_PayAllowTime=null,INGRT_PayAllowUser_DR=null
		where INGRT_Rowid=:Ingrt)
	i SQLCODE'=0 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(##class(web.DHCSTMHUI.DHCINGdRet).%GetParameter("AppName")_Ingrt) q -3
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(##class(web.DHCSTMHUI.DHCINGdRet).%GetParameter("AppName")_Ingrt)
	q 0
}

/// Descript:	判断入库单是否可取消付款审批
/// Creator: 	tsr
/// CreatDate: 	2018-06-11
/// Table: 		DHC_InGdrec
/// Input: 		入库主表Id
/// Return:		0-允许取消付款审批;-1-已制付款单
ClassMethod AllowCanAuditIng(Ingr As %String, Msg As %String) As %String
{
	n (Ingr,Msg)
	s Err=..IngrPayed(Ingr,"G")
	i Err'=0 d
	.s Msg="此入库单已制付款单!"
	q:Err'=0 -1
	q 0
}

/// Descript:	判断退货单是否可取消付款审批
/// Creator: 	tsr
/// CreatDate: 	2018-06-11
/// Table: 		DHC_InGdRet
/// Input: 		退货主表Id
/// Return:		0-允许取消付款审批;-1-已制付款单
ClassMethod AllowCanAuditRet(Ingrt As %String, Msg As %String) As %String
{
	n (Ingrt,Msg)
	s Err=..IngrPayed(Ingrt,"R")
	i Err'=0 d
	.s Msg="此退货单已制付款单!"
	q:Err'=0 -1
	q 0
}

/// Descript:	判断入库单\退货单是否有明细记录已经制付款单
/// Creator: 	tsr
/// CreatDate: 	2018-06-11
/// Table: 		DHC_InGdrec,DHC_InGdRet
/// Input: 		业务主表Id,业务类型
/// Return:		0-未制付款单;-1-已制付款单
ClassMethod IngrPayed(Ingr As %String, Type As %String) As %String
{
	n (Ingr,Type)
	s Err=0

	//入库
	i Type="G" d
	.s Ch=0
	.f  s Ch=$o(^DHCINGR(Ingr,"GRI",Ch)) q:(Ch="")!(Err'=0)  d
	..s Ingri=Ingr_"||"_Ch
	..s Pay=$o(^DHCPAY(0,"TYPEGR",Type,Ingri,""))
	..i Pay>0 s Err=-1

	//退货
	i Type="R" d
	.s Ch=0
	.f  s Ch=$o(^INGRT(Ingr,"DHCGRR",Ch)) q:(Ch="")!(Err'=0)  d
	..s Ingri=Ingr_"||"_Ch
	..s Pay=$o(^DHCPAY(0,"TYPEGR",Type,Ingri,""))
	..i Pay>0 s Err=-1

	q Err
}

/// Descript:	生成入库\退货凭证
/// Creator: 	tsr
/// CreatDate: 	2018-06-11
/// Table: 		DHC_InGdrec,DHC_InGdRet
ClassMethod CreateVoucher(Main As %String, Detail As %String, VoucherMonth As %String) As %String
{
	n (Main,Detail,VoucherMonth)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s IngrLoc=PJObj.%Get("IngrLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s gUserId=PJObj.%Get("gUserId")
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s VendorId="",RecRpAmt=0,RecSpAmt=0,RetRpAmt=0,RetSpAmt=0,RecIdStr="",RetIdStr=""
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
		s Vendor=Obj.%Get("Vendor")
		s GRNo=Obj.%Get("GRNo")
		i (VendorId'="")&&(VendorId'=Vendor) d RtnObj.Err(-3,"","供应商不相同!","",0)
		q:RtnObj.success'=0
		s VendorId=Vendor
		s RpAmt=Obj.%Get("RpAmt")
		s SpAmt=Obj.%Get("SpAmt")
		s checkflag=##class(web.DHCSTMHUI.DHCPayVoucher).CheckVoucher(Type,RowId)
		i checkflag=0 d RtnObj.Err(-4,"",GRNo_"已生成凭证!","",0)
		q:RtnObj.success'=0
		i Type="G" d
		.s RecRpAmt=RecRpAmt+RpAmt
		.s RecSpAmt=RecSpAmt+SpAmt
		.s RecIdStr=$s(RecIdStr="":RowId,1:RecIdStr_"^"_RowId)
		i Type="R" d
		.s RetRpAmt=RetRpAmt+RpAmt
		.s RetSpAmt=RetSpAmt+SpAmt
		.s RetIdStr=$s(RetIdStr="":RowId,1:RetIdStr_"^"_RowId)
	}
	q:RtnObj.success'=0 RtnObj.Json()
	s MainData=IngrLoc_"^"_VoucherMonth_"^"_gUserId_"^"_StartDate_"^"_EndDate_"^"_VendorId_"^"_RecRpAmt_"^"_RecSpAmt_"^"_RetRpAmt_"^"_RetSpAmt
	s ret=##class(web.DHCSTMHUI.DHCPayVoucher).InsertVoucher(MainData,RecIdStr,RetIdStr)
	i +ret<0 d RtnObj.Err(-5,"","生成凭证失败!")
	q RtnObj.Json()
}

/// 判断退货单全部为捐赠物资
/// Output:		Y:全部为捐赠物资, N:不全是捐赠物资
/// w ##class(web.DHCSTMHUI.DHCINGdRecPaymentApproval).GetIngrtGiftFlag(22)
ClassMethod GetIngrtGiftFlag(Ingrt) As %String
{
	n (Ingrt)
	q:Ingrt="" ""
	s Flag="Y"
	s Ch=0
	f  s Ch=$o(^INGRT(Ingrt,"DHCGRR",Ch)) q:(Ch="")||(Flag="N")  d
	.s Ingri=$p(^INGRT(Ingrt,"DHCGRR",Ch),"^",1)
	.q:Ingri=""
	.s Ingr=$p(Ingri,"||",1)
	.q:Ingr=""
	.s IngriGiftFlag=$p(^DHCINGR(Ingr),"^",31)
	.q:IngriGiftFlag="Y"
	.s Flag="N"
	
	q Flag
}

}
