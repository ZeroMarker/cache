Class User.DHCDocOrderVirtualtLong Extends %Persistent [ SqlRowIdName = ORDVL_RowID, SqlTableName = DHCDoc_OrderVirtualtLong, StorageStrategy = SQLStorage ]
{

Property ORDVLOrdItemDR As OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = ORDVL_OrdItem_DR ];

Property ORDVLStatDR As OECOrderStatus [ SqlColumnNumber = 3, SqlFieldName = ORDVL_Stat_DR ];

/// Des Ref to CTPCP
Property ORDVLDoctorDR As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = ORDVL_Doctor_DR ];

/// Order Start Date
Property ORDVLSttDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ORDVL_SttDate ];

/// Order Start Time
Property ORDVLSttTime As %Time [ SqlColumnNumber = 6, SqlFieldName = ORDVL_SttTime ];

/// Date
Property ORDVLDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = ORDVL_Date ];

/// Time(No of Times)
Property ORDVLTime As %Time [ SqlColumnNumber = 8, SqlFieldName = ORDVL_Time ];

/// Cross Out Date
Property ORDVLXDate As %Date [ SqlColumnNumber = 9, SqlFieldName = ORDVL_XDate ];

/// Cross Out Time
Property ORDVLXTime As %Time [ SqlColumnNumber = 10, SqlFieldName = ORDVL_XTime ];

/// X out Doctor
Property ORDVLXCTCPDR As CTCareProv [ SqlColumnNumber = 11, SqlFieldName = ORDVL_XCTCP_DR ];

Property ORDVLOrdLinkItemDR As OEOrdItem [ SqlColumnNumber = 12, SqlFieldName = ORDVL_OrdLinkItem_DR ];

Property ORDVLLastUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = ORDVL_LastUpdateDate ];

Property ORDVLLastUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = ORDVL_LastUpdateTime ];

/// End Date
Property ORDVLEndDate As %Date [ SqlColumnNumber = 15, SqlFieldName = ORDVL_EndDate ];

/// End Time
Property ORDVLEndTime As %Time [ SqlColumnNumber = 16, SqlFieldName = ORDVL_EndTime ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDocORDVL(0))</SqlIdExpression>
<SQLMap name="DataMastMap">
<Data name="ORDVL_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ORDVL_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ORDVL_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ORDVL_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ORDVL_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ORDVL_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ORDVL_OrdItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ORDVL_OrdLinkItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ORDVL_Stat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ORDVL_SttDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ORDVL_SttTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ORDVL_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ORDVL_XCTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ORDVL_XDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ORDVL_XTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCDocORDVL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ORDVL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ORDVL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrdItem">
<Global>^DHCDocORDVLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORDVL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdItemDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORDVL_OrdItem_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORDVL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdLinkItem">
<Global>^DHCDocORDVLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ORDVL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORDLINKDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORDVL_OrdLinkItem_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORDVL_OrdItem_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORDVL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocOrderVirtualtLongS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
