Class web.DHCENS.STBLL.DICT.METHOD.CTMedicineMaterial Extends (%RegisteredObject, %XML.Adaptor)
{

/// Others：w ##class(web.DHCENS.STBLL.DICT.METHOD.CTMedicineMaterial).SendDrugInfo("")
ClassMethod SendDrugInfo(input As %String) As %String
{
	Set $zt="Exception"
	
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set SuccessFlag="0"
	//调用药房组方法取出药品信息（存储在临时global中），返回值：药品总数^进程号
	set DrugStr=##class(web.DHCSTInterfacePH).GetDrugBaseInfo("G")
	set AllStr="",EndStr=""
	if (DrugStr'="") {
		//药品总数
		set FirstStr=$P(DrugStr,"^",1)
		//进程号
		set EndStr=$P(DrugStr,"^",2)
		set Id="",i=0,Flag=1
		//循环取出Global中的全部药品信息
		f  set Id=$o(^TMP(EndStr,"PHBAINFO",Id)) q:Id=""  d
		.//药品信息
		.set DrugModel=##class(web.DHCENS.STBLL.DICT.MODEL.CTMedicineMaterial).%New()
		.set TmpStr=^TMP(EndStr,"PHBAINFO",Id)
		.set DrugCode=$P(TmpStr,"^",1)
		.set DrugModel.CTMMCode=$P(TmpStr,"^",1)
		.s MedInfo=..DrugItmByCode(DrugCode)
		.i MedInfo'="" d
		..s MedId=""
		..s pid=$p(MedInfo,"^",1)   //add by lipan
		..f  s MedId=$o(^TMP("DHCST","dhcpha","DrugItmByCode",pid,"ITM",MedId)) q:MedId=""  d
		...s MedStr=^TMP("DHCST","dhcpha","DrugItmByCode",pid,"ITM",MedId)
		...;药品编码^药品效期^药品批号^药房编码^药品价格^药品货柜码^转换系数 
		.set DrugModel.CTMMDesc=$P(TmpStr,"^",2)
		.set DrugModel.CTMMSpecification=$P(TmpStr,"^",18)
		.;b:DrugModel.CTMMSpecification'="" ;spcification
		.set DrugModel.CTMMGenericName=$P(TmpStr,"^",4)
		.set DrugModel.CTMMDosageFormDesc=$P(TmpStr,"^",5)
		.set DrugModel.CTMMManufacturerName=$P(TmpStr,"^",6)
		.set DrugModel.CTMMValuationUnit=$P(TmpStr,"^",7)
		.;set DrugModel.MiniUnit=$P(TmpStr,"^",7)
		.;set DrugModel.WeightUnit=$P(TmpStr,"^",8)
		.;set DrugModel.Weight=$P(TmpStr,"^",9)
		.set DrugModel.CTMMPackingUnit=$P($P(TmpStr,"^",10),"(",1)
		.set DrugModel.CTMMPackingCoefficient=$P($P($P(TmpStr,"^",10),"(",2),")",1)
		.set DrugModel.CTMMDosUom=$P(TmpStr,"^",12)
		.set DrugModel.CTMMDosage=$P(TmpStr,"^",13)
		.set DrugModel.CTMMMinPkgNum=$P(TmpStr,"^",17)
		.set DrugModel.CTMMPYCode=$P(TmpStr,"^",22)
		.set Subscript="" f  set Subscript=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(DrugCode),Subscript)) q:Subscript=""  d
		..set Version="" f  set Version=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(DrugCode),Subscript,Version)) q:Version=""  d
		...set ARCIMRowId=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(DrugCode),Subscript,Version))
		...set ItemCatDR=$p($g(^ARCIM(Subscript,Version,1)),"^",10)
	    ...set DrugModel.CTMMOrderChildCategory=$P($g(^ARC("IC",ItemCatDR)),"^",1)
		...set OrdCatDR=$P($g(^ARC("IC",ItemCatDR)),"^",8)
		...set DrugModel.CTMMOrderCategory=$p($g(^OEC("ORCAT",OrdCatDR)),"^",1)
		.set DrugModel.CTMMCodesystemCode="CT_MedicineMaterial"
		.d body.medicineMaterials.Insert(DrugModel)
		.set Count=body.medicineMaterials.Count()
		.if Count>200 d
		..set request.body=body
		..d request.XMLExportToStream(.stream)
		..set soapObj.Timeout="60"
		..set tSC=soapObj.SaveManagerDataInfo("CT_MedicineMaterial",stream)
		..d body.medicineMaterials.Clear()
		..set result=$p(tSC.Read(),"^",1)
		..if result'["<ResultCode>0</ResultCode>" d
		...set SuccessFlag=-1
	
		set Count=body.medicineMaterials.Count()
		if (Count>0){	
			set request.body=body
			d request.XMLExportToStream(.stream)
			set soapObj.Timeout="60"
			set tSC=soapObj.SaveManagerDataInfo("CT_MedicineMaterial",stream)
			d body.medicineMaterials.Clear()
			set result=$p(tSC.Read(),"^",1)
			if result'["<ResultCode>0</ResultCode>" d
			.set SuccessFlag=-1
		}
		if SuccessFlag'=0 {
			s RetStr="-1^失败"
		}
		else{
			s RetStr="0^成功"
		}
		}
		k ^TMP(EndStr,"PHBAINFO")	
		Quit RetStr
Exception
	Quit "-1^"_$ze
}

ClassMethod DrugItmByCode(InciCode As %String) As %String
{
	
	s Inci=""
	s Inci=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(InciCode),Inci))
	s pid=$I(^TMP("DHCST","dhcpha","DrugItmByCode"))
    s num=0
	K ^TMP("DHCST","dhcpha","DrugItmByCode",pid,"ITM")
	s PhaLoc=""
	f  s PhaLoc=$o(^INCI("IL_LOC",PhaLoc)) q:PhaLoc=""  d
	.s PhaLocCode=$P(^CTLOC(PhaLoc),"^",1)                                     //药房编码
	.s PhaLocDesc=$P(^CTLOC(PhaLoc),"^",2)                                     //药房名称
	.s PhaLocType=$P(^CTLOC(PhaLoc),"^",13)
	.q:PhaLocType'="D"
	.s HospId=$p(^CTLOC(PhaLoc),"^",22)
	.s IL=""
	.f  s IL=$o(^INCI("IL_LOC",PhaLoc,Inci,IL))  q:IL=""  d 
	..s InciCode=$p(^INCI(Inci,1),"^",1)                                       //药品编码
    ..s LB=0
	..f  s LB=$o(^INCI(Inci,"IL",IL,"LB",LB))  q:LB=""  d
	...s num=num+1
	...s Inclb=Inci_"||"_IL_"||"_LB
    ...s Incib=""
    ...s Incib=$P(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
    ...s Chl=$p(Incib,"||",2)
	...s BatNo=$p(^INCI(Inci,"IB",Chl),"^",1)                                   //药品批号
 	...s ExpDate=+$p(^INCI(Inci,"IB",Chl),"^",2)                                //药品效期
 	...s:+ExpDate'=0 ExpDate=$zd(ExpDate,3)
 	...s StkBin=""
 	...s Incsbdr=$p($g(^INCI(Inci,"IL",IL)),"^",2)
 	...s:Incsbdr'="" StkBin=$p(^INC("SB",Incsbdr),"^",2)                        //药品货柜码
 	...s SalePrice=##class(web.DHCSTCOMMONSRV).GetPriceElse(Inci,+$h,"",HospId) //药品价格
 	...s:SalePrice<1 SalePrice=0_SalePrice
 	...s ctuom=$p(^INCI(Inci,1),"^",10)                                        //基本单位  	
    ...s puom=$p(^INCI(Inci,3),"^",6)                                           //入库单位
    ...s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,ctuom)            //转换系数 
    ...s Data=InciCode_"^"_BatNo_"^"_ExpDate_"^"_PhaLocCode_"^"_StkBin_"^"_SalePrice_"^"_fac
    ...s ^TMP("DHCST","dhcpha","DrugItmByCode",pid,"ITM",num)=Data
    q pid_"^"_num
}

}
