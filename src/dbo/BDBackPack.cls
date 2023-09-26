Class dbo.BDBackPack Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_BackPack, StorageStrategy = Default ]
{

/// Foreign Key FKBBBPorductTransaction created via DDL
ForeignKey FKBDBackPackBack(BackDR) References dbo.BDBack(PKBDBACK) [ SqlName = FK_BD_BackPack_Back ];

/// Foreign Key FKBBBPorductTransaction created via DDL
ForeignKey FKBDBackPackPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_BackPack_Pack ];

Index IndexMaster On (BackDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPack On (PackDR, BackDR) [ SqlName = Index_Pack, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血袋回收单
Property BackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血液
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BDBackPackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BackDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDBackPackD</DataLocation>
<DefaultData>BDBackPackDefaultData</DefaultData>
<IdLocation>^dbo.BDBackPackD</IdLocation>
<IndexLocation>^dbo.BDBackPackI</IndexLocation>
<StreamLocation>^dbo.BDBackPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
