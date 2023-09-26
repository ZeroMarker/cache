/// 卡片购入管理
Class User.DHCCardPurchaseManage Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHC_CardPurchaseManage, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CPM_Date
Property CPMDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = CPM_Date ];

/// CPM_Loc
Property CPMLoc As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = CPM_Loc ];

/// CPM_Buyer
Property CPMBuyer As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = CPM_Buyer ];

/// CPM_Amount
Property CPMAmount As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = CPM_Amount ];

/// CPM_StartNum
Property CPMStartNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CPM_StartNum ];

/// CPM_EndNum
Property CPMEndNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CPM_EndNum ];

/// CPM_Note
Property CPMNote As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CPM_Note ];

/// CPM_UpdateUsr
Property CPMUpdateUsr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = CPM_UpdateUsr ];

/// CPM_UpdateDat
Property CPMUpdateDat As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = CPM_UpdateDat ];

/// Card Purchase using available flag
Property CPMAvail As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = CPM_Avail ];

Property CPMHospital As User.CTHospital [ SqlColumnNumber = 12, SqlFieldName = CPM_Hospital ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCARDManage("Purchase",0))</SqlIdExpression>
<SQLMap name="MainData">
<Data name="CPM_Amount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CPM_Avail">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CPM_Buyer">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CPM_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CPM_EndNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CPM_Hospital">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CPM_Loc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CPM_Note">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CPM_StartNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CPM_UpdateDat">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CPM_UpdateUsr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCCARDManage</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CPM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Purchase"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CPM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CPM_RowID</SqlRowIdName>
<StreamLocation>^User.DHCCardPurchaseManageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
