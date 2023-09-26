Class User.PIVALocBatCubage Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PLBATCU_RowID, SqlTableName = PIVA_LocBatCubage, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PLBATCUChildSub [ IdKey, PrimaryKey, Unique ];

/// PIVA_LocBat Parent Reference
Relationship PLBATCUParrefDR As User.PIVALocBat [ Cardinality = parent, Inverse = ChildPIVALocBatCubage, Required, SqlFieldName = PLBATCU_Parref_DR ];

/// PLBATCU_ChildSub
Property PLBATCUChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PLBATCU_ChildSub ];

/// PLBATCU_MAX
Property PLBATCUMAX As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PLBATCU_MAX ];

/// PLBATCU_BatNo
Property PLBATCUBatNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PLBATCU_BatNo ];

/// PLBATCU_MIN
Property PLBATCUMIN As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PLBATCU_MIN ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="Master">
<Data name="PLBATCU_BatNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PLBATCU_MAX">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PLBATCU_MIN">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PIVALBATCU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_LocBat.PLBAT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PLBATCU_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PIVA_LocBat.PLBAT_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cub"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PLBATCU_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PIVALocBatCubageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
