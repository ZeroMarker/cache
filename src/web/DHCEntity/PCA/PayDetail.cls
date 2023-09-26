Class web.DHCEntity.PCA.PayDetail Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// PaySeqNo	支付小票号HIS生成，唯一
Property PaySeqNo As %String(TRUNCATE = 1);

/// Charge	*金额
Property Charge As %String(TRUNCATE = 1);

}
