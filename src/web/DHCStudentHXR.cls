/// DHC_Student,类名User.DHCStudent 主键 St_RowID
/// 字段 St_Code,St_Name,St_Sex_DR(Ct_Sex),St_Dob(Date)
Class web.DHCStudentHXR Extends %Persistent [ SqlTableName = DHC_StudentHXR ]
{

/// 学号
Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_code ];

/// 姓名
Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = Ct_Sex ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Storage Default
{
<Data name="DHCStudentHXRDefaultData">
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
<DataLocation>^web.DHCStudentHXRD</DataLocation>
<DefaultData>DHCStudentHXRDefaultData</DefaultData>
<IdLocation>^web.DHCStudentHXRD</IdLocation>
<IndexLocation>^web.DHCStudentHXRI</IndexLocation>
<StreamLocation>^web.DHCStudentHXRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
