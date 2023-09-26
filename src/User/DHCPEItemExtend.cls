/// 站点项目组合关联表
Class User.DHCPEItemExtend Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IE_RowID, SqlTableName = DHC_PE_ItemExtend, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEItemExtend";

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPEIESendItem As User.DHCPEIESendItem [ Cardinality = children, Inverse = SIParref ];

Relationship ChildDHCPEIEPrice As User.DHCPEIEPrice [ Cardinality = children, Inverse = PParref ];

/// 医嘱项
Property IEARCIMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = IE_ARCIM_DR ];

/// 创建人
Property IECreateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = IE_CreateUser_DR ];

/// 创建日期
Property IECreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = IE_CreateDate ];

/// 创建时间
Property IECreateTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = IE_CreateTime ];

/// 体检项目/站点项目
Property IEOrderDR As User.DHCPEStationOrder [ SqlFieldName = IE_OrderDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEIE)</SqlIdExpression>
<SQLMap name="IndexARCIM">
<Global>^DHCPEIE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>IE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IE_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^DHCPEIE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>IE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IE_OrderDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="IE_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IE_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IE_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IE_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IE_OrderDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IE_RowID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPEIE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IE_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPEItemExtendS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
