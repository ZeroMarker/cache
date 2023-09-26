/// 
Class dbo.BDInfusionPack Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_InfusionPack ]
{

/// Foreign Key FKBDInfusionPackInfusionDR created via DDL
ForeignKey FKBDInfusionPackInfusionDR(InfusionDR) References dbo.BDInfusion(PKBDINFUSION) [ SqlName = FK_BDInfusionPackInfusionDR ];

/// Foreign Key FKBDInfusionPackPackDR created via DDL
ForeignKey FKBDInfusionPackPackDR(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BDInfusionPackPackDR ];

/// DDL Primary Key Specification
Index PKBDINFUSIONPACK On RowID [ PrimaryKey, SqlName = PK_BD_INFUSIONPACK, Type = index, Unique ];

Index IndexMaster On (InfusionDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property InfusionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BDInfusionPackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InfusionDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDInfusionPackD</DataLocation>
<DefaultData>BDInfusionPackDefaultData</DefaultData>
<IdLocation>^dbo.BDInfusionPackD</IdLocation>
<IndexLocation>^dbo.BDInfusionPackI</IndexLocation>
<StreamLocation>^dbo.BDInfusionPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
