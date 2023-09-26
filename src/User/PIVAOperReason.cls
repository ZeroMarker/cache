Class User.PIVAOperReason Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = POR_RowID, SqlTableName = PIVA_OperReason, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// POR_Code
Property PORCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = POR_Code ];

/// POR_Desc
Property PORDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = POR_Desc ];

/// POR_Type
Property PORType As %Library.String(DISPLAYLIST = ",Cancel,Refuse,PASS,UnNormalPack,BatUp", MAXLEN = 6, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",C,R,P,UNP,BU") [ SqlColumnNumber = 4, SqlFieldName = POR_Type ];

/// POR_Flag
Property PORFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = POR_Flag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVAOR)</SqlIdExpression>
<SQLMap name="Indextype">
<Global>^PIVAOR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>POR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POR_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterPIVAOperReason">
<Data name="POR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="POR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="POR_Flag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="POR_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PIVAOR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>POR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{POR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PIVAOperReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^PIVAOR)
	s oldI = +$g(^mdata("PIVAOPERREASON"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^PIVAOR = maxI
	s ^mdata("PIVAOPERREASON") = maxI
}

}
