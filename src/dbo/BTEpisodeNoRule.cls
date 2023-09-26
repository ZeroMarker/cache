Class dbo.BTEpisodeNoRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_EpisodeNoRule, StorageStrategy = Default ]
{

Index IndexMaster On (WGMCode, AdmissionType, Specimen, TestSetCode) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTestSet On (WGMCode, AdmissionType, TestSetCode) [ SqlName = Index_TestSet, Type = index ];

Index IndexSpecimen On (WGMCode, AdmissionType, Specimen) [ SqlName = Index_Specimen, Type = index ];

/// DDL Primary Key Specification
Index PKBTEPISODENORULE On RowID [ PrimaryKey, SqlName = PK_BT_EPISODENORULE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WGMCode As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 3 ];

Property AdmissionType As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

Property Specimen As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

Property TestSetCode As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property SttEpisodeNo As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 7 ];

Property EndEpisodeNo As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTEpisodeNoRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WGMCode</Value>
</Value>
<Value name="3">
<Value>AdmissionType</Value>
</Value>
<Value name="4">
<Value>Specimen</Value>
</Value>
<Value name="5">
<Value>TestSetCode</Value>
</Value>
<Value name="6">
<Value>SttEpisodeNo</Value>
</Value>
<Value name="7">
<Value>EndEpisodeNo</Value>
</Value>
</Data>
<DataLocation>^dbo.BTEpisodeNoRuleD</DataLocation>
<DefaultData>BTEpisodeNoRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTEpisodeNoRuleD</IdLocation>
<IndexLocation>^dbo.BTEpisodeNoRuleI</IndexLocation>
<StreamLocation>^dbo.BTEpisodeNoRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
