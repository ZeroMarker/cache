Class web.DHCENS.STBLL.DICTNew.METHOD.CTStockCategorySubGroup Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018-09-06
/// Description：库存分类子类信息
/// Table： INC_StkCat
/// Input： 
/// Return：
/// Others：set a= ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStockCategorySubGroup).GetCTStkCatSubGrp("1").Read()
ClassMethod GetCTStockCategorySubGroup(Input As %String = "") As %GlobalCharacterStream
{
	set $zt="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
	}
	if pList.Count()>0{
		b ;-1
		set OutputStream=..GetCTStockCategorySubGroupByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回库存分类字典密文流
/// Table：INC_StkCat
/// Input： Array集合
/// Return：库存分类字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStockCategorySubGroup).GetCTStkCatSubGrpByID()
ClassMethod GetCTStockCategorySubGroupByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTStockCategorySubGroup).%New()
		set scgId=+rowid,scgSubId=$p(rowid,"||",2)
		q:scgSubId=""
		set stkCatDr=$p($g(^DHCSCG(scgId,"RE",scgSubId)),"^",1)
		q:stkCatDr=""
		q:$d(^INC("SC",stkCatDr))=0
		set Obj.businessrowid=stkCatDr
		set Obj.CTSCSGCode=$p($g(^INC("SC",stkCatDr)),"^",1)
		set Obj.CTSCSGCodesystemCode="CT_StockCategorySubGroup"
		set Obj.CTSCSGDesc=$p($g(^INC("SC",stkCatDr)),"^",2)
		set Obj.CTSCSGGroupCode=scgId //$P($G(^DHCSCG(scgId)),"^",1)
		set Obj.CTSCSGRemarks=""
		set Obj.CTSCSGStatus="1"
		set Obj.CTSCSGUpdateUserCode="无"
		set hospId=$o(^CT("HOSP","0"))
		set hospCode=$p(^CT("HOSP",hospId),"^",1)	
		set Obj.CTSCSGHosCode=hospId //hospCode
		d ListInfo.CTStockCategorySubGroup.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTStockCategorySubGroup",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_StockCategorySubGroup",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送库存分类字典
/// Table：INC_StkCat
/// Input： 
/// Return：库存分类字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStockCategorySubGroup).SendCTStkCatSubGrp("")
ClassMethod SendCTStkCatSubGrp(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1,sc=""
	s scgId=0 f  s scgId=$o(^DHCSCG(scgId)) q:scgId=""  d
	
	.set scgSubId=""  for  set scgSubId=$o(^DHCSCG(scgId,"RE",scgSubId)) 	q:scgSubId=""  d
	..q:$d(^INC("SC",scgSubId))=0
	..set rowid=scgId_"||"_scgSubId
	..d plist.SetAt(rowid,count)
	..s count=count+1
	..if count>50 d
	...set Instream=..GetCTStockCategorySubGroupByID(plist)
	...set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	...set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_StockCategorySubGroup",tSC)
	...d tSC.OutputToDevice()
	...d Instream.Clear()
	...s count=1
	...d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTStockCategorySubGroupByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_StockCategorySubGroup",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
