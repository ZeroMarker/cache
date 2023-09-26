Class web.DHCENS.STBLL.DICTNew.METHOD.CTDeptClass Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018-11-06
/// Description：科室类别信息
/// Table：
/// Input： 
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptClass).SendCTDeptClass("00001")
ClassMethod SendCTDeptClass(BusinessFieldCode As %String) As %String
{
	s $zt="Exception"	
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set String="<ListInfo><CTDeptClass><CTDC_Code>W</CTDC_Code><CTDC_Desc>Ward</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>E</CTDC_Code><CTDC_Desc>Execute</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>DI</CTDC_Code><CTDC_Desc>Drug Injection</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>D</CTDC_Code><CTDC_Desc>Dispensing</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>C</CTDC_Code><CTDC_Desc>Cashier</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>O</CTDC_Code><CTDC_Desc>Other</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>OP</CTDC_Code><CTDC_Desc>Operating Theatre</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>EM</CTDC_Code><CTDC_Desc>Emergency</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>DS</CTDC_Code><CTDC_Desc>Day Surgery</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>MR</CTDC_Code><CTDC_Desc>Medical Records</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>OR</CTDC_Code><CTDC_Desc>OutPatient Consulting Room</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>CL</CTDC_Code><CTDC_Desc>Clinic</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>ADM</CTDC_Code><CTDC_Desc>Admission Point</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass></ListInfo>"
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDeptClass",.Jsonobj)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DeptClass",JsonString)
	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	if resultCode=0 d
	.set success=0
	else  d
	.set success=-1
	quit success
Exception
	Quit "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2018-11-06
/// Description：科室类别信息
/// Table：
/// Input： 
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptClass).GetCTDeptClass("00001").Read()
ClassMethod GetCTDeptClass(BusinessFieldCode As %String) As %GlobalCharacterStream
{
	s $zt="Exception"	
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set String="<ListInfo><CTDeptClass><CTDC_Code>W</CTDC_Code><CTDC_Desc>Ward</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>E</CTDC_Code><CTDC_Desc>Execute</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>DI</CTDC_Code><CTDC_Desc>Drug Injection</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>D</CTDC_Code><CTDC_Desc>Dispensing</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>C</CTDC_Code><CTDC_Desc>Cashier</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>O</CTDC_Code><CTDC_Desc>Other</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>OP</CTDC_Code><CTDC_Desc>Operating Theatre</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>EM</CTDC_Code><CTDC_Desc>Emergency</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>DS</CTDC_Code><CTDC_Desc>Day Surgery</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>MR</CTDC_Code><CTDC_Desc>Medical Records</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>OR</CTDC_Code><CTDC_Desc>OutPatient Consulting Room</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>CL</CTDC_Code><CTDC_Desc>Clinic</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass><CTDeptClass><CTDC_Code>ADM</CTDC_Code><CTDC_Desc>Admission Point</CTDC_Desc><CTDC_CodesystemCode>CT_DeptClass</CTDC_CodesystemCode><CTDC_Status>1</CTDC_Status><CTDC_UpdateUserCode>无</CTDC_UpdateUserCode><CTDC_Remarks>无</CTDC_Remarks><BusinessFieldCode>"_BusinessFieldCode_"</BusinessFieldCode></CTDeptClass></ListInfo>"
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDeptClass",.Jsonobj)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DeptClass",JsonString)
	quit Instream
Exception
	Quit "-1^"_$ze
}

}
