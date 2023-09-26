/// 基础数据平台-临床知识库-知识库目录字典
Class User.DHCPHInstLabel Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PINL_RowID, SqlTableName = DHC_PHInstLabel, StorageStrategy = SQLStorage ]
{

// ^DHCPHPINL

Parameter EXTENTSIZE = 250;

/// PINL_Desc
Property PINLDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PINL_Desc ];

/// PINL_OrderNum
Property PINLOrderNum As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PINL_OrderNum ];

/// PINL_Code
Property PINLCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PINL_Code ];

/// PINL_ManageMode
Property PINLManageMode As %Library.String(DISPLAYLIST = ",Warn,Control,Stat", MAXLEN = 7, SELECTIVITY = "25.0000%", VALUELIST = ",W,C,S") [ SqlColumnNumber = 5, SqlFieldName = PINL_ManageMode ];

/// PINL_Label_Dr 
Property PINLLabelDr As User.DHCPHLibaryLabel [ SqlColumnNumber = 6, SqlFieldName = PINL_Label_Dr ];

/// PINL_Icon
Property PINLIcon As %String [ SqlColumnNumber = 7, SqlFieldName = PINL_Icon ];

/// PINL_AllFlag
Property PINLAllFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PINL_AllFlag ];

/// PINL_AlertMsg  2016/9/30
Property PINLAlertMsg As %String [ SqlColumnNumber = 9, SqlFieldName = PINL_AlertMsg ];

/// PINL_GenFlag  2018/01/26 在通用名目录显示
Property PINLGenFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PINL_GenFlag ];

/// PINL_ProFlag  2018/01/26 在商品名目录显示
Property PINLProFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PINL_ProFlag ];

/// PINL_Href 2018/01/26 js路径
Property PINLHref As %String [ SqlColumnNumber = 12, SqlFieldName = PINL_Href ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHPINL(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PINL_AlertMsg">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PINL_AllFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PINL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PINL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PINL_GenFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PINL_Href">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PINL_Icon">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PINL_Label_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PINL_ManageMode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PINL_OrderNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PINL_ProFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCPHPINL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PINL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PINL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPHPINL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PINL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>$$UPPER({PINL_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PINL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPHPINL</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PINL_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PINL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrderNum">
<Global>^DHCPHPINL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PINL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PINL_OrderNum}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PINL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PINL_RowID</SqlRowIdName>
<StreamLocation>^User.DHCPHInstLabelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
