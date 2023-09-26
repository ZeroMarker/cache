/// 远得电子发票查询接口参数组织
Class BILL.EINV.DTO.YDA.EInvQueryReq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

Parameter XMLNAME = "RetData";

/// Number	单据编号	VARCHAR (30)
Property Number As %String(TRUNCATE = 1);

/// InvoiceCode	发票代码	VARCHAR (20)	是
Property InvoiceCode As %String(TRUNCATE = 1);

/// InvoiceNo	发票号码	VARCHAR (10)	是
Property InvoiceNo As %String(TRUNCATE = 1);

/// Times	开票日期	VARCHAR (10)
Property Times As %String(TRUNCATE = 1);

}
