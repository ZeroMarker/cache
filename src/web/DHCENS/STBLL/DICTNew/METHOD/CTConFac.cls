Class web.DHCENS.STBLL.DICTNew.METHOD.CTConFac Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description：药品转换系数字典信息
/// Table：CT_ConFac
/// Input： 
/// Return：药品转换系数字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTConFac).GetCTConFac("277").Read()
ClassMethod GetCTConFac(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTConFacByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回产地字典密文流
/// Table：
/// Input： Array集合
/// Return：产地字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTConFac).GetCTConFacByID()
ClassMethod GetCTConFacByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTConFac).%New()
		set Str=$g(^CT("CTCF",rowid))
		set Obj.businessrowid=rowid
		set FrUomDr=$p(Str,"^",1)
		set ToUomDr=$p(Str,"^",2)
		set:FrUomDr'="" Obj.CTPHCFCode=FrUomDr //$p($g(^CT("UOM",FrUomDr)),"^",1)
		set:ToUomDr'="" Obj.CTPHCFTargetCode=ToUomDr //$p($g(^CT("UOM",ToUomDr)),"^",1)
		if (Obj.CTPHCFTargetCode=""){
			b ;1
		}
		set Obj.CTPHCFLinkId=rowid
		set Obj.CTPHCFFactor=$p(Str,"^",3)
		set Obj.CTPHCFCodesystemCode="CT_PHConversionFactor"
		set Obj.CTPHCFRemarks=""
		set Obj.CTPHCFStatus="1"
		set Obj.CTPHCFUpdateUserCode="无"
		d ListInfo.CTPHConversionFactor.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPHConversionFactor",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_PHConversionFactor",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送药品转换系数字典
/// Table：
/// Input： 药品转换系数字典
/// Return：药品转换系数字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTConFac).SendCTConFac("")
ClassMethod SendCTConFac(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1,myCount=0
	s rowid=0 f  s rowid=$o(^CT("CTCF",rowid)) q:(rowid="")  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.s myCount=myCount+1
	.if count>50 d
	..set Instream=..GetCTConFacByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PHConversionFactor",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTConFacByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PHConversionFactor",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
