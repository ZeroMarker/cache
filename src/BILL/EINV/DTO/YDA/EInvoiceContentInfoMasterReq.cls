Class BILL.EINV.DTO.YDA.EInvoiceContentInfoMasterReq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// Number	单据编号	VARCHAR (30)	是
Property BillNumber As %String(TRUNCATE = 1);

/// BusNo	订单编号	VARCHAR (30)	是
Property BusNo As %String(TRUNCATE = 1);

/// Organ	组织机构代码	VARCHAR (20)
Property Organ As %String(TRUNCATE = 1);

/// ClientName	购方名称	VARCHAR (100)
Property ClientName As %String(TRUNCATE = 1);

/// ClientTaxCode	购方税号	VARCHAR（20）
Property ClientTaxCode As %String(TRUNCATE = 1);

/// ClientBankAccount	购方银行及账号	VARCHAR (100)
Property ClientBankAccount As %String(TRUNCATE = 1);

/// ClientAddressPhone	购方地址及电话	VARCHAR (100)
Property ClientAddressPhone As %String(TRUNCATE = 1);

/// ClientPhone	客户手机号	VARCHAR（11）
Property ClientPhone As %String(TRUNCATE = 1);

/// ClientMail	客户邮箱	VARCHAR（50）
Property ClientMail As %String(TRUNCATE = 1);

/// BillType	发票性质	VARCHAR (1)	是	见注 3
Property BillType As %String(TRUNCATE = 1);

/// InfoKind	发票类型	VARCHAR (2)	是	见注 4
Property InfoKind As %String(TRUNCATE = 1);

/// Notes	发票备注	VARCHAR（200）		
Property Notes As %String(TRUNCATE = 1);

/// InvoiceCode	蓝字发票代码	VARCHAR (20)		红字发票必填
Property InvoiceCode As %String(TRUNCATE = 1);

/// InvoiceNo	蓝字发票号码	VARCHAR (10)		红字发票必填
Property InvoiceNo As %String(TRUNCATE = 1);

/// Invoicer	开票人	VARCHAR (8)	
Property Invoicer As %String(TRUNCATE = 1);

/// Checker	复核人	VARCHAR (8)	
Property Checker As %String(TRUNCATE = 1);

/// Cashier	收款人	VARCHAR (8)	
Property Cashier As %String(TRUNCATE = 1);

/// InvoicerCode	开票人代码	VARCHAR (20)	是	见注 5
Property InvoicerCode As %String(TRUNCATE = 1);

/// SumMoney	开票金额	DECIMAL(14,2)	是	实际开票金额
Property SumMoney As %String(TRUNCATE = 1);

/// Times	单据日期	VARCHAR (10)		2018-11-16
Property Times As %String(TRUNCATE = 1);

/// Remark1	头信息备用字段 1	VARCHAR（200）
Property Remark1 As %String(TRUNCATE = 1);

/// Remark2	头信息备用字段 2	VARCHAR（200）
Property Remark2 As %String(TRUNCATE = 1);

/// SpecialInvoice	特殊票种	CHAR (1)		见注 11
Property SpecialInvoice As %String(TRUNCATE = 1);

}
