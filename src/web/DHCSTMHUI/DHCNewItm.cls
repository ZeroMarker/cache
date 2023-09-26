Import sqluser

/// 待立项物资信息(供应链等)
/// 2017-08-02
/// XuChao
Class web.DHCSTMHUI.DHCNewItm Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTNEWITMM";

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCNewItm","GetNewItm",^bintmp(18))
Query GetNewItm(Params As %String) As Query(ROWSPEC = "NIRowId,Inci,InciCode,InciDesc,NIDesc,NISpec,NIModel,NIBrand,NIBUom,NIBUomDesc,NIPUom,NIPUomDesc,NIAlias,NISpPUom,NIRpPUom,NIRemark,NIImportFlag,NIRegNo,NIHighPrice,NIVendor,NIVendorDesc,NIManf,NIManfDesc,NIBAflag,NIExpireLen,NIHighRiskFlag,NIChargeFlag,NIAbbrev,NIImplantationMat,NISterileDateLen,NIZeroStk,NIRegCertExpDate,NIDateTime,NINo,TemPurchase,CentralPurFlag,BatchReq,ExpReq") [ SqlProc ]
{
}

ClassMethod GetNewItmExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s StartDate=PJObj.%Get("SciStartDate")
	s StartDate=..DH2L(StartDate)
	s EndDate=PJObj.%Get("SciEndDate")
	s EndDate=..DH2L(EndDate)
	s Desc=PJObj.%Get("SciDesc")
	s CreatedFlag=PJObj.%Get("CreatedFlag")
	s AckFlag=PJObj.%Get("AckFlag")
	q:(StartDate="")||(EndDate="") $$$OK
	
	s result=##class(%Library.ResultSet).%New()
	s StrSql="select NI_RowId,NI_InciDR,NI_LocDR,NI_UserDR,NI_TemPurchase,NI_CentralPurFlag,NI_BatchReq,NI_ExpReq,"
		_"NI_Date,NI_Time,NI_AckUserDR,NI_AckDate,NI_AckTime,NI_AckFlag,NI_Desc,NI_Spec,NI_Model,NI_Brand,"
		_"NI_BUom,NI_PUom,NI_Alias,NI_PRp,NI_PSp,NI_Remark,NI_Vendor,NI_Manf,NI_ImportFlag,NI_RegNo,NI_RegCertExpDate,NI_HighPrice,NI_BAFlag,"
		_"NI_ExpireLen,NI_HighRiskFlag,NI_ChargeFlag,NI_Abbrev,NI_ImplantationMat,NI_SterileDateLen,NI_ZeroStk,NI_No" 
		_" From DHC_NewItm where NI_Date BETWEEN '"_StartDate_"' AND '"_EndDate_"'"
	d result.Prepare(StrSql)
	d result.RuntimeModeSet(0)
	s Sc=result.Execute()
	i $$$ISERR(Sc) q $$$OK
	while (result.Next())
	{
		s NIRowId = result.Data("NI_RowId")
		s NIAckFlag=result.Data("NI_AckFlag")
		continue:(AckFlag'="")&&(NIAckFlag'=AckFlag)
		s Inci=result.Data("NI_InciDR")
		s Created="N"
		i Inci'="" s Created="Y"
		CONTINUE:(CreatedFlag'="")&&(CreatedFlag'=Created)
		s HospId=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciHospID(Inci)
		s InciCode="",InciDesc=""
		s:Inci'="" InciCode = $P(^INCI(Inci,1),"^",1)
		s:Inci'="" InciDesc=$P(^INCI(Inci,1),"^",2)
		s NIDesc = result.Data("NI_Desc") 
		CONTINUE:(Desc'="")&&(NIDesc'[Desc)  
		s NISpec=result.Data("NI_Spec")
		s NIModel = result.Data("NI_Model") 
		s NIBrand=result.Data("NI_Brand")
		s NIBUom=""
		s NIBUomDesc=result.Data("NI_BUom")
		s:NIBUomDesc'="" NIBUom=$o(^CT("UOM",0,"Desc",$$ALPHAUP^SSUTIL4(NIBUomDesc),""))
		s NIPUom=""
		s NIPUomDesc=result.Data("NI_PUom")
		s:NIPUomDesc'="" NIPUom=$o(^CT("UOM",0,"Desc",$$ALPHAUP^SSUTIL4(NIPUomDesc),""))
		s NIAlias=result.Data("NI_Alias")
		s NISpPUom=result.Data("NI_PSp")
		s NIRpPUom=result.Data("NI_PRp")
		s NIRemark=result.Data("NI_Remark")
		s NIImportFlag=result.Data("NI_ImportFlag")
		s NIRegNo=result.Data("NI_RegNo")
		s NIHighPrice=result.Data("NI_HighPrice")
		s NIVendor=result.Data("NI_Vendor")
		s NIManfDesc=result.Data("NI_Manf")
		s NIManf=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",NIManfDesc,"PH_Manufacturer",HospId)
		s NIBAflag=result.Data("NI_BAFlag")
		s NIExpireLen=result.Data("NI_ExpireLen")
		s NIHighRiskFlag=result.Data("NI_HighRiskFlag")
		s NIChargeFlag=result.Data("NI_ChargeFlag")
		s NIAbbrev=result.Data("NI_Abbrev")
		s NIImplantationMat=result.Data("NI_ImplantationMat")
		s NISterileDateLen=result.Data("NI_SterileDateLen")
		s NIZeroStk=result.Data("NI_ZeroStk")
		s NIRegCertExpDate=result.Data("NI_RegCertExpDate")
		s NIDate=result.Data("NI_AckDate")
		s NITime=result.Data("NI_AckTime")
		s NINo=result.Data("NI_No")
		s TemPurchase=result.Data("NI_TemPurchase")
		s CentralPurFlag=result.Data("NI_CentralPurFlag")
		s BatchReq=result.Data("NI_BatchReq")
		s ExpReq=result.Data("NI_ExpReq")
		s:NIDate'="" NIDate=..DL2H(NIDate)
		s:NITime'="" NITime=..TL2H(NITime)
		s NIDateTime=NIDate_" "_NITime

		s NIVendor=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",NIVendor,"APC_Vendor",HospId)
		s NIVendorDesc=$s(NIVendor'="":$p(^APC("APCVM",NIVendor),"^",3),1:"")
		
		d OutPutRowTrans
	}
	q $$$OK

OutPutRowTrans
	s Data=$lb(NIRowId,Inci,InciCode,InciDesc,NIDesc,
		NISpec,NIModel,NIBrand,NIBUom,NIBUomDesc,
		NIPUom,NIPUomDesc,NIAlias,NISpPUom,NIRpPUom,
		NIRemark,NIImportFlag,NIRegNo,NIHighPrice,NIVendor,
		NIVendorDesc,NIManf,NIManfDesc,NIBAflag,NIExpireLen,
		NIHighRiskFlag,NIChargeFlag,NIAbbrev,NIImplantationMat,NISterileDateLen,
		NIZeroStk,NIRegCertExpDate,NIDateTime,NINo,TemPurchase,CentralPurFlag,BatchReq,ExpReq)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:返回立项项目的详细信息
/// w ##class(web.DHCSTMHUI.DHCNewItm).GetItmDetail(12)
ClassMethod GetItmDetail(RowId As %String, HospId As %String) As %String
{
	n (RowId,HospId,%session)
	q:RowId="" "{}"
	&sql(select NI_RowId,NI_InciDR,NI_LocDR,NI_UserDR,NI_Date,NI_Time,
		NI_AckUserDR,NI_AckDate,NI_AckTime,NI_AckFlag,
		NI_Desc,NI_Spec,NI_Model,NI_Brand,NI_BUom,
		NI_PUom,NI_Alias,NI_PRp,NI_PSp,NI_Remark,
		NI_Vendor,NI_Manf,NI_ImportFlag,NI_RegNo,NI_RegCertExpDate,
		NI_HighPrice,NI_BAFlag,NI_ExpireLen,NI_HighRiskFlag,NI_ChargeFlag,
		NI_Abbrev,NI_ImplantationMat,NI_SterileDateLen,NI_ZeroStk,NI_SciId,
		NI_VendorCode,NI_No,NI_PUom,NI_PbNo,NI_DoubleFlag,
		NI_PRp,NI_ConsumeQty,NI_InciRemarks,NI_ReqUser,NI_ReqLoc,
		NI_ProfessorInfo,NI_TemPurchase,NI_CentralPurFlag,NI_BatchReq,NI_ExpReq
		into
		:NIRowId,:NIInciDR,:NILocDR,:NIUserDR,:NIDate,:NITime,
		:NIAckUserDR,:NIAckDate,:NIAckTime,:NIAckFlag,
		:NIDesc,:NISpec,:NIModel,:NIBrand,:NIBUom,
		:NIPUom,:NIAlias,:NIPRp,:NIPSp,:NIRemark,
		:NIVendor,:NIManf,:NIImportFlag,:NIRegNo,:NIRegCertExpDate,
		:NIHighPrice,:NIBAFlag,:NIExpireLen,:NIHighRiskFlag,:NIChargeFlag,
		:NIAbbrev,:NIImplantationMat,:NISterileDateLen,:NIZeroStk,:NISciId,
		:NIVendorCode,:NINo,:NIPUom,:NIPbNo,:NIDoubleFlag,
		:NIPRp,:NIConsumeQty,:NIInciRemarks,:NIReqUser,:NIReqLoc,
		:NIProfessorInfo,:TemPurchase,:CentralPurFlag,:BatchReq,:ExpReq
		from DHC_NewItm where %id=:RowId
	)
	q:SQLCODE=100 "{}"
	
	s:+NIPSp=0 NIPSp=NIPRp
	s NIBUomId=$s(NIBUom'="":$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(NIBUom),0)),1:"")
	s NIBUom=..sssComboStr(NIBUomId,NIBUom)
	s NIPUomId=$s(NIPUom'="":$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(NIPUom),0)),1:"")
	s NIPUom=..sssComboStr(NIPUomId,NIPUom)
	s NIReqLocDesc=$s(NIReqLoc'="":$p(^CTLOC(NIReqLoc),"^",2),1:"")
	s NIReqLoc=..sssComboStr(NIReqLoc,NIReqLocDesc)
	
	s ManageInfo=$p(NIProfessorInfo,"&",1)
	s ManageProfessorYes=$p(ManageInfo,"|",1)
	s ManageProfessorNo=$p(ManageInfo,"|",2)
	s ManageProfessorWait=$p(ManageInfo,"|",3)
	s HospInfo=$p(NIProfessorInfo,"&",2)
	s HospProfessorYes=$p(HospInfo,"|",1)
	s HospProfessorNo=$p(HospInfo,"|",2)
	s HospProfessorWait=$p(HospInfo,"|",3)
	s CommitteeInfo=$p(NIProfessorInfo,"&",3)
	s CommitteeYes=$p(CommitteeInfo,"|",1)
	s CommitteeNo=$p(CommitteeInfo,"|",2)
	s CommitteeWait=$p(CommitteeInfo,"|",3)
	s OfficeInfo=$p(NIProfessorInfo,"&",4)
	s OfficeYes=$p(OfficeInfo,"|",1)
	s OfficeNo=$p(OfficeInfo,"|",2)
	s OfficeWait=$p(OfficeInfo,"|",3)
	
	s (NIRegNoId,Manf,ManfId,ManfDesc,RegCertExpDate,RegCertDate,RegCertName,RegCertExpDateExtended)=""
	i NIRegNo'="" d
	.s NIRegNoId=$o(^DHCMRCT(0,"NO",NIRegNo,""),-1)
	.q:NIRegNoId=""
	.s ManfId=$p(^DHCMRCT(NIRegNoId),"^",2)
	.s RegCertExpDate=$p(^DHCMRCT(NIRegNoId),"^",20)
	.s RegCertExpDate=..DL2H(RegCertExpDate)
	.s RegCertDate=$p(^DHCMRCT(NIRegNoId),"^",19)
	.s RegCertDate=..DL2H(RegCertDate)
	.s RegCertName=$p(^DHCMRCT(NIRegNoId),"^",16)		//16? 13?
	.;s RegCertExpDateExtended=		;长期?
	
	i ManfId="" d
	.s ManfId=##class(web.DHCSTMHUI.Tools.CodeInputNew).validManf(NIManf,HospId)
	
	s ManfDesc=$s(ManfId'="":$p(^PHMNF(ManfId),"^",2),1:"")
	s Manf=..sssComboStr(ManfId,ManfDesc)
	
	s VendorId=##class(web.DHCSTMHUI.Tools.CodeInputNew).validVendor(NIVendor,HospId)
	s VendorDesc=$s(VendorId'="":$p(^APC("APCVM",VendorId),"^",3),1:"")
	s PbVendor=..sssComboStr(VendorId,VendorDesc)
	
	s DataStr=NIDesc_"^"_NISpec_"^"_NIModel_"^"_NIBrand_"^"_NIAbbrev
		_"^"_NIImportFlag_"^"_NIBAFlag_"^"_NIHighRiskFlag_"^"_NIChargeFlag_"^"_NIImplantationMat
		_"^"_NIZeroStk_"^"_RowId_"^"_NIPUom_"^"_NIPbNo_"^"_NIDoubleFlag
		_"^"_NIPRp_"^"_NIConsumeQty_"^"_NIInciRemarks_"^"_NIReqUser_"^"_NIReqLoc
		_"^"_ManageProfessorYes_"^"_ManageProfessorNo_"^"_ManageProfessorWait_"^"_HospProfessorYes_"^"_HospProfessorNo
		_"^"_HospProfessorWait_"^"_CommitteeYes_"^"_CommitteeNo_"^"_CommitteeWait_"^"_OfficeYes
		_"^"_OfficeNo_"^"_OfficeWait_"^"_NIRegNo_"^"_NIRegNoId_"^"_ManfId
		_"^"_ManfDesc_"^"_RegCertExpDate_"^"_RegCertDate_"^"_RegCertName_"^"_RegCertExpDateExtended
		_"^"_NIBUom_"^"_NIPSp_"^"_Manf_"^"_NIHighPrice_"^"_PbVendor_"^"_TemPurchase_"^"_CentralPurFlag
		_"^"_BatchReq_"^"_ExpReq
	s TitleStr="InciDesc^Spec^Model^Brand^AliasStr"
		_"^ImpFlag^BaFlag^HighRiskFlag^ChargeFlag^ImplantationMat"
		_"^ZeroStk^NIRowId^PUom^PbNo^DoubleFlag"
		_"^RpPUom^ConsumeQty^Remarks^ReqUser^ReqLoc"
		_"^ManageProfessorYes^ManageProfessorNo^ManageProfessorWait^HospProfessorYes^HospProfessorNo"
		_"^HospProfessorWait^CommitteeYes^CommitteeNo^CommitteeWait^OfficeYes"
		_"^OfficeNo^OfficeWait^RegCertNo^NIRegNoId^ManfId"
		_"^ManfDesc^RegCertExpDate^RegCertDate^RegCertName^RegCertExpDateExtended"
		_"^BUom^SpPUom^Manf^HighPrice^PbVendor^TemPurchase^CentralPurFlag"
		_"^BatchNoReq^ExpDateReq"
	s JsonStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q JsonStr
}

ClassMethod jsGetSpecifications(Params As %String) As %Library.String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s RtnObj=..GetSpecifications(Params)
	q RtnObj.Json()
}

/// Descript:	同步供应链物资
/// Creator:	lxt
/// CreateDate:	20211026
/// Table:		DHC_NewItm
/// Input:		主单信息
/// Return：	成功，失败
/// w ##class(web.DHCSTMHUI.DHCNewItm).getHospInc(123)
ClassMethod GetSpecifications(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")

	s StartDate=PJObj.%Get("SciStartDate")
	s EndDate=PJObj.%Get("SciEndDate")
	s HospId=PJObj.%Get("BDPHospital")
	q:(StartDate="")||(EndDate="") RtnObj.Err(-1,"","日期不能为空！","",0)
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s StartDate=$zd(StartDate,3)_" "_"00:00:00"
	s EndDate=$zd(EndDate,3)_" "_"23:59:59"
	
	s Ret=##class(web.DHCSTMHUI.ServiceForECS).getSpecifications("",StartDate,EndDate,HospId)
	q:Ret'=0 RtnObj.Err(-2,"","同步失败！")
	
	q RtnObj
}

}
