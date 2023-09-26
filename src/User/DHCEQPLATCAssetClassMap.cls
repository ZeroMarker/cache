Class User.DHCEQPLATCAssetClassMap Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQPLATCAssetClassMap, StorageStrategy = SQLStorage ]
{

/// ACM_AssetClassDR
Property ACMAssetClassDR As DHCEQPLATCAssetClass [ SqlColumnNumber = 2, SqlFieldName = ACM_AssetClassDR ];

/// ACM_SourceType
Property ACMSourceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ACM_SourceType ];

/// ACM_SourceID
Property ACMSourceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ACM_SourceID ];

/// ACM_DateFrom
Property ACMDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = ACM_DateFrom ];

/// ACM_DateTo
Property ACMDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = ACM_DateTo ];

/// ACM_Remark
Property ACMRemark As %String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ACM_Remark ];

/// ACM_InvalidFlag
Property ACMInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ACM_InvalidFlag ];

/// ACM_Hold1
Property ACMHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ACM_Hold1 ];

/// ACM_Hold2
Property ACMHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ACM_Hold2 ];

/// ACM_Hold3
Property ACMHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ACM_Hold3 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCTPLAT("AssetClassMap",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ACM_AssetClassDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ACM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ACM_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ACM_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ACM_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ACM_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ACM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ACM_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ACM_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCTPLAT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ACM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"AssetClassMap"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{ACM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQCTPLAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ACM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AssetClassMap"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACM_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ACM_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ACM_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQPLATCAssetClassMapS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
