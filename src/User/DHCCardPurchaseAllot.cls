/// 卡片分配管理
Class User.DHCCardPurchaseAllot Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHC_CardPurchaseAllot, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CPA_Date
Property CPADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = CPA_Date ];

/// CPA_Loc
Property CPALoc As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = CPA_Loc ];

/// CPA_Buyer
Property CPAUser As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = CPA_User ];

/// CPA_Amount
Property CPAAmount As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = CPA_Amount ];

/// CPA_StartNum
Property CPAStartNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CPA_StartNum ];

/// CPA_EndNum
Property CPAEndNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CPA_EndNum ];

/// CPA_Left
Property CPALeft As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = CPA_Left ];

/// CPA_Note
Property CPANote As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CPA_Note ];

/// CPA_UpdateUsr
Property CPAUpdateUsr As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = CPA_UpdateUsr ];

/// CPA_UpdateDat
Property CPAUpdateDat As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = CPA_UpdateDat ];

/// Card Purchase using available flag
Property CPAAvail As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = CPA_Avail ];

Property CPAHospital As User.CTHospital [ SqlColumnNumber = 13, SqlFieldName = CPA_Hospital ];

Property CPAPreManageDr As User.DHCCardPurchaseManage [ SqlColumnNumber = 14, SqlFieldName = CPA_PreManageDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCARDManage("PurchaseAllot",0))</SqlIdExpression>
<SQLMap name="IndexManageDr">
<Global>^DHCCARDManage</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CPA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PurchaseAllot"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PreManageDr"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CPA_PreManageDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CPA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCCARDManage</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CPA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PurchaseAllot"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CPA_User}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CPA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MainData">
<Data name="CPA_Amount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CPA_Avail">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CPA_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CPA_EndNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CPA_Hospital">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CPA_Left">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CPA_Loc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CPA_Note">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CPA_PreManageDr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CPA_StartNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CPA_UpdateDat">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CPA_UpdateUsr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CPA_User">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCARDManage</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CPA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PurchaseAllot"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CPA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CPA_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCCardPurchaseAllotS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
