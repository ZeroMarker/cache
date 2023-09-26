Class web.DHCENS.STBLL.DICTNew.METHOD.CTCostCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-13
/// Description：患者费别字典信息
/// Table：PAC_AdmReason
/// Input： 
/// Return：患者费别信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCostCategory).GetCTCostCategory("")
ClassMethod GetCTCostCategory(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTCostCategoryByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018-11-13
/// Description：患者费别字典信息
/// Table：PAC_AdmReason
/// Input： 
/// Return：患者费别信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCostCategory).SendCTCostCategory("")
ClassMethod SendCTCostCategory(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^PAC("ADMREA",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetCTCostCategoryByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CostCategory",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTCostCategoryByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CostCategory",tSC)
	
	q "0" ;sc
#;	set Instream=..GetCTCostCategoryByID(plist)
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-13
/// Description：患者费别字典信息
/// Table：PAC_AdmReason
/// Input： 
/// Return：患者费别信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCostCategory).GetCTCostCategory("")
ClassMethod GetCTCostCategoryByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCostCategory).%New()
		set Str=$g(^PAC("ADMREA",rowid))
		set Obj.businessrowid=rowid
		set Obj.CTCCCode=$p(Str,"^",1)
		set Obj.CTCCDesc=$p(Str,"^",2)
		set Obj.CTCCStartDate=$p(Str,"^",3)
		set EndDate=$p(Str,"^",4)
		set Obj.CTCCEndDate=$p(Str,"^",4)
		set Obj.CTCCCodesystemCode="CT_CostCategory"
		set Obj.CTCCRemarks=""
		set Obj.CTCCStatus="1"
		set Obj.CTCCUpdateUserCode="无"
		d ListInfo.CTCostCategory.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCostCategory",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_CostCategory",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
