Class User.DHCEQCManufacturer Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MF_RowID, SqlTableName = DHC_EQCManufacturer, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MF_Name
Property MFName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MF_Name ];

/// MF_Code
Property MFCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MF_Code ];

/// MF_Address
Property MFAddress As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MF_Address ];

/// MF_Tel
Property MFTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MF_Tel ];

/// MF_Zip
Property MFZip As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MF_Zip ];

/// MF_Fax
Property MFFax As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MF_Fax ];

/// MF_ContPerson
Property MFContPerson As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MF_ContPerson ];

/// MF_ShName
Property MFShName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MF_ShName ];

/// MF_Grading
Property MFGrading As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MF_Grading ];

/// MF_InvalidFlag
Property MFInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = MF_InvalidFlag ];

/// MF_Hold1
Property MFHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MF_Hold1 ];

/// MF_Hold2
Property MFHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MF_Hold2 ];

/// MF_Hold3
Property MFHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MF_Hold3 ];

/// MF_Hold4
Property MFHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MF_Hold4 ];

/// MF_Hold5
Property MFHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MF_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCManufacturer",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MF_Address">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MF_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MF_ContPerson">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MF_Fax">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MF_Grading">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MF_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MF_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MF_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MF_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MF_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MF_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MF_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MF_ShName">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MF_Tel">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MF_Zip">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCManufacturer"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{MF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCManufacturerS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
