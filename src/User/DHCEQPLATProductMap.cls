Class User.DHCEQPLATProductMap Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PM_RowID, SqlTableName = DHC_EQPLATProductMap, StorageStrategy = SQLStorage ]
{

/// PM_ProductDR
Property PMProductDR As DHCEQPLATCProduct [ SqlColumnNumber = 2, SqlFieldName = PM_ProductDR ];

/// PM_SourceType
Property PMSourceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PM_SourceType ];

/// PM_SourceID
Property PMSourceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PM_SourceID ];

/// PM_Remark
Property PMRemark As %String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PM_Remark ];

/// PM_InvalidFlag
Property PMInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PM_InvalidFlag ];

/// PM_Hold1
Property PMHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PM_Hold1 ];

/// PM_Hold2
Property PMHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PM_Hold2 ];

/// PM_Hold3
Property PMHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PM_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPLATProductMap(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PM_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PM_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PM_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PM_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PM_ProductDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PM_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PM_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQPLATProductMap</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexProduct">
<Global>^DHCEQPLATProductMap</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Product"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PM_ProductDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PM_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PM_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQPLATProductMap</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PM_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PM_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PM_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQPLATProductMapS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
