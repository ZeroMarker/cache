Class User.DHCPHWRPerAndFamHis Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHPFH_RowID, SqlTableName = DHC_PHWRPerAndFamHis, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHPFHChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHWardRound Parent Reference PHPFH_PHWR_Parref
Relationship PHPFHPHWRParref As User.DHCPHWardRound [ Cardinality = parent, Inverse = ChildDHCPHWRPERANDFAMHIS, Required, SqlFieldName = PHPFH_PHWR_Parref ];

/// PHPFH_ChildSub
Property PHPFHChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHPFH_ChildSub ];

/// PHPFH_Desc  个人史及家族史
Property PHPFHDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHPFH_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHPFH_Desc">
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
<Field>PHPFH_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHWardRound.PHWR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PFH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHPFH_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHWRPerAndFamHisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
