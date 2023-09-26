/// 名称:		EMR.DOC.DTO.DataElementValues
/// 描述:		术语集 数据元值域传输对象
/// 编写者：	yejian
/// 编写日期: 	2020-10-15
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.DataElementValues Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 最终修改日期
Property LastModifyDate As %Date;

/// 最终修改时间
Property LastModifyTime As %Time;

/// 数据值域标示符
Property DEVID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 值含义
Property Meaning As %String(MAXLEN = 500, TRUNCATE = 1);

/// 说明
Property Description As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标示符关联ID
Property DECVMID As %String(MAXLEN = 50, TRUNCATE = 1);

}
