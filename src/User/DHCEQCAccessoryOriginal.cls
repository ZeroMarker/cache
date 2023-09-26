Class User.DHCEQCAccessoryOriginal Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AO_RowID, SqlTableName = DHC_EQCAccessoryOriginal, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AO_Code
Property AOCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AO_Code ];

/// AO_Desc
Property AODesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AO_Desc ];

/// AO_Remark
Property AORemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AO_Remark ];

/// AO_InvalidFlag
Property AOInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AO_InvalidFlag ];

/// AO_SourceType
Property AOSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AO_SourceType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCAccessoryOriginal",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AO_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AO_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AO_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AO_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AO_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCAccessoryOriginal"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AO_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCAccessoryOriginalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
