/// Function:国家标准数据源值域  码表 
/// Creator: sunfengchao
/// CreateDate:2016-4-7
Class User.BDPNationalDataDomain Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BDPDomain_RowId, SqlTableName = BDP_NationalDataDomain, StorageStrategy = SQLStorage ]
{

/// 值域代码   
Property BDPDomainCode As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = BDP_DomainCode ];

/// 值域代码名称
Property BDPDomainDescDR As User.BDPNationalDataType [ Required, SqlColumnNumber = 3, SqlFieldName = BDP_DomainDesc_DR ];

///  值
Property BDPDomainValue As %String [ SqlColumnNumber = 4, SqlFieldName = BDP_DomainValue ];

/// 值含义
Property BDPDomainExpression As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = BDP_DomainExpression ];

/// 类别 
Property BDPDomainType As %String [ SqlColumnNumber = 6, SqlFieldName = BDP_DomainType ];

/// 说明
Property BDPDomainStatement As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = BDP_DomainStatement ];

/// 国标版本
Property BDPDomainVersion As %String [ SqlColumnNumber = 8, SqlFieldName = BDP_DomainVersion ];

/// 其他
Property BDPDomainOther As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = BDP_DomainOther ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<Property name="APCVCCoCodeDR"/>
<Property name="CTADDCoCodeDR"/>
<SqlIdExpression>$i(^BDPDATADOMAIN(0))</SqlIdExpression>
<SQLMap name="DATAMasterMap">
<Data name="BDP_DomainCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BDP_DomainDesc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BDP_DomainExpression">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BDP_DomainOther">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BDP_DomainStatement">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BDP_DomainType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BDP_DomainValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BDP_DomainVersion">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^BDPDATADOMAIN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BDPDomain_R</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{BDPDomain_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTADDCode">
<Global>^BDPDATADOMAIN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BDPDomain_R</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({BDP_DomainCode})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{BDPDomain_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTADDDescDR">
<Global>^BDPDATADOMAIN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BDPDomain_R</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BDP_DomainDesc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDPDomain_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExpression">
<Global>^BDPDATADOMAIN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BDPDomain_R</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Expression"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BDP_DomainExpression}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDPDomain_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^BDPDATADOMAIN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BDPDomain_R</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DomainType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({BDP_DomainType})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDPDomain_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVersion">
<Global>^BDPDATADOMAIN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BDPDomain_R</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Version"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BDP_DomainVersion}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDPDomain_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BDPDomain_RowId</SqlRowIdName>
<StreamLocation>^User.BDPNationalDataDomainS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
