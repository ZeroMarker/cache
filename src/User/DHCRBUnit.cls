Class User.DHCRBUnit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCU_RowID, SqlTableName = DHCRB_Unit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCRBUnitValue As User.DHCRBUnitValue [ Cardinality = children, Inverse = DCVParRef ];

/// DCU_Name
Property DCUName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DCU_Name ];

/// DCU_Code
Property DCUCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DCU_Code ];

/// DCU_Type
Property DCUType As %Library.String(DISPLAYLIST = ",Text,Number,Select", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",T,N,S") [ SqlColumnNumber = 4, SqlFieldName = DCU_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBUnit("Unit"))</SqlIdExpression>
<SQLMap name="MasterDataIndex">
<Data name="DCU_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCU_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCU_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBUnit</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DCU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Unit"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCU_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBUnitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
