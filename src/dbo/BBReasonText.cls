Class dbo.BBReasonText Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReasonText, StorageStrategy = Default ]
{

/// Foreign Key FKBBRPLinkBloodProduct created via DDL
ForeignKey FKReaTextReason(ReasonDR) References dbo.BBReason(PKBBREASON) [ SqlName = FK_ReaText_Reason ];

Index IndexReason On (ReasonDR, SeqNum) [ SqlName = Index_Reason, Type = index ];

/// DDL Primary Key Specification
Index PKBBREASONTEXT On RowID [ PrimaryKey, SqlName = PK_BB_REASONTEXT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 合理用血理由  
Property ReasonDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBReasonTextDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReasonDR</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReasonTextD</DataLocation>
<DefaultData>BBReasonTextDefaultData</DefaultData>
<IdLocation>^dbo.BBReasonTextD</IdLocation>
<IndexLocation>^dbo.BBReasonTextI</IndexLocation>
<StreamLocation>^dbo.BBReasonTextS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
