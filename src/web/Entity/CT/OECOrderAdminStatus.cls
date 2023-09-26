/// 名称: 医嘱执行状态维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-9-4
Class web.Entity.CT.OECOrderAdminStatus Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.OECOrderAdminStatus";

/// RowId号
Property STATRowId As %String;

/// 代码
Property STATCode As %String;

/// 描述
Property STATDesc As %String;

/// Bill Flag
Property STATBill As %String;

/// Stock Flag
Property STATDeductStock As %String;

/// IV Completed
Property STATIVCompleted As %String;

/// Can Admin Skin Test
Property STATCanAdminSkinTest As %String;

}
