Class User.DHCINVOPRefReason Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IRR_RowID, SqlTableName = DHC_INVOPRefReason, StorageStrategy = SQLStorage ]
{

/// IRR_Code
Property IRRCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IRR_Code ];

/// IRR_Desc
Property IRRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IRR_Desc ];

/// IRR_Hosp_DR
Property IRRHospDR As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = IRR_Hosp_DR ];

/// IRR_Note2
Property IRRNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IRR_Note2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINVOPREFR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IRR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IRR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IRR_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IRR_Note2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCINVOPREFR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IRR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IRR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCINVOPRefReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
