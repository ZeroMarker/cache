Class User.DHCStudentLq Extends %Persistent [ SqlTableName = DHC_Student_Lq, StorageStrategy = NewStorage1 ]
{

// St_Code,St_Name,St_Sex_DR(Ct_Sex),St_Dob(Date)

// 学号：

Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

// 姓名：

Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

// 性别：

Property StSexDR As User.CTSex [ Required, SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

// 出生日期：

Property StDob As %String [ Required, SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Storage NewStorage1
{
<StreamLocation>^User.DHCStudentLqS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Storage Default
{
<Data name="DHCStudentLqDefaultData">
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
<DataLocation>^User.DHCStudentLqD</DataLocation>
<DefaultData>DHCStudentLqDefaultData</DefaultData>
<IdLocation>^User.DHCStudentLqD</IdLocation>
<IndexLocation>^User.DHCStudentLqI</IndexLocation>
<StreamLocation>^User.DHCStudentLqS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
