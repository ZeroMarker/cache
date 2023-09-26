Class User.DHCEQCComponentSetItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CSI_RowID, SqlTableName = DHC_EQCComponentSetItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CSI_ComponentSetDR
Property CSIComponentSetDR As User.DHCEQCComponentSet [ SqlColumnNumber = 2, SqlFieldName = CSI_ComponentSetDR ];

/// CSI_ComponentItemDR
Property CSIComponentItemDR As User.DHCEQCComponentItem [ SqlColumnNumber = 3, SqlFieldName = CSI_ComponentItemDR ];

/// CSI_Caption
Property CSICaption As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CSI_Caption ];

/// CSI_CaptionStyle
Property CSICaptionStyle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CSI_CaptionStyle ];

/// CSI_Disabled
Property CSIDisabled As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = CSI_Disabled ];

/// CSI_DisplayOnly
Property CSIDisplayOnly As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = CSI_DisplayOnly ];

/// CSI_Hidden
Property CSIHidden As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = CSI_Hidden ];

/// CSI_ItemStyle
Property CSIItemStyle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CSI_ItemStyle ];

/// CSI_ReadOnly
Property CSIReadOnly As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = CSI_ReadOnly ];

/// CSI_Sort
Property CSISort As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CSI_Sort ];

/// CSI_Required
Property CSIRequired As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = CSI_Required ];

/// CSI_SaveFlag
Property CSISaveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = CSI_SaveFlag ];

/// CSI_OrderBy
Property CSIOrderBy As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CSI_OrderBy ];

/// CSI_Hold1
Property CSIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CSI_Hold1 ];

/// CSI_Hold2
Property CSIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CSI_Hold2 ];

/// CSI_Hold3
Property CSIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CSI_Hold3 ];

/// CSI_Hold4
Property CSIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CSI_Hold4 ];

/// CSI_Hold5
Property CSIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = CSI_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCComponentSetItem",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CSI_Caption">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CSI_CaptionStyle">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CSI_ComponentItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CSI_ComponentSetDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CSI_Disabled">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CSI_DisplayOnly">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CSI_Hidden">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
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
<Data name="CSI_ItemStyle">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CSI_OrderBy">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CSI_ReadOnly">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CSI_Required">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CSI_SaveFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CSI_Sort">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CSI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCComponentSetItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{CSI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexComponentItemSort">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CSI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCComponentSetItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"ComponentItem"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{CSI_ComponentSetDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{CSI_ComponentItemDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{CSI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemSort">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCComponentSetItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"ItemSort"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{CSI_ComponentSetDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>+{CSI_Sort}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CSI_ComponentItemDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CSI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexZone">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>{CSI_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCComponentSetItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"Zone"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{CSI_ComponentSetDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{CSI_Hold1}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{CSI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCComponentSetItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
