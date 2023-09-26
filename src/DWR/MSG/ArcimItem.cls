Class DWR.MSG.ArcimItem Extends (%Persistent, %XML.Adaptor)
{

/*
arcimId   	2
arcimcode	30
arcimDesc 	1
freqCode	3
subCatType	6  "R"
ordCatId        7   医嘱大类Id
phUomDesc	12  规格单位
phdurrowid	13  疗程Id
subCatDesc	18  医嘱子类描述
itemPrice	19
billUom		20
stockQty	22
packedQty	23
genericName	24
resQty		25
recLoc		29
*/
Property showIndex As %String;

Property arcimId As %String;

Property arcimcode As %String;

Property arcimDesc As %String;

Property freqCode As %String;

Property freqId As %String;

Property phUomDesc As %String;

Property subCatDesc As %String;

Property itemPrice As %String;

Property billUom As %String;

Property stockQty As %String;

Property recLoc As %String;

Property recLocList As list Of DWR.MSG.DepartmentInfo(XMLNAME = "recLocList");

Property labSpecList As list Of DWR.MSG.LabSpecInfo(XMLNAME = "labSpecList");

Property doseQtyList As list Of DWR.MSG.DoseQtyInfo(XMLNAME = "doseQtyList");

Property instrId As %String;

Property instrCode As %String;

Property priorDesc As %String;

Property priorId As %String;

Property needSkin As %String;

Property skinActId As %String;

//提示信息,如果存在,需要弹出提示

Property arcMsg As %String;

Property arcType As %String;

Property labSpec As %String;

Property labSpecCode As %String;

Property labContCode As %String;

Property labCont As %String;

Property phFromId As %String;

Property durId As %String;

Property packQty As %String;

Property doseQty As %String;

Property doseUom As %String;

Property skinAct As %String;

Property ordStartDate As %String;

Property ordStartTime As %String;

Property masterSeqNo As %String;

Property firstTimes As %String;

Property ordNote As %String;

Property ordState As %String;

Property isAntib As %String;

Property anntibId As %String;

Storage Default
{
<Data name="ArcimItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>arcimId</Value>
</Value>
<Value name="3">
<Value>arcimcode</Value>
</Value>
<Value name="4">
<Value>arcimDesc</Value>
</Value>
<Value name="5">
<Value>freqCode</Value>
</Value>
<Value name="6">
<Value>phUomDesc</Value>
</Value>
<Value name="7">
<Value>subCatDesc</Value>
</Value>
<Value name="8">
<Value>itemPrice</Value>
</Value>
<Value name="9">
<Value>billUom</Value>
</Value>
<Value name="10">
<Value>stockQty</Value>
</Value>
<Value name="11">
<Value>recLoc</Value>
</Value>
<Value name="12">
<Value>showIdex</Value>
</Value>
<Value name="13">
<Value>recLocList</Value>
</Value>
<Value name="14">
<Value>labSpecList</Value>
</Value>
<Value name="15">
<Value>doseQtyList</Value>
</Value>
<Value name="16">
<Value>freqId</Value>
</Value>
<Value name="17">
<Value>instrId</Value>
</Value>
<Value name="18">
<Value>instrCode</Value>
</Value>
<Value name="19">
<Value>priorDesc</Value>
</Value>
<Value name="20">
<Value>priorId</Value>
</Value>
<Value name="21">
<Value>needSkinTest</Value>
</Value>
<Value name="22">
<Value>needSkin</Value>
</Value>
<Value name="23">
<Value>skinActId</Value>
</Value>
<Value name="24">
<Value>arcMsg</Value>
</Value>
<Value name="25">
<Value>arcType</Value>
</Value>
<Value name="26">
<Value>labSpec</Value>
</Value>
<Value name="27">
<Value>labSpecCode</Value>
</Value>
<Value name="28">
<Value>labContCode</Value>
</Value>
<Value name="29">
<Value>labCont</Value>
</Value>
<Value name="30">
<Value>phFromId</Value>
</Value>
<Value name="31">
<Value>durId</Value>
</Value>
<Value name="32">
<Value>packQty</Value>
</Value>
<Value name="33">
<Value>showIndex</Value>
</Value>
<Value name="34">
<Value>doseQty</Value>
</Value>
<Value name="35">
<Value>doseUomDesc</Value>
</Value>
<Value name="36">
<Value>doseUom</Value>
</Value>
<Value name="37">
<Value>skinAct</Value>
</Value>
<Value name="38">
<Value>ordStartDate</Value>
</Value>
<Value name="39">
<Value>ordStartTime</Value>
</Value>
<Value name="40">
<Value>masterSeqNo</Value>
</Value>
<Value name="41">
<Value>firstTimes</Value>
</Value>
<Value name="42">
<Value>ordNote</Value>
</Value>
<Value name="43">
<Value>ordState</Value>
</Value>
<Value name="44">
<Value>isAntib</Value>
</Value>
<Value name="45">
<Value>anntibId</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.ArcimItemD</DataLocation>
<DefaultData>ArcimItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.ArcimItemD</IdLocation>
<IndexLocation>^DWR.MSG.ArcimItemI</IndexLocation>
<StreamLocation>^DWR.MSG.ArcimItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
