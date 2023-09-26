Import sqluser

Class web.DHCSTMHUI.DHCINGdRecInv Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询入库退货单主信息
/// Creator: 	tsr
/// CreatDate: 	2018-06-14
/// Table: 		DHC_Pay
/// Input: 		采购科室Id,Params对象
Query DHCINGdRecList(Params As %String) As Query(ROWSPEC = "Type,RowId,Vendor,VendorDesc,ReqLocDesc,GRNo,CreateDate,CreateUser,AuditDate,AuditUser,RpAmt:%Float,SpAmt:%Float,PayedAmt:%Float,PayOverFlag,ComDate,ComTime,ComUser,AudDate,AudTime,AudUser,ReAudDate,ReAudTime,ReAudUser,RefuseReason") [ SqlProc ]
{
}

ClassMethod DHCINGdRecListExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	;s ^tmpzx(21)=Params
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
	s pInvCode=PJObj.%Get("InvCode")
	s pInvNo=PJObj.%Get("InvNo")
	s pConfirm=PJObj.%Get("Confirm")
	s pInvFlag=PJObj.%Get("InvFlag")
	s pSxNo=PJObj.%Get("SxNo")
	s pInciDesc=PJObj.%Get("InciDesc")
	s pInci=PJObj.%Get("Inci")
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	q:pIngrLoc="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s StkType=..sssCode()
	;s StrParam=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId

	//检索入库信息
	s SqlStr="select %id Ingr,"
	s SqlStr=SqlStr_"ingr_no GRNo,"
	s SqlStr=SqlStr_"ingr_apcvm_dr Vendor,"
	s SqlStr=SqlStr_"ingr_apcvm_dr->apcvm_name VendorDesc,"
	s SqlStr=SqlStr_"ingr_createdate CreateDate,"
	s SqlStr=SqlStr_"ingr_createuser->ssusr_name CreateUser,"
	s SqlStr=SqlStr_"INGR_ReqLoc_Dr ReqLoc,"
	s SqlStr=SqlStr_"INGR_ReqLoc_Dr->CTLOC_Desc ReqLocDesc,"
	s SqlStr=SqlStr_"ingr_date AuditDate,"
	s SqlStr=SqlStr_"ingr_ssusr_dr->ssusr_name AuditUser,INGR_AuditFlag "
	s SqlStr=SqlStr_" From dhc_ingdrec"
	s SqlStr=SqlStr_" where ingr_createdate between "_StartDate_" and "_EndDate
	s SqlStr=SqlStr_" and ingr_loc_dr="_pIngrLoc
	s SqlStr=SqlStr_" and INGR_StkType='"_StkType_"'"
	i pVendor'="" d
	.s SqlStr=SqlStr_" and ingr_apcvm_dr="_pVendor
	s xrs=##class(%ResultSet).%New()
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("Ingr")
		s ReqLoc=xrs.Data("ReqLoc")
		continue:(pReqLoc'="")&&(pReqLoc'=ReqLoc)
		s Type="G"
		i pInvNo'="" continue:..CheckInvNo(pInvNo,RowId,Type)
		i pInci'="" continue:'$d(^DHCINGR(0,"INCI",pInci,RowId))
		i pInciDesc'="" continue:..CheckInciDesc(pInciDesc,RowId,Type)
		i pSxNo'="" continue:..CheckSxNo(pSxNo,RowId,Type)
		s InvFlag=..CheckGRInvNo(RowId,Type)
		continue:((pInvFlag="N")&&(InvFlag=1))||((pInvFlag="Y")&&(InvFlag=0))
		s InvId=$o(^DHCRcRtInv(0,"TypeINGRTRowId",Type,RowId,""))
		s ConfirmDate=$s(InvId'="":$p(^DHCRcRtInv(InvId),"^",5),1:"")
		s ConfirmFlag=$s(ConfirmDate'="":"Y",1:"N")
		continue:(pConfirm'="")&&(ConfirmFlag'=pConfirm)
		
		s tmpAmt=..GetGRAmt(RowId,Type)
		s RpAmt=$P(tmpAmt,"^",1)
		s SpAmt=$P(tmpAmt,"^",2)
		s Vendor=xrs.Data("Vendor")
		s VendorDesc=xrs.Data("VendorDesc")
		s GRNo=xrs.Data("GRNo")
		s CreateDate=xrs.Data("CreateDate")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s CreateUser=xrs.Data("CreateUser")
		s AuditDate=xrs.Data("AuditDate")
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s AuditUser=xrs.Data("AuditUser")
		s Audit = xrs.Data("INGR_AuditFlag")
		CONTINUE:Audit'="Y"
		s ReqLocDesc=xrs.Data("ReqLocDesc")
		s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
		s PayedAmt=..PayedAmt(RowId,Type)
		s PayOverFlag="N"
		i PayedAmt>=RpAmt s PayOverFlag="Y"
		s invdaudinfo=..GetInvAudInfo(RowId,Type)
		s ComDate=$p(invdaudinfo,"^",1)
		s ComTime=$p(invdaudinfo,"^",2)
		s ComUser=$p(invdaudinfo,"^",3)
		s AudDate=$p(invdaudinfo,"^",4)
		s AudTime=$p(invdaudinfo,"^",5)
		s AudUser=$p(invdaudinfo,"^",6)
		s ReAudDate=$p(invdaudinfo,"^",7)
		s ReAudTime=$p(invdaudinfo,"^",8)
		s ReAudUser=$p(invdaudinfo,"^",9)
		s RefuseReason=$p(invdaudinfo,"^",10)
		d OutPutRow
	}
	d xrs.Close()
	
	//检索退货信息
	s SqlStr="select %id Ingrt,"
	s SqlStr=SqlStr_"INGRT_NO GRNo,"
	s SqlStr=SqlStr_"INGRT_APCVM_DR Vendor,"
	s SqlStr=SqlStr_"INGRT_APCVM_DR->apcvm_name VendorDesc,"
	s SqlStr=SqlStr_"INGRT_Date CreateDate,"
	s SqlStr=SqlStr_"INGRT_SSUSR_DR->ssusr_name CreateUser,"
	s SqlStr=SqlStr_"INGRT_AuditDate AuditDate,"
	s SqlStr=SqlStr_"INGRT_SSUSR_Audit_DR->ssusr_name AuditUser,INGRT_AuditFlag "
	s SqlStr=SqlStr_" From dhc_ingdret"
	s SqlStr=SqlStr_" where INGRT_Date between "_StartDate_" And "_EndDate
	s SqlStr=SqlStr_" and INGRT_CTLOC_DR="_pIngrLoc
	s SqlStr=SqlStr_" and INGRT_StkType= '"_StkType_"'"
	i pVendor'="" d
	.s SqlStr=SqlStr_" and ingrt_apcvm_dr="_pVendor
	s xrs=##class(%ResultSet).%New()
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("Ingrt")
		s ReqLoc=""
		continue:(pReqLoc'="")&&(pReqLoc'=ReqLoc)
		s Type="R"
		i pInvNo'="" continue:..CheckInvNo(pInvNo,RowId,Type)
		i pInciDesc'="" continue:..CheckInciDesc(pInciDesc,RowId,Type)
		i pSxNo'="" continue:..CheckSxNo(pSxNo,RowId,Type)
		s NoInciFlag=0
		i pInci'="" d
		.&sql(select %id from dhc_ingrtitm where INGRTI_INGRT_Parref=:RowId and +INGRTI_MEDRTITM_DR=:pInci) 
		.s:SQLCODE NoInciFlag=1
		continue:(pInci'="")&&(NoInciFlag=1)
		s InvFlag=..CheckGRInvNo(RowId,Type)
		continue:((pInvFlag="N")&&(InvFlag=1))||((pInvFlag="Y")&&(InvFlag=0))
		s InvId=$o(^DHCRcRtInv(0,"TypeINGRTRowId",Type,RowId,""))
		s ConfirmDate=$s(InvId'="":$p(^DHCRcRtInv(InvId),"^",5),1:"")
		s ConfirmFlag=$s(ConfirmDate'="":"Y",1:"N")
		continue:(pConfirm'="")&&(ConfirmFlag'=pConfirm)
		
		s tmpAmt=..GetGRAmt(RowId,Type)
		s RpAmt=$P(tmpAmt,"^",1)
		s SpAmt=$P(tmpAmt,"^",2)
		s Vendor=xrs.Data("Vendor")
		s VendorDesc=xrs.Data("VendorDesc")
		s GRNo=xrs.Data("GRNo")
		s CreateDate=xrs.Data("CreateDate")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s CreateUser=xrs.Data("CreateUser")
		s AuditDate=xrs.Data("AuditDate")
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s AuditUser=xrs.Data("AuditUser")
		s Audit = xrs.Data("INGRT_AuditFlag")
		CONTINUE:Audit'="Y"
		s ReqLocDesc=""
		s PayedAmt=..PayedAmt(RowId,Type)
		s PayOverFlag="N"
		i -PayedAmt>=RpAmt s PayOverFlag="Y"
		s invdaudinfo=..GetInvAudInfo(RowId,Type)
		s ComDate=$p(invdaudinfo,"^",1)
		s ComTime=$p(invdaudinfo,"^",2)
		s ComUser=$p(invdaudinfo,"^",3)
		s AudDate=$p(invdaudinfo,"^",4)
		s AudTime=$p(invdaudinfo,"^",5)
		s AudUser=$p(invdaudinfo,"^",6)
		s ReAudDate=$p(invdaudinfo,"^",7)
		s ReAudTime=$p(invdaudinfo,"^",8)
		s ReAudUser=$p(invdaudinfo,"^",9)
		s RefuseReason=$p(invdaudinfo,"^",10)
		d OutPutRow
	}
	d xrs.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(Type,RowId,Vendor,VendorDesc,ReqLocDesc,GRNo,CreateDate,CreateUser,AuditDate,AuditUser,RpAmt,SpAmt,PayedAmt,PayOverFlag,ComDate,ComTime,ComUser,AudDate,AudTime,AudUser,ReAudDate,ReAudTime,ReAudUser,RefuseReason)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	检查入库\退货单是否存在某发票号
/// Creator: 	tsr
/// CreatDate: 	2018-06-15
/// Table: 		dhc_ingdrecitm,dhc_ingrtitm
/// Input: 		发票号,业务Id,业务类型
/// Return:		0-存在;非0-不存在
ClassMethod CheckInvNo(InvNo As %String, Ingr As %String, Type As %String) As %String
{
	n (InvNo,Ingr,Type)
	s Match="%"_InvNo_"%"
	i Type="G" d
	.&sql(select %id from dhc_ingdrecitm where ingri_ingr_parref=:Ingr and initm_invno like :Match)
	e  i Type="R" d
	.&sql(select %id from dhc_ingrtitm where INGRTI_INGRT_Parref=:Ingr and INGRTI_InvNo like :Match)
	q SQLCODE
}

/// Descript:	检查入库\退货单是否存在某随行单号
/// Creator: 	tsr
/// CreatDate: 	2018-06-15
/// Table: 		dhc_ingdrecitm,dhc_ingrtitm
/// Input: 		随行单号,业务Id,业务类型
/// Return:		0-存在;非0-不存在
ClassMethod CheckSxNo(SxNo As %String, Ingr As %String, Type As %String) As %String
{
	n (SxNo,Ingr,Type)
	s Match="%"_SxNo_"%"
	i Type="G" d
	.&sql(select %id from dhc_ingdrecitm  where ingri_ingr_parref=:Ingr and initm_sxno like :Match)
	e  i Type="R" d
	.&sql(select %id from dhc_ingrtitm where INGRTI_INGRT_Parref=:Ingr and INGRTI_Sxno like :Match)
	q SQLCODE
}

/// Descript:	检查入库\退货单是否存在某物资名称
/// Creator: 	tsr
/// CreatDate: 	2018-06-15
/// Table: 		dhc_ingdrecitm,dhc_ingrtitm
/// Input: 		物资名称,业务Id,业务类型
/// Return:		0-存在;1-不存在
ClassMethod CheckInciDesc(InciDesc As %String, Ingr As %String, Type As %String) As %String
{
	n (InciDesc,Ingr,Type)
	s err=1
	i Type="G" d
	.s Ch=0
	.f  s Ch=$o(^DHCINGR(Ingr,"GRI",Ch)) q:(Ch="")!(err=0)  d
	..s Inci=$p(^DHCINGR(Ingr,"GRI",Ch),"^",25)
	..s TMPInciDesc=$p(^INCI(Inci,1),"^",2)
	..q:TMPInciDesc'[InciDesc
	..s err=0
	e  i Type="R" d
	.s Ch=0
	.f  s Ch=$o(^INGRT(Ingr,"DHCGRR",Ch)) q:(Ch="")!(err=0)  d
	..s Inci=+$p(^INGRT(Ingr,"DHCGRR",Ch),"^",6)
	..s TMPInciDesc=$p(^INCI(Inci,1),"^",2)
	..q:TMPInciDesc'[InciDesc
	..s err=0
	q err
}

/// Descript:	取入库\退货单进价和售价总金额
/// Creator: 	tsr
/// CreatDate: 	2018-06-15
/// Table: 		dhc_ingdrecitm,dhc_ingrtitm
/// Input: 		业务Id,业务类型
/// Return:		0-存在;非0-不存在
ClassMethod GetGRAmt(Ingr As %String, Type As %String) As %String
{
	n (Ingr,Type)
	s (RpAmt,SpAmt,QtyAmt)=0
	i Type="G" d
	.&sql(select sum(initm_realtotal),sum(initm_spamt),sum(INGRI_RecQty) into :RpAmt,:SpAmt,:QtyAmt
		From dhc_ingdrecitm where ingri_ingr_parref=:Ingr)
	e  i Type="R" d
	.&sql(select sum(ingrti_retamount),sum(ingrti_spamt),sum(INGRTI_RETQTY) into :RpAmt,:SpAmt,:QtyAmt
		From dhc_ingrtitm where ingrti_ingrt_parref=:Ingr)
	q RpAmt_"^"_SpAmt_"^"_QtyAmt
}

/// Descript:	判断某入库单\退货单明细是否全部录入发票号
/// Creater:	tsr
/// CreateDate: 2018-06-15
/// Input:		业务Id,业务类型
/// Output:		1-全部录入发票号;0-存在未录入发票号的明细
ClassMethod CheckGRInvNo(Ingr As %String, Type As %String) As %Library.String
{
	n (Ingr,Type)
	s Flag=1
	i Type="G" d
	.s Ch=0
	.f  s Ch=$o(^DHCINGR(Ingr,"GRI",Ch)) q:(Ch="")!(Flag=0)  d
	..s InvNo=$p(^DHCINGR(Ingr,"GRI",Ch),"^",27)
	..i InvNo="" s Flag=0
	e  i Type="R" d
	.s Ch=0
	.f  s Ch=$o(^INGRT(Ingr,"DHCGRR",Ch)) q:(Ch="")!(Flag=0)  d
	..s InvNo=$p(^INGRT(Ingr,"DHCGRR",Ch),"^",12)
	..i InvNo="" s Flag=0
	q Flag
}

/// Descript:	判断某入库单\退货单明细是否全部未录入发票号
/// Creater:	tsr
/// CreateDate: 2018-06-15
/// Input:		业务Id,业务类型
/// Output:		1-全部未录入发票号;0-存在录入发票号的明细
ClassMethod CheckGRInvNoN(Ingr As %String, Type As %String) As %Library.String
{
	n (Ingr,Type)
	s Flag=1
	i Type="G" d
	.s Ch=0
	.f  s Ch=$o(^DHCINGR(Ingr,"GRI",Ch)) q:(Ch="")!(Flag=0)  d
	..s InvNo=$p(^DHCINGR(Ingr,"GRI",Ch),"^",27)
	..i InvNo'="" s Flag=0
	e  i Type="R" d
	.s Ch=0
	.f  s Ch=$o(^INGRT(Ingr,"DHCGRR",Ch)) q:(Ch="")!(Flag=0)  d
	..s InvNo=$p(^INGRT(Ingr,"DHCGRR",Ch),"^",12)
	..i InvNo'="" s Flag=0
	q Flag
}

/// Descript:	取某入库单\退货单已付款总金额
/// Creater:	tsr
/// CreateDate: 2018-06-15
/// Input:		业务Id,业务类型
ClassMethod PayedAmt(Ingr As %String, Type As %String) As %String
{
	n (Ingr,Type)
	s Amt=0
	i Type="G" d
	.s Ch=0
	.f  s Ch=$O(^DHCINGR(Ingr,"GRI",Ch)) q:Ch=""  d
	..s Ingri=Ingr_"||"_Ch
	..s Amt=Amt+..PayedAmtRecItm(Ingri)
	e  i Type="R" d
	.s Ch=0
	.f  s Ch=$O(^INGRT(Ingr,"DHCGRR",Ch)) q:Ch=""  d
	..s Ingri=Ingr_"||"_Ch
	..s Amt=Amt+..PayedAmtRetItm(Ingri)
	q Amt
}

/// Descript:	取某入库明细已付款金额
/// Creater:	tsr
/// CreateDate: 2018-06-15
/// Input:		业务明细Id
ClassMethod PayedAmtRecItm(Ingri As %String) As %String
{
	n (Ingri)
	s Pay=""
	s SumAmt=0
	f  s Pay=$o(^DHCPAY(0,"TYPEGR","G",Ingri,Pay)) q:Pay=""  d
	.s Ack1=$p(^DHCPAY(Pay),"^",8)
	.q:Ack1'="Y"	//判断是否采购确认
	.s Ch=0
	.f  s Ch=$o(^DHCPAY(0,"TYPEGR","G",Ingri,Pay,Ch)) q:Ch=""  d
	..s PayedAmt=$P(^DHCPAY(Pay,"I",Ch),"^",5)
	..s SumAmt=SumAmt+PayedAmt
	q SumAmt
}

/// Descript:	取某退货明细已付款金额
/// Creater:	tsr
/// CreateDate: 2018-06-15
/// Input:		业务明细Id
ClassMethod PayedAmtRetItm(Ingri As %String) As %String
{
	n (Ingri)
	s Pay=""
	s SumAmt=0
	f  s Pay=$o(^DHCPAY(0,"TYPEGR","R",Ingri,Pay)) q:Pay=""  d
	.s ack1=$p(^DHCPAY(Pay),"^",8)
	.q:ack1'="Y"	//判断是否采购确认
	.s Ch=0
	.f  s Ch=$o(^DHCPAY(0,"TYPEGR","R",Ingri,Pay,Ch)) q:Ch=""  d
	..s PayedAmt=$P(^DHCPAY(Pay,"I",Ch),"^",5)
	..s SumAmt=SumAmt+PayedAmt
	q SumAmt
}

/// Descript:	获取发票确认记录
/// Creater:	tsr
/// CreateDate: 2018-06-15
/// Input:		业务明细Id
ClassMethod GetInvAudInfo(IngtId As %String, Type As %String) As %String
{
	n (IngtId,Type)
	q:IngtId="" ""
	q:Type="" ""
	
	s InvId=$o(^DHCRcRtInv(0,"TypeINGRTRowId",Type,IngtId,""))
	q:InvId="" ""
	q:'$d(^DHCRcRtInv(InvId)) ""
	
	s (ComDate,ComTime,ComUser,AudDate,AudTime,AudUser,ReAudDate,ReAudTime,ReAudUser)=""
	s DHCRcRtInvinfo=^DHCRcRtInv(InvId)
	s ComDate=$p(^DHCRcRtInv(InvId),"^",2)
	s:ComDate'="" ComDate=..DL2H(ComDate)
	s ComTime=$p(^DHCRcRtInv(InvId),"^",3)
	s:ComTime'="" ComTime=..TL2H(ComTime)
	s ComUserId=$p(^DHCRcRtInv(InvId),"^",4)
	s:ComUserId'="" ComUser=$p(^SSU("SSUSR",ComUserId),"^",2)
	s AudDate=$p(^DHCRcRtInv(InvId),"^",5)
	s:AudDate'="" AudDate=..DL2H(AudDate)
	s AudTime=$p(^DHCRcRtInv(InvId),"^",6)
	s:AudTime'="" AudTime=..TL2H(AudTime)
	s AudUserId=$p(^DHCRcRtInv(InvId),"^",7)
	s:AudUserId'="" AudUser=$p(^SSU("SSUSR",AudUserId),"^",2)
	s ReAudDate=$p(^DHCRcRtInv(InvId),"^",8)
	s:ReAudDate'="" ReAudDate=..DL2H(ReAudDate)
	s ReAudTime=$p(^DHCRcRtInv(InvId),"^",9)
	s:ReAudTime'="" ReAudTime=..TL2H(ReAudTime)
	s ReAudUserId=$p(^DHCRcRtInv(InvId),"^",10)
	s:ReAudUserId'="" ReAudUser=$p(^SSU("SSUSR",ReAudUserId),"^",2)
	s RefuseReason=$p(^DHCRcRtInv(InvId),"^",12)
	s data=ComDate_"^"_ComTime_"^"_ComUser_"^"_AudDate_"^"_AudTime_"^"_AudUser_"^"_ReAudDate_"^"_ReAudTime_"^"_ReAudUser_"^"_RefuseReason_"^"_ComUserId_"^"_AudUserId_"^"_ReAudUserId
	q data
}

/// Descript:	入库退货单明细查询
/// Creator: 	tsr
/// CreatDate: 	2018-08-03
/// Table: 		DHC_INGdRec,DHC_INGDRET
/// Input: 		科室Id,Params对象
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINGdRecInv","GetIngdRecItm",^templxt("234234"))
Query GetIngdRecItm(Params As %String) As Query(ROWSPEC = "RowId,IncId,Code,Description,Spec,UomDesc,BatchNo,ExpDate,Qty:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,InvAmt:%Float,InvNo,InvDate,Manf,SxNo,Type,InvCode,ConfirmStatus") [ SqlProc ]
{
}

ClassMethod GetIngdRecItmExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	;s ^templxt("234234")=Params
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
		s RowId=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
		i Type="G"
		{
			s SqlStr = "SELECT INGRI_Rowid as RowId, INGRI_BatchNo, INGRI_CTUOM_DR, INGRI_ExpDate, INGRI_RecQty,"
				_"initm_INCI_DR, initm_INCI_DR->INCI_Code as IncCode, initm_INCI_DR->INCI_Desc as IncDesc,"
				_"initm_invmoney, initm_invno, initm_phmnf_dr, initm_phmnf_dr->PHMNF_Name as Manf,"
				_"initm_realprice, initm_realtotal, initm_saleprice, initm_SpAmt, initm_invdate, initm_sxno,initm_InvCode "
				_"FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef= "_RowId
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
				//CONTINUE:##class(web.DHCSTMHUI.DHCVendorInv).CheckIngDetail(RowId,Type)=1		;该入库单明细已经组合
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
				s InvCode = result.Data("initm_InvCode")
				s INGRINVId=$o(^DHCRcRtInv(0,"TypeINGRTRowId",Type,+RowId,""))
				s ComfirDate=$s(INGRINVId'="":$p(^DHCRcRtInv(INGRINVId),"^",2),1:"")
				s ComfirmSatus="N"
				s:ComfirDate'="" ComfirmSatus="Y"
				s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
				d OutPutRowDetail
			}
			d result.Close()
		}
		i Type="R"
		{
			s SqlStr = "SELECT INGRTI_RowId AS RowId, INGRTI_INGRI_DR, INGRTI_INGRI_DR->initm_phmnf_dr->phmnf_name Manf,"
				_"INGRTI_RetQty, INGRTI_RetUom_DR, INGRTI_RetAmount, INGRTI_MEDRTITM_DR, INGRTI_Sxno,"
				_"INGRTI_RealPrice, INGRTI_SalePrice, INGRTI_SpAmt, INGRTI_InvNo, INGRTI_InvAmt, INGRTI_InvDate,INGRTI_InvCode "
				_"FROM DHC_INGRTITM WHERE INGRTI_INGRT_Parref="_RowId
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
				//CONTINUE:##class(web.DHCSTMHUI.DHCVendorInv).CheckIngDetail(RowId,Type)=1		;该退货单明细已经组合
				s Ingri = result.Data("INGRTI_INGRI_DR")
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
				s RpAmt = -result.Data("INGRTI_RetAmount")
				s Sp = result.Data("INGRTI_SalePrice")
				s SpAmt = -result.Data("INGRTI_SpAmt")
				s InvAmt = -result.Data("INGRTI_InvAmt")
				s InvNo = result.Data("INGRTI_InvNo")
				s InvDate = result.Data("INGRTI_InvDate")
				s:InvDate'="" InvDate=..DL2H(InvDate)
				s SxNo = result.Data("INGRTI_Sxno")
				s Manf = result.Data("Manf")
				s InvCode = result.Data("INGRTI_InvCode")
				s INGRINVId=$o(^DHCRcRtInv(0,"TypeINGRTRowId",Type,+RowId,""))
				s ComfirDate=$s(INGRINVId'="":$p(^DHCRcRtInv(INGRINVId),"^",2),1:"")
				s ComfirmSatus="N"
				s:ComfirDate'="" ComfirmSatus="Y"
				s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)  
				d OutPutRowDetail
			}
			d result.Close()
		}
	}
	
	Quit $$$OK
OutPutRowDetail
	s Data=$lb(RowId,IncId,Code,Description,Spec,UomDesc,BatchNo,ExpDate,Qty,Rp,RpAmt,Sp,SpAmt,InvAmt,InvNo,InvDate,Manf,SxNo,Type,InvCode,ComfirmSatus)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	更新发票及随行单号信息
/// Creater:	tsr
/// CreateDate: 2018-06-15
/// Input:		Params
ClassMethod Save(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Update(Params)
	q RtnObj.Json()
}

/// Descript:	更新发票及随行单号信息
/// Creater:	tsr
/// CreateDate: 2018-06-15
/// Input:		Params
/// w ##class(web.DHCSTMHUI.DHCINGdRecInv).Update(^TempSBX)
ClassMethod Update(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	tstart
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
		s INGRINVId=$o(^DHCRcRtInv(0,"TypeINGRTRowId",Type,+RowId,""))
		s ComfirDate=$s(INGRINVId'="":$p(^DHCRcRtInv(INGRINVId),"^",2),1:"")
		s:ComfirDate'="" Sc=RtnObj.Err(-2,RowId,"发票已确认，不可修改！","",0)
		q:RtnObj.success'=0
		s InvNo=Obj.%Get("InvNo")
		s InvCode=Obj.%Get("InvCode")
		s InvDate=Obj.%Get("InvDate")
		s:InvDate'="" InvDate=..DH2L(InvDate)
		s InvAmt=Obj.%Get("InvAmt")
		s SxNo=Obj.%Get("SxNo")
		s InvSetDate=##class(web.DHCSTMHUI.DHCINGdRecItm).GetInvSetDate(RowId,Type,InvNo)
		s VendorId=""
		s LocId=""
		i Type="G" d
		.i ..sssLock(##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")_RowId)<0 d
		..s Sc=RtnObj.Err(-99,RowId,"加锁失败!")
		.q:RtnObj.success'=0
		.&sql(update dhc_ingdrecitm set initm_invno=:InvNo,initm_InvCode=:InvCode,
			initm_invdate=:InvDate,initm_invmoney=:InvAmt,
			initm_sxno=:SxNo,initm_InvSetDate=:InvSetDate where %id=:RowId)
		.i SQLCODE'=0 s Sc=RtnObj.Err(-3,RowId,"更新失败!")
		.d ..sssUnLock(##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")_RowId)
		.q:RtnObj.success'=0
		.s Ingr=+RowId
		.s VendorId=$p(^DHCINGR(Ingr),"^",3)
		.s LocId=$p(^DHCINGR(Ingr),"^",13)
		e  i Type="R" d
		.i ..sssLock(##class(web.DHCSTMHUI.DHCINGdRet).%GetParameter("AppName")_RowId)<0 d
		..s Sc=RtnObj.Err(-99,RowId,"加锁失败!")
		.q:RtnObj.success'=0
		.&sql(update dhc_ingrtitm set INGRTI_InvNo=:InvNo,INGRTI_InvCode=:InvCode,
			INGRTI_InvDate=:InvDate,INGRTI_InvAmt=:InvAmt,
			INGRTI_Sxno=:SxNo,INGRTI_InvSetDate=:InvSetDate where %id=:RowId)
		.i SQLCODE'=0 s Sc=RtnObj.Err(-3,RowId,"更新失败!")
		.d ..sssUnLock(##class(web.DHCSTMHUI.DHCINGdRet).%GetParameter("AppName")_RowId)
		.q:RtnObj.success'=0
		.s Ingrt=+RowId
		.s VendorId=$p(^INGRT(Ingrt),"^",2)
		.s LocId=$p(^INGRT(Ingrt),"^",7)
		
		i (InvCode'="")||(InvNo'="") d
		.s InvId=""
		.&sql(select %ID into :InvId from DHC_VendorInv where nvl(INV_InvCode,'')=nvl(:InvCode,'') and INV_InvNo=:InvNo)
		.i InvId="" d
		..s sumInvAmt=##class(web.DHCSTMHUI.DHCVendorInv).GetInvAmtByIngr(InvCode,InvNo)
		..s Data=InvId_"^"_VendorId_"^"_InvCode_"^"_InvNo_"^"_sumInvAmt_"^"_InvDate_"^"_LocId_"^"_"Y"_"^"_"Y"
		..s Title="RowId^Vendor^InvCode^InvNo^InvAmt^InvDate^IngrLoc^CompFlag^FilledFlag"
		..s InvDate=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
		..s RtnObj=##class(web.DHCSTMHUI.DHCVendorInv).SaveInvInfo(InvDate)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj
	tcommit
	q RtnObj
}

/// Description:	发票确认
/// Creator:		tsr
/// CreatDate:		2018-06-19
/// Table:			DHC_IngRcRtInv
ClassMethod Confirm(Main As %String, Detail As %String) As %String
{
	n (Main,Detail,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s gHospId=PJObj.%Get("gHospId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gUserId=PJObj.%Get("gUserId")
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s StrParam=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s RecPayTrans=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTPAYM","RecPayTrans",StrParam)
	
	tstart
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
		s GRNo=Obj.%Get("GRNo")
		i Type="" d RtnObj.Err(-3,RowId,"单号"_GRNo_"的类型为空!","",0)
		q:RtnObj.success'=0
		
		;若有单据明细上发票号为空,不进行处理
		s RtnObj=..CheckBeforeConfirm(Type,RowId)
		q:RtnObj.success<0
		
		s InvId=$o(^DHCRcRtInv(0,"TypeINGRTRowId",Type,RowId,""))
		s ComfirDate=$s(InvId'="":$p(^DHCRcRtInv(InvId),"^",2),1:"")
		i ComfirDate'="" d RtnObj.Err(-4,RowId,"单号"_GRNo_"的单据已确认!","",0)
		q:RtnObj.success'=0
		
		s Date=+$H
		s Time=$p($H,",",2)
		i InvId="" d
		.&sql(INSERT INTO DHC_IngRcRtInv
			(INGRINV_INGRT_RowId, INGRINV_Date, INGRINV_Time, INGRINV_SSUSR_DR,INGRINV_Type,
			INGRINV_Audit_Date)
			VALUES (:RowId,:Date,:Time,:gUserId,:Type,
			:Date))
		.i SQLCODE'=0 d RtnObj.Err(-5,RowId,"插入数据失败!")
		.q:RtnObj.success'=0
		e  d
		.&sql(UPDATE DHC_IngRcRtInv 
			SET INGRINV_Date=:Date, INGRINV_Time=:Time, INGRINV_SSUSR_DR=:gUserId,INGRINV_Audit_Date=:Date
			WHERE INGRINV_RowId=:InvId)
		.i SQLCODE'=0 d RtnObj.Err(-6,RowId,"更新数据失败!")
		.q:RtnObj.success'=0
		q:RtnObj.success'=0
		
		i RecPayTrans=1 d
		.s ret=..InsertPayTrans(RowId,Type)
		i ret'=0 d RtnObj.Err(-7,RowId,"插入金额流水账失败!"_ret)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tcommit
	q RtnObj.Json()
}

/// Description:判断入库单/退货单是否可进行审核
/// CreatDate:	2021-10-11
/// Input:		Type(G/R), RowId
/// Output:		RtnObj
/// w ##Class(web.DHCSTMHUI.DHCINGdRecInv).CheckBeforeConfirm("G",66)
ClassMethod CheckBeforeConfirm(Type, RowId) As RtnObj
{
	n (Type,RowId)
	s RtnObj=##class(RtnObj).%New()
	i (Type="")||(RowId)="" q RtnObj.Err(-1,"","参数有误")
	
	i Type="G" d
	.s Ch=0
	.f  s Ch=$o(^DHCINGR(RowId,"GRI",Ch)) q:(Ch="")||(RtnObj.success<0)  d
	..s Ingri=RowId_"||"_Ch
	..
	..s FilledFlag="Y"
	..s InvId=$o(^DHCVendorInv(0,"TypeItm",Type,Ingri,""),-1)
	..i InvId'="" s FilledFlag=$p(^DHCVendorInv(InvId),"^",12)
	..i FilledFlag'="Y" d RtnObj.Err(-2,"","该单据对应的发票未进行审核!","",0) q
	..
	..s InvNo=$p(^DHCINGR(RowId,"GRI",Ch),"^",27)
	..i InvNo="" d RtnObj.Err(-2,"","存在发票号为空的情况!","",0) q
	e  i Type="R" d
	.s Ch=0
	.f  s Ch=$o(^INGRT(RowId,"DHCGRR",Ch)) q:(Ch="")||(RtnObj.success<0)  d
	..s Ingrti=RowId_"||"_Ch
	..
	..s FilledFlag="Y"
	..s InvId=$o(^DHCVendorInv(0,"TypeItm",Type,Ingrti,""),-1)
	..i InvId'="" s FilledFlag=$p(^DHCVendorInv(InvId),"^",12)
	..i FilledFlag'="Y" d RtnObj.Err(-2,"","该单据对应的发票未进行审核!","",0) q
	..
	..s InvNo=$p(^INGRT(RowId,"DHCGRR",Ch),"^",12)
	..i InvNo="" d RtnObj.Err(-2,"","存在发票号为空的情况!","",0) q
	q RtnObj
}

/// 确认某一条单据，记录金额台账
/// Author: lihui
/// Date: 20190523
/// input : 单据rowid
/// Return:	0成功;<0 失败
/// w ##class(web.DHCSTMHUI.DHCINGdRecInv).InsertPayTrans()
ClassMethod InsertPayTrans(RcRtID As %String, type As %String) As %String
{
	n (RcRtID,type,%session)
	q:RcRtID="" 0
	q:type="" 0
	s params=..sssParamStr()
	s userid=$p(params,"^",3),date=+$h,time=$p($h,",",2)
	s (locid,trantype,apcvenid)=""
	i type="G" d
	.s trantype="G" 
	.s locid=$p($g(^DHCINGR(RcRtID)),"^",13)
	.s apcvenid=$p($g(^DHCINGR(RcRtID)),"^",3)
	e  i type="R" d
	.s trantype="R"
	.s locid=$p($g(^INGRT(RcRtID)),"^",7)
	.s apcvenid=$p($g(^INGRT(RcRtID)),"^",2)
	q:((trantype="")||(locid="")||(apcvenid="")) 0
	s ret=0
	i type="G" d
	.s chl=0 
	.f  s chl=$o(^DHCINGR(RcRtID,"GRI",chl)) q:(chl="")!(ret'=0)  d
	..q:'$d(^DHCINGR(RcRtID,"GRI",chl))
	..s recitminfo=^DHCINGR(RcRtID,"GRI",chl)
	..s invno=$p(recitminfo,"^",27)
	..q:invno=""
	..s point=RcRtID_"||"_chl
	..s inclb=$p(recitminfo,"^",1)
	..s rpamt=$p(recitminfo,"^",31)
	..&sql(INSERT INTO DHC_PayTrans (PAYTR_Type, PAYTR_Pointer, PAYTR_CTLoc_DR, PAYTR_APCVM_DR, PAYTR_INCLB_DR, PAYTR_RpAmount, PAYTR_Date, PAYTR_Time, PAYTR_SSUSR_DR)
	       VALUES(:trantype,:point,:locid,:apcvenid,:inclb,:rpamt,:date,:time,:userid))
	..i SQLCODE'=0  d
	...s ret=-2
	..q:ret'=0
	e  i type="R" d
	.s chl=0
	.f  s chl=$o(^INGRT(RcRtID,"DHCGRR",chl)) q:(chl="")!(ret'=0)  d
	..q:'$d(^INGRT(RcRtID,"DHCGRR",chl))
	..s retitminfo=^INGRT(RcRtID,"DHCGRR",chl)
	..s invno=$p(retitminfo,"^",12)
	..q:invno=""
	..s point=RcRtID_"||"_chl
	..s inclb=$p(retitminfo,"^",6)
	..s rpamt=-$p(retitminfo,"^",4)
	..&sql(INSERT INTO DHC_PayTrans (PAYTR_Type, PAYTR_Pointer, PAYTR_CTLoc_DR, PAYTR_APCVM_DR, PAYTR_INCLB_DR, PAYTR_RpAmount, PAYTR_Date, PAYTR_Time, PAYTR_SSUSR_DR)
	       VALUES(:trantype,:point,:locid,:apcvenid,:inclb,:rpamt,:date,:time,:userid))
	..i SQLCODE'=0  d
	...s ret=-2
	..q:ret'=0
	q ret
}

/// Description:	发票取消确认
/// Creator:		tsr
/// CreatDate:		2018-06-19
/// Table:			DHC_IngRcRtInv
/// w ##class(web.DHCSTMHUI.DHCINGdRecInv).CanConfirm("[{""Type"":""G"",""RowId"":""494"",""Vendor"":""7"",""GRNo"":""MIP20230217001""}]","{""gUserId"":""6460"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""MENUID"":""57718""}")
ClassMethod CanConfirm(Params As %String, Main = "") As %String
{
	n (Params,Main)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=MainPJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s gGroupId=MainPJObj.%Get("gGroupId")
	s gLocId=MainPJObj.%Get("gLocId")
	s gUserId=MainPJObj.%Get("gUserId")
	s gHospId=MainPJObj.%Get("gHospId")
	
	s StrParam=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s RecPayTrans=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTPAYM","RecPayTrans",StrParam)
	
	tstart
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
		i Type="" d RtnObj.Err(-3,RowId,RowId_"业务单类型为空!","",0)
		q:RtnObj.success'=0
		s Date="",Time="",UserId=""
		s InvId=$o(^DHCRcRtInv(0,"TypeINGRTRowId",Type,RowId,""))
		i InvId="" d RtnObj.Err(-4,RowId,RowId_"业务单未确认!","",0)
		q:RtnObj.success'=0
		s InvDate=$p(^DHCRcRtInv(InvId),"^",2)
		i InvDate="" d RtnObj.Err(-4,RowId,RowId_"业务单已取消确认!","",0)
		q:RtnObj.success'=0
		s Ret=..IfExistMadePay(RowId,Type)
   		i Ret'=0 d RtnObj.Err(-3,"","该业务单已生成付款单,不能取消确认!","",0)
   		q:RtnObj.success'=0
		&sql(UPDATE DHC_IngRcRtInv
			SET INGRINV_Date=:Date, INGRINV_Time=:Time, INGRINV_SSUSR_DR=:UserId,INGRINV_Audit_Date=null
			WHERE INGRINV_RowId=:InvId)
		i SQLCODE'=0 d RtnObj.Err(-5,RowId,"更新数据失败!")
		q:RtnObj.success'=0
		
		i RecPayTrans=1 d
		.s ret=..InsertCancelPayTrans(RowId,Type)
		i ret'=0 d RtnObj.Err(-6,RowId,"插入金额流水账失败!"_ret)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tcommit
	q RtnObj.Json()
}

/// 取消确认某一条单据，记录金额台账
/// Author: lihui
/// Date: 20190523
/// input : 单据rowid
/// Return:	0成功;<0 失败
/// w ##class(web.DHCSTMHUI.DHCINGdRecInv).InsertCancelPayTrans()
ClassMethod InsertCancelPayTrans(RcRtID As %String, type As %String) As %String
{
	n (RcRtID,type,%session)
	q:RcRtID="" 0
	q:type="" 0
	s params=..sssParamStr()
	s userid=$p(params,"^",3),date=+$h,time=$p($h,",",2)
	s (locid,trantype,apcvenid)=""
	i type="G" d
	.s trantype="GC"
	.s locid=$p($g(^DHCINGR(RcRtID)),"^",13)
	.s apcvenid=$p($g(^DHCINGR(RcRtID)),"^",3)
	e  i type="R" d
	.s trantype="RC"
	.s locid=$p($g(^INGRT(RcRtID)),"^",7)
	.s apcvenid=$p($g(^INGRT(RcRtID)),"^",2)
	q:((trantype="")||(locid="")||(apcvenid="")) 0
	s ret=0
	i type="G" d
	.s chl=0 
	.f  s chl=$o(^DHCINGR(RcRtID,"GRI",chl)) q:(chl="")!(ret'=0)  d
	..q:'$d(^DHCINGR(RcRtID,"GRI",chl))
	..s recitminfo=^DHCINGR(RcRtID,"GRI",chl)
	..s invno=$p(recitminfo,"^",27)
	..q:invno=""
	..s point=RcRtID_"||"_chl
	..s inclb=$p(recitminfo,"^",1)
	..s rpamt=-$p(recitminfo,"^",31)
	..&sql(INSERT INTO DHC_PayTrans (PAYTR_Type, PAYTR_Pointer, PAYTR_CTLoc_DR, PAYTR_APCVM_DR, PAYTR_INCLB_DR, PAYTR_RpAmount, PAYTR_Date, PAYTR_Time, PAYTR_SSUSR_DR)
	       VALUES(:trantype,:point,:locid,:apcvenid,:inclb,:rpamt,:date,:time,:userid))
	..i SQLCODE'=0  d
	...s ret=-2
	..q:ret'=0
	e  i type="R" d
	.s chl=0
	.f  s chl=$o(^INGRT(RcRtID,"DHCGRR",chl)) q:(chl="")!(ret'=0)  d
	..q:'$d(^INGRT(RcRtID,"DHCGRR",chl))
	..s retitminfo=^INGRT(RcRtID,"DHCGRR",chl)
	..s invno=$p(retitminfo,"^",12)
	..q:invno=""
	..s point=RcRtID_"||"_chl
	..s inclb=$p(retitminfo,"^",6)
	..s rpamt=$p(retitminfo,"^",4)
	..&sql(INSERT INTO DHC_PayTrans (PAYTR_Type, PAYTR_Pointer, PAYTR_CTLoc_DR, PAYTR_APCVM_DR, PAYTR_INCLB_DR, PAYTR_RpAmount, PAYTR_Date, PAYTR_Time, PAYTR_SSUSR_DR)
	       VALUES(:trantype,:point,:locid,:apcvenid,:inclb,:rpamt,:date,:time,:userid))
	..i SQLCODE'=0  d
	...s ret=-2
	..q:ret'=0
	q ret
}

/// Description:判断业务单据明细是否已经生成付款单
/// Creator:wxj
/// CreatDate:2022-09-21
/// Return:1 已经生成付款单  0 未生成付款单
/// w ##class(web.DHCSTMHUI.DHCINGdRecInv).IfExistMadePay(188,"G")
ClassMethod IfExistMadePay(RowId As %String, Type As %String) As %Library.String
{
    n (RowId,Type)
    q:RowId="" 0
    s Ret=0
    i Type="G" d
    .s Ch=0
    .f  s Ch=$o(^DHCINGR(RowId,"GRI",Ch)) q:(Ch="")!(Ret'=0)  d
    ..s Ingri=RowId_"||"_Ch
    ..s Pay=$o(^DHCPAY(0,"TYPEGR","G",Ingri,""))
	..s:+Pay>0 Ret=1	
    e  i Type="R" d
	.s Ch=0
	.f  s Ch=$o(^INGRT(RowId,"DHCGRR",Ch)) q:(Ch="")!(Ret'=0)  d
	..s Ingrti=RowId_"||"_Ch
    ..s Pay=$o(^DHCPAY(0,"TYPEGR","R",Ingrti,""))
	..s:+Pay>0 Ret=1	
    q Ret
}

}
