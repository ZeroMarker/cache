Class web.DHCENS.STBLL.DICTNew.METHOD.CTMedicineMaterial Extends (%RegisteredObject, %XML.Adaptor)
{

/// 药品材料信息
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMedicineMaterial).CTMedicineMaterial("")
ClassMethod CTMedicineMaterial(Input As %String) As %String
{
	set $zt="MsgErr"
	SET request=##class(web.DHCENS.STBLL.DICTNew.MODEL.MedicalMaterialRequest).%New()
	set header=##class(web.DHCENS.STBLL.DICTNew.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set request.header=header
	;set body=##class(web.DHCENS.STBLL.DICTNew.MODEL.MedicalMaterialBody).%New()
	
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.MedicalMaterialBody).%New()
		//调用药房组方法取出药品信息（存储在临时global中），返回值：药品总数^进程号
	set success="-1"
	set DrugStr=##class(web.DHCSTInterfacePH).GetDrugBaseInfo("G",Input)
	set Soap=##class(web.DHCENS.STBLL.SOAP.PUB0003Soap).%New()
	;set Soap.Timeout="3"
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
		.set DrugModel=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTMedicineMaterial).%New()
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
		.SET DrugModel.CTPHDMIBussnessCode=""
		.;set DrugModel.MiniUnit=$P(TmpStr,"^",7)
		.;set DrugModel.WeightUnit=$P(TmpStr,"^",8)
		.;set DrugModel.Weight=$P(TmpStr,"^",9)
		.set DrugModel.CTMMUnitPrice=$P(TmpStr,"^",16)
		.;b ;01
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
		.d ListInfo.MedicineMaterialList.Insert(DrugModel)
		.set count=ListInfo.MedicineMaterialList.Count()
		.if count>100 d 
		..set request.body=ListInfo
		..d request.XMLExportToStream(.Stream)
		..b ;02
		..set tSC=Soap.SendDataFromHis("BOE0176",Stream)
		..;b ;0
		..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		..if resultCode=0 d
		...set success=0
		..else  d
		...set success=-1
		
		/*
		..set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTMedicineMaterial",.Jsonobj)
		..set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
		..set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_MedicineMaterial",JsonString)
		..;b ;00
		..d ListInfo.CTMedicineMaterial.Clear()
		..set count=0
		..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		..if resultCode=0 d
		...set success=0
		..else  d
		...set success=-1
		*/
		if count>0 
		{
			set request.body=ListInfo
			d request.XMLExportToStream(.Stream)
			set tSC=Soap.SendDataFromHis("BOE0176",Stream)
			set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
			if resultCode=0 d
			.set success=0
			else  d
			.set success=-1
			/*
			set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTOrderStatus",.Jsonobj)
			set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
			set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_OrderStatus",JsonString)
			set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
			if resultCode=0 d
			.set success=0
			else  d
			.set success=-1	
			*/
		}
	}
	k ^TMP(EndStr,"PHBAINFO")	
	quit success
MsgErr
    b ;33
	quit "-1"_$ze
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
