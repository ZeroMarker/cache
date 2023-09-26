/// 数据-导管使用信息变更记录
Class User.DHCICUCatheterChange Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICU_CatheterChange ]
{

/// 重症记录
Property Arrange As User.DHCICUArrange [ Required, SqlColumnNumber = 2 ];

/// 导管使用记录
Property CatheterRecord As User.DHCICUCatheterRecord [ Required, SqlColumnNumber = 3 ];

/// 修改字段
Property ChangeField As %String [ Required, SqlColumnNumber = 4 ];

/// 修改字段名称
Property ChangeFieldName As %String [ Required, SqlColumnNumber = 5 ];

/// 原始值
Property OriginalValue As %String [ SqlColumnNumber = 6 ];

/// 修改值
Property Value As %String [ SqlColumnNumber = 7 ];

/// 操作者
Property UpdateUser As %String [ SqlColumnNumber = 8 ];

/// 变更日期
Property UpdateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9 ];

/// 变更时间
Property UpdateTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 10 ];

Index Arr On Arrange;

Index Catheter On (Arrange, CatheterRecord);

Storage Default
{
<Data name="DHCICUCatheterChangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Arrange</Value>
</Value>
<Value name="3">
<Value>CatheterRecord</Value>
</Value>
<Value name="4">
<Value>ChangeField</Value>
</Value>
<Value name="5">
<Value>ChangeFieldName</Value>
</Value>
<Value name="6">
<Value>OriginalValue</Value>
</Value>
<Value name="7">
<Value>Value</Value>
</Value>
<Value name="8">
<Value>UpdateUser</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUCatheterChangeD</DataLocation>
<DefaultData>DHCICUCatheterChangeDefaultData</DefaultData>
<IdLocation>^User.DHCICUCatheterChangeD</IdLocation>
<IndexLocation>^User.DHCICUCatheterChangeI</IndexLocation>
<StreamLocation>^User.DHCICUCatheterChangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
