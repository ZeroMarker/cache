Class DHCMGNUR.NarcoticDrugs Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property EmrDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property EmrTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

/// first nurse
Property EmrUser As %String(TRUNCATE = 1);

Property RecTyp As %String(TRUNCATE = 1);

Property RecWard As %String(TRUNCATE = 1);

Property Adm As %String(TRUNCATE = 1);

Property Batch As %String(TRUNCATE = 1);

Property Usage As %String(TRUNCATE = 1);

/// second nurse
Property CheUser As %String(TRUNCATE = 1);

/// reback nurse
Property RecUser As %String(TRUNCATE = 1);

Property DealMehtod As %String(MAXLEN = 3000, TRUNCATE = 1);

Property oeoreID As %String(TRUNCATE = 1);

Property ExecDate As %String(TRUNCATE = 1);

Property ExecTime As %String(TRUNCATE = 1);

Index oeordID On oeoreID;

Index Ward On (RecWard, Adm);

Index Adm On Adm;

Storage Default
{
<Data name="NarcoticDrugsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EmrDate</Value>
</Value>
<Value name="3">
<Value>EmrTime</Value>
</Value>
<Value name="4">
<Value>EmrUser</Value>
</Value>
<Value name="5">
<Value>EmrCode</Value>
</Value>
<Value name="6">
<Value>CheUser</Value>
</Value>
<Value name="7">
<Value>RecUser</Value>
</Value>
<Value name="8">
<Value>DealMehtod</Value>
</Value>
<Value name="9">
<Value>oeordid</Value>
</Value>
<Value name="10">
<Value>Batch</Value>
</Value>
<Value name="11">
<Value>Usage</Value>
</Value>
<Value name="12">
<Value>RecTyp</Value>
</Value>
<Value name="13">
<Value>RecWard</Value>
</Value>
<Value name="14">
<Value>oeoreID</Value>
</Value>
<Value name="15">
<Value>Adm</Value>
</Value>
<Value name="16">
<Value>ExecDate</Value>
</Value>
<Value name="17">
<Value>ExecTime</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.NarcoticDrugsD</DataLocation>
<DefaultData>NarcoticDrugsDefaultData</DefaultData>
<IdLocation>^DHCMGNUR.NarcoticDrugsD</IdLocation>
<IndexLocation>^DHCMGNUR.NarcoticDrugsI</IndexLocation>
<StreamLocation>^DHCMGNUR.NarcoticDrugsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
