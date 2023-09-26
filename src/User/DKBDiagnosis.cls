/// 诊断字典表：DKB_Diagnosis
Class User.DKBDiagnosis Extends %Persistent [ SqlRowIdName = DKBDi_RowId, SqlTableName = DKB_Diagnosis, StorageStrategy = SQLStorage ]
{

//^DKBDIAGNO

Property DKBDiCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DKBDi_Code ];

Property DKBDiDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DKBDi_Desc ];

Property DKBDiPositionDR As User.DKBPositionCat [ SqlColumnNumber = 4, SqlFieldName = DKBDi_PositionDR ];

Property DKBDiPathogenyDR As User.DKBPathogenyCat [ SqlColumnNumber = 5, SqlFieldName = DKBDi_PathogenyDR ];

Property DKBDiRemark As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DKBDi_Remark ];

Property DKBDiActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DKBDi_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DKBDIAGNO(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DKBDIAGNO</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBDi_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({DKBDi_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBDi_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="DKBDi_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DKBDi_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DKBDi_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBDi_PathogenyDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DKBDi_PositionDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DKBDi_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DKBDIAGNO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DKBDi_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DKBDi_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DKBDIAGNO</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBDi_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({DKBDi_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBDi_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DKBDiagnosisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
