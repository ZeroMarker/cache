/// Function:学生类（默认存储）
/// CreateDate:2023-09-12
/// Creator:谢海洋
Class User.DHCStudentXHY Extends %Persistent [ SqlTableName = DHC_StudentXHY ]
{

Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Storage Default
{
<Data name="DHCStudentXHYDefaultData">
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
<DataLocation>^User.DHCStudentXHYD</DataLocation>
<DefaultData>DHCStudentXHYDefaultData</DefaultData>
<IdLocation>^User.DHCStudentXHYD</IdLocation>
<IndexLocation>^User.DHCStudentXHYI</IndexLocation>
<StreamLocation>^User.DHCStudentXHYS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
