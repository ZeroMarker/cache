/// 药品商品名字典表　
/// 2016-09-30
/// 谷雪萍
Class User.DHCPHProName Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHN_RowId, SqlTableName = DHC_PHProName, StorageStrategy = SQLStorage ]
{

// ^DHCPHPNA

Property PHNCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHN_Code ];

Property PHNDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHN_Desc ];

Property PHNActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHN_ActiveFlag ];

Property PHNSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PHN_SysFlag ];

// 剂型2017-02-24

Property PHNFormDr As User.DHCPHExtForm [ SqlColumnNumber = 6, SqlFieldName = PHN_Form_Dr ];

// 厂家 2017-02-24

Property PHNFactory As %String [ SqlColumnNumber = 7, SqlFieldName = PHN_Factory ];

// 通用名指针 2017-03-20

Property PHNGenericDr As User.DHCPHExtGeneric [ SqlColumnNumber = 8, SqlFieldName = PHN_Generic_Dr ];

// 草药毒性字典指针 2017-07-19

Property PHNToxicity As User.DHCPHToxicity [ SqlColumnNumber = 9, SqlFieldName = PHN_Toxicity ];

// 是否整支 2017-11-28

Property PHNWholeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PHN_WholeFlag ];

// 厂家字典表 2017-11-29

Property PHNManfDR As User.DHCPHManf [ SqlColumnNumber = 11, SqlFieldName = PHN_Manf_DR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHPNA(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHPNA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHN_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHN_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHPNA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHN_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHN_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="GenIndex">
<Global>^DHCPHPNA</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Gen"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHN_Generic_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ManfDRIndex">
<Global>^DHCPHPNA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHN_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Manf"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHN_Manf_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHN_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHN_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHN_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHN_Factory">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHN_Form_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHN_Generic_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHN_Manf_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHN_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHN_Toxicity">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHN_WholeFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCPHPNA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHN_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHN_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHN_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHProNameS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
