Class User.PIVAOrderLinkInstruc Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = POLS_RowID, SqlTableName = PIVA_OrderLinkInstruc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On POLSChildsub [ IdKey, PrimaryKey, Unique ];

/// PIVA_OrderLink Parent Reference
Relationship POLSPOLParRef As User.PIVAOrderLink [ Cardinality = parent, Inverse = ChildPIVAOrderLinkInstruc, Required, SqlFieldName = POLS_POL_ParRef ];

/// POLS_Childsub
Property POLSChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = POLS_Childsub ];

/// POLS_PHCInstruc_Dr
Property POLSPHCInstrucDr As User.PHCInstruc [ SqlColumnNumber = 3, SqlFieldName = POLS_PHCInstruc_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterPOLS">
<Data name="POLS_Childsub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="POLS_PHCInstruc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="POLS_POL_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^POLI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_OrderLink.POL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>POLS_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIVA_OrderLink.POL_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POLS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInstruc">
<Global>^POLI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIVA_OrderLink.POL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>POLS_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INSTRUCDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POLS_PHCInstruc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIVA_OrderLink.POL_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POLS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVAOrderLinkInstrucS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
