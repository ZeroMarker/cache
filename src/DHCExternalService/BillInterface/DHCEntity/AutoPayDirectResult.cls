Class DHCExternalService.BillInterface.DHCEntity.AutoPayDirectResult Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

//Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

//=1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

//=0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

//Parameter XMLIGNORENULL = 1;

//Parameter XMLSEQUENCE = 0;

/// TradeCode	*交易编码
Property ResultCode As %String(TRUNCATE = 1);

/// BankID	*银行代码
Property ResultContent As %String(TRUNCATE = 1);

/// HospitalID	医院编码
Property PatNo As %String(TRUNCATE = 1);

/// ClientType	渠道代码
Property CardNo As %String(TRUNCATE = 1);

/// TerminalID	科室代码
Property PrtDate As %String(TRUNCATE = 1);

/// ExtUserID	操作员代码
Property PatName As %String(TRUNCATE = 1);

/// HISDate	HIS交易时间 YYYYMMDDHHMMSS
Property PatSex As %String(TRUNCATE = 1);

/// HISTradeNo HIS唯一流水号
Property PatAge As %String(TRUNCATE = 1);

/// PayCardNo	银联卡号
Property AdmLoc As %String(TRUNCATE = 1);

/// RevTranFlag	正反交易标志 0-扣费，1-退费
Property AdmLocAddress As %String(TRUNCATE = 1);

/// PatientID	患者主索引
Property AdmDoc As %String(TRUNCATE = 1);

/// MobileNo	手机/电话号码
Property AdmDia As %String(TRUNCATE = 1);

/// PayAmt	扣款总金额
Property PreWindow As %String(TRUNCATE = 1);

Property RecLocs As list Of DHCExternalService.BillInterface.DHCEntity.RecLoc(XMLITEMNAME = "RecLoc", XMLPROJECTION = "ELEMENT");

}
