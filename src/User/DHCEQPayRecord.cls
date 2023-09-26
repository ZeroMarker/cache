Class User.DHCEQPayRecord Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PR_RowID, SqlTableName = DHC_EQPayRecord, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PR_PayRequestDR
Property PRPayRequestDR As User.DHCEQPayRequest [ SqlColumnNumber = 2, SqlFieldName = PR_PayRequestDR ];

/// PR_SourceType
Property PRSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PR_SourceType ];

/// PR_SourceID
Property PRSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PR_SourceID ];

/// PR_EquipTypeDR
Property PREquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 5, SqlFieldName = PR_EquipTypeDR ];

/// PR_PayPlanDR
Property PRPayPlanDR As User.DHCEQPayPlan [ SqlColumnNumber = 6, SqlFieldName = PR_PayPlanDR ];

/// PR_Item
Property PRItem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PR_Item ];

/// PR_Quantity
Property PRQuantity As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PR_Quantity ];

/// PR_Price
Property PRPrice As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = PR_Price ];

/// PR_PayType
Property PRPayType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PR_PayType ];

/// PR_PayPercent
Property PRPayPercent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PR_PayPercent ];

/// PR_PayFee
Property PRPayFee As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = PR_PayFee ];

/// PR_CertificateDR
Property PRCertificateDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PR_CertificateDR ];

/// PR_Remark
Property PRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PR_Remark ];

/// PR_InvalidFlag
Property PRInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = PR_InvalidFlag ];

/// PR_Hold1
Property PRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PR_Hold1 ];

/// PR_Hold2
Property PRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PR_Hold2 ];

/// PR_Hold3
Property PRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PR_Hold3 ];

/// PR_Hold4
Property PRHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PR_Hold4 ];

/// PR_Hold5
Property PRHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PR_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPayRecord("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PR_CertificateDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PR_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PR_Item">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PR_PayFee">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PR_PayPercent">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PR_PayPlanDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PR_PayRequestDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PR_PayType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PR_Price">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PR_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PR_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PR_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQPayRecord</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPayRequest">
<Global>^DHCEQPayRecord</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PayRequest"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PR_PayRequestDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQPayRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PR_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PR_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPayRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
