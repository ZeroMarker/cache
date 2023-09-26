/// Function:学生类（默认存储）
/// CreateDate:2023-09-13
/// Creator:zhailihong
/// 为什么要加user.abstract？
/// 修改rowid有两个位置，一个是class中的sqlrowidname，一个是storage中的sqlrowidname
/// required信息为必填项
Class User.DHChomework2 Extends (%Persistent, User.Abstract) [ SqlRowIdName = St_Rowid, SqlTableName = DHC_homework2 ]
{

/// 字段 St_Code,St_Name,St_Sex_DR(Ct_Sex),St_Dob(Date)
/// 学号
Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

/// Global(Master Map)：^DHCSTUDENT({St_RowID})
/// Index：^DHCSTUDENT(0,"SEX",{St_Sex_DR},{St_RowID})
/// Index：^DHCSTUDENT(0,"DOB",{St_Dob},{St_RowID})
Storage Default
{
<Data name="DHChomework2DefaultData">
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
<DataLocation>^User.DHChomework2D</DataLocation>
<DefaultData>DHChomework2DefaultData</DefaultData>
<Description>
<![CDATA[Global(Master Map)：^DHCSTUDENT({St_RowID})
Index：^DHCSTUDENT(0,"SEX",{St_Sex_DR},{St_RowID})
Index：^DHCSTUDENT(0,"DOB",{St_Dob},{St_RowID})]]></Description>
<IdLocation>^User.DHChomework2D</IdLocation>
<IndexLocation>^User.DHChomework2I</IndexLocation>
<StreamLocation>^User.DHChomework2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
