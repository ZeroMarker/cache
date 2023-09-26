Class User.DHCRBExamRejectItem Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, SqlTableName = DHCRB_ExamRejectItem ]
{

Property ItmMastDR As %String [ Required, SqlColumnNumber = 2 ];

Property ItmMastCode As %String [ SqlColumnNumber = 3 ];

Property ItmBodyDR As %String [ SqlColumnNumber = 4 ];

Property ItmBodyCode As %String [ SqlColumnNumber = 5 ];

/// Property RejectExamGroupID As %String;
Property ExamGroupID As %String [ SqlColumnNumber = 6 ];

Property RejectExamGroupCode As %String [ SqlColumnNumber = 7 ];

Property RejectItmMastDR As %String [ SqlColumnNumber = 8 ];

Property RejectItmMastCode As %String [ SqlColumnNumber = 9 ];

Property RejectItmBodyDR As %String [ SqlColumnNumber = 10 ];

Property RejectItmBodyCode As %String [ SqlColumnNumber = 11 ];

Property RejectTime As %Integer [ SqlColumnNumber = 12 ];

Property TimeUnit As %String [ SqlColumnNumber = 13 ];

/// 提示类型，[强制/提示] [Force/Warn]
Property HintType As %String [ SqlColumnNumber = 14 ];

Index ItmMastIndex On ItmMastDR;

Index RejectItmMastIndex On (ItmMastDR, RejectItmMastDR);

/// Index ExamGroupIndex On (ItmMastDR, RejectExamGroupID As AlphaUp);
Index ExamGroupIndex On (ItmMastDR, ExamGroupID As AlphaUp);

Index RejectIndex On RejectItmMastDR;

/// Index OnlyExamGroupIndex On RejectExamGroupID As AlphaUp;
Index OnlyExamGroupIndex On ExamGroupID As AlphaUp;

Storage Default
{
<Data name="DHCRBExamRejectItemDefaultData">
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
<Value>RejectItmMastDR</Value>
</Value>
<Value name="5">
<Value>RejectTime</Value>
</Value>
<Value name="6">
<Value>TimeUnit</Value>
</Value>
<Value name="7">
<Value>RejectExamGroupID</Value>
</Value>
<Value name="8">
<Value>RejectExamGroupCode</Value>
</Value>
<Value name="9">
<Value>ItmMastCode</Value>
</Value>
<Value name="10">
<Value>RejectItmMastCode</Value>
</Value>
<Value name="11">
<Value>RejectItmBodyDR</Value>
</Value>
<Value name="12">
<Value>RejectItmBodyCode</Value>
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
<DataLocation>^User.DHCRBExamRejectItemD</DataLocation>
<DefaultData>DHCRBExamRejectItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCRBExamRejectItemD</IdLocation>
<IndexLocation>^User.DHCRBExamRejectItemI</IndexLocation>
<StreamLocation>^User.DHCRBExamRejectItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
