Class web.DHCENS.STBLL.DICTNew.METHOD.CTSpec Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：zhengchenghou
/// CreatDate：2018-06-04
/// Description：医护人员专长字典信息
/// Table：
/// Input： CT_Spec
/// Return：医护人员专长字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSpec).CTSpec("")
ClassMethod CTSpec(input As %String) As %String
{
	set $zt="MsgErr"
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set RowId=0 f  set RowId=$O(^CT("SPC",RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTSpec).%New()
	.set Str=$g(^CT("SPC",RowId))
	.set Obj.CTSPCCode=$p(Str,"^",1)
	.set Obj.CTSPCDesc=$p(Str,"^",2)
	.set Obj.CTSCodesystemCode="CT_Spec"
	.set Obj.CTSStatus="1"
	.set Obj.CTSUpdateUserCode="无"
	.d ListInfo.CTSpec.Insert(Obj)
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTSpec",.Jsonobj)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Spec",JsonString)
	set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	if resultCode=0 d
	.set success=0
	else  d
	.set success=-1
	quit success
MsgErr
	quit "-1^"_$ze
}

/// Description：医护人员专长字典信息
/// Table：CT_Spec
/// Input： 
/// Return：医护人员专长字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSpec).GetCTSpec("57").Read()
ClassMethod GetCTSpec(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTSpecByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回医护人员专长字典密文流
/// Table：
/// Input： Array集合
/// Return：医护人员专长字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCTSpec).GetCTCTSpecByID()
ClassMethod GetCTSpecByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTSpec).%New()
		set Str=$g(^CT("SPC",rowid))
		set Obj.CTSPCCode=$p(Str,"^",1)
		set Obj.CTSPCDesc=$p(Str,"^",2)
		set Obj.CTSCodesystemCode="CT_Spec"
		set Obj.CTSStatus="1"
		set Obj.CTSUpdateUserCode="无"
		d ListInfo.CTSpec.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTSpec",.Jsonobj)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Spec",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送医护人员专长信息字典
/// Table：
/// Input： 医护人员专长字典
/// Return：医护人员专长字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSpec).SendCTSpec("")
ClassMethod SendCTSpec(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^CT("SPC",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>200 d
	..set Instream=..GetCTSpecByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Spec",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTSpecByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Spec",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
