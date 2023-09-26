/// Foution：学生类（默认存储)
/// CreateDate:2023-09-12
/// Creator:翁瑞珍
Class User.DHCAStudent Extends (%Persistent, User.Abstract) [ SqlRowIdName = St_Rowid, SqlTableName = DHCA_Student ]
{

/// --父表建立与子表的关系
Relationship childCourse As User.DHCAStudentCourse [ Cardinality = children, Inverse = StudentParRef ];

/// 学号
Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Index Code On StCode As Exact;

Index Name On StName As Exact;

Index SexDR On StSexDR As Exact;

Index Dob On StDob As Exact;

Storage Default
{
<Data name="DHCAStudentDefaultData">
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
<DataLocation>^User.DHCAStudentD</DataLocation>
<DefaultData>DHCAStudentDefaultData</DefaultData>
<IdLocation>^User.DHCAStudentD</IdLocation>
<IndexLocation>^User.DHCAStudentI</IndexLocation>
<StreamLocation>^User.DHCAStudentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
