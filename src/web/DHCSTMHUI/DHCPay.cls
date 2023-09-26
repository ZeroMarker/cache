Import sqluser

Class web.DHCSTMHUI.DHCPay Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTPAYM";

/// Descript:	查询付款单主信息
/// Creator: 	tsr
/// CreatDate: 	2018-05-24
/// Table: 		DHC_Pay
/// Input: 		采购科室Id,Params对象
Query DHCPay(LocId As %String, Params As %String) As Query(ROWSPEC = "RowId,PayNo,LocId,LocDesc,Vendor,VendorDesc,UserName,Date,Time,PayAmt:%Float,PurConfirm,PurConfirmUser,PurConfirmDate,AccConfirm,AccConfirmUser,AccConfirmDate,FinConfirm,FinConfirmUser,FinConfirmDate,Complete,PayMode,CheckNo,CheckDate,CheckAmt:%Float,PayModeId") [ SqlProc ]
{
}

ClassMethod DHCPayExecute(ByRef qHandle As %Binary, LocId As %String, Params As %String) As %Status
{
	n (qHandle,LocId,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:LocId="" $$$OK
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s pVendor=PJObj.%Get("Vendor")
	s pComplate=PJObj.%Get("Complate")
	s pPurAckFlag=PJObj.%Get("PurAckFlag")
	s pAccAckFlag=PJObj.%Get("AccAckFlag")
	s pFinAckFlag=PJObj.%Get("FinAckFlag")
	s pPayMode=PJObj.%Get("PayMode")
	s pGRNo=PJObj.%Get("GRNo")
	s pDateFlag=PJObj.%Get("DateFlag")  //日期查询类型
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s LocDesc=$p(^CTLOC(LocId),"^",2)
	s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
	
	s SqlStr="SELECT %ID RowId,"
	s SqlStr=SqlStr_"PAY_No PayNo,"
	s SqlStr=SqlStr_"PAY_APCVM_DR Vendor,"
	s SqlStr=SqlStr_"PAY_APCVM_DR->APCVM_NAME VendorDesc,"
	s SqlStr=SqlStr_"PAY_Date,"
	s SqlStr=SqlStr_"PAY_Time,"
	s SqlStr=SqlStr_"PAY_SSUSR_DR->SSUSR_NAME UserName,"
	s SqlStr=SqlStr_"PAY_Ack1 PurConfirm,"
	s SqlStr=SqlStr_"PAY_Date_Ack1 PurConfirmDate,"
	s SqlStr=SqlStr_"PAY_SSUSR_Ack1->SSUSR_NAME PurConfirmUser,"
	s SqlStr=SqlStr_"PAY_Ack2 AccConfirm,"
	s SqlStr=SqlStr_"PAY_Date_Ack2 AccConfirmDate,"
	s SqlStr=SqlStr_"PAY_SSUSR_Ack2->SSUSR_NAME AccConfirmUser,"
	s SqlStr=SqlStr_"PAY_Completed Complete,"
	s SqlStr=SqlStr_"PAY_Mode PayMode,"
	s SqlStr=SqlStr_"PAY_CheckNo CheckNo,"
	s SqlStr=SqlStr_"PAY_CheckDate CheckDate,"
	s SqlStr=SqlStr_"PAY_CheckAmt CheckAmt,"
	s SqlStr=SqlStr_"PAY_Ack11 FinConfirm,"
	s SqlStr=SqlStr_"PAY_Date_Ack11 FinConfirmDate,"
	s SqlStr=SqlStr_"PAY_SSUSR_Ack11->SSUSR_NAME FinConfirmUser"
	s SqlStr=SqlStr_" FROM SQLUser.DHC_Pay WHERE PAY_CTLOC_DR="_LocId
	i pDateFlag="" d
	.s SqlStr=SqlStr_" AND PAY_Date BETWEEN "_StartDate_" AND "_EndDate
	e  i pDateFlag=1  d
	.s SqlStr=SqlStr_" AND PAY_Date_Ack1 BETWEEN "_StartDate_" AND "_EndDate
	e  i pDateFlag=2  d
	.s SqlStr=SqlStr_" AND PAY_Date_Ack2 BETWEEN "_StartDate_" AND "_EndDate
	e  i pDateFlag=3  d
	.s SqlStr=SqlStr_" AND PAY_Date_Ack11 BETWEEN "_StartDate_" AND "_EndDate
	i pVendor'="" d
	.s SqlStr=SqlStr_" AND PAY_APCVM_DR="_pVendor
	i pComplate'="" d
	.s SqlStr=SqlStr_" AND NVL(PAY_Completed,'N')="_"'"_pComplate_"'"
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s PayNo=xrs.Data("PayNo")
		s Vendor=xrs.Data("Vendor")
		s VendorDesc=xrs.Data("VendorDesc")
		s UserName=xrs.Data("UserName")
		s Date=xrs.Data("PAY_Date")
		s:Date'="" Date=..DL2H(Date)
		s Time=xrs.Data("PAY_Time")
		s:Time'="" Time=..TL2H(Time)
		s PayAmt=..PayAmt(RowId)
		s PurConfirm=xrs.Data("PurConfirm")
		s AccConfirm=xrs.Data("AccConfirm")
		s FinConfirm=xrs.Data("FinConfirm")
		s:PurConfirm="" PurConfirm="N"
		s:AccConfirm="" AccConfirm="N"
		s:FinConfirm="" FinConfirm="N"
		continue:(pPurAckFlag'="")&&(pPurAckFlag'=PurConfirm)
		continue:(pAccAckFlag'="")&&(pAccAckFlag'=AccConfirm)
		continue:(pFinAckFlag'="")&&(pFinAckFlag'=FinConfirm)
		s PurConfirmUser=xrs.Data("PurConfirmUser")
		s PurConfirmDate=xrs.Data("PurConfirmDate")
		s:PurConfirmDate'="" PurConfirmDate=..DL2H(PurConfirmDate)
		s AccConfirmUser=xrs.Data("AccConfirmUser")
		s AccConfirmDate=xrs.Data("AccConfirmDate")
		s:AccConfirmDate'="" AccConfirmDate=..DL2H(AccConfirmDate)
		s FinConfirmUser=xrs.Data("FinConfirmUser")
		s FinConfirmDate=xrs.Data("FinConfirmDate")
		s:FinConfirmDate'="" FinConfirmDate=..DL2H(FinConfirmDate)
		s Complete=xrs.Data("Complete")
		s PayModeId=xrs.Data("PayMode")
		continue:(pPayMode'="")&&(pPayMode'=PayModeId)
		;s:PayMode'="" PayMode=$p(^DHCPAYMODE(PayMode),"^",2)
		//付款方式由dhc_paymode改为ct_paymode
		s PayMode=""
		s:PayModeId'="" PayMode=$p(^CT("CTPM",PayModeId),"^",2)
		s GRNoFlag=##class(web.DHCSTMHUI.DHCPay).FindpayByIngrno(RowId,pGRNo)
		continue:(pGRNo'="")&&(GRNoFlag'=1)
		s CheckNo=xrs.Data("CheckNo")
		s CheckAmt=xrs.Data("CheckAmt")
		s CheckDate=xrs.Data("CheckDate")
		s:CheckDate'="" CheckDate=..DL2H(CheckDate)
		d OutPutPayRow 
	}
	d xrs.Close()
	Quit $$$OK
OutPutPayRow
	s Data=$lb(RowId,PayNo,LocId,LocDesc,Vendor,VendorDesc,UserName,Date,Time,PayAmt,PurConfirm,PurConfirmUser,PurConfirmDate,AccConfirm,AccConfirmUser,AccConfirmDate,FinConfirm,FinConfirmUser,FinConfirmDate,Complete,PayMode,CheckNo,CheckDate,CheckAmt,PayModeId)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	取付款单应付总金额
/// Creator: 	tsr
/// CreatDate: 	2018-05-28
/// Table: 		DHC_PayItm
ClassMethod PayAmt(Pay As %String) As %String
{
	n (Pay)
	s Amt=0
	&sql(SELECT sum(payi_payamt) into :Amt from DHC_PayItm where payi_pay_parref=:Pay)
	q Amt
}

/// 
/// Descript:	根据入库\退货单号查询是否存在付款单
/// Creator: 	tsr
/// CreatDate: 	2018-05-28
/// Table: 		DHC_PayItm
/// Input:		付款单Id,业务单号
/// Return:		0-不存在;1-存在
ClassMethod FindpayByIngrno(PayId As %String, GRNo As %String) As %String
{
	n (PayId,GRNo)
	q:PayId="" ""
	q:GRNo="" ""
	s Ch=""
	s ExitFlag=0
	f  s Ch=$o(^DHCPAY(PayId,"I",Ch)) q:((Ch="")||(ExitFlag=1))  d
	.s GRI=$p(^DHCPAY(PayId,"I",Ch),"^",2)
	.s Ingr=+GRI
	.s IngrNo=$p($g(^DHCINGR(Ingr)),"^",1)
	.s IngrtNo=$p($g(^INGRT(Ingr)),"^",1)
	.s:(((IngrNo'="")&&(IngrNo=GRNo))||((IngrtNo'="")&&(IngrtNo=GRNo))) ExitFlag=1
	q ExitFlag
}

/// Descript:	根据付款单ID查询付款单主信息
/// Creator: 	tsr
/// CreatDate: 	2018-05-28
/// Table: 		DHC_Pay
/// Input: 		付款单主表RowId
ClassMethod Select(Pay As %String) As %String
{
	n (Pay)
	s Result=""
	&sql(select PAY_Rowid,PAY_No,PAY_APCVM_DR,PAY_CTLOC_DR,PAY_Date,
		PAY_Time,PAY_SSUSR_DR,PAY_Mode,PAY_Ack1,PAY_Ack2,
		PAY_CheckNo,PAY_CheckDate,PAY_CheckAmt,PAY_Date_Ack1,PAY_Date_Ack2,
		PAY_SSUSR_Ack1,PAY_SSUSR_Ack2,PAY_DateExpected,PAY_PoisonFlag,PAY_Completed,
		PAY_CertifiedNo,PAY_Remarks
		into
		RowId,PayNo,Vendor,IngrLoc,PayDate,
		PayTime,PayUser,PayMode,PurConfirm,AccConfirm,
		CheckNo,CheckDate,CheckAmt,PurConfirmDate,AccConfirmDate,
		PurUser,AccUser,DateExpected,PoisonFlag,Comp,
		CertifiedNo,Remarks
		from DHC_Pay where %ID=:Pay)
	q:SQLCODE'=0 Result
	s:PayDate'="" Date=..DL2H(PayDate)
	s:CheckDate'="" CheckDate=..DL2H(CheckDate)
	s:PurConfirmDate'="" PurConfirmDate=..DL2H(PurConfirmDate)
	s:AccConfirmDate'="" AccConfirmDate=..DL2H(AccConfirmDate)
	s:PayTime'="" Time=..TL2H(PayTime)
	s (UserName,PurUserName,AccUserName,VendorDesc,IngrLocDesc)=""
	s:PayUser'="" UserName=$p($G(^SSU("SSUSR",PayUser)),"^",2)
	s:PurUser'="" PurUserName=$p($G(^SSU("SSUSR",PurUser)),"^",2)
	s:AccUser'="" AccUserName=$p($G(^SSU("SSUSR",AccUser)),"^",2)
	s:Vendor'="" VendorDesc=$p($g(^APC("APCVM",Vendor)),"^",3)
	s:IngrLoc'="" IngrLocDesc=$p($g(^CTLOC(IngrLoc)),"^",2)
	
	s Data=RowId_"^"_PayNo_"^"_Vendor_"^"_IngrLoc_"^"_Date
		_"^"_Time_"^"_PayUser_"^"_PayMode_"^"_PurConfirm_"^"_AccConfirm
		_"^"_CheckNo_"^"_CheckDate_"^"_CheckAmt_"^"_PurConfirmDate_"^"_AccConfirmDate
		_"^"_PurUser_"^"_AccUser_"^"_DateExpected_"^"_PoisonFlag_"^"_Comp
		_"^"_UserName_"^"_PurUserName_"^"_AccUserName_"^"_VendorDesc_"^"_IngrLocDesc
		_"^"_CertifiedNo_"^"_Remarks
	s Title="RowId^PayNo^Vendor^IngrLoc^Date"
		_"^Time^PayUser^PayMode^PurConfirm^AccConfirm"
		_"^CheckNo^CheckDate^CheckAmt^PurConfirmDate^AccConfirmDate"
		_"^PurUser^AccUser^DateExpected^PoisonFlag^Comp"
		_"^UserName^PurUserName^AccUserName^VendorDesc^IngrLocDesc"
		_"^CertifiedNo^Remarks"
	s Result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Result
}

/// Descript:	查询待付款供应商信息
/// Creator: 	tsr
/// CreatDate: 	2018-05-28
/// Table: 		DHC_INGdRecItm,DHC_INGRTITM
/// Input: 		Params对象
Query VendorListToPay(LocId As %String, Params As %String) As Query(ROWSPEC = "RowId,VendorDesc")
{
}

ClassMethod VendorListToPayExecute(ByRef qHandle As %Binary, LocId As %String, Params As %String) As %Status
{
	n (qHandle,LocId,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:LocId="" $$$OK
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s StartDate=PJObj.%Get("FPStartDate")
	s EndDate=PJObj.%Get("FPEndDate")
	s pVendor=PJObj.%Get("FPVendor")
	s pInvNo=PJObj.%Get("InvNo")
	s gHospId=PJObj.%Get("gHospId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gUserId=PJObj.%Get("gUserId")
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s AppName=##class(web.DHCSTMHUI.DHCPay).%GetParameter("AppName")
	s Param=gGroupId_"^"_LocId_"^"_gUserId_"^"_gHospId
	s ApprovalFlag=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"ApprovalFlag",Param)	//是否需要审批后付款

	K ^TMP($J)
	//入库供应商列表
	s SqlStr="SELECT %ID Ingri,"
	s SqlStr=SqlStr_"INGRI_INGR_ParRef->INGR_APCVM_DR Vendor,"
	s SqlStr=SqlStr_"INGRI_INGR_ParRef->INGR_APCVM_DR->APCVM_NAME VendorDesc" 
	s SqlStr=SqlStr_" FROM DHC_INGdRecItm"  
	s SqlStr=SqlStr_" WHERE INGRI_INGR_ParRef->INGR_Date BETWEEN "_StartDate_" AND "_EndDate    
	s SqlStr=SqlStr_" AND INGRI_INGR_ParRef->INGR_Loc_Dr="_LocId  
	i pVendor'="" d
	.s SqlStr=SqlStr_" AND INGRI_INGR_ParRef->INGR_APCVM_DR="_pVendor
	i ApprovalFlag="1" d
	.s SqlStr=SqlStr_" AND INGRI_INGR_ParRef->INGR_PayAllowed='Y'"
	i pInvNo'="" d
	.s SqlStr=SqlStr_" AND initm_invno LIKE '%"_pInvNo_"%'"

	s xrs=##class(%ResultSet).%New()
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s Ingri=xrs.Data("Ingri")
		s Vendor=xrs.Data("Vendor")
		s VendorDesc=xrs.Data("VendorDesc")
		s Type="G"
		continue:..PayOver(Type,Ingri)=1
		i '$d(^TMP($J,Vendor)) d
		.s ^TMP($J,Vendor)=VendorDesc
	}
	d xrs.Close()
	//退货供应商列表
	s RetType=..sssCode()
	s SqlStr="SELECT %ID Ingr,"
	s SqlStr=SqlStr_"INGRTI_INGRT_Parref->INGRT_APCVM_DR Vendor,"
	s SqlStr=SqlStr_"INGRTI_INGRT_Parref->INGRT_APCVM_DR->APCVM_NAME VendorDesc"
	s SqlStr=SqlStr_" FROM DHC_INGRTITM"
	s SqlStr=SqlStr_" WHERE INGRTI_INGRT_Parref->INGRT_AuditDate BETWEEN "_StartDate_" AND "_EndDate
	s SqlStr=SqlStr_" AND INGRTI_INGRT_Parref->INGRT_CTLOC_DR="_LocId
	s SqlStr=SqlStr_" AND INGRTI_INGRT_Parref->INGRT_StkType='"_RetType_"'"
	i pVendor'="" d
	.s SqlStr=SqlStr_" AND INGRTI_INGRT_Parref->INGRT_APCVM_DR="_pVendor
	i ApprovalFlag="1" d
	.s SqlStr=SqlStr_" AND INGRTI_INGRT_Parref->INGRT_PayAllowed='Y'"
	i pInvNo'="" d
	.s SqlStr=SqlStr_" AND INGRTI_InvNo like '%"_pInvNo_"%'"

	s xrs=##class(%ResultSet).%New()
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s Ingr=xrs.Data("Ingr")
		s Vendor=xrs.Data("Vendor")
		s VendorDesc=xrs.Data("VendorDesc")
		s Type="R"
		continue:..PayOver(Type,Ingr)=1
		i '$d(^TMP($J,Vendor)) d
		.s ^TMP($J,Vendor)=VendorDesc
	}
	d xrs.Close()
	s RowId="" 
	f  s RowId=$o(^TMP($J,RowId)) q:RowId=""  d
	.S VendorDesc=$g(^TMP($J,RowId))
	.d OutPutVendorRow
	K ^TMP($J)
	Q $$$OK
OutPutVendorRow
	s Data=$lb(RowId,VendorDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	判断入库/退货记录是否结清
/// Creator: 	tsr
/// CreatDate: 	2018-05-29
/// Table: 		DHC_Pay
/// Input: 		业务类型,业务RowId
/// Return:		1-结清;0-未结清
ClassMethod PayOver(Type, Ingri As %String) As %String
{
	n (Type,Ingri)
	s Pay=$O(^DHCPAY(0,"TYPEGR",Type,Ingri,""),-1)
	q:Pay="" 0
	s Ch=$O(^DHCPAY(0,"TYPEGR",Type,Ingri,Pay,""),-1)
	q:Ch="" 0
	s Over=$P(^DHCPAY(Pay,"I",Ch),"^",7)
	i Over="Y" q 1
	q 0
}

/// Descript:	查询入库/退货明细记录
/// Creator: 	tsr
/// CreatDate: 	2018-05-29
/// Table: 		DHC_INGdRecItm,DHC_INGRTITM
/// Input: 		科室Id,供应商Id,Params
/// Return:		
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPay","GetItmToPay","163","7","{""FPStartDate"":""2022-01-24"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""57812"",""FPVendor"":"""",""PayMode"":"""",""FPEndDate"":""2022-10-24"",""PayRatio"":"""",""InvNo"":"""",""TotalAmt"":""""}")
Query GetItmToPay(LocId As %String, Vendor As %String, Params As %String) As Query(ROWSPEC = "RowId,No,Date,Time,UserName,Inclb,Inci,Code,Description,Spec,Manf,UomDesc,Qty:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,PayedAmt:%Float,RestAmt:%Float,InvNo,InvAmt:%Float,InvDate,InsxNo,BatNo,ExpDate,Type,PayAmt:%Float") [ SqlProc ]
{
}

ClassMethod GetItmToPayExecute(ByRef qHandle As %Binary, LocId As %String, Vendor As %String, Params As %String) As %Status
{
	n (qHandle,LocId,Vendor,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	q:LocId="" $$$OK 
	q:Vendor="" $$$OK
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s StartDate=PJObj.%Get("FPStartDate")
	s EndDate=PJObj.%Get("FPEndDate")
	s pInvNo=PJObj.%Get("InvNo")
	s gHospId=PJObj.%Get("gHospId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gUserId=PJObj.%Get("gUserId")
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s AppName=##class(web.DHCSTMHUI.DHCPay).%GetParameter("AppName")
	s Param=gGroupId_"^"_LocId_"^"_gUserId_"^"_gHospId
	s ApprovalFlag=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"ApprovalFlag",Param)	//是否需要审批后付款	s sql="select ingri_ingr_parref ingr,"
	
	//入库明细
	s SqlStr="select ingri_ingr_parref ingr,"
		_"ingri_ingr_parref->ingr_no gdNo,"
		_"ingri_ingr_parref->ingr_apcvm_dr->apcvm_name venName,"
		_"ingri_ingr_parref->ingr_date gdDate,"
		_"ingri_ingr_parref->ingr_time gdTime,"
		_"ingri_ingr_parref->ingr_ssusr_dr->ssusr_name gdUserName,"
		_"ingri_rowid ingri,"
		_"ingri_inclb_dr inclb,"
		_"ingri_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_code inciCode,"
		_"ingri_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_desc inciDesc,"
		_"initm_inci_dr inci,"
		_"initm_phmnf_dr->phmnf_name manf,"
		_"ingri_inclb_dr->inclb_incib_dr->incib_no batNo,"
		_"ingri_inclb_dr->inclb_incib_dr->incib_expdate expDate,"
		_"ingri_ctuom_dr->ctuom_desc uomDesc,"
		_"ingri_recqty qty,"
		_"initm_realprice rp,"
		_"initm_realtotal rpAmt,"
		_"initm_saleprice sp,"
		_"initm_spamt spAmt,"
		_"initm_invno invNo,"
		_"initm_invdate invDate,"
		_"initm_invmoney invAmt,"
		_"initm_sxno sxNo"
		_" From dhc_ingdrecitm"
		_" where ingri_ingr_parref->ingr_date between "_StartDate_" and "_EndDate
		_" and ingri_ingr_parref->ingr_loc_dr="_LocId
		_" and ingri_ingr_parref->ingr_apcvm_dr="_Vendor
	i ApprovalFlag="1" d
	.s SqlStr=SqlStr_" and ingri_ingr_parref->ingr_payallowed='Y'"
	s xrs=##class(%ResultSet).%New()
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s Ingr=xrs.Data("ingr")
		s No=xrs.Data("gdNo")
		s Date=xrs.Data("gdDate")
		s:Date'="" Date=..DL2H(Date)
		s Time=xrs.Data("gdTime")
		s:Time'="" Time=..TL2H(Time)
		s UserName=xrs.Data("gdUserName")
		s Ingri=xrs.Data("ingri")
		continue:..PayOver("G",Ingri)
		s Inclb=xrs.Data("inclb")
		s Inci=xrs.Data("inci")
		s Code=xrs.Data("inciCode")
		s Description=xrs.Data("inciDesc")
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
		s Manf=xrs.Data("manf")
		s UomDesc=xrs.Data("uomDesc")
		s Qty=xrs.Data("qty")
		s Rp=xrs.Data("rp")
		s RpAmt=xrs.Data("rpAmt")
		s Sp=xrs.Data("sp")
		s SpAmt=xrs.Data("spAmt")
		s PayedAmt=##class(web.DHCSTMHUI.DHCINGdRecInv).PayedAmtRecItm(Ingri)
		s RestAmt=RpAmt-PayedAmt   //待付金额
		s InvNo=xrs.Data("invNo")
		continue:(pInvNo'="")&&(InvNo'=pInvNo)
		s InvAmt=xrs.Data("invAmt")
		s InvDate=xrs.Data("invDate")
		s:InvDate'="" InvDate=..DL2H(InvDate)
		s InsxNo=xrs.Data("sxNo")
		s BatNo=xrs.Data("batNo")
		s ExpDate=xrs.Data("expDate")
		s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		s PayAmt=RestAmt
		d OutPutIngrItmRow
	}
	d xrs.Close()

	//退货明细
	s SqlStr="select ingrti_ingrt_parref ingrt,"
		_" ingrti_ingrt_parref->ingrt_no gdNo,"
		_" ingrti_ingrt_parref->ingrt_apcvm_dr vendor,"
		_" ingrti_ingrt_parref->ingrt_apcvm_dr->apcvm_name vendorName,"
		_" ingrti_ingrt_parref->ingrt_date createDate,"
		_" ingrti_ingrt_parref->ingrt_time createTime,"
		_" ingrti_ingrt_parref->ingrt_ssusr_dr->ssusr_name createUserName,"
		_" ingrti_ingrt_parref->ingrt_auditdate gdDate ,"
		_" ingrti_ingrt_parref->ingrt_audittime gdTime,"
		_" ingrti_ingrt_parref->INGRT_SSUSR_Audit_DR->ssusr_name gdAuditUserName,"
		_" ingrti_rowid ingrti, INGRTI_MEDRTITM_DR Inclb,"
		_" ingrti_ingri_dr ingri,"
		_" ingrti_retqty retqty,"
		_" ingrti_realprice rp,"
		_" ingrti_saleprice sp,"
		_" ingrti_retuom_dr->ctuom_desc uomDesc,"
		_" ingrti_retamount retamount,"
		_" ingrti_invno invNo,"
		_" ingrti_invamt invAmt,"
		_" ingrti_invdate invDate,"
		_" ingrti_sxno sxNo"
		_" From dhc_ingrtitm"
		_" where ingrti_ingrt_parref->ingrt_date between "_StartDate_" and "_EndDate
		_" and ingrti_ingrt_parref->ingrt_ctloc_dr="_LocId
		_" and ingrti_ingrt_parref->ingrt_apcvm_dr="_Vendor
	i ApprovalFlag="1" d
	.s SqlStr=SqlStr_" and ingrti_ingrt_parref->ingrt_payallowed='Y'"
	s xrs=##class(%ResultSet).%New()
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s Ingrt=xrs.Data("ingrt")
		s No=xrs.Data("gdNo")
		s Date=xrs.Data("createDate")
		s:Date'="" Date=..DL2H(Date)
		s Time=xrs.Data("createTime")
		s:Time'="" Time=..TL2H(Time)
		s UserName=xrs.Data("gdAuditUserName")
		s Ingrti=xrs.Data("ingrti")
		continue:..PayOver("R",Ingrti)
		s Ingri=xrs.Data("ingri")
		s IngrCh=$p(Ingri,"||",2)
		s Inclb=xrs.Data("Inclb")
		
		;这里不再跟进Ingri取值,可能存在Ingri为空的情况
		s Inci=$p(Inclb,"||",1)
		s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
		s BatNo=$p(BatExp,"^",1)
		s ExpDate=$p(BatExp,"^",2)
		s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
		s Manf=$p(ManfInfo,"^",2)
		
		s Code=$p(^INCI(Inci,1),"^",1)
		s Description=$p(^INCI(Inci,1),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
		s RetQty=xrs.Data("retqty")
		s Rp=xrs.Data("rp")
		s RpAmt=Rp*RetQty
		s Sp=xrs.Data("sp")
		s SpAmt=Sp*RetQty
		s PayedAmt=##class(web.DHCSTMHUI.DHCINGdRecInv).PayedAmtRetItm(Ingrti)
		s UomDesc=xrs.Data("uomDesc")
		s RetAmt=xrs.Data("retamount")
		s RestAmt=RetAmt+PayedAmt
		s InsxNo=xrs.Data("sxNo")
		s InvNo=xrs.Data("invNo")
		continue:(pInvNo'="")&&(InvNo'=pInvNo)
		s InvAmt=xrs.Data("invAmt")
		s InvDate=xrs.Data("invDate")
		s:InvDate'="" InvDate=..DL2H(InvDate)
		s PayAmt=RestAmt
		d OutPutIngrtItmRow
	}
	Quit $$$OK
OutPutIngrItmRow
	s Data=$lb(Ingri,No,Date,Time,UserName,Inclb,Inci,Code,Description,Spec,Manf,UomDesc,Qty,Rp,RpAmt,Sp,SpAmt,PayedAmt,RestAmt,InvNo,InvAmt,InvDate,InsxNo,BatNo,ExpDate,"G",PayAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
OutPutIngrtItmRow
	s Data=$lb(Ingrti,No,Date,Time,UserName,Inclb,Inci,Code,Description,Spec,Manf,UomDesc,RetQty,Rp,(-1)*RpAmt,Sp,(-1)*SpAmt,(-1)*PayedAmt,(-1)*RestAmt,InvNo,InvAmt,InvDate,InsxNo,BatNo,ExpDate,"R",(-1)*PayAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存付款单信息
/// Creator: 	tsr
/// CreatDate: 	2018-06-05
/// Table:		DHC_Pay,DHC_PayItm
/// Input:		付款单Id,付款科室Id,供应商Id,Main,Detail
/// Output:     
ClassMethod Save(PayId As %String, LocId As %String, Vendor As %String, Main As %String, Detail As %String) As %Library.String
{
	n (PayId,LocId,Vendor,Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s PayRatio=PJObj.%Get("PayRatio")
	tstart
	s $ZT=..sssError()
	s RtnObj=..Update(PayId,LocId,Vendor,Main)
	i RtnObj.success<0 tro  q RtnObj.Json()
	s MainId=RtnObj.rowid
	s RtnObj=##class(web.DHCSTMHUI.DHCPayItm).Save(MainId,Detail,PayRatio)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tcommit 
	s RtnObj.rowid=MainId
	q RtnObj.Json()
}

/// Descript:	插入或更新付款单主表记录
/// Creator: 	tsr
/// CreatDate: 	2018-06-05
/// Table:		DHC_Pay
/// Input:		付款单Id,付款科室Id,供应商Id,Main
/// Return:		-2-供应商不匹配;-3-付款科室不匹配;-4-付款单已完成;-5-保存失败;-99-加锁失败
ClassMethod Update(PayId As %String, LocId As %String, Vendor As %String, Main As %String) As RtnObj
{
	n (PayId,LocId,Vendor,Main)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s pPayMode=PJObj.%Get("PayMode")
	s gUserId=PJObj.%Get("gUserId")
	s (TMPVendor,TMPLocId,TMPComp)=""
	s:PayId'="" TMPVendor=$p(^DHCPAY(PayId),"^",2)
	s:PayId'="" TMPLocId=$p(^DHCPAY(PayId),"^",3)
	s:PayId'="" TMPComp=$p(^DHCPAY(PayId),"^",19)
	i (TMPVendor'="")&&(TMPVendor'=Vendor) d
	.s Sc=RtnObj.Err(-2,"","供应商不匹配!","",0)
	q:RtnObj.success'=0 RtnObj
	i (TMPLocId'="")&&(TMPLocId'=LocId) d
	.s Sc=RtnObj.Err(-3,"","付款科室不匹配!","",0)
	q:RtnObj.success'=0 RtnObj
	i TMPComp="Y" d
	.s Sc=RtnObj.Err(-4,"","付款单已完成!","",0)
	q:RtnObj.success'=0 RtnObj
	
	i PayId'="" q:..sssLock(..%GetParameter("AppName")_PayId)<0 -99		//锁定
	i PayId="" d
	.s Obj=##class(User.DHCPay).%New()
	e  d
	.s Obj=##class(User.DHCPay).%OpenId(PayId)
	.d Obj.%Reload()
	d Obj.PAYAPCVMDRSetObjectId(Vendor)
	d Obj.PAYCTLOCDRSetObjectId(LocId)
	d Obj.PAYSSUSRDRSetObjectId(gUserId)
	s Obj.PAYDate=+$H
	s Obj.PAYTime=$p($H,",",2)
	s PayNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(..%GetParameter("AppName"),"",LocId)
	s Obj.PAYNo=PayNo
	s Obj.PAYMode=pPayMode
	s sc=Obj.%Save()
	i $$$ISERR(sc) d RtnObj.Err(-5,"","保存失败!")
	q:RtnObj.success'=0 RtnObj
	s RowId= Obj.%Id()
	i PayId'="" d ..sssUnLock(..%GetParameter("AppName")_PayId)
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:	删除付款单信息 
/// Creator: 	tsr
/// CreatDate: 	2018-06-05
/// Table:		DHC_Pay
/// Input:		付款单Id
/// Return:		-1-不允许删除;-2-删除失败;-99-加锁失败
ClassMethod Delete(PayId As %String) As %String
{
	n (PayId)
	s RtnObj=##class(RtnObj).%New()
	i ..AllowDel(PayId)<0 d RtnObj.Err(-1,"","此付款单不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	i ..sssLock(..%GetParameter("AppName")_PayId)<0 d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	&sql(delete from DHC_Pay where %id=:PayId)
	i SQLCODE'=0 d RtnObj.Err(-2,"","删除失败!")
	d ..sssUnLock(..%GetParameter("AppName")_PayId)
	q:RtnObj.success'=0 RtnObj.Json()
	q RtnObj.Json()
}

/// Descript:	判断是否允许删除
/// Creator: 	tsr
/// CreatDate: 	2018-06-05
/// Table:		DHC_Pay
/// Input:		付款单Id
/// Return:		0-允许删除;-1-已采购审核;-2-已会计审核;-3-已完成
ClassMethod AllowDel(PayId As %String)
{
	n (PayId)
	s (Ack1,Ack2,Ack11)=""
	&sql(select PAY_Ack1, PAY_Ack2, PAY_Ack11, PAY_Completed into :Ack1,:Ack2,:Ack11,:Comp from DHC_Pay where %id=:PayId)
	i Ack1="Y" q -1
	i Ack2="Y" q -2
	i Ack11="Y" q -3
	i Comp="Y" q -4
	q 0
}

/// Descript:	付款单完成
/// Creator: 	tsr
/// CreatDate: 	2018-06-05
/// Table:		DHC_Pay
/// Input:		付款单Id
ClassMethod SetComp(PayId As %String) As %String
{
	n (PayId)
	s RtnObj=##class(RtnObj).%New()
	i PayId="" d RtnObj.Err(-1,"","付款单Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s Comp="N"
	&sql(SELECT PAY_Completed INTO :Comp FROM DHC_Pay WHERE %ID=:PayId)
	i Comp="Y" d RtnObj.Err(-2,PayId,"已完成,不能重复完成!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	i ..sssLock(..%GetParameter("AppName")_PayId)<0 d RtnObj.Err(-99,PayId,"加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s Comp="Y",CompDate=+$h,CompTime=$p($h,",",2)
	&sql(UPDATE SQLUser.DHC_Pay SET PAY_Completed = :Comp, PAY_CompletedDate = :CompDate, PAY_CompletedTime = :CompTime WHERE %ID=:PayId)
	i SQLCODE d RtnObj.Err(-3,PayId,"更新失败!")
	d ..sssUnLock(..%GetParameter("AppName")_PayId)
	q:RtnObj.success'=0 RtnObj.Json()
	s RtnObj.rowid=PayId
	q RtnObj.Json()
}

/// Descript:	付款单取消完成
/// Creator: 	tsr
/// CreatDate: 	2018-06-05
/// Table:		DHC_Pay
/// Input:		付款单Id
ClassMethod CancelComp(PayId As %String) As %String
{
	n (PayId)
	s RtnObj=##class(RtnObj).%New()
	i PayId="" d RtnObj.Err(-1,"","付款单Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s Comp="Y",Ack1="N",Ack2="N",Ack11="N"
	&sql(SELECT PAY_Completed, PAY_Ack1, PAY_Ack2, PAY_Ack11 INTO :Comp,:Ack1,:Ack2,:Ack11 FROM DHC_Pay WHERE %ID=:PayId)
	i Comp'="Y" d RtnObj.Err(-1,PayId,"未完成,不能取消完成!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	i Ack1="Y" d RtnObj.Err(-2,PayId,"已采购审核,不能取消完成!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	i Ack2="Y" d RtnObj.Err(-3,PayId,"已会计审核,不能取消完成!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	i Ack11="Y" d RtnObj.Err(-4,PayId,"已财务审核,不能取消完成!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	i ..sssLock(..%GetParameter("AppName")_PayId)<0 d RtnObj.Err(-99,PayId,"加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s Comp="N"
	&sql(UPDATE SQLUser.DHC_Pay SET PAY_Completed = :Comp, PAY_CompletedDate = NULL, PAY_CompletedTime = NULL WHERE %ID=:PayId)
	i SQLCODE d RtnObj.Err(-5,PayId,"更新失败!")
	d ..sssUnLock(..%GetParameter("AppName")_PayId)
	q:RtnObj.success'=0 RtnObj.Json()
	s RtnObj.rowid=PayId
	q RtnObj.Json()
}

/// Descript:	锁定付款单
/// Creator: 	tsr
/// CreatDate: 	2018-06-05
/// Input:		付款单Id
ClassMethod Lock(Pay As %String) As %String
{
	n (Pay)
	q:Pay="" 0
	s AppName=..%GetParameter("AppName")
	q ##class(web.DHCSTMHUI.Common.AppCommon).Lock(AppName_Pay)
}

/// Descript:	解锁付款单
/// Creator: 	tsr
/// CreatDate: 	2018-06-05
/// Input:		付款单Id
ClassMethod uLock(Pay As %String)
{
	n (Pay)
	q:Pay="" 0
	s AppName=..%GetParameter("AppName")
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(AppName_Pay)
	q
}

}
