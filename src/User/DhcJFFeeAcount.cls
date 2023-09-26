Class User.DhcJFFeeAcount Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Fee_RowID, SqlTableName = Dhc_JFFeeAcount, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On FeeChildsub [ IdKey, PrimaryKey, Unique ];

/// Dhc_JFYJAcount Parent Reference
Relationship FeeAcctdr As User.DhcJFYJAcount [ Cardinality = parent, Inverse = ChildDhcJFFeeAcount, Required, SqlFieldName = Fee_Acct_dr ];

/// Fee_Childsub
Property FeeChildsub As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ InitialExpression = {$i(^DHCFEEACOUNT($p(%d(0),$c(1),1),"SUB",0))}, SqlColumnNumber = 8, SqlFieldName = Fee_Childsub ];

/// Fee_CurrentRemain
Property FeeCurrentRemain As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Fee_CurrentRemain ];

/// Fee_DfSum
Property FeeDfSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Fee_DfSum ];

/// Fee_JfSum
Property FeeJfSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Fee_JfSum ];

/// Fee_LastRemain
Property FeeLastRemain As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Fee_LastRemain ];

/// Fee_PrintFlag
Property FeePrintFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Fee_PrintFlag ];

/// Fee_Tari_dr
Property FeeTaridr As User.DHCTarInpatCate [ SqlColumnNumber = 2, SqlFieldName = Fee_Tari_dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DHCJFFEEACOUNT">
<Data name="Fee_Acct_dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Fee_Childsub">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Fee_CurrentRemain">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Fee_DfSum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Fee_JfSum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Fee_LastRemain">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Fee_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Fee_Tari_dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCJFFEEACOUNT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Dhc_JFYJAcount.Acct_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>Fee_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{Dhc_JFYJAcount.Acct_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SUB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{Fee_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DhcJFFeeAcountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
