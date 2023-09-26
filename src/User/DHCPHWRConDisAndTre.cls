Class User.DHCPHWRConDisAndTre Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCDT_RowID, SqlTableName = DHC_PHWRConDisAndTre, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHCDTChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHWardRound Parent Reference PHCDT_PHWR_Parref
Relationship PHCDTPHWRParref As User.DHCPHWardRound [ Cardinality = parent, Inverse = ChildDHCPHWRCONDISANDTRE, Required, SqlFieldName = PHCDT_PHWR_Parref ];

/// PHCDT_ChildSub
Property PHCDTChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHCDT_ChildSub ];

/// PHCDT_Desc  伴随疾病及用药描述
Property PHCDTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHCDT_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHCDT_Desc">
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
<Field>PHCDT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHWardRound.PHWR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCDT_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHWRConDisAndTreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
