Class web.DHCENS.STBLL.DICTNew.METHOD.CTSCOrigin Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018—09-06
/// Description：产地字典信息
/// Table：DHC_STOrigin
/// Input： 
/// Return：产地字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSCOrigin).GetCTSCOrigin("23").Read()
ClassMethod GetCTSCOrigin(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTSCOriginByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回产地字典密文流
/// Table：DHC_STOrigin
/// Input： Array集合
/// Return：产地字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCTSCOrigin).GetCTCTSCOriginByID()
ClassMethod GetCTSCOriginByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTSCOrigin).%New()
		set Str=$g(^DHCSTORI(rowid))
		set Obj.businessrowid=rowid
		set Obj.CTSCOCode=$p(Str,"^",1)
		set Obj.CTSCODesc=$p(Str,"^",2)
		set Obj.CTSCOCodesystemCode="CT_SCOrigin"
		set Obj.CTSCOAlias=$p(Str,"^",3)
		set Obj.CTSCOType=$p(Str,"^",4)
		set Obj.CTSCORemarks=""
		set Obj.CTSCOStatus="1"
		set Obj.CTSCOUpdateUserCode="无"
		d ListInfo.CTSCOrigin.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTSCOrigin",.Jsonobj)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTSCOrigin",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_SCOrigin",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送产地信息字典
/// Table：DHC_STOrigin
/// Input： 产地信息字典
/// Return：产地信息字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSCOrigin).SendCTSCOrigin("")
ClassMethod SendCTSCOrigin(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^DHCSTORI(rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>50 d
	..set Instream=..GetCTSCOriginByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_SCOrigin",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTSCOriginByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_SCOrigin",tSC)
	q "0"
Err
	q "-1^"_$ze
}

}
