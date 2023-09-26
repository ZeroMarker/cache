Class User.DHCAccPFoot Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AccPF_RowID, SqlTableName = DHC_AccPFoot, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCAccPFootSub As User.DHCAccPFootSub [ Cardinality = children, Inverse = AccPFSParRef ];

/// AccPF_Date
Property AccPFDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = AccPF_Date ];

/// AccPF_Time
Property AccPFTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = AccPF_Time ];

/// AccPF_User_DR
Property AccPFUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = AccPF_User_DR ];

/// AccPF_LastDate
Property AccPFLastDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = AccPF_LastDate ];

/// AccPF_LastTime
Property AccPFLastTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = AccPF_LastTime ];

/// AccPF_PreLeftSum
Property AccPFPreLeftSum As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = AccPF_PreLeftSum ];

/// AccPF_PreSum
Property AccPFPreSum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = AccPF_PreSum ];

/// AccPF_CardPaySum
Property AccPFCardPaySum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = AccPF_CardPaySum ];

/// AccPF_LeftSum
Property AccPFLeftSum As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = AccPF_LeftSum ];

/// AccPF_RefundPreSum
Property AccPFRefundPreSum As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = AccPF_RefundPreSum ];

/// AccPF_AccPayINVSum
Property AccPFAccPayINVSum As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = AccPF_AccPayINVSum ];

/// AccPF_Acc Payed By Depart etc.
Property AccPFAccDepPaySum As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = AccPF_AccDepPaySum ];

/// AccPF_AccTimeType
Property AccPFAccTimeType As %Library.String(DISPLAYLIST = ",PayDate,UseRepDate,GetRepDate", MAXLEN = 10, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",PD,RD,GRD") [ SqlColumnNumber = 14, SqlFieldName = AccPF_AccTimeType ];

/// AccPF_CurQFSum
Property AccPFCurQFSum As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = AccPF_CurQFSum ];

/// AccPF_CurLeftQFSum
Property AccPFCurLeftQFSum As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = AccPF_CurLeftQFSum ];

/// AccPF_HSDate
Property AccPFHSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = AccPF_HSDate ];

/// AccPF_RoundSum
Property AccPFRoundSum As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = AccPF_RoundSum ];

/// AccPF_Pay Sum By Not Card
Property AccPFPaySumByNoCard As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = AccPF_PaySumByNoCard ];

/// AccPF_YBPaySum
Property AccPFYBPaySum As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = AccPF_YBPaySum ];

/// AccPF_Hospital_DR
Property AccPFHospitalDR As User.CTHospital [ Required, SqlColumnNumber = 21, SqlFieldName = AccPF_Hospital_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCACD("AccPF"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AccPF_AccDepPaySum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AccPF_AccPayINVSum">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AccPF_AccTimeType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AccPF_CardPaySum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AccPF_CurLeftQFSum">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AccPF_CurQFSum">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AccPF_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AccPF_HSDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AccPF_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AccPF_LastDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AccPF_LastTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AccPF_LeftSum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AccPF_PaySumByNoCard">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AccPF_PreLeftSum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AccPF_PreSum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AccPF_RefundPreSum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AccPF_RoundSum">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AccPF_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AccPF_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AccPF_YBPaySum">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^DHCACD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AccPF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccPF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AccPF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCurDate">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AccPF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccPF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CurDateT"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPF_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccPF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHSDate">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AccPF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccPF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"HSDateF"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPF_HSDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccPF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDateT">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AccPF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccPF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"TypeDateT"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPF_AccTimeType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccPF_Date}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{AccPF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAccPFootS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
