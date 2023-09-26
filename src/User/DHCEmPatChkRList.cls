Class User.DHCEmPatChkRList Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = PCR_RowId, SqlTableName = DHC_EmPatChkRList, StorageStrategy = SQLStorage ]
{

/// 出租物品id  PCR_Rent_Dr
Property PCRRentDr As User.DHCEmRentList [ SqlColumnNumber = 2, SqlFieldName = PCR_Rent_Dr ];

/// 租，还 标志  PCR_Flag
Property PCRFlag As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PCR_Flag ];

/// 租用日期   PCR_Date
Property PCRDate As %Date [ SqlColumnNumber = 4, SqlFieldName = PCR_Date ];

/// 租用时间   PCR_Time
Property PCRTime As %Time [ SqlColumnNumber = 5, SqlFieldName = PCR_Time ];

/// 租用操作人  PCR_Operator
Property PCROperator As %String [ SqlColumnNumber = 6, SqlFieldName = PCR_Operator ];

/// 租赁人   PCR_Renter
Property PCRRenter As %String [ SqlColumnNumber = 7, SqlFieldName = PCR_Renter ];

/// 租赁人联系方式 PCR_RenterTel
Property PCRRenterTel As %String [ SqlColumnNumber = 8, SqlFieldName = PCR_RenterTel ];

/// 证件类型   PCR_CardType
Property PCRCardType As %String [ SqlColumnNumber = 9, SqlFieldName = PCR_CardType ];

/// 现金  PCR_Cash
Property PCRCash As %String [ SqlColumnNumber = 10, SqlFieldName = PCR_Cash ];

/// 现金编号  PCR_CashNo
Property PCRCashNo As %String(MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = PCR_CashNo ];

/// 归还者姓名  PCR_GiveUser
Property PCRGiveUser As %String [ SqlColumnNumber = 12, SqlFieldName = PCR_GiveUser ];

/// 归还者关系  PCR_GiveRelation
Property PCRGiveRelation As %String [ SqlColumnNumber = 13, SqlFieldName = PCR_GiveRelation ];

/// 归还日期
Property PCRGiveDate As %Date [ SqlColumnNumber = 14, SqlFieldName = PCR_GiveDate ];

/// 归还时间
Property PCRGiveTime As %Time [ SqlColumnNumber = 15, SqlFieldName = PCR_GiveTime ];

/// 归还操作人
Property PCRGiveOpUser As %String [ SqlColumnNumber = 16, SqlFieldName = PCR_GiveOpUser ];

/// 医院ID
Property PCRHospDr As User.CTHospital [ SqlColumnNumber = 17, SqlFieldName = PCR_Hosp_Dr ];

/// 备注
Property PCRNote As %String [ SqlColumnNumber = 18, SqlFieldName = PCR_Note ];

/// 关联患者ID
Property PCRPatMasDr As User.PAPatMas [ SqlColumnNumber = 19, SqlFieldName = PCR_PatMas_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMPCR)</SqlIdExpression>
<SQLMap name="Master">
<Data name="PCR_CardType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PCR_Cash">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PCR_CashNo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PCR_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCR_Flag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCR_GiveDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PCR_GiveOpUser">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PCR_GiveRelation">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PCR_GiveTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PCR_GiveUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PCR_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PCR_Note">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PCR_Operator">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCR_PatMas_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PCR_Rent_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCR_Renter">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCR_RenterTel">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCR_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMPCR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="rentDateIndex">
<Global>^DHCEMPCRi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PCR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"rentDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCR_Time}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PCR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkRListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
