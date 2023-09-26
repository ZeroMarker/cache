Class web.DHCENS.STBLL.DICTNew.METHOD.CTOPChargeChildCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：门诊子类字典信息
/// Table：DHC_TarOutpatCate
/// Input： 
/// Return：门诊子类信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOPChargeChildCategory).GetCTOPChargeChildCategory("")
ClassMethod GetCTOPChargeChildCategory(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTOPChargeChildCategoryByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018—11-03
/// Description：门诊（子类）字典信息
/// Table：DHC_TarOutpatCate
/// Input： 
/// Return：门诊（子类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOPChargeChildCategory).SendCTOPChargeChildCategory("")
ClassMethod SendCTOPChargeChildCategory(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^DHCTarC("OC",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTOPChargeChildCategoryByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_OPChargeChildCategory",tSC)
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018—11-03
/// Description：门诊（子类）字典信息
/// Table：DHC_TarOutpatCate
/// Input： 
/// Return：门诊（子类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOPChargeChildCategory).GetCTOPChargeChildCategoryByID("")
ClassMethod GetCTOPChargeChildCategoryByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTOPChargeChildCategory).%New()
		set Str=$g(^DHCTarC("OC",rowid))
		set LastDr=$p(Str,"^",3)
		set Obj.businessrowid=rowid
		set Obj.CTOPCCCParentCode=LastDr //$p(^DHCTarC("TOC",LastDr),"^",1)
		set Obj.CTOPCCCCode=$p(Str,"^",1)
		set Obj.CTOPCCCDesc=$p(Str,"^",2)
		set Obj.CTOPCCCCodesystemCode="CT_OPChargeChildCategory"
		set Obj.CTOPCCCStartDate=""
		set Obj.CTOPCCCRemarks=""
		set Obj.CTOPCCCStatus="1"
		set Obj.CTOPCCCUpdateUserCode="无"
		set hospId=$o(^CT("HOSP","0")),hospCode=""
		set:hospId'="" hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
		set Obj.CTOPCCCHosCode=hospId //hospCode
		d ListInfo.CTOPChargeChildCategory.Insert(Obj)
		
	}
	set JsonStream=##class(%GlobalCharacterStream).%New()
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTOPChargeChildCategory",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_OPChargeChildCategory",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
