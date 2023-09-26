Class User.DHCEQCComponentSetItemOld Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQCComponentSetItemOld, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CSI_ComponentSetDR
Property CSIComponentSetDR As DHCEQCComponentSetOld [ SqlColumnNumber = 2, SqlFieldName = CSI_ComponentSetDR ];

/// CSI_ItemType
Property CSIItemType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CSI_ItemType ];

/// CSI_ItemName
Property CSIItemName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CSI_ItemName ];

/// CSI_Caption
Property CSICaption As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CSI_Caption ];

/// CSI_CaptionStyle
Property CSICaptionStyle As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CSI_CaptionStyle ];

/// CSI_Disabled
Property CSIDisabled As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = CSI_Disabled ];

/// CSI_DisplayOnly
Property CSIDisplayOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = CSI_DisplayOnly ];

/// CSI_Hidden
Property CSIHidden As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = CSI_Hidden ];

/// CSI_ItemStyle
Property CSIItemStyle As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CSI_ItemStyle ];

/// CSI_OrderByAsc
Property CSIOrderByAsc As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = CSI_OrderByAsc ];

/// CSI_OrderByDesc
Property CSIOrderByDesc As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = CSI_OrderByDesc ];

/// CSI_ReadOnly
Property CSIReadOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = CSI_ReadOnly ];

/// CSI_Sort
Property CSISort As %Float [ SqlColumnNumber = 14, SqlFieldName = CSI_Sort ];

/// CSI_Hold1
Property CSIHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CSI_Hold1 ];

/// CSI_Hold2
Property CSIHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CSI_Hold2 ];

/// CSI_Hold3
Property CSIHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CSI_Hold3 ];

/// CSI_Hold4
Property CSIHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CSI_Hold4 ];

/// CSI_Hold5
Property CSIHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = CSI_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCComponent("DHCEQCComponentSetItemOld","0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CSI_Caption">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CSI_CaptionStyle">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CSI_ComponentSetDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CSI_Disabled">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CSI_DisplayOnly">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CSI_Hidden">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CSI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CSI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CSI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CSI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CSI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CSI_ItemName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CSI_ItemStyle">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CSI_ItemType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CSI_OrderByAsc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CSI_OrderByDesc">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CSI_ReadOnly">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CSI_Sort">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCEQCComponent</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CSI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCComponentSetItemOld"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CSI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItemName">
<Global>^DHCEQCComponent</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>CSI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCComponentSetItemOld"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"IndexItemName"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CSI_ComponentSetDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CSI_ItemType}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{CSI_ItemName}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{CSI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSort">
<Global>^DHCEQCComponent</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>CSI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCComponentSetItemOld"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"IndexSort"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CSI_ComponentSetDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CSI_ItemType}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{CSI_Sort}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{CSI_ItemName}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{CSI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CSI_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQCComponentSetItemOldS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
