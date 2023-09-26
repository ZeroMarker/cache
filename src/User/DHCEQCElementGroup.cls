Class User.DHCEQCElementGroup Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EG_RowID, SqlTableName = DHC_EQCElementGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EG_ElementCatDR
Property EGElementCatDR As User.DHCEQCElementCat [ SqlColumnNumber = 2, SqlFieldName = EG_ElementCatDR ];

/// EG_Name
Property EGName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EG_Name ];

/// EG_Desc
Property EGDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EG_Desc ];

/// EG_Note
Property EGNote As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EG_Note ];

/// EG_Remark
Property EGRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EG_Remark ];

/// EG_InvalidFlag
Property EGInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = EG_InvalidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCElementGroup",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EG_ElementCatDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EG_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EG_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EG_Note">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EG_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EG_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCElementGroup"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{EG_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexElementCatDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EG_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCElementGroup"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ElementCatDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EG_ElementCatDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCElementGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
