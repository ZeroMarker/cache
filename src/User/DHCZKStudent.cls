Class User.DHCZKStudent Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_ZKStudent ]
{

/// 学号
Property StCode As %String [ SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Storage Default
{
<Data name="DHCZKStudentDefaultData">
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
<DataLocation>^User.DHCZKStudentD</DataLocation>
<DefaultData>DHCZKStudentDefaultData</DefaultData>
<IdLocation>^User.DHCZKStudentD</IdLocation>
<IndexLocation>^User.DHCZKStudentI</IndexLocation>
<StreamLocation>^User.DHCZKStudentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
