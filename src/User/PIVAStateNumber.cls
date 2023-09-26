Class User.PIVAStateNumber Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PSN_RowID, SqlTableName = PIVA_StateNumber, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PSN_Number
Property PSNNumber As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PSN_Number ];

/// PSN_Name
Property PSNName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PSN_Name ];

/// PSN_ActiveFlag
Property PSNActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PSN_ActiveFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVASN)</SqlIdExpression>
<SQLMap name="DATAMaster">
<Data name="PSN_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PSN_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PSN_Number">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PIVASN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PSN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PSN_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PIVAStateNumberS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s maxI = $o(^PIVASN(""), -1)
	s ^PIVASN = maxI
	s ^mdata("PIVASTATE") = maxI
}

}
