/// 名称: User.DHCStudentDef.cls
/// 描述: 学生默认存储表
/// 编写者: 黄钰
/// 编写日期: 2023-09-12
Class User.DHCStudentDef Extends %Persistent [ SqlRowIdName = St_RowId, SqlTableName = DHC_Student_Def ]
{

/// 学号
Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As User.CTSex [ Required, SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ Required, SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Index Code On StCode As Exact;

Index Name On StName As Exact;

Storage Default
{
<Data name="DHCStudentDefDefaultData">
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
<DataLocation>^User.DHCStudentDefD</DataLocation>
<DefaultData>DHCStudentDefDefaultData</DefaultData>
<IdLocation>^User.DHCStudentDefD</IdLocation>
<IndexLocation>^User.DHCStudentDefI</IndexLocation>
<StreamLocation>^User.DHCStudentDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
