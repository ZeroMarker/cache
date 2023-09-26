Class web.DHCENS.STBLL.HIGHMATERIAL.METHOD.ConsumablesBarcode Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.HIGHMATERIAL.METHOD.ConsumablesBarcode).Test()
ClassMethod Test() As %String
{
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><ConsumablesBarcodeRt><MaterialCode>100023003</MaterialCode><MaterialBarcode>987654321</MaterialBarcode></ConsumablesBarcodeRt></Body></Request>")
	set sc=..ConsumablesBarcode(stream)
	Quit sc.Read()
}

/// Creator：WuXianPu
/// CreatDate：2016—07-29
/// Description：高值耗材条码信息接收
/// Table：
/// Input：
/// Return：
/// Others: 
ClassMethod ConsumablesBarcode(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	set Response=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set (MaterialCode,MaterialBarcode)=""
		set HosCode="HNSRMYY"	
		set tSC=tDocument.EvaluateExpression("/Request/Body/ConsumablesBarcodeRt/MaterialCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set MaterialCode=$tr(fieldValue,$c(0),"")
		}			
		set tSC=tDocument.EvaluateExpression("/Request/Body/ConsumablesBarcodeRt/MaterialBarcode","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set MaterialBarcode=$tr(fieldValue,$c(0),"")
		}	
		set ^TMPDHCENS("ConsumablesBarcode",+$h,MaterialCode,MaterialBarcode)=Input.Read()
		set return= ##class(web.DHCMaterialManager).InsertMaterialBarcode(MaterialCode,MaterialBarcode)
		set tSC=0
		if tSC="0" {
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"
		}
		else {
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent=tSC
		}
		set Response.Respbody=responseBody
	}   
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set Response=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Respbody).%New()
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze
	set Response.Respbody=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
}

}
