Class User.DHCPHWRPasDisHis Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHPDH_RowID, SqlTableName = DHC_PHWRPasDisHis, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHPDHChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHWardRound Parent Reference PHPDH_PHWR_Parref
Relationship PHPDHPHWRParref As User.DHCPHWardRound [ Cardinality = parent, Inverse = ChildDHCPHWRPASDISHIS, Required, SqlFieldName = PHPDH_PHWR_Parref ];

/// PHPDH_ChildSub
Property PHPDHChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHPDH_ChildSub ];

/// PHPDH_Desc  既往病史
Property PHPDHDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHPDH_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHPDH_Desc">
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
<Field>PHPDH_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHWardRound.PHWR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PDH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHPDH_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHWRPasDisHisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
