/// 名称:科室用户权限配置
/// 描述:实体类
/// 编写者:基础数据平台-李可凡
/// 编写日期:2021-07-14
Class web.Entity.BDP.BDPCDSSDeptUserAut Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.BDP.BDPCDSSDeptUserAut";

/// rowid
Property ID As %String;

/// 科室id
Property DeptDR As %String;

/// 关联用户id
Property UserDR As %String;

/// 维护时间
Property CreateDate As %String;

/// 更新人员
Property CreateUser As %String;

/// 备注
Property Remarks As %String;

/// cdss服务代码
Property CDSSServiceCode As %String;

}
