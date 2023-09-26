Class CT.WS.entity.EDataElementValuesCategory Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ID
Property ID As %String(TRUNCATE = 1);

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 最后修改日期
Property LastModifyDate As %Date;

/// 最后修改时间
Property LastModifyTime As %Time;

/// 数据值域目录ID
Property CategoryID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 数据值域代码标示符
Property DECVMID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 代码名称
Property Name As %String(MAXLEN = 100, TRUNCATE = 1);

/// 代码描述	
Property Description As %String(MAXLEN = 500, TRUNCATE = 1);

/// 上级分类名称
Property PerName As %String(MAXLEN = 500, TRUNCATE = 1);

/// 数据OID码
Property OID As %String(MAXLEN = 50, TRUNCATE = 1);

}
