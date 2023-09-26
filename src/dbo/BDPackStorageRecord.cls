Class dbo.BDPackStorageRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackStorageRecord, StorageStrategy = Default ]
{

/// Foreign Key FKPackPositionFridgeLayer created via DDL
ForeignKey FKPackStorageRecPackPosition(PackPositionDR) References dbo.BDPackPosition(PKBDPackPosition) [ SqlName = FK_PackStorageRec_PackPosition ];

ForeignKey FKPackStorageRecPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_PackStorageRec_Pack ];

ForeignKey FKPackStorageRecInUser(InUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_PackStorageRec_InUser ];

ForeignKey FKPackStorageRecOutUser(OutUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_PackStorageRec_OutUser ];

ForeignKey FKPackStorageRecWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_PackStorageRec_WorkGroup ];

Index IndexMaster On (PackPositionDR, PositionNo, InDate, InTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPack On (PackDR, Status) [ SqlName = Index_Pack, Type = index ];

Index IndexWorkGroupIn On (WorkGroupDR, InDate) [ SqlName = Index_WorkGroupIn, Type = index ];

Index IndexWorkGroupOut On (WorkGroupDR, OutDate) [ SqlName = Index_WorkGroupOut, Type = index ];

Index IndexInUser On (InUserDR, InDate) [ SqlName = Index_InUser, Type = index ];

Index IndexOutUser On (OutUserDR, OutDate) [ SqlName = Index_OutUser, Type = index ];

Index IndexPackPosition On (PackPositionDR, PositionNo, Status) [ SqlName = Index_PackPosition, Type = index ];

/// DDL Primary Key Specification
Index PKBDPackStorageRecord On RowID [ PrimaryKey, SqlName = PK_BDPackStorage_Record, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血袋存储框  
Property PackPositionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 位置号  
Property PositionNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 血袋  
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 存入日期  
Property InDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 存入时间
Property InTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 存入用户  
Property InUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 取出日期
Property OutDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 取出时间
Property OutTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 取出用户
Property OutUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 状态 I:在库,O:出库 
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 12 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 13 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BDPackStorageRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackPositionDR</Value>
</Value>
<Value name="3">
<Value>PositionNo</Value>
</Value>
<Value name="4">
<Value>PackDR</Value>
</Value>
<Value name="5">
<Value>InDate</Value>
</Value>
<Value name="6">
<Value>InTime</Value>
</Value>
<Value name="7">
<Value>InUserDR</Value>
</Value>
<Value name="8">
<Value>OutDate</Value>
</Value>
<Value name="9">
<Value>OutTime</Value>
</Value>
<Value name="10">
<Value>OutUserDR</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>WorkGroupDR</Value>
</Value>
<Value name="13">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackStorageRecordD</DataLocation>
<DefaultData>BDPackStorageRecordDefaultData</DefaultData>
<IdLocation>^dbo.BDPackStorageRecordD</IdLocation>
<IndexLocation>^dbo.BDPackStorageRecordI</IndexLocation>
<StreamLocation>^dbo.BDPackStorageRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
