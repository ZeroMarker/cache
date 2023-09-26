Class User.DHCEQCConsumableItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CI_RowID, SqlTableName = DHC_EQCConsumableItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CI_Code
Property CICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CI_Code ];

/// CI_Desc
Property CIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CI_Desc ];

/// CI_ExDesc
Property CIExDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CI_ExDesc ];

/// CI_ExID
Property CIExID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CI_ExID ];

/// CI_ExType
Property CIExType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CI_ExType ];

/// CI_InvalidFlag
Property CIInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = CI_InvalidFlag ];

/// CI_Price
Property CIPrice As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = CI_Price ];

/// CI_UomDR
Property CIUomDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CI_UomDR ];

/// CI_PayPrice
Property CIPayPrice As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = CI_PayPrice ];

/// CI_Hold1
Property CIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CI_Hold1 ];

/// CI_Hold2
Property CIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CI_Hold2 ];

/// CI_Hold3
Property CIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CI_Hold3 ];

/// CI_UpdateDate
Property CIUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = CI_UpdateDate ];

/// CI_ChargeType
Property CIChargeType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CI_ChargeType ];

/// CI_ExpenseType
Property CIExpenseType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CI_ExpenseType ];

/// CI_AdditionRate
Property CIAdditionRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CI_AdditionRate ];

/// CI_BillItemNo
Property CIBillItemNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CI_BillItemNo ];

/// CI_RegistrationNo
Property CIRegistrationNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = CI_RegistrationNo ];

/// CI_ExpenseRate
Property CIExpenseRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CI_ExpenseRate ];

/// CI_DisposableFlag
Property CIDisposableFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = CI_DisposableFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCConsumableItem",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CI_AdditionRate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CI_BillItemNo">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CI_ChargeType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CI_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CI_DisposableFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CI_ExDesc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CI_ExID">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CI_ExType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CI_ExpenseRate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CI_ExpenseType">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CI_PayPrice">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CI_Price">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CI_RegistrationNo">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CI_UomDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCConsumableItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCConsumableItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
