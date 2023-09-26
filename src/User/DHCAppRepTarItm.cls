Class User.DHCAppRepTarItm Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AppRepTarItm, StorageStrategy = SQLStorage ]
{

/// ARTI_OrdItem	医嘱id
Property ARTIOrdItem As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = ARTI_OrdItem ];

/// ARTI_Pointer	项目id
Property ARTIPointer As %Library.String [ SqlColumnNumber = 3, SqlFieldName = ARTI_Pointer ];

/// ARTI_Type	“P”部位,”D”，后处理，“O”体位
Property ARTIType As %Library.String(DISPLAYLIST = ",P,D,O", MAXLEN = 3, SELECTIVITY = "25%", VALUELIST = ",P,D,O") [ SqlColumnNumber = 4, SqlFieldName = ARTI_Type ];

/// ARTI_Disc	打折系数
Property ARTIDisc As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = ARTI_Disc ];

/// ARTI_Tar_Dr	收费项id
Property ARTITarDr As User.DHCTarItem [ SqlColumnNumber = 6, SqlFieldName = ARTI_Tar_Dr ];

/// ARTI_UpdDate	更新日期	Date
Property ARTIUpdDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = ARTI_UpdDate ];

/// ARTI_UpdTime	更新时间	Time
Property ARTIUpdTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = ARTI_UpdTime ];

/// ARTI_Qty	收费数量
Property ARTIQty As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ARTI_Qty ];

/// ARTI_Billed	
Property ARTIBilled As %Library.String(DISPLAYLIST = ",ToBill,Bill,Ignore,Refund,Paid", MAXLEN = 3, SELECTIVITY = "25%", VALUELIST = ",TB,B,I,R,P") [ SqlColumnNumber = 10, SqlFieldName = ARTI_Billed ];

/// ARTI_OrdExec	执行记录扩展表id
Property ARTIOrdExec As User.OEOrdExecExt [ SqlColumnNumber = 11, SqlFieldName = ARTI_OrdExec ];

/// ARTI_ReqItm_Dr	申请项目ID
Property ARTIReqItmDr As User.DHCAppRepArc [ SqlColumnNumber = 12, SqlFieldName = ARTI_ReqItm_Dr ];

/// ARTI_PBO_Dr	账单医嘱表指针	
Property ARTIPBODr As User.DHCPatBillOrder [ SqlColumnNumber = 13, SqlFieldName = ARTI_PBO_Dr ];

/// ARTI_Amt	账单金额--暂时不用	
Property ARTIAmt As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = ARTI_Amt ];

/// ARTI_PartFlag	部位标示	
Property ARTIPartFlag As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = ARTI_PartFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPREPTA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ARTI_Amt">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ARTI_Billed">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ARTI_Disc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARTI_OrdExec">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ARTI_OrdItem">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARTI_PBO_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ARTI_PartFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ARTI_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARTI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARTI_ReqItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ARTI_Tar_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ARTI_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARTI_UpdDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ARTI_UpdTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCAPREPTA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{ARTI_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ARTI_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrdExec">
<Global>^DHCAPREPTA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARTI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexOrdExec"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARTI_OrdExec}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARTI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdItem">
<Global>^DHCAPREPTA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARTI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARTI_OrdItem}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARTI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdPointer">
<Global>^DHCAPREPTA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARTI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdPointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARTI_OrdItem}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARTI_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARTI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdTar">
<Global>^DHCAPREPTA</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARTI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdTar"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARTI_OrdItem}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARTI_Tar_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARTI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPBO">
<Global>^DHCAPREPTA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARTI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PBO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARTI_PBO_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARTI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReqItmID">
<Global>^DHCAPREPTA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARTI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReqItm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARTI_ReqItm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARTI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ARTI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCAppRepTarItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
