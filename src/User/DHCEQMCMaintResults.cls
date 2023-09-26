Class User.DHCEQMCMaintResults Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQMCMaintResults, StorageStrategy = SQLStorage ]
{

/// MR_Code
Property MRCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MR_Code ];

/// MR_Desc
Property MRDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MR_Desc ];

/// MR_Remark
Property MRRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MR_Remark ];

/// MR_InvalidFlag
Property MRInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = MR_InvalidFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQMCMaintResults",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQMCMaintResults"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{MR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MR_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQMCMaintResultsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
