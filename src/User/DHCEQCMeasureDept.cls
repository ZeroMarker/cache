Class User.DHCEQCMeasureDept Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MD_RowID, SqlTableName = DHC_EQCMeasureDept, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MD_Name
Property MDName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MD_Name ];

/// MD_Code
Property MDCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MD_Code ];

/// MD_Address
Property MDAddress As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MD_Address ];

/// MD_Tel
Property MDTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MD_Tel ];

/// MD_Zip
Property MDZip As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MD_Zip ];

/// MD_Fax
Property MDFax As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MD_Fax ];

/// MD_ContPerson
Property MDContPerson As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MD_ContPerson ];

/// MD_ShName
Property MDShName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MD_ShName ];

/// MD_Grading
Property MDGrading As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MD_Grading ];

/// MD_InvalidFlag
Property MDInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = MD_InvalidFlag ];

/// MD_Bank
Property MDBank As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MD_Bank ];

/// MD_BankNo
Property MDBankNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MD_BankNo ];

/// MD_EMail
Property MDEMail As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MD_EMail ];

/// MD_Hold1
Property MDHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MD_Hold1 ];

/// MD_Hold2
Property MDHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MD_Hold2 ];

/// MD_Hold3
Property MDHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MD_Hold3 ];

/// MD_Hold4
Property MDHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = MD_Hold4 ];

/// MD_Hold5
Property MDHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MD_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCMeasureDept",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MD_Address">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MD_Bank">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MD_BankNo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MD_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MD_ContPerson">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MD_EMail">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MD_Fax">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MD_Grading">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MD_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MD_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MD_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MD_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MD_ShName">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MD_Tel">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MD_Zip">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCMeasureDept"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{MD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCMeasureDeptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
