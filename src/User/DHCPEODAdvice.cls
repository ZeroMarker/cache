Class User.DHCPEODAdvice Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ODA_RowId, SqlTableName = DHC_PE_ODAdvice, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEODAdvice";

Parameter EXTENTSIZE = 250;

/// ODA_ST_DR
Property ODASTDR As User.DHCPEStation [ SqlColumnNumber = 2, SqlFieldName = ODA_ST_DR ];

/// ODA_DiagnoseConclusion
Property ODADiagnoseConclusion As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ODA_DiagnoseConclusion ];

/// ODA_Advice
Property ODAAdvice As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ODA_Advice ];

/// ODA_AdviceDetail
Property ODAAdviceDetail As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ODA_AdviceDetail ];

/// ODA_UserUpdate_DR
Property ODAUserUpdateDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ODA_UserUpdate_DR ];

/// ODA_DateUpdate
Property ODADateUpdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = ODA_DateUpdate ];

/// ODA_Illness
Property ODAIllness As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 8, SqlFieldName = ODA_Illness ];

/// ODA_CommonIllness
Property ODACommonIllness As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 9, SqlFieldName = ODA_CommonIllness ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEODA)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEODA">
<Data name="ODA_Advice">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ODA_AdviceDetail">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ODA_CommonIllness">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ODA_DateUpdate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ODA_DiagnoseConclusion">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ODA_Illness">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ODA_ST_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ODA_UserUpdate_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPEODA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ODA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDiagnoseConclusion">
<Global>^DHCPEODA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ODA_DiagnoseConclusion}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ODA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEODAdviceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
