Class User.DHCIPMealItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCMI_RowID, SqlTableName = DHC_IPMealItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCIPMealItemPrice As User.DHCIPMealItemPrice [ Cardinality = children, Inverse = DHCIPDHCMIParref ];

/// DHCMI_Code
Property DHCMICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHCMI_Code ];

/// DHCMI_Desc
Property DHCMIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCMI_Desc ];

/// DHCMI_MealType_Dr
Property DHCMIMealTypeDr As User.DHCIPMealType [ SqlColumnNumber = 4, SqlFieldName = DHCMI_MealType_Dr ];

/// DHCMI_MealModality_Dr
Property DHCMIMealModalityDr As User.DHCIPMealModality [ SqlColumnNumber = 5, SqlFieldName = DHCMI_MealModality_Dr ];

/// DHCMI_Uom_Dr
Property DHCMIUomDr As User.DHCIPMealUom [ SqlColumnNumber = 6, SqlFieldName = DHCMI_Uom_Dr ];

/// dDHCMI_CTLOC_Dr
Property DHCMICTLOCDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DHCMI_CTLOC_Dr ];

/// DHCMI_ActiveFlag
Property DHCMIActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = DHCMI_ActiveFlag ];

/// DHCMI_StartDate
Property DHCMIStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = DHCMI_StartDate ];

/// DHCMI_StartTime
Property DHCMIStartTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DHCMI_StartTime ];

/// DHCMI_EndDate
Property DHCMIEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = DHCMI_EndDate ];

/// DHCMI_EndTime
Property DHCMIEndTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = DHCMI_EndTime ];

/// DHCMI_Remark
Property DHCMIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DHCMI_Remark ];

/// DHCMI_Comment1
Property DHCMIComment1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DHCMI_Comment1 ];

/// DHCMI_Comment2
Property DHCMIComment2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DHCMI_Comment2 ];

/// DHCMI_User
Property DHCMIUser As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = DHCMI_User ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCIPMEALITEM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCMI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCMI_CTLOC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCMI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCMI_Comment1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCMI_Comment2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCMI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCMI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCMI_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCMI_MealModality_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCMI_MealType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCMI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCMI_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCMI_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCMI_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCMI_User">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCIPMEALITEM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCMI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCMI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCIPMEALITEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMI_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCtLoc">
<Global>^DHCIPMEALITEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MealLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMI_CTLOC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCIPMEALITEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMI_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMealModality">
<Global>^DHCIPMEALITEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MealModality"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMI_MealModality_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMealType">
<Global>^DHCIPMEALITEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MealType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMI_MealType_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPMealItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
