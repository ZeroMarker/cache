/// 配送任务类型
Class User.DHCDisTypeAdd Extends (%Persistent, %XML.Adaptor) [ SqlRowIdName = TA_RowID, SqlTableName = DHC_DisTypeAdd, StorageStrategy = NewStorage1 ]
{

/// 代码  TA_Code
Property DACode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = TA_Code ];

/// 描述  TA_Desc
Property TADesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = TA_Desc ];

/// 是否可用  TA_ActiveFlag
Property TAActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = TA_ActiveFlag ];

/// 集团化医院  TA_Hosp_Dr
Property TAHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = TA_Hosp_Dr ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCDISTA)</SqlIdExpression>
<SQLMap name="DataMap">
<BlockCount>1</BlockCount>
<Data name="TA_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TA_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDISTA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCode">
<Global>^DHCDISTA</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TA_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TA_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDisTypeAddS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
