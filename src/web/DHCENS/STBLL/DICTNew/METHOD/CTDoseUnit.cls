Class web.DHCENS.STBLL.DICTNew.METHOD.CTDoseUnit Extends (%RegisteredObject, %XML.Adaptor)
{

/// MDM初始化批量导入数据
/// Creator：luofanyu
/// CreatDate：2018—11-01
/// Description：剂量单位字典信息
/// Table：CT_UOM
/// Input： 
/// Return：剂量单位字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDoseUnit).SendCTDoseUnit("")
ClassMethod SendCTDoseUnit(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("UOM",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>200 do
	..set Instream=..GetCTDoseUnitByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_DoseUnit",tSC)
	..do tSC.OutputToDevice()
	..do Instream.Clear()
	..set count=1
	..do plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTDoseUnitByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_DoseUnit",tSC)
	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018—11-01
/// Description：剂量单位字典信息
/// Table：CT_UOM
/// Input： 
/// Return：剂量单位字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDoseUnit).GetCTDoseUnitByID("")
ClassMethod GetCTDoseUnitByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Str=$g(^CT("UOM",rowid))
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDoseUnit).%New()
		set Obj.CTDUCode=$p(Str,"^",1)
		set Obj.businessrowid = rowid
		set Obj.CTDUDesc=$p(Str,"^",2)
		set Obj.CTDUCodesystemCode="CT_PHUnit"
		set Obj.CTDURemarks=""
		set Obj.CTDUStatus="1"
		set Obj.CTDUUpdateUserCode="无"
		d ListInfo.CTDoseUnit.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDoseUnit",.Jsonobj)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DoseUnit",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：WuXianPu
/// CreatDate：2012—11-10
/// Description：剂量单位字典信息
/// Table：CT_UOM
/// Input： 
/// Return：剂量单位字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDoseUnit).CTDoseUnit("")
ClassMethod CTDoseUnit(input As %String) As %String
{
	set $zt="MsgErr"
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set RowId=0 f  set RowId=$O(^CT("UOM",RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDoseUnit).%New()
	.set Str=$g(^CT("UOM",RowId))
	.set Obj.CTDUCode=$p(Str,"^",1)
	.set Obj.CTDUDesc=$p(Str,"^",2)
	.set Obj.CTDUCodesystemCode="CT_PHUnit"
	.set Obj.CTDURemarks=""
	.set Obj.CTDUStatus="1"
	.set Obj.CTDUUpdateUserCode="无"
	.d ListInfo.CTDoseUnit.Insert(Obj)
	.set count=ListInfo.CTDoseUnit.Count()
	.if count>100 d
	..d ListInfo.XMLExportToString(.String)
	..set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDoseUnit",.Jsonobj)
	..set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	..set JsonString=$tr(JsonString,$c(13),"")
	..set JsonString=$tr(JsonString,$c(10),"")
	..set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DoseUnit",JsonString)
	..d ListInfo.CTDoseUnit.Clear()
	..set count=0
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode=0 d
	...set success=0
	..else  d
	...set success=-1
	if (count>0){
		d ListInfo.XMLExportToString(.String)
		set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDoseUnit",.Jsonobj)
		set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
		set JsonString=$tr(JsonString,$c(13),"")
		set JsonString=$tr(JsonString,$c(10),"")
		set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DoseUnit",JsonString)
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode=0 d
		.set success=0
		else  d
		.set success=-1
	}
	quit success
		
MsgErr
	quit "-1"_$ze
}

}
