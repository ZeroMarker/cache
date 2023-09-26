Class CT.NUR.NIS.TranslationDict Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = TranslationDict, StorageStrategy = SQLStorage ]
{

/// 通用词汇存储类
Property Word As %String [ SqlColumnNumber = 2, SqlFieldName = Word ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CT.NUR.NIS.TranslationDict(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Word">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CT.NUR.NIS.TranslationDict</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TD_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TD_ROWID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TD_ROWID</SqlRowIdName>
<StreamLocation>^CT.NUR.NIS.TranslationDictS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
