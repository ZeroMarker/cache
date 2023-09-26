Class web.DHCENS.STBLL.DICTNew.METHOD.CTPharmacologyCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description：药理学（大类）字典信息
/// Table：phc_cat
/// Input： 
/// Return：药理学（大类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPharmacologyCategory).GetCTPharmacologyCategory("1").Read()
ClassMethod GetCTPharmacologyCategory(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTPharmacologyCategoryByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送药理学（大类）信息字典
/// Table：phc_cat
/// Input： 
/// Return：药理学（大类）信息字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPharmacologyCategory).SendCTPharmacologyCategory("")
ClassMethod SendCTPharmacologyCategory(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^PHCC(rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>200 d
	..set Instream=..GetCTPharmacologyCategoryByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PHCCategory",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTPharmacologyCategoryByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PHCCategory",tSC)
	q "1"
Err
	q "-1^"_$ze
}

ClassMethod GetCTPharmacologyCategoryByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPharmacologyCategory).%New()
		set rowid=plist.GetAt(i)
		set Str=$g(^PHCC(rowid))
		q:Str=""
		set Obj.businessrowid=rowid
		set Obj.CTPHCCCode=$p(Str,"^",1)
		set Obj.CTPHCCDesc=$p(Str,"^",2)
		set Obj.CTPHCCCodesystemCode="CT_PHCCategory"
		set Obj.CTPHCCRemarks=""
		set Obj.CTPHCCStatus="1"
		set Obj.CTPHCCUpdateUserCode="无"
		d ListInfo.CTPHCCategory.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPHCCategory",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_PHCCategory",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
