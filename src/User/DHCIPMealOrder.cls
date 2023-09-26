Class User.DHCIPMealOrder Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCMO_RowID, SqlTableName = DHC_IPMealOrder, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCIPMealOrdItem As User.DHCIPMealOrdItem [ Cardinality = children, Inverse = DHCMOIMORDPARREF ];

/// DHCMO_Adm_Dr
Property DHCMOAdmDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCMO_Adm_Dr ];

/// DHCMO_Date
Property DHCMODate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCMO_Date ];

/// DHCMO_Time
Property DHCMOTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DHCMO_Time ];

/// DHCMO_User_Dr
Property DHCMOUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCMO_User_Dr ];

/// DHCMO_Remark
Property DHCMORemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DHCMO_Remark ];

/// DHCMO_Comment1
Property DHCMOComment1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DHCMO_Comment1 ];

/// DHCMO_Comment2
Property DHCMOComment2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCMO_Comment2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCIPMEALORDER)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCMO_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCMO_Comment1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCMO_Comment2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCMO_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCMO_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCMO_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCMO_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCIPMEALORDER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCMO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCMO_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCIPMEALORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMO_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexData">
<Global>^DHCIPMEALORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMO_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPMealOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
