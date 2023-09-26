Class web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-13
/// Description：医护人员类型
/// Table：CT_CarPrvTp
/// Input： 
/// Return：医护人员类型
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvType).GetCTDuration("")
ClassMethod GetCTCareProvType(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTCareProvTypeByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018-11-13
/// Description：医护人员类型
/// Table：CT_CarPrvTp
/// Input： 
/// Return：医护人员类型
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvType).SendCTCareProvType("")
ClassMethod SendCTCareProvType(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("CPT",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetCTCareProvTypeByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CareProvType",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTCareProvTypeByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CareProvType",tSC)
	
	q "0" ;sc
#;	set Instream=..GetCTCareProvTypeByID(plist)
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-13
/// Description：医护人员类型
/// Table：CT_CarPrvTp
/// Input： 
/// Return：医护人员类型
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvType).GetCTCareProvTypeByID("")
ClassMethod GetCTCareProvTypeByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCareProvType).%New()
		set Str=$g(^CT("CPT",rowid))
		set Obj.businessrowid=rowid
		set Obj.CTCPTCode=$p(Str,"^",1)
		set Obj.CTCPTDesc=$p(Str,"^",2)
		set Obj.CTCPTCodesystemCode="CT_CareProvType"
		set Obj.CTCPTRemarks=""
		set isActive=$p(Str,"^",3)
		set:isActive="Y" Obj.CTCPTStatus="1"
		set:isActive="N" Obj.CTCPTStatus="0"
		set Obj.CTCPTStartDate=$p(Str,"^",5)
		set Obj.CTCPTUpdateUserCode="无"
		d ListInfo.CTCareProvType.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCareProvType",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_CareProvType",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
