Class User.StudentInfoYHT Extends %Persistent [ SqlTableName = DHC_StudentDefaultYHT ]
{

/// 学生学号
Property StCode As %String [ SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 学生姓名
Property StName As %String [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 学生性别指针
Property StSexDR As CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 学生出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

/// 学生学号索引
Index CodeIndex On StCode;

/// 学生姓名索引
Index NameIndex On StName;

Storage Default
{
<Data name="StudentInfoYHTDefaultData">
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
<DataLocation>^User.StudentInfoYHTD</DataLocation>
<DefaultData>StudentInfoYHTDefaultData</DefaultData>
<IdLocation>^User.StudentInfoYHTD</IdLocation>
<IndexLocation>^User.StudentInfoYHTI</IndexLocation>
<SqlRowIdName>St_RowId</SqlRowIdName>
<StreamLocation>^User.StudentInfoYHTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
