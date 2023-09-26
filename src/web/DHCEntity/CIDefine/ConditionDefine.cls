Class web.DHCEntity.CIDefine.ConditionDefine Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 当前的费别
Property Instype As %String(TRUNCATE = 1);

/// Adm RowID 串 78^67^
Property AdmListInfo As %String(TRUNCATE = 1);

Property GroupDR As %String(TRUNCATE = 1);

/// 组成的医嘱字符串
/// 格式 1||1^2||1^
Property OEORIStr As %String(TRUNCATE = 1);

/// 发票RowID
Property PRTRowIDStr As %String(TRUNCATE = 1);

/// 收费/退费标志
Property SFlag As %String(TRUNCATE = 1);

/// 服务名称
Property ServiceName As %String(TRUNCATE = 1);

/// 不结算医嘱的串
Property UnBillOrdStr As %String(TRUNCATE = 1);

Property UserDR As %String(TRUNCATE = 1);

}
