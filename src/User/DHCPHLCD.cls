Class User.DHCPHLCD Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHLCD_ROWID, SqlTableName = DHC_PHLCD, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHLCD_DELAY
Property PHLCDDELAY As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHLCD_DELAY ];

/// PHLCD_PHL_DR
Property PHLCDPHLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHLCD_PHL_DR ];

/// PHLCD_PHW_DR
Property PHLCDPHWDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PHLCD_PHW_DR ];

/// PHLCD_XSCS
Property PHLCDXSCS As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHLCD_XSCS ];

/// PHLCD_XSRS
Property PHLCDXSRS As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PHLCD_XSRS ];

/// PHLCD_XSSJ
Property PHLCDXSSJ As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PHLCD_XSSJ ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHLCD)</SqlIdExpression>
<SQLMap name="PHLCDMASTER">
<Data name="PHLCD_DELAY">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHLCD_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHLCD_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHLCD_XSCS">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHLCD_XSRS">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHLCD_XSSJ">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHLCD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHLCD_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHLCD_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHLCDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
