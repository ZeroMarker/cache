Class web.DHCENS.STBLL.PIVAS.METHOD.OrdNurExeItem Extends (%RegisteredObject, %XML.Adaptor)
{

// 配液-发送医嘱执行记录

// w ##class(web.DHCENS.STBLL.PIVAS.METHOD.OrdNurExeItem).GetOrdNurExeItemInfo("1375||167||16").Read()

ClassMethod GetOrdNurExeItemInfo(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.PIVAS.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.PIVAS.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.PIVAS.MODEL.Body).%New()
	set OrderNurExecuteObj=##class(web.DHCENS.STBLL.PIVAS.MODEL.OrdNurExeItemInfo).%New()
	s OrderNurExeInfo=##class(PHA.FACE.TPS.PIVASKLD).GetOeoreInfo(Input)
	s OrderNurExecuteObj.recLocCode=$P(OrderNurExeInfo,"^",1)
	s OrderNurExecuteObj.recLocDesc=$P(OrderNurExeInfo,"^",2)
	s OrderNurExecuteObj.addDateTime=$P(OrderNurExeInfo,"^",3)
	s OrderNurExecuteObj.patNo=$P(OrderNurExeInfo,"^",4)
	s OrderNurExecuteObj.patName=$P(OrderNurExeInfo,"^",5)
	s OrderNurExecuteObj.admId=$P(OrderNurExeInfo,"^",6)
	s OrderNurExecuteObj.wardLocCode=$P(OrderNurExeInfo,"^",7)
	s OrderNurExecuteObj.wardLocDesc=$P(OrderNurExeInfo,"^",8)
	s OrderNurExecuteObj.mainOeore=$P(OrderNurExeInfo,"^",9)
	s OrderNurExecuteObj.ordItmId=$P(OrderNurExeInfo,"^",10)
	s OrderNurExecuteObj.oeore=$P(OrderNurExeInfo,"^",11)
	s OrderNurExecuteObj.inciCode=$P(OrderNurExeInfo,"^",12)
	s OrderNurExecuteObj.inciDesc=$P(OrderNurExeInfo,"^",13)
	s OrderNurExecuteObj.spec=$P(OrderNurExeInfo,"^",14)
	s OrderNurExecuteObj.manfName=$P(OrderNurExeInfo,"^",15)
	s OrderNurExecuteObj.dspQty=$P(OrderNurExeInfo,"^",16)
	s OrderNurExecuteObj.dspUomDesc=$P(OrderNurExeInfo,"^",17)
	s OrderNurExecuteObj.doseDateTime=$P(OrderNurExeInfo,"^",18)
	s OrderNurExecuteObj.price=$P(OrderNurExeInfo,"^",19)
	s OrderNurExecuteObj.mainOrdItmId=$P(OrderNurExeInfo,"^",20)
	s body.OrderNurExecutes=OrderNurExecuteObj
	s request.body=body
	d request.XMLExportToStream(.stream)
	q stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
