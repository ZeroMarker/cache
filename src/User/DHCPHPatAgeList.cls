/// 基础数据平台-临床知识库-年龄字典
Class User.DHCPHPatAgeList Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PDA_RowID, SqlTableName = DHC_PHPatAgeList, StorageStrategy = SQLStorage ]
{

// ^DHCPHPAGEL

Parameter EXTENTSIZE = 250;

/// PDA_AgeCode
Property PDAAgeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PDA_AgeCode ];

/// PDA_AgeDesc
Property PDAAgeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PDA_AgeDesc ];

/// PDA_AgeMin
Property PDAAgeMin As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PDA_AgeMin ];

/// PDA_AgeMax
Property PDAAgeMax As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PDA_AgeMax ];

/// PDA_ActiveFlag
Property PDAActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PDA_ActiveFlag ];

/// PDA_SysFlag
Property PDASysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PDA_SysFlag ];

Property PDAUomDr As User.DHCPHExtUom [ SqlColumnNumber = 8, SqlFieldName = PDA_Uom_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHPAGEL(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHPAGEL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PDA_AgeCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="PDA_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDA_AgeCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDA_AgeDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDA_AgeMax">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDA_AgeMin">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDA_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDA_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPHPAGEL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PDA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHPAGEL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PDA_AgeDesc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDA_RowID</SqlRowIdName>
<StreamLocation>^User.DHCPHPatAgeListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
