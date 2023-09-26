Class User.DHCEQKBHospital Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = H_RowID, SqlTableName = DHC_EQKBHospital, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// H_Desc
Property HDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = H_Desc ];

/// H_Code
Property HCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = H_Code ];

/// H_Remark
Property HRemark As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = H_Remark ];

/// H_Address
Property HAddress As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = H_Address ];

/// H_TelPhone
Property HTelPhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = H_TelPhone ];

/// H_InvalidFlag
Property HInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = H_InvalidFlag ];

/// H_Hold1
Property HHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = H_Hold1 ];

/// H_Hold2
Property HHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = H_Hold2 ];

/// H_Hold3
Property HHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = H_Hold3 ];

/// H_Hold4
Property HHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = H_Hold4 ];

/// H_Hold5
Property HHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = H_Hold5 ];

/// H_Hold6
Property HHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = H_Hold6 ];

/// H_Hold7
Property HHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = H_Hold7 ];

/// H_Hold8
Property HHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = H_Hold8 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQKB("DHCEQKBHospital",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="H_Address">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="H_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="H_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="H_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="H_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="H_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="H_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="H_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="H_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="H_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="H_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="H_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="H_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="H_TelPhone">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQKB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>H_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQKBHospital"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{H_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>H_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBHospital"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{H_Desc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{H_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQKBHospitalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
