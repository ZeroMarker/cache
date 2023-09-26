Class DHCAliPay.DHCEntity.PCA.PatOrder Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ErrorMsg
Property ErrorMsg As %String(TRUNCATE = 1);

/// AdmReasonCount
Property AdmReasonCount As %String(TRUNCATE = 1);

/// 门诊分类集合
Property AdmReasons As list Of DHCAliPay.DHCEntity.PCA.AdmReason;

/// web.DHCEntity.PCA.AdmReason;
Property TarOCCateItems As list Of DHCAliPay.DHCEntity.PCA.TarOCCateItem;

Property PatNO As %String(TRUNCATE = 1);

Property PatName As %String(TRUNCATE = 1);

Property PatSex As %String(TRUNCATE = 1);

Property PatAge As %String(TRUNCATE = 1);

Property AmtSum As %String(TRUNCATE = 1);

Property HisTradeNo As %String(TRUNCATE = 1);

}
