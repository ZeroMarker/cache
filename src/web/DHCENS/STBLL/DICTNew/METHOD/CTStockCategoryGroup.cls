Class web.DHCENS.STBLL.DICTNew.METHOD.CTStockCategoryGroup Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018-09-06
/// Description：库存类组信息
/// Table： DHC_StkCatGroup
/// Input： 
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStockCategoryGroup).GetCTStkCatGrp("1").Read()
ClassMethod GetCTStkCatGrp(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTStkCatGrpByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回库存类组字典密文流
/// Table：DHC_StkCatGroup
/// Input： Array集合
/// Return：库存类组字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStockCategoryGroup).GetCTStkCatGrpByID()
ClassMethod GetCTStkCatGrpByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTStockCategoryGroup).%New()
		set Str=$g(^DHCSCG(rowid))
		q:Str=""
		set Obj.businessrowid=rowid
		set Obj.CTSCGCode=$P($G(^DHCSCG(rowid)),"^",1)
		set Obj.CTSCGCodesystemCode="CT_StockCategoryGroup"
		set Obj.CTSCGDesc=$P($G(^DHCSCG(rowid)),"^",2)
		set SCGType=$P($G(^DHCSCG(rowid)),"^",3)
		set Obj.CTSCGType=$case(SCGType,"G":"药品","M":"材料",:"其他")
		set Obj.CTSCGRemarks=""
		set Obj.CTSCGStatus="1"
		set Obj.CTSCGUpdateUserCode="无"
		set hospId=$o(^CT("HOSP","0"))
		set hospCode=$p(^CT("HOSP",hospId),"^",1)	
		set Obj.CTSCGHosCode=hospId //hospCode
		do ListInfo.CTStockCategoryGroup.Insert(Obj)
	
	}
	d ListInfo.XMLExportToString(.String)

	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTStockCategoryGroup",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_StockCategoryGroup",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送库存类组字典
/// Table：DHC_StkCatGroup
/// Input： 
/// Return：库存类组字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStockCategoryGroup).SendCTStkCatGrp("")
ClassMethod SendCTStkCatGrp(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^DHCSCG(rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>50 d
	..set Instream=..GetCTStkCatGrpByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_StockCategoryGroup",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTStkCatGrpByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_StockCategoryGroup",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
