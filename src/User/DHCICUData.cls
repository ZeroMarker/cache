/// 重症表单数据
Class User.DHCICUData Extends %Library.Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICU_Data ]
{

/// 重症表单
Property ICUSheet As User.DHCICUSheet [ Required, SqlColumnNumber = 2 ];

/// 数据项代码，在一个表单中代码是唯一的
Property ItemCode As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 数据项描述
Property ItemDesc As %String(MAXLEN = 1000) [ Required, SqlColumnNumber = 4 ];

/// 数据值
Property ItemValue As %String(MAXLEN = 3000) [ SqlColumnNumber = 5 ];

/// 数据产生日期
Property ItemDate As %Date [ SqlColumnNumber = 6 ];

/// 数据产生时间
Property ItemTime As %Time [ SqlColumnNumber = 7 ];

/// 最后更新用户
Property UpdateUser As %String [ SqlColumnNumber = 8 ];

/// 最后更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 9 ];

/// 最后更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 10 ];

/// 备注
Property Note As %String(MAXLEN = 3000) [ SqlColumnNumber = 11 ];

Index ISheet On ICUSheet;

/// 表单中的每个数据项代码是唯一的
Index ICode On (ICUSheet, ItemCode) [ Unique ];

/// 重症表单删除联动
ForeignKey FKICUSheet(ICUSheet) References User.DHCICUSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="DHCICUDataDefaultData">
<Value name="1">
<Value>ICUSheet</Value>
</Value>
<Value name="2">
<Value>ItemCode</Value>
</Value>
<Value name="3">
<Value>ItemDesc</Value>
</Value>
<Value name="4">
<Value>ItemValue</Value>
</Value>
<Value name="5">
<Value>ItemDate</Value>
</Value>
<Value name="6">
<Value>ItemTime</Value>
</Value>
<Value name="7">
<Value>UpdateUser</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>UpdateTime</Value>
</Value>
<Value name="10">
<Value>Note</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUDataD</DataLocation>
<DefaultData>DHCICUDataDefaultData</DefaultData>
<IdLocation>^User.DHCICUDataD</IdLocation>
<IndexLocation>^User.DHCICUDataI</IndexLocation>
<StreamLocation>^User.DHCICUDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
