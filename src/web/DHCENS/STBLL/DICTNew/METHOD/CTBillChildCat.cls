Class web.DHCENS.STBLL.DICTNew.METHOD.CTBillChildCat Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：账单子类项字典信息
/// Table：CT_BillChildCat
/// Input： 
/// Return：账单子类信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBillChildCat).GetCTBillChildCat("1||1").Read()
ClassMethod GetCTBillChildCat(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTBillChildCatByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBillChildCat).SendCTBillChildCat("")
ClassMethod SendCTBillChildCat(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set ArcId="0"  for  set ArcId=$o(^ARCBG(ArcId)) Quit:ArcId=""  d
	.set SubId="0"
	.for  set SubId=$o(^ARCBG(ArcId,"SG",SubId)) Quit:SubId=""  d
	..set rowid=ArcId_"||"_SubId
	..do plist.SetAt(rowid,count)
	..set count=count+1
	..;w !,rowid_","_count_","_$g(^ARCBG(ArcId,"SG",SubId))
	..if count>100 do
	...set Instream=..GetCTBillChildCatByID(plist)
	...set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	...set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_BillChildCat",tSC)
	...do tSC.OutputToDevice()
	...do Instream.Clear()
	...;set count=1
	...do plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTBillChildCatByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_BillChildCat",tSC)
	.b ;
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

ClassMethod GetCTBillChildCatByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:count
	{
		set rowid=pList.GetAt(i)
		set ArcbgId=+rowid,SubId=$p(rowid,"||",2)
		set str=$g(^ARCBG(ArcbgId,"SG",SubId))
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTBillChildCat).%New()
		set Obj.businessrowid=rowid ;SubId
		set Obj.CTBCCCode=$p(str,"^",1)
		set Obj.CTBCCCodesystemCode="CT_BillChildCat"
		set Obj.CTBCCDesc=$p(str,"^",2)
		set Obj.CTBCCRemarks="无"
		set Obj.CTBCCStatus=1
		set Obj.CTBCCBillCategory=ArcbgId //$p(^ARCBG(ArcbgId),"^",2)
		do ListInfo.CTBillChildCat.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTBillChildCat",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_BillChildCat",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
