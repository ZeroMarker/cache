/// CT_HospitalLogo
/// 医院logo表	Entity
/// 基础数据平台-李可凡
/// 2022-07-07
Class web.Entity.CT.CTHospitalLogo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTHospitalLogo";

/// rowid
Property LOGORowId As %String;

/// CT_Hospital Parent Reference
Property LOGOParRef As %String;

/// Childsub
Property LOGOChildsub As %String;

/// 业务代码
Property LOGOCode As %String;

/// logo Url地址
Property LOGOUrl As %String;

/// 备注
Property LOGORemarks As %String;

/// logo base64编码
Property LOGOImg As %String;

}
