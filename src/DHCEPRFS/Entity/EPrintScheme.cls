/// Desc: 打印方案
/// Creator:Candyxu
/// CreateDate:2012-05-04
Class DHCEPRFS.Entity.EPrintScheme Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

/// PDF打印方案名称
Property SchemeName As %String(TRUNCATE = 1);

/// PDF打印方案名称描述
Property SchemeDesc As %String(TRUNCATE = 1);

/// 方案所含项目串
Property SchemeItems As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 是否默认
Property IsDefault As %String(TRUNCATE = 1);

/// 创建者用户ID
Property CreateUserID As %String(TRUNCATE = 1);

/// 创建者用户ID
Property ModifyUserID As %String(TRUNCATE = 1);

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 修改日期
Property ModifyDate As %Date;

/// 修改时间
Property ModifyTime As %Time;

/// 方案排序
Property SchemeOrder As %Integer;

/// 方案类型 -  PRINT打印方案，CREATE生成方案
Property SchemeType As %String(TRUNCATE = 1);

}
