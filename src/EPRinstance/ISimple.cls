Class EPRinstance.ISimple Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxForLink On (EpisodeID, TemplateID, SimpleItemCode, InstanceDataID) [ Unique ];

Index IdxForUpdate On (InstanceDataID, SimpleItemCode) [ Unique ];

Property ChartItemID As %String(TRUNCATE = 1);

Property DataValue As %String(MAXLEN = 32000, TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property ListNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property SimpleItemCode As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property ValueCode As %String(MAXLEN = 500, TRUNCATE = 1);

Query SelecSimple(APatientID As %String, AInstanceDataID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,PatientID:%String,TemplateID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_ISimple_SelecSimple, SqlProc ]
{
 SELECT ID,PatientID, TemplateID
 FROM EPRinstance.ISimple
 where PatientID= :APatientID
 and InstanceDataID =:AInstanceDataID
 ORDER BY ID
}

Storage Default
{
<Data name="ISimpleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceDataID</Value>
</Value>
<Value name="3">
<Value>SimpleItemCode</Value>
</Value>
<Value name="4">
<Value>TemplateID</Value>
</Value>
<Value name="5">
<Value>ChartItemID</Value>
</Value>
<Value name="6">
<Value>DataValue</Value>
</Value>
<Value name="7">
<Value>EpisodeID</Value>
</Value>
<Value name="8">
<Value>ListNo</Value>
</Value>
<Value name="9">
<Value>PatientID</Value>
</Value>
<Value name="10">
<Value>TemplateVersion</Value>
</Value>
<Value name="11">
<Value>ValueCode</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.ISimpleD</DataLocation>
<DefaultData>ISimpleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.ISimpleD</IdLocation>
<IndexLocation>^DHCEPRI.ISimpleI</IndexLocation>
<StreamLocation>^DHCEPRI.ISimpleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
