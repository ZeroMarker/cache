Class web.BDPExt.WZBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// update2020-02-11
/// 库存类组与分类关联表 User.DHCStkCatGrpRelations
/// User.DHCItmAddionInfo
ClassMethod SaveEntity(Ceobj As web.BDPExt.WZEntity) As %String
{
	n (Ceobj,%session)
	s $zt="ERROR"
	s ImportResult=""
	s:Ceobj.TARIInsuCode'="" Ceobj.InsuCode=Ceobj.TARIInsuCode
	//SP售价  Rp进价
	//PUom入库单位  BUom基本单位
	s liststr="Code^"_Ceobj.Code_"|Desc^"_Ceobj.Desc_"|Charge^"_Ceobj.Charge_"|CatGrp^"_Ceobj.CatGrp_"|StkCat^"_Ceobj.StkCat_"|Spec^"_Ceobj.Spec_"|Model^"_Ceobj.Model_"|Origin^"_Ceobj.Origin_"|Brand^"_Ceobj.Brand_"|Abbr^"_Ceobj.Abbr    //1-10
	s liststr=liststr_"|Alias^"_Ceobj.Alias_"|BUom^"_Ceobj.BUom_"|PUom^"_Ceobj.PUom_"|Factor^"_Ceobj.Factor_"|FeeUom^"_Ceobj.FeeUom_"|RP^"_Ceobj.RP_"|SP^"_Ceobj.SP_"|PriceInformation^"_Ceobj.PriceInformation  //11-18
	//s liststr=liststr_"|OrdCat^"_Ceobj.OrdCat_"|OrdSubCat^"_Ceobj.OrdSubCat_"|BillCat^"_Ceobj.BillCat_"|BillSubCat^"_Ceobj.BillSubCat_"|TarCat^"_Ceobj.TarCat_"|TarSubCat^"_Ceobj.TarSubCat_"|InpaCat^"_Ceobj.InpaCat_"|InpaSubCat^"_Ceobj.InpaSubCat_"|OutpaCat^"_Ceobj.OutpaCat_"|OutpaSubCat^"_Ceobj.OutpaSubCat_"|EmCat^"_Ceobj.EmCat_"|EmSubCat^"_Ceobj.EmSubCat_"|AcctCat^"_Ceobj.AcctCat_"|AcctSubCat^"_Ceobj.AcctSubCat_"|MrCat^"_Ceobj.MrCat_"|MrSubCat^"_Ceobj.MrSubCat_"|MrSubCatNew^"_Ceobj.MrSubCatNew
	s liststr=liststr_"|InsuCode^"_Ceobj.InsuCode_"|InsuDesc^"_Ceobj.InsuDesc
	//s liststr=liststr_"|Priority^"_Ceobj.Priority_"|Onitsown^"_Ceobj.Onitsown_"|Wostock^"_Ceobj.Wostock  ///22个。19--40
	s liststr=liststr_"|HighValue^"_Ceobj.HighValue_"|BatRequired^"_Ceobj.BatRequired_"|ExpdateRequired^"_Ceobj.ExpdateRequired_"|Supervision^"_Ceobj.Supervision_"|Barcode^"_Ceobj.Barcode_"|PbFlag^"_Ceobj.PbFlag_"|PbRP^"_Ceobj.PbRP_"|Vendor^"_Ceobj.Vendor_"|Manf^"_Ceobj.Manf_"|Carrier^"_Ceobj.Carrier
	s liststr=liststr_"|RegisterNo^"_Ceobj.RegisterNo_"|RegisterExpdate^"_Ceobj.RegisterExpdate
	//s liststr=liststr__"|ProductionLicense^"_Ceobj.ProductionLicense_"|ProductionLicenseExpdate^"_Ceobj.ProductionLicenseExpdate_"|BusinessLicense^"_Ceobj.BusinessLicense_"|BusinessLicenseDate^"_Ceobj.BusinessLicenseDate_"|RevReg^"_Ceobj.RevReg_"|OrgCode^"_Ceobj.OrgCode_"|OrgCodeDate^"_Ceobj.OrgCodeDate_"|BusinessCertificate^"_Ceobj.BusinessCertificate
	//s liststr=liststr_"|BusinessCertificateExpdate^"_Ceobj.BusinessCertificateExpdate_"|AuthorizationDate^"_Ceobj.AuthorizationDate
	s liststr=liststr_"|ContactPerson^"_Ceobj.ContactPerson_"|ContactTel^"_Ceobj.ContactTel_"|Remarks^"_Ceobj.Remarks_"|PackUomMax^"_Ceobj.PackUomMax_"|PackUomFacMax^"_Ceobj.PackUomFacMax  
	//2021-12-22 补充7个字段
	s liststr=liststr_"|ImportFlag^"_Ceobj.ImportFlag_"|MatQuality^"_Ceobj.MatQuality_"|ImplantFlag^"_Ceobj.ImplantFlag_"|CentralPurFlag^"_Ceobj.CentralPurFlag_"|TemPurchase^"_Ceobj.TemPurchase  
	s liststr=liststr_"|InHosFlag^"_Ceobj.InHosFlag_"|BookCat^"_Ceobj.BookCat
	
	s:Ceobj.OLTQty="" Ceobj.OLTQty="1" 
	s:Ceobj.TARIActiveFlag="" Ceobj.TARIActiveFlag="Y"
	s ^tmpcy("web.BDPExt.WZBLL")=liststr
	Ts
	//库存项
	///2020-04-16调用物资组李慧新接口web.DHCSTMHUI.Tools.CodeInputX
	//s importret=##class(web.DHCSTM.Tools.CodeInputX).SaveInci(liststr)  //>0 - 成功,<0 - 失败
	///调试：w ##class(web.DHCSTMHUI.Tools.CodeInputX).SaveInci(^tmpcy("web.BDPExt.WZBLL"),2)
	try
	{
		s importret=##class(web.DHCSTMHUI.Tools.CodeInputX).SaveInci(liststr,Ceobj.LinkHospId)
	}
	catch myvar
	{
		//s importret="-1^"_$ze
		s importret="{""rowid"":"""",""msg"":"""_$tr($ze,"""","")_""",""success"":""-1"",""keyValue"":{}}"
		
	}
	//if (importret>0)    //>0 - 成功,<0 - 失败
	///2021-02-27 解析新的返回值 JSON串
	if importret["rowid"
	{
	set messageJsonObj=##class(%DynamicAbstractObject).%FromJSON(importret)  //将返回值json处理成对象
	if (messageJsonObj.success=0)  //为负数时为保存失败,0为保存成功
	{
		//s InciID=importret
		s InciID=messageJsonObj.rowid
		if (InciID>0)
		{
			S INCIIsTrfFlag=$P($G(^INCI(InciID,2)),"^",6)
			i INCIIsTrfFlag["Both" s $P(^INCI(InciID,2),"^",6)="B"   ///Both Iss & Trf  表结构有问题
			
			i (Ceobj.Code="") 
			{
				s Ceobj.Code=$p($g(^INCI(InciID,1)),"^",1)  //医嘱项代码=收费项代码	
			}
			///后勤类材料不需要导医嘱项
		    ///医用卫生材料中（收费）的有医嘱项,医用卫生材料中（非收费类）一般也不用医嘱项
			if ($ZCVT(Ceobj.Charge,"U")="Y")
			{
				
				///医嘱项
				s myARCIMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Ceobj.ARCIMCode,Ceobj.LinkHospId)  //$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.ARCIMCode),0))    ///已存在的医嘱项跳过
				if (myARCIMRowId="")
				{
					//医嘱项
					s arcimeobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.ARCItmMast")
					s arcimeobj.LinkHospId=Ceobj.LinkHospId
					s arcimeobj.ARCIMRowId=""
					s arcimeobj.ARCIMCode=Ceobj.ARCIMCode  //医嘱项代码
					s arcimeobj.ARCIMDesc=Ceobj.ARCIMDesc  //医嘱项名称
					s arcimeobj.ARCIMAbbrev=Ceobj.ArcAbbrev  //医嘱项缩写
					s arcimeobj.ARCIMOEMessage=Ceobj.ArcOEMessage   ///2017-3-6
					s arcimeobj.ARCIMItemCatDR=Ceobj.OrdSubCat
					s arcimeobj.ARCIMBillSubDR=Ceobj.BillSubCat
					s arcimeobj.ARCIMBillingUOMDR=Ceobj.FeeUom     //医嘱项走计价单位
					s arcimeobj.ARCIMDefPriorityDR=Ceobj.Priority
					s arcimeobj.ARCIMOrderOnItsOwn=Ceobj.Onitsown
					i (arcimeobj.ARCIMOrderOnItsOwn="") s arcimeobj.ARCIMOrderOnItsOwn="Y"  //默认为独立医嘱
					s arcimeobj.ARCIMAllowOrderWOStockCheck=Ceobj.Wostock
					i (arcimeobj.ARCIMAllowOrderWOStockCheck="") s arcimeobj.ARCIMAllowOrderWOStockCheck="N"   //默认为有库存
					s ARCIMSaveResult=##class(web.DHCBL.CT.ARCItmMast).SaveEntity(arcimeobj)	
					s myARCIMRowId=##class(web.BDPExt.FunLib).GetResultRowId(ARCIMSaveResult)
				}
				if (myARCIMRowId'="")&&(InciID>0)
				{
					//保存完医嘱项后要修改库存项里的医嘱项dr，指向这条医嘱项
					IF myARCIMRowId["||"
					{
						s inciobj=##class(User.INCItm).%OpenId(InciID,0)
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
							s ImportResult="{success:'false',errorinfo:'获取库存项对象失败！'}" 
							
						}
					
					}
					else
					{
						s ImportResult="{success:'false',errorinfo:'医嘱项id/库存项id错误!'}" 
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
						//收费项
						
						s tarieobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarItem")
						s tarieobj.LinkHospId=Ceobj.LinkHospId
						s tarieobj.TARIRowId=""		
						
						s tarieobj.TARICode=Ceobj.TARICode   //收费项代码
						s tarieobj.TARIDesc=Ceobj.TARIDesc   //收费项名称
						s tarieobj.TARIUOM=Ceobj.BUom      //收费项走基本单位
						s tarieobj.TARISubCate=Ceobj.TarSubCat
						s tarieobj.TARIInpatCate=Ceobj.InpaSubCat
						s tarieobj.TARIOutpatCate=Ceobj.OutpaSubCat
						s tarieobj.TARIEMCCate=Ceobj.EmSubCat
						s tarieobj.TARIAcctCate=Ceobj.AcctSubCat
						s tarieobj.TARIMRCate=Ceobj.MrSubCat
						s tarieobj.TARIMCNew=Ceobj.MrSubCatNew   
						s tarieobj.TARIInsuName=Ceobj.InsuDesc    //医保名称
						s tarieobj.TARIActiveFlag=Ceobj.TARIActiveFlag
						s:tarieobj.TARIActiveFlag="" tarieobj.TARIActiveFlag="Y"  
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
							
							//计算基本单位对应的价格   2017-03-21 入库单位和基本单位的转换系数
							s CTCFRowId=$o(^CT("CTCF",0,"UOM",Ceobj.PUom,Ceobj.BUom,0))	
							s CTCFFactor=$p($g(^CT("CTCF",CTCFRowId)),"^",3)
							s tpeobj.TPPrice=Ceobj.SP/CTCFFactor
							s tpeobj.TPTARIParRef=TARIRowId
							s tpeobj.TPHospitalDR=Ceobj.LinkHospId
							s TPSaveResult=##class(web.DHCBL.CT.DHCTarItemPrice).SaveEntity(tpeobj,"Y") 		
							s TPRowId=##class(web.BDPExt.FunLib).GetResultRowId(TPSaveResult)
							i (TPRowId'="")
							{
								///医嘱项与收费项关联
								s olteobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCOrderLinkTar")
								///医嘱项与收费项目关联
								s olteobj.OLTARCIMDR=myARCIMRowId
								s olteobj.OLTTariffDR=TARIRowId
								
								s OLTSaveResult=##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(olteobj,"Y")
								s OLTRowId=##class(web.BDPExt.FunLib).GetResultRowId(OLTSaveResult)
								i (OLTRowId="")
								{
									s ImportResult="医嘱项与收费项目关联:"_OLTSaveResult
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
			
		}
		else
		{
			s ImportResult="{success:'false',errorinfo:'获取库存项RowId失败！'}" 
		}
		
			
	}
	else
	{
		s ImportResult= "物资接口保存失败："_messageJsonObj.msg
		/*s msg=importret
		if importret=-13 s msg="代码重复"
		if importret=-20 s msg="基本单位"_"为空"
		if importret=-21 s msg="基本单位"_"为空"
		if importret=-22 s msg="整包装单位"_"为空"
		if importret=-23  s msg="整包装单位"_"为空"
		if importret=-24 s msg="入库单位和基本单位无对应换算"
		if importret=-241 s msg="大包装单位和入库单位无对应换算"
		if importret=-25  s msg="类组(大类)"_"为空"
		if importret=-26  s msg="无法取得类组(大类)"
		if importret=-27  s msg="库存分类(子类)"_"为空"
		if importret=-28  s msg="无法取得库存分类(子类"
		if importret=-29  s msg="类组和分类无法建立关联"
		if importret=-300  s msg= "营业执照(工商执照)更新错误"
		if importret=-301  s msg="经营许可证更新错误"
		if importret=-3011  s msg="经营许可证效期更新错误"
		if importret=-302  s msg="业务联系人更新错误"
		if importret=-303  s msg="业务授权截止期更新错误"
		if importret=-304  s msg="业务联系人电话更新错误"
		if importret=-305  s msg="营业执照(工商执照)有效期更新错误"
		if importret=-306  s msg="供应商税务登记号更新错误"
		if importret=-307  s msg="供应商组织机构代码更新错误"
		if importret=-308  s msg="供应商组织机构代码有效期更新错误"
		if importret=400   s msg="生产厂商插入错误" 
		if importret=-401  s msg="生产许可证更新错误"
		if importret=-4011  s msg="生产许可证效期更新错误"
		if importret=-5   s msg="自动生成代码错误"
		if importret=-1  s msg="插入主表错误"
		if importret=-2  s msg="插入附加表错误"
		if importret=-10  s msg="插入别名错误"
		if importret=-11  s msg="生成价格数据错误"
		if importret=-12  s msg="插入dhc_itmremark错误"
		if importret=-110  s msg="更新器械注册证号错误"
		if importret=-111  s msg="更新器械注册证效期错误"
		if importret=-131  s msg="插入dhc_itmven错误"
		if importret=-132 s msg="更新dhc_itmremark错误"
		s ImportResult= "库存项保存失败:"_msg_"！" 
		*/
	}
	}
	else
	{
		s ImportResult= "保存失败："_importret
		if $tl>0 Tro
	}
	if (ImportResult="")
	{
		Tc
		s ImportResult="{success:'true',id:'"_$g(InciID)_"'}"   ///返回库存项单位
	}
	else
	{
		if $tl>0 Tro
	}

	q ImportResult
ERROR
	if $tl>0 Tro
	Q "导入报错"_$ZE
}

/// Creator:陈莹
/// CreatDate:2017-3-22
/// Description:数据重复验证方法,导入药品数据时调用
/// Table:User.INCItm
/// Input: code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.BDPExt.WZBLL).FormValidate("ZZZ00035","齿轮","2")
/// Other:w ##class(web.BDPExt.WZBLL).FormValidate("A00N001","药箅子[1个]",2)
ClassMethod FormValidate(code As %String, desc As %String, hospid As %String) As %String
{
	new (code,desc,hospid)
	s flag=""
	if ($$ALPHAUP^SSUTIL4(code)'="")
	{
		s idc=0
		for
		{
			s idc=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
			s Value=$p($g(^INCI(idc,1)),"^",1)
			if (Value=code)
			{
				
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("INC_Itm",idc,hospid)
				continue:showflag="N"
				s flag=1
			}			
		}		
	}
	if ($$ALPHAUP^SSUTIL4(desc)'="")
	{
		s idc=0
		for
		{
			s idc=$o(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(desc),idc)) q:idc=""
			s Value=$p($g(^INCI(idc,1)),"^",2)
			if (Value=desc)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("INC_Itm",idc,hospid)
				continue:showflag="N"
				s flag=1
			}
			
		}
		
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2017-10-10
/// Description:通过库存项是否收费标志（有没有关联医嘱项）
/// w ##class(web.BDPExt.WZBLL).GetChargeFlag(INCIRowId)
ClassMethod GetChargeFlag(INCIRowId) As %String
{
	n (INCIRowId)
	q:INCIRowId="" ""
	s INCIOriginalARCIMDR=$P($G(^INCI(INCIRowId,1)),"^",3)
	if (INCIOriginalARCIMDR'="")
	{
		s Flag="Y"
	}
	else
	{
		s Flag="N"
	}
	q Flag
}

/// Creator:陈莹
/// CreatDate:2017-10-10
/// Description:通过库存项获取库存类组描述
/// 库存类组与分类关联表 User.DHCStkCatGrpRelations
/// w ##class(web.BDPExt.WZBLL).GetCatGrpByRowId(INCIRowId)
ClassMethod GetCatGrpByRowId(INCIRowId) As %String
{
	n (INCIRowId)
	q:INCIRowId="" ""
	s Desc=""
	s StkCat=$p($g(^INCI(INCIRowId,2)),"^",2)
	if StkCat'=""
	{
		s SCGRowid=$o(^DHCSCG("STKCAT",StkCat,0))
		s:SCGRowid'="" Desc=$p($g(^DHCSCG(SCGRowid)),"^",2)	
	}
	q Desc
}

/*
	///字段名和值之间用上箭头"^" 拼接，然后它们之间再用"|"拼接。
	s yzxobj.TARIExternalCode=Ceobj.TARIExternalCode
			s yzxobj.TARIEngName=Ceobj.TARIEngName
			s yzxobj.TARIChargeBasis=Ceobj.TARIChargeBasis
			s yzxobj.TARIConnote=Ceobj.TARIConnote
			s yzxobj.TARIRemark=Ceobj.TARIRemark
			s yzxobj.TARIExclude=Ceobj.TARIExclude
			
			*/
}
