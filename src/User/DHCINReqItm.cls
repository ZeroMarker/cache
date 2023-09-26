Class User.DHCINReqItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INRQI_RowId, SqlTableName = DHC_INReqItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INRQI_INRQI_DR User.INReqItm
Property INRQIINRQIDR As User.INReqItm [ SqlColumnNumber = 2, SqlFieldName = INRQI_INRQI_DR ];

/// INRQI_Remark
Property INRQIRemark As %Library.String(MAXLEN = 60) [ SqlColumnNumber = 3, SqlFieldName = INRQI_Remark ];

/// INRQI_QtyApproved
Property INRQIQtyApproved As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = INRQI_QtyApproved ];

/// INRQI_ProReqQty
Property INRQIProReqQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = INRQI_ProReqQty ];

/// INRQI_FinishFlag,"Y"代表完成,"N"或空为未完成
Property INRQIFinishFlag As %Library.String(MAXLEN = 4) [ SqlColumnNumber = 6, SqlFieldName = INRQI_FinishFlag ];

/// INRQI_SpecList
Property INRQISpecList As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INRQI_SpecList ];

/// INRQI_HandleType
Property INRQIHandleType As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INRQI_HandleType ];

/// INRQI_Canceled 
Property INRQICanceled As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = INRQI_Canceled ];

/// INRQI_CanceledUser_DR
Property INRQICanceledUserDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = INRQI_CanceledUser_DR ];

/// INRQI_CanceledDate
Property INRQICanceledDate As %Library.Date [ SqlColumnNumber = 11, SqlFieldName = INRQI_CanceledDate ];

/// INRQI_CanceledTime
Property INRQICanceledTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = INRQI_CanceledTime ];

/// INRQI_RefuseDate
Property INRQIRefuseDate As %Library.Date [ SqlColumnNumber = 13, SqlFieldName = INRQI_RefuseDate ];

/// INRQI_RefuseTime
Property INRQIRefuseTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = INRQI_RefuseTime ];

/// INRQI_RefuseUser_DR
Property INRQIRefuseUserDR As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = INRQI_RefuseUser_DR ];

/// INRQI_RefuseReason_DR 
Property INRQIRefuseReasonDR As User.DHCReasonForRefuseRequest [ SqlColumnNumber = 16, SqlFieldName = INRQI_RefuseReason_DR ];

/// INRQI_ReservedQty
Property INRQIReservedQty As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = INRQI_ReservedQty ];

/// INRQI_StkUsedDays
Property INRQIStkUsedDays As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INRQI_StkUsedDays ];

/// INRQI_DispQty
Property INRQIDispQty As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = INRQI_DispQty ];

/// INRQI_ArriveDays(要求到货天数)
Property INRQIArriveDays As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INRQI_ArriveDays ];

/// INRQI_ExpDateDays(要求效期天数)
Property INRQIExpDateDays As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INRQI_ExpDateDays ];

/// 建议数量调整原因
Property INRQIAdjReasonDr As User.DHCStkComDictionary [ SqlColumnNumber = 22, SqlFieldName = INRQI_AdjReason_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCINRQI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INRQI_AdjReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INRQI_ArriveDays">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INRQI_Canceled">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INRQI_CanceledDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INRQI_CanceledTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INRQI_CanceledUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INRQI_DispQty">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INRQI_ExpDateDays">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INRQI_FinishFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INRQI_HandleType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INRQI_INRQI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INRQI_ProReqQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INRQI_QtyApproved">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INRQI_RefuseDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INRQI_RefuseReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INRQI_RefuseTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INRQI_RefuseUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INRQI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INRQI_ReservedQty">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INRQI_SpecList">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INRQI_StkUsedDays">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^DHCINRQI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INRQI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INRQI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINRQI">
<Global>^DHCINRQI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRQI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INRQI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INRQI_INRQI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INRQI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INRQI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCINReqItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINRQI)
	s oldI = +$g(^mdata("DHCINREQITM"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINRQI = maxI
	s ^mdata("DHCINREQITM") = maxI
}

}
