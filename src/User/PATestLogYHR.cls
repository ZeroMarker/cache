Class User.PATestLogYHR Extends (%Persistent, User.Abstract) [ SqlTableName = PA_TestLogYHR, StorageStrategy = NewStorage1 ]
{

/// 建立关系
Relationship ParRef As PATestYHR [ Cardinality = parent, Inverse = ChildPerson, SqlFieldName = LogRowId_ParRef ];

/// 定义 ChildSub
Property PAChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^PATESTLOGYHRi(+$s($d(initvalue):initvalue,1:%d(0)),"Person",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PA_ChildSub ];

/// 字段：Log_RowId  Log_Person_Dr  Log_Filed Log_OldValue Log_NewValue
/// 病人RowId
Property LogPersonDr As User.PATest [ Required, SqlColumnNumber = 3, SqlFieldName = Log_Person_Dr ];

/// 值变化字段名
Property LogFiled As %String [ SqlColumnNumber = 4, SqlFieldName = Log_Filed ];

/// 旧值
Property LogOldValue As %String [ SqlColumnNumber = 5, SqlFieldName = Log_OldValue ];

/// 新值
Property LogNewValue As %String [ SqlColumnNumber = 6, SqlFieldName = Log_NewValue ];

Index PersonDr On LogPersonDr As Exact;

/// 创建ChildSub索引
Index PARowIdBasedIDKeyIndex On PAChildSub [ IdKey, PrimaryKey, Unique ];

Storage NewStorage1
{
<SQLMap name="DataMaster">
<Data name="Log_Filed">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Log_NewValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Log_OldValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Log_Person_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PATESTLOGYHRi</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_TestYHR.PA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PA_TestYHR.PA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"Person"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLogPersonDr">
<Global>^PATESTLOGYHRi</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_TestYHR.PA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PA_TestYHR.PA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Person"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"PersonDr"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Log_Person_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PATestLogYHRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
