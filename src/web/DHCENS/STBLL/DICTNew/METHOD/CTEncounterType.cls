Class web.DHCENS.STBLL.DICTNew.METHOD.CTEncounterType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：推送就诊类型字典到主数据
/// Table：
/// Input： 
/// Return：就诊类型字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTEncounterType).SendCTEncounterType("00001")
ClassMethod SendCTEncounterType(BusinessFieldCode As %String) As %String
{
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set String="<ListInfo><CTEncounterType><businessrowid>O</businessrowid><CTET_Code>O</CTET_Code><CTET_Desc>门诊</CTET_Desc><CTET_CodesystemCode>CT_EncounterType</CTET_CodesystemCode><CTET_Status>1</CTET_Status><CTET_UpdateUserCode>无</CTET_UpdateUserCode><CTET_Remarks>无</CTET_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTEncounterType><CTEncounterType><businessrowid>E</businessrowid><CTET_Code>E</CTET_Code><CTET_Desc>急诊</CTET_Desc><CTET_CodesystemCode>CT_EncounterType</CTET_CodesystemCode><CTET_Status>1</CTET_Status><CTET_UpdateUserCode>无</CTET_UpdateUserCode><CTET_Remarks>无</CTET_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTEncounterType><CTEncounterType><businessrowid>I</businessrowid><CTET_Code>I</CTET_Code><CTET_Desc>住院</CTET_Desc><CTET_CodesystemCode>CT_EncounterType</CTET_CodesystemCode><CTET_Status>1</CTET_Status><CTET_UpdateUserCode>无</CTET_UpdateUserCode><CTET_Remarks>无</CTET_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTEncounterType><CTEncounterType><businessrowid>H</businessrowid><CTET_Code>H</CTET_Code><CTET_Desc>体检</CTET_Desc><CTET_CodesystemCode>CT_EncounterType</CTET_CodesystemCode><CTET_Status>1</CTET_Status><CTET_UpdateUserCode>无</CTET_UpdateUserCode><CTET_Remarks>无</CTET_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTEncounterType></ListInfo>"
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTEncounterType",.Jsonobj)
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenString(String)
	Do reader.Correlate("ListInfo","web.DHCENS.STBLL.DICTNew.MODEL.ListInfo")
	While reader.Next(.obj,.sc) {
		set ListInfo=obj
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTEncounterType",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")  
	;b ;JsonString
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_EncounterType",JsonString)
	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	
	quit tSC.Read()
}

}
