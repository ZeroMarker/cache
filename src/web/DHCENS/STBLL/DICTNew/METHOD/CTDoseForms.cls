Class web.DHCENS.STBLL.DICTNew.METHOD.CTDoseForms Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：剂型字典信息
/// Table：phc_form
/// Input： 
/// Return：剂型字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDoseForms).GetCTDoseForms("")
ClassMethod GetCTDoseForms(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTDoseFormsByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：剂型字典信息
/// Table：phc_form
/// Input： 
/// Return：剂型字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDoseForms).SendCTDoseForms("")
ClassMethod SendCTDoseForms(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^PHCF(rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	if plist.Count()>0{
		set Instream=..GetCTDoseFormsByID(plist)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_DoseForms",tSC)
		do tSC.OutputToDevice()
	}
	q "1"
Exception
	Quit -1_$ze
}

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：剂型字典信息
/// Table：phc_form
/// Input： 
/// Return：剂型字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDoseForms).GetCTDoseFormsByID("")
ClassMethod GetCTDoseFormsByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDoseForms).%New()
		set Str=$g(^PHCF(rowid))
		set Obj.businessrowid=rowid
		set Obj.CTDFCode=$p(Str,"^",1)
		set Obj.CTDFDesc=$p(Str,"^",2)
		set Obj.CTDFCodesystemCode="CT_DoseForms"
		set Obj.CTDFRemarks=""
		set Obj.CTDFStatus="1"
		set Obj.CTDFUpdateUserCode="无"
		d ListInfo.CTDoseForms.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDoseForms",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DoseForms",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
