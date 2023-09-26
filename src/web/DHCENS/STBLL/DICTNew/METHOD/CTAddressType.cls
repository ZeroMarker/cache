Class web.DHCENS.STBLL.DICTNew.METHOD.CTAddressType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：就诊状态字典
/// Table：
/// Input： 
/// Return：就诊状态字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAddressType).SendCTAddressType("00001")
ClassMethod SendCTAddressType(BusinessFieldCode As %String) As %String
{
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set String="<ListInfo><CTAddressType><businessrowid>01</businessrowid><CTAT_Code>01</CTAT_Code><CTAT_Desc>户籍住址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTAddressType><CTAddressType><businessrowid>02</businessrowid><CTAT_Code>02</CTAT_Code><CTAT_Desc>工作场所地址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTAddressType><CTAddressType><businessrowid>03</businessrowid><CTAT_Code>03</CTAT_Code><CTAT_Desc>家庭常住住址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTAddressType><CTAddressType><businessrowid>04</businessrowid><CTAT_Code>04</CTAT_Code><CTAT_Desc>通讯地址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTAddressType><CTAddressType><businessrowid>05</businessrowid><CTAT_Code>05</CTAT_Code><CTAT_Desc>暂住地址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTAddressType><CTAddressType><businessrowid>06</businessrowid><CTAT_Code>06</CTAT_Code><CTAT_Desc>出生地址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTAddressType><CTAddressType><businessrowid>07</businessrowid><CTAT_Code>07</CTAT_Code><CTAT_Desc>产后修养地址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTAddressType><CTAddressType><businessrowid>08</businessrowid><CTAT_Code>08</CTAT_Code><CTAT_Desc>变迁地址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTAddressType><CTAddressType><businessrowid>09</businessrowid><CTAT_Code>09</CTAT_Code><CTAT_Desc>现住址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTAddressType><CTAddressType><businessrowid>99</businessrowid><CTAT_Code>99</CTAT_Code><CTAT_Desc>其他地址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTAddressType></ListInfo>"
	;set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTAddressType",.Jsonobj)
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenString(String)
	Do reader.Correlate("ListInfo","web.DHCENS.STBLL.DICTNew.MODEL.ListInfo")
	While reader.Next(.obj,.sc) {
		set ListInfo=obj
	}	
	//d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTAddressType",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")  
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_AddressType",JsonString)
	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_AddressType",tSC)
	quit tSC.Read()
}

}
