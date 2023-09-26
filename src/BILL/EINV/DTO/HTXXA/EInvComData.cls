/// 航天公共参数
Class BILL.EINV.DTO.HTXXA.EInvComData Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "EInvoiceIFS";

/// SM3算法
Property Sign As %String(CAPTION = "签名值", XMLPROJECTION = "ELEMENT");

Property IFSHeader As BILL.EINV.DTO.HTXXA.EInvComDataHeader(CAPTION = "电子票据接口交互报文头", XMLPROJECTION = "ELEMENT");

Property IFSDATA As BILL.EINV.DTO.HTXXA.EInvComDataIFSDATA(CAPTION = "电子票据接口数据", XMLPROJECTION = "ELEMENT");

Property ReturnInfo As BILL.EINV.DTO.HTXXA.EInvComDataReturnInfo(CAPTION = "返回内容", XMLPROJECTION = "ELEMENT");

}
