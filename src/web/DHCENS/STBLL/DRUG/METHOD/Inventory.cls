Class web.DHCENS.STBLL.DRUG.METHOD.Inventory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lipan
/// CreatDate：2016—07-04
/// Description:库存信息
/// Table：
/// Input：<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><GetInventory><DeptCode>2001010101</DeptCode><DrugCode>Y00000004885</DrugCode></GetInventory></Body></Request>
/// Return：
/// Others: 
/// w ##class(web.DHCENS.STBLL.DRUG.METHOD.Inventory).GetInventory ()
ClassMethod GetInventory(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	
	set Response=##class(web.DHCENS.STBLL.DRUG.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.DRUG.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.DRUG.MODEL.GetInventory).%New()
	if $$$ISERR(tSC) {
		s responseBody.ResultCode=-1
		s responseBody.ResultContent="失败:"_tSC
		s Response.RespInventory=responseBody
    	d Response.XMLExportToStream(.stream)
    	q stream
	}else{
			set (DepCode,DrugCode)=""
			set HosCode="HNSRMYY"	
			set tSC=tDocument.EvaluateExpression("/Request/Body/GetInventory/DeptCode","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set DepCode=$tr(fieldValue,$c(0),"")
			}
			
			set tSC=tDocument.EvaluateExpression("/Request/Body/GetInventory/DrugCode","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set DrugCode=$tr(fieldValue,$c(0),"")
			}
	}  
	if DepCode=""{
		s responseBody.ResultCode=-1
		s responseBody.ResultContent="科室代码不能为空"
		s Response.RespInventory=responseBody
    	d Response.XMLExportToStream(.stream)
    	q stream
	}
	s DepDesc=""
	s DepRowid=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(DepCode),""))

	s:DepRowid'="" DepDesc=$p(^CTLOC(DepRowid),"^",2)
	if ((DepDesc="")) {		
		s responseBody.ResultCode=-1
		s responseBody.ResultContent="科室代码非法"
		s Response.RespInventory=responseBody
    	d Response.XMLExportToStream(.stream)
    	q stream
	}
	if ((DrugCode="")) {
		s responseBody.ResultCode=-1
		s responseBody.ResultContent="药品代码不能为空"
		s Response.RespInventory=responseBody
    	d Response.XMLExportToStream(.stream)
    	q stream
	}

	s qty=##class(web.DHCSTSTKQTY).CurPurQty(DrugCode,DepDesc,"")
	s InciRowId=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(DrugCode),""))
	s:InciRowId'="" DrugName=$p(^INCI(InciRowId,1),"^",2)
   	s responseBody.DepCode=DepCode
   	s responseBody.DrugCode=DrugCode
   	s responseBody.DrugName=DrugName
   	s responseBody.Qty=$p(qty,"^",1)
   	s responseBody.Unit=$p(qty,"^",2)
   	s responseBody.ResultCode=0
   	s responseBody.ResultContent="成功"
   	s Response.RespInventory=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	b ;2
	Quit stream
}

/// w ##class(web.DHCENS.STBLL.DRUG.METHOD.Inventory).test()
ClassMethod test() As %String
{
	s stre=##class(%GlobalCharacterStream).%New()
	;s Input="<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><GetInventory><DeptCode>2001010101</DeptCode><DrugCode>Y00000004885</DrugCode></GetInventory></Body></Request>"
	s Input="<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><GetInventory><DeptCode>2001010101</DeptCode><DrugCode>Y00000004885</DrugCode></GetInventory></Body></Request>"
	d stre.Write(Input)
	s string=..GetInventory(stre).Read()
	q string
}

}
