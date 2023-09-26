Class web.DHCENS.STBLL.DICTNew.METHOD.CTWard Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018-09-15
/// Description：
/// Table：pac_ward
/// Input： 
/// Return：根据rowid病区字典信息集合，ODS用
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTWard).GetCTWard("1").Read()
ClassMethod GetCTWard(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTWardByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：查询HIS中病区字典信息
/// Table：pac_ward
/// Input： 
/// Return：病区字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTWard).SendCTWard("")
ClassMethod SendCTWard(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid="0" for  s rowid=$o(^PAWARD(rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>20 d
	..set Instream=..GetCTWardByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Ward",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTWardByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Ward",tSC)

	q sc
Err
	q "-1^"_$ze
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回病区字典密文流
/// Table：pac_ward
/// Input： Array集合
/// Return：病区字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTWard).GetCTWardByID()
ClassMethod GetCTWardByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		s insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTWard).%New()
		s Str=$g(^PAWARD(rowid))
		Quit:rowid="BED_BedType_DR"
		Quit:rowid="BED_Room_DR"
		set locId=$p(Str,"^",5)
		Quit:locId=""
		s insObj.businessrowid=rowid
		s insObj.CTWCode=$p(Str,"^",1)
		s insObj.CTWDesc=$p(Str,"^",2)
		s insObj.CTWCodesystemCode="CT_Ward"
		s insObj.CTWRemarks=""
		s insObj.CTWStatus="1"
		s insObj.CTWUpdateUserCode="无"
		s insObj.CTWDeptCode=locId //$p($g(^CTLOC(locId)),"^",1)
		s startdate=$p(Str,"^",7)
		s:startdate="" startdate="61360" 
		s insObj.CTWStartDate=startdate 
		s enddate=$P(Str,"^",9)
		s:enddate'="" insObj.CTWEndDate=enddate 
		s hospId=$o(^CT("HOSP","0"))
		s hospCode=hospId //$p(^CT("HOSP",hospId),"^",1)	
		s insObj.CTWHosCode=hospCode
		d ListInfo.CTWard.Insert(insObj)
	}
	d ListInfo.XMLExportToString(.String)
	
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTWard",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).GetMainDataManager("CT_Ward",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
