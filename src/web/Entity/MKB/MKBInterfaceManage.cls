/// 描述: 知识库接口管理表User.MKBInterfaceManage实体类
/// 编写者：基础数据平台组-石萧伟
/// 编写日期: 2018-03-27
Class web.Entity.MKB.MKBInterfaceManage Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.MKB.MKBInterfaceManage";

Property id As %String;

Property checked As %String;

Property MKBINMRowId As %String;

/// 代码
Property MKBINMCode As %String;

/// 描述
Property MKBINMDesc As %String;

/// 方法
Property MKBINMFunction As %String;

/// 返回值
Property MKBINMReturnValue As %String;

/// 上级分类
Property MKBINMLastLevel As %String;

/// 等级
Property MKBINMLevel As %String;

/// 备注
Property MKBINMRemark As %String;

/// 是否激活
Property MKBINMActive As %String;

}
