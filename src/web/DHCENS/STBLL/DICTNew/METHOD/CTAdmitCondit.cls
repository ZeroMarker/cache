Class web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitCondit Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：入院情况字典信息
/// Table：CT_AdmitCondit
/// Input： 
/// Return：入院情况字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitCondit).GetCTAdmitCondit("1")
ClassMethod GetCTAdmitCondit(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTAdmitConditByID(pList)
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
/// Description：入院情况字典信息
/// Table：CT_AdmitCondit
/// Input： 
/// Return：入院情况信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitCondit).SendCTAdmitCondit("")
ClassMethod SendCTAdmitCondit(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^PAC("REFPRI",rowid)) Quit:rowid=""  d
	.;w rowid
	.do plist.SetAt(rowid,count)
	.set count=count+1
	set Instream=..GetCTAdmitConditByID(plist)
	;w Instream.Read()
	do Instream.Rewind()
	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_AdmitCondit",tSC)
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：入院情况字典信息
/// Table：CT_AdmitCondit
/// Input： 
/// Return：入院情况信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitCondit).GetCTAdmitConditByID("")
ClassMethod GetCTAdmitConditByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set admitConditInfo=$g(^PAC("REFPRI",rowid))
		set admitConditObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTAdmitCondit).%New()
		set admitConditObj.businessrowid=rowid
		set admitConditObj.CTACCode=$p(admitConditInfo,"^",1)
		set admitConditObj.CTACDesc=$p(admitConditInfo,"^",2)
		set admitConditObj.CTACCodesystemCode="CT_AdmitCondit"
		set admitConditObj.CTACRemarks="无"
		set admitConditObj.CTACStatus="1"
		set admitConditObj.CTACStartDate=$p(admitConditInfo,"^",5)
		set admitConditObj.CTACEndDate=$p(admitConditInfo,"^",6)
		set admitConditObj.CTACUpdateUserCode="无"
		d ListInfo.CTAdmitCondit.Insert(admitConditObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTAdmitCondit",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_AdmitCondit",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
