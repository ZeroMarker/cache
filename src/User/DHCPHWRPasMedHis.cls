Class User.DHCPHWRPasMedHis Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHPMH_RowID, SqlTableName = DHC_PHWRPasMedHis, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHPMHChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHWardRound Parent Reference PHPMH_PHWR_Parref
Relationship PHPMHPHWRParref As User.DHCPHWardRound [ Cardinality = parent, Inverse = ChildDHCPHWRPASMEDHIS, Required, SqlFieldName = PHPMH_PHWR_Parref ];

/// PHPMH_ChildSub
Property PHPMHChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHPMH_ChildSub ];

/// PHPMH_Desc  既往用药史
Property PHPMHDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHPMH_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHPMH_Desc">
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
<Field>PHPMH_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHWardRound.PHWR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PMH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHPMH_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHWRPasMedHisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
