Class web.DHCENS.STBLL.DICTNew.METHOD.CTPharmacologyMinorCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—08-01
/// Description：药理学（子类）字典信息
/// Table：phc_subcat
/// Input： 
/// Return：药理学（子类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPharmacologyMinorCategory).CTPharmacologyChildCategory()
ClassMethod CTPharmacologyChildCategory(input As %String = "") As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICTNew.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICTNew.MODEL.Body).%New()
	
	set RowId=0 f  set RowId=$O(^PHCC(RowId)) q:RowId=""  d
	.set Str=$g(^PHCC(RowId))
	.Quit:$p(Str,"^",1)=""
	.set subId=0 f  set subId=$O(^PHCC(RowId,"SC",subId)) q:subId=""  d
	..Quit:((RowId_"||"_subId'=input)&&(input'=""))
	..set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPharmacologyCategory).%New()
	..set childStr=$g(^PHCC(RowId,"SC",subId))
	..Quit:$p(childStr,"^",1)=""
	..set Obj.CTPHCCCode=$p(childStr,"^",1)
	..set Obj.CTPHCCDesc=$p(childStr,"^",2)
	..set Obj.CTPHCCCodesystemCode="CT_PharmacologyCategory"
	..set Obj.CTPHCCRemarks=""
	..set Obj.CTPHCCStatus="1"
	..set Obj.CTPHCCUpdateUserCode="无"
	..set Obj.CTPHCCPharmacologyCategoryCode=$p(Str,"^",1)
	..d body.childPharmaCategorys.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_PHCCategory",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

/// Description：药理学（子类）字典信息
/// Table：phc_subcat
/// Input： 
/// Return：药理学（子类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPharmacologyMinorCategory).GetCTPharmacologyChildCategory()
ClassMethod GetCTPharmacologyChildCategory(input As %String = "") As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICTNew.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICTNew.MODEL.Body).%New()
	
	set RowId=0 f  set RowId=$O(^PHCC(RowId)) q:RowId=""  d
	.set Str=$g(^PHCC(RowId))
	.Quit:$p(Str,"^",1)=""
	.set subId=0 f  set subId=$O(^PHCC(RowId,"SC",subId)) q:subId=""  d
	..Quit:((RowId_"||"_subId'=input)&&(input'=""))
	..set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPharmacologyCategory).%New()
	..set childStr=$g(^PHCC(RowId,"SC",subId))
	..Quit:$p(childStr,"^",1)=""
	..set Obj.CTPHCCCode=$p(childStr,"^",1)
	..set Obj.CTPHCCDesc=$p(childStr,"^",2)
	..set Obj.CTPHCCCodesystemCode="CT_PharmacologyCategory"
	..set Obj.CTPHCCRemarks=""
	..w "why",!
	..set Obj.CTPHCCStatus="1"
	..set Obj.CTPHCCUpdateUserCode="无"
	..set Obj.CTPHCCPharmacologyCategoryCode=$p(Str,"^",1)
	..d body.childPharmaCategorys.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	
	Quit stream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018—08-01
/// Description：药理学（子类）字典信息
/// Table：phc_subcat
/// Input： 
/// Return：药理学（子类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPharmacologyMinorCategory).SendCTPharmacologyChildCategory()
ClassMethod SendCTPharmacologyChildCategory(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s sum=0
	s rowid=0 f  s rowid=$o(^PHCC(rowid)) q:(rowid="")||(sum=3)  d
	.set sum=sum+1
	.set Str=$g(^PHCC(rowid))
	.Quit:$p(Str,"^",1)=""
	.set subId=0 f  set subId=$O(^PHCC(rowid,"SC",subId)) q:subId=""  d
	..;Quit:((rowid_"||"_subId'=input)&&(input'=""))
	..set minId=0 f  set minId=$O(^PHCC(rowid,"SC",subId,"MIN",minId)) q:minId=""  do
	...Quit:((minId'=input)&&(input'=""))
	...d plist.SetAt(rowid_"||"_subId_"||"_minId,count)
	...s count=count+1
	...if count>0 d
	....set Instream=..GetCTPharmacologyChildCategoryByID(plist)
	....set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	....set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PHCCategory",tSC)
	....d tSC.OutputToDevice()
	....d Instream.Clear()
	....s count=1
	....d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTPharmacologyChildCategoryByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PHCCategory",tSC)
	q sc
Err
	q "-1^"_$ze
}

/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPharmacologyMinorCategory).GetCTPharmacologyChildCategoryByID()
ClassMethod GetCTPharmacologyChildCategoryByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPharmacologyCategory).%New()
		set ID=plist.GetAt(i)
		set rowid=$p(ID,"||",1),subId=$p(ID,"||",2),minId=$p(ID,"||",3)
		set minStr=$g(^PHCC(rowid,"SC",subId,"MIN",minId))
		;Quit:$p(childStr,"^",1)=""
		set Obj.CTPHCCCode=$p(minStr,"^",1)
		set Obj.CTPHCCDesc=$p(minStr,"^",2)
		set Obj.CTPHCCCodesystemCode="CT_PHCCategory"
		set Obj.CTPHCCRemarks=""
		w "01",!
		set Obj.CTPHCCStatus="1"
		w "02",!
		set Obj.CTPHCCUpdateUserCode="无"
		//set Obj.CTPHCCParentCode=$p(childStr,"^",1)
		set pStr=$g(^PHCC(rowid,"SC",subId))
		set Obj.CTPHCCParentCode=$p(pStr,"^",1)
		//set Obj.CTPHCCParentCode=rowid
		
		d ListInfo.CTPHCCategory.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPHCCategory",.Jsonobj)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_PHCCategory",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
