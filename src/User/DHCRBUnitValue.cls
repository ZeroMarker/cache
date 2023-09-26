Class User.DHCRBUnitValue Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCV_RowID, SqlTableName = DHCRB_UnitValue, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DCVChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCRB_Unit Parent Reference
Relationship DCVParRef As User.DHCRBUnit [ Cardinality = parent, Inverse = ChildDHCRBUnitValue, Required, SqlFieldName = DCV_ParRef ];

/// Child subscript
Property DCVChildSub As %Library.Float [ InitialExpression = {$i(^DHCRB("DHCRBUNITVALUE"))}, Required, SqlColumnNumber = 2, SqlFieldName = DCV_ChildSub ];

/// DCV_Value
Property DCVValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DCV_Value ];

/// DCV_Units
Property DCVUnits As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DCV_Units ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DCV_Units">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCV_Value">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBUnit</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRB_Unit.DCU_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DCV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitValue"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRB_Unit.DCU_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCV_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBUnitValueS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
