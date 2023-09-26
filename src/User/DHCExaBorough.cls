Class User.DHCExaBorough Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCExaBorough ]
{

Property ExabCode As %String(TRUNCATE = 1);

Property ExabDepDr As User.CTLoc;

Property ExabMemo As %String(TRUNCATE = 1);

Property ExabName As %String(TRUNCATE = 1);

Property ExabTem As %String(TRUNCATE = 1);

Property ExabAutoReport As %String(TRUNCATE = 1);

Property ExabFristReson As %String(TRUNCATE = 1);

Property ExabNoCheckinDocCanRecAdm As %String(TRUNCATE = 1);

Property ExabCreatQueueNo As %String(TRUNCATE = 1);

Property ExabDelayQueueNo As %String(TRUNCATE = 1);

Property ExabCallDelayQueueNo As %String(TRUNCATE = 1);

Property ExabHospitalDr As User.CTHospital;

Storage Default
{
<Data name="DHCExaBoroughDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExabCode</Value>
</Value>
<Value name="3">
<Value>ExabDepDr</Value>
</Value>
<Value name="4">
<Value>ExabMemo</Value>
</Value>
<Value name="5">
<Value>ExabName</Value>
</Value>
<Value name="6">
<Value>ExabTem</Value>
</Value>
<Value name="7">
<Value>ExabAutoReport</Value>
</Value>
<Value name="8">
<Value>ExabFristReson</Value>
</Value>
<Value name="9">
<Value>ExabNoCheckinDocCanRecAdm</Value>
</Value>
<Value name="10">
<Value>ExabCreatQueueNo</Value>
</Value>
<Value name="11">
<Value>ExabDelayQueueNo</Value>
</Value>
<Value name="12">
<Value>ExabCallDelayQueueNo</Value>
</Value>
<Value name="13">
<Value>ExabHospitalDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCExaBoroughD</DataLocation>
<DefaultData>DHCExaBoroughDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCExaBoroughD</IdLocation>
<IndexLocation>^User.DHCExaBoroughI</IndexLocation>
<StreamLocation>^User.DHCExaBoroughS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
