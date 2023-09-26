Class User.DHCPHDQEvtTrigFac Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DQETF_RowID, SqlTableName = DHC_PHDQEvtTrigFac, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DQETF_Code
Property DQETFCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DQETF_Code ];

/// DQETF_Desc
Property DQETFDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DQETF_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DQETF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DQETF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHDQETF</Global>
<RowIdSpec name="1">
<Field>DQETF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DQETF_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHDQEvtTrigFacS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
