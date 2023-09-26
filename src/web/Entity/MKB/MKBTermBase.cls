/// Creator:高姗姗
/// CreatDate:2018-03-27
/// Description：医用知识库术语注册实体类
/// Table：User.MKBTermBase
Class web.Entity.MKB.MKBTermBase Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.MKB.MKBTermBase";

Property MKBTBRowId As %String;

/// 术语ID
Property MKBTBCode As %String;

/// 术语名
Property MKBTBDesc As %String;

/// 类型
Property MKBTBType As %String;

/// 版本
Property MKBTBVersion As %String;

/// 出处
Property MKBTBSource As %String;

/// 检索码
Property MKBTBPYCode As %String;

/// 备注
Property MKBTBNote As %String;

/// 分类Id
Property MKBTBCatDr As %String;

/// 分类描述
Property MKBTDesc As %String;

/// 标识
Property MKBTBFlag As %String;

/// 图标
Property MKBTBImage As %String;

/// 顺序
Property MKBTBSequence As %String;

/// 编码规则
Property MKBTBCodeRules As %String;

}
