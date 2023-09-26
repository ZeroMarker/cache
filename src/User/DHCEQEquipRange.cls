Class User.DHCEQEquipRange Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ER_RowID, SqlTableName = DHC_EQEquipRange, StorageStrategy = SQLStorage ]
{

/// ER_RangeDesc
Property ERRangeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ER_RangeDesc ];

/// ER_SourceType
Property ERSourceType As %Library.String(DISPLAYLIST = ",人员权限限定,保养检查计划,PM模板限定", MAXLEN = 5, SELECTIVITY = "14.2857%", VALUELIST = ",1,2,3") [ SqlColumnNumber = 3, SqlFieldName = ER_SourceType ];

/// ER_SourceID
Property ERSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ER_SourceID ];

/// ER_EquipTypeFlag
Property EREquipTypeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ER_EquipTypeFlag ];

/// ER_StatCatFlag
Property ERStatCatFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ER_StatCatFlag ];

/// ER_EquipCatFlag
Property EREquipCatFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ER_EquipCatFlag ];

/// ER_LocFlag
Property ERLocFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ER_LocFlag ];

/// ER_EquipFlag
Property EREquipFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ER_EquipFlag ];

/// ER_ItemFlag
Property ERItemFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = ER_ItemFlag ];

/// ER_MinPrice
Property ERMinPrice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ER_MinPrice ];

/// ER_MaxPrice
Property ERMaxPrice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ER_MaxPrice ];

/// ER_Hold1
Property ERHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ER_Hold1 ];

/// ER_Hold2
Property ERHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ER_Hold2 ];

/// ER_Hold3
Property ERHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = ER_Hold3 ];

/// ER_Hold4
Property ERHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = ER_Hold4 ];

/// ER_Hold5
Property ERHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = ER_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQEquipRange("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ER_EquipCatFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ER_EquipFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ER_EquipTypeFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ER_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ER_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ER_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ER_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ER_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ER_ItemFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ER_LocFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ER_MaxPrice">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ER_MinPrice">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ER_RangeDesc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ER_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ER_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ER_StatCatFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQEquipRange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ER_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ER_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQEquipRange</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ER_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ER_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ER_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEquipRangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
