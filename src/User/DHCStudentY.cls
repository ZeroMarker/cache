/// Function:学生类(默认存储)
/// CreateDate:2023-09-12
/// Creator:yanghongrui
Class User.DHCStudentY Extends (%Persistent, User.Abstract) [ SqlRowIdName = St_RowId, SqlTableName = DHC_StudentY ]
{

Relationship ChildCourse As DHCStudentCourseR [ Cardinality = children, Inverse = ParRef ];

/// 字段：字段 St_Code,St_Name,St_Sex_DR(Ct_Sex),St_Dob(Date)
/// 学号
Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

/// 对代码进行唯一性限制
/// 学号索引
Index Code On StCode As Exact;

/// 姓名索引
Index Name On StName As Exact;

/// 性别索引
Index SexDx On StSexDR As Exact;

Storage Default
{
<Data name="DHCStudentYDefaultData">
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
<DataLocation>^User.DHCStudentYD</DataLocation>
<DefaultData>DHCStudentYDefaultData</DefaultData>
<IdLocation>^User.DHCStudentYD</IdLocation>
<IndexLocation>^User.DHCStudentYI</IndexLocation>
<SqlRowIdName>St_RowId</SqlRowIdName>
<StreamLocation>^User.DHCStudentYS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
