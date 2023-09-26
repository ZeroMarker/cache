/// Function:学生类（默认存储）
/// CreateDate:2023-9-13
/// Creator:蒋美林
Class User.DHCStudentJML Extends (%Persistent, User.Abstract) [ SqlRowIdName = St_RowId, SqlTableName = DHC_StudentJML ]
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

/// 性别索引
Index SexDR On StSexDR As Exact;

/// 学号+性别索引
Index CodeSexDR On (StCode As Exact, StSexDR As Exact);

Storage Default
{
<Data name="DHCStudentJMLDefaultData">
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
<DataLocation>^User.DHCStudentJMLD</DataLocation>
<DefaultData>DHCStudentJMLDefaultData</DefaultData>
<IdLocation>^User.DHCStudentJMLD</IdLocation>
<IndexLocation>^User.DHCStudentJMLI</IndexLocation>
<StreamLocation>^User.DHCStudentJMLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
