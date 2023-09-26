Class web.DHCENS.STBLL.DICTNew.METHOD.CTBillCat Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：获取账单大类项字典信息
/// Table：CT_BillCat
/// Input： 
/// Return：账单大类字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBillCat).GetCTBillCat("1").Read()
ClassMethod GetCTBillCat(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTBillCatByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：推送账单大类项字典信息
/// Table：CT_BillCat
/// Input： 
/// Return：
/// Others: 
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBillCat).SendCTBillCat("")
ClassMethod SendCTBillCat(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^ARCBG(rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 do
	..set Instream=..GetCTBillCatByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_BillCat",tSC)
	..do tSC.OutputToDevice()
	..do Instream.Clear()
	..set count=1
	..do plist.Clear()
	;set stream=..GetHospitalByID(plist)
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTBillCatByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_BillCat",tSC)
	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

ClassMethod GetCTBillCatByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTBillCat).%New()
		set str=$g(^ARCBG(rowid))
		q:str=""
		set Obj.businessrowid=rowid
		set Obj.CTBCCode=$p(str,"^",1)
		set Obj.CTBCDesc=$p(str,"^",2)
		set Obj.CTBCCodesystemCode="CT_BillCat"
		set Obj.CTBCUpdateUserCode="无"
		set Obj.CTBCStatus=1
		set Obj.CTBCRemarks="无"
		do ListInfo.CTBillCat.Insert(Obj)
		set count=ListInfo.CTBillCat.Count()
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()	
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTBillCat",.Jsonobj)

	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_BillCat",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
