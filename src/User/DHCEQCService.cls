Class User.DHCEQCService Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SV_RowID, SqlTableName = DHC_EQCService, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SV_Name
Property SVName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SV_Name ];

/// SV_Code
Property SVCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SV_Code ];

/// SV_Address
Property SVAddress As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SV_Address ];

/// SV_Tel
Property SVTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SV_Tel ];

/// SV_Zip
Property SVZip As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SV_Zip ];

/// SV_Fax
Property SVFax As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SV_Fax ];

/// SV_ContPerson
Property SVContPerson As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SV_ContPerson ];

/// SV_ShName
Property SVShName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SV_ShName ];

/// SV_Grading
Property SVGrading As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SV_Grading ];

/// SV_InvalidFlag
Property SVInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = SV_InvalidFlag ];

/// SV_Bank
Property SVBank As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SV_Bank ];

/// SV_BankNo
Property SVBankNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = SV_BankNo ];

/// SV_EMail
Property SVEMail As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = SV_EMail ];

/// SV_Hold1
Property SVHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = SV_Hold1 ];

/// SV_Hold2
Property SVHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = SV_Hold2 ];

/// SV_Hold3
Property SVHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = SV_Hold3 ];

/// SV_Hold4
Property SVHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = SV_Hold4 ];

/// SV_Hold5
Property SVHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = SV_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCService",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SV_Address">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SV_Bank">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SV_BankNo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SV_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SV_ContPerson">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SV_EMail">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SV_Fax">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SV_Grading">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SV_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SV_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SV_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SV_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SV_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SV_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SV_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SV_ShName">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SV_Tel">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SV_Zip">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SV_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCService"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{SV_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCServiceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
