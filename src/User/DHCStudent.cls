/// Function:学生类（默认存储）
/// CreateTime:2023-09-12
/// Creator:YiWenbo
/// 建立学生表表名DHC_Student,类名User.DHCStudent 主键 St_RowId字段 St_Code,St_Name,St_Sex_DR(Ct_Sex),St_Dob(Date)
Class User.DHCStudent Extends (%Persistent, User.Abstract) [ SqlRowIdName = St_RowId, SqlTableName = DHC_Student ]
{

Relationship ChildCourse As DHCStudentCourseYWB [ Cardinality = children, Inverse = ParRef ];

Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

Property StSexDR As User.CTSex [ Required, SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

Property StDob As %Date [ Required, SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Index SexDR On StSexDR As Exact;

Index Dob On StDob As Exact;

Storage Default
{
<Data name="DHCStudentDefaultData">
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
<DataLocation>^User.DHCStudentD</DataLocation>
<DefaultData>DHCStudentDefaultData</DefaultData>
<IdLocation>^User.DHCStudentD</IdLocation>
<IndexLocation>^User.DHCStudentI</IndexLocation>
<StreamLocation>^User.DHCStudentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
