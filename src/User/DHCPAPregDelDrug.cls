Class User.DHCPAPregDelDrug Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DelDrug_RowID, SqlTableName = DHC_PA_PregDelDrug, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (DelDrugPregDr, DelDrugDelSub, DelDrugChildsub) [ IdKey, PrimaryKey, Unique ];

/// DelDrug_Preg_Dr
Property DelDrugPregDr As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DelDrug_Preg_Dr ];

/// DelDrug_Del_Sub
Property DelDrugDelSub As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = DelDrug_Del_Sub ];

/// Del_Drug_Childsub
Property DelDrugChildsub As %Library.Float [ InitialExpression = {$i(PAPRG(%d(2),"DEL",%d(3),"DELDRUG",0))}, SqlColumnNumber = 4, SqlFieldName = Del_Drug_Childsub ];

/// DelDrug_Drug_Dr
Property DelDrugDrugDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DelDrug_Drug_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="Datamaster">
<Data name="DelDrug_Drug_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAPRG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DelDrug_Preg_Dr</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DelDrug_Del_Sub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>Del_Drug_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DelDrug_Preg_Dr}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DelDrug_Del_Sub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DELDRUG"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Del_Drug_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPAPregDelDrugS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
