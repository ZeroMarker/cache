Class User.DHCDiagnosCatDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCD_Rowid, SqlTableName = DHC_DiagnosCatDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DCDChildSub [ IdKey, PrimaryKey, Unique ];

/// DCD_ChildSub
Property DCDChildSub As %Library.Float [ InitialExpression = {$i(^DHCDiagnosCat($p(%d(0),$c(1)),"Detail",0))}, Required, SqlColumnNumber = 2, SqlFieldName = DCD_ChildSub ];

/// DHC_DiagnosCat Parent Reference
Relationship DCDDCParRef As User.DHCDiagnosCat [ Cardinality = parent, Inverse = ChildDHCDiagnosCatDetail, Required, SqlFieldName = DCD_DC_ParRef ];

/// DCD_Diagnos_DR
Property DCDDiagnosDR As User.MRCICDDx [ SqlColumnNumber = 3, SqlFieldName = DCD_Diagnos_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DCD_Diagnos_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDiagnosCat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DiagnosCat.DC_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DCD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_DiagnosCat.DC_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Detail"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDiagnos">
<Global>^DHCDiagnosCatI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DiagnosCat.DC_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DCD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Diagose"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCD_Diagnos_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DiagnosCat.DC_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDiagnosCatDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
