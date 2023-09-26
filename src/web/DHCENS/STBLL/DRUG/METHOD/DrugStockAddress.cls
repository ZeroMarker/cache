Class web.DHCENS.STBLL.DRUG.METHOD.DrugStockAddress Extends (%RegisteredObject, %XML.Adaptor)
{

// w ##class(web.DHCENS.STBLL.DRUG.METHOD.DrugStockAddress).SendStockPosition()

ClassMethod SendStockPosition() As %String
{
	set soapOb=##class(web.DHCENS.STBLL.DRUG.SOAP.PUB0013Soap).%New()
	set stream=##class(%GlobalCharacterStream).%New()
	//门急诊
	set locRowId=""  for  set locRowId=$o(^DHCPHLOC(locRowId)) q:locRowId=""  d
	.set reclocdr=$p($g(^DHCPHLOC(locRowId)),"^",1)
	.q:reclocdr=""
	.set DeptCode=$p($g(^CTLOC(reclocdr)),"^",1)
	.set DeptDesc=$p($g(^CTLOC(reclocdr)),"^",2)
	.set inci="" for  set inci=$o(^INCI("IL_LOC",reclocdr,inci)) q:inci=""  d
	..set incilch=$o(^INCI("IL_LOC",reclocdr,inci,"")) 
	..q:incilch="" 
 	..set address=##class(web.DHCSTCOMMONSRV).getIncStk(inci_"||"_incilch)
 	..q:address=""
	..set DrugCode=$p($g(^INCI(inci,1)),"^",1)
	..set DrugDesc=$p($g(^INCI(inci,1)),"^",2)
	..set tmpStr=address_"||"_DrugCode_"||"_DrugDesc_"||"_DeptCode_"||"_DrugDesc
	..d stream.Write("<Request><header><SourceSystem>HIS</SourceSystem><MessageID>9143</MessageID></header><Body><DrugStockAddressList><DrugStockAddress><DeptCode>"_tmpStr_"</DeptCode><DeptDesc>门诊药房</DeptDesc><DrugCode>Y00000000011</DrugCode><DrugDesc></DrugDesc><Address>货位一</Address></DrugStockAddress></DrugStockAddressList></Body></Request>")
	..set result=soapOb.recieveStockAddress("T0050",stream)
	..;b ;44
	..d stream.Rewind()
	
		//住院
	set locRowId=""  for  set locRowId=$o(^DHCPL(locRowId)) q:locRowId=""  d
	.set reclocdr=$p($g(^DHCPL(locRowId)),"^",1)
	.q:reclocdr=""
	.set DeptCode=$p($g(^CTLOC(reclocdr)),"^",1)
	.set DeptDesc=$p($g(^CTLOC(reclocdr)),"^",2)
	.set inci="" for  set inci=$o(^INCI("IL_LOC",reclocdr,inci)) q:inci=""  d
	..set incilch=$o(^INCI("IL_LOC",reclocdr,inci,"")) 
	..q:incilch="" 
 	..set address=##class(web.DHCSTCOMMONSRV).getIncStk(inci_"||"_incilch)
 	..q:address=""
 	..set DrugCode=$p($g(^INCI(inci,1)),"^",1)
	..set DrugDesc=$p($g(^INCI(inci,1)),"^",2)
	..set tmpStr=address_"||"_DrugCode_"||"_DrugDesc_"||"_DeptCode_"||"_DrugDesc
	..d stream.Write("<Request><header><SourceSystem>HIS</SourceSystem><MessageID>9143</MessageID></header><Body><DrugStockAddressList><DrugStockAddress><DeptCode>"_tmpStr_"</DeptCode><DeptDesc>门诊药房</DeptDesc><DrugCode>Y00000000011</DrugCode><DrugDesc></DrugDesc><Address>货位一</Address></DrugStockAddress></DrugStockAddressList></Body></Request>")
	..set result=soapOb.recieveStockAddress("T0050",stream)
	..d stream.Rewind()
	
	q result.Read()
}

/// 处方信息货位
/// s stream=##class(web.DHCENS.STBLL.DRUG.METHOD.DrugStockAddress).DrugStockAddress()
ClassMethod DrugStockAddress(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DRUG.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.DRUG.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set request.header=header
	set success="0"
	set body=##class(web.DHCENS.STBLL.DRUG.MODEL.Body).%New()
	set addrObj=##class(web.DHCENS.STBLL.DRUG.MODEL.DrugStockAddress).%New()
	set addrObj.Address=$p(Input,"||",1)
	set addrObj.DrugCode=$p(Input,"||",2)
	set addrObj.DrugDesc=$p(Input,"||",3)
	set addrObj.DeptCode=$p(Input,"||",4)
	set addrObj.DeptDesc=$p(Input,"||",5)
	set addrObj.TypeCode=0  //门急诊
	d body.addrList.Insert(addrObj)
	
	set request.body=body
	d request.XMLExportToStream(.stream)
	
	q stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
