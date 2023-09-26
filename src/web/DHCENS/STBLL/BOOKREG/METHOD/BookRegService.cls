/// 取号确认
Class web.DHCENS.STBLL.BOOKREG.METHOD.BookRegService Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lyh
/// CreatDate：2016-07-04
/// Description：HIS端取号成功后调用
/// Table：
/// Input： 预约单号
/// Return：
/// Others: w ##class(web.DHCENS.STBLL.BOOKREG.METHOD.BookRegService).BookRegService("3204||2")
ClassMethod BookRegService(OrderCode As %String) As %GlobalCharacterStream
{
	s $zt="Err"
	s request=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Request).%New()
	s header=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Header).%New()
	s header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID($h)
	s header.SourceSystem="02"
	s request.header=header
	s body=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Body).%New()
	s bookRegObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.BookRegService).%New()
	s bookRegObj.TradeCode="T003"
	s bookRegObj.ExtOrgCode=""
	s bookRegObj.ClientType=""
	s bookRegObj.HospitalId=""
	s bookRegObj.ExtUserID=""
	s bookRegObj.TransactionId=""
	s bookRegObj.OrderCode=OrderCode
	s body.bookRegService=bookRegObj
	s request.body=body
	d request.XMLExportToStream(.stream)
	b ;lyh end
	q stream
Err
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
