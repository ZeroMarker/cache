Class User.PIVAFreqRule Extends (%Persistent, User.Abstract) [ SqlRowIdName = PIVA_RowID, SqlTableName = PIVA_FreqRule, StorageStrategy = NewStorage1 ]
{

Property PIVAFreqDr As User.PHCFreq [ SqlColumnNumber = 2, SqlFieldName = PIVA_Freq_Dr ];

Property PIVAOrderNum As %Numeric [ SqlColumnNumber = 3, SqlFieldName = PIVA_OrderNum ];

Property PIVAPhaLocDr As CTLoc [ SqlColumnNumber = 4, SqlFieldName = PIVA_PhaLocDr ];

Property PIVAUpFlag As %Boolean [ SqlColumnNumber = 5, SqlFieldName = PIVA_UpFlag ];

Property PIVADownFlag As %Boolean [ SqlColumnNumber = 6, SqlFieldName = PIVA_DownFlag ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PIVAFREQR)</SqlIdExpression>
<SQLMap name="IndexFreq">
<Global>^PIVAFREQR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PIVA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Freq"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVA_PhaLocDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIVA_Freq_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PIVA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdNum">
<Global>^PIVAFREQR</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIVA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdNum"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVA_PhaLocDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIVA_OrderNum}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PIVA_Freq_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PIVA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PIVA_DownFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIVA_Freq_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIVA_OrderNum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIVA_PhaLocDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIVA_UpFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PIVAFREQR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIVA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PIVAFreqRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
