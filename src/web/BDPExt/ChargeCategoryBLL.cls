Class web.BDPExt.ChargeCategoryBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// chenying
ClassMethod SaveEntity(Ceobj As web.BDPExt.ChargeCategoryEntity) As %String
{
	new (Ceobj,%session)
	s ImportResult=""    
	//s Ceobj.ARCBGDesc=Ceobj.ARCBGCode
	//s Ceobj.ARCBGAbbrev=Ceobj.ARCBGCode
	//s Ceobj.ARCSGDesc=Ceobj.ARCSGCode   
	//s Ceobj.ARCSGAbbrev=Ceobj.ARCSGCode              
	s Ceobj.TARCDesc=Ceobj.TARCCode                 
	s Ceobj.TARSCDesc=Ceobj.TARSCCode                 
	s Ceobj.TARTICDesc=Ceobj.TARTICCode
	s Ceobj.TARICDesc=Ceobj.TARICCode
	s Ceobj.TARTOCDesc=Ceobj.TARTOCCode
	s Ceobj.TAROCDesc=Ceobj.TAROCCode
	s Ceobj.TARTECDesc=Ceobj.TARTECCode
	s Ceobj.TARECDesc=Ceobj.TARECCode 
	s Ceobj.TARTACDesc=Ceobj.TARTACCode
	s Ceobj.TARACDesc=Ceobj.TARACCode
	s Ceobj.TARTMCDesc=Ceobj.TARTMCCode
	s Ceobj.TARMCDesc=Ceobj.TARMCCode
	s Ceobj.NTARTMCDesc=Ceobj.NTARTMCCode
	s Ceobj.NTARMCDesc=Ceobj.NTARMCCode  

	; 帐单大类                                            
	//s ARCBillGrpobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.ARCBillGrp")
	; 帐单子类    
	//s ARCBillSubobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.ARCBillSub")
	; 收费项目大类
	s DHCTarCateobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarCate")
	; 收费项目子类
	s DHCTarSubCateobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarSubCate")
	;住院费用大类
	s DHCTarICobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarIC")
	;住院费用子类
	s DHCTarInpatCateobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarInpatCate")
	;门诊费用大类
	s DHCTarOCobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarOC")
	;门诊费用子类
	s DHCTarOutpatCateobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarOutpatCate")
	;核算费用大类
	s DHCTarECobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarEC")
	;核算费用子类
	s DHCTarEMCCateobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarEMCCate")
	; 会计费用大类
	s DHCTarACobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarAC") 
	;会计费用子类
	s DHCTarAcctCateobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarAcctCate")
	;病案首页大类
	s DHCTarMCobj= ##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarMC") 
	;病案首页子类
	s DHCTarMRCateobj= ##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarMRCate")   
	;新病案首页大类
	s DHCNewTarMCobj= ##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCNewTarMC")  
	;新病案首页子类
	s DHCNewTarMRCateobj= ##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCNewTarMRCate")

	; 1 账单大类 与账单子类
	/*s ARCBGRowId=""
	if (Ceobj.ARCBGCode'="")&(Ceobj.ARCSGCode'="")&(Ceobj.ARCBGDesc'="")&(Ceobj.ARCSGDesc'="")
	{
		Tstart
		s ARCBGRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_BillGrp",Ceobj.ARCBGCode,Ceobj.LinkHospId)  //$o(^ARCBG(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.ARCBGCode),0))    
		if (ARCBGRowId="")
		{
			s ARCBillGrpobj.ARCBGRowId=""
			s ARCBillGrpSaveResult=##class(web.DHCBL.CT.ARCBillGrp).SaveEntity(ARCBillGrpobj)
			s ARCBGRowId=##class(web.BDPExt.FunLib).GetResultRowId(ARCBillGrpSaveResult)
			if (ARCBGRowId="")
			{
				Tro
				s ImportResult="<账单大类>:"_ARCBillGrpSaveResult              
			}
		}
		if (ARCBGRowId'="")
		{
			; 账单子类
			s ARCSGSub=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_BillSub",Ceobj.ARCSGCode,Ceobj.LinkHospId)  //$o(^ARCBG("SG_Code",$$ALPHAUP^SSUTIL4(Ceobj.ARCSGCode),ARCBGRowId,0))
			if (ARCSGSub="")
			{
				s ARCBillSubobj.ParentRowId=ARCBGRowId
				s ARCBillSubSaveResult=##class(web.DHCBL.CT.ARCBillSub).SaveEntity(ARCBillSubobj)
				s ARCSGRowId=##class(web.BDPExt.FunLib).GetResultRowId(ARCBillSubSaveResult)     
				if (ARCSGRowId="")
				{
					Tro
					s ImportResult=ImportResult_"<账单子类>:"_ARCBillSubSaveResult              
				}
				else
				{
					TC
				}
			}
			else
			{
				Tro
				s ImportResult=ImportResult_"<账单子类>:"_Ceobj.ARCSGCode_"已存在。"
			}
		}
	}
	else
	{
		s ImportResult=ImportResult_"账单大类或账单子类有空值。"
	}
	*/
	; 2 收费项目大类与收费项目子类
	if (Ceobj.TARCCode'="")&(Ceobj.TARSCCode'="")&(Ceobj.TARCDesc'="")&(Ceobj.TARSCDesc'="")
	{
		Tstart
		s TARCRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarCate",Ceobj.TARCCode,Ceobj.LinkHospId)  //$o(^DHCTarC("CC",0,"Code",Ceobj.TARCCode,0))
		if (TARCRowId="")
		{
			s DHCTarCateobj.TARCRowId=""
			s DHCTarCateobj.LinkHospId=Ceobj.LinkHospId
			s DHCTarCateSaveResult=##class(web.DHCBL.CT.DHCTarCate).SaveEntity(DHCTarCateobj)
			s TARCRowId=##class(web.BDPExt.FunLib).GetResultRowId(DHCTarCateSaveResult)
			if (TARCRowId="")
			{
				Tro
				s ImportResult=ImportResult_"<收费项目大类>:"_DHCTarCateSaveResult              
			}
		}
		if (TARCRowId'="")
		{
			; 收费项目子类
			s TARSCRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarSubCate",Ceobj.TARSCCode,Ceobj.LinkHospId)  //$o(^DHCTarC("SC",0,"Code",Ceobj.TARSCCode,0))
			if (TARSCRowId="")
			{
				s DHCTarSubCateobj.TARSCTARCDR=TARCRowId
				s DHCTarSubCateobj.LinkHospId=Ceobj.LinkHospId
				s DHCTarSubCateSaveResult=##class(web.DHCBL.CT.DHCTarSubCate).SaveEntity(DHCTarSubCateobj)
				s TARSCRowId=##class(web.BDPExt.FunLib).GetResultRowId(DHCTarSubCateSaveResult)   
				if (TARSCRowId="")
				{
					Tro
					s ImportResult=ImportResult_"<收费项目子类>:"_DHCTarSubCateSaveResult              
				}
				else
				{
					TC
				}
			}
			else
			{
				Tro
				s ImportResult=ImportResult_"<收费项目子类>:"_Ceobj.TARSCCode_"已存在。"
			}
		}
	}
  	else
	{
		if ((Ceobj.TARCCode'="")||(Ceobj.TARSCCode'="")||(Ceobj.TARCDesc'="")||(Ceobj.TARSCDesc'="")) s ImportResult=ImportResult_"收费大类或收费子类有空值。"
	}
	/// 3 住院费用大类和住院费用子类
	if (Ceobj.TARTICCode'="")&(Ceobj.TARICCode'="")&(Ceobj.TARTICDesc'="")&(Ceobj.TARICDesc'="")
	{ 
		Tstart
		s TARTICRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarIC",Ceobj.TARTICCode,Ceobj.LinkHospId)  //$o(^DHCTarC("TIC",0,"Code",Ceobj.TARTICCode,0)) 
		if (TARTICRowId="")
		{
			s DHCTarICobj.TARTICRowId=""
			s DHCTarICobj.LinkHospId=Ceobj.LinkHospId
			s DHCTarICSaveResult=##class(web.DHCBL.CT.DHCTarIC).SaveEntity(DHCTarICobj) 
			s TARTICRowId=##class(web.BDPExt.FunLib).GetResultRowId(DHCTarICSaveResult)   
			if (TARTICRowId="")
			{
				Tro
				s ImportResult=ImportResult_"<住院费用大类>:"_DHCTarICSaveResult              
			}     
		}
		if (TARTICRowId'="")
		{
			; 住院费用子类
			s TARICRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarInpatCate",Ceobj.TARICCode,Ceobj.LinkHospId)  //$o(^DHCTarC("IC",0,"Code",Ceobj.TARICCode,0))
			if (TARICRowId="")
			{
				s DHCTarInpatCateobj.TARICTARTICDR=TARTICRowId
				s DHCTarInpatCateobj.LinkHospId=Ceobj.LinkHospId
				s DHCTarInpatCateSaveResult=##class(web.DHCBL.CT.DHCTarInpatCate).SaveEntity(DHCTarInpatCateobj)
				s TARICRowId=##class(web.BDPExt.FunLib).GetResultRowId(DHCTarInpatCateSaveResult)   
				if (TARICRowId="")
				{
					Tro
					s ImportResult=ImportResult_"<住院费用子类>:"_DHCTarInpatCateSaveResult              
				} 
				else
				{
					TC
				}
			}
			else
			{
				Tro
				s ImportResult=ImportResult_"<住院费用子类>:"_Ceobj.TARICCode_"已存在。"
			}
		}
	}
	else
	{
		if ((Ceobj.TARTICCode'="")||(Ceobj.TARICCode'="")||(Ceobj.TARTICDesc'="")||(Ceobj.TARICDesc'="")) s ImportResult=ImportResult_"住院费用大类或住院费用子类有空值。"
	}
	; 4 门诊费用大类 与 门诊费用子类
	if (Ceobj.TARTOCCode'="")&(Ceobj.TAROCCode'="")&(Ceobj.TARTOCDesc'="")&(Ceobj.TAROCDesc'="")
	{
		Tstart
		s TARTOCRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarOC",Ceobj.TARTOCCode,Ceobj.LinkHospId)  //$o(^DHCTarC("TOC",0,"Code",Ceobj.TARTOCCode,0))
		if (TARTOCRowId="")
		{
			s DHCTarOCobj.TARTOCRowId=""
			s DHCTarOCobj.LinkHospId=Ceobj.LinkHospId
			s DHCTarOCSaveResult=##class(web.DHCBL.CT.DHCTarOC).SaveEntity(DHCTarOCobj)
			s TARTOCRowId=##class(web.BDPExt.FunLib).GetResultRowId(DHCTarOCSaveResult)
			if (TARTOCRowId="")
			{
				Tro
				s ImportResult=ImportResult_"<门诊费用大类>:"_DHCTarOCSaveResult              
			} 
		}
		if (TARTOCRowId'="")
		{
			; 门诊费用子类
			s TAROCRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarOutpatCate",Ceobj.TAROCCode,Ceobj.LinkHospId)  //$o(^DHCTarC("OC",0,"Code",Ceobj.TAROCCode,0))
			if (TAROCRowId="")
			{
				s DHCTarOutpatCateobj.TAROCTARTOCDR=TARTOCRowId
				s DHCTarOutpatCateobj.LinkHospId=Ceobj.LinkHospId
				s DHCTarOutpatCateSaveResult=##class(web.DHCBL.CT.DHCTarOutpatCate).SaveEntity(DHCTarOutpatCateobj)
				s TAROCRowId=##class(web.BDPExt.FunLib).GetResultRowId(DHCTarOutpatCateSaveResult)  
				if (TAROCRowId="")
				{
					Tro
					s ImportResult=ImportResult_"<门诊费用子类>:"_DHCTarSubCateSaveResult              
				} 
				else
				{
					TC
				}
			}
			else
			{
				Tro
				s ImportResult=ImportResult_"<门诊费用子类>:"_Ceobj.TAROCCode_"已存在。"
			}
		}
	}
	else
	{
		if ((Ceobj.TARTOCCode'="")||(Ceobj.TAROCCode'="")||(Ceobj.TARTOCDesc'="")||(Ceobj.TAROCDesc'="")) s ImportResult=ImportResult_"门诊费用大类或门诊费用子类有空值。"
	}

	;5 核算费用大类 核算费用子类
	if (Ceobj.TARTECCode'="")&(Ceobj.TARECCode'="")&(Ceobj.TARTECDesc'="")&(Ceobj.TARECDesc'="")
	{
		Tstart
		s TARTECRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarEC",Ceobj.TARTECCode,Ceobj.LinkHospId)  //$o(^DHCTarC("TEC",0,"Code",Ceobj.TARTECCode,0))
		if (TARTECRowId="")
		{
			s DHCTarECobj.TARTECRowId=""
			s DHCTarECobj.LinkHospId=Ceobj.LinkHospId
			s DHCTarECSaveResult=##class(web.DHCBL.CT.DHCTarEC).SaveEntity(DHCTarECobj)
			s TARTECRowId=##class(web.BDPExt.FunLib).GetResultRowId(DHCTarECSaveResult)
			if (TARTECRowId="")
			{
				Tro
				s ImportResult=ImportResult_"<核算费用大类>:"_DHCTarECSaveResult              
			} 
		}
		if (TARTECRowId'="")
		{
			; 核算费用子类
			s TAROCRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarEMCCate",Ceobj.TARECCode,Ceobj.LinkHospId)  //$o(^DHCTarC("EC",0,"Code",Ceobj.TARECCode,0))
			if (TAROCRowId="")
			{
				s DHCTarEMCCateobj.TARECTARTECDR=TARTECRowId
				s DHCTarEMCCateobj.LinkHospId=Ceobj.LinkHospId
				s DHCTarEMCCateSaveResult=##class(web.DHCBL.CT.DHCTarEMCCate).SaveEntity(DHCTarEMCCateobj)
				s TAROCRowId=##class(web.BDPExt.FunLib).GetResultRowId(DHCTarEMCCateSaveResult)  
				if (TAROCRowId="")
				{
					Tro
					s ImportResult=ImportResult_"<核算费用子类>:"_DHCTarEMCCateSaveResult              
				}
				else
				{
					TC
				} 
			}
			else
			{
				Tro
				s ImportResult=ImportResult_"<核算费用子类>:"_Ceobj.TARECCode_"已存在。"
			}
		}
	}
	else
	{
		if ((Ceobj.TARTECCode'="")||(Ceobj.TARECCode'="")||(Ceobj.TARTECDesc'="")||(Ceobj.TARECDesc'="")) s ImportResult=ImportResult_"核算费用大类或核算费用子类有空值。"
	}
	; 6 会计费用大类 会计费用子类
	if (Ceobj.TARTACCode'="")&(Ceobj.TARACCode'="")&(Ceobj.TARTACDesc'="")&(Ceobj.TARACDesc'="")
	{
		Tstart
		s TARTACRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarAC",Ceobj.TARTACCode,Ceobj.LinkHospId)  //$o(^DHCTarC("TAC",0,"Code",Ceobj.TARTACCode,0))
		if (TARTACRowId="")
		{
			s DHCTarACobj.TARTACRowId=""
			s DHCTarACobj.LinkHospId=Ceobj.LinkHospId
			s DHCTarACSaveResult=##class(web.DHCBL.CT.DHCTarAC).SaveEntity(DHCTarACobj)
			s TARTACRowId=##class(web.BDPExt.FunLib).GetResultRowId(DHCTarACSaveResult)
			if (TARTACRowId="")
			{
				Tro
				s ImportResult=ImportResult_"<会计费用大类>:"_DHCTarACSaveResult              
			}
		}
		if (TARTACRowId'="")
		{
			; 会计费用子类
			s TARACRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarAcctCate",Ceobj.TARACCode,Ceobj.LinkHospId)  //$o(^DHCTarC("AC",0,"Code",Ceobj.TARACCode,0))
			if (TARACRowId="")
			{
				s DHCTarAcctCateobj.TARACTARTACDR=TARTACRowId
				s DHCTarAcctCateobj.LinkHospId=Ceobj.LinkHospId
				s DHCTarAcctCateSaveResult=##class(web.DHCBL.CT.DHCTarAcctCate).SaveEntity(DHCTarAcctCateobj)
				s TARACRowId=##class(web.BDPExt.FunLib).GetResultRowId(DHCTarAcctCateSaveResult)  
				if (TARACRowId="")
				{
					Tro
					s ImportResult=ImportResult_"<会计费用子类>:"_DHCTarAcctCateSaveResult              
				}
				else
				{
					TC
				}
			}
			else
			{
				Tro
				s ImportResult=ImportResult_"<会计费用子类>:"_Ceobj.TARACCode_"已存在。"
			}
		}
	}
	else
	{
		if ((Ceobj.TARTACCode'="")||(Ceobj.TARACCode'="")||(Ceobj.TARTACDesc'="")||(Ceobj.TARACDesc'="")) s ImportResult=ImportResult_"会计费用大类或会计费用子类有空值。"
	}
	; 7 病案首页大类 病案首页子类
	if (Ceobj.TARTMCCode'="")&(Ceobj.TARMCCode'="")&(Ceobj.TARTMCDesc'="")&(Ceobj.TARMCDesc'="")
	{
		Tstart
		s TARTMCRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarMC",Ceobj.TARTMCCode,Ceobj.LinkHospId)  //$o(^DHCTarC("TMC",0,"Code",Ceobj.TARTMCCode,0))
		if (TARTMCRowId="")
		{
			s DHCTarMCobj.TARTMCRowId=""
			s DHCTarMCobj.LinkHospId=Ceobj.LinkHospId
			s DHCTarMCSaveResult=##class(web.DHCBL.CT.DHCTarMC).SaveEntity(DHCTarMCobj)
			s TARTMCRowId=##class(web.BDPExt.FunLib).GetResultRowId(DHCTarMCSaveResult)
			if (TARTMCRowId="")
			{
				Tro
				s ImportResult=ImportResult_"<病案首页大类>:"_DHCTarMCSaveResult              
			} 
		}
		if (TARTMCRowId'="")
		{
			; 病案首页子类
			s TARACRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarMRCate",Ceobj.TARMCCode,Ceobj.LinkHospId)  //$o(^DHCTarC("MC",0,"Code",Ceobj.TARMCCode,0))
			if (TARACRowId="")
			{
				s DHCTarMRCateobj.TARMCTARTMCDR=TARTMCRowId
				s DHCTarMRCateobj.LinkHospId=Ceobj.LinkHospId
				s DHCTarMRCateSaveResult=##class(web.DHCBL.CT.DHCTarMRCate).SaveEntity(DHCTarMRCateobj)
				s TARACRowId=##class(web.BDPExt.FunLib).GetResultRowId(DHCTarMRCateSaveResult)  
				if (TARACRowId="")
				{
					Tro
					s ImportResult=ImportResult_"<病案首页子类>:"_DHCTarMRCateSaveResult              
				}
				else
				{
					TC
				}
			}
			else
			{
				Tro
				s ImportResult=ImportResult_"<病案首页子类>:"_Ceobj.TARMCCode_"已存在。"
			}
		}
	}
	else
	{
		if ((Ceobj.TARTMCCode'="")||(Ceobj.TARMCCode'="")||(Ceobj.TARTMCDesc'="")||(Ceobj.TARMCDesc'="")) s ImportResult=ImportResult_"病案首页大类或病案首页子类有空值。"
	}
	; 8 新病案首页大类 新病案首页子类
	if (Ceobj.NTARTMCCode'="")&(Ceobj.NTARMCCode'="")&(Ceobj.NTARTMCDesc'="")&(Ceobj.NTARMCDesc'="")
	{
		Tstart
		s NTARTMCRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarMCNew",Ceobj.NTARTMCCode,Ceobj.LinkHospId)  //$o(^DHCTARMCNEW(0,"Code",Ceobj.NTARTMCCode,0))
		if (NTARTMCRowId="")
		{
			s DHCNewTarMCobj.NTARTMCRowId=""
			s DHCNewTarMCobj.LinkHospId=Ceobj.LinkHospId
			s DHCNewTarMSaveResult=##class(web.DHCBL.CT.DHCNewTarMC).SaveEntity(DHCNewTarMCobj)
			s NTARTMCRowId=##class(web.BDPExt.FunLib).GetResultRowId(DHCNewTarMSaveResult)
			if (NTARTMCRowId="")
			{
				Tro
				s ImportResult=ImportResult_"<新病案首页大类>:"_DHCNewTarMSaveResult         
			}
		}
		if (NTARTMCRowId'="")
		{
			; 新病案首页子类
			s NTARMCRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarMCCateNew",Ceobj.NTARMCCode,Ceobj.LinkHospId)  //$o(^DHCTARMRCATENEW(0,"Code",Ceobj.NTARMCCode,0))
			if (NTARMCRowId="")
			{
				s DHCNewTarMRCateobj.NTARMCDR=NTARTMCRowId
				s DHCNewTarMRCateobj.LinkHospId=Ceobj.LinkHospId
				s DHCTarNewMRCateSaveResult=##class(web.DHCBL.CT.DHCNewTarMRCate).SaveEntity(DHCNewTarMRCateobj)
				s NTARMCRowId=##class(web.BDPExt.FunLib).GetResultRowId(DHCTarNewMRCateSaveResult)  
				if (NTARMCRowId="")
				{
					Tro
					s ImportResult=ImportResult_"<新病案首页子类>:"_DHCTarMRCateSaveResult              
				}
				else
				{
					TC
				} 
			}
			else
			{
				Tro
				s ImportResult=ImportResult_"<新病案首页子类>:"_Ceobj.NTARMCCode_"已存在。"
			}
		}
	}
	else
	{
		if ((Ceobj.NTARTMCCode'="")||(Ceobj.NTARMCCode'="")||(Ceobj.NTARTMCDesc'="")||(Ceobj.NTARMCDesc'="")) s ImportResult=ImportResult_"新病案首页大类或新病案首页子类有空值。"
	}
	
	if (ImportResult="")
	{
		s ImportResult="{success:'true',id:'"_$g(TAROCRowId)_"'}" 
	}
	
	q ImportResult
}

}
