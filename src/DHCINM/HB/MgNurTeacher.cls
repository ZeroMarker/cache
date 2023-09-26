/// Creater:wangpf
/// Descriptions:带教老师
/// Date:2020-07-02
Class DHCINM.HB.MgNurTeacher Extends %Persistent
{

/// 年度
Property TeacherYear As %Integer [ SqlColumnNumber = 2, SqlFieldName = Teacher_Year ];

/// 病区
Property TeacherWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 3, SqlFieldName = Teacher_Ward ];

/// 人员
Property TeacherPer As CF.DHCINM.HR.Persons [ SqlColumnNumber = 4, SqlFieldName = Teacher_Per ];

/// 备注
Property TeacherRemark As %String [ SqlColumnNumber = 5, SqlFieldName = Teacher_Remark ];

Index YearWard On (TeacherYear, TeacherWard);

Index Per On (TeacherPer, TeacherYear, TeacherWard);

Storage Default
{
<Data name="MgNurTeacherDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TeacherYear</Value>
</Value>
<Value name="3">
<Value>TeacherWard</Value>
</Value>
<Value name="4">
<Value>TeacherPer</Value>
</Value>
<Value name="5">
<Value>TeacherRemark</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgNurTeacherD</DataLocation>
<DefaultData>MgNurTeacherDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgNurTeacherD</IdLocation>
<IndexLocation>^DHCINM.HB.MgNurTeacherI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgNurTeacherS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
