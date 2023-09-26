Class dbo.BBBackTypeReason Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BackTypeReason, StorageStrategy = Default ]
{

/// Foreign Key FKBDRFIRReqForm created via DDL
ForeignKey FKBBBTRBackType(BackTypeDR) References dbo.BBBackType(PKBBBACKTYPE) [ SqlName = FK_BB_BTR_BackType ];

Index IndexSeqNum On (BackTypeDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBBACKTYPEREASON On RowID [ PrimaryKey, SqlName = PK_BB_BACKTYPEREASON, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 取血单  
Property BackTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 原因  
Property Reason As %Library.String(MAXLEN = 200) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBBackTypeReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BackTypeDR</Value>
</Value>
<Value name="3">
<Value>Reason</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBackTypeReasonD</DataLocation>
<DefaultData>BBBackTypeReasonDefaultData</DefaultData>
<IdLocation>^dbo.BBBackTypeReasonD</IdLocation>
<IndexLocation>^dbo.BBBackTypeReasonI</IndexLocation>
<StreamLocation>^dbo.BBBackTypeReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
