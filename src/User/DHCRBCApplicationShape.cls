Class User.DHCRBCApplicationShape Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DAS_Rowid, SqlTableName = DHCRBC_ApplicationShape, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCRBCApplicationShapeFie As User.DHCRBCApplicationShapeFie [ Cardinality = children, Inverse = DASFParRef ];

/// DAS_ComponentName
Property DASComponentName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DAS_ComponentName ];

/// DAS_PrintTempName
Property DASPrintTempName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DAS_PrintTempName ];

/// DAS_ComponentID
Property DASComponentID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DAS_ComponentID ];

/// DAS_HtmlTempleContent
Property DASHtmlTempleContent As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DAS_HtmlTempleContent ];

/// DAS_HospitalID
Property DASHospitalID As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = DAS_HospitalID ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBApp("Shape"))</SqlIdExpression>
<SQLMap name="MasterDataMAP">
<Data name="DAS_ComponentID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DAS_ComponentName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DAS_HospitalID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DAS_HtmlTempleContent">
<Node>"html"</Node>
</Data>
<Data name="DAS_PrintTempName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBApp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DAS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Shape"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCApplicationShapeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
