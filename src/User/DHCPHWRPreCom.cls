Class User.DHCPHWRPreCom Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHWRC_RowID, SqlTableName = DHC_PHWRPreCom, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHWRCChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PHWRCPHWRParref As User.DHCPHWardRound [ Cardinality = parent, Inverse = ChildDHCPHWRPRECOM, Required, SqlFieldName = PHWRC_PHWR_Parref ];

/// PHWRC_ChildSub
Property PHWRCChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHWRC_ChildSub ];

/// PHWRC_Desc  主诉描述
Property PHWRCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 9999, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHWRC_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHWRC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHWR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHWardRound.PHWR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHWRC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHWardRound.PHWR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PPC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHWRC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHWRPreComS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
