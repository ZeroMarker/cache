/// function:建立学生表(默认存储)
/// creator：蔡耀伟
/// date：2023-09-13
Class User.DHCStudentCYW Extends (%Persistent, User.Abstract) [ SqlRowIdName = St_RowId, SqlTableName = DHC_StudentCYW ]
{

Relationship ChildCourse As DHCStudentCourseCYW [ Cardinality = children, Inverse = ParRef ];

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

/// 性别索引
Index SexDR On StSexDR As Exact;

/// 学号+性别索引
Index CodeSexDR On (StCode As Exact, StSexDR As Exact);

Storage Default
{
<Data name="DHCStudentCYWDefaultData">
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
<DataLocation>^User.DHCStudentCYWD</DataLocation>
<DefaultData>DHCStudentCYWDefaultData</DefaultData>
<IdLocation>^User.DHCStudentCYWD</IdLocation>
<IndexLocation>^User.DHCStudentCYWI</IndexLocation>
<StreamLocation>^User.DHCStudentCYWS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
