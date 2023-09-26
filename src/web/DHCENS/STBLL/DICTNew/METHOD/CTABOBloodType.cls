Class web.DHCENS.STBLL.DICTNew.METHOD.CTABOBloodType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：ABO血型字典信息
/// Table：CT_ABOBloodType
/// Input： 
/// Return：ABO血型字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTABOBloodType).GetCTABOBloodType("1")
ClassMethod GetCTABOBloodType(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTABOBloodTypeByID(pList)
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
/// Description：ABO血型字典信息
/// Table：CT_ABOBloodType
/// Input： 
/// Return：ABO血型信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTABOBloodType).SendCTABOBloodType("")
ClassMethod SendCTABOBloodType(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^PAC("BLDT",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	set Instream=..GetCTABOBloodTypeByID(plist)
	do Instream.Rewind()
	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ABOBloodType",tSC)
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：ABO血型字典信息
/// Table：CT_ABOBloodType
/// Input： 
/// Return：ABO血型信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTABOBloodType).GetCTABOBloodTypeByID("")
ClassMethod GetCTABOBloodTypeByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set bloodTypeInfo=$g(^PAC("BLDT",rowid))
		set bloodTypeObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTABOBloodType).%New()
		set bloodTypeObj.businessrowid=rowid
		set bloodTypeObj.CTABOBTCode=$p(bloodTypeInfo,"^",1)
		set bloodTypeObj.CTABOBTDesc=$p(bloodTypeInfo,"^",2)
		set bloodTypeObj.CTABOBTCodesystemCode="CT_ABOBloodType"
		set bloodTypeObj.CTABOBTRemarks="无"
		set bloodTypeObj.CTABOBTStatus="1"
		set bloodTypeObj.CTABOBTStartDate=""
		set bloodTypeObj.CTABOBTEndDate=""
		set bloodTypeObj.CTABOBTUpdateUserCode="无"
		d ListInfo.CTABOBloodType.Insert(bloodTypeObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTABOBloodType",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ABOBloodType",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
