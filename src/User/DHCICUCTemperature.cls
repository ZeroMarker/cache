Class User.DHCICUCTemperature Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ICUCT_RowId, SqlTableName = DHC_ICUC_Temperature, StorageStrategy = CacheStorage ]
{

Property ICUCTRecordItemCode As %String [ SqlColumnNumber = 2, SqlFieldName = ICUCT_RecordItemCode ];

Property ICUCTObservationItemCode As %String [ SqlColumnNumber = 3, SqlFieldName = ICUCT_ObservationItemCode ];

Property ICUCTDayFactor As %Float [ SqlColumnNumber = 4, SqlFieldName = ICUCT_DayFactor ];

Property ICUCTStartTime As %Time [ SqlColumnNumber = 5, SqlFieldName = ICUCT_StartTime ];

Property ICUCTValidSpan As %Time [ SqlColumnNumber = 6, SqlFieldName = ICUCT_ValidSpan ];

Property ICUCTExtraUpperThreshold As %Float [ SqlColumnNumber = 7, SqlFieldName = ICUCT_ExtraUpperThreshold ];

Property ICUCTExtraInterval As %Time [ SqlColumnNumber = 8, SqlFieldName = ICUCT_ExtraInterval ];

Property ICUCTType As %String(DISPLAYLIST = ",RecordItem,Arrange", MAXLEN = 10, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",R,A") [ SqlColumnNumber = 9, SqlFieldName = ICUCT_Type ];

Property ICUCTSummaryInsertTime As %Time [ SqlColumnNumber = 10, SqlFieldName = ICUCT_SummaryInsertTime ];

Property ICUCTCtlocId As %String [ SqlColumnNumber = 11, SqlFieldName = ICUCT_CtlocId ];

// Property ICUCTStrategy As %String(DISPLAYLIST = ",Normal,Summary", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,S") [ SqlColumnNumber = 12, SqlFieldName = ICUCT_Strategy ];

Property ICUCTStrategy As %String [ SqlColumnNumber = 12, SqlFieldName = ICUCT_Strategy ];

Property ICUCTSpareIcucriCode As %String [ SqlColumnNumber = 13, SqlFieldName = ICUCT_SpareIcucriCode ];

Storage CacheStorage
{
<Data name="DHCICUTemperatureClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCICUTemperatureDefaultData">
<Value name="1">
<Value>ICUCTRecordItemCode</Value>
</Value>
<Value name="2">
<Value>ICUCTObservationItemCode</Value>
</Value>
<Value name="3">
<Value>ICUCTDayFactor</Value>
</Value>
<Value name="4">
<Value>ICUCTStartTime</Value>
</Value>
<Value name="5">
<Value>ICUCTValidSpan</Value>
</Value>
<Value name="6">
<Value>ICUCTExtraUpperThreshold</Value>
</Value>
<Value name="7">
<Value>ICUCTExtraInterval</Value>
</Value>
<Value name="8">
<Value>ICUCTType</Value>
</Value>
<Value name="9">
<Value>ICUCTSummaryInsertTime</Value>
</Value>
<Value name="10">
<Value>ICUCTCtlocId</Value>
</Value>
<Value name="11">
<Value>ICUCTStrategy</Value>
</Value>
<Value name="12">
<Value>ICUCTSpareIcucriCode</Value>
</Value>
</Data>
<DataLocation>^DHCICUC("Temperature")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCICUC("Temperature")</IdLocation>
<IndexLocation>^User.DHCICUCTemperatureI</IndexLocation>
<StreamLocation>^User.DHCICUCTemperatureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
