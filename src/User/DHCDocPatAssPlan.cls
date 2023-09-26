Class User.DHCDocPatAssPlan Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHC_DocPatAssPlan, StorageStrategy = Default ]
{

Parameter EXTENTSIZE = 250;

Index PAPAdm On (PAPEpisodeID, PAPSequence As AlphaUp);

/// PAP_EpisodeID
Property PAPEpisodeID As %String [ SqlColumnNumber = 2, SqlFieldName = PAP_EpisodeID ];

/// PAP_UserType
Property PAPUserType As %String [ SqlColumnNumber = 3, SqlFieldName = PAP_UserType ];

/// PAP_SymptomDate
Property PAPSymptomDate As %Date [ SqlColumnNumber = 4, SqlFieldName = PAP_SymptomDate ];

/// PAP_SymptomTime
Property PAPSymptomTime As %Time [ SqlColumnNumber = 5, SqlFieldName = PAP_SymptomTime ];

/// PAP_PatSymptom
Property PAPPatSymptom As %GlobalBinaryStream(LOCATION = "^DHCDocPatAssPlanS") [ SqlColumnNumber = 6, SqlFieldName = PAP_PatSymptom ];

/// PAP_ExpectedGoal
Property PAPExpectedGoal As %GlobalBinaryStream(LOCATION = "^DHCDocPatAssPlanS") [ SqlColumnNumber = 7, SqlFieldName = PAP_ExpectedGoal ];

/// PAP_Measures
Property PAPMeasures As %GlobalBinaryStream(LOCATION = "^DHCDocPatAssPlanS") [ SqlColumnNumber = 8, SqlFieldName = PAP_Measures ];

/// PAP_ExpectedCompletionDate
Property PAPExpectedCompletionDate As %Date [ SqlColumnNumber = 9, SqlFieldName = PAP_ExpectedCompletionDate ];

/// PAP_ExpectedCompletionTime
Property PAPExpectedCompletionTime As %Time [ SqlColumnNumber = 10, SqlFieldName = PAP_ExpectedCompletionTime ];

/// PAP_SignUser
Property PAPSignUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = PAP_SignUser ];

/// PAP_SignDate
Property PAPSignDate As %Date [ SqlColumnNumber = 12, SqlFieldName = PAP_SignDate ];

/// PAP_SignTime
Property PAPSignTime As %Time [ SqlColumnNumber = 13, SqlFieldName = PAP_SignTime ];

/// PAP_ResultCode
Property PAPResultCode As %String [ SqlColumnNumber = 14, SqlFieldName = PAP_ResultCode ];

/// PAP_Result
Property PAPResult As %GlobalBinaryStream(LOCATION = "^DHCDocPatAssPlanS") [ SqlColumnNumber = 15, SqlFieldName = PAP_Result ];

/// PAP_ResultUser
Property PAPResultUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = PAP_ResultUser ];

/// PAP_ResultUserDate
Property PAPResultUserDate As %Date [ SqlColumnNumber = 17, SqlFieldName = PAP_ResultUserDate ];

/// PAP_ResultUserTime
Property PAPResultUserTime As %Time [ SqlColumnNumber = 18, SqlFieldName = PAP_ResultUserTime ];

/// PAP_UpdateUser
Property PAPUpdateUser As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = PAP_UpdateUser ];

/// PAP_UpdateDate
Property PAPUpdateDate As %Date [ SqlColumnNumber = 20, SqlFieldName = PAP_UpdateDate ];

/// PAP_UpdateTime
Property PAPUpdateTime As %Time [ SqlColumnNumber = 21, SqlFieldName = PAP_UpdateTime ];

/// PAP_Sequence
Property PAPSequence As %String [ Required, SqlColumnNumber = 22, SqlFieldName = PAP_Sequence ];

/// PAP_Level
Property PAPLevel As %String [ SqlColumnNumber = 23, SqlFieldName = PAP_Level ];

Storage Default
{
<Data name="DHCDocPAPData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAPEpisodeID</Value>
</Value>
<Value name="3">
<Value>PAPUserType</Value>
</Value>
<Value name="4">
<Value>PAPSymptomDate</Value>
</Value>
<Value name="5">
<Value>PAPSymptomTime</Value>
</Value>
<Value name="6">
<Value>PAPPatSymptom</Value>
</Value>
<Value name="7">
<Value>PAPExpectedGoal</Value>
</Value>
<Value name="8">
<Value>PAPMeasures</Value>
</Value>
<Value name="9">
<Value>PAPExpectedCompletionDate</Value>
</Value>
<Value name="10">
<Value>PAPExpectedCompletionTime</Value>
</Value>
<Value name="11">
<Value>PAPSignUser</Value>
</Value>
<Value name="12">
<Value>PAPSignDate</Value>
</Value>
<Value name="13">
<Value>PAPSignTime</Value>
</Value>
<Value name="14">
<Value>PAPResultCode</Value>
</Value>
<Value name="15">
<Value>PAPResult</Value>
</Value>
<Value name="16">
<Value>PAPResultUser</Value>
</Value>
<Value name="17">
<Value>PAPResultUserDate</Value>
</Value>
<Value name="18">
<Value>PAPResultUserTime</Value>
</Value>
<Value name="19">
<Value>PAPUpdateUser</Value>
</Value>
<Value name="20">
<Value>PAPUpdateDate</Value>
</Value>
<Value name="21">
<Value>PAPUpdateUser</Value>
</Value>
<Value name="22">
<Value>PAPUpdateTime</Value>
</Value>
<Value name="23">
<Value>PAPSequence</Value>
</Value>
<Value name="24">
<Value>PAPLevel</Value>
</Value>
</Data>
<DataLocation>^DHCDocPatAssPlanD</DataLocation>
<DefaultData>DHCDocPAPData</DefaultData>
<ExtentSize>1000000</ExtentSize>
<IdLocation>^DHCDocPatAssPlanD</IdLocation>
<IndexLocation>^DHCDocPatAssPlanI</IndexLocation>
<SqlRowIdName>PAP_RowID</SqlRowIdName>
<StreamLocation>^DHCDocPatAssPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
