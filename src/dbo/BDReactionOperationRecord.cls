Class dbo.BDReactionOperationRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReactionOperationRecord, StorageStrategy = Default ]
{

/// Foreign Key FKBDRECTIADVER created via DDL
ForeignKey FKBDOPRERCADVER(AdverseReactionDR) References dbo.BDAdverseReaction(PKBDADVERSEREACTION) [ SqlName = FK_BD_OPRERC_ADVER ];

/// Foreign Key FKBDADVERADDUSER created via DDL
ForeignKey FKBDOPRERCUSER(OperateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_OPRERC_USER ];

Index IndexMaster On AdverseReactionDR [ SqlName = Index_AdverseReaction, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AdverseReactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property Type As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Property OperateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property OperateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property OperateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property OperateNote As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BDReactionOperationRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdverseReactionDR</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>OperateDate</Value>
</Value>
<Value name="5">
<Value>OperateTime</Value>
</Value>
<Value name="6">
<Value>OperateUserDR</Value>
</Value>
<Value name="7">
<Value>OperateNote</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReactionOperationRecordD</DataLocation>
<DefaultData>BDReactionOperationRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDReactionOperationRecordD</IdLocation>
<IndexLocation>^dbo.BDReactionOperationRecordI</IndexLocation>
<StreamLocation>^dbo.BDReactionOperationRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
