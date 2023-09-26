Import sqluser

/// Descript:	院区改造原始数据处理
/// Creator:	lxt
/// CreateDate:	20200519
Class web.DHCSTMHUI.NotCommon.MatForBDPDataDeal Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// d ##class(web.DHCSTMHUI.NotCommon.MatForBDPDataDeal).DealMaterialHospData()
/// 处理院区
ClassMethod DealMaterialHospData()
{
	s DefHospId=2
	d ..DealDrugInfo(DefHospId)  //三大项
	d ..DealBasicData(DefHospId)  //基础数据
	d ..DealSetData(DefHospId)  //配置数据
}

/// 三大项
ClassMethod DealDrugInfo(DefHospId)
{
	&sql(update DHC_ItmAddHosp set IAH_Hospital_DR=:DefHospId where IAH_IncItm_DR->INCI_INCSC_DR->INCSC_StkType='M' and isnull(IAH_Hospital_DR,'')='')
	&sql(update ARC_ItemHosp set HOSP_Hospital_DR=:DefHospId where HOSP_ParRef->ARCIM_RowId IN (SELECT INCI_OriginalARCIM_DR FROM inc_itm WHERE INCI_INCSC_DR->INCSC_StkType='M') and isnull(HOSP_Hospital_DR,'')='')
	s TableName="DHC_TarItem"
	&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT DISTINCT :TableName,OLT_Tariff_DR,:DefHospId FROM DHC_OrderLinkTar 
		WHERE OLT_ARCIM_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='M' and OLT_Tariff_DR 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
}

/// 基础数据
ClassMethod DealBasicData(DefHospId)
{
	//不带医院标识，使用BDP_MappingHosp
	s TableName="APC_VendCat"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,APCVC_RowId,:DefHospId FROM APC_VendCat WHERE APCVC_StkType='M' AND APCVC_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHCST_BookCat"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,BC_RowID,:DefHospId FROM DHCST_BookCat WHERE BC_RowID 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_ItmChargeType"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,ICT_RowId,:DefHospId FROM DHC_ItmChargeType WHERE ICT_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_LocItemGrp"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,LIG_RowID,:DefHospId FROM DHC_LocItemGrp WHERE LIG_RowID 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_MarkType"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,MT_Rowid,:DefHospId FROM DHC_MarkType WHERE MT_Type='M' and MT_Rowid 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_StkDecimal"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,SD_RowID,:DefHospId FROM DHC_StkDecimal WHERE SD_Type='M' and SD_RowID 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_MarkRule"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,MR_Rowid,:DefHospId FROM DHC_MarkRule WHERE MR_Type='M' and MR_Rowid 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_ItmNotUseReason"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,DIUR_RowID,:DefHospId FROM DHC_ItmNotUseReason WHERE DIUR_RowID 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_ItmQualityLevel"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,QL_RowId,:DefHospId FROM DHC_ItmQualityLevel WHERE QL_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="INC_SterileCategory"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,SCAT_RowId,:DefHospId FROM INC_SterileCategory WHERE SCAT_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_StkCatGroup"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,SCG_Rowid,:DefHospId FROM DHC_StkCatGroup WHERE SCG_Type='M' and SCG_Rowid 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="INC_StkCat"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,INCSC_RowId,:DefHospId FROM INC_StkCat WHERE INCSC_StkType='M' and INCSC_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_OperateType"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,IPT_RowId,:DefHospId FROM DHC_OperateType WHERE IPT_Type in ('IM','OM') and IPT_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_ItmPBLevel"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,PBL_RowId,:DefHospId FROM DHC_ItmPBLevel WHERE PBL_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_PublicBiddingList"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,DHCPBL_Rowid,:DefHospId FROM DHC_PublicBiddingList WHERE DHCPBL_Type='M' and DHCPBL_Rowid 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="INC_ReasonForAdjustment"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,ADJ_RowId,:DefHospId FROM INC_ReasonForAdjustment WHERE ADJ_StkType='M' and ADJ_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_ReasonForAdjustPrice"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,REA_RowId,:DefHospId FROM DHC_ReasonForAdjustPrice WHERE REA_StkType='M' and REA_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_IncReasonForStockScrap"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,REASON_ScrapRowID,:DefHospId FROM DHC_IncReasonForStockScrap WHERE REASON_ScrapType='M' and REASON_ScrapRowID 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="INC_ReasonForReturn"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,RET_Rowid,:DefHospId FROM INC_ReasonForReturn WHERE RET_StkType='M' and RET_Rowid 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="INC_POCanc_FullFillReason"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,CFR_RowId,:DefHospId FROM INC_POCanc_FullFillReason WHERE CFR_StkType='M' and CFR_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_ReasonForRefuseRequest"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,RF_RowId,:DefHospId FROM DHC_ReasonForRefuseRequest WHERE RF_StkType='M' and RF_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_SourceOfFund"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,SOF_RowId,:DefHospId FROM DHC_SourceOfFund WHERE SOF_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_StkLocGroup"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,SLG_RowId,:DefHospId FROM DHC_StkLocGroup WHERE SLG_Type='M' and SLG_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
		
	//补充
	s TableName="DHC_PlanStatus"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,DHCPS_RowId,:DefHospId FROM DHC_PlanStatus WHERE DHCPS_StkType='M' and DHCPS_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
		
	s TableName="DHC_MatCatClinical"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,MCC_Rowid,:DefHospId FROM DHC_MatCatClinical WHERE MCC_Rowid 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
		
	s TableName="DHC_MatCatSpecial"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,MCS_Rowid,:DefHospId FROM DHC_MatCatSpecial WHERE MCS_Rowid 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_MatCatOfficial"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,MCO_Rowid,:DefHospId FROM DHC_MatCatOfficial WHERE MCO_Rowid 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	//自带医院标识
	/*
	s TableName="APC_Vendor"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(update dhc_stvendor set stv_hospital_dr=:DefHospId where STV_Vendor_DR->APCVM_Type='M' and isnull(stv_hospital_dr,'')='')
	
	s TableName="DHC_Carrier"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(update DHC_Carrier set ca_hospital_dr=:DefHospId where CA_Type='M' and isnull(ca_hospital_dr,'')='')
	
	s TableName="PH_Manufacturer"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(update PH_Manufacturer set PHMNF_Hospital_DR=:DefHospId where PHMNF_RowId in(SELECT MANF_PhcManf_DR FROM DHC_Manf_AddionInfo WHERE MANF_Type='M') and isnull(PHMNF_Hospital_DR,'')='')
	
	s TableName="DHC_STOrigin"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(update DHC_STOrigin set Orig_Hosp_Dr=:DefHospId where Orig_Type='M' and isnull(Orig_Hosp_Dr,'')='')
	*/
	
	s TableName="APC_Vendor"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,APCVM_RowId,:DefHospId FROM APC_Vendor WHERE APCVM_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
	
	s TableName="DHC_Carrier"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,CA_Rowid,:DefHospId FROM DHC_Carrier WHERE CA_Rowid 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
		
	s TableName="PH_Manufacturer"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,PHMNF_RowId,:DefHospId FROM PH_Manufacturer WHERE PHMNF_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
		
	s TableName="DHC_STOrigin"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,Orig_RowId,:DefHospId FROM DHC_STOrigin WHERE Orig_RowId 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
}

/// 配置数据
ClassMethod DealSetData(DefHospId)
{
	//DHCSTM_HvMapArcic
	&sql(update DHC_HvMapArc set HMA_Hosp_DR=:DefHospId where isnull(HMA_Hosp_DR,'')='')
	
	//DHC_StkSysCounter
	s TableName="DHC_StkSysCounter"
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i TableType'="G" d
	.&sql(insert into BDP_MappingHosp(BDPMPH_TableName,BDPMPH_DataReference,BDPMPH_Hospital) 
		SELECT :TableName,SSC_RowID,:DefHospId FROM DHC_StkSysCounter WHERE SSC_SSA_Parref->SSA_GrpType='M' and SSC_RowID 
		NOT IN(SELECT BDPMPH_DataReference FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName))
}

/// w ##class(web.DHCSTMHUI.NotCommon.MatForBDPDataDeal).test()
ClassMethod test() As %String
{

	s ClassMethodStr="User.BDPMappingHosp"
	s CompiledObj=##class(%Dictionary.CompiledClass).%OpenId(ClassMethodStr,0)
	q:'$IsObject(CompiledObj) "Y"
	q "N"
}

}
