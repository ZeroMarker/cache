Class User.DHCDocAppBLTemple Extends %Persistent [ Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHC_DocAppBLTemple, StorageStrategy = DHCDocAppBLTemple ]
{

/// 模板名字
Property APPName As %Library.String [ SqlColumnNumber = 2, SqlFieldName = APP_Name ];

/// 模板类型
Property APPType As %Library.String [ SqlColumnNumber = 3, SqlFieldName = APP_Type ];

/// 模板
Property APPContent As %Library.String(MAXLEN = 100000) [ SqlColumnNumber = 4, SqlFieldName = APP_Content ];

/// 模板ID
Property APPID As %Library.String [ SqlColumnNumber = 5, SqlFieldName = APP_ID ];

/// 模板JS
Property APPJSStr As %Library.String(MAXLEN = 100000) [ SqlColumnNumber = 6, SqlFieldName = APP_JSStr ];

/// 模板类型 BL 病理 CUREASS 治疗评估
Property APPMapType As %Library.String(DISPLAYLIST = ",BL,CureAssess", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",BL,CA") [ SqlColumnNumber = 7, SqlFieldName = APP_MapType ];

/// 模板ID
Property APPLastID As %Library.String [ SqlColumnNumber = 8, SqlFieldName = APP_LastID ];

Storage DHCDocAppBLTemple
{
<SqlIdExpression>$i(^DHCDocBLTem(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="APP_Content">
<Node>"ConT"</Node>
</Data>
<Data name="APP_ID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APP_JSStr">
<Node>"JSStr"</Node>
</Data>
<Data name="APP_LastID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APP_MapType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APP_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APP_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocBLTem</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLastID">
<Global>^DHCDocBLTemi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LastID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APP_LastID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocAppBLTempleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
