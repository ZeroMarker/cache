Class User.PHAINLocDrugDocItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = LDDI_RowId, SqlTableName = PHAIN_LocDrugDocItm, StorageStrategy = SQLStorage ]
{

Index ArcIDKeyIndex On (LDDIPARREF, LDDICTCPDr) [ Unique ];

Index RowIDBasedIDKeyIndex On LDDICHILDSUB [ IdKey, PrimaryKey, Unique ];

Relationship LDDIPARREF As User.PHAINLocDrugList [ Cardinality = parent, Inverse = ChildDHCLDDL, Required, SqlFieldName = LDDI_PARREF ];

/// LDDI_CHILDSUB
Property LDDICHILDSUB As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = LDDI_CHILDSUB ];

/// LDDI_CTCP_Dr  医护人员表指向
Property LDDICTCPDr As User.CTCareProv [ SqlColumnNumber = 3, SqlFieldName = LDDI_CTCP_Dr ];

Storage SQLStorage
{
<SQLMap name="IndexCTCP">
<Global>^CF.PHA.IN.LocDrugDocItm</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHAIN_LocDrugList.LDL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>LDDI_CHILDSUB</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CTCP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LDDI_CTCP_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAIN_LocDrugList.LDL_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LDDI_CHILDSUB}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="LDLIMASTER">
<Data name="LDDI_CTCP_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CF.PHA.IN.LocDrugDocItm</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_LocDrugList.LDL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LDDI_CHILDSUB</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_LocDrugList.LDL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LDDI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LDDI_CHILDSUB}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LDDI_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINLocDrugDocItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
