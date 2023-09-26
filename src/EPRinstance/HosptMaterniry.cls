Class EPRinstance.HosptMaterniry Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxEpisodeID On OPAdmID;

Index IdxPatientIDEpisodeID On (OPPapmiDR, OPAdmID);

Property OPAdmID As %String;

Property OPPapmiDR As %String;

Property OPDeptDR As %String;

Property OPDeptDesc As %String;

Storage Default
{
<Data name="HosptMaterniryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OPAdmID</Value>
</Value>
<Value name="3">
<Value>OPDeptDR</Value>
</Value>
<Value name="4">
<Value>OPDeptDesc</Value>
</Value>
<Value name="5">
<Value>OPPapmiDR</Value>
</Value>
</Data>
<DataLocation>^EPRinstance.HosptMaterniryD</DataLocation>
<DefaultData>HosptMaterniryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRinstance.HosptMaterniryD</IdLocation>
<IndexLocation>^EPRinstance.HosptMaterniryI</IndexLocation>
<StreamLocation>^EPRinstance.HosptMaterniryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
