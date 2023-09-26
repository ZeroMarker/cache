Class User.CHL.Student Extends %Persistent [ SqlTableName = Student ]
{

// 陈洪亮

// 学号

Property StCode As %String [ SqlColumnNumber = 2, SqlFieldName = St_Code ];

// 姓名

Property StName As %String [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

// 性别

Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

// 生日

Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

// 学号索引

Index StCodeIdx On StCode [ Unique ];

Storage Default
{
<Data name="StudentDefaultData">
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
<DataLocation>^User.CHL.StudentD</DataLocation>
<DefaultData>StudentDefaultData</DefaultData>
<IdLocation>^User.CHL.StudentD</IdLocation>
<IndexLocation>^User.CHL.StudentI</IndexLocation>
<StreamLocation>^User.CHL.StudentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
