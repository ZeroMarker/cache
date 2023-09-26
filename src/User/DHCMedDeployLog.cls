/// 
Class User.DHCMedDeployLog Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMedDeployLog ]
{

Storage Default
{
<Data name="DHCMedDeployLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^User.DHCMedDeployLogD</DataLocation>
<DefaultData>DHCMedDeployLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMedDeployLogD</IdLocation>
<IndexLocation>^User.DHCMedDeployLogI</IndexLocation>
<StreamLocation>^User.DHCMedDeployLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
