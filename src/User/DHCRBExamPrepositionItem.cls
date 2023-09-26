Class User.DHCRBExamPrepositionItem Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, SqlTableName = DHCRB_ExamPrepositionItem ]
{

Property ItmMastDR As %String [ Required, SqlColumnNumber = 2 ];

Property ItmMastCode As %String [ SqlColumnNumber = 3 ];

Property ItmBodyDR As %String [ SqlColumnNumber = 4 ];

Property ItmBodyCode As %String [ SqlColumnNumber = 5 ];

// Property PrepositonExamGroupID As %String;

Property ExamGroupID As %String [ SqlColumnNumber = 6 ];

Property PrepositonExamGroupCode As %String [ SqlColumnNumber = 7 ];

Property PrepositonItmMastDR As %String [ SqlColumnNumber = 8 ];

Property PrepositonItmMastCode As %String [ SqlColumnNumber = 9 ];

Property PrepositonItmBodyDR As %String [ SqlColumnNumber = 10 ];

Property PrepositonItmBodyCode As %String [ SqlColumnNumber = 11 ];

Property PreTime As %Integer [ SqlColumnNumber = 12 ];

Property TimeUnit As %String [ SqlColumnNumber = 13 ];

/// 提示类型，[强制/提示] [Force/Warn]
Property HintType As %String [ SqlColumnNumber = 14 ];

Index ItmMastIndex On ItmMastDR;

Index ItemCodeIndex On ItmMastCode As AlphaUp;

Index PreItmMastIndex On (ItmMastDR, PrepositonItmMastDR);

Index ExamGroupIndex On (ItmMastDR, ExamGroupID As AlphaUp);

Storage Default
{
<Data name="DHCRBExamPrepositionItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExamGroupID</Value>
</Value>
<Value name="3">
<Value>ItmMastDR</Value>
</Value>
<Value name="4">
<Value>PreTime</Value>
</Value>
<Value name="5">
<Value>PrepositonItmMastDR</Value>
</Value>
<Value name="6">
<Value>TimeUnit</Value>
</Value>
<Value name="7">
<Value>ItmMastCode</Value>
</Value>
<Value name="8">
<Value>PrepositonExamGroupID</Value>
</Value>
<Value name="9">
<Value>PrepositonExamGroupCode</Value>
</Value>
<Value name="10">
<Value>PrepositonItmMastCode</Value>
</Value>
<Value name="11">
<Value>PrepositonItmBodyDR</Value>
</Value>
<Value name="12">
<Value>PrepositonItmBodyCode</Value>
</Value>
<Value name="13">
<Value>ItmBodyDR</Value>
</Value>
<Value name="14">
<Value>ItmBodyCode</Value>
</Value>
<Value name="15">
<Value>HintType</Value>
</Value>
</Data>
<DataLocation>^User.DHCRBExamPrepositionItemD</DataLocation>
<DefaultData>DHCRBExamPrepositionItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCRBExamPrepositionItemD</IdLocation>
<IndexLocation>^User.DHCRBExamPrepositionItemI</IndexLocation>
<StreamLocation>^User.DHCRBExamPrepositionItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
