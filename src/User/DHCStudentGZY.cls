Class User.DHCStudentGZY Extends (%Persistent, User.Abstract) [ SqlRowIdName = St_RowId, SqlTableName = DHC_Student_GZY ]
{

Property StCode As %String [ SqlColumnNumber = 2, SqlFieldName = St_Code ];

Property StName As %String [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_SexDR ];

Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Index NameIndex On StName As EXACT;

Index CodeIndex On StCode As EXACT;

Storage Default
{
<Data name="DHCStudentGZYDefaultData">
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
<DataLocation>^User.DHCStudentGZYD</DataLocation>
<DefaultData>DHCStudentGZYDefaultData</DefaultData>
<IdLocation>^User.DHCStudentGZYD</IdLocation>
<IndexLocation>^User.DHCStudentGZYI</IndexLocation>
<StreamLocation>^User.DHCStudentGZYS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
