Class web.DHCENS.STBLL.DICTNew.METHOD.CTDischCondit Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description：出院情况信息
/// Table：PAC_DischCondit
/// Input： 
/// Return：出院情况集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDischCondit).GetCTDischCondit("1").Read()
ClassMethod GetCTDischCondit(Input As %String = "") As %GlobalCharacterStream
{
	set $zt="Exception"
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
	}
	if pList.Count()>0{
		set OutputStream=..GetCTDischConditByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回出院情况字典密文流
/// Table：
/// Input： Array集合
/// Return：出院情况字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDischCondit).GetCTDischConditByID()
ClassMethod GetCTDischConditByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set RowId=plist.GetAt(i)
		set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDischCondit).%New()
		set Str=$g(^PAC("DISCON",RowId))
		set insObj.businessrowid=RowId
		set insObj.CTDCCode=$P(Str,"^",1)
		set insObj.CTDCDesc=$P(Str,"^",2)
		set insObj.CTDCCodesystemCode="CT_DischCondit"
		set insObj.CTDCStartDate=$P(Str,"^",4)
		set insObj.CTDCEndDate=$P(Str,"^",5)
		set insObj.CTDCStatus="1"
		set insObj.CTDCUpdateUserCode="无"
		d ListInfo.CTDischCondit.Insert(insObj)
	}
	d ListInfo.XMLExportToString(.String)	
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDischCondit",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DischCondit",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送出院情况字典
/// Table：
/// Input：
/// Return：出院情况字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDischCondit).SendCTDischCondit("")
ClassMethod SendCTDischCondit(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^PAC("DISCON",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	if plist.Count()>0{
		set Instream=..GetCTDischConditByID(plist)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		d tSC.OutputToDevice()
		set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_DischCondit",tSC)		
	}
	q sc
Err
	q "-1^"_$ze
}

}
