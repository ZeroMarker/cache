Class User.DHCJFSSGrpDepTypeConfig Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Grp_RowId, SqlTableName = DHC_JFSSGrpDepTypeConfig, StorageStrategy = SQLStorage ]
{

/// Grp_Dr
Property GrpDr As User.SSGroup [ SqlColumnNumber = 2, SqlFieldName = Grp_Dr ];

/// Grp_DepType_Dr
Property GrpDepTypeDr As User.ARCDepType [ SqlColumnNumber = 3, SqlFieldName = Grp_DepType_Dr ];

/// Grp_Default
Property GrpDefault As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Grp_Default ];

/// Grp_Comment1
Property GrpComment1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Grp_Comment1 ];

/// Grp_Comment2
Property GrpComment2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Grp_Comment2 ];

/// Grp_Hosp_Dr
Property GrpHospDr As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = Grp_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFSSGRPDEPTYPECONFIG)</SqlIdExpression>
<SQLMap name="IndexGrp">
<Global>^DHCJFSSGRPDEPTYPECONFIG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Grp_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Grp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Grp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Grp_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="Grp_Comment1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Grp_Comment2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Grp_Default">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Grp_DepType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Grp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Grp_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCJFSSGRPDEPTYPECONFIG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Grp_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Grp_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCJFSSGrpDepTypeConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
