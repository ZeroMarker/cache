Class web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeChildCategoryNew Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：ZhangXinying
/// CreatDate：2018-09-06
/// Description：新病案子类信息
/// Table：
/// Input： 
/// Return：新病案子类信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeChildCategoryNew).GetCTMRChargeChildCategoryNew("1").Read()
ClassMethod GetCTMRChargeChildCategoryNew(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTMRChargeChildCategoryNewByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018-09-06
/// Description：新病案（子类）信息
/// Table：
/// Input： 
/// Return：新病案（子类）信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeChildCategoryNew).SendCTMRChargeChildCategoryNew("")
ClassMethod SendCTMRChargeChildCategoryNew(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^DHCTarC("MCNew",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTMRChargeChildCategoryNewByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_MRChargeChildCategoryNew",tSC)
	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2018-09-06
/// Description：新病案（子类）信息
/// Table：
/// Input： 
/// Return：新病案（子类）信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeChildCategoryNew).GetCTMRChargeChildCategoryNewByID("")
ClassMethod GetCTMRChargeChildCategoryNewByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTMRChargeChildCategoryNew).%New()
		set Str=$g(^DHCTarC("MCNew",rowid))
		set LastDr=$p(Str,"^",3)
		set Obj.businessrowid=rowid
		set Obj.CTMRCCCNParentCode=LastDr //$p(^DHCTarC("TMCNew",LastDr),"^",1)
		set Obj.CTMRCCCNCode=$p(Str,"^",1)
		set Obj.CTMRCCCNDesc=$p(Str,"^",2)
		set Obj.CTMRCCCNCodesystemCode="CT_MRChargeChildCategoryNew"
		set Obj.CTMRCCCNStartDate=""
		set Obj.CTMRCCCNRemarks=""
		set Obj.CTMRCCCNStatus="1"
		set Obj.CTMRCCCNUpdateUserCode="无"
		set hospId=$o(^CT("HOSP","0")),hospCode=""
		set:hospId'="" hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
		set Obj.CTMRCCCNHosCode=hospId //hospCode
		d ListInfo.CTMRChargeChildCategoryNew.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTMRChargeChildCategoryNew",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_MRChargeChildCategoryNew",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
