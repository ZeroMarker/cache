Class web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnoseType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description：诊断类型字典信息
/// Table：MRC_DiagnosType
/// Input： 
/// Return：诊断类型字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnose).GetCTDiagnoseType("1").Read()
ClassMethod GetCTDiagnoseType(Input As %String = "") As %GlobalCharacterStream
{
	set $zt="Exception"
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
	}
	if pList.Count()>0{
		set OutputStream=..GetCTDiagnoseTypeByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回诊断类型字典密文流
/// Table：
/// Input： Array集合
/// Return：诊断类型字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnoseType).GetCTDiagnoseTypeByID()
ClassMethod GetCTDiagnoseTypeByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set diagTypeId=plist.GetAt(i)
		set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDiagnoseType).%New()
		set insObj.businessrowid=diagTypeId
		set insObj.CTDTCode=$P(^MRC("DTYP",diagTypeId),"^",1)
		set insObj.CTDTDesc=$P(^MRC("DTYP",diagTypeId),"^",2)
		set insObj.CTDTCodesystemCode="CT_DiagnoseType"
		set insObj.CTDTStatus="1"
		set insObj.CTDTUpdateUserCode="无"
		d ListInfo.CTDiagnoseType.Insert(insObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDiagnoseType",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)	
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DiagnoseType",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送诊断类型字典
/// Table：
/// Input： 诊断类型字典
/// Return：诊断类型字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnoseType).SendCTDiagnoseType("")
ClassMethod SendCTDiagnoseType(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^MRC("DTYP",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	if plist.Count()>0{
		set Instream=..GetCTDiagnoseTypeByID(plist)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		d tSC.OutputToDevice()
		set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_DiagnoseType",tSC)
	}
	q "1"
Err
	q "-1^"_$ze
}

}
