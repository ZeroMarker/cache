Class User.DHCJFRcptGroupSet Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = grp_rowid, SqlTableName = DHC_JFRcptGroupSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCJFRcptGroupUser As User.DHCJFRcptGroupUser [ Cardinality = children, Inverse = grpuserparref ];

/// grp_rcpttype
Property grprcpttype As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = grp_rcpttype ];

/// grp_rcptgrptype
Property grprcptgrptype As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = grp_rcptgrptype ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFRcptGroupSet)</SqlIdExpression>
<SQLMap name="DHCJFRcptGroupSet">
<Data name="grp_rcptgrptype">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="grp_rcpttype">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCJFRcptGroupSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>grp_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{grp_rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DHCJFRcptGroupSetIndex">
<Global>^DHCJFRcptGroupSet</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>grp_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{grp_rcpttype}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{grp_rcptgrptype}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{grp_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFRcptGroupSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
