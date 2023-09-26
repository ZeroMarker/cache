Class web.DHCENS.STBLL.DICTNew.METHOD.CTRHBloodType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：RH血型字典信息
/// Table：CT_RHBloodType
/// Input： 
/// Return：RH血型字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRHBloodType).GetCTRHBloodType("1")
ClassMethod GetCTRHBloodType(Input As %String) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
		}
	if pList.Count()>0{
		set OutputStream=..GetCTRHBloodTypeByID(pList)
	}
	w OutputStream.Read()
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：RH血型字典信息
/// Table：CT_RHBloodType
/// Input： 
/// Return：RH血型信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRHBloodType).SendCTRHBloodType("")
ClassMethod SendCTRHBloodType(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^RHBLOODTYPE(rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1

	if plist.Count()>0{
		set Instream=..GetCTRHBloodTypeByID(plist)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_RHBloodType",tSC)
		d tSC.OutputToDevice()
	} 
	q 1
Exception
	Quit -1_$ze
}

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：RH血型字典信息
/// Table：CT_RHBloodType
/// Input： 
/// Return：RH血型信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRHBloodType).GetCTRHBloodTypeByID("")
ClassMethod GetCTRHBloodTypeByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set bloodTypeInfo=$g(^RHBLOODTYPE(rowid))
		set bloodTypeObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTRHBloodType).%New()
		set bloodTypeObj.businessrowid=rowid
		set bloodTypeObj.CTRHBTCode=$p(bloodTypeInfo,"^",1)
		set bloodTypeObj.CTRHBTDesc=$p(bloodTypeInfo,"^",2)
		set bloodTypeObj.CTRHBTCodesystemCode="CT_RHBloodType"
		set bloodTypeObj.CTRHBTRemarks="无"
		set bloodTypeObj.CTRHBTStatus="1"
		set bloodTypeObj.CTRHBTStartDate=$p(bloodTypeInfo,"^",3)
		set bloodTypeObj.CTRHBTEndDate=""
		set bloodTypeObj.CTRHBTUpdateUserCode="无"
		d ListInfo.CTRHBloodType.Insert(bloodTypeObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTRHBloodType",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;w JsonString,!
	;;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	;set JsonString=$tr(JsonString,$c(13),"")
	;set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_RHBloodType",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
