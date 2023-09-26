Class User.DHCJFPatIPSubCatFee Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IPSubCat_RowID, SqlTableName = DHC_JFPatIPSubCatFee, StorageStrategy = SQLStorage ]
{

/// IPSubCat_DHCPB_DR 账单指针
Property IPSubCatDHCPBDR As User.DHCPatientBill [ SqlColumnNumber = 2, SqlFieldName = IPSubCat_DHCPB_DR ];

/// IPSubCat_DR 子分类指针
Property IPSubCatDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = IPSubCat_DR ];

/// IPSubCat_TotalAmt 子分类总金额
Property IPSubCatPatFee As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = IPSubCat_TotalAmt ];

/// IPSubCat_Type 子分类类型
Property IPSubCatType As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = IPSubCat_Type ];

/// IPSubCat_DiscAmt 子分类折扣金额
Property IPSubCatDiscAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = IPSubCat_DiscAmt ];

/// IPSubCat_PayOrAmt 子分类记账金额
Property IPSubCatPayOrAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = IPSubCat_PayOrAmt ];

/// IPSubCat_PatShareAmt 子分类自付金额
Property IPSubCatPatShareAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = IPSubCat_PatShareAmt ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFPATIPSUBCATFEE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IPSubCat_DHCPB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPSubCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPSubCat_DiscAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPSubCat_PatShareAmt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPSubCat_PayOrAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPSubCat_TotalAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPSubCat_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCJFPATIPSUBCATFEE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IPSubCat_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IPSubCat_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDHCPB">
<Global>^DHCJFPATIPSUBCATFEE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IPSubCat_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DHCPB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPSubCat_DHCPB_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPSubCat_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFPatIPSubCatFeeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
