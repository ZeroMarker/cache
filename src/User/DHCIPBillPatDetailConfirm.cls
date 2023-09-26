Class User.DHCIPBillPatDetailConfirm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ConfD_Rowid, SqlTableName = DHC_IPBillPatDetailConfirm, StorageStrategy = SQLStorage ]
{

Property ConfDConfPatBillDr As %Library.String [ SqlColumnNumber = 2, SqlFieldName = ConfD_ConfPatBillDr ];

Property ConfDConfOrdDr As %Library.String [ SqlColumnNumber = 3, SqlFieldName = ConfD_ConfOrd_Dr ];

Property ConfDOrditemDr As %Library.String [ SqlColumnNumber = 4, SqlFieldName = ConfD_Orditem_Dr ];

Property ConfDPatDetailDr As %Library.String [ SqlColumnNumber = 5, SqlFieldName = ConfD_PatDetail_Dr ];

Property ConfDDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = ConfD_Date ];

Property ConfDTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = ConfD_Time ];

Property ConfDUser As %Library.String [ SqlColumnNumber = 8, SqlFieldName = ConfD_User ];

Property ConfDStatus As %Library.String [ SqlColumnNumber = 9, SqlFieldName = ConfD_Status ];

Property ConfDTotalAmt As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = ConfD_TotalAmt ];

Property ConfDPayorAmt As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = ConfD_PayorAmt ];

Property ConfDDiscAmt As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = ConfD_DiscAmt ];

Property ConfDPatientAmt As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = ConfD_PatientAmt ];

Property ConfDNote1 As %Library.String [ SqlColumnNumber = 14, SqlFieldName = ConfD_Note1 ];

Property ConfDNote2 As %Library.String [ SqlColumnNumber = 15, SqlFieldName = ConfD_Note2 ];

Property ConfDNote3 As %Library.String [ SqlColumnNumber = 16, SqlFieldName = ConfD_Note3 ];

Property ConfDNote4 As %Library.String [ SqlColumnNumber = 17, SqlFieldName = ConfD_Note4 ];

Property ConfDNote5 As %Library.String [ SqlColumnNumber = 18, SqlFieldName = ConfD_Note5 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCIPBillPatDetailConfirm)</SqlIdExpression>
<SQLMap name="indexconford">
<Global>^DHCIPBillPatDetailConfirm</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Field>0</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Field>"ConfOrd"</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Field>ConfD_ConfOrd_Dr</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Field>{ConfD_Rowid}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ConfOrd"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ConfD_ConfOrd_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ConfD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexconfpatbill">
<Global>^DHCIPBillPatDetailConfirm</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ConfPatBill"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ConfD_ConfPatBillDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ConfD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexdate">
<Global>^DHCIPBillPatDetailConfirm</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ConfD_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ConfD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexorditem">
<Global>^DHCIPBillPatDetailConfirm</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Orditem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ConfD_Orditem_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ConfD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexpatdetail">
<Global>^DHCIPBillPatDetailConfirm</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatDetail"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ConfD_PatDetail_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ConfD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexuser">
<Global>^DHCIPBillPatDetailConfirm</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ConfD_User}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ConfD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="master">
<Data name="ConfD_ConfOrd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ConfD_ConfPatBillDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ConfD_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ConfD_DiscAmt">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ConfD_Note1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ConfD_Note2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ConfD_Note3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ConfD_Note4">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ConfD_Note5">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ConfD_Orditem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ConfD_PatDetail_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ConfD_PatientAmt">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ConfD_PayorAmt">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ConfD_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ConfD_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ConfD_TotalAmt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ConfD_User">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCIPBillPatDetailConfirm</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ConfD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ConfD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCIPBillPatDetailConfirmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
