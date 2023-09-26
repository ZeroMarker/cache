Class User.DHCEQTempImport Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TI_RowID, SqlTableName = DHC_EQTempImport, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TI_Name
Property TIName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TI_Name ];

/// TI_Code
Property TICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TI_Code ];

/// TI_Unit
Property TIUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TI_Unit ];

/// TI_EquipType
Property TIEquipType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = TI_EquipType ];

/// TI_StatCat
Property TIStatCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TI_StatCat ];

/// TI_EquipCat
Property TIEquipCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = TI_EquipCat ];

/// TI_Model
Property TIModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = TI_Model ];

/// TI_Manufactory
Property TIManufactory As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = TI_Manufactory ];

/// TI_Hold1
Property TIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = TI_Hold1 ];

/// TI_Hold2
Property TIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = TI_Hold2 ];

/// TI_Hold3
Property TIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = TI_Hold3 ];

/// TI_Hold4
Property TIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = TI_Hold4 ];

/// TI_Hold5
Property TIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = TI_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQTempImport("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TI_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TI_EquipCat">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TI_EquipType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TI_Manufactory">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TI_Model">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TI_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TI_StatCat">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TI_Unit">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQTempImport</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{TI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQTempImportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
