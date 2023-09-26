/// Creator:      yaojining
/// CreatDate:    2020.09.14
/// Description:  存储角标
Class CT.NUR.EMR.SubScripts Extends (%Persistent, User.Abstract) [ SqlTableName = SubScripts ]
{

Property Number As %Integer [ SqlColumnNumber = 2 ];

Property Script As %String(MAXLEN = 1000000, TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Index Number On Number;

Index NumberScript On (Number, Script);

Storage Default
{
<Data name="SubScriptsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Number</Value>
</Value>
<Value name="3">
<Value>Script</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.EMR.SubScriptsD</DataLocation>
<DefaultData>SubScriptsDefaultData</DefaultData>
<IdLocation>^CT.NUR.EMR.SubScriptsD</IdLocation>
<IndexLocation>^CT.NUR.EMR.SubScriptsI</IndexLocation>
<StreamLocation>^CT.NUR.EMR.SubScriptsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
