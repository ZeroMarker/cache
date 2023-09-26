Class User.LXW.DHCStudent Extends %Persistent [ SqlTableName = DHC_Student ]
{

// 学号

Property stCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

// 也可以在类旁边的Class表格处/storage处直接改

// 姓名

Property StName As %String [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

// 性别

Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_SexDR ];

// 出生日期

Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Storage Default
{
<Data name="DHCStudentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>stCode</Value>
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
<DataLocation>^User.LXW.DHCStudentD</DataLocation>
<DefaultData>DHCStudentDefaultData</DefaultData>
<IdLocation>^User.LXW.DHCStudentD</IdLocation>
<IndexLocation>^User.LXW.DHCStudentI</IndexLocation>
<SqlRowIdName>St_RowId</SqlRowIdName>
<StreamLocation>^User.LXW.DHCStudentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
