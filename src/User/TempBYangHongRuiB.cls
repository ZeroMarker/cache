Class User.TempBYangHongRuiB Extends (%Persistent, User.Abstract) [ SqlRowIdName = PAADM_RowId, SqlTableName = TempB_YangHongRuiB ]
{

/// 字段：PatName  BED_NO  BED_Desc
/// 姓名
Property PatName As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Pat_Name ];

/// 床号
Property BEDNO As %String [ SqlColumnNumber = 3, SqlFieldName = BED_NO ];

/// 床的型号
Property BEDDesc As %String [ SqlColumnNumber = 4, SqlFieldName = BED_Desc ];

/// 对代码进行唯一性限制
/// 姓名索引
Index Name On PatName As Exact;

Index NO On BEDNO As Exact;

Storage Default
{
<Data name="TempBYangHongRuiBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatName</Value>
</Value>
<Value name="3">
<Value>BEDNO</Value>
</Value>
<Value name="4">
<Value>BEDDesc</Value>
</Value>
</Data>
<DataLocation>^User.TempBYangHongRuiBD</DataLocation>
<DefaultData>TempBYangHongRuiBDefaultData</DefaultData>
<IdLocation>^User.TempBYangHongRuiBD</IdLocation>
<IndexLocation>^User.TempBYangHongRuiBI</IndexLocation>
<StreamLocation>^User.TempBYangHongRuiBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
