Class User.DHCPEPreIBaseInfo Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIBI_RowId, SqlTableName = DHC_PE_PreIBaseInfo, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEPreIBaseInfo";

Parameter EXTENTSIZE = 250;

Index PIBIPAPMINoUnqIndex On PIBIPAPMINo [ Unique ];

/// PIBI_Address
Property PIBIAddress As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PIBI_Address ];

/// PIBI_Blood
Property PIBIBloodDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PIBI_Blood_DR ];

/// PIBI_Company
Property PIBICompany As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PIBI_Company ];

/// PIBI_DOB
Property PIBIDOB As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = PIBI_DOB ];

/// PIBI_Email
Property PIBIEmail As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PIBI_Email ];

/// PIBI_IDCard
Property PIBIIDCard As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PIBI_IDCard ];

/// PIBI_Married
Property PIBIMarriedDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PIBI_Married_DR ];

/// PIBI_MobilePhone
Property PIBIMobilePhone As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PIBI_MobilePhone ];

/// PIBI_Name
Property PIBIName As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PIBI_Name ];

/// PIBI_Nation_DR
Property PIBINationDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PIBI_Nation_DR ];

/// PIBI_PAPMINo
Property PIBIPAPMINo As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PIBI_PAPMINo ];

/// PIBI_PatType_DR
Property PIBIPatTypeDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PIBI_PatType_DR ];

/// PIBI_Position
Property PIBIPosition As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PIBI_Position ];

/// PIBI_Postalcode
Property PIBIPostalcode As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PIBI_Postalcode ];

/// PIBI_Sex_DR
Property PIBISexDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PIBI_Sex_DR ];

/// PIBI_Tel1
Property PIBITel1 As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PIBI_Tel1 ];

/// PIBI_Tel2
Property PIBITel2 As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PIBI_Tel2 ];

/// PIBI_UpdateDate
Property PIBIUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 20, SqlFieldName = PIBI_UpdateDate ];

/// PIBI_UpdateUser_DR
Property PIBIUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = PIBI_UpdateUser_DR ];

// Property PIBIVocation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PIBI_Vocation ];

/// PIBI_Vocation
Property PIBIVocation As CTOccupation [ SqlColumnNumber = 11, SqlFieldName = PIBI_Vocation ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEPreIBI)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEPreIBI">
<Data name="PIBI_Address">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PIBI_Blood_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PIBI_Company">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PIBI_DOB">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIBI_Email">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PIBI_IDCard">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PIBI_Married_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PIBI_MobilePhone">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PIBI_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIBI_Nation_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PIBI_PAPMINo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIBI_PatType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIBI_Position">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PIBI_Postalcode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PIBI_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIBI_Tel1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PIBI_Tel2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PIBI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PIBI_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PIBI_Vocation">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCPEPreIBI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIBI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PIBI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexIDCard">
<Global>^DHCPEPreIBI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIBI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"IDCard"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIBI_IDCard}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIBI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCPEPreIBI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIBI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PIBI_Name})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIBI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMINo">
<Global>^DHCPEPreIBI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIBI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAPMINo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIBI_PAPMINo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIBI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreIBaseInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
