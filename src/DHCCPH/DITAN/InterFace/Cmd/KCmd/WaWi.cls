Class DHCCPH.DITAN.InterFace.Cmd.KCmd.WaWi Extends (%SerialObject, %XML.Adaptor) [ ClassType = serial, Inheritance = right, ProcedureBlock ]
{

Property KCmd As KCmd(XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="WaWiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KCmd</Value>
</Value>
</Data>
<Data name="WaWiState">
<Value name="1">
<Value>KCmd</Value>
</Value>
</Data>
<DataLocation>^DHCCPH.DITAN.InterFace9B6.WaWiD</DataLocation>
<DefaultData>WaWiDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCPH.DITAN.InterFace9B6.WaWiD</IdLocation>
<IndexLocation>^DHCCPH.DITAN.InterFace9B6.WaWiI</IndexLocation>
<State>WaWiState</State>
<StreamLocation>^DHCCPH.DITAN.InterFace9B6.WaWiS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
