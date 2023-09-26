Class web.DHCENS.STBLL.DICTNew.METHOD.CTPEItem Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description：体检项目字典信息
/// Table：DHC_PE_StationOrder
/// Input： 
/// Return：体检项目字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPEItem).GetCTPEItem("1||2").Read()
ClassMethod GetCTPEItem(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTPEItemByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回体检项目字典密文流
/// Table：
/// Input： Array集合
/// Return：体检项目字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPEItem).GetCTPEItemByID()
ClassMethod GetCTPEItemByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set Id=$p(rowid,"||",1),SubId=$p(rowid,"||",2)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPEItem).%New()
		set Str=$g(^DHCPEST(Id,"O",SubId))
		set ArcimDr=$p(Str,"^",1)
		set ArmSub=$p(ArcimDr,"||",1),ArmVer=$p(ArcimDr,"||",2)
		set Obj.businessrowid=rowid
		set Obj.CTPEICode=$p($g(^ARCIM(ArmSub,ArmVer,1)),"^",1)
		set Obj.CTPEIDesc=$p($g(^ARCIM(ArmSub,ArmVer,1)),"^",2)
		set Obj.CTPEICodesystemCode="CT_PEItem"
		set Obj.CTPEIRemarks=""
		set Obj.CTPEIStatus="1"
		set Obj.CTPEIUpdateUserCode="无"
		set hospId=$o(^CT("HOSP","0")),hospCode=""
		set:hospId'="" hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
		set Obj.CTPEIHosCode=hospId //hospCode
		d ListInfo.CTPEItem.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPEItem",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_PEItem",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送体检项目字典
/// Table：
/// Input： 
/// Return：体检项目字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPEItem).SendCTPEItem("")
ClassMethod SendCTPEItem(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s StRowId="" f  s StRowId=$o(^DHCPEST(StRowId)) q:StRowId=""  d
	.s StOrdChildSub="0" f  s StOrdChildSub=$o(^DHCPEST(StRowId,"O",StOrdChildSub)) q:StOrdChildSub=""  d
	..s rowid=StRowId_"||"_StOrdChildSub
	..d plist.SetAt(rowid,count)
	..s count=count+1
	..if count>50 d
	...set Instream=..GetCTPEItemByID(plist)
	...set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	...set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PEItem",tSC)
	...d tSC.OutputToDevice()
	...d Instream.Clear()
	...s count=1
	...d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTPEItemByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PEItem",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
