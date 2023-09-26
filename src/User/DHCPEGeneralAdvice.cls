Class User.DHCPEGeneralAdvice Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GA_RowId, SqlTableName = DHC_PE_GeneralAdvice, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEGeneralAdvice";

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPEGeneralAdviceDetail As User.DHCPEGeneralAdviceDetail [ Cardinality = children, Inverse = GADParref ];

/// GA_AduitDate
Property GAAduitDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 7, SqlFieldName = GA_AduitDate ];

/// GA_AduitUser_DR
Property GAAduitUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = GA_AduitUser_DR ];

/// GA_Advice
Property GAAdvice As list Of %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = GA_Advice, SqlListDelimiter = "$C(0)", SqlListType = DELIMITED ];

/// GA_IADM_DR
Property GAIADMDR As User.DHCPEIADM [ SqlColumnNumber = 2, SqlFieldName = GA_IADM_DR ];

/// GA_UpdateDate
Property GAUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 4, SqlFieldName = GA_UpdateDate ];

/// GA_UpdateUser_DR
Property GAUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = GA_UpdateUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEGA)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEGA">
<Data name="GA_AduitDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="GA_AduitUser_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="GA_Advice">
<Delimiter>"^"</Delimiter>
<Node>"A"</Node>
<Piece>1</Piece>
</Data>
<Data name="GA_IADM_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="GA_UpdateDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="GA_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Global>^DHCPEGA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{GA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexIADM">
<Global>^DHCPEGA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"IADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GA_IADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEGeneralAdviceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
