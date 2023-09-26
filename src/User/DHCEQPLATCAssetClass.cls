Class User.DHCEQPLATCAssetClass Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQPLATCAssetClass, StorageStrategy = SQLStorage ]
{

/// AC_Code
Property ACCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AC_Code ];

/// AC_Desc
Property ACDesc As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AC_Desc ];

/// AC_AssetTypeDR
Property ACAssetTypeDR As DHCEQPLATCAssetType [ SqlColumnNumber = 4, SqlFieldName = AC_AssetTypeDR ];

/// AC_Remark
Property ACRemark As %String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AC_Remark ];

/// AC_DateFrom
Property ACDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = AC_DateFrom ];

/// AC_DateTo
Property ACDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = AC_DateTo ];

/// AC_EXType
Property ACEXType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AC_EXType ];

/// AC_EXID
Property ACEXID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AC_EXID ];

/// AC_InvalidFlag
Property ACInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = AC_InvalidFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCTPLAT("AssetClass",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AC_AssetTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AC_EXID">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AC_EXType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AC_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQCTPLAT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"AssetClass"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{AC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQCTPLAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AssetClass"</Expression>
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
<Expression>{AC_Code}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AC_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQPLATCAssetClassS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
