/// Function: 学生表（默认Storage）
/// CreateDate: 2023-09-12
/// Creator: 魏方茜
Class User.wfqClass2 Extends (%Persistent, User.Abstract) [ SqlRowIdName = St_RowId, SqlTableName = DHC_Studentwfq ]
{

/// 学号
Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Storage Default
{
<Data name="wfqClass2DefaultData">
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
<DataLocation>^User.wfqClass2D</DataLocation>
<DefaultData>wfqClass2DefaultData</DefaultData>
<IdLocation>^User.wfqClass2D</IdLocation>
<IndexLocation>^User.wfqClass2I</IndexLocation>
<StreamLocation>^User.wfqClass2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
