Class DHCENS.LIS.Model.OrgResultMsg Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 细菌代码
Property BugsCode As %String(MAXLEN = 32767);

/// 抗生素代码
Property AntiCode As %String(MAXLEN = 32767);

/// 名称
Property AntiName As %String(MAXLEN = 32767);

/// 缩写
Property AntiEngName As %String(MAXLEN = 32767);

/// MIC结果
Property MICRes As %String(MAXLEN = 32767);

/// KB结果
Property KBRes As %String(MAXLEN = 32767);

/// 药敏结果
Property Result As %String(MAXLEN = 32767);

/// MIC判定范围
Property MICRanges As %String(MAXLEN = 32767);

/// KB判定范围
Property KBRanges As %String(MAXLEN = 32767);

/// 显示顺序
Property Order As %String(MAXLEN = 32767);

}
