Class User.DHCPHWRAllergicHis Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHAH_RowID, SqlTableName = DHC_PHWRAllergicHis, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHAHChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHWardRound Parent Reference PHAH_PHWR_Parref
Relationship PHAHPHWRParref As User.DHCPHWardRound [ Cardinality = parent, Inverse = ChildDHCPHWRALLERGICHIS, Required, SqlFieldName = PHAH_PHWR_Parref ];

/// PHAH_ChildSub
Property PHAHChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHAH_ChildSub ];

/// PHAH_Desc  伴随疾病及用药描述
Property PHAHDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHAH_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHAH_Desc">
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
<Field>PHAH_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHWardRound.PHWR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAH_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHWRAllergicHisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
