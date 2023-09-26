Class dbo.QCEQAWGPlanStudy Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = EQA_WGPlanStudy, StorageStrategy = Default ]
{

Index IndexMaster On (EQAWGPlanDR, StudyUserDR, StudyDate, StudyTime) [ SqlName = Index_Master, Type = index ];

Index IndexStudyUser On (StudyUserDR, StudyDate) [ SqlName = Index_StudyUser, Type = index ];

Index PKEQAWGPLANSTUDY On RowID [ PrimaryKey, SqlName = PK_EQA_WGPLANSTUDY, Type = index, Unique ];

ForeignKey FKQCEQAWGPlanStudyQCEQAWGPlan(EQAWGPlanDR) References dbo.QCEQAWGPlan(PKQCEQAWGPLAN) [ SqlName = FK_QCEQA_WGPlanStudy_WGPlan ];

ForeignKey FKQCEQAWGPlanStudyStudyUser(StudyUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QCEQA_WGPlanStudy_StudyUser ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property EQAWGPlanDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property StudyUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property StudyDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property StudyTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property TimeSpan As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="QCEQAWGPlanStudyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EQAWGPlanDR</Value>
</Value>
<Value name="3">
<Value>StudyUserDR</Value>
</Value>
<Value name="4">
<Value>StudyDate</Value>
</Value>
<Value name="5">
<Value>StudyTime</Value>
</Value>
<Value name="6">
<Value>TimeSpan</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.QCEQAWGPlanStudyD</DataLocation>
<DefaultData>QCEQAWGPlanStudyDefaultData</DefaultData>
<IdLocation>^dbo.QCEQAWGPlanStudyD</IdLocation>
<IndexLocation>^dbo.QCEQAWGPlanStudyI</IndexLocation>
<StreamLocation>^dbo.QCEQAWGPlanStudyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
