/// 定义病人就诊状态图标显示子表
Class User.DocCFTreatStatusInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = TreatStatusConfigID ]
{

/// 主表ID
Property TreatStatusConfigMainID As User.DocCFTreatStatusMainInfo [ SqlColumnNumber = 2 ];

/// 元素ID
Property toolId As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 名称描述
Property name As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 显示顺序
Property DisplayNum As %Library.Integer [ SqlColumnNumber = 5, SqlComputeCode = { s {DisplayNum}= $s(({DisplayNum}'=""):{DisplayNum},1:$g(^User.DocCFTreatStatusInfoD)+1)}, SqlComputed ];

/// 是否显示
Property IsVisible As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// 是否有效
Property IsActive As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// 样式
Property iconStyle As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

/// 图标路径
Property iconRoute As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

/// 炫彩样式
Property customStyle As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

/// 链接
Property URLconfig As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

/// 事件定义	
Property clickHandler As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

/// 状态改变
Property statusChangeHandler As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

/// 水平分割条	
Property herSplitLine As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

/// 垂直分隔条
Property verSplitLine As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 15 ];

/// 激活状态	
Property activeStatus As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

/// 禁用状态
Property disableStatus As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

/// 悬浮提示
Property tooltip As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 18 ];

/// 快捷键
Property shortcut As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 19 ];

/// 表达式
Property express As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 20 ];

/// 极简样式
Property liteCustomStyle As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 21 ];

/// 与前一个元素成组
Property prevGroupFlag As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 22 ];

Index mainIndex On (TreatStatusConfigMainID, DisplayNum, IsActive);

Storage Default
{
<Data name="DocCFTreatStatusInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TreatStatusConfigMainID</Value>
</Value>
<Value name="3">
<Value>TreatStatusConfigCode</Value>
</Value>
<Value name="4">
<Value>toolId</Value>
</Value>
<Value name="5">
<Value>name</Value>
</Value>
<Value name="6">
<Value>DisplayNum</Value>
</Value>
<Value name="7">
<Value>IsVisible</Value>
</Value>
<Value name="8">
<Value>IsActive</Value>
</Value>
<Value name="9">
<Value>iconStyle</Value>
</Value>
<Value name="10">
<Value>customStyle</Value>
</Value>
<Value name="11">
<Value>URLconfig</Value>
</Value>
<Value name="12">
<Value>Clickevent</Value>
</Value>
<Value name="13">
<Value>clickHandler</Value>
</Value>
<Value name="14">
<Value>herSplitLine</Value>
</Value>
<Value name="15">
<Value>verSplitLine</Value>
</Value>
<Value name="16">
<Value>statusChangeHandler</Value>
</Value>
<Value name="17">
<Value>iconRoute</Value>
</Value>
<Value name="18">
<Value>activeStatus</Value>
</Value>
<Value name="19">
<Value>disableStatus</Value>
</Value>
<Value name="20">
<Value>tooltip</Value>
</Value>
<Value name="21">
<Value>shortcut</Value>
</Value>
<Value name="22">
<Value>express</Value>
</Value>
<Value name="23">
<Value>liteCustomStyle</Value>
</Value>
<Value name="24">
<Value>prevGroupFlag</Value>
</Value>
</Data>
<DataLocation>^User.DocCFTreatStatusInfoD</DataLocation>
<DefaultData>DocCFTreatStatusInfoDefaultData</DefaultData>
<IdLocation>^User.DocCFTreatStatusInfoD</IdLocation>
<IndexLocation>^User.DocCFTreatStatusInfoI</IndexLocation>
<StreamLocation>^User.DocCFTreatStatusInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
