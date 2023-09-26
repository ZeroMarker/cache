Class web.DHCENS.STBLL.DICT.METHOD.CTEncounterType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：就诊类型字典
/// Table：
/// Input： 
/// Return：就诊类型字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTEncounterType).CTEncounterType("00002")
ClassMethod CTEncounterType(BusinessFieldCode As %String) As %String
{
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Request><Header></Header><Body><CT_EncounterTypeList><CT_EncounterType><CTET_Code>O</CTET_Code><CTET_Desc>门诊</CTET_Desc><CTET_CodesystemCode>CT_EncounterType</CTET_CodesystemCode><CTET_Status>1</CTET_Status><CTET_UpdateUserCode>无</CTET_UpdateUserCode><CTET_Remarks>无</CTET_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_EncounterType><CT_EncounterType><CTET_Code>E</CTET_Code><CTET_Desc>急诊</CTET_Desc><CTET_CodesystemCode>CT_EncounterType</CTET_CodesystemCode><CTET_Status>1</CTET_Status><CTET_UpdateUserCode>无</CTET_UpdateUserCode><CTET_Remarks>无</CTET_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_EncounterType><CT_EncounterType><CTET_Code>I</CTET_Code><CTET_Desc>住院</CTET_Desc><CTET_CodesystemCode>CT_EncounterType</CTET_CodesystemCode><CTET_Status>1</CTET_Status><CTET_UpdateUserCode>无</CTET_UpdateUserCode><CTET_Remarks>无</CTET_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_EncounterType><CT_EncounterType><CTET_Code>H</CTET_Code><CTET_Desc>体检</CTET_Desc><CTET_CodesystemCode>CT_EncounterType</CTET_CodesystemCode><CTET_Status>1</CTET_Status><CTET_UpdateUserCode>无</CTET_UpdateUserCode><CTET_Remarks>无</CTET_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_EncounterType></CT_EncounterTypeList></Body></Request>")
	set tSC=soapObj.SaveManagerDataInfo("CT_EncounterType",stream)
	Quit tSC.Read()
}

}
