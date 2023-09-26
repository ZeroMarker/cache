Class web.DHCENS.STBLL.DICTNew.METHOD.CTCutType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018-09-15
/// Description：
/// Table：ORC_BladeType
/// Input： 
/// Return：根据rowid取切口类型字典信息集合，ODS用
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCutType).GetCTCutType("24").Read()
ClassMethod GetCTCutType(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTCutTypeByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：查询HIS中切口类型字典信息
/// Table：ORC_BladeType
/// Input： 
/// Return：切口类型字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCutType).SendCTCutType("")
ClassMethod SendCTCutType(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid="0" for  s rowid=$o(^ORC("BLDTP",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>200 d
	..set Instream=..GetCTCutTypeByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CutType",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTCutTypeByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CutType",tSC)

	q sc
Err
	q "-1^"_$ze
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回切口类型字典密文流
/// Table：ORC_BladeType
/// Input： Array集合
/// Return：切口类型字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCutType).GetCTCutTypeByID()
ClassMethod GetCTCutTypeByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		s insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCutType).%New()
		s Str=$g(^ORC("BLDTP",rowid))
		s insObj.businessrowid=rowid
		s insObj.CTCTCode=$p(Str,"^",1)
		s insObj.CTCTDesc=$p(Str,"^",2)
		s insObj.CTCTCodesystemCode="CT_CutType"
		s insObj.CTCTRemarks=""
		s insObj.CTCTStatus="1"
		s insObj.CTCTUpdateUserCode="无"
		s insObj.CTCTStartDate=$p(Str,"^",3)
		s insObj.CTCTEndDate=$P(Str,"^",4)
		s hospId=$o(^CT("HOSP","0"))
		s hospCode=$p(^CT("HOSP",hospId),"^",1)	
		s insObj.CTCTHosCode=hospId //hospCode
		
		d ListInfo.CTCutType.Insert(insObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCutType",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_CutType",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
