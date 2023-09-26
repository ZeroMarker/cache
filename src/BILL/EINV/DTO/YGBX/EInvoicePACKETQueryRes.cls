Class BILL.EINV.DTO.YGBX.EInvoicePACKETQueryRes Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLNAME = "PACKET";

Property type As %String(XMLPROJECTION = "ATTRIBUTE");

Property version As %String(XMLPROJECTION = "ATTRIBUTE");

/// RETURNCODE	返回代码	VARCHAR2(5)	Y	0-成功1-失败
Property RETURNCODE As %String(XMLNAME = "RETURNCODE", XMLPROJECTION = "ELEMENT");

/// RETURNMSG	返回信息	VARCHAR2(500)	Y	
Property RETURNMSG As %String(XMLNAME = "RETURNMSG", XMLPROJECTION = "ELEMENT");

Property FPDM As %String(XMLNAME = "FPDM", XMLPROJECTION = "ELEMENT");

Property FPHM As %String(XMLNAME = "FPHM", XMLPROJECTION = "ELEMENT");

/// PDF_URL	PDF下载地址	VARCHAR2(50)
Property PDFURL As %String(XMLNAME = "PDF_URL", XMLPROJECTION = "ELEMENT");

/// KPRQ	开票日期
Property KPRQ As %String(XMLNAME = "KPRQ", XMLPROJECTION = "ELEMENT");

}
