Class EMR.DOC.DTO.TitleColConfig Extends %RegisteredObject
{

/// 类型
Property Type As %String(TRUNCATE = 1);

/// 是否只读
Property ReadOnly As %String(TRUNCATE = 1);

/// 值格式
Property Format As %String(TRUNCATE = 1);

/// 是否换行
Property LineBreak As %String(TRUNCATE = 1);

/// 对齐方式
Property Align As %String(TRUNCATE = 1);

/// 是否显示
Property Visible As %String(TRUNCATE = 1);

/// 标题时间前后顺序
Property SeqNum As %Integer;

/// 字体
Property FontStyle As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 扩展参数
Property Params As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 绑定标题
Property TitleID As %String;

}
