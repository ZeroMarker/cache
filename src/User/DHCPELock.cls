/// Description：体检锁
/// Creator：wangguoying
Class User.DHCPELock Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_Lock ]
{

Parameter ClassName = "User.DHCPELock";

/// 业务类型 AR:报告初审  MAR:报告复审
Property BusType As %Library.String(COLLATION = "AlphaUp", VALUELIST = ",AR,MAR") [ Required, SqlColumnNumber = 2, SqlFieldName = L_BusType ];

Property Computer As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = L_Computer ];

Property ComputerName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = L_Computer_Name ];

/// 业务ID
Property BusId As %Library.String(COLLATION = "EXACT", TRUNCATE = 1) [ Required, SqlColumnNumber = 5, SqlFieldName = L_BusId ];

/// Date Stamp
Property LockDate As %Library.Date [ InitialExpression = {+$H}, Required, SqlColumnNumber = 6, SqlFieldName = L_LockDate ];

Property LockTime As %Library.Time [ InitialExpression = {$p($H,",",2)}, Required, SqlColumnNumber = 7, SqlFieldName = L_LockTime ];

/// 登录科室
Property LoginLoc As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = L_Login_Loc ];

Property SessionId As %Library.String(COLLATION = "EXACT", TRUNCATE = 1) [ Required, SqlColumnNumber = 9, SqlFieldName = L_SessionId ];

Property UserDR As %Library.String(TRUNCATE = 1) [ Required, SqlColumnNumber = 10, SqlFieldName = L_User_DR ];

Index Lock On (BusType, BusId, SessionId) [ Unique ];

Index IndOfLocUserCpTypeID On (LoginLoc, UserDR, Computer, BusType, BusId);

Index SessionId On SessionId;

Storage Default
{
<Data name="DHCPELockDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BusType</Value>
</Value>
<Value name="3">
<Value>Computer</Value>
</Value>
<Value name="4">
<Value>ComputerName</Value>
</Value>
<Value name="5">
<Value>BusId</Value>
</Value>
<Value name="6">
<Value>LockDate</Value>
</Value>
<Value name="7">
<Value>LockTime</Value>
</Value>
<Value name="8">
<Value>LoginLoc</Value>
</Value>
<Value name="9">
<Value>SessionId</Value>
</Value>
<Value name="10">
<Value>UserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPELockD</DataLocation>
<DefaultData>DHCPELockDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPELockD</IdLocation>
<IndexLocation>^User.DHCPELockI</IndexLocation>
<StreamLocation>^User.DHCPELockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
