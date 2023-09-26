Class BILL.EINV.DTO.YGBX.EInvoicePACKETRes Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLNAME = "PACKET";

Property type As %String(XMLPROJECTION = "ATTRIBUTE");

Property version As %String(XMLPROJECTION = "ATTRIBUTE");

/// UNITID	合并开票批次	VARCHAR2(5)	Y	发票请求流水号
Property UNITID As %String(TRUNCATE = 1, XMLNAME = "UNITID");

/// TBRMC	投保人名称	VARCHAR2(50)	Y	发票抬头
Property TBRMC As %String(TRUNCATE = 1, XMLNAME = "TBRMC");

/// FPDM	发票代码	VARCHAR2(50)	Y
Property FPDM As %String(TRUNCATE = 1, XMLNAME = "FPDM");

/// FPHM	发票号码	VARCHAR2(50)	Y	
Property FPHM As %String(TRUNCATE = 1, XMLNAME = "FPHM");

/// KPRQ	开票日期	VARCHAR2(50)	Y	
Property KPRQ As %String(TRUNCATE = 1, XMLNAME = "KPRQ");

/// RETURNCODE	发票生成状态	VARCHAR2(50)	Y	0成功，1失败，2 保单已开过发票
Property RETURNCODE As %String(TRUNCATE = 1, XMLNAME = "RETURNCODE");

/// ERRORBDH	保单号	VARCHAR2(50)	N	返回所有已开过票的保单号，以逗号隔开
Property ERRORBDH As %String(TRUNCATE = 1, XMLNAME = "ERRORBDH");

/// RETURNMSG	状态描述	VARCHAR2(50)	Y	信息（成功、错误信息等）
Property RETURNMSG As %String(TRUNCATE = 1, XMLNAME = "RETURNMSG");

}
