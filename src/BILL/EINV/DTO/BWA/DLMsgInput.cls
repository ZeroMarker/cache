Class BILL.EINV.DTO.BWA.DLMsgInput Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 纳税人识别号
Property NSRSBH As %String(XMLPROJECTION = "ELEMENT");

/// 销售方名称
Property XSFMC As %String(XMLNAME = "XSF_MC", XMLPROJECTION = "ELEMENT");

/// 设备编号
Property JQBH As %String(XMLPROJECTION = "ELEMENT");

/// 接口参数(值为4代表开票/上传，为3代表下载)
Property DIRECT As %String(XMLPROJECTION = "ELEMENT");

/// 内层报文(发票上传的内层报文，需BASE64加密)
Property FPXML As %String(MAXLEN = 1000, XMLPROJECTION = "ELEMENT");

}
