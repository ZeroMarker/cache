/// create by GR0021 2014-12-29构筑物资产卡片 
Class User.DHCEQStructures Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = S_RowID, SqlTableName = DHC_EQStructures, StorageStrategy = SQLStorage ]
{

/// S_StructDR
Property SStructDR As User.DHCEQCBuildingStruct [ SqlColumnNumber = 2, SqlFieldName = S_StructDR ];

/// S_Place
Property SPlace As %Library.String [ SqlColumnNumber = 3, SqlFieldName = S_Place ];

/// S_OwnerFlag
Property SOwnerFlag As %Library.String(DISPLAYLIST = ",无产权,有产权,产权待界定", MAXLEN = 4, SELECTIVITY = "25.00000%", VALUELIST = ",0,1,2") [ SqlColumnNumber = 4, SqlFieldName = S_OwnerFlag ];

/// S_OwnerKind
Property SOwnerKind As %Library.String(DISPLAYLIST = ",国有,集体", MAXLEN = 3, SELECTIVITY = "33.33330%", VALUELIST = ",0,1") [ SqlColumnNumber = 5, SqlFieldName = S_OwnerKind ];

/// S_CompletionDate
Property SCompletionDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = S_CompletionDate ];

/// S_Remark
Property SRemark As %Library.String [ SqlColumnNumber = 7, SqlFieldName = S_Remark ];

/// S_InvalidFlag
Property SInvalidFlag As %Library.String [ SqlColumnNumber = 8, SqlFieldName = S_InvalidFlag ];

/// S_SourceType
Property SSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = S_SourceType ];

/// S_SourceID
Property SSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = S_SourceID ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQStructures("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="S_CompletionDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="S_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="S_OwnerFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="S_OwnerKind">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="S_Place">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="S_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="S_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="S_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="S_StructDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQStructures</Global>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{S_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQStructures</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{S_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{S_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{S_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQStructuresS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
