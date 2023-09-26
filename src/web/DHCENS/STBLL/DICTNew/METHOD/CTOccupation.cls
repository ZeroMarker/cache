Class web.DHCENS.STBLL.DICTNew.METHOD.CTOccupation Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：职业字典信息
/// Table：CT_Occupation
/// Input： 
/// Return：职业字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOccupation).GetCTOccupation("")
ClassMethod GetCTOccupation(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetOccupationByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// MDM初始化批量导入字典
/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：职业字典信息
/// Table：CT_Occupation
/// Input： 
/// Return：职业信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOccupation).SendCTOccupation("")
ClassMethod SendCTOccupation(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("OCC",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetOccupationByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Occupation",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetOccupationByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Occupation",tSC)
	.d tSC.OutputToDevice()	
	q "0" ;sc
#;	set Instream=..GetOccupationByID(plist)
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

ClassMethod GetOccupationByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set occObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTOccupation).%New()
		set occInfo=$g(^CT("OCC",rowid))
		set occObj.businessrowid=rowid
		set occObj.CTOCode=$p(occInfo,"^",1)
		set occObj.CTODesc=$p(occInfo,"^",2)
		set occObj.CTOCodesystemCode="CT_Occupation"
		set occObj.CTORemarks="无"
		set occObj.CTOStatus="1"
		set occObj.CTOUpdateUserCode="无"
		set occObj.CTOStartDate=$p(occInfo,"^",3)
		set occObj.CTOEndDate=$p(occInfo,"^",4)
		do ListInfo.CTOccupation.Insert(occObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTOccupation",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Occupation",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
