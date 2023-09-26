///     
Class dbo.TCHumidityRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = TC_HumidityRecord, StorageStrategy = Default ]
{

/// Foreign Key FKHumidityREcordWarningLevel created via DDL
ForeignKey FKHumidityREcordWarningLevel(WarningLevelDR) References dbo.BTTCWarningLevel(PKBTTCWARNINGLEVEL) [ SqlName = FK_HumidityREcordWarningLevel ];

/// Foreign Key FKHumidityRecordAddUser created via DDL
ForeignKey FKHumidityRecordAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_HumidityRecordAddUser ];

/// Foreign Key FKHumidityRecordCollUser created via DDL
ForeignKey FKHumidityRecordCollUser(CollectUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_HumidityRecordCollUser ];

/// Foreign Key FKHumidityRecordDevice created via DDL
ForeignKey FKHumidityRecordDevice(DeviceDR) References dbo.BTDevice(PKBTDEVICE) [ SqlName = FK_HumidityRecordDevice ];

/// Foreign Key FKHumidityRecordWorkGroup created via DDL
ForeignKey FKHumidityRecordWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_HumidityRecordWorkGroup ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexMaster On (DeviceDR, CollectDate, CollectTime) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKTCHUMIDITYRECORD On RowID [ PrimaryKey, SqlName = PK_TC_HUMIDITYRECORD, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property DeviceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property CollectDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property CollectTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property CollectType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 9 ];

Property CollectUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property Result As %Library.Float [ SqlColumnNumber = 12 ];

Property WarningLevelDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="TCHumidityRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeviceDR</Value>
</Value>
<Value name="3">
<Value>CollectDate</Value>
</Value>
<Value name="4">
<Value>CollectTime</Value>
</Value>
<Value name="5">
<Value>WorkGroupDR</Value>
</Value>
<Value name="6">
<Value>AddDate</Value>
</Value>
<Value name="7">
<Value>AddTime</Value>
</Value>
<Value name="8">
<Value>CollectType</Value>
</Value>
<Value name="9">
<Value>CollectUserDR</Value>
</Value>
<Value name="10">
<Value>AddUserDR</Value>
</Value>
<Value name="11">
<Value>Result</Value>
</Value>
<Value name="12">
<Value>WarningLevelDR</Value>
</Value>
</Data>
<DataLocation>^dbo.TCHumidityRecordD</DataLocation>
<DefaultData>TCHumidityRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.TCHumidityRecordD</IdLocation>
<IndexLocation>^dbo.TCHumidityRecordI</IndexLocation>
<StreamLocation>^dbo.TCHumidityRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
