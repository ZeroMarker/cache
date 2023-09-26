Class User.DHCEQCDisuseType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DR_RowID, SqlTableName = DHC_EQCDisuseType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DR_Code
Property DRCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DR_Code ];

/// DR_Desc
Property DRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DR_Desc ];

/// DR_Remark
Property DRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DR_Remark ];

/// DR_InvalidFlag
Property DRInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DR_InvalidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCDisuseType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCDisuseType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCDisuseTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
