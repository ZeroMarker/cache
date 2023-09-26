Class User.PIVAState Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PS_RowID, SqlTableName = PIVA_State, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PS_Number
Property PSNumber As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PS_Number ];

/// PS_Name
Property PSName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PS_Name ];

/// PS_Flag
Property PSFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PS_Flag ];

/// PS_SysFlag
Property PSSysFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PS_SysFlag ];

/// PS_RetFlag
Property PSRetFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PS_RetFlag ];

/// PS_DispFlag
Property PSDispFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PS_DispFlag ];

/// PS_Loc_Dr
Property PSLocDr As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = PS_Loc_Dr ];

/// PS_SingleFlag
Property PSSingleFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PS_SingleFlag ];

/// PS_TypeFlag
Property PSTypeFlag As %Library.String(DISPLAYLIST = ",In,Out", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 10, SqlFieldName = PS_TypeFlag ];

/// PS_PackIgnore
Property PSPackIgnore As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PS_PackIgnore ];

/// 打包减库标识
Property PSPackDisp As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PS_PackDisp ];

/// 配置费收取
Property PSFeeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = PS_FeeFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVAS)</SqlIdExpression>
<SQLMap name="DATAMasterPIVAState">
<Data name="PS_DispFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PS_FeeFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PS_Flag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PS_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PS_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PS_Number">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PS_PackDisp">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PS_PackIgnore">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PS_RetFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PS_SingleFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PS_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PS_TypeFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^PIVAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFlagNumber">
<Global>^PIVAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PS_Flag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PS_RetFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PS_Number}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocNumber">
<Global>^PIVAS</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCNUMBER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PS_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PS_Number}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocTypeNumber">
<Global>^PIVAS</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCTYPENUMBER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PS_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PS_TypeFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PS_Number}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNAME">
<Global>^PIVAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NAME"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PS_Name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^PIVAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NUMBER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PS_Number}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVAStateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^PIVAS)
	s oldI = +$g(^mdata("PIVASTATE"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^PIVAS = maxI
	s ^mdata("PIVASTATE") = maxI
}

}
