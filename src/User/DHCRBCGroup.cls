Class User.DHCRBCGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DGP_RowID, SqlTableName = DHCRBC_Group, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCRBCGroupUseFuntion As User.DHCRBCGroupUseFuntion [ Cardinality = children, Inverse = DGPFParRef ];

/// DGP_Code
Property DGPCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, SELECTIVITY = 1, TRUNCATE = 0) [ Required, SqlColumnNumber = 2, SqlFieldName = DGP_Code ];

/// DGP_Desc
Property DGPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DGP_Desc ];

Index DGPCodeUnqIdx1 On DGPCode [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("Group"))</SqlIdExpression>
<SQLMap name="MasterDataIndex">
<Data name="DGP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DGP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DGP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DGP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
