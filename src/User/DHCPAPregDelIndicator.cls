Class User.DHCPAPregDelIndicator Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Indict_RowID, SqlTableName = DHC_PA_PregDelIndicator, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (IndictPregDr, IndictDelSub, Indictchildsub) [ IdKey, PrimaryKey, Unique ];

/// Indict_Preg_Dr
Property IndictPregDr As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = Indict_Preg_Dr ];

/// Indict_Del_Sub
Property IndictDelSub As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = Indict_Del_Sub ];

/// Indict_childsub
Property Indictchildsub As %Library.Float [ InitialExpression = {$i(PAPRG(%d(2),"DEL",%d(3),"INDICT",0))}, SqlColumnNumber = 4, SqlFieldName = Indict_childsub ];

/// Indict_Code_Dr
Property IndictCodeDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Indict_Code_Dr ];

/// Indict_text
Property Indicttext As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Indict_text ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="Indict_Code_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Indict_text">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAPRG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Indict_Preg_Dr</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>Indict_Del_Sub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>Indict_childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Indict_Preg_Dr}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Indict_Del_Sub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"INDICT"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Indict_childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPAPregDelIndicatorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
