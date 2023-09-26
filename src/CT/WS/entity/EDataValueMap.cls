/// 名称：		CT.WS.entity.EDataValueMap
/// 描述：		自定义映射关系持久化类
/// 编写者：	yejian
/// 编写时间：	2012-7-10
Class CT.WS.entity.EDataValueMap Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ID
Property ID As %String(TRUNCATE = 1);

/// 标准值域代码表标示符
Property DECVMID As %String(MAXLEN = 200, TRUNCATE = 1);

/// 标准值域代码表数据元值域代码
Property DEVID As %String(MAXLEN = 200, TRUNCATE = 1);

/// 标准值域代码表数据元值域描述
Property Meaning As %String(MAXLEN = 200, TRUNCATE = 1);

/// 自定义字典代码
Property CtmDictCode As %String(TRUNCATE = 1);

/// 自定义字典描述
Property CtmDictDesc As %String(TRUNCATE = 1);

/// 自定义字典定义编码
Property DicCode As %String(TRUNCATE = 1);

/// 系统编码
Property SystemCode As %String(TRUNCATE = 1);

}
