Class User.DHCDocAppBLMap Extends (%Persistent, User.Abstract) [ Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHC_DocAppBLMap, StorageStrategy = DHCDocAppBLMap ]
{

/// 模板代码
Property APPMapCode As %Library.String [ SqlColumnNumber = 2, SqlFieldName = APPMap_Code ];

/// 模板名字
Property APPMapName As %Library.String [ SqlColumnNumber = 3, SqlFieldName = APPMap_Name ];

/// 模板展示模板
Property APPMapShowTemp As %Library.String [ SqlColumnNumber = 4, SqlFieldName = APPMap_ShowTemp ];

/// 模板展示JS
Property APPMapShowJS As %Library.String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = APPMap_ShowJS ];

/// 模板是否激活
Property APPMapActive As %Library.String [ SqlColumnNumber = 6, SqlFieldName = APPMap_Active ];

/// 模板初始化方法
Property APPMapFristFunction As %Library.String(MAXLEN = 1000000) [ SqlColumnNumber = 7, SqlFieldName = APPMap_FristFunction ];

/// 模板点击事件
Property APPMapItmmastFunction As %Library.String(MAXLEN = 1000000) [ SqlColumnNumber = 8, SqlFieldName = APPMap_ItmmastFunction ];

/// 模板保存其他信息事件
Property APPMapSaveOtherInfo As %Library.String(MAXLEN = 1000000) [ SqlColumnNumber = 9, SqlFieldName = APPMap_SaveOtherInfo ];

/// 模板加载其他信息事件
Property APPMapLoadOtherInfo As %Library.String(MAXLEN = 1000000) [ SqlColumnNumber = 10, SqlFieldName = APPMap_LoadOtherInfo ];

/// 模板类型 BL 病理 CUREASS 治疗评估
Property APPMapMapType As %Library.String(DISPLAYLIST = ",BL,CureAssess,CureRecord", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",BL,CA,CR") [ SqlColumnNumber = 11, SqlFieldName = APPMap_MapType ];

/// xml模板名称
Property APPMapXMLTempName As %Library.String(MAXLEN = 9999) [ SqlColumnNumber = 12, SqlFieldName = APPMap_XMLTempName ];

Storage DHCDocAppBLMap
{
<SqlIdExpression>$i(^DHCDocAppBLMap(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="APPMap_Active">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APPMap_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APPMap_FristFunction">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APPMap_ItmmastFunction">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APPMap_LoadOtherInfo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="APPMap_MapType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="APPMap_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APPMap_SaveOtherInfo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APPMap_ShowJS">
<Node>"ShowJS"</Node>
</Data>
<Data name="APPMap_ShowTemp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APPMap_XMLTempName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCDocAppBLMap</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMapCode">
<Global>^DHCDocAppBLMapi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MapCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPMap_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocAppBLMapS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
