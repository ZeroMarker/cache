Class CHSSWeb.Barcode.PersonBarcodeData Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property PersonBarcodeList As list Of CHSSWeb.Barcode.PersonBarcodeObj(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "EXPLICIT");

Storage Default
{
<Data name="PersonBarcodeDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonBarcodeList</Value>
</Value>
<Value name="3">
<Value>PersonReportList</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.Bar52D.PersonBarcod6A1D</DataLocation>
<DefaultData>PersonBarcodeDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.Bar52D.PersonBarcod6A1D</IdLocation>
<IndexLocation>^CHSSWeb.Bar52D.PersonBarcod6A1I</IndexLocation>
<StreamLocation>^CHSSWeb.Bar52D.PersonBarcod6A1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
