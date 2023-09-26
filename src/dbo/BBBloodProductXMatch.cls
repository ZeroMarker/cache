Class dbo.BBBloodProductXMatch Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodProductXMatch, StorageStrategy = Default ]
{

/// Foreign Key FKBBBGCMXGroup created via DDL
ForeignKey FKBBBPMProduct(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BB_BPM_BloodProduct ];

ForeignKey FKBBBPMXProduct(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BB_BPM_XBloodProduct ];

Index IndexMaster On (BloodProductDR, XBloodProductDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (BloodProductDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBBLOODGROUPXMATCH On RowID [ PrimaryKey, SqlName = PK_BB_BLOODGROUPXMATCH, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property XBloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BBBloodProductXMatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodProductDR</Value>
</Value>
<Value name="3">
<Value>XBloodProductDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodProductXMatchD</DataLocation>
<DefaultData>BBBloodProductXMatchDefaultData</DefaultData>
<IdLocation>^dbo.BBBloodProductXMatchD</IdLocation>
<IndexLocation>^dbo.BBBloodProductXMatchI</IndexLocation>
<StreamLocation>^dbo.BBBloodProductXMatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
