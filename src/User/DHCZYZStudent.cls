/// Fuction:学生表（默认存储）
/// CreateDate:2023-09-12
/// Creator:zhangyizhu
Class User.DHCZYZStudent Extends %Persistent [ SqlRowIdName = St_RowId, SqlTableName = DHCZYZ_Student ]
{

Relationship ChildCourse As DHCZYZStuCourse [ Cardinality = children, Inverse = StuParRef ];

/// 学号
Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDr As CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

/// 学号索引
Index Code On StCode As Exact;

/// 姓名索引
Index Name On StName As Exact;

Storage Default
{
<Data name="DHCZYZStudentDefaultData">
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
<Value>StSexDr</Value>
</Value>
<Value name="5">
<Value>StDob</Value>
</Value>
</Data>
<DataLocation>^User.DHCZYZStudentD</DataLocation>
<DefaultData>DHCZYZStudentDefaultData</DefaultData>
<IdLocation>^User.DHCZYZStudentD</IdLocation>
<IndexLocation>^User.DHCZYZStudentI</IndexLocation>
<StreamLocation>^User.DHCZYZStudentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
