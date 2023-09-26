Class dbo.BBExtHospitalLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ExtHospitalLink, StorageStrategy = Default ]
{

Index IndexMaster On (WorkGroupDR, ExtHospitalDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexWorkGroup On (WorkGroupDR, SeqNum) [ SqlName = Index_WorkGroup, Type = index ];

/// DDL Primary Key Specification
Index PKBBEXTHOSPITALLINK On RowID [ PrimaryKey, SqlName = PK_BB_EXTHOSPITALLINK, Type = index, Unique ];

/// Foreign Key FKRightWork created via DDL
ForeignKey FKEXTHLWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_EXTHLWorkGroup ];

/// Foreign Key FKRightWork created via DDL
ForeignKey FKEXTHLHospital(ExtHospitalDR) References dbo.BBExtHospital(PKBBEXTHOSPITAL) [ SqlName = FK_EXTHLHospital ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ExtHospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBExtHospitalLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupDR</Value>
</Value>
<Value name="3">
<Value>ExtHospitalDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BBExtHospitalLinkD</DataLocation>
<DefaultData>BBExtHospitalLinkDefaultData</DefaultData>
<IdLocation>^dbo.BBExtHospitalLinkD</IdLocation>
<IndexLocation>^dbo.BBExtHospitalLinkI</IndexLocation>
<StreamLocation>^dbo.BBExtHospitalLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
