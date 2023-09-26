/// 名称:		EMR.DOC.DTO.GlossaryItem
/// 描述:		术语集文档元素关联表传输对象
/// 编写者：	yejian
/// 编写日期: 	2020-10-15
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.GlossaryItem Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 所属术语集
Property GlossaryID As %Integer;

/// 所属数据ID
Property DataID As %Integer;

/// 界面模板单元名称(冗余字段用于显示单元名称)
Property ItemName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 关联类型（ISECTIONDESC（章节)，ICOMPOSITEDESC(复合元素)，ICOMPOSITESAMPLE	(结构化元素)，ICONCEPTDESC(医学概念)，ICONCEPTSAMPLE(医学概念子元素)，
/// IMACRODESC(宏对象(存储部分医学公式，月经生育史，眼科前房深度公式))，IMACROSAMPLE(宏对象子元素)）
Property ItemType As %String(TRUNCATE = 1);

/// 编码路径
Property CodePath As %String(MAXLEN = 500, TRUNCATE = 1);

/// 章节编码
Property SCode As %String(TRUNCATE = 1);

/// 段落编码
Property CCode As %String(TRUNCATE = 1);

/// 宏编码
Property MACode As %String(TRUNCATE = 1);

/// 元素编码
Property CSCode As %String(TRUNCATE = 1);

/// 界面模板标示(NEW：新版，OLD:旧版(空))
Property TemType As %String(TRUNCATE = 1);

/// 界面模板单元取值类型
Property ValueType As %String(TRUNCATE = 1);

/// 术语内部标识符
Property InternalID As %String(TRUNCATE = 1);

/// 编码
Property DataCode As %String(MAXLEN = 200, TRUNCATE = 1);

}
