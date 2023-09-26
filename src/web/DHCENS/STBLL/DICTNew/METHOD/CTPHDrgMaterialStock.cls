Class web.DHCENS.STBLL.DICTNew.METHOD.CTPHDrgMaterialStock Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：haochenguang
/// CreatDate：2018-09-15
/// Description：
/// Table：INC_Item
/// Input： 
/// Return：库存项字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHDrgMaterialStock).GetCTPHDrgMaterialStock("1").Read()
ClassMethod GetCTPHDrgMaterialStock(Input As %String = "") As %GlobalCharacterStream
{
	set $zt="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
		}
	if pList.Count()>0{
		set OutputStream=..GetCTPHDrgMaterialStockByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：查询HIS中库存项字典信息
/// Table：Inc_Itm
/// Input： 库存项字典
/// Return：库存项字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHDrgMaterialStock).SendCTPHDrgMaterialStock("")
ClassMethod SendCTPHDrgMaterialStock(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1,sc=""
	s rowid="0" for  s rowid=$o(^INCI(rowid)) q:(+rowid=0)||(rowid="")  d
	.s catstr=..CatGrpType(rowid)
	.s catCode=$p(catstr,"^",1)
	.q:catCode'="M"
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>20 d
	..set Instream=..GetCTPHDrgMaterialStockByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PHDrgMaterialStock",tSC)
	..d tSC.OutputToDevice()
	..;b ;00
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTPHDrgMaterialStockByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PHDrgMaterialStock",tSC)
	q sc
Err
	q "-1^"_$ze
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回库存项字典密文流
/// Table：Inc_Itm
/// Input： Array集合
/// Return：库存项字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHDrgMaterialStock).GetCTPHDrgMaterialStockByID()
ClassMethod GetCTPHDrgMaterialStockByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPHDrgMaterialStock).%New()
		set Str=$g(^INCI(rowid,1))
		set Str1=$g(^INCI(rowid,3))
		set Obj.businessrowid=rowid
		set Obj.CTPHDMSCode=$p(Str,"^",1)
		set Obj.CTPHDMSDesc=$p(Str,"^",2)
		set Obj.CTPHDMSCodesystemCode="CT_PHDrgMaterialStock"
		
		set Obj.CTPHDMSUpdateUserCode=$p(Str1,"^",3)
		set:Obj.CTPHDMSUpdateUserCode="" Obj.CTPHDMSUpdateUserCode="admin"
		s hospId=$o(^CT("HOSP","0"))
		s hospCode=$p(^CT("HOSP",hospId),"^",1)	
		s Obj.CTPHDMSHosCode=hospId //hospCode
		set Obj.CTPHDMSDesc=$p(Str,"^",2)
		set Obj.CTPHDMSDrgRowId="" ;$p(Str,"^",1)
		set Obj.CTPHDMSRowId=$p(Str,"^",1)
		set catGrp=..CatGrpType(rowid)
		set Obj.CTPHDMSStkCatGrpCode=$p(catGrp,"^",1) //库存类组代码
		set ctscInfo=..GetCTSCByInci(rowid)
		set Obj.CTPHDMSStkCatCode=$p(ctscInfo,"^",4)
		//set Obj.CTPHDMSStkCatDesc=$p(ctscInfo,"^",2)
		set Obj.CTPHDMSDrugMaterielCatCode=$case($p(catGrp,"^",2),"YL":"2","ZW":"3",:"2") //物料类别 1.药品 2.医用耗材（医疗） 3.后勤物资（总务）
		set Obj.CTPHDMSManagementLevelCode="" //管理级别 1.低值耗材  2.高值耗材 3.诊断试剂
		set Obj.CTPHDMSConsumableCatCode="" //耗材大类代码 01.放射材料 02.检验材料 03.特殊材料
		set Obj.CTPHDMSConsumableChildCatCode="" //耗材子类代码 001.常用耗材类 002.导管类 003.缝线及刀类
		set ManfInfo=..GetManfByInci(rowid)
		set Obj.CTPHDMSManufacturerCode=$p(ManfInfo,"^",1)
		set Obj.CTPHDMSManufacturerDesc=$p(ManfInfo,"^",2)
		set Obj.CTPHDMSMaterialCatCode="" //耗材大类
		set Obj.CTPHDMSMaterialSubCatCode="" //耗材子类
		set Obj.CTPHDMSProductCode=$p(Str,"^",2) //产品码
		set Obj.CTPHDMSStorageCondition="" //存储条件
		set Obj.CTPHDMSRegulatoryLevel="" //监管级别
		set Obj.CTPHDMSRegistrationNum=..GetRegCertNo(rowid) //注册证号
		set vendorDr=$p(Str1,"^",13)
		set:vendorDr'="" Obj.CTPHDMSVendorCode=$p($g(^APC("APCVM",vendorDr)),"^",1)
		set puomInfo=..GetItmpuomByInci(rowid)
		set Obj.CTPHDMSCheckInUnitCode=$p(puomInfo,"^",3)
		set Obj.CTPHDMSCheckInUnitDesc=$p(puomInfo,"^",2)
		set packuomInfo=..GetPackUom(rowid)
		set Obj.CTPHDMSPackageUnitCode=$p(packuomInfo,"^",3)
		set Obj.CTPHDMSPackageUnitDesc=$p(packuomInfo,"^",2)
		set Obj.CTPHDMSPackConvFacCode=..GetUomFac(rowid)
		set Obj.CTPHDMSCheckInConvFacCode=..GetRUomFac(rowid)
		set Obj.CTPHDMSSkinTestFlag=..GetSkinTest(rowid)
		set Obj.CTPHDMSChargeFlag=..GetChargeFlag(rowid)
		set Obj.CTPHDMSApprovalNum=..GetInfoRemark(rowid)
		set Obj.CTPHDMSStateBasicDryFlag=..GetBasicDrug(rowid)
		set uomInfo=..GetUom(rowid)
		set Obj.CTPHDMSBasicUnitCode=$p(uomInfo,"^",3)
		set Obj.CTPHDMSBasicUnitDesc=$p(uomInfo,"^",2)
		set Obj.CTPHDMSStopStatusFlag=$p($g(^INCI(rowid,2)),"^",9)  //停用标志 INCI_NotUseFlag
		d ListInfo.CTPHDrgMaterialStock.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPHDrgMaterialStock",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_PHDrgMaterialStock",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// 取医嘱的商品名
ClassMethod GetPHCDName(inci As %String) As %String
{
	q:inci="" ""
 	s arcim=$p($g(^INCI(inci,1)),"^",3)
 	q:arcim="" ""
 	s drgFormId=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",12)
	s labName=""
	i drgFormId'="" s labName=$p(^PHCD(+drgFormId,2),"^",7) //医嘱的商品名
	q labName
}

/// 取剂型
ClassMethod GetForm(inci As %String) As %String
{
    s phcform=""	    
    s arcim=$p($g(^INCI(inci,1)),"^",3)
    q:arcim="" ""
 	s drgFormId=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",12)
 	q:drgFormId="" ""
 	s phcd=$p(drgFormId,"||",1),phcdSub=$p(drgFormId,"||",2)
 	q:phcd="" ""
	s phcFormId=$p($g(^PHCD(phcd,"DF",phcdSub,1)),"^",1)
	q:phcFormId="" ""
	s phcFormCode=$p($g(^PHCF(phcFormId)),"^",1)
	s phcFormDesc=$p($g(^PHCF(phcFormId)),"^",2)
    q phcFormCode_"^"_phcFormDesc
}

/// 取等效数量、等效单位
ClassMethod GetEQInfo(inci As %String) As %String
{
    s phcform="",CTUom="",CTUomDesc="",EQCTUomDr="",EQQty=""	    
    s arcim=$p($g(^INCI(inci,1)),"^",3)
    q:arcim="" ""
 	s drgFormId=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",12)
 	q:drgFormId="" ""
 	s PhcdId=$p(drgFormId,"||",1),PhcdfId=$p(drgFormId,"||",2)
	s:(PhcdId'="")&&($d(^PHCD(PhcdId,"DF",PhcdfId,"EQ","0"))) EqSub=$o(^PHCD(PhcdId,"DF",PhcdfId,"EQ","0"))
	s:(PhcdId'="")&&($d(^PHCD(PhcdId,"DF",PhcdfId,"EQ","0")))&&(EqSub'="") EQCTUomDr=$p($g(^PHCD(PhcdId,"DF",PhcdfId,"EQ",EqSub)),"^",1)
	s:(PhcdId'="")&&($d(^PHCD(PhcdId,"DF",PhcdfId,"EQ","0")))&&(EqSub'="") EQQty=$p($g(^PHCD(PhcdId,"DF",PhcdfId,"EQ",EqSub)),"^",2)
	s:EQCTUomDr'="" CTUom=$p($g(^CT("UOM",EQCTUomDr)),"^",1)
	s:EQCTUomDr'="" CTUomDesc=$p($g(^CT("UOM",EQCTUomDr)),"^",1)
	q EQQty_"^"_CTUom_"^"_CTUomDesc
}

/// 取厂家代码和名称
ClassMethod GetManfByInci(inci As %String) As %String
{
	s arcim=$p($g(^INCI(inci,1)),"^",3),manf="",manfDesc=""
	q:arcim="" ""
 	s drgFormId=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",12)
 	q:drgFormId="" ""
 	s phcd=$p(drgFormId,"||",1)
 	q:phcd="" ""
 	s phcmnfDr=$p($g(^PHCD(phcd,2)),"^",4)
 	q:phcmnfDr="" ""
	s manf=$p($g(^PHMNF(phcmnfDr)),"^",1)
	s manfDesc=$p($g(^PHMNF(phcmnfDr)),"^",2)
	q phcmnfDr
}

/// 取危重药物标志
ClassMethod IsCriticalDrg(inci As %String) As %String
{
	s arcim=$p($g(^INCI(inci,1)),"^",3),phcPoDr="",criticalFlag=""
	q:arcim="" ""
 	s drgFormId=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",12)
 	s phcd=$p(drgFormId,"||",1)
 	q:phcd="" ""
 	s phcPoDr=$p($g(^PHCD(phcd,1)),"^",4)
 	if phcPoDr'="" s criticalFlag="Y"
 	else  s criticalFlag="N"
	q criticalFlag
}

/// 取基本单位代码、描述
ClassMethod GetUom(inci As %String) As %String
{
	q:inci="" ""
 	s uomDr=$p($g(^INCI(inci,1)),"^",10)
 	q:uomDr="" ""
 	s uomCode=$p($g(^CT("UOM",uomDr)),"^",1)
 	s uomDesc=$p($g(^CT("UOM",uomDr)),"^",2)
 	q uomCode_"^"_uomDesc_"^"_uomDr
}

/// 取管制分类代码、描述
ClassMethod GetPoisonInfo(inci As %String) As %String
{
    s arcim=$p($g(^INCI(inci,1)),"^",3),phcpoCode="",phcpoDesc=""
    q:arcim="" ""
 	s drgFormId=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",12)
 	s phcd=$p(drgFormId,"||",1)
 	q:phcd="" ""
 	s phcPoDr=$p($g(^PHCD(phcd,1)),"^",4)
 	q:phcPoDr="" ""
    s phcpoCode=$p($g(^PHCPO(phcPoDr)),"^",1)  
    s phcpoDesc=$p($g(^PHCPO(phcPoDr)),"^",2) 
    q phcpoCode_"^"_phcpoDesc
}

/// 取药学分类代码和名称
ClassMethod GetMinSubCatByInci(inci As %String) As %String
{
	s arcim=$p($g(^INCI(inci,1)),"^",3)
	q:arcim="" ""
 	s drgFormId=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",12)
 	q:drgFormId="" ""
 	s phcd=$p(drgFormId,"||",1)
 	q:phcd="" ""
 	s phcmscDr=$p($g(^PHCD(phcd,1)),"^",6)
 	q:phcmscDr="" ""
 	s phcdr=$p(phcmscDr,"||",1),phcsub=$p(phcmscDr,"||",2)
 	q:phcdr="" ""
 	s phcCode=$p($g(^PHCC(phcdr,"SC",phcsub)),"^",1)
 	s phcDesc=$p($g(^PHCC(phcdr,"SC",phcsub)),"^",2)
 	q phcCode_"^"_phcDesc
}

/// 取疗程代码和名称
ClassMethod GetDurationByInci(inci As %String) As %String
{
	s arcim=$p($g(^INCI(inci,1)),"^",3),phcdurationId=""
	q:arcim="" ""
 	s phcDurationId=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),8),"^",16)
 	q:phcDurationId="" ""
 	s phcDurationCode=$p($g(^PHCDU(phcDurationId)),"^",1)
 	s phcDurationDesc=$p($g(^PHCDU(phcDurationId)),"^",2)
 	q phcDurationCode_"^"_phcDurationDesc
}

/// 取频次代码和名称
ClassMethod GetFreqByInci(inci As %String) As %String
{
	s arcim=$p($g(^INCI(inci,1)),"^",3),phcdurationId=""
	q:arcim="" ""
 	s freqId=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),8),"^",17)
 	q:freqId="" ""
 	s freqCode=$p($g(^PHCFR(freqId)),"^",1)
 	s freqDesc=$p($g(^PHCFR(freqId)),"^",2)
 	q freqCode_"^"_freqDesc
}

/// 取用药途径代码和名称
ClassMethod GetInstrucByInci(inci As %String) As %String
{
	s arcim=$p($g(^INCI(inci,1)),"^",3)
	q:arcim="" ""
 	s drgFormId=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",12)
 	q:drgFormId="" ""
 	s phcd=$p(drgFormId,"||",1),phcdsub=$p(drgFormId,"||",2)
 	q:phcd="" ""
 	s instDr=$p($g(^PHCD(phcd,"DF",phcdsub,1)),"^",5)
 	q:instDr="" ""
 	s instCode=$p($g(^PHCIN(instDr)),"^",1)
 	s instDesc=$p($g(^PHCIN(instDr)),"^",2)
 	q instCode_"^"_instDesc
}

/// 取库存分类代码和名称
ClassMethod GetCTSCByInci(inci As %String) As %String
{
	s incscDr=$p($g(^INCI(inci,2)),"^",2)
	q:incscDr="" ""
 	s incscCode=$p($g(^INC("SC",incscDr)),"^",1)
 	s incscDesc=$p($g(^INC("SC",incscDr)),"^",2)
 	s incscCategory=$p($g(^INC("SC",incscDr)),"^",3)
 	q incscCode_"^"_incscDesc_"^"_incscCategory_"^"_incscDr
}

/// 取入库单位
ClassMethod GetItmpuomByInci(inci As %String) As %String
{
	s itmpuomdr=$p(^INCI(inci,3),"^",6)
	q:itmpuomdr="" ""
	s itmpuomCode=$p($g(^CT("UOM",itmpuomdr)),"^",1) //入库单位代码
	s itmpuomDesc=$p($g(^CT("UOM",itmpuomdr)),"^",2) //入库单位描述
	q itmpuomCode_"^"_itmpuomDesc_"^"_itmpuomdr
}

/// 取注册证号
ClassMethod GetRegCertNo(inci As %String) As %String
{
 	s IRRowID=""
	s:inci="" IRRowID=$o(^ITMREK("INCI",inci,0))
	s IRRegCertNo=""
	s:IRRowID'="" IRRegCertNo=$p($g(^ITMREK(IRRowID)),"^",11)
	q IRRegCertNo
}

/// 取年龄限制
ClassMethod GetAgeLimit(inci As %String) As %String
{
    s phcform=""	    
    s arcim=$p($g(^INCI(inci,1)),"^",3)
    q:arcim="" ""
 	s drgFormId=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",12)
 	q:drgFormId="" ""
 	s phcd=$p(drgFormId,"||",1),phcdSub=$p(drgFormId,"||",2)
 	q:phcd="" ""
	s ageLimit=$p($g(^PHCD(phcd,"DF",phcdSub,"DHC")),"^",4)
	q ageLimit
}

/// 取整包装单位
ClassMethod GetPackUom(inci As %String) As %String
{
   s dhcItmDr=$o(^DHCITMINFO(0,"INCI",inci,""))
   q:dhcItmDr="" ""
   s packUomDr=$p($g(^DHCITMINFO(dhcItmDr)),"^",51)
   q:packUomDr="" ""
   s packUomCode=$p($g(^CT("UOM",packUomDr)),"^",1)
   s packUomDesc=$p($g(^CT("UOM",packUomDr)),"^",2)
   q packUomCode_"^"_packUomDesc_"^"_packUomDr
}

/// 取皮试标记
ClassMethod GetSkinTest(inci As %String) As %String
{
   s dhcItmDr=$o(^DHCITMINFO(0,"INCI",inci,""))
   q:dhcItmDr="" ""
   s skinTest=$p($g(^DHCITMINFO(dhcItmDr)),"^",35)
   q skinTest
}

/// 取计费标志
ClassMethod GetChargeFlag(inci As %String) As %String
{
   s dhcItmDr=$o(^DHCITMINFO(0,"INCI",inci,""))
   q:dhcItmDr="" ""
   s chargeFlag=$p($g(^DHCITMINFO(dhcItmDr)),"^",57)
   q chargeFlag
}

/// 取批准文号
ClassMethod GetInfoRemark(inci As %String) As %String
{
   s dhcItmDr=$o(^DHCITMINFO(0,"INCI",inci,""))
   q:dhcItmDr="" ""
   s infoRemark=$p($g(^DHCITMINFO(dhcItmDr)),"^",10)
   q infoRemark
}

/// 取国家基本药物标记
ClassMethod GetBasicDrug(inci As %String) As %String
{
   s dhcItmDr=$o(^DHCITMINFO(0,"INCI",inci,""))
   q:dhcItmDr="" ""
   s basicDrug=$p($g(^DHCITMINFO(dhcItmDr)),"^",4)
   q basicDrug
}

/// 取大包装转换系数
ClassMethod GetUomFac(inci As %String) As %String
{
   //INFO_PackUomFactor
   s dhcItmDr=$o(^DHCITMINFO(0,"INCI",inci,""))
   q:dhcItmDr="" ""	
   s fac=$p($g(^DHCITMINFO(dhcItmDr)),"^",52)
   q fac
   /*
   s itmpuomdr=$p(^INCI(inci,3),"^",6)
   q:itmpuomdr="" ""
   s uomDr=$p($g(^INCI(inci,1)),"^",10)
   q:uomDr="" ""
   s fac=##class(web.DHCSTInterfacePH).UOMFac(itmpuomdr,uomDr)
   q fac
   */
}

/// Input:库存项ID
ClassMethod CatGrpType(inci As %String) As %String
{
	 q:inci="" ""
	 s incsc=$p($g(^INCI(inci,2)),"^",2)
	
	 q:incsc="" ""
	 s incsc=+incsc
	 s scg=$o(^DHCSCG("STKCAT",incsc,""))
	 if scg=""{
		set ^tmpll("count")=^tmpll("count")+1
		}
	 q:scg="" ""
	 s catgrpdr=$p(^DHCSCG(+scg),"^",3)
	 s catgrpdesc=$p(^DHCSCG(+scg),"^",1)
	 q catgrpdr_"^"_catgrpdesc
}

/// 取入库转换系数
ClassMethod GetRUomFac(inci As %String) As %String
{
   s itmpuomdr=$p($g(^INCI(inci,3)),"^",6)
   q:itmpuomdr="" ""
   s uomDr=$p($g(^INCI(inci,1)),"^",10)
   q:uomDr="" ""
   s fac=##class(web.DHCSTInterfacePH).UOMFac(itmpuomdr,uomDr)
   q fac
}

}
