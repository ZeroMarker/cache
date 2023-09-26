Class web.DHCENS.STBLL.DICTNew.METHOD.CTAllergySource Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：过敏源字典信息
/// Table：CT_AllergySource
/// Input： 
/// Return：过敏源字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAllergySource).GetCTAllergySource("1")
ClassMethod GetCTAllergySource(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTAllergySourceByID(pList)
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
/// Description：过敏源字典信息
/// Table：CT_AllergySource
/// Input： 
/// Return：过敏源信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAllergySource).SendCTAllergySource("")
ClassMethod SendCTAllergySource(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^PAC("ALG",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	set Instream=..GetCTAllergySourceByID(plist)
	do Instream.Rewind()
	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_AllergySource",tSC)
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：过敏源字典信息
/// Table：CT_AllergySource
/// Input： 
/// Return：过敏源信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAllergySource).GetCTAllergySourceByID("")
ClassMethod GetCTAllergySourceByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set allergySourceInfo=$g(^PAC("ALG",rowid))
		set allergySourceObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTAllergySource).%New()
		set allergySourceObj.businessrowid=rowid
		set allergySourceObj.CTASCode=$p(allergySourceInfo,"^",1)
		set allergySourceObj.CTASDesc=$p(allergySourceInfo,"^",2)
		set allergySourceObj.CTASCodesystemCode="CT_AllergySource"
		set allergySourceObj.CTASRemarks="无"
		set allergySourceObj.CTASStatus="1"
		set allergySourceObj.CTASStartDate=$p(allergySourceInfo,"^",4)
		set allergySourceObj.CTASEndDate=""
		set allergySourceObj.CTASUpdateUserCode="无"
		set type=$p(allergySourceInfo,"^",3)
		set allergySourceObj.CTASType=$p(^MRC("AT",type),"^",1)
		d ListInfo.CTAllergySource.Insert(allergySourceObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTAllergySource",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_AllergySource",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
