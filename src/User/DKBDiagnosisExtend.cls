/// 诊断扩展表：DKB_DiagnosisExtend
Class User.DKBDiagnosisExtend Extends %Persistent [ SqlRowIdName = DKBDIE_RowId, SqlTableName = DKB_DiagnosisExtend, StorageStrategy = SQLStorage ]
{

//^DKBDGSEXT

Property DKBDIEDiaDr As User.DKBDiagnosis [ SqlColumnNumber = 2, SqlFieldName = DKBDIE_Dia_Dr ];

Property DKBDIEChildrenDr As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DKBDIE_Children_Dr ];

Property DKBDIEChildrenType As %String(DISPLAYLIST = ",列表,树形,文本,数据来源", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",L,T,TX,S") [ SqlColumnNumber = 4, SqlFieldName = DKBDIE_Children_Type ];

Property DKBDIEActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DKBDIE_ActiveFlag ];

Property DKBDIECatDr As User.DKBBaseCat [ SqlColumnNumber = 6, SqlFieldName = DKBDIE_Cat_Dr ];

Property DKBDIEExtend As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DKBDIE_Extend ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DKBDGSEXT(0))</SqlIdExpression>
<SQLMap name="CatIndex">
<Global>^DKBDGSEXT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DKBDIE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBDIE_Dia_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBDIE_Cat_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBDIE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DKBDIE_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DKBDIE_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DKBDIE_Children_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBDIE_Children_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DKBDIE_Dia_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DKBDIE_Extend">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DKBDGSEXT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DKBDIE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DKBDIE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DKBDiagnosisExtendS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
