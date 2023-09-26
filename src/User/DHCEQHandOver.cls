Class User.DHCEQHandOver Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = HO_RowID, SqlTableName = DHC_EQHandOver, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index HONoUnqIdx1 On HONo [ Unique ];

/// HO_No
Property HONo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = HO_No ];

/// HO_Type
Property HOType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = HO_Type ];

/// HO_LocDR
Property HOLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = HO_LocDR ];

Property HODate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = HO_Date ];

Property HOTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = HO_Time ];

Property HOUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = HO_UserDR ];

Property HOToUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = HO_ToUserDR ];

Property HODealDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = HO_DealDate ];

Property HODealime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = HO_DealTime ];

/// HO_Status
Property HOStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = HO_Status ];

/// HO_Remark
Property HORemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = HO_Remark ];

/// HO_Hold1
Property HOHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = HO_Hold1 ];

/// HO_Hold2
Property HOHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = HO_Hold2 ];

/// HO_Hold3
Property HOHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = HO_Hold3 ];

/// HO_Hold4
Property HOHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = HO_Hold4 ];

/// HO_Hold5
Property HOHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = HO_Hold5 ];

Property HOInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = HO_InvalidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQHandOver("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HO_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HO_DealDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HO_DealTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HO_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="HO_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="HO_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="HO_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="HO_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="HO_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="HO_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HO_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HO_Remark">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HO_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HO_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HO_ToUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HO_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HO_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQHandOver</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>HO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{HO_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCEQHandOver</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HO_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{HO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQHandOver</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HO_LocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{HO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCEQHandOver</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HO_No}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{HO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQHandOverS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
