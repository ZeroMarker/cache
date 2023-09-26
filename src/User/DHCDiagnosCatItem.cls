/// DHC
Class User.DHCDiagnosCatItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCI_Rowid, SqlTableName = DHC_DiagnosCatItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DCIChildsub [ IdKey, PrimaryKey, Unique ];

/// DCI_ARCIM_DR
Property DCIARCIMDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = DCI_ARCIM_DR ];

/// DCI_Childsub
Property DCIChildsub As %Library.Float [ InitialExpression = {$i(^DHCDiagnosCat($p(%d(0),$c(1)),"Item",0))}, Required, SqlColumnNumber = 2, SqlFieldName = DCI_Childsub ];

/// DHC_DiagnosCat Parent Reference
Relationship DCIDCParRef As User.DHCDiagnosCat [ Cardinality = parent, Inverse = ChildDHCDiagnosCatItem, Required, SqlFieldName = DCI_DC_ParRef ];

/// DCI_Duration_DR
Property DCIDurationDR As User.PHCDuration [ SqlColumnNumber = 4, SqlFieldName = DCI_Duration_DR ];

/// DCI_MonthMaxQty
Property DCIMonthMaxQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DCI_MonthMaxQty ];

/// DCI_YearMaxQty
Property DCIYearMaxQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DCI_YearMaxQty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DCI_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCI_Duration_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCI_MonthMaxQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCI_YearMaxQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDiagnosCat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DiagnosCat.DC_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DCI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_DiagnosCat.DC_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCI_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDiagnosCatItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
