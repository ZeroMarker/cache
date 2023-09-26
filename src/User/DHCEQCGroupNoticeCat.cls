Class User.DHCEQCGroupNoticeCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GNC_RowID, SqlTableName = DHC_EQCGroupNoticeCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// GNC_DefaultFlag
Property GNCDefaultFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = GNC_DefaultFlag ];

/// GNC_NoticeCatDR
Property GNCNoticeCatDR As User.DHCEQPCNoticeCat [ SqlColumnNumber = 3, SqlFieldName = GNC_NoticeCatDR ];

/// GNC_GroupDR
Property GNCGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = GNC_GroupDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCGroupNoticeCat",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GNC_DefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GNC_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GNC_NoticeCatDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>GNC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCGroupNoticeCat"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{GNC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>GNC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCGroupNoticeCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GNC_GroupDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GNC_NoticeCatDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{GNC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCGroupNoticeCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
