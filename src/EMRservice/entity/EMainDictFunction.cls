/// 名称: 维护程序系统功能项定义表
/// 描述: 系统功能项
/// 编写者：LingChen
/// 编写日期: 2010-10-22
Class EMRservice.entity.EMainDictFunction Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 功能名称
Property FuncName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 功能描述
Property FuncDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 父节点
Property ParentID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// Group/Item 
Property Type As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 备注
Property Notes As %String(MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 6 ];

}
