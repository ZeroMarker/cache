Class User.DHCAdvHoliday Extends %Persistent [ Owner = {_SYSTEM,dhpm1}, SqlRowIdName = ADVHol_RowID, SqlTableName = DHC_AdvHoliday, StorageStrategy = SQLStorage ]
{

Property ADVHolDate As %Date [ SqlColumnNumber = 2, SqlFieldName = ADVHol_Date ];

Property ADVHolFlagDay As %String [ SqlColumnNumber = 3, SqlFieldName = ADVHol_FlagDay ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVHOLIDAY)</SqlIdExpression>
<SQLMap name="IndexHolDate">
<Global>^DHCADVHOLIDAY</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADVHol_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Holiday"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVHol_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVHol_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHoliday">
<Global>^DHCADVHOLIDAY</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADVHol_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Festival"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVHol_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVHol_FlagDay}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADVHol_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ADVHol_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADVHol_FlagDay">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVHOLIDAY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADVHol_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADVHol_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvHolidayS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
