/// Descript:	药房药库通用字典表,相同结构的码表都用此表存储，用”类型”区分不同的含义
/// Creater:		zhouyg
/// CreateDate:	2014-04-15
Class User.DHCStkComDictionary Extends %Persistent [ SqlRowIdName = SCDI_RowID, SqlTableName = DHC_StkComDictionary, StorageStrategy = SQLStorage ]
{

/// 代码
Property SCDICode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SCDI_Code ];

/// 描述
Property SCDIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SCDI_Desc ];

/// 类型
Property SCDIType As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SCDI_Type ];

/// 类型描述
Property SCDITypeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SCDI_TypeDesc ];

/// G 药品 M物资
Property SCDIStkType As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SCDI_StkType ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCSTSCDI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SCDI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SCDI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SCDI_StkType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SCDI_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SCDI_TypeDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCSTSCDI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SCDI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{SCDI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCSTSCDI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SCDI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({SCDI_Type})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{SCDI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeCode">
<Global>^DHCSTSCDI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SCDI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPECODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({SCDI_Type})</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SCDI_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SCDI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SCDI_RowID</SqlRowIdName>
<StreamLocation>^User.DHCStkComDictionaryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
