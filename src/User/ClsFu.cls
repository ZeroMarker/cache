Class User.ClsFu Extends (%Persistent, User.Abstract) [ SqlRowIdName = St_RowId, SqlTableName = DHC_StudentFU ]
{

/// 表名DHC_Student,类名User.DHCStudent 主键 St_RowID 字段 St_Code,St_Name,St_Sex_DR(Ct_Sex),St_Dob(Date)
Property StCode As %String [ SqlColumnNumber = 2, SqlFieldName = St_Code ];

Property StName As %String [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Storage Default
{
<Data name="ClsFuDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StCode</Value>
</Value>
<Value name="3">
<Value>StName</Value>
</Value>
<Value name="4">
<Value>StSexDR</Value>
</Value>
<Value name="5">
<Value>StDob</Value>
</Value>
</Data>
<DataLocation>^User.ClsFuD</DataLocation>
<DefaultData>ClsFuDefaultData</DefaultData>
<IdLocation>^User.ClsFuD</IdLocation>
<IndexLocation>^User.ClsFuI</IndexLocation>
<SqlRowIdName>St_RowId</SqlRowIdName>
<StreamLocation>^User.ClsFuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
