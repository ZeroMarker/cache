/// 病人和项目关联关系表
Class CSM.PatientProject Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 剔除日期时间
Property ElimDateTime As %String(MAXLEN = 19, TRUNCATE = 1);

/// 剔除原因
Property ElimReason As %String(MAXLEN = 500, TRUNCATE = 1);

/// 剔除操作用户ID
Property ElimUserID As %Integer;

/// 病人进入项目的日期时间
Property JoinDateTime As %String(MAXLEN = 19, TRUNCATE = 1) [ Required ];

/// 病人被加入项目时的主要诊断
Property JoinDiagnos As %String(MAXLEN = 100, TRUNCATE = 1);

/// 把病人加入项目的用户ID
Property JoinUserID As %Integer [ Required ];

/// 病人状态：在组1/剔除0/失访-1
Property Status As %String(MAXLEN = 2, TRUNCATE = 1) [ Required ];

/// 病人组ID
Property PatGrpID As %Integer [ Required ];

/// 病人ID
Property PatientID As %Integer [ Required ];

/// 病人在项目中的编号
Property PatientNo As %String(TRUNCATE = 1);

/// 病人所在项目组ID
Property ProjGrpID As %Integer [ Required ];

Storage Default
{
<Data name="PatientProjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ElimDateTime</Value>
</Value>
<Value name="3">
<Value>ElimReason</Value>
</Value>
<Value name="4">
<Value>ElimUserID</Value>
</Value>
<Value name="5">
<Value>JoinDateTime</Value>
</Value>
<Value name="6">
<Value>JoinDiagnos</Value>
</Value>
<Value name="7">
<Value>JoinUserID</Value>
</Value>
<Value name="8">
<Value>PatGrpID</Value>
</Value>
<Value name="9">
<Value>PatientID</Value>
</Value>
<Value name="10">
<Value>PatientNo</Value>
</Value>
<Value name="11">
<Value>ProjGrpID</Value>
</Value>
<Value name="12">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^CSM.PatientProjectD</DataLocation>
<DefaultData>PatientProjectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.PatientProjectD</IdLocation>
<IndexLocation>^CSM.PatientProjectI</IndexLocation>
<StreamLocation>^CSM.PatientProjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
