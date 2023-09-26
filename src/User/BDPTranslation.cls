/// 基础数据平台翻译表
/// 陈莹
Class User.BDPTranslation Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlTableName = BDP_Translation ]
{

/// 表名
Property BTTableName As %String(MAXLEN = "") [ Required ];

/// 字段名
Property BTFieldName As %String(MAXLEN = "") [ Required ];

/// 语言
Property BTLanguages As %String(MAXLEN = "") [ Required ];

/// 翻译前中文
Property BTFieldDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 翻译后内容
Property BTTransDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

Index TransIndex On (BTTableName, BTFieldName, BTLanguages, BTFieldDesc As Exact);

Index SrcIndex On (BTTableName, BTFieldName, BTLanguages, BTTransDesc As Exact, BTFieldDesc As Exact);

Index LanIndex On BTLanguages;

Index TableIndex On BTTableName;

Storage Default
{
<Data name="BDPTranslationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTableName</Value>
</Value>
<Value name="3">
<Value>BTFieldName</Value>
</Value>
<Value name="4">
<Value>BTLanguages</Value>
</Value>
<Value name="5">
<Value>BTFieldDesc</Value>
</Value>
<Value name="6">
<Value>BTTransDesc</Value>
</Value>
</Data>
<DataLocation>^User.BDPTranslationD</DataLocation>
<DefaultData>BDPTranslationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPTranslationD</IdLocation>
<IndexLocation>^User.BDPTranslationI</IndexLocation>
<StreamLocation>^User.BDPTranslationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
