Class User.DHCDisGoodsRequest Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlRowIdName = REQ_RowID, SqlTableName = DHC_DisGoodsRequest, StorageStrategy = NewStorage1 ]
{

/// 申请单号/ID  REQ_No
Property REQNo As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = REQ_No ];

/// 申请科室  REQ_Loc_Dr	
Property REQLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = REQ_Loc_Dr ];

/// 接收科室  REQ_RecLoc_Dr	
Property REQRecLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = REQ_RecLoc_Dr ];

/// 陪送日期  REQ_ExeDate	
Property REQExeDate As %Date [ SqlColumnNumber = 5, SqlFieldName = REQ_ExeDate ];

/// 陪送时间  REQ_ExeTime	
Property REQExeTime As %Time [ SqlColumnNumber = 6, SqlFieldName = REQ_ExeTime ];

/// 备注 REQ_Remarks		
Property REQRemarks As %Text(MAXLEN = 300) [ SqlColumnNumber = 7, SqlFieldName = REQ_Remarks ];

/// 创建日期  REQ_CreateDate	
Property REQCreateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = REQ_CreateDate ];

/// 创建时间  REQ_CreateTime	
Property REQCreateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = REQ_CreateTime ];

/// 创建人  REQ_CreateUser	
Property REQCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = REQ_CreateUser ];

/// 当前状态  REQ_CurStatus	
Property REQCurStatus As %Text(MAXLEN = 30) [ SqlColumnNumber = 11, SqlFieldName = REQ_CurStatus ];

/// 条码  REQ_BarCode	
Property REQBarCode As %String [ SqlColumnNumber = 12, SqlFieldName = REQ_BarCode ];

/// 配送类型  REQ_TypeAdd_Dr	
Property REQTypeAddDr As User.DHCDisTypeAdd [ SqlColumnNumber = 13, SqlFieldName = REQ_TypeAdd_Dr ];

/// 是否加急
Property REQEmFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = REQ_EmFlag ];

Relationship ChildDHCDISGOODSREQUEST As User.DHCDisGoodsReqItm [ Cardinality = children, Inverse = REQParRefDr ];

/// 申请单位置  REQ_Loction	
Property REQLoction As %Text(MAXLEN = 30) [ SqlColumnNumber = 15, SqlFieldName = REQ_Loction ];

/// 申请单位置标识  REQ_LoctionFlag	
Property REQLoctionFlag As %Text(MAXLEN = 30) [ SqlColumnNumber = 16, SqlFieldName = REQ_LoctionFlag ];

/// 其他组条码  REQ_ExtBarCode
Property REQExtBarCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 17, SqlFieldName = REQ_ExtBarCode ];

/// 其他条码数量  REQ_ExtNum	
Property REQExtNum As %Text(MAXLEN = 30) [ SqlColumnNumber = 18, SqlFieldName = REQ_ExtNum ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCDISGRE)</SqlIdExpression>
<SQLMap name="IndexBarCode">
<Global>^DHCDISGRE</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BarCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REQ_BarCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCDISGRE</Global>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REQ_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateRecloc">
<Global>^DHCDISGRE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>REQ_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexDateRecloc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REQ_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REQ_RecLoc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExtBarCode">
<Global>^DHCDISGRE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>REQ_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExtBarCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REQ_ExtBarCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDate">
<Global>^DHCDISGRE</Global>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocCreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REQ_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REQ_CreateDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="dataMaster">
<Data name="REQ_BarCode">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="REQ_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REQ_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="REQ_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="REQ_CurStatus">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="REQ_EmFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="REQ_ExeDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REQ_ExeTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REQ_ExtBarCode">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="REQ_ExtNum">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="REQ_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REQ_Loction">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="REQ_LoctionFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="REQ_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REQ_RecLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REQ_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REQ_TypeAdd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCDISGRE</Global>
<Subscript name="1">
<Expression>{REQ_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDisGoodRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
