/// 航信电子发票开具接口入参组织
Class BILL.EINV.DTO.HXA.EInvoiceReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "REQUEST_FPKJXX";

Property ReqComFPKJXX As BILL.EINV.DTO.BWA.EReqComFPKJ(XMLNAME = "REQUEST_FPKJXX", XMLPROJECTION = "ELEMENT");

}
