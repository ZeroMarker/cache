Class dhc.qm.data.Request Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

Property userCode As %String(TRUNCATE = 1);

Property userPassWord As %String(TRUNCATE = 1);

Property period As %String(TRUNCATE = 1);

Property checkDr As %String(TRUNCATE = 1);

Property checkRowid As %String(TRUNCATE = 1);

Property status As %String(TRUNCATE = 1);

Property planDr As %String(TRUNCATE = 1);

Property deptGroupDr As %String(TRUNCATE = 1);

Property startDate As %String(TRUNCATE = 1);

Property endDate As %String(TRUNCATE = 1);

Property wardDr As %String(TRUNCATE = 1);

Property qmschemDr As %String(TRUNCATE = 1);

Property admNo As %String(TRUNCATE = 1);

Property patName As %String(TRUNCATE = 1);

Property inPatCode As %String(TRUNCATE = 1);

Property Indoccode As %String(TRUNCATE = 1);

Property IndocName As %String(TRUNCATE = 1);

Property operatorcode As %String(TRUNCATE = 1);

Property operdocname As %String(TRUNCATE = 1);

Property operatorID As %String(TRUNCATE = 1);

Property operator As %String(TRUNCATE = 1);

Property operatordate As %String(TRUNCATE = 1);

Property patRowid As %String(TRUNCATE = 1);

Property txtValue As %String(TRUNCATE = 1);

Property actValue As %String(TRUNCATE = 1);

Property PicLink As %String(TRUNCATE = 1);

Property OperationID As %String(TRUNCATE = 1);

Property OperationName As %String(TRUNCATE = 1);

Property Operationdate As %String(TRUNCATE = 1);

Property consultID As %String;

Property consultdepart As %String;

Property consultdoccode As %String;

Property consultdoc As %String;

Property applydate As %String;

Property consultdate As %String;

Property decedate As %String;

Property deadNum As %String;

Property EquipNo As %String(TRUNCATE = 1);

Property TableName As %String(TRUNCATE = 1);

Property valInfo As %String(TRUNCATE = 1);

Property EQRowID As %String(TRUNCATE = 1);

Property ExObjDR As %String(TRUNCATE = 1);

Property RequestLocDR As %String(TRUNCATE = 1);

Property ApproveRole As %String(TRUNCATE = 1);

Property WaitAD As %String(TRUNCATE = 1);

Property QXType As %String(TRUNCATE = 1);

Property RequestNo As %String(TRUNCATE = 1);

Property InvalidFlag As %String(TRUNCATE = 1);

Property LocFlag As %String(TRUNCATE = 1);

Property UserFlag As %String(TRUNCATE = 1);

Property GroupID As %String(TRUNCATE = 1);

Property CurUser As %String(TRUNCATE = 1);

Property vData As %String(TRUNCATE = 1);

Property MRRowID As %String(TRUNCATE = 1);

Property MRGUser As %String(TRUNCATE = 1);

Property val As %String(TRUNCATE = 1);

Property CurRole As %String(TRUNCATE = 1);

Property RoleStep As %String(TRUNCATE = 1);

Property editFieldsInfo As %String(TRUNCATE = 1);

Property AcceptUser As %String(TRUNCATE = 1);

Property FaultCase As %String(TRUNCATE = 1);

Property FaultReason As %String(TRUNCATE = 1);

Storage Default
{
<Data name="RequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>userCode</Value>
</Value>
<Value name="3">
<Value>userPassWord</Value>
</Value>
<Value name="4">
<Value>period</Value>
</Value>
<Value name="5">
<Value>checkDr</Value>
</Value>
<Value name="6">
<Value>status</Value>
</Value>
<Value name="7">
<Value>planDr</Value>
</Value>
<Value name="8">
<Value>deptGroupDr</Value>
</Value>
<Value name="9">
<Value>wardDr</Value>
</Value>
<Value name="10">
<Value>qmschemDr</Value>
</Value>
<Value name="11">
<Value>admNo</Value>
</Value>
<Value name="12">
<Value>patName</Value>
</Value>
<Value name="13">
<Value>inPatCode</Value>
</Value>
<Value name="14">
<Value>Indoccode</Value>
</Value>
<Value name="15">
<Value>IndocName</Value>
</Value>
<Value name="16">
<Value>operatorcode</Value>
</Value>
<Value name="17">
<Value>operdocname</Value>
</Value>
<Value name="18">
<Value>operatorID</Value>
</Value>
<Value name="19">
<Value>operator</Value>
</Value>
<Value name="20">
<Value>operatordate</Value>
</Value>
<Value name="21">
<Value>patRowid</Value>
</Value>
<Value name="22">
<Value>txtValue</Value>
</Value>
<Value name="23">
<Value>actValue</Value>
</Value>
<Value name="24">
<Value>PicLink</Value>
</Value>
<Value name="25">
<Value>OperationID</Value>
</Value>
<Value name="26">
<Value>OperationName</Value>
</Value>
<Value name="27">
<Value>Operationdate</Value>
</Value>
<Value name="28">
<Value>consultID</Value>
</Value>
<Value name="29">
<Value>consultdepart</Value>
</Value>
<Value name="30">
<Value>consultdoccode</Value>
</Value>
<Value name="31">
<Value>consultdoc</Value>
</Value>
<Value name="32">
<Value>applydate</Value>
</Value>
<Value name="33">
<Value>consultdate</Value>
</Value>
<Value name="34">
<Value>decedate</Value>
</Value>
<Value name="35">
<Value>deadNum</Value>
</Value>
<Value name="36">
<Value>checkRowid</Value>
</Value>
<Value name="37">
<Value>startDate</Value>
</Value>
<Value name="38">
<Value>endDate</Value>
</Value>
<Value name="39">
<Value>EquipNo</Value>
</Value>
<Value name="40">
<Value>TableName</Value>
</Value>
<Value name="41">
<Value>valInfo</Value>
</Value>
<Value name="42">
<Value>EQRowID</Value>
</Value>
<Value name="43">
<Value>ExObjDR</Value>
</Value>
<Value name="44">
<Value>RequestLocDR</Value>
</Value>
<Value name="45">
<Value>ApproveRole</Value>
</Value>
<Value name="46">
<Value>WaitAD</Value>
</Value>
<Value name="47">
<Value>QXType</Value>
</Value>
<Value name="48">
<Value>RequestNo</Value>
</Value>
<Value name="49">
<Value>InvalidFlag</Value>
</Value>
<Value name="50">
<Value>LocFlag</Value>
</Value>
<Value name="51">
<Value>UserFlag</Value>
</Value>
<Value name="52">
<Value>GroupID</Value>
</Value>
<Value name="53">
<Value>CurUser</Value>
</Value>
<Value name="54">
<Value>vData</Value>
</Value>
<Value name="55">
<Value>MRRowID</Value>
</Value>
<Value name="56">
<Value>MRGUser</Value>
</Value>
<Value name="57">
<Value>val</Value>
</Value>
<Value name="58">
<Value>CurRole</Value>
</Value>
<Value name="59">
<Value>RoleStep</Value>
</Value>
<Value name="60">
<Value>editFieldsInfo</Value>
</Value>
<Value name="61">
<Value>AcceptUser</Value>
</Value>
<Value name="62">
<Value>FaultCase</Value>
</Value>
<Value name="63">
<Value>FaultReason</Value>
</Value>
</Data>
<DataLocation>^dhc.qm.data.RequestD</DataLocation>
<DefaultData>RequestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.qm.data.RequestD</IdLocation>
<IndexLocation>^dhc.qm.data.RequestI</IndexLocation>
<StreamLocation>^dhc.qm.data.RequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
