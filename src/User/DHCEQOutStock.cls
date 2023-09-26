Class User.DHCEQOutStock Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OS_RowID, SqlTableName = DHC_EQOutStock, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OS_OutStockNo
Property OSOutStockNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = OS_OutStockNo ];

/// OS_OutStockLocDR
Property OSOutStockLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OS_OutStockLocDR ];

/// OS_OutTypeDR
Property OSOutTypeDR As User.DHCEQCOutType [ SqlColumnNumber = 4, SqlFieldName = OS_OutTypeDR ];

/// OS_ToDR
Property OSToDR As User.DHCEQCFromToDept [ SqlColumnNumber = 5, SqlFieldName = OS_ToDR ];

/// OS_OutStockDate
Property OSOutStockDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = OS_OutStockDate ];

/// OS_MakerDR
Property OSMakerDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = OS_MakerDR ];

/// OS_MakeDate
Property OSMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = OS_MakeDate ];

/// OS_AckUserDR
Property OSAckUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = OS_AckUserDR ];

/// OS_AckDate
Property OSAckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = OS_AckDate ];

/// OS_AckTime
Property OSAckTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = OS_AckTime ];

/// OS_BillAckUserDR
Property OSBillAckUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = OS_BillAckUserDR ];

/// OS_BillAckDate
Property OSBillAckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = OS_BillAckDate ];

/// OS_BillAckTime
Property OSBillAckTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = OS_BillAckTime ];

/// OS_Status
Property OSStatus As %Library.String(DISPLAYLIST = ",新增,提交,出库审核,账目审核", MAXLEN = 4, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 15, SqlFieldName = OS_Status ];

/// OS_Remark
Property OSRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = OS_Remark ];

/// OS_EquipTypeDR
Property OSEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 17, SqlFieldName = OS_EquipTypeDR ];

/// OS_StatCatDR
Property OSStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 18, SqlFieldName = OS_StatCatDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQOutStock("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OS_AckDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OS_AckTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OS_AckUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OS_BillAckDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OS_BillAckTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OS_BillAckUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OS_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OS_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OS_MakerDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OS_OutStockDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OS_OutStockLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OS_OutStockNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OS_OutTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OS_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="OS_Status">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OS_ToDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQOutStock</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAckDataStat">
<Global>^DHCEQOutStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>OS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OS_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"AckDateStat"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OS_AckDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"StatCat"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{OS_StatCatDR}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{OS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutStockNo">
<Global>^DHCEQOutStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OutStockNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OS_OutStockNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutType">
<Global>^DHCEQOutStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OutType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OS_OutTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQOutStockS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
