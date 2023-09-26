Class User.PMPDictionary3 Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PMP_Dictionary, StorageStrategy = SQLStorage ]
{

/// DTY_Code
Property DTYCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DTY_Code ];

/// DTY_Desc
Property DTYDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DTY_Desc ];

/// DTY_Flag
Property DTYFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DTY_Flag ];

/// DTY_Remark
Property DTYRemark As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DTY_Remark ];

/// DTY_Standby1
Property DTYStandby1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DTY_Standby1 ];

/// DTY_Standby2
Property DTYStandby2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DTY_Standby2 ];

/// DTY_Standby3
Property DTYStandby3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DTY_Standby3 ];

/// DTY_Standby4
Property DTYStandby4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DTY_Standby4 ];

/// DTY_Standby5
Property DTYStandby5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DTY_Standby5 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PMPDictionary("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DTY_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DTY_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DTY_Flag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DTY_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DTY_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DTY_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DTY_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DTY_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DTY_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^PMPDictionary</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DTY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DTY_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXDTYCode">
<Global>^PMPDictionary</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DTY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DTY_Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DTY_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DTY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXDTYDesc">
<Global>^PMPDictionary</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DTY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DTY_Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DTY_Desc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DTY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexdodFlagDesc">
<Global>^PMPDictionary</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"flagdesc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DTY_Flag}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DTY_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DTY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofFlag">
<Global>^PMPDictionary</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"FLAG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DTY_Flag}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DTY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DTY_Rowid</SqlRowIdName>
<StreamLocation>^User.PMPDictionary3S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
