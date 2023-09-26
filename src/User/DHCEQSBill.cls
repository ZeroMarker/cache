Class User.DHCEQSBill Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = B_RowID, SqlTableName = DHC_EQSBill, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// B_BillNo
Property BBillNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = B_BillNo ];

/// B_FromHospitalDR
Property BFromHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = B_FromHospitalDR ];

/// B_ToHospitalDR
Property BToHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = B_ToHospitalDR ];

/// B_ShareType
Property BShareType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = B_ShareType ];

/// B_StartDate
Property BStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = B_StartDate ];

/// B_EndDate
Property BEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = B_EndDate ];

/// B_PayLocDR
Property BPayLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = B_PayLocDR ];

/// B_ChargeLocDR
Property BChargeLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = B_ChargeLocDR ];

/// B_TotalFee
Property BTotalFee As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = B_TotalFee ];

/// B_CostFee
Property BCostFee As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = B_CostFee ];

/// B_IsShare
Property BIsShare As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = B_IsShare ];

/// B_BillMakerDR
Property BBillMakerDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = B_BillMakerDR ];

/// B_BillMakeDate
Property BBillMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = B_BillMakeDate ];

/// B_BillMakeTime
Property BBillMakeTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = B_BillMakeTime ];

/// B_Status
Property BStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 16, SqlFieldName = B_Status ];

/// B_Remark
Property BRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = B_Remark ];

/// B_InvalidFlag
Property BInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = B_InvalidFlag ];

/// B_Hold1
Property BHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = B_Hold1 ];

/// B_Hold2
Property BHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = B_Hold2 ];

/// B_Hold3
Property BHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = B_Hold3 ];

/// B_Hold4
Property BHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = B_Hold4 ];

/// B_Hold5
Property BHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = B_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQSBill("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="B_BillMakeDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="B_BillMakeTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="B_BillMakerDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="B_BillNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="B_ChargeLocDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="B_Costfee">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="B_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="B_FromHospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="B_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="B_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="B_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="B_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="B_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="B_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="B_IsShare">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="B_PayLocDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="B_Remark">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="B_ShareType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="B_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="B_Status">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="B_ToHospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="B_Totalfee">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEQSBill</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{B_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSBillS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
