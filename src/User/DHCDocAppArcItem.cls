Class User.DHCDocAppArcItem Extends %Persistent [ SqlRowIdName = RowID, SqlTableName = DHC_DocAppArcItem, StorageStrategy = DHCDocAppArcItem ]
{

/// 元素ID
Property APPItemArcID As %Library.String [ SqlColumnNumber = 2, SqlFieldName = APPItemArc_ID ];

/// 元素描述
Property APPItemArcName As %Library.String [ SqlColumnNumber = 3, SqlFieldName = APPItemArc_Name ];

/// 元素类型
Property APPItemArcType As %Library.String [ SqlColumnNumber = 4, SqlFieldName = APPItemArc_Type ];

/// 元素JS代码
Property APPItemArcShowJS As %Library.String(MAXLEN = 100000) [ SqlColumnNumber = 5, SqlFieldName = APPItemArc_ShowJS ];

/// 元素是否必填
Property APPItemArcAcquir As %Library.String [ SqlColumnNumber = 6, SqlFieldName = APPItemArc_Acquir ];

/// 元素是否保存
Property APPItemArcSave As %Library.String [ SqlColumnNumber = 7, SqlFieldName = APPItemArc_Save ];

/// 元素是否隐藏
Property APPItemArcHidden As %Library.String [ SqlColumnNumber = 8, SqlFieldName = APPItemArc_Hidden ];

/// 元素对应的模板
Property APPItemArcBLTemple As User.DHCDocAppBLTemple [ SqlColumnNumber = 9, SqlFieldName = APPItemArc_BLTemple ];

/// 元素对应的病理单
Property APPItemArcMap As User.DHCDocAppBLMap [ SqlColumnNumber = 10, SqlFieldName = APPItemArc_Map ];

/// 元素对应的医嘱项
Property APPItemArcItmMast As User.ARCItmMast [ SqlColumnNumber = 11, SqlFieldName = APPItemArc_ItmMast ];

Storage DHCDocAppArcItem
{
<SqlIdExpression>$i(^DHCDocAppArcItem(0))</SqlIdExpression>
<SQLMap name="IndexArcItem">
<Global>^DHCDocAppArcItemi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ArcItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPItemArc_Map}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APPItemArc_BLTemple}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APPItemArc_ItmMast}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="APPItemArc_Acquir">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APPItemArc_BLTemple">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APPItemArc_Hidden">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APPItemArc_ID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APPItemArc_ItmMast">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="APPItemArc_Map">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="APPItemArc_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APPItemArc_Save">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APPItemArc_ShowJS">
<Node>"ShowJS"</Node>
</Data>
<Data name="APPItemArc_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocAppArcItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocAppArcItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
