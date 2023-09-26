/// 新草药医嘱模式  药品数据导入方法
/// Creator:陈莹 
/// CreatDate:2018-11-18
/// 基础数据平台组
Class web.BDPExt.CYBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹 
/// CreatDate:2018-11-18
/// 过程：先保存药学项，库存项 ，再去保存医嘱项 收费项， ARCIM_PHCDF_DR-->药学项子表 Phc_DrgForm，
/// INCI_OriginalARCIM_DR-->ARC_ItmMast医嘱项表
ClassMethod SaveEntity(Ceobj As web.BDPExt.CYEntity) As %String
{
	n (Ceobj,%session)
	s $zt="ERROR"
	s ImportResult=""
	//住院单次剂量偏好：H-偏好取半(即不足一半取半,足够一半取整), FD-偏好向下取整(即不为整数则向下取整，最小值不低于1),FU-偏好向上取整(即不为整数则向上取整),A-按实际单次剂量计算
	s Ceobj.DARCIMPartialValue=$case(Ceobj.DARCIMPartialValue,"偏好取半":"H","偏好向下取整":"FD","偏好向上取整":"FU","":"FU","按实际单次剂量计算":"A",:Ceobj.DARCIMPartialValue)  //空时默认"偏好向上取整"
	//门诊单次剂量偏好：H-偏好取半(即不足一半取半,足够一半取整), FD-偏好向下取整(即不为整数则向下取整，最小值不低于1),FU-偏好向上取整(即不为整数则向上取整),A-按实际单次剂量计算
	s Ceobj.DARCIMOPPartialValue=$case(Ceobj.DARCIMOPPartialValue,"偏好取半":"H","偏好向下取整":"FD","偏好向上取整":"FU","":"FU","按实际单次剂量计算":"A",:Ceobj.DARCIMPartialValue)  //空时默认"偏好向上取整"
	//字段名和值之间用上箭头"^" 拼接，然后它们之间再用"|"拼接。
	///库存项
	s inciliststr="INCICode^"_Ceobj.INCICode_"|INCIDesc^"_Ceobj.INCIDesc_"|INCALIAS^"_Ceobj.INCALIAS_"|Rp^"_Ceobj.Rp_"|Sp^"_Ceobj.Sp
	s inciliststr=inciliststr_"|INCICTUOMPurchDR^"_Ceobj.INCICTUOMPurchDR_"|INCICTUOMPurchFac^"_Ceobj.INCICTUOMPurchFac_"|INCICTUOMDR^"_Ceobj.INCICTUOMDR_"|INCICTUOMOutPatDR^"_Ceobj.INCICTUOMOutPatDR_"|INCICTUOMOutPatFac^"_Ceobj.INCICTUOMOutPatFac
	s inciliststr=inciliststr_"|INCICTUOMInPatDR^"_Ceobj.INCICTUOMInPatDR_"|INCICTUOMInPatFac^"_Ceobj.INCICTUOMInPatFac_"|INFOSpec^"_Ceobj.INFOSpec_"|INCIINCSCDR^"_Ceobj.INCIINCSCDR_"|INFOSkinTest^"_Ceobj.INFOSkinTest
	s inciliststr=inciliststr_"|INFOPDrugbase2^"_Ceobj.INFOPDrugbase2_"|INFOPDrugbase1^"_Ceobj.INFOPDrugbase1_"|INFORemark^"_Ceobj.INFORemark_"|INFODrugbase2^"_Ceobj.INFODrugbase2_"|INFOBasicDrug^"_Ceobj.INFOBasicDrug
	s inciliststr=inciliststr_"|INFOBAflag^"_Ceobj.INFOBAflag_"|INFOInHosFlag^"_Ceobj.INFOInHosFlag_"|INFORec^"_Ceobj.INFORec_"|INFOTest^"_Ceobj.INFOTest_"|INFOCodex^"_Ceobj.INFOCodex
	s inciliststr=inciliststr_"|INCINotUseFlag^"_Ceobj.INCINotUseFlag_"|INFOPackUom^"_Ceobj.INFOPackUom_"|INFOPackUomFactor^"_Ceobj.INFOPackUomFactor_"|INFOMTDR^"_Ceobj.INFOMTDR
	s inciliststr=inciliststr_"|INFOOTC^"_Ceobj.INFOOTC_"|INFOQualityLevel^"_Ceobj.INFOQualityLevel_"|INFOImportFlag^"_Ceobj.INFOImportFlag_"|PriceDate^"_Ceobj.PriceDate_"|INCIBarCode^"_Ceobj.INCIBarCode
	s inciliststr=inciliststr_"|INFOQualityNo^"_Ceobj.INFOQualityNo_"|INFOInMedBasis^"_Ceobj.INFOInMedBasis_"|INCIReportingDays^"_Ceobj.INCIReportingDays_"|INFOStandardCode^"_Ceobj.INFOStandardCode_"|INFOMaxSp^"_Ceobj.INFOMaxSp
	s inciliststr=inciliststr_"|INFOPbManfDR^"_Ceobj.INFOPbManfDR_"|INFOPbVendorDR^"_Ceobj.INFOPbVendorDR_"|INFOPbRp^"_Ceobj.INFOPbRp_"|INFOHighPrice^"_Ceobj.INFOHighPrice_"|INFOComFrom^"_Ceobj.INFOComFrom
	s inciliststr=inciliststr_"|INFOBCDr^"_Ceobj.INFOBCDr_"|INFOPrcFileD^"_Ceobj.INFOPrcFileD_"|INFOPrcFile^"_Ceobj.INFOPrcFile_"|INFOPBLevel^"_Ceobj.INFOPBLevel_"|INFOPbCarrierDR^"_Ceobj.INFOPbCarrierDR
	s inciliststr=inciliststr_"|ISCDark^"_Ceobj.ISCDark_"|ISCAirtight^"_Ceobj.ISCAirtight_"|ISCDry^"_Ceobj.ISCDry_"|ISCCommonTemp^"_Ceobj.ISCCommonTemp_"|INFODrugUse^"_Ceobj.INFODrugUse
	s inciliststr=inciliststr_"|ISCGloomyCool^"_Ceobj.ISCGloomyCool_"|ISCCoolGloomy^"_Ceobj.ISCCoolGloomy_"|ISCSeal^"_Ceobj.ISCSeal_"|ISCRadiation^"_Ceobj.ISCRadiation_"|ISCVentilate^"_Ceobj.ISCVentilate
	s inciliststr=inciliststr_"|ISCMinHumidity^"_Ceobj.ISCMinHumidity_"|ISCDAMPPROOF^"_Ceobj.ISCDAMPPROOF_"|ISCFREEZE^"_Ceobj.ISCFREEZE_"|ISCCOLDST^"_Ceobj.ISCCOLDST_"|ISCMeltPack^"_Ceobj.ISCMeltPack
	s inciliststr=inciliststr_"|ISCMaxTemp^"_Ceobj.ISCMaxTemp_"|ISCMinTemp^"_Ceobj.ISCMinTemp_"|ISCMaxHumidity^"_Ceobj.ISCMaxHumidity
	
	s inciliststr=inciliststr_"|INFOEasyConfuse^"_Ceobj.INFOEasyConfuse_"|INFOCentralPurFlag^"_Ceobj.INFOCentralPurFlag //2019-12-25	
	s inciliststr=inciliststr_"|ISCRemark^"_Ceobj.ISCRemark_"|INFONegotiateFlag^"_Ceobj.INFONegotiateFlag  //2020-01-06
	s inciliststr=inciliststr_"|HospId^"_Ceobj.LinkHospId	  //2020-03-13 云HIS增加医院
	s inciliststr=inciliststr_"|INFOPurPlanCode^"_Ceobj.INFOPurPlanCode    //2020-03-27药品采购码
	s inciliststr=inciliststr_"|INFOOrigin^"_Ceobj.INFOOrigin    //2022-05-13产地
	s inciliststr=inciliststr_"|INFOMonitorFlag^"_Ceobj.INFOMonitorFlag    //2023-04-23院内重点监控药物(Y/N)
	///药学项
	s phcdatastr="PHCCCode^"_Ceobj.ARCIMCode_"|PHCCDesc^"_Ceobj.ARCIMDesc_"|ARCIMCode^"_Ceobj.ARCIMCode_"|ARCIMDesc^"_Ceobj.ARCIMDesc_"|PHCDFCTUOMDR^"_Ceobj.PHCDFCTUOMDR
	s phcdatastr=phcdatastr_"|PHCDGenericDR^"_Ceobj.PHCDGenericDR_"|PHCDFPHCINDR^"_Ceobj.PHCDFPHCINDR_"|PHCDFPHCFDR^"_Ceobj.PHCDFPHCFDR_"|PHCDFCTUOMFac^"_Ceobj.PHCDFCTUOMFac_"|PHCDFCTUOMDR^"_Ceobj.PHCDFCTUOMDR
	s phcdatastr=phcdatastr_"|EQDefaultDose1^"_Ceobj.EQDefaultDose1_"|EQCTUOMDR1^"_Ceobj.EQCTUOMDR1_"|EQQty1^"_Ceobj.EQQty1_"|PHCDFPHCDUDR^"_Ceobj.PHCDFPHCDUDR_"|PHCDFPHCFRDR^"_Ceobj.PHCDFPHCFRDR
	s phcdatastr=phcdatastr_"|PHCDPHCPODR^"_Ceobj.PHCDPHCPODR_"|PHCDPHMNFDR^"_Ceobj.PHCDPHMNFDR_"|EQDefaultDose2^"_Ceobj.EQDefaultDose2_"|EQCTUOMDR2^"_Ceobj.EQCTUOMDR2_"|EQQty2^"_Ceobj.EQQty2
	s phcdatastr=phcdatastr_"|PHCDFCQZTFlag^"_Ceobj.PHCDFCQZTFlag_"|PHCDFONEFlag^"_Ceobj.PHCDFONEFlag_"|PHCDFAntibioticFlag^"_Ceobj.PHCDFAntibioticFlag_"|PHCDFCalcuDose^"_Ceobj.PHCDFCalcuDose_"|PHCDFDeductPartially^"_Ceobj.PHCDFDeductPartially
	s phcdatastr=phcdatastr_"|PHCDFDDD^"_Ceobj.PHCDFDDD_"|PHCDFCriticalFlag^"_Ceobj.PHCDFCriticalFlag_"|PHCDOfficialCode^"_Ceobj.PHCDOfficialCode_"|PHCDFIPSkinTestYY^"_Ceobj.PHCDFIPSkinTestYY_"|PHCDFOPSkinTestYY^"_Ceobj.PHCDFOPSkinTestYY
	s phcdatastr=phcdatastr_"|PHCDFProvinceComm^"_Ceobj.PHCDFProvinceComm_"|PHCDFTpnFlag^"_Ceobj.PHCDFTpnFlag_"|PHCDFWHODDDUomDr^"_Ceobj.PHCDFWHODDDUomDr_"|PHCDFWHODDD^"_Ceobj.PHCDFWHODDD_"|PHCDFWHONET^"_Ceobj.PHCDFWHONET
	s phcdatastr=phcdatastr_"|PHCDLabelName21^"_Ceobj.PHCDLabelName21_"|PHCDFOfficialCode2^"_Ceobj.PHCDFOfficialCode2_"|PHCDFOfficialCode1^"_Ceobj.PHCDFOfficialCode1_"|PHCDLabelName1^"_Ceobj.PHCDLabelName1_"|PHCDLabelName22^"_Ceobj.PHCDLabelName22
	s phcdatastr=phcdatastr_"|PHCDFSpec^"_Ceobj.PHCDFSpec_"|PHCDFGranulesFact^"_Ceobj.PHCDFGranulesFact_"|PHCDFivgttSpeed^"_Ceobj.PHCDFivgttSpeed_"|PHCDFCHPhSpecInstr^"_Ceobj.PHCDFCHPhSpecInstr
	
	s phcdatastr=phcdatastr_"|PHCDFChemotherapeutic^"_Ceobj.PHCDFChemotherapeutic_"|PHCDFHighRisk^"_Ceobj.PHCDFHighRisk_"|PHCDFFirstAid^"_Ceobj.PHCDFFirstAid_"|PHCDFOMFlag^"_Ceobj.PHCDFOMFlag _"|PHCDFDope^"_Ceobj.PHCDFDope  //2019-12-25
	s phcdatastr=phcdatastr_"|PHCDFTumble^"_Ceobj.PHCDFTumble_"|PHCDFAllergyFlag^"_Ceobj.PHCDFAllergyFlag_"|PHCDFDietTaboo^"_Ceobj.PHCDFDietTaboo
	
	s phcdatastr=phcdatastr_"|EQDefault1^"_Ceobj.EQDefault1_"|EQDefault2^"_Ceobj.EQDefault2   //2020-01-06
	s phcdatastr=phcdatastr_"|PHCDFNoAllergy^"_Ceobj.PHCDFNoAllergy_"|PHCDFAntiLevSCDIDr^"_Ceobj.PHCDFAntiLevSCDIDr   //2022-1-05

	s ^tmpcy("web.BDPExt.CYEntity","inciliststr")=inciliststr
	s ^tmpcy("web.BDPExt.CYEntity","phcdatastr")=phcdatastr
	//w ##class(web.DHCST.Tools.InputDrugBasicLevelData).SaveDrug(^tmpcy("web.BDPExt.CYEntity","inciliststr"),^tmpcy("web.BDPExt.CYEntity","phcdatastr"),"","","")
	Ts     
	
	try
	{
		//药学项id^库存项ID  //"5542||1^5549"   -1^错误信息
		///s ret=##class(web.DHCST.Tools.InputDrugBasicLevelData).SaveDrug(inciliststr, phcdatastr,"","","")
		s ret=##class(PHA.TOOLS.Import.Drug).Save(inciliststr, phcdatastr,"","","") //2020-01-07 调用药品组新接口
	}
	catch myvar
	{
		s ret="-1^"_$ze
	}
	s (drugID,inciID,myARCIMRowId,TARIRowId)=""
	if ($p(ret,"^",1)["||")&&($p(ret,"^",2)>0)
	{
		s:Ceobj.TARIStartDate="" Ceobj.TARIStartDate=Ceobj.ARCIMEffDate  //2019-02-24
		s:Ceobj.TPStartDate="" Ceobj.TPStartDate=Ceobj.TARIStartDate  //2019-02-24
		s:Ceobj.INCTRStartDate="" Ceobj.INCTRStartDate=Ceobj.TARIStartDate  //2019-02-24
		s drugID=$p(ret,"^",1)
		s inciID=$p(ret,"^",2)
		S INCIIsTrfFlag=$P($G(^INCI(inciID,2)),"^",6)
		i INCIIsTrfFlag["Both" s $P(^INCI(inciID,2),"^",6)="B"   ///Both Iss & Trf  表结构有问题
		///医嘱项
		s myARCIMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Ceobj.ARCIMCode,Ceobj.LinkHospId)  //$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.ARCIMCode),0))    ///已存在的医嘱项跳过
		if (myARCIMRowId="")
		{
			//医嘱项
			s arcimeobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.ARCItmMast")
			s arcimeobj.LinkHospId=Ceobj.LinkHospId
			s arcimeobj.ARCIMRowId=""
			s arcimeobj.ARCIMAbbrev=Ceobj.ARCIMDesc
			s arcimeobj.ARCIMItemCatDR=Ceobj.OrdSubCat
			s arcimeobj.ARCIMBillSubDR=Ceobj.BillSubCat
			//门诊发药单位同步保存到医嘱项的计价单位上  2021-01-28去掉，不再同步
			//s arcimeobj.ARCIMBillingUOMDR=Ceobj.INCICTUOMOutPatDR  
			s arcimeobj.ARCIMEffDate=Ceobj.ARCIMEffDate //2019-02-12
			s arcimeobj.ARCIMEffDateTo=Ceobj.ARCIMEffDateTo
			s arcimeobj.ARCIMPHCDFDR=drugID	  ///PHCDrgForm
			s arcimeobj.ARCIMDefPriorityDR=Ceobj.Priority
			s arcimeobj.ARCIMOrderOnItsOwn=Ceobj.Onitsown
			i (arcimeobj.ARCIMOrderOnItsOwn'="N") s arcimeobj.ARCIMOrderOnItsOwn="Y"
			s ARCIMSaveResult=##class(web.DHCBL.CT.ARCItmMast).SaveEntity(arcimeobj)	
			s myARCIMRowId=##class(web.BDPExt.FunLib).GetResultRowId(ARCIMSaveResult)
		}
		
		if (myARCIMRowId'="")
		{
			
			//保存完医嘱项后要修改库存项里的医嘱项dr，指向这条医嘱项
			IF myARCIMRowId["||"
			{
				s inciobj=##class(User.INCItm).%OpenId(inciID,0)
				if inciobj'=""
				{
					Do inciobj.INCIOriginalARCIMDRSetObjectId(myARCIMRowId) 
					s sc=inciobj.%Save()
					do inciobj.%Close()
					if $$$ISERR(sc)
					{
						s ImportResult="{success:'false',errorinfo:'保存库存项的医嘱项指针失败！'}" 
					}
				}
				else
				{
					s ImportResult="{success:'false',errorinfo:'保存库存项的医嘱项指针失败！'}" 
					
				}
			}
			else
			{
				s ImportResult="{success:'false',errorinfo:'保存库存项的医嘱项指针失败!'}" 
			}
			if ImportResult=""
			{
				///医嘱项别名
				if Ceobj.ALIASText'=""
				{
					s aliaslength=$l(Ceobj.ALIASText,"/")
					for i=1:1:aliaslength
					{	
						continue:$p(Ceobj.ALIASText,"/",i)=""
						s aliaseobj=##class(web.Entity.CT.ARCAlias).%New()
						s aliaseobj.ALIASARCIMDR=myARCIMRowId
						s aliaseobj.ALIASDateFrom=Ceobj.ARCIMEffDate //2019-02-24
						s aliaseobj.ALIASDateTo=Ceobj.ARCIMEffDateTo
						s aliaseobj.ALIASText=$p(Ceobj.ALIASText,"/",i)	
						d ##class(web.DHCBL.CT.ARCAlias).SaveEntity(aliaseobj)
					}
				}
				///医嘱项扩展表DHC_ItmMast
				S DARCIMRowid=$O(^DHCItmMast("0","ARCIM",myARCIMRowId,0))
				if DARCIMRowid=""
				{
					s ditmobj=##class(User.DHCItmMast).%New()
					d ditmobj.DARCIMARCIMDRSetObjectId(myARCIMRowId)
					s ditmobj.DARCIMLimitQty=Ceobj.DARCIMLimitQty
					s ditmobj.DARCIMWarningUseQty=Ceobj.DARCIMMaxQty
					s ditmobj.DARCIMFreeDrugFlag=Ceobj.DARCIMFreeDrugFlag  //免费药标志(Y/N)
					s ditmobj.DARCIMCanCrossDay="N"  //默认为N，Y时可修改药品材料开医嘱事件 2021-06-25修改为N
					s ditmobj.DARCIMCMAllowEntryDecimal=Ceobj.DARCIMCMAllowEntryDecimal  /// 草药是否允许录入小数(Y/N)  2021-01-05
					s ditmobj.DARCIMPartialValue=Ceobj.DARCIMPartialValue  ///  住院单次剂量偏好(偏好取半,偏好向下取整,偏好向上取整,按实际单次剂量计算),空时默认"偏好向上取整"
					s ditmobj.DARCIMOPPartialValue=Ceobj.DARCIMOPPartialValue  ///  门诊单次剂量偏好(偏好取半,偏好向下取整,偏好向上取整,按实际单次剂量计算),空时默认"偏好向上取整" 20221024add
					s sc=ditmobj.%Save()
				} 
				else
				{
					s ditmobj=##class(User.DHCItmMast).%OpenId(DARCIMRowid)
					d ditmobj.DARCIMARCIMDRSetObjectId(myARCIMRowId)
					s ditmobj.DARCIMLimitQty=Ceobj.DARCIMLimitQty
					s ditmobj.DARCIMWarningUseQty=Ceobj.DARCIMMaxQty
					s ditmobj.DARCIMFreeDrugFlag=Ceobj.DARCIMFreeDrugFlag
					s ditmobj.DARCIMCMAllowEntryDecimal=Ceobj.DARCIMCMAllowEntryDecimal  /// 草药是否允许录入小数(Y/N)  2021-01-05
					s ditmobj.DARCIMPartialValue=Ceobj.DARCIMPartialValue  ///  住院单次剂量偏好(偏好取半,偏好向下取整,偏好向上取整,按实际单次剂量计算),空时默认"偏好向上取整"
					s ditmobj.DARCIMOPPartialValue=Ceobj.DARCIMOPPartialValue  ///  门诊单次剂量偏好(偏好取半,偏好向下取整,偏好向上取整,按实际单次剂量计算),空时默认"偏好向上取整" 20221024add
					s sc=ditmobj.%Save()
				} 
				
				
				
				//收费项
				s tarieobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarItem")
				s tarieobj.LinkHospId=Ceobj.LinkHospId
				s tarieobj.TARIRowId=""					
				s tarieobj.TARICode=Ceobj.TARICode   //收费项代码
				s tarieobj.TARIDesc=Ceobj.TARIDesc   //收费项名称
				s tarieobj.TARIUOM=Ceobj.INCICTUOMDR     //收费项单位=库存项基本单位 
				s tarieobj.TARISubCate=Ceobj.TarSubCat
				s tarieobj.TARIInpatCate=Ceobj.InpaSubCat
				s tarieobj.TARIOutpatCate=Ceobj.OutpaSubCat
				s tarieobj.TARIEMCCate=Ceobj.EmSubCat
				s tarieobj.TARIAcctCate=Ceobj.AcctSubCat
				s tarieobj.TARIMRCate=Ceobj.MrSubCat
				s tarieobj.TARIMCNew=Ceobj.MrSubCatNew   
				s:tarieobj.TARIActiveFlag="" tarieobj.TARIActiveFlag="Y"  
				s tarieobj.TARIInsuName=Ceobj.TARIInsuName
				s tarieobj.TARIInsuCode=Ceobj.TARIInsuCode
				s tarieobj.TARIConnote=Ceobj.TARIConnote
				s tarieobj.TARIRemark=Ceobj.TARIRemark
				s tarieobj.TARIExclude=Ceobj.TARIExclude
				s tarieobj.TARIChargeBasis=Ceobj.TARIChargeBasis
				s tarieobj.TARIEngName=Ceobj.TARIEngName
				s tarieobj.TARIExternalCode=Ceobj.TARIExternalCode 
				s TARISaveResult=##class(web.DHCBL.CT.DHCTarItem).SaveEntity(tarieobj)  
				s TARIRowId=##class(web.BDPExt.FunLib).GetResultRowId(TARISaveResult)
				if (TARIRowId'="")
				{
					if Ceobj.TARIALIAS'=""  //收费项别名
					{
						s aliaslength=$l(Ceobj.TARIALIAS,"/")
						for i=1:1:aliaslength
						{	
							///收费项别名
							s tiaeobj=##class(web.Entity.CT.DHCTarItemAlias).%New()
							s tiaeobj.TIATARIDR=TARIRowId
							s tiaeobj.TIAAlias=$p(Ceobj.TARIALIAS,"/",i)	
							d ##class(web.DHCBL.CT.DHCTarItemAlias).SaveEntity(tiaeobj)
						}
					}
					
							
					//收费项价格
					s tpeobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarItemPrice")
					//INCICTUOMPurchDR入库单位   INCICTUOMDR基本单位
					s tpeobj.TPPrice=Ceobj.Sp/Ceobj.INCICTUOMPurchFac
					//s:tpeobj.TPPatInsType="" tpeobj.TPPatInsType=##class(web.DHCBL.CT.DHCTarItem).GetDefPatInsType(Ceobj.LinkHospId)   ///费用类别不能为空，,默认取包含自费的费别，否则价格为0
					s tpeobj.TPTARIParRef=TARIRowId
					s tpeobj.TPHospitalDR=Ceobj.LinkHospId
					s TPSaveResult=##class(web.DHCBL.CT.DHCTarItemPrice).SaveEntity(tpeobj,"Y") 		
					s TPRowId=##class(web.BDPExt.FunLib).GetResultRowId(TPSaveResult)
					i (TPRowId'="")
					{
						///库存项与收费项关联 而不是医嘱项与收费项关联
						s INCTRQty=Ceobj.INCTRQty
						s:INCTRQty="" INCTRQty=1
						s INCTRStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Ceobj.INCTRStartDate)
						s:INCTRStartDate="" INCTRStartDate=+$h
						
						s inctarrelaobj=##class(User.DHCIncTarRela).%New()
						d inctarrelaobj.INCTRINCIDrSetObjectId(inciID)
						d inctarrelaobj.INCTRTariDrSetObjectId(TARIRowId)
						s inctarrelaobj.INCTRQty=INCTRQty
						s inctarrelaobj.INCTRStartDate=INCTRStartDate
						s inctarrelaobj.INCTREndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Ceobj.INCTREndDate)
						s sc=inctarrelaobj.%Save()
						if $$$ISOK(sc)
						{
						
						}
						else
						{
							s ImportResult= "库存项与收费项目关联:{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
						}
					
					}
					else
					{
						s ImportResult="收费项目价格:"_TPSaveResult				
					}
				}	
				else
				{
					s ImportResult="收费项目:"_TARISaveResult			
				}
			}
		}
		else
		{
			s ImportResult="医嘱项:"_ARCIMSaveResult	
		}
		
	}
	else
	{	
		s ImportResult= "药品保存失败："_ret_"！" 
	}
	
	
	if (ImportResult="")
	{
		Tc
		s ImportResult="{success:'true',id:'"_$p(ret,"^",1)_"'}"  ///返回药学项单位
	}
	else
	{
		Tro
		
	}
	q ImportResult
ERROR
	Q "导入报错"_$ZE
}

/// Creator:陈莹 
/// CreatDate:2018-11-18
/// Desc:校验库存分类是否关联了类型为药品的库存类组
/// Input: 库存分类ID
/// 返回0为校验通过
/// DEBUG:w ##class(web.BDPExt.CYBLL).IsDrugCat()
ClassMethod IsDrugCat(incsc)
{
	q:(+incsc = 0) "-1^库存分类为空"
	q:($p($g(^INC("SC", incsc)), "^", 3) '= "G") "-1^库存分类类型不为G"
	s scg = $o(^DHCSCG("STKCAT", incsc, 0))
	q:(+scg = 0) "-1^库存分类未关联类组"
	q:($p($g(^DHCSCG(scg)), "^", 3) '= "G") "-1^库存分类关联的类组类型不为G"
	q 0
}

}
