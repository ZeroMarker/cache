/// 住院子类
Class web.DHCENS.STBLL.DICTNew.METHOD.CTIPChargeChildCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：住院子类字典信息
/// Table：DHC_TarInpatCate
/// Input： 
/// Return：住院子类信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTIPChargeChildCategory).GetCTIPChargeChildCategory("1").Read()
ClassMethod GetCTIPChargeChildCategory(Input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
		}
	if pList.Count()>0{
		set OutputStream=..GetCTIPChargeChildCategoryByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018—11-03
/// Description：住院（子类）字典信息
/// Table：DHC_TarInpatCate
/// Input： 
/// Return：住院（子类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTIPChargeChildCategory).SendCTIPChargeChildCategory("")
ClassMethod SendCTIPChargeChildCategory(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^DHCTarC("IC",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>200 d
	..set Instream=..GetCTIPChargeChildCategoryByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_IPChargeChildCategory",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTIPChargeChildCategoryByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_IPChargeChildCategory",tSC)
	q sc
#;	set length=plist.Count()
#;	if length>0 d
#;	.set Instream=..GetCTIPChargeChildCategoryByID(plist)
#;	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	.do tSC.OutputToDevice()
#;	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_IPChargeChildCategory",tSC)
#;	
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018—11-03
/// Description：住院（子类）字典信息
/// Table：DHC_TarInpatCate
/// Input： 
/// Return：住院（子类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTIPChargeChildCategory).GetCTIPChargeChildCategory("")
ClassMethod GetCTIPChargeChildCategoryByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTIPChargeChildCategory).%New()
		set Str=$g(^DHCTarC("IC",rowid))
		set LastDr=$p(Str,"^",3)
		set Obj.businessrowid=rowid
		set Obj.CTIPCCCParentCode=LastDr //$p(^DHCTarC("TIC",LastDr),"^",1)
		set Obj.CTIPCCCCode=$p(Str,"^",1)
		set Obj.CTIPCCCDesc=$p(Str,"^",2)
		set Obj.CTIPCCCCodesystemCode="CT_IPChargeChildCategory"
		set Obj.CTIPCCCStartDate=""
		set Obj.CTIPCCCRemarks=""
		set Obj.CTIPCCCStatus="1"
		set Obj.CTIPCCCUpdateUserCode="无"
		set hospId=$o(^CT("HOSP","0")),hospCode=""
		set:hospId'="" hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
		set Obj.CTIPCCCHosCode=hospId //hospCode
		d ListInfo.CTIPChargeChildCategory.Insert(Obj)	
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTIPChargeChildCategory",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_IPChargeChildCategory",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
