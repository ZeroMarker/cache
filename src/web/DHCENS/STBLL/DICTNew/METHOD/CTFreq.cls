Class web.DHCENS.STBLL.DICTNew.METHOD.CTFreq Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-13
/// Description：药品频次字典信息
/// Table：PHC_Freq
/// Input： 
/// Return：药品频次字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTFreq).GetCTFreq("1").Read()
ClassMethod GetCTFreq(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTFreqByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018-11-13
/// Description：药品频次字典信息
/// Table：PHC_Freq
/// Input： 
/// Return：药品频次字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTFreq).SendCTFreq("")
ClassMethod SendCTFreq(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^PHCFR(rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	if plist.Count()>0{
		set Instream=..GetCTFreqByID(plist)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Freq",tSC)
		do tSC.OutputToDevice()
	}	
	Quit "1"
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-13
/// Description：药品频次字典信息
/// Table：PHC_Freq
/// Input： 
/// Return：药品频次字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTFreq).GetCTFreqByID("")
ClassMethod GetCTFreqByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTFreq).%New()
		set Str=$g(^PHCFR(rowid))
		set Obj.businessrowid=rowid
		set Obj.CTFCode=$p(Str,"^",1)
		set Obj.CTFDesc=$p(Str,"^",4)
		set Obj.CTFEngDesc=$p(Str,"^",1)
		set:Obj.CTFDesc="" Obj.CTFDesc=$p(Str,"^",3)
		set Obj.CTFCodesystemCode="CT_Freq"
		set Obj.CTFRemarks=""
		set Obj.CTFStatus="1"
		set Obj.CTFUpdateUserCode="无"
		set Obj.CTFFactor=$p(Str,"^",2)
		set ActiveFlag=$p(Str,"^",6)
		set:ActiveFlag="Y" Obj.CTFStatus="1"
		d ListInfo.CTFreq.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTFreq",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Freq",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
