/// ARC Order Set Date(1209)
Class User.ARCOrdSetDate Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_OrdSetDate, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DATEChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildARCOrdSetDateItem As ARCOrdSetDateItem [ Cardinality = children, Inverse = ITMParRef ];

Relationship ChildARCOrdSetDateOS As ARCOrdSetDateOS [ Cardinality = children, Inverse = OSParRef ];

/// ARC_OrdSets Parent Reference
Relationship DATEParRef As ARCOrdSets [ Cardinality = parent, Inverse = ChildARCOrdSetDate, Required, SqlFieldName = DATE_ParRef ];

/// Childsub
Property DATEChildsub As %Float [ InitialExpression = {$i(^ARCOS($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DATE",0))}, SqlColumnNumber = 2, SqlFieldName = DATE_Childsub ];

/// Date From
Property DATEDateFrom As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = DATE_DateFrom ];

/// Date To
Property DATEDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DATE_DateTo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DATE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DATE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARCOS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_OrdSets.ARCOS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DATE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DATE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateFrom">
<Global>^ARCOS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_OrdSets.ARCOS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DATE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DateFrom"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DATE_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DATE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateTo">
<Global>^ARCOS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_OrdSets.ARCOS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DATE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DateTo"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DATE_DateTo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DATE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DATE_RowId</SqlRowIdName>
<StreamLocation>^User.ARCOrdSetDateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
