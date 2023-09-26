///     
Class dbo.TCTempRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = TC_TempRecord, StorageStrategy = Default ]
{

/// Foreign Key FKTTempRecordAddUser created via DDL
ForeignKey FKTTempRecordAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TTempRecordAddUser ];

/// Foreign Key FKTempRecordCollUser created via DDL
ForeignKey FKTempRecordCollUser(CollectUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TempRecordCollUser ];

/// Foreign Key FKTempRecordDevice created via DDL
ForeignKey FKTempRecordDevice(DeviceDR) References dbo.BTDevice(PKBTDEVICE) [ SqlName = FK_TempRecordDevice ];

/// Foreign Key FKTempRecordWarningLevel created via DDL
ForeignKey FKTempRecordWarningLevel(WarningLevelDR) References dbo.BTTCWarningLevel(PKBTTCWARNINGLEVEL) [ SqlName = FK_TempRecordWarningLevel ];

/// Foreign Key FKTempRecordWorkGroup created via DDL
ForeignKey FKTempRecordWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_TempRecordWorkGroup ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexMaster On (DeviceDR, CollectDate, CollectTime) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKTCTEMPRECORD On RowID [ PrimaryKey, SqlName = PK_TC_TEMPRECORD, Type = index, Unique ];

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
<Data name="TCTempRecordDefaultData">
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
<DataLocation>^dbo.TCTempRecordD</DataLocation>
<DefaultData>TCTempRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.TCTempRecordD</IdLocation>
<IndexLocation>^dbo.TCTempRecordI</IndexLocation>
<StreamLocation>^dbo.TCTempRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
