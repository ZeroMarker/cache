Class web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeCategoryNew Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：ZhangXinying
/// CreatDate：2018-09-06
/// Description：新病案大类字典信息
/// Table：
/// Input： 
/// Return：新病案大类信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeCategoryNew).GetCTMRChargeCategoryNew("1").Read()
ClassMethod GetCTMRChargeCategoryNew(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTMRChargeCategoryNewByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018-09-06
/// Description：新病案（大类）信息
/// Table：
/// Input： 
/// Return：新病案（大类）信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeCategoryNew).SendCTMRChargeCategoryNew("")
ClassMethod SendCTMRChargeCategoryNew(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^DHCTarC("TMCNew",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTMRChargeCategoryNewByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_MRChargeCategoryNew",tSC)
	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2018-09-06
/// Description：新病案（大类）信息
/// Table：
/// Input： 
/// Return：新病案（大类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeCategoryNew).GetCTMRChargeCategoryNewByID("")
ClassMethod GetCTMRChargeCategoryNewByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTMRChargeCategoryNew).%New()
		set Str=$g(^DHCTarC("TMCNew",rowid))
		set Obj.businessrowid=rowid
		set Obj.CTMRCCNCode=$p(Str,"^",1)
		set Obj.CTMRCCNDesc=$p(Str,"^",2)
		set Obj.CTMRCCNCodesystemCode="CT_MRChargeCategoryNew"
		set Obj.CTMRCCNStartDate=""
		set Obj.CTMRCCNRemarks=""
		set Obj.CTMRCCNStatus="1"
		set Obj.CTMRCCNUpdateUserCode="无"
		set hospId=$o(^CT("HOSP","0")),hospCode=""
		set:hospId'="" hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
		set Obj.CTMRCCNHosCode=hospId //hospCode
		d ListInfo.CTMRChargeCategoryNew.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	;b ;;;String
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTMRChargeCategoryNew",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	;b ;;; JsonString,!
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_MRChargeCategoryNew",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
