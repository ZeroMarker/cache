///     
Class dbo.BTTCWarningParameter Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTTC_WarningParameter, StorageStrategy = Default ]
{

/// Foreign Key FKTempHumiWarningDevice created via DDL
ForeignKey FKTempHumiWarningDevice(DeviceDR) References dbo.BTDevice(PKBTDEVICE) [ SqlName = FK_TempHumiWarningDevice ];

/// Foreign Key FKTempHumiWarningLevel created via DDL
ForeignKey FKTempHumiWarningLevel(WarningLevelDR) References dbo.BTTCWarningLevel(PKBTTCWARNINGLEVEL) [ SqlName = FK_TempHumiWarningLevel ];

Index IndexMaster On (DeviceDR, WarningLevelDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTCWARNINGPARAMETER On RowID [ PrimaryKey, SqlName = PK_BTTC_WARNINGPARAMETER, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property DeviceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property WarningLevelDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TempLow As %Library.Float [ SqlColumnNumber = 5 ];

Property TempHigh As %Library.Float [ SqlColumnNumber = 6 ];

Property HumiLow As %Library.Float [ SqlColumnNumber = 7 ];

Property HumiHigh As %Library.Float [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTTCWarningParameterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeviceDR</Value>
</Value>
<Value name="3">
<Value>WarningLevelDR</Value>
</Value>
<Value name="4">
<Value>TempLow</Value>
</Value>
<Value name="5">
<Value>TempHigh</Value>
</Value>
<Value name="6">
<Value>HumiLow</Value>
</Value>
<Value name="7">
<Value>HumiHigh</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTCWarningParameterD</DataLocation>
<DefaultData>BTTCWarningParameterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTCWarningParameterD</IdLocation>
<IndexLocation>^dbo.BTTCWarningParameterI</IndexLocation>
<StreamLocation>^dbo.BTTCWarningParameterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
