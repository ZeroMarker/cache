Class CT.WS.entity.EDataDicToData Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 系统编码
Property Code As %String(TRUNCATE = 1);

/// 自定义字典定义编码
Property ConfigId As %String(TRUNCATE = 1);

/// 自定义字典描述
Property ConfigValue As %String(TRUNCATE = 1);

/// 标准值域代码表数据元值域代码
Property StandardId As %String(TRUNCATE = 1);

/// 标准值域代码表数据元值域描述
Property StandardValue As %String(TRUNCATE = 1);

}
