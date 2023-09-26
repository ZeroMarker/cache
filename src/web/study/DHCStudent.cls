Class web.study.DHCStudent Extends (%Persistent, User.Abstract) [ SqlRowIdName = St_RowID, SqlTableName = DHC_Student ]
{

/// 崔兴阳 基础平台
/// 表名DHC_Student,类名User.DHCStudent 主键 St_RowID字段 
/// St_Code,St_Name,St_Sex_DR(Ct_Sex),St_Dob(Date) 
/// Global(Master Map)：^DHCSTUDENT({St_RowID})
/// Index：^DHCSTUDENT(0,"Name",{St_Name},{St_RowID})
/// Index：^DHCSTUDENT(0,"Code",{St_Code},{St_RowID})
Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

Property StDob As %Date [ SqlColumnNumber = 4, SqlFieldName = St_Dob ];

Property StSexDR As User.CTSex [ SqlColumnNumber = 5, SqlFieldName = St_Sex_DR ];

Index Name On StName As Exact;

Index Code On StCode As Exact;

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
<Value>StDob</Value>
</Value>
<Value name="5">
<Value>StSexDR</Value>
</Value>
</Data>
<DataLocation>^web.study.DHCStudentD</DataLocation>
<DefaultData>DHCStudentDefaultData</DefaultData>
<IdLocation>^web.study.DHCStudentD</IdLocation>
<IndexLocation>^web.study.DHCStudentI</IndexLocation>
<StreamLocation>^web.study.DHCStudentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
