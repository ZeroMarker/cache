/// 会计子类
Class web.DHCENS.STBLL.DICTNew.METHOD.CTACChargeChildCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：会计子类字典信息
/// Table：DHC_TarAcctCate
/// Input： 
/// Return：会计子类信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTACChargeChildCategory).GetCTACChargeChildCategory("")
ClassMethod GetCTACChargeChildCategory(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTACChargeChildCategoryByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018—11-03
/// Description：会计（子类）字典信息
/// Table：DHC_TarAcctCate
/// Input： 
/// Return：会计（子类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTACChargeChildCategory).SendCTACChargeChildCategory("")
ClassMethod SendCTACChargeChildCategory(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^DHCTarC("AC",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>20 d
	..set Instream=..GetCTACChargeChildCategoryByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ACChargeChildCategory",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTACChargeChildCategoryByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)	
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ACChargeChildCategory",tSC)
	.d tSC.OutputToDevice()
	q sc
#;	set length=plist.Count()
#;	if length>0 d
#;	.set Instream=..GetCTACChargeChildCategoryByID(plist)
#;	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	.do tSC.OutputToDevice()
#;	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ACChargeChildCategory",tSC)
#;	
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018—11-03
/// Description：会计（子类）字典信息
/// Table：DHC_TarAcctCate
/// Input： 
/// Return：会计（子类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTACChargeCategory).GetCTACChargeChildCategoryByID("")
ClassMethod GetCTACChargeChildCategoryByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTACChargeChildCategory).%New()
		set Str=$g(^DHCTarC("AC",rowid))
		set LastDr=$p(Str,"^",3)
		set Obj.businessrowid=rowid
		set Obj.CTACCCCParentCode=LastDr   //$p(^DHCTarC("TAC",LastDr),"^",1)
		set Obj.CTACCCCCode=$p(Str,"^",1)
		set Obj.CTACCCCDesc=$p(Str,"^",2)
		set Obj.CTACCCCCodesystemCode="CT_ACChargeChildCategory"
		set Obj.CTACCCCStartDate=""
		set Obj.CTACCCCRemarks=""
		set Obj.CTACCCCStatus="1"
		set Obj.CTACCCCUpdateUserCode="无"
		set hospId=$o(^CT("HOSP","0")),hospCode=""
		set:hospId'="" hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
		set Obj.CTACCCCHosCode=hospCode
		d ListInfo.CTACChargeChildCategory.Insert(Obj)
		
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTACChargeChildCategory",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ACChargeChildCategory",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
