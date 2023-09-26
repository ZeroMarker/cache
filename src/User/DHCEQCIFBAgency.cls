Class User.DHCEQCIFBAgency Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IFBA_RowID, SqlTableName = DHC_EQCIFBAgency, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IFBA_Code
Property IFBACode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IFBA_Code ];

/// IFBA_Desc
Property IFBADesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IFBA_Desc ];

/// IFBA_Qualifications
Property IFBAQualifications As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IFBA_Qualifications ];

/// IFBA_Address
Property IFBAAddress As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IFBA_Address ];

/// IFBA_Tel
Property IFBATel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IFBA_Tel ];

/// IFBA_Fax
Property IFBAFax As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IFBA_Fax ];

/// IFBA_ConPerson
Property IFBAConPerson As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IFBA_ConPerson ];

/// IFBA_FromDate
Property IFBAFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = IFBA_FromDate ];

/// IFBA_ToDate
Property IFBAToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = IFBA_ToDate ];

/// IFBA_InvalidFlag
Property IFBAInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = IFBA_InvalidFlag ];

/// IFBA_Hold1
Property IFBAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IFBA_Hold1 ];

/// IFBA_Hold2
Property IFBAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IFBA_Hold2 ];

/// IFBA_Hold3
Property IFBAHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IFBA_Hold3 ];

/// IFBA_Hold4
Property IFBAHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IFBA_Hold4 ];

/// IFBA_Hold5
Property IFBAHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = IFBA_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCIFBAgency",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IFBA_Address">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IFBA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IFBA_ConPerson">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IFBA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IFBA_Fax">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IFBA_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IFBA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IFBA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IFBA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IFBA_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IFBA_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IFBA_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IFBA_Qualifications">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IFBA_Tel">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IFBA_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>IFBA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCIFBAgency"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{IFBA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCIFBAgencyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
