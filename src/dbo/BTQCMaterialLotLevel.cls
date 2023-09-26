///     
Class dbo.BTQCMaterialLotLevel Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_MaterialLotLevel, StorageStrategy = Default ]
{

/// Foreign Key FKMaterialLotLevel created via DDL
ForeignKey FKMaterialLotLevel(MaterialLotDR) References dbo.BTQCMaterialLot(PKBTQCMATERIALLOT) [ SqlName = FK_MaterialLotLevel ];

Index IndexMaster On (MaterialLotDR, LevelNo) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTQCMATERIALLOTLEVEL On RowID [ PrimaryKey, SqlName = PK_BTQC_MATERIALLOTLEVEL, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MaterialLotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property LotNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTQCMaterialLotLevelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialLotDR</Value>
</Value>
<Value name="3">
<Value>LevelNo</Value>
</Value>
<Value name="4">
<Value>LotNo</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCMaterialLotLevelD</DataLocation>
<DefaultData>BTQCMaterialLotLevelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTQCMaterialLotLevelD</IdLocation>
<IndexLocation>^dbo.BTQCMaterialLotLevelI</IndexLocation>
<StreamLocation>^dbo.BTQCMaterialLotLevelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
