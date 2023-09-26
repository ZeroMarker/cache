Class web.DHCENS.STBLL.DICT.METHOD.CTAddressType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016-11-26
/// Description：地址类型信息
/// Table：
/// Input： 
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.DICT.METHOD.CTAddressType).CTAddressType("00002")
ClassMethod CTAddressType(BusinessFieldCode As %String) As %String
{
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Request><Header></Header><Body><CT_AddressTypeList><CT_AddressType><CTAT_Code>01</CTAT_Code><CTAT_Desc>户籍住址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_AddressType><CT_AddressType><CTAT_Code>02</CTAT_Code><CTAT_Desc>工作场所地址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_AddressType><CT_AddressType><CTAT_Code>03</CTAT_Code><CTAT_Desc>家庭常住住址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_AddressType><CT_AddressType><CTAT_Code>04</CTAT_Code><CTAT_Desc>通讯地址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_AddressType><CT_AddressType><CTAT_Code>05</CTAT_Code><CTAT_Desc>暂住地址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_AddressType><CT_AddressType><CTAT_Code>06</CTAT_Code><CTAT_Desc>出生地址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_AddressType><CT_AddressType><CTAT_Code>07</CTAT_Code><CTAT_Desc>产后修养地址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_AddressType><CT_AddressType><CTAT_Code>08</CTAT_Code><CTAT_Desc>变迁地址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_AddressType><CT_AddressType><CTAT_Code>09</CTAT_Code><CTAT_Desc>现住址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_AddressType><CT_AddressType><CTAT_Code>99</CTAT_Code><CTAT_Desc>其他地址</CTAT_Desc><CTAT_CodesystemCode>CT_AddressType</CTAT_CodesystemCode><CTAT_Status>1</CTAT_Status><CTAT_UpdateUserCode>无</CTAT_UpdateUserCode><CTAT_Remarks>无</CTAT_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_AddressType></CT_AddressTypeList></Body></Request>")
	set tSC=soapObj.SaveManagerDataInfo("CT_AddressType",stream)
	Quit tSC.Read()
}

}
