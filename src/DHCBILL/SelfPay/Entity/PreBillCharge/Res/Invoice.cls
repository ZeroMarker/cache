Class DHCBILL.SelfPay.Entity.PreBillCharge.Res.Invoice Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// InvoiceNo 票据唯一流水号
Property InvoiceNo As %String(TRUNCATE = 1);

/// InvoiceAmt 票据金额
Property InvoiceAmt As %String(TRUNCATE = 1);

/// InsuFlag 调用医保标志（Y调用,N不调用）
Property InsuFlag As %String(TRUNCATE = 1);

/// OutInsuInfo 第三方医保分解上传明细
Property OutInsuInfo As %GlobalCharacterStream;

/// HISInsuInfo HIS动态库医保分解参数
Property HISInsuInfo As %String(TRUNCATE = 1);

}
