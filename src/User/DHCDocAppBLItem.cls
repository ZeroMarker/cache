Class User.DHCDocAppBLItem Extends %Persistent [ SqlRowIdName = RowID, SqlTableName = DHC_DocAppBLItem, StorageStrategy = DHCDocAppBLItem ]
{

/// 元素ID
Property APPItemID As %Library.String(MAXLEN = 9999) [ SqlColumnNumber = 2, SqlFieldName = APPItem_ID ];

/// 元素描述
Property APPItemName As %Library.String(MAXLEN = 9999) [ SqlColumnNumber = 3, SqlFieldName = APPItem_Name ];

/// 元素类型
Property APPItemType As %Library.String [ SqlColumnNumber = 4, SqlFieldName = APPItem_Type ];

/// 元素JS代码
Property APPItemShowJS As %Library.String(MAXLEN = 100000) [ SqlColumnNumber = 5, SqlFieldName = APPItem_ShowJS ];

/// 元素是否必填
Property APPItemAcquir As %Library.String [ SqlColumnNumber = 6, SqlFieldName = APPItem_Acquir ];

/// 元素是否保存
Property APPItemSave As %Library.String [ SqlColumnNumber = 7, SqlFieldName = APPItem_Save ];

/// 元素对应的模板
Property APPItemForBLTemple As User.DHCDocAppBLTemple [ SqlColumnNumber = 8, SqlFieldName = APPItem_ForBLTemple ];

/// 元素限制录入长度
Property APPItemLength As User.DHCDocAppBLTemple [ SqlColumnNumber = 9, SqlFieldName = APPItem_Length ];

/// 元素控件类型
Property APPItemXType As %Library.String [ SqlColumnNumber = 10, SqlFieldName = APP_ItemXType ];

/// 元素控件ID
Property APPItemXID As %Library.String [ SqlColumnNumber = 11, SqlFieldName = APP_ItemXID ];

/// 打印时不打印元素描述
Property APPItemXPrintName As %Library.String [ SqlColumnNumber = 12, SqlFieldName = APPItem_XPrintName ];

Storage DHCDocAppBLItem
{
<SqlIdExpression>$i(^DHCDocAppBLItem(0))</SqlIdExpression>
<SQLMap name="BLTempIndex">
<Global>^DHCDocAppBLItemi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"BLTemp"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPItem_ForBLTemple}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="APPItem_Acquir">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APPItem_ForBLTemple">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APPItem_ID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APPItem_Length">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APPItem_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APPItem_Save">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APPItem_ShowJS">
<Node>"ShowJS"</Node>
</Data>
<Data name="APPItem_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APPItem_XPrintName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="APP_ItemXID">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="APP_ItemXType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCDocAppBLItem</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItemID">
<Global>^DHCDocAppBLItemi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"APPItemID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPItem_ID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLength">
<Global>^DHCDocAppBLItemi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Length"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPItem_Length}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCDocAppBLItemi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPItem_Name}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSave">
<Global>^DHCDocAppBLItemi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Save"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPItem_Save}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexcquir">
<Global>^DHCDocAppBLItemi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Acquir"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPItem_Acquir}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocAppBLItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
