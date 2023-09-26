/// Creator:基础数据平台组 钟荣枫
/// CreateDate:2019-12-27
/// Desc:科室多层关系维护
Class web.Entity.CT.BDPCTLOCCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDPCTLOCCategory";

Property ID As %String;

/// 代码,要求唯一
Property Code As %String;

/// 名称,中文描述
Property Caption As %String;

/// 片区/学科/学科分类
Property Type As %String;

/// 上级分类
Property ParentCatDr As %String;

/// 激活状态(Y/N)
Property ActiveFlag As %String;

/// 显示顺序,1,2,3
Property Sequence As %String;

}
