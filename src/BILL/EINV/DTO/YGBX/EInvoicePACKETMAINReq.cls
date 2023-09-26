Class BILL.EINV.DTO.YGBX.EInvoicePACKETMAINReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

/// UNITED	是否合并开票	VARCHAR2(50)	是	0-否 1-是
Property UNITED As %String(TRUNCATE = 1, XMLNAME = "UNITED");

/// BDH	保单号	VARCHAR2(50)	是	
Property BDH As %String(TRUNCATE = 1, XMLNAME = "BDH");

/// QC	期次	VARCHAR2(50)	否	分期开具期次号按逗号分隔,多保单号时不取该字段，直接获取所有为开票数据
Property QC As %String(TRUNCATE = 1, XMLNAME = "QC");

/// ACNTUNIT	归属机构	VARCHAR2(50)	否	5位财务账套代码
Property ACNTUNIT As %String(TRUNCATE = 1, XMLNAME = "ACNTUNIT");

/// PAYEENAME	机构名称	VARCHAR2(50)	否
Property PAYEENAME As %String(TRUNCATE = 1, XMLNAME = "PAYEENAME");

/// TBRMC	投保人名称	VARCHAR2(50)	选填	需要更新时必填
Property TBRMC As %String(TRUNCATE = 1, XMLNAME = "TBRMC");

/// NSRSBH	购买方纳税人识别号	VARCHAR2(50)	选填	需要更新时必填
Property NSRSBH As %String(TRUNCATE = 1, XMLNAME = "NSRSBH");

/// GFKHDZ	购方开户地址	VARCHAR2(255)	选填	需要更新时必填
Property GFKHDZ As %String(TRUNCATE = 1, XMLNAME = "GFKHDZ");

/// GFLXDH	购方联系电话	VARCHAR2(50)	选填	需要更新时必填
Property GFLXDH As %String(TRUNCATE = 1, XMLNAME = "GFLXDH");

/// GFKHYH	购方开户行名称	VARCHAR2(50)	选填	需要更新时必填
Property GFKHYH As %String(TRUNCATE = 1, XMLNAME = "GFKHYH");

/// GFYHZH	购方银行账户	VARCHAR2(50)	选填	需要更新时必填
Property GFYHZH As %String(TRUNCATE = 1, XMLNAME = "GFYHZH");

/// CONSUMERPHONE	消费者手机号	VARCHAR2(50)	否
Property CONSUMERPHONE As %String(TRUNCATE = 1, XMLNAME = "CONSUMERPHONE");

/// CONSUMEREMAIL	消费者电子邮件	VARCHAR2(50)	否
Property CONSUMEREMAIL As %String(TRUNCATE = 1, XMLNAME = "CONSUMEREMAIL");

/// XZDM	 险种代码 	VARCHAR2(50)	是
Property XZDM As %String(TRUNCATE = 1, XMLNAME = "XZDM");

/// XZMC	险种名称	VARCHAR2(50)	是
Property XZMC As %String(TRUNCATE = 1, XMLNAME = "XZMC");

/// AMOUNT	数量	VARCHAR2(50)	是	保单数量，最大为500 
Property AMOUNT As %String(TRUNCATE = 1, XMLNAME = "AMOUNT");

/// TOTALJYJE	所有要合并的保单的总的金额	VARCHAR2(50)	是	含税金额（保费）
Property TOTALJYJE As %String(TRUNCATE = 1, XMLNAME = "TOTALJYJE");

/// FPJZ	发票介质	VARCHAR2(50)	是	2表示电子发票
Property FPJZ As %String(TRUNCATE = 1, XMLNAME = "FPJZ");

/// MESSAGEFLAG	发送消息类型	VARCHAR2(50)	是	0表示不发送总线消息，1表示发  送总线消息
Property MESSAGEFLAG As %String(TRUNCATE = 1, XMLNAME = "MESSAGEFLAG");

/// COMPANYNAME	平台名称	VARCHAR2(50)	是
Property COMPANYNAME As %String(TRUNCATE = 1, XMLNAME = "COMPANYNAME");

/// OPERATESITE	保单来源渠道	VARCHAR2(50)	是
Property OPERATESITE As %String(TRUNCATE = 1, XMLNAME = "OPERATESITE");

/// KPQQH	开票请求号	VARCHAR2(50)	否	飞猪渠道使用
Property KPQQH As %String(TRUNCATE = 1, XMLNAME = "KPQQH");

/// BZ	备注	VARCHAR2(50)	否	备注
Property BZ As %String(TRUNCATE = 1, XMLNAME = "BZ");

}
