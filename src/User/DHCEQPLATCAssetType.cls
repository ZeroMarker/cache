Class User.DHCEQPLATCAssetType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQPLATCAssetType, StorageStrategy = SQLStorage ]
{

/// AT_Code
Property ATCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AT_Code ];

/// AT_Desc
Property ATDesc As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AT_Desc ];

/// AT_Remark
Property ATRemark As %String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AT_Remark ];

/// AT_DateFrom
Property ATDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = AT_DateFrom ];

/// AT_DateTo
Property ATDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = AT_DateTo ];

/// AT_InvalidFlag
Property ATInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = AT_InvalidFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCTPLAT("AssetType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AT_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCTPLAT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AssetType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQCTPLAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AssetType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AT_Code}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AT_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQPLATCAssetTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
