/// 名称:通讯录授权
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-12-25
Class web.Entity.CT.CTHCCSPreferences Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTHCCSPreferences";

// PRERowId

Property PRERowId As %String;

// 通讯录-指针

Property PREContactListDR As %String;

// 授权类型（群组G)

Property PREAuthorizeType As %String;

// 授权数据（群组ID)

Property PREAuthorizeData As %String;

}
