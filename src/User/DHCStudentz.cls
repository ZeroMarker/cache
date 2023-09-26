Class User.DHCStudentz Extends %Persistent [ SqlTableName = DHC_Studentz ]
{

Relationship ChildCourse As DHCStudentCoursex [ Cardinality = children, Inverse = ParRef ];

Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Index Code On StCode As Exact;

Index Name On StName As Exact;

Storage Default
{
<Data name="DHCStudentzDefaultData">
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
<DataLocation>^User.DHCStudentzD</DataLocation>
<DefaultData>DHCStudentzDefaultData</DefaultData>
<IdLocation>^User.DHCStudentzD</IdLocation>
<IndexLocation>^User.DHCStudentzI</IndexLocation>
<StreamLocation>^User.DHCStudentzS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
