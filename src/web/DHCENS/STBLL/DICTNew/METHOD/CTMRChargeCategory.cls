Class web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：病案大类字典信息
/// Table：DHC_TarMC
/// Input： 
/// Return：病案大类信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeCategory).GetCTMRChargeCategory("")
ClassMethod GetCTMRChargeCategory(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTMRChargeCategoryByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018—11-03
/// Description：病案（大类）字典信息
/// Table：DHC_TarMC
/// Input： 
/// Return：病案（大类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeCategory).SendCTMRChargeCategory("")
ClassMethod SendCTMRChargeCategory(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^DHCTarC("TMC",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTMRChargeCategoryByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_MRChargeCategory",tSC)
	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018—11-03
/// Description：病案（大类）字典信息
/// Table：DHC_TarMC
/// Input： 
/// Return：病案（大类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeCategory).GetCTMRChargeCategoryByID("")
ClassMethod GetCTMRChargeCategoryByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTMRChargeCategory).%New()
		set Str=$g(^DHCTarC("TMC",rowid))
		set Obj.businessrowid=rowid
		set Obj.CTMRCCCode=$p(Str,"^",1)
		set Obj.CTMRCCDesc=$p(Str,"^",2)
		set Obj.CTMRCCCodesystemCode="CT_MRChargeCategory"
		set Obj.CTMRCCStartDate=""
		set Obj.CTMRCCRemarks=""
		set Obj.CTMRCCStatus="1"
		set Obj.CTMRCCUpdateUserCode="无"
		set hospId=$o(^CT("HOSP","0")),hospCode=""
		set:hospId'="" hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
		set Obj.CTMRCCHosCode=hospId //hospCode
		d ListInfo.CTMRChargeCategory.Insert(Obj)
		
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTMRChargeCategory",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_MRChargeCategory",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
