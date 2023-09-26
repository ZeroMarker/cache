Class User.xsl.DHCStudent Extends %Persistent [ SqlTableName = DHC_Student ]
{

Property StCode As %String [ SqlColumnNumber = 2, SqlFieldName = St_Code ];

Property StName As %String [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_SexDR ];

Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Index NameInx On StName As EXACT;

Index CodeInx On StCode As EXACT;

Storage Default
{
<Data name="DHCStudentDefaultData">
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
<DataLocation>^User.xsl.DHCStudentD</DataLocation>
<DefaultData>DHCStudentDefaultData</DefaultData>
<IdLocation>^User.xsl.DHCStudentD</IdLocation>
<IndexLocation>^User.xsl.DHCStudentI</IndexLocation>
<StreamLocation>^User.xsl.DHCStudentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
