Class User.DHCEQCComponentItemVisit Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQCComponentItemVisit, StorageStrategy = SQLStorage ]
{

/// CIV_GroupDR
Property CIVGroupDR As User.SSGroup [ SqlColumnNumber = 2, SqlFieldName = CIV_GroupDR ];

/// CIV_ComponentItemDR
Property CIVComponentItemDR As User.DHCEQCComponentItem [ SqlColumnNumber = 3, SqlFieldName = CIV_ComponentItemDR ];

/// CIV_DisplayType
Property CIVDisplayType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CIV_DisplayType ];

/// CIV_Hold1
Property CIVHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CIV_Hold1 ];

/// CIV_Hold2
Property CIVHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CIV_Hold2 ];

/// CIV_Hold3
Property CIVHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CIV_Hold3 ];

/// CIV_Hold4
Property CIVHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CIV_Hold4 ];

/// CIV_Hold5
Property CIVHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CIV_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCComponentItemVisit",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CIV_ComponentItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CIV_DisplayType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CIV_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CIV_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CIV_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CIV_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CIV_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CIV_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CIV_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCComponentItemVisit"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CIV_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexComponentItem">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CIV_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCComponentItemVisit"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"ComponentItem"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CIV_GroupDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CIV_ComponentItemDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{CIV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CIV_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQCComponentItemVisitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
