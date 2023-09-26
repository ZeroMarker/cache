/// 医呼通设备发放
/// 基础数据平台-李可凡
/// 2022-08-21
/// table: CT_HCCSEquipLinkContList
Class web.Entity.CT.CTHCCSEquipLinkContList Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTHCCSEquipLinkContList";

/// RowId
Property ELCLRowId As %String;

/// 医呼通设备
Property ELCLEquipmentDR As %String;

/// 科室领用人（指向个人通讯录）
Property ELCLContactListDR As %String;

/// 关联开始日期-这个字段不用了
Property ELCLDateFrom As %String;

/// 关联结束日期-这个字段不用了
Property ELCLDateTo As %String;

/// 领用科室（指向 医呼通科室）
Property ELCLAcceptLocationDR As %String;

/// 发放时间（日期 时间 $zdt($h,3) ） 
Property ELCLDeliverTime As %String;

/// 状态（Y启用，N停用）
Property ELCLStatus As %String;

/// 科室是否接收(Y/N)
Property ELCLIsAcceptedByLoc As %String;

/// 设备接收时间（日期 时间 $zdt($h,3) ）
Property ELCLAcceptTime As %String;

/// 设备接收人（SS_User）
Property ELCLAcceptUserDR As %String;

/// 使用模式（全科共用A、单人专用U）
Property ELCLUseMode As %String;

/// 使用人(单人专用时必须维护此字段， 个人通讯录)
Property ELCLEquipUserDR As %String;

}
