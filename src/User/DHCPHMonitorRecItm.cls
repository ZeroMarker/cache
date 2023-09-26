Class User.DHCPHMonitorRecItm Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMRI_RowID, SqlTableName = DHC_PHMonitorRecItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PHMRIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PHMRIParRefDr As User.DHCPHMonitorRecord [ Cardinality = parent, Inverse = ChildDHCPHMonitorRecItm, Required, SqlFieldName = PHMRI_ParRef_Dr ];

Property PHMRIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHMRI_ChildSub ];

Property PHMRIExtDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = PHMRI_ExtDate ];

Storage SQLStorage
{
<SQLMap name="indexExDate">
<Global>^DHCPHMREC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHMonitorRecord.PHMR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHMRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMRI_ExtDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHMonitorRecord.PHMR_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHMRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="master">
<Data name="PHMRI_ExtDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHMREC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHMonitorRecord.PHMR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHMRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHMonitorRecord.PHMR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMRI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMonitorRecItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
