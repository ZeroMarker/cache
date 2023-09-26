/// 诊断常用名/别名字典表
Class User.DKBDiagnosisCom Extends %Persistent [ SqlRowIdName = DKBDIC_RowId, SqlTableName = DKB_DiagnosisCom, StorageStrategy = SQLStorage ]
{

//^DKBDGSCOM

Property DKBDICDiaDr As User.DKBDiagnosis [ SqlColumnNumber = 2, SqlFieldName = DKBDIC_Dia_Dr ];

Property DKBDICCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DKBDIC_Code ];

Property DKBDICDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DKBDIC_Desc ];

Property DKBDICType As %String(DISPLAYLIST = ",常用名,别名", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",C,A") [ SqlColumnNumber = 5, SqlFieldName = DKBDIC_Type ];

Property DKBDICActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DKBDIC_ActiveFlag ];

Property DKBDICSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DKBDIC_SysFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DKBDGSCOM(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DKBDGSCOM</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DKBDIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBDIC_Dia_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBDIC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$UPPER({DKBDIC_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DKBDIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DKBDGSCOM</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DKBDIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBDIC_Dia_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBDIC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$UPPER({DKBDIC_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DKBDIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DiaIndex">
<Global>^DKBDGSCOM</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DKBDIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Dia"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBDIC_Dia_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBDIC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBDIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DKBDIC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DKBDIC_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBDIC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DKBDIC_Dia_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DKBDIC_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DKBDIC_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DKBDGSCOM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DKBDIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DKBDIC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DKBDiagnosisComS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
