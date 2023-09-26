/// Function:学生类(默认存储)
/// createDate : 2023-09-12
/// Creator :俞长志
Class User.DHCStudentYCZ Extends (%Persistent, User.Abstract) [ SqlRowIdName = St_RowId, SqlTableName = DHC_StudentYCZ ]
{

/// 学号
Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

/// 学号索引
Index Code On StCode As Exact;

/// 姓名索引
Index Name On StName As Exact;

Storage Default
{
<Data name="DHCStudentYCZDefaultData">
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
<DataLocation>^User.DHCStudentYCZD</DataLocation>
<DefaultData>DHCStudentYCZDefaultData</DefaultData>
<IdLocation>^User.DHCStudentYCZD</IdLocation>
<IndexLocation>^User.DHCStudentYCZI</IndexLocation>
<StreamLocation>^User.DHCStudentYCZS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
