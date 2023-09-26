/// 基础数据平台-临床知识库-单位对照表
Class User.DHCPHUomContrast Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHUCT_RowId, SqlTableName = DHC_PHUomContrast, StorageStrategy = SQLStorage ]
{

// ^DHCPHUOCON

Property PHUCTUomCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHUCT_UomCode ];

Property PHUCTUomDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHUCT_UomDesc ];

Property PHUCTHisUomCode As %String [ SqlColumnNumber = 4, SqlFieldName = PHUCT_HisUomCode ];

Property PHUCTHisUomDesc As %String [ SqlColumnNumber = 5, SqlFieldName = PHUCT_HisUomDesc ];

Property PHUCTFactor As %String [ SqlColumnNumber = 6, SqlFieldName = PHUCT_Factor ];

Property PHUCTHisFactor As %String [ SqlColumnNumber = 7, SqlFieldName = PHUCT_HisFactor ];

Property PHUCTHospDr As %String [ SqlColumnNumber = 8, SqlFieldName = PHUCT_Hosp_Dr ];

Property PHUCTSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PHUCT_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHUOCON(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHUOCON</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHUCT_UomCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHUCT_HisUomCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHUCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHisCode">
<Global>^DHCPHUOCON</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHUCT_HisUomCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHUCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHUCT_Factor">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHUCT_HisFactor">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHUCT_HisUomCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHUCT_HisUomDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHUCT_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHUCT_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHUCT_UomCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHUCT_UomDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHUOCON</Global>
<Subscript name="1">
<Expression>{PHUCT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHUCT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHUomContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
