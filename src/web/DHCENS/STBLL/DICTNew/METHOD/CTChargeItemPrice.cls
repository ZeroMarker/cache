Class web.DHCENS.STBLL.DICTNew.METHOD.CTChargeItemPrice Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator: ZhangXinying
/// Description：查询HIS收费项目价格信息
/// Table：dhc_taritemprice
/// Input： 收费项目价格字典
/// Return：收费项目价格字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTChargeItemPrice).CTChargeItemPrice("")
ClassMethod CTChargeItemPrice(input As %String = "") As %String
{
	s SuccessFlag=0
	s $zt="Exception"	
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s TARIRowId="" f  s TARIRowId=$o(^DHCTARI(TARIRowId)) q:TARIRowId=""  d
	.s ChildSub=0 f  s ChildSub=$o(^DHCTARI(TARIRowId,"P",ChildSub)) q:ChildSub=""  d
	..q:((ChildSub'=input)&&(input'=""))
	..s TPInfo=$g(^DHCTARI(TARIRowId,"P",ChildSub))
	..s TPObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTChargeItemPrice).%New()
	..s TPObj.CTCIPRowId=TARIRowId_"||"_ChildSub
	..s price=$p(TPInfo,"^",5)
	..s:price'="" TPObj.CTCIPPrice=$fn(price,",",2)
	..s TPObj.CTCIPChargeItemCode=$P($G(^DHCTARI(TARIRowId)),"^",1)
	..s TPPatInsType=$p(TPInfo,"^",13)
	..s:TPPatInsType'="" TPObj.CTCIPCostCategoryCode=$p($g(^PAC("ADMREA",TPPatInsType)),"^",1)
	..s TPObj.CTCIPCodesystemCode="CT_ChargeItemPrice"
	..s TPObj.CTCIPRemarks="无"
	..s TPObj.CTCIPStatus="1"
	..s TPObj.CTCIPUpdateUserCode=$p(TPInfo,"^",8)
	..s hospId=$o(^CT("HOSP","0"))
	..s hospCode=$p(^CT("HOSP",hospId),"^",1)	
	..s TPObj.CTCIPHosCode=hospCode
	..s TPObj.CTCIPStartDate=$p(TPInfo,"^",3)
	..s TPObj.CTCIPEndDate=$p(TPInfo,"^",4)
	..d ListInfo.CTChargeItemPrice.Insert(TPObj)
	..Quit:input'=""
	..set Count=ListInfo.CTChargeItemPrice.Count()
	..if Count>100 d
	...d ListInfo.XMLExportToString(.String)
	...set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTChargeItemPrice",.Jsonobj)
	...set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	...set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ChargeItemPrice",JsonString)
	...set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	...set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	...if resultCode=0 d
	....set success=0
	...else  d
	....set success=-1
	if count>0
	{
		d ListInfo.XMLExportToString(.String)
		set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTChargeItemPrice",.Jsonobj)
		set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
		set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ChargeItemPrice",JsonString)
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode=0 d
		.set success=0
		else  d
		.set success=-1
	}
	quit success
Exception
	Quit "-1^"_$ze
}

/// Creator: ZhangXinying
/// Description：根据rowid获取HIS收费项目价格信息，ODS用
/// Table：dhc_taritemprice
/// Input： 收费项目价格字典
/// Return：收费项目价格字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTChargeItemPrice).GetCTChargeItemPrice("1||1").Read()
ClassMethod GetCTChargeItemPrice(Input As %String = "") As %GlobalCharacterStream
{
	s success=0
	s $zt="Exception"	
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
		set chargeMainRowId=$p(rowid,"||",1) //收费项
		set startDate=$o(^DHCOLT(0,"TAR",chargeMainRowId,""))
		if startDate'=""{
			set linkRowId=$o(^DHCOLT(0,"TAR",chargeMainRowId,startDate,""))
			if linkRowId'=""{
				set arcItemRowId=$p(^DHCOLT(linkRowId),"^",1)
				if arcItemRowId'=""{
					set tscArc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTARCItmMast).SendCTARCItmMast(arcItemRowId)	
				}
			}
		}		
	}
	if pList.Count()>0{
		set OutputStream=..GetCTChargeItemPriceByID(pList)
	}
	
	Quit OutputStream
	
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：查询HIS中收费项目价格字典信息
/// Table：dhc_taritemprice
/// Input： 收费项目价格字典
/// Return：收费项目价格字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTChargeItemPrice).SendCTChargeItemPrice("")
ClassMethod SendCTChargeItemPrice(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s TARIRowId="" f  s TARIRowId=$o(^DHCTARI(TARIRowId)) q:TARIRowId=""  d
	.s ChildSub=0 f  s ChildSub=$o(^DHCTARI(TARIRowId,"P",ChildSub)) q:ChildSub=""  d
	..s rowid=TARIRowId_"||"_ChildSub
	..d plist.SetAt(rowid,count)
	..s count=count+1
	..if count>51 d
	...set Instream=..GetCTChargeItemPriceByID(plist)
	...set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	...set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ChargeItemPrice",tSC)
	...d tSC.OutputToDevice()
	...;b ;00
	...d Instream.Clear()
	...s count=1
	...d plist.Clear()
	set length=plist.Count()
	
	if length>0 d
	.set Instream=..GetCTChargeItemPriceByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ChargeItemPrice",tSC)

	q sc
Err
	q "-1^"_$ze
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回收费项目价格字典密文流
/// Table：
/// Input： Array集合
/// Return：收费项目价格字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTChargeItemPrice).GetCTChargeItemPriceByID()
ClassMethod GetCTChargeItemPriceByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		s insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTChargeItemPrice).%New()
		s TARIRowId=$p(rowid,"||",1),ChildSub=$p(rowid,"||",2)
		s TPInfo=$g(^DHCTARI(TARIRowId,"P",ChildSub))
		s TPObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTChargeItemPrice).%New()
		s TPObj.CTCIPRowId=TARIRowId_"||"_ChildSub
		s TPObj.businessrowid=TARIRowId_"||"_ChildSub
		s price=$p(TPInfo,"^",5)
		s:price'="" TPObj.CTCIPPrice=$fn(price,",",2)
		s TPObj.CTCIPChargeItemCode=TARIRowId //$P($G(^DHCTARI(TARIRowId)),"^",1)
		s TPPatInsType=$p(TPInfo,"^",13)
		s:TPPatInsType'="" TPObj.CTCIPCostCategoryCode=TPPatInsType //$p($g(^PAC("ADMREA",TPPatInsType)),"^",1)
		s TPObj.CTCIPCodesystemCode="CT_ChargeItemPrice"
		s TPObj.CTCIPRemarks="无"
		s TPObj.CTCIPStatus="1"
		s TPObj.CTCIPUpdateUserCode=$p(TPInfo,"^",8)
		s hospId=$o(^CT("HOSP","0"))
		s hospCode=$p(^CT("HOSP",hospId),"^",1)	
		s TPObj.CTCIPHosCode=hospId //hospCode
		s TPObj.CTCIPStartDate=$p(TPInfo,"^",3)
		s TPObj.CTCIPEndDate=$p(TPInfo,"^",4)
		d ListInfo.CTChargeItemPrice.Insert(TPObj)
	}
	d ListInfo.XMLExportToString(.String)
	
	set JsonStream=##class(%GlobalCharacterStream).%New()	
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTChargeItemPrice",.Jsonobj)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	//set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ChargeItemPrice",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
