Class web.DHCENS.STBLL.DICTNew.METHOD.CTTitleOfTech Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：查询HIS中医生职称字典信息
/// Table：CT_Title
/// Input： 
/// Return：查询HIS中医生职称字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTTitleOfTech).GetCTTitleOfTech("11").Read()
ClassMethod GetCTTitleOfTech(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTTitleOfTechByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：查询HIS中医生职称字典信息
/// Table：CT_Title
/// Input： 
/// Return：查询HIS中医生职称字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTTitleOfTech).SendCTTitleOfTech("")
ClassMethod SendCTTitleOfTech(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("TTL",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTTitleOfTechByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_TitleOfTech",tSC)
	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：查询HIS中医生职称字典信息
/// Table：CT_Title
/// Input： 
/// Return：查询HIS中医生职称字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTTitleOfTech).GetCTTitleOfTechByID("")
ClassMethod GetCTTitleOfTechByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Info=$g(^CT("TTL",rowid))
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTTitleOfTech).%New()
		set Obj.businessrowid=rowid
		set Obj.CTTTCode=$p(Info,"^",1)
		set Obj.CTTTDesc=$p(Info,"^",2)
		set Obj.CTTTCodesystemCode="CT_TitleOfTech"
		set Obj.CTTTRemarks="无"
		set Obj.CTTTStartDate=$p(Info,"^",3)
		set Obj.CTTTEndDate=$p(Info,"^",4)
		set:Obj.CTTTEndDate="" Obj.CTTTStatus="1"
		set:Obj.CTTTEndDate'="" Obj.CTTTStatus="0"
		d ListInfo.CTTitleOfTech.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTTitleOfTech",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_TitleOfTech",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
