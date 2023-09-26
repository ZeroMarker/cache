Class BILL.EINV.DTO.YDA.EInvQueryInvoiceRes Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ClientName	购方名称	VARCHAR (100)		成功时必填
Property ClientName As %String(TRUNCATE = 1);

/// InvoiceCode	发票代码	VARCHAR (20)		成功时必填
Property InvoiceCode As %String(TRUNCATE = 1);

/// InvoiceNo	发票号码	VARCHAR (10)		成功时必填
Property InvoiceNo As %String(TRUNCATE = 1);

/// Money	未税金额	DECIMAL(14,2)		成功时必填
Property Money As %String(TRUNCATE = 1);

/// TaxAmount	税额	DECIMAL(14,2)		成功时必填
Property TaxAmount As %String(TRUNCATE = 1);

/// Times	开票日期	VARCHAR (10)		yyyy-MM-dd
Property Times As %String(TRUNCATE = 1);

/// Pdfurl	电子发票下载地址	
Property Pdfurl As %String(TRUNCATE = 1);

/// PdfMsg	生成 pdf 文件失败原因
Property PdfMsg As %String(TRUNCATE = 1);

/// PdfContent	PDF 文件（base64）
Property PdfContent As %String(TRUNCATE = 1);

/// InfoKind	发票类型	Varchar(2)		0:专用发票2：普通发票51：电子发票41：卷式发票
Property InfoKind As %String(TRUNCATE = 1);

/// InvoiceStatus	发票状态	Varchar(2)		0	正常发票1	作废发票
Property InvoiceStatus As %String(TRUNCATE = 1);

}
