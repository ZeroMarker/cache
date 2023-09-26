Class DHCCPH.DITAN.InterFace.Cmd.ACmd.Record Extends (%SerialObject, %XML.Adaptor) [ ClassType = serial, Inheritance = right, ProcedureBlock ]
{

Property Country As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property Code As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property BarCode As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property Quantity As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property Flag As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Storage Default
{
<Data name="RecordState">
<Value name="1">
<Value>Barcode</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Country</Value>
</Value>
<Value name="4">
<Value>Flag</Value>
</Value>
<Value name="5">
<Value>Quantity</Value>
</Value>
<Value name="6">
<Value>BarCode</Value>
</Value>
</Data>
<State>RecordState</State>
<StreamLocation>^DHCCPH.DITAN.InterFa9AC.RecordS</StreamLocation>
<Type>%Storage.Serial</Type>
}

//Record Country="0" Code="0" Barcode="17" Quantity="1" Flag="0"/>

}
