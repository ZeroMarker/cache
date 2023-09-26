Class web.DHCENS.STBLL.DICTNew.METHOD.CTCardType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：获取卡类型字典信息
/// Table：DHC_CardTypeDef
/// Input： 
/// Return：卡类型字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCardType).SendCTCardType("")
ClassMethod SendCTCardType(Input As %String) As %String
{
	set $Ztrap="Exception"
	set rowid=0,count=1
	set plist=##class(%ArrayOfDataTypes).%New()
	for{
		set rowid=$o(^DHCCARDTYPEDef(rowid))
		Quit:(rowid="")||(+rowid=0)
		do plist.SetAt(rowid,count)
		set count=count+1
	}
	set stream=..GetCardTypeByID(plist)
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set tSC=soapObj.AcceptDicInfo("MES0001",stream)
	set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CardType",tSC)
	do tSC.OutputToDevice()
	Quit tSC.Read()
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：获取卡类型字典信息
/// Table：DHC_CardTypeDef
/// Input： 
/// Return：检查部位字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCardType).GetCTCardType("1").Read()
ClassMethod GetCTCardType(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCardTypeByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：获取卡类型字典信息
/// Table：DHC_CardTypeDef
/// Input： 
/// Return：卡类型字典信息集合
ClassMethod GetCardTypeByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCardType).%New()
		set message=$g(^DHCCARDTYPEDef(rowid))
		set obj.businessrowid=rowid
		set obj.CTCTCode=$P(message,"^",1)
		set obj.CTCTCodesystemCode="CT_CardType"
		set obj.CTCTDesc=$P(message,"^",2)
		set obj.CTCTRemarks="无"
		set StartDate=$P(message,"^",9)
		set obj.CTCTStartDate=StartDate
		set EndDate=$P(message,"^",10)
		set obj.CTCTEndDate=EndDate
		set obj.CTCTStatus=1
		set obj.CTCTUpdateUserCode="无"
		do ListInfo.CTCardType.Insert(obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCardType",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_CardType",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
