Class web.DHCENS.STBLL.DICTNew.METHOD.CTAnaesthesiaType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018-09-15
/// Description：
/// Table：ORC_AnaestType
/// Input： 
/// Return：根据rowid麻醉类型字典信息集合，ODS用
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAnaesthesiaType).GetCTAnaesthesiaType("176").Read()
ClassMethod GetCTAnaesthesiaType(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTAnaesthesiaTypeByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：查询HIS中麻醉类型字典信息
/// Table：ORC_AnaestType
/// Input： 
/// Return：麻醉类型字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAnaesthesiaType).SendCTAnaesthesiaType("")
ClassMethod SendCTAnaesthesiaType(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid="0" for  s rowid=$o(^ORC("ANTYPE",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>50 d
	..set Instream=..GetCTAnaesthesiaTypeByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ORCAnaestType",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTAnaesthesiaTypeByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ORCAnaestType",tSC)

	q sc
Err
	q "-1^"_$ze
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回麻醉类型字典密文流
/// Table：ORC_AnaestType
/// Input： Array集合
/// Return：麻醉类型字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAnaesthesiaType).GetCTAnaesthesiaTypeByID()
ClassMethod GetCTAnaesthesiaTypeByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		s insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTAnaesthesiaType).%New()
		s Str=$g(^ORC("ANTYPE",rowid))
		s insObj.businessrowid=rowid
		s insObj.CTORCATCode=$p(Str,"^",1)
		s insObj.CTORCATDesc=$p(Str,"^",2)
		s insObj.CTORCATCodesystemCode="CT_ORCAnaestType"
		s insObj.CTORCATRemarks=""
		s insObj.CTORCATStatus="1"
		s insObj.CTORCATUpdateUserCode="无"
		s insObj.CTORCATStartDate=$p(Str,"^",3)
		s insObj.CTORCATEndDate=$P(Str,"^",4)
		s hospId=$o(^CT("HOSP","0"))
		s hospCode=hospId ///$p(^CT("HOSP",hospId),"^",1)	
		s insObj.CTORCATHosCode=hospCode
		d ListInfo.CTORCAnaestType.Insert(insObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTORCAnaestType",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ORCAnaestType",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
