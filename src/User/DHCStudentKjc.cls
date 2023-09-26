/// Function:学生类
/// CreateDate:2023-09-12
/// Creator:孔晋川
Class User.DHCStudentKjc Extends (%Persistent, User.Abstract) [ SqlRowIdName = St_RowId, SqlTableName = DHC_StudentKjc ]
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
<Data name="DHCStudentKjcDefaultData">
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
<DataLocation>^User.DHCStudentKjcD</DataLocation>
<DefaultData>DHCStudentKjcDefaultData</DefaultData>
<IdLocation>^User.DHCStudentKjcD</IdLocation>
<IndexLocation>^User.DHCStudentKjcI</IndexLocation>
<StreamLocation>^User.DHCStudentKjcS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
