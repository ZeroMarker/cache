Class DWR.MSG.OrderItem Extends (%Persistent, %XML.Adaptor)
{

Property ordIndex As %String;

Property ordItemId As %String;

Property seqNo As %String;

Property itemCat As %String;

Property itemDesc As %String;

Property orderDoctor As %String;

Property orderDate As %String;

Property orderTime As %String;

Property orderStatus As %String;

Property stopOrderDoctor As %String;

Property stopOrderDate As %String;

Property stopOrderTime As %String;

Property ordStartDate As %String;

Property ordStartTime As %String;

Property priority As %String;

Property doseQty As %String;

Property doseUom As %String;

Property frequency As %String;

Property instruction As %String;

Property duration As %String;

Property qty As %String;

Property uom As %String;

Property recLoc As %String;

Property orderNote As %String;

/// /默认 orderdefault.png 药品 drug.png
Property icoFile As %String;

Property stopPerm As %String;

Storage Default
{
<Data name="OrderItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ordIndex</Value>
</Value>
<Value name="3">
<Value>ordItemId</Value>
</Value>
<Value name="4">
<Value>seqNo</Value>
</Value>
<Value name="5">
<Value>itemCat</Value>
</Value>
<Value name="6">
<Value>itemDesc</Value>
</Value>
<Value name="7">
<Value>orderDoctor</Value>
</Value>
<Value name="8">
<Value>orderTime</Value>
</Value>
<Value name="9">
<Value>stopOrderDate</Value>
</Value>
<Value name="10">
<Value>stopOrderTime</Value>
</Value>
<Value name="11">
<Value>itemStatus</Value>
</Value>
<Value name="12">
<Value>startDate</Value>
</Value>
<Value name="13">
<Value>startTime</Value>
</Value>
<Value name="14">
<Value>priority</Value>
</Value>
<Value name="15">
<Value>doseQty</Value>
</Value>
<Value name="16">
<Value>doseUom</Value>
</Value>
<Value name="17">
<Value>frequency</Value>
</Value>
<Value name="18">
<Value>instruction</Value>
</Value>
<Value name="19">
<Value>duration</Value>
</Value>
<Value name="20">
<Value>qty</Value>
</Value>
<Value name="21">
<Value>uom</Value>
</Value>
<Value name="22">
<Value>recLoc</Value>
</Value>
<Value name="23">
<Value>note</Value>
</Value>
<Value name="24">
<Value>icoFileUrl</Value>
</Value>
<Value name="25">
<Value>icoFile</Value>
</Value>
<Value name="26">
<Value>orderDate</Value>
</Value>
<Value name="27">
<Value>stopOrderDoctor</Value>
</Value>
<Value name="28">
<Value>ordNote</Value>
</Value>
<Value name="29">
<Value>orderNote</Value>
</Value>
<Value name="30">
<Value>orderStatus</Value>
</Value>
<Value name="31">
<Value>ordStartDate</Value>
</Value>
<Value name="32">
<Value>ordStartTime</Value>
</Value>
<Value name="33">
<Value>stopPerm</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.OrderItemD</DataLocation>
<DefaultData>OrderItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.OrderItemD</IdLocation>
<IndexLocation>^DWR.MSG.OrderItemI</IndexLocation>
<StreamLocation>^DWR.MSG.OrderItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
