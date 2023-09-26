Class BILL.EINV.DTO.TBTCA.PaperCollectionRecord Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 0;

/// 票据代码
Property BillCode As %String(XMLPROJECTION = "ELEMENT");

/// 票据名称
Property BillName As %String(XMLPROJECTION = "ELEMENT");

/// 领用时间
Property CollectionTime As %String(XMLPROJECTION = "ELEMENT");

/// 起始号码
Property StartNo As %String(XMLPROJECTION = "ELEMENT");

/// 结束号码
Property EndNo As %String(XMLPROJECTION = "ELEMENT");

/// 领用数量
Property Count As %String(XMLPROJECTION = "ELEMENT");

/// 领用人
Property Receive As %String(XMLPROJECTION = "ELEMENT");

/// 领用明细ID
Property ReceiveId As %String(XMLPROJECTION = "ELEMENT");

}
