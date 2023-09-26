Class User.DHCInciInfoMustInput Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = INCMI_RowId, SqlTableName = DHC_InciInfoMustInput, StorageStrategy = SQLStorage ]
{

/// 控件id
Property INCMIElementId As %Library.String(COLLATION = "Exact", MAXLEN = 45, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INCMI_ElementId ];

/// 控件名称
Property INCMIElementName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INCMI_ElementName ];

/// 控件所在csp
Property INCMICspName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INCMI_CspName ];

/// 是否必填标志
Property INCMIMustFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = INCMI_MustFlag ];

/// 控件所在Block
Property INCMIBlock As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INCMI_Block ];

/// 控件Label 
Property INCMIElementLabel As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INCMI_ElementLabel ];

/// INCMI_Loc_Dr 
Property INCMILocDr As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INCMI_Loc_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^INCMI)</SqlIdExpression>
<SQLMap name="DataMasterINCMI">
<Data name="INCMI_Block">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INCMI_CspName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCMI_ElementId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCMI_ElementLabel">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INCMI_ElementName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INCMI_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INCMI_MustFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^INCMI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INCMI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INCMI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBlock">
<Global>^INCMI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCMI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Block"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCMI_Block}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCMIEID">
<Global>^INCMI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INCMI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCMID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCMI_ElementId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCMI_CspName}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INCMI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCInciInfoMustInputS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^INCMI)
	s oldI = +$g(^mdata("DHCINCIINFOMUSTINPUT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^INCMI = maxI
	s ^mdata("DHCINCIINFOMUSTINPUT") = maxI
}

}
