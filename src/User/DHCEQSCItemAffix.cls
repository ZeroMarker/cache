Class User.DHCEQSCItemAffix Extends %Persistent [ SqlRowIdName = IA_RowID, SqlTableName = DHC_EQSCItemAffix, StorageStrategy = SQLStorage ]
{

/// IA_ItemDR
Property IAShareItemDR As DHCEQSCShareItem [ SqlColumnNumber = 2, SqlFieldName = IA_ShareItemDR ];

/// IA_AffixDR
Property IAAffixDR As DHCEQCAffix [ SqlColumnNumber = 3, SqlFieldName = IA_AffixDR ];

/// IA_Model
Property IAModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IA_Model ];

/// IA_Quantity
Property IAQuantity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IA_Quantity ];

/// IA_Remark
Property IARemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IA_Remark ];

/// IA_Price
Property IAPrice As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = IA_Price ];

/// IA_InvalidFlag
Property IAInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = IA_InvalidFlag ];

/// IA_Hold1
Property IAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IA_Hold1 ];

/// IA_Hold2
Property IAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IA_Hold2 ];

/// IA_Hold3
Property IAHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IA_Hold3 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQSCItemAffix("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IA_AffixDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IA_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IA_Model">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IA_Price">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IA_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IA_ShareItemDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQSCItemAffix</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{IA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ShareItemIndex">
<Global>^DHCEQSCItemAffix</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{IA_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IAShareItemDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IA_ShareItemDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSCItemAffixS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
