Class User.DHCIPMealItemPrice Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCIP_RowID, SqlTableName = DHC_IPMealItemPrice, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHCIPChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_IPMealItem Parent Reference
Relationship DHCIPDHCMIParref As User.DHCIPMealItem [ Cardinality = parent, Inverse = ChildDHCIPMealItemPrice, Required, SqlFieldName = DHCIP_DHCMI_Parref ];

/// DHCIP_ChildSub_
Property DHCIPChildSub As %Library.Float [ InitialExpression = {$i(^DHCIPMEALITEM($p(%d(0),$c(1),1),"P",0))}, SqlColumnNumber = 2, SqlFieldName = DHCIP_ChildSub ];

/// DHCIP_Price
Property DHCIPPrice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCIP_Price ];

/// DHCIP_StartDate
Property DHCIPStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DHCIP_StartDate ];

/// DHCIP_EndDate
Property DHCIPEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCIP_EndDate ];

/// DHCIP_UpdateUser_Dr
Property DHCIPUpdateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCIP_UpdateUser_Dr ];

/// DHCIP_UpdateDate
Property DHCIPUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = DHCIP_UpdateDate ];

/// DHCIP_UpdateTime
Property DHCIPUpdateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = DHCIP_UpdateTime ];

/// DHCIP_PatInsuType
Property DHCIPPatInsuType As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DHCIP_PatInsuType ];

/// DHCIP_Remark
Property DHCIPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DHCIP_Remark ];

/// DHCIP_Comment1
Property DHCIPComment1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DHCIP_Comment1 ];

/// DHCIP_Comment2
Property DHCIPComment2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DHCIP_Comment2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DHCIP_Comment1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCIP_Comment2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCIP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCIP_PatInsuType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCIP_Price">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCIP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCIP_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCIP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCIP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCIP_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCIPMEALITEM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_IPMealItem.DHCMI_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCIP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_IPMealItem.DHCMI_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCIP_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStartDate">
<Global>^DHCIPMEALITEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_IPMealItem.DHCMI_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHCIP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_IPMealItem.DHCMI_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCIP_PatInsuType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCIP_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCIP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDate1">
<Global>^DHCIPMEALITEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_IPMealItem.DHCMI_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCIP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_IPMealItem.DHCMI_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCIP_StartDate}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCIP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPMealItemPriceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
