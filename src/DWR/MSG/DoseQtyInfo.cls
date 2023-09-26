Class DWR.MSG.DoseQtyInfo Extends (%Persistent, %XML.Adaptor)
{

Parameter XMLNAME = "DoseQtyInfo";

Property doseQty As %String;

Property doseUomDesc As %String;

Property doseUomId As %String;

Property defaultFlag As %String;

Storage Default
{
<Data name="DoseQtyInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>doseQty</Value>
</Value>
<Value name="3">
<Value>doseUomDesc</Value>
</Value>
<Value name="4">
<Value>doseUomId</Value>
</Value>
<Value name="5">
<Value>defaultFlage</Value>
</Value>
<Value name="6">
<Value>defaultFlag</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.DoseQtyInfoD</DataLocation>
<DefaultData>DoseQtyInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.DoseQtyInfoD</IdLocation>
<IndexLocation>^DWR.MSG.DoseQtyInfoI</IndexLocation>
<StreamLocation>^DWR.MSG.DoseQtyInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
