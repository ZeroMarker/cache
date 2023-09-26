/// 名称:		EMR.DOC.DTO.TextKBCategory
/// 描述:		当前使用牙位表示法
/// 编写者：	zhangxl
/// 编写日期: 	2021-10-12
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.EToothRepresentation Extends %RegisteredObject
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 代码
Property ToothCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property ToothName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 状态(0:未使用，1：正在使用)
Property Status As %String(MAXLEN = 100, TRUNCATE = 1);

}
