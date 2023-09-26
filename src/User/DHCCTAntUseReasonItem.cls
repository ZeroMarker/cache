Class User.DHCCTAntUseReasonItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DAURI_Rowid, SqlTableName = DHC_CTAntUseReasonItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (DAURIAURParRef, DAURIChildsub) [ IdKey, PrimaryKey, Unique ];

Property DAURIChildsub As %Float [ InitialExpression = {$i(^DCTAR("AUR",+$s($d(initvalue):initvalue,1:%d(0)),"I",0))}, SqlColumnNumber = 3, SqlFieldName = DAURI_Childsub ];

/// DAURI_Code
Property DAURICode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DAURI_Code ];

/// DAURI_Desc 
Property DAURIDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DAURI_Desc ];

/// DAURI_ActiveFlag
Property DAURIActiveFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DAURI_ActiveFlag ];

Property DAURIAURParRef As User.DHCCTAntUseReason [ SqlColumnNumber = 2, SqlFieldName = DAURI_AUR_ParRef ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="DAURI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DAURI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DAURI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DCTAR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DAURI_AUR_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DAURI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AUR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAURI_AUR_ParRef}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DAURI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DAURI_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCCTAntUseReasonItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
