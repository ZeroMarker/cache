Class DHCINSU.Model.BJ.INSURecipe Extends (%SerialObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "recipe";

Property diagnoseno As %String;

Property recipeno As %String;

Property recipedate As %String;

Property diagnosecode As %String;

Property diagnosename As %String;

Property medicalrecord As %String;

Property sectioncode As %String;

Property sectionname As %String;

Property hissectionname As %String;

Property drid As %String;

Property drname As %String;

Property recipetype As %String;

Property helpmedicineflag As %String;

Property remark As %String;

Property registertradeno As %String;

Property billstype As %String;

Property drlevel As %String;

//只有工伤、外配处方才有此节点

Relationship recipearray As DHCINSU.Model.BJ.INSURecipearray(XMLPROJECTION = "NONE") [ Cardinality = one, Inverse = recipe ];

Storage Default
{
<Data name="INSURecipeState">
<Value name="1">
<Value>diagnoseno</Value>
</Value>
<Value name="2">
<Value>recipeno</Value>
</Value>
<Value name="3">
<Value>recipedate</Value>
</Value>
<Value name="4">
<Value>diagnosecode</Value>
</Value>
<Value name="5">
<Value>diagnosename</Value>
</Value>
<Value name="6">
<Value>medicalrecord</Value>
</Value>
<Value name="7">
<Value>sectioncode</Value>
</Value>
<Value name="8">
<Value>sectionname</Value>
</Value>
<Value name="9">
<Value>hissectionname</Value>
</Value>
<Value name="10">
<Value>drid</Value>
</Value>
<Value name="11">
<Value>drname</Value>
</Value>
<Value name="12">
<Value>recipetype</Value>
</Value>
<Value name="13">
<Value>helpmedicineflag</Value>
</Value>
<Value name="14">
<Value>remark</Value>
</Value>
<Value name="15">
<Value>registertradeno</Value>
</Value>
<Value name="16">
<Value>billstype</Value>
</Value>
<Value name="17">
<Value>DivideInput</Value>
</Value>
</Data>
<State>INSURecipeState</State>
<StreamLocation>^DHCINSU.Model.BJ.INSURecipeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
