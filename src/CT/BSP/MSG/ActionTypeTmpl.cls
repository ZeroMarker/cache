Class CT.BSP.MSG.ActionTypeTmpl Extends %Persistent
{

Property ActionCode As %String;

Property SendMode As %String;

Property TmplCode As %String;

Index ActSendMode On (ActionCode As Exact, SendMode As Exact);

Storage Default
{
<Data name="ActionTypeTmplDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionCode</Value>
</Value>
<Value name="3">
<Value>SendMode</Value>
</Value>
<Value name="4">
<Value>TmplCode</Value>
</Value>
</Data>
<DataLocation>^CT.BSP.MSG.ActionTypeTmplD</DataLocation>
<DefaultData>ActionTypeTmplDefaultData</DefaultData>
<IdLocation>^CT.BSP.MSG.ActionTypeTmplD</IdLocation>
<IndexLocation>^CT.BSP.MSG.ActionTypeTmplI</IndexLocation>
<StreamLocation>^CT.BSP.MSG.ActionTypeTmplS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
