/// 
Class dbo.BDInfusion Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_Infusion ]
{

/// Foreign Key FKBDInfusionLocationDR created via DDL
ForeignKey FKBDInfusionLocationDR(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BDInfusionLocationDR ];

/// Foreign Key FKBDInfusionFirstCheckUserDR created via DDL
ForeignKey FKBDInfusionFirstCheckUserDR(FirstCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDInfusionFirstCheckUserDR ];

/// Foreign Key FKBDInfusionSecondCheckUserDR created via DDL
ForeignKey FKBDInfusionSecondCheckUserDR(SecondCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDInfusionSecondCheckUserDR ];

/// Foreign Key FKBDInfusionInfusionEndUserDR created via DDL
ForeignKey FKBDInfusionInfusionEndUserDR(InfusionEndUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDInfusionInfusionEndUserDR ];

/// Foreign Key FKBDInfusionCommitUserDR created via DDL
ForeignKey FKBDInfusionCommitUserDR(CommitUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDInfusionCommitUserDR ];

/// DDL Primary Key Specification
Index PKBDINFUSION On RowID [ PrimaryKey, SqlName = PK_BD_INFUSION, Type = index, Unique ];

Index IndexMaster On InfusionNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexCommitDate On CommitDate [ SqlName = Index_CommitDate, Type = index ];

Index IndexCommitUser On (CommitUserDR, CommitDate) [ SqlName = Index_CommitUser, Type = index ];

Index IndexLocation On (LocationDR, CommitDate) [ SqlName = Index_Location, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property InfusionNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property MedicalRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property ExFeature As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 7 ];

Property InfusionDevice As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 8 ];

Property InfusionStartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property InfusionStartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property FirstCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property SecondCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property InfusionEndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property InfusionEndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property InfusionEndUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property CommitDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property CommitTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property CommitUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="BDInfusionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InfusionNo</Value>
</Value>
<Value name="3">
<Value>RegNo</Value>
</Value>
<Value name="4">
<Value>MedicalRecordNo</Value>
</Value>
<Value name="5">
<Value>LocationDR</Value>
</Value>
<Value name="6">
<Value>ExFeature</Value>
</Value>
<Value name="7">
<Value>InfusionDevice</Value>
</Value>
<Value name="8">
<Value>InfusionStartDate</Value>
</Value>
<Value name="9">
<Value>InfusionStartTime</Value>
</Value>
<Value name="10">
<Value>FirstCheckUserDR</Value>
</Value>
<Value name="11">
<Value>SecondCheckUserDR</Value>
</Value>
<Value name="12">
<Value>InfusionEndDate</Value>
</Value>
<Value name="13">
<Value>InfusionEndTime</Value>
</Value>
<Value name="14">
<Value>InfusionEndUserDR</Value>
</Value>
<Value name="15">
<Value>CommitDate</Value>
</Value>
<Value name="16">
<Value>CommitTime</Value>
</Value>
<Value name="17">
<Value>CommitUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDInfusionD</DataLocation>
<DefaultData>BDInfusionDefaultData</DefaultData>
<IdLocation>^dbo.BDInfusionD</IdLocation>
<IndexLocation>^dbo.BDInfusionI</IndexLocation>
<StreamLocation>^dbo.BDInfusionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
