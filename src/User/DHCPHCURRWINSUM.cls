Class User.DHCPHCURRWINSUM Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCWS_ROWID, SqlTableName = DHC_PHCURRWINSUM, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHCWS_PHL_DR
Property PHCWSPHLDR As User.DHCPHLOC [ SqlColumnNumber = 2, SqlFieldName = PHCWS_PHL_DR ];

/// PHCWS_DATE
Property PHCWSDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PHCWS_DATE ];

/// PHCWS_PHW_DR
Property PHCWSPHWDR As User.DHCPHWINDOW [ SqlColumnNumber = 4, SqlFieldName = PHCWS_PHW_DR ];

/// PHCWS_PrescNoSum
Property PHCWSPrescNoSum As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHCWS_PrescNoSum ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHCWS)</SqlIdExpression>
<SQLMap name="DHCPHCWSiPHLDATE">
<Global>^DHCPHCWSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PHCWS_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PHLDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHCWS_PHL_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCWS_DATE}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHCWS_PHW_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PHCWS_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DHCPHCWSiPHLDATENUM">
<Global>^DHCPHCWSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PHCWS_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PHLSUM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHCWS_PHL_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCWS_DATE}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHCWS_PrescNoSum}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PHCWS_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHCWSMASTER">
<Data name="PHCWS_DATE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCWS_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCWS_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHCWS_PrescNoSum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHCWS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCWS_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHCWS_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCURRWINSUMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
