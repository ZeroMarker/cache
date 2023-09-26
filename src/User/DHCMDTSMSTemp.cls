Class User.DHCMDTSMSTemp Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MS_RowID, SqlTableName = DHC_MDTSMSTemp, StorageStrategy = NewStorage1 ]
{

Relationship ChildDHCMDTSMSTEMPD As User.DHCMDTSMSTempD [ Cardinality = children, Inverse = MSTempParRef ];

/// MS_Code  代码
Property MSCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MS_Code ];

/// MS_Desc  描述
Property MSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MS_Desc ];

/// 是否可用  MS_ActiveFlag
Property MSActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MS_ActiveFlag ];

/// 集团化医院  MS_Hosp_Dr
Property MSHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = MS_Hosp_Dr ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCMDTSMST)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MS_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MS_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMDTSMST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCMDTSMST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MS_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MS_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCMDTSMST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MS_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MS_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTSMSTempS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
