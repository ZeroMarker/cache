Class web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeChildCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：病案子类字典信息
/// Table：DHC_TarMRCate
/// Input： 
/// Return：病案子类信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeChildCategory).GetCTMRChargeChildCategory("")
ClassMethod GetCTMRChargeChildCategory(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTMRChargeChildCategoryByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018—11-03
/// Description：病案（子类）字典信息
/// Table：DHC_TarMRCate
/// Input： 
/// Return：病案（子类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeChildCategory).SendCTMRChargeChildCategory("")
ClassMethod SendCTMRChargeChildCategory(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^DHCTarC("MC",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetCTMRChargeChildCategoryByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_MRChargeChildCategory",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	
	if length>0 d
	.set Instream=..GetCTMRChargeChildCategoryByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_MRChargeChildCategory",tSC)
	
	//q "0" ;sc
#;	set length=plist.Count()
#;	if length>0 d
#;	.set Instream=..GetCTMRChargeChildCategoryByID(plist)
#;	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	.do tSC.OutputToDevice()
#;	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_MRChargeChildCategory",tSC)
#;	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018—11-03
/// Description：病案（子类）字典信息
/// Table：DHC_TarMRCate
/// Input： 
/// Return：病案（子类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeChildCategory).GetCTMRChargeChildCategory("")
ClassMethod GetCTMRChargeChildCategoryByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTMRChargeChildCategory).%New()
		continue:rowid=""
		;b ;-1
		set Str=$g(^DHCTarC("MC",rowid))
		;b ;00
		set LastDr=$p(Str,"^",3)
		;b ;01
		set Obj.businessrowid=rowid
		set Obj.CTMRCCCParentCode=LastDr //$p(^DHCTarC("TMC",LastDr),"^",1)
		set Obj.CTMRCCCCode=$p(Str,"^",1)
		set Obj.CTMRCCCDesc=$p(Str,"^",2)
		set Obj.CTMRCCCCodesystemCode="CT_MRChargeChildCategory"
		set Obj.CTMRCCCStartDate=""
		set Obj.CTMRCCCRemarks=""
		set Obj.CTMRCCCStatus="1"
		set Obj.CTMRCCCUpdateUserCode="无"
		set hospId=$o(^CT("HOSP","0")),hospCode=""
		set:hospId'="" hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
		set Obj.CTMRCCCHosCode=hospId //hospCode
		d ListInfo.CTMRChargeChildCategory.Insert(Obj)
		
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTMRChargeChildCategory",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_MRChargeChildCategory",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
