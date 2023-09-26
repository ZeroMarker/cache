Class User.DHCCTAntUseReason Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AUR_Rowid, SqlTableName = DHC_CT_AntUseReason, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AUR_Code
Property AURCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AUR_Code ];

/// AUR_Desc
Property AURDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AUR_Desc ];

/// AUR_ActiveFlag
Property AURActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = AUR_ActiveFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DCTAR("AUR"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AUR_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AUR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AUR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DCTAR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AUR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AUR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AUR_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCCTAntUseReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
