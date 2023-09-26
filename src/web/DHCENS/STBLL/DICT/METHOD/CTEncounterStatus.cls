Class web.DHCENS.STBLL.DICT.METHOD.CTEncounterStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：就诊状态字典
/// Table：
/// Input： 
/// Return：就诊状态字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTEncounterStatus).CTEncounterStatus("00002")
ClassMethod CTEncounterStatus(BusinessFieldCode As %String) As %String
{
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Request><Header></Header><Body><CT_EncounterStatusList><CT_EncounterStatus><CTES_Code>A</CTES_Code><CTES_Desc>在就诊</CTES_Desc><CTES_CodesystemCode>CT_EncounterStatus</CTES_CodesystemCode><CTES_Status>1</CTES_Status><CTES_UpdateUserCode>无</CTES_UpdateUserCode><CTES_Remarks>无</CTES_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_EncounterStatus><CT_EncounterStatus><CTES_Code>C</CTES_Code><CTES_Desc>取消就诊</CTES_Desc><CTES_CodesystemCode>CT_EncounterStatus</CTES_CodesystemCode><CTES_Status>1</CTES_Status><CTES_UpdateUserCode>无</CTES_UpdateUserCode><CTES_Remarks>无</CTES_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_EncounterStatus><CT_EncounterStatus><CTES_Code>D</CTES_Code><CTES_Desc>已出院</CTES_Desc><CTES_CodesystemCode>CT_EncounterStatus</CTES_CodesystemCode><CTES_Status>1</CTES_Status><CTES_UpdateUserCode>无</CTES_UpdateUserCode><CTES_Remarks>无</CTES_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_EncounterStatus><CT_EncounterStatus><CTES_Code>P</CTES_Code><CTES_Desc>其他</CTES_Desc><CTES_CodesystemCode>CT_EncounterStatus</CTES_CodesystemCode><CTES_Status>1</CTES_Status><CTES_UpdateUserCode>无</CTES_UpdateUserCode><CTES_Remarks>无</CTES_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CT_EncounterStatus></CT_EncounterStatusList></Body></Request>")
	set tSC=soapObj.SaveManagerDataInfo("CT_EncounterStatus",stream)
	Quit tSC.Read()
}

}
