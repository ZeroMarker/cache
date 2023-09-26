Class DHCEPRRBAC.INST.FSAuthorizationGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 	申请相关
/// 批准日期
Property AppointDate As %Date;

/// 批准时间
Property AppointTime As %Time;

/// 截止日期
Property AppointEndDate As %Date;

/// 截止时间
Property AppointEndTime As %Time;

/// 批准人
Property AppointUserID As %String(TRUNCATE = 1);

/// 申请人
Property RequestUserID As %String(TRUNCATE = 1);

/// 申请科室
Property RequestDept As %String(TRUNCATE = 1);

/// 申请安全组
Property RequestSSGroup As %String(TRUNCATE = 1);

/// 发出申请的日期
Property RequestDate As %Date;

/// 发出申请的时间
Property RequestTime As %Time;

Property RoleID As %String(TRUNCATE = 1);

Property OperationID As %String(TRUNCATE = 1);

/// 申请的系统类型，FS - 病案归档
Property EPRAction As %String(TRUNCATE = 1);

/// 授权类型,0-授权给个人,1-授权给科室
Property AppointType As %String(TRUNCATE = 1);

/// 授权类型(N:正常未授权; R:拒绝; F:完成授权; D:以默认权限通过)
Property AppointStatus As %String(TRUNCATE = 1);

Property AppointComment As %String(TRUNCATE = 1);

Property RequestSpan As %String(TRUNCATE = 1);

Property RequestComment As %String(TRUNCATE = 1);

Relationship TheFSAuthorization As DHCEPRRBAC.INST.FSAuthorization [ Cardinality = children, Inverse = TheFSAuthorizationGroup ];

Index IdxAStatus On (AppointStatus, RequestDate, RequestTime);

Index IdxRequestDt On (AppointStatus, RequestUserID, RequestDate, RequestTime);

Index IdxRequestExpire On (AppointStatus, RequestUserID, AppointEndDate, AppointEndTime);

Index IdxRequestLoc On (AppointStatus, RequestDept, RequestDate, RequestTime);

Index IdxRequestSSGroup On (AppointStatus, RequestSSGroup, RequestDate, RequestTime);

Index IdxAppointDt On (AppointStatus, AppointUserID, AppointDate, AppointTime);

Index IdxRequestUser On (AppointStatus, RequestUserID);

// 2017-3-17 by yangpeng

Index IdxAuthorization On (AppointDate, AppointTime);

Storage Default
{
<Data name="FSAuthorizationGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AppointDate</Value>
</Value>
<Value name="3">
<Value>AppointTime</Value>
</Value>
<Value name="4">
<Value>AppointEndDate</Value>
</Value>
<Value name="5">
<Value>AppointEndTime</Value>
</Value>
<Value name="6">
<Value>AppointUserID</Value>
</Value>
<Value name="7">
<Value>RequestUserID</Value>
</Value>
<Value name="8">
<Value>RequestDept</Value>
</Value>
<Value name="9">
<Value>RequestSSGroup</Value>
</Value>
<Value name="10">
<Value>RequestDate</Value>
</Value>
<Value name="11">
<Value>RequestTime</Value>
</Value>
<Value name="12">
<Value>RoleID</Value>
</Value>
<Value name="13">
<Value>EPRAction</Value>
</Value>
<Value name="14">
<Value>AppointType</Value>
</Value>
<Value name="15">
<Value>AppointStatus</Value>
</Value>
<Value name="16">
<Value>OperationID</Value>
</Value>
<Value name="17">
<Value>AppointComment</Value>
</Value>
<Value name="18">
<Value>RequestComment</Value>
</Value>
<Value name="19">
<Value>RequestRange</Value>
</Value>
<Value name="20">
<Value>RequestSpan</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.INST.FSAuthGD</DataLocation>
<DefaultData>FSAuthorizationGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.INST.FSAuthGD</IdLocation>
<IndexLocation>^DHCEPRRBAC.INST.FSAuthGI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.INST.FSAuthGS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
