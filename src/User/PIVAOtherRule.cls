Class User.PIVAOtherRule Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIVA_RowID, SqlTableName = PIVA_OtherRule, StorageStrategy = NewStorage1 ]
{

Property PIVACubageFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 2, SqlFieldName = PIVA_CubageFlag ];

Property PIVAContinueFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = PIVA_ContinueFlag ];

Property PIVAPhaLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PIVA_PhaLocDr ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PIVAOTHR)</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^PIVAOTHR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PIVA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVA_PhaLocDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIVA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PIVA_ContinueFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIVA_CubageFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIVA_PhaLocDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PIVAOTHR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIVA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PIVAOtherRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
