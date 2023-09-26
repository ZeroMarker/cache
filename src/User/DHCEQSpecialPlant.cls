Class User.DHCEQSpecialPlant Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQSpecialPlant, StorageStrategy = SQLStorage ]
{

/// S_SourceType
Property SSourceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = S_SourceType ];

/// S_SourceID
Property SSourceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = S_SourceID ];

/// S_PlantDate
Property SPlantDate As %Date [ SqlColumnNumber = 4, SqlFieldName = S_PlantDate ];

/// S_Life
Property SLife As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = S_Life ];

/// S_Classes
Property SClasses As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = S_Classes ];

/// S_Origin
Property SOrigin As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = S_Origin ];

/// S_InvalidFlag
Property SInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = S_InvalidFlag ];

/// S_Hold1
Property SHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = S_Hold1 ];

/// S_Hold2
Property SHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = S_Hold2 ];

/// S_Hold3
Property SHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = S_Hold3 ];

/// S_Hold4
Property SHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = S_Hold4 ];

/// S_Hold5
Property SHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = S_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQSpecialPlant("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="S_Classes">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="S_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="S_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="S_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="S_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="S_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="S_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="S_Life">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="S_Origin">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="S_PlantDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="S_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="S_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQSpecialPlant</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>S_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{S_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQSpecialPlant</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>S_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{S_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{S_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{S_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>S_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQSpecialPlantS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
