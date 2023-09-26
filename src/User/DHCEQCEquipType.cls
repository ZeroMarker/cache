Class User.DHCEQCEquipType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ET_RowID, SqlTableName = DHC_EQCEquipType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ET_Code
Property ETCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ET_Code ];

/// ET_Desc
Property ETDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ET_Desc ];

/// ET_EQFlag
Property ETEQFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ET_EQFlag ];

/// ET_EQType
Property ETEQType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ET_EQType ];

/// ET_Hold1
Property ETHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ET_Hold1 ];

/// ET_Hold2
Property ETHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ET_Hold2 ];

/// ET_Hold3
Property ETHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ET_Hold3 ];

/// ET_Hold4
Property ETHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ET_Hold4 ];

/// ET_Hold5
Property ETHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ET_Hold5 ];

/// ET_InvalidFlag
Property ETInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ET_InvalidFlag ];

/// ET_MaxPrice
Property ETMaxPrice As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ET_MaxPrice ];

/// ET_MinPrice
Property ETMinPrice As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ET_MinPrice ];

/// ET_Remark
Property ETRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ET_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCEquipType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ET_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ET_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ET_EQFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ET_EQType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ET_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ET_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ET_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ET_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ET_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ET_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ET_MaxPrice">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ET_MinPrice">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ET_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ET_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCEquipType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ET_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCEquipTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
