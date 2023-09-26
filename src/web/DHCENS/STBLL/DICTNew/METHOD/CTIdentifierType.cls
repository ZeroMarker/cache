Class web.DHCENS.STBLL.DICTNew.METHOD.CTIdentifierType Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTIdentifierType).SendCTIdentifierType("")
ClassMethod SendCTIdentifierType(Input As %String) As %String
{
	set $Ztrap="Exception"
	set rowid=0,count=1
	set plist=##class(%ArrayOfDataTypes).%New()
	for{
		set rowid=$o(^PAC("CARD",rowid))
		Quit:(rowid="")||(+rowid=0)
		
		do plist.SetAt(rowid,count)
		set count=count+1
	}		
	set stream=..GetIdentifierTypeByID(plist)
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set tSC=soapObj.AcceptDicInfo("MES0001",stream)
	set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_IdentifierType",tSC)
	do tSC.OutputToDevice()
	
	Quit tSC.Read()
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTIdentifierType).GetCTIdentifierType("20").Read()
ClassMethod GetCTIdentifierType(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
		}
	if pList.Count()>0{
		set OutputStream=..GetIdentifierTypeByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

ClassMethod GetIdentifierTypeByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTIdentifierType).%New()
		set Str=$g(^PAC("CARD",rowid))
		set Obj.businessrowid=rowid
		set Obj.CTITCode=$p(Str,"^",1)
		set Obj.CTITDesc=$p(Str,"^",2)
		set Obj.CTITStartDate=$p(Str,"^",3)
		set Obj.CTITEndDate=$p(Str,"^",4)
		set Obj.CTITCodesystemCode="CT_IdentifierType"
		set Obj.CTITRemarks=""
		set Obj.CTITStatus="1"
		set Obj.CTITUpdateUserCode="无"
		d ListInfo.CTIdentifierType.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTIdentifierType",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_IdentifierType",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
