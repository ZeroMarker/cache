Class web.DHCENS.STBLL.DICTNew.METHOD.CTPHCPoison Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018—09-06
/// Description：管制分类字典信息
/// Table：PHC_Poison
/// Input： 
/// Return：管制分类字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHCPoison).GetCTPHCPoison("1").Read()
ClassMethod GetCTPHCPoison(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTPHCPoisonByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回管制分类字典密文流
/// Table：PHC_Poison
/// Input： Array集合
/// Return：管制分类字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHCPoison).GetCTPHCPoisonByID()
ClassMethod GetCTPHCPoisonByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPHCPoison).%New()
		set Str=$g(^PHCPO(rowid))
		set Obj.businessrowid=rowid
		set Obj.CTPHCPCode=$p(Str,"^",1)
		set Obj.CTPHCPDesc=$p(Str,"^",2)
		set Obj.CTPHCPCodesystemCode="CT_PHCPoison"
		set Obj.CTPHCPRemarks=""
		set Obj.CTPHCPStatus="1"
		set Obj.CTPHCPUpdateUserCode="无"
		d ListInfo.CTPHCPoison.Insert(Obj)
		set count=ListInfo.CTPHCPoison.Count()
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPHCPoison",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_PHCPoison",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送管制分类信息字典
/// Table：PHC_Poison
/// Input： 
/// Return：管制分类信息字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHCPoison).SendCTPHCPoison("")
ClassMethod SendCTPHCPoison(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^PHCPO(rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>100 d
	..set Instream=..GetCTPHCPoisonByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PHCPoison",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTPHCPoisonByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PHCPoison",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
