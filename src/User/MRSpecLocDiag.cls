Class User.MRSpecLocDiag Extends %Persistent [ SqlTableName = MR_SpecLocDiag ]
{

Index IndexPat On (PatientDR, DiagCatDR);

Index IndexAdm On (AdmDR, DiagCatDR);

Index IndexDateTime On (PatientDR, DiagCatDR, InsertDate, InsertTime);

/// 指向创建的就诊记录
Property AdmDR As PAAdm;

Property PatientDR As PAPatMas;

/// 表单项目分类指向
Property DiagCatDR As DHCSpecLocDiagCat [ Required ];

/// 填写用户
Property UserDR As SSUser;

/// 填写日期
Property InsertDate As %Date;

/// 填写时间
Property InsertTime As %Time;

/// 更新用户
Property UpdateUserDR As SSUser;

/// 自定义流水号,用于自动定义关联业务场景，比如医嘱流水号（ord|SerialNum）,患者流水号(pat|no)等；自定义流水号应由自定义类型|自定义编号组成，用于区分唯一性
Property CustomSerialNum As %String;

/// 有效标识
Property Active As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N");

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

Storage Default
{
<Data name="MRSpecLocDiagDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdmDR</Value>
</Value>
<Value name="3">
<Value>PatientDR</Value>
</Value>
<Value name="4">
<Value>DiagCatDR</Value>
</Value>
<Value name="5">
<Value>UserDR</Value>
</Value>
<Value name="6">
<Value>InsertDate</Value>
</Value>
<Value name="7">
<Value>InsertTime</Value>
</Value>
<Value name="8">
<Value>UpdateUserDR</Value>
</Value>
<Value name="9">
<Value>CustomSerialNum</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^User.MRSpecLocDiagD</DataLocation>
<DefaultData>MRSpecLocDiagDefaultData</DefaultData>
<IdLocation>^User.MRSpecLocDiagD</IdLocation>
<IndexLocation>^User.MRSpecLocDiagI</IndexLocation>
<StreamLocation>^User.MRSpecLocDiagS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
