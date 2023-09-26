/// creator: xbl
/// createdate: 2017/12/18
/// description: 带教老师管理
Class DHCNMG.Intern.MgTeacher Extends %Persistent
{

/// 带教老师
Property TeachPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Teach_PerDR ];

/// 科室
Property TeachWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 3, SqlFieldName = Teach_WardDR ];

/// 开始日期
Property TeachStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Teach_StDate ];

/// 结束日期
Property TeachEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Teach_EndDate ];

/// 备注
Property TeachRemark As %String [ SqlColumnNumber = 6, SqlFieldName = Teach_Remark ];

/// 创建人
Property TeachCrtUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 7, SqlFieldName = Teach_CrtUser ];

/// 创建日期
Property TeachCrtDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Teach_CrtDate ];

/// 创建时间
Property TeachCrtTime As %Time [ SqlColumnNumber = 9, SqlFieldName = Teach_CrtTime ];

Index Person On TeachPerDR;

Index Ward On TeachWardDR;

Storage Default
{
<Data name="MgTeacherDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TeachPerDR</Value>
</Value>
<Value name="3">
<Value>TeachWardDR</Value>
</Value>
<Value name="4">
<Value>TeachStDate</Value>
</Value>
<Value name="5">
<Value>TeachEndDate</Value>
</Value>
<Value name="6">
<Value>TeachRemark</Value>
</Value>
<Value name="7">
<Value>TeachCrtUser</Value>
</Value>
<Value name="8">
<Value>TeachCrtDate</Value>
</Value>
<Value name="9">
<Value>TeachCrtTime</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Intern.MgTeacherD</DataLocation>
<DefaultData>MgTeacherDefaultData</DefaultData>
<IdLocation>^DHCNMG.Intern.MgTeacherD</IdLocation>
<IndexLocation>^DHCNMG.Intern.MgTeacherI</IndexLocation>
<StreamLocation>^DHCNMG.Intern.MgTeacherS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
