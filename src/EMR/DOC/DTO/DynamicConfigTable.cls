/// 名称:		EMR.DOC.DTO.DynamicConfigTable
/// 描述:		公用字典
/// 编写者：	zzy
/// 编写日期: 	2020-10-15
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.DynamicConfigTable Extends (%RegisteredObject, %XML.Adaptor)
{

Index Idx On (TableName, ConfigName) [ Unique ];

/// className
Property ClassName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// tableName
Property TableName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 配置名称
Property ConfigName As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 字段
Property Fields As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 字段默认值
Property IniValue As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 6 ];

}
