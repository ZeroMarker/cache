Class User.MRDiagnosPropertyLog Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = MR_DiagnosProperty_Log, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DiagPChildSub [ IdKey, PrimaryKey, Unique ];

Relationship DiagPParRef As MRDiagnosProperty [ Cardinality = parent, Inverse = ChildMRDiagnosProperty, Required, SqlFieldName = DiagP_ParRef ];

Property DiagPChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"DIAGPL",0))}, Required, SqlColumnNumber = 2, SqlFieldName = DiagP_ChildSub ];

Property DiagPUpdateContent As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = DiagP_Update_Content ];

Property DiagPUpdateUserDR As SSUser [ SqlColumnNumber = 4, SqlFieldName = DiagP_UpdateUser_DR ];

Property DiagPUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = DiagP_UpdateDate ];

Property DiagPUpdateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = DiagP_UpdateTime ];

Storage SQLStorage
{
<SQLMap name="DataMasterMap">
<Data name="DiagP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DiagP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DiagP_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DiagP_Update_Content">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_DiagnosProperty.MRDiagnosP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DiagP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MR_DiagnosProperty.MRDiagnosP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIAGPL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DiagP_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MRDiagnosPL_RowID</SqlRowIdName>
<StreamLocation>^User.MRDiagnosPropertyLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
