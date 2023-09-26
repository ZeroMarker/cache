/// 排班管理-存假-记录具体日期
Class User.PIVARestItm Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = PIVA_RestItm, StorageStrategy = CacheSQLStorage ]
{

Index RowIDBasedIDKeyIndex On PRIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PRIParref As User.PIVARest [ Cardinality = parent, Inverse = ChildPIVARestItm, Required, SqlFieldName = PRI_Parref ];

Property PRIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PRI_ChildSub ];

/// 日期
Property PRIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PRI_Date ];

Storage CacheSQLStorage
{
<SQLMap name="DataMaster">
<Data name="PRI_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^Busi.PIVA.Rest</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_Rest.PR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIVA_Rest.PR_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PRI_RowId</SqlRowIdName>
<StreamLocation>^Busi.PIVA.RestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
