/// 描述: 业务执行表User.MKBBusExecute实体类
/// 编写者：基础数据平台组-石萧伟
/// 编写日期: 2018-03-27
Class web.Entity.MKB.MKBBusExecute Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.MKB.MKBBusExecute";

Property MKBBERowId As %String;

/// 代码
Property MKBBECode As %String;

/// 业务执行动作
Property MKBBEBusExe As %String;

/// 业务场景
Property MKBBEBusScene As %String;

/// 上级分类
Property MKBBELastLevel As %String;

/// 等级
Property MKBBELevel As %String;

/// 是否激活
Property MKBBEActive As %String;

/// 业务接口
Property MKBBEInterfDr As %String;

}
