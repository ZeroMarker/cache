/// 名称：		EPRservice.entity.EDataElementValues
/// 描述：		数据值域代码持久化类
/// 编写者：	yejian
/// 编写时间：	2012-7-10
Class EPRservice.entity.EDataElementValues Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
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

/// 数据元标示符
Property DEVID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 值含义
Property Meaning As %String(MAXLEN = 20, TRUNCATE = 1);

/// 说明
Property Description As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标示符关联ID
Property DECVMID As %String(MAXLEN = 50, TRUNCATE = 1);

}
