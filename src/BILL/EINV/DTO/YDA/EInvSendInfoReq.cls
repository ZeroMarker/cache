/// 远得发票信息推送参数组织对象
Class BILL.EINV.DTO.YDA.EInvSendInfoReq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

Parameter XMLNAME = "RetData";

Property Command As %String(TRUNCATE = 1);

/// InvoiceCode	发票代码	VARCHAR (20)	是
Property InvoiceCode As %String(TRUNCATE = 1);

/// InvoiceNo	发票号码	VARCHAR (10)	是
Property InvoiceNo As %String(TRUNCATE = 1);

/// Times	开票日期	VARCHAR (10)
Property Times As %String(TRUNCATE = 1);

/// ClientMail	邮箱	VARCHAR (50)
Property ClientMail As %String(TRUNCATE = 1);

/// ClientPhone	手机号	VARCHAR (11)
Property ClientPhone As %String(TRUNCATE = 1);

}
