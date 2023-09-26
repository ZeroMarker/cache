Class web.DHCENS.STBLL.DICTNew.METHOD.CTORCAnaestComplications Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018-09-15
/// Description：麻醉并发症
/// Table：ORC_Anaest_Complications
/// Input： 
/// Return：根据rowid取麻醉并发症字典信息集合，ODS用
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTORCAnaestComplications).GetCTORCAnaestComplications("1").Read()
ClassMethod GetCTORCAnaestComplications(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTORCAnaestComplicationsByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：查询HIS中麻醉并发症字典信息
/// Table：
/// Input： 
/// Return：麻醉并发症字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTORCAnaestComplications).SendCTORCAnaestComplications("")
ClassMethod SendCTORCAnaestComplications(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid="0" for  s rowid=$o(^ORC("COMP",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>200 d
	..set Instream=..GetCTORCAnaestComplicationsByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ORCAnaestComplications",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTORCAnaestComplicationsByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ORCAnaestComplications",tSC)

	q sc
Err
	q "-1^"_$ze
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回麻醉并发症字典密文流
/// Table：ORC_AnaestType_Complications
/// Input： Array集合
/// Return：麻醉并发症字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTORCAnaestComplications).GetCTORCAnaestComplicationsByID()
ClassMethod GetCTORCAnaestComplicationsByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		s insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTORCAnaestComplications).%New()
		s Str=$g(^ORC("COMP",rowid))
		s insObj.businessrowid=rowid
		s insObj.CTORCACCode=$p(Str,"^",1)
		s insObj.CTORCACDesc=$p(Str,"^",2)
		s insObj.CTORCACCodesystemCode="CT_ORCAnaestComplications"
		s insObj.CTORCACRemarks=""
		s insObj.CTORCACStatus="1"
		s insObj.CTORCACUpdateUserCode="无"
		s hospId=$o(^CT("HOSP","0"))
		s hospCode=$p(^CT("HOSP",hospId),"^",1)	
		s insObj.CTORCACHosCode=hospId //hospCode
		d ListInfo.CTORCAnaestComplications.Insert(insObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTORCAnaestComplications",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ORCAnaestComplications",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
