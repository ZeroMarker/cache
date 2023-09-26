Class web.DHCENS.STBLL.DICTNew.METHOD.CTEncounterStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：就诊状态字典
/// Table：
/// Input： 
/// Return：就诊状态字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTEncounterStatus).SendCTEncounterStatus("00001")
ClassMethod SendCTEncounterStatus(BusinessFieldCode As %String) As %String
{
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set String="<ListInfo><CTEncounterStatus><businessrowid>A</businessrowid><CTES_Code>A</CTES_Code><CTES_Desc>在就诊</CTES_Desc><CTES_CodesystemCode>CT_EncounterStatus</CTES_CodesystemCode><CTES_Status>1</CTES_Status><CTES_UpdateUserCode>无</CTES_UpdateUserCode><CTES_Remarks>无</CTES_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTEncounterStatus><CTEncounterStatus><businessrowid>C</businessrowid><CTES_Code>C</CTES_Code><CTES_Desc>取消就诊</CTES_Desc><CTES_CodesystemCode>CT_EncounterStatus</CTES_CodesystemCode><CTES_Status>1</CTES_Status><CTES_UpdateUserCode>无</CTES_UpdateUserCode><CTES_Remarks>无</CTES_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTEncounterStatus><CTEncounterStatus><businessrowid>D</businessrowid><CTES_Code>D</CTES_Code><CTES_Desc>已出院</CTES_Desc><CTES_CodesystemCode>CT_EncounterStatus</CTES_CodesystemCode><CTES_Status>1</CTES_Status><CTES_UpdateUserCode>无</CTES_UpdateUserCode><CTES_Remarks>无</CTES_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTEncounterStatus><CTEncounterStatus><businessrowid>P</businessrowid><CTES_Code>P</CTES_Code><CTES_Desc>其他</CTES_Desc><CTES_CodesystemCode>CT_EncounterStatus</CTES_CodesystemCode><CTES_Status>1</CTES_Status><CTES_UpdateUserCode>无</CTES_UpdateUserCode><CTES_Remarks>无</CTES_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTEncounterStatus></ListInfo>"
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTEncounterStatus",.Jsonobj)
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenString(String)
	Do reader.Correlate("ListInfo","web.DHCENS.STBLL.DICTNew.MODEL.ListInfo")
	While reader.Next(.obj,.sc) {
		set ListInfo=obj
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTEncounterStatus",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")  

	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)

	set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_EncounterStatus",JsonString)

	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)

	
	quit tSC.Read()
}

}
