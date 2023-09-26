Class User.DHCStudentLYZ Extends (%Persistent, User.Abstract) [ SqlRowIdName = St_RowId, SqlTableName = DHC_Student_lyz ]
{

// Property StRowID As %Integer [ SqlColumnNumber = 1, SqlFieldName = St_RowID ];

Property StCode As %String [ SqlColumnNumber = 2, SqlFieldName = St_Code ];

Property StName As %String [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_SexDR ];

Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Index NameIndex On StName As EXACT;

Index CodeIndex On StCode As EXACT;

// Index MasterMap On StRowID [ IdKey, Unique ];

/// Define the global mapping for DHC_Student
/// Global(Master Map): ^DHCSTUDENT({St_RowID})
Storage Default
{
<Data name="DHCStudentLYZDefaultData">
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
<DataLocation>^User.DHCStudentLYZ</DataLocation>
<DefaultData>DHCStudentLYZDefaultData</DefaultData>
<Description>
<![CDATA[Define the global mapping for DHC_Student
Global(Master Map): ^DHCSTUDENT({St_RowID})]]></Description>
<IdLocation>^User.DHCStudentLYZ</IdLocation>
<IndexLocation>^User.DHCStudentLYZ</IndexLocation>
<StreamLocation>^User.DHCStudentLYZ</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
