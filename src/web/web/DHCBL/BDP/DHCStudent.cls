/// Creator：夏天
/// Description：学生表
Class web.web.DHCBL.BDP.DHCStudent Extends %Persistent [ SqlTableName = DHC_Student ]
{

/// 学号
Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As CtSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Storage Default
{
<Data name="DHCStudentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.web.DHCBL.BDP.DHCStudentD</DataLocation>
<DefaultData>DHCStudentDefaultData</DefaultData>
<IdLocation>^web.web.DHCBL.BDP.DHCStudentD</IdLocation>
<IndexLocation>^web.web.DHCBL.BDP.DHCStudentI</IndexLocation>
<StreamLocation>^web.web.DHCBL.BDP.DHCStudentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
