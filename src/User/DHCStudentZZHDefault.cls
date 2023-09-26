/// Description:	学生类 (DefaultStorage)
/// CreateDate:	2023年9月12日
/// Creator:		赵子豪
Class User.DHCStudentZZHDefault Extends %Persistent [ SqlRowIdName = St_RowID, SqlTableName = DHC_StudentZZH1 ]
{

/// 代码
Property StCode As %String [ SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Index Code On StCode As Exact;

Index Name On StName As Exact;

Storage Default
{
<Data name="DHCStudentZZHDefaultDefaultData">
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
<DataLocation>^User.DHCStudentZZHDefaultD</DataLocation>
<DefaultData>DHCStudentZZHDefaultDefaultData</DefaultData>
<IdLocation>^User.DHCStudentZZHDefaultD</IdLocation>
<IndexLocation>^User.DHCStudentZZHDefaultI</IndexLocation>
<StreamLocation>^User.DHCStudentZZHDefaultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
