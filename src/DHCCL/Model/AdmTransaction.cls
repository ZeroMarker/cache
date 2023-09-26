/// 转科
Class DHCCL.Model.AdmTransaction Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = AdmTransaction ]
{

/// 就诊
Property Admission As DHCCL.Model.Admission [ Required, SqlColumnNumber = 2 ];

/// 入科日期
Property StartDate As %Date [ SqlColumnNumber = 3 ];

/// 入科时间
Property StartTime As %Time [ SqlColumnNumber = 4 ];

/// 出科日期
Property EndDate As %Date [ SqlColumnNumber = 5 ];

/// 出科时间
Property EndTime As %Time [ SqlColumnNumber = 6 ];

Property CareProv As DHCCL.Config.CareProvider [ SqlColumnNumber = 7 ];

Property Location As DHCCL.Config.Location [ SqlColumnNumber = 8 ];

Property Room As DHCCL.Config.Room [ SqlColumnNumber = 9 ];

Property Ward As DHCCL.Config.Ward [ SqlColumnNumber = 10 ];

Property Bed As DHCCL.Config.Bed [ SqlColumnNumber = 11 ];

Property ExternalID As %String [ SqlColumnNumber = 12 ];

Index Adm On Admission;

Index Ext On ExternalID;

Storage Default
{
<Data name="AdmTransactionDefaultData">
<Value name="1">
<Value>Admission</Value>
</Value>
<Value name="2">
<Value>StartDate</Value>
</Value>
<Value name="3">
<Value>StartTime</Value>
</Value>
<Value name="4">
<Value>EndDate</Value>
</Value>
<Value name="5">
<Value>EndTime</Value>
</Value>
<Value name="6">
<Value>CareProv</Value>
</Value>
<Value name="7">
<Value>Location</Value>
</Value>
<Value name="8">
<Value>Room</Value>
</Value>
<Value name="9">
<Value>Ward</Value>
</Value>
<Value name="10">
<Value>Bed</Value>
</Value>
<Value name="11">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Model.AdmTransactionD</DataLocation>
<DefaultData>AdmTransactionDefaultData</DefaultData>
<IdLocation>^DHCCL.Model.AdmTransactionD</IdLocation>
<IndexLocation>^DHCCL.Model.AdmTransactionI</IndexLocation>
<StreamLocation>^DHCCL.Model.AdmTransactionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
