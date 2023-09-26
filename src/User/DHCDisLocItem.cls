Class User.DHCDisLocItem Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = LI_RowId, SqlTableName = DHC_DisLocItem, StorageStrategy = SQLStorage ]
{

/// 代码  LI_Code
Property LICode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = LI_Code ];

/// 描述  LI_Desc
Property LIDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = LI_Desc ];

/// 接收科室  LI_RecLoc_Dr
Property LIRecLocDr As %String [ SqlColumnNumber = 4, SqlFieldName = LI_RecLoc_Dr ];

/// 类型  LI_Type
Property LIType As %String(DISPLAYLIST = ",配送,陪送,陪送其他,送物", SELECTIVITY = "33.3333%", VALUELIST = ",1,0,2,3") [ SqlColumnNumber = 5, SqlFieldName = LI_Type ];

/// 是否可用 LI_ActiveFlag
Property LIActiveFlag As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = LI_ActiveFlag ];

/// 集团化医院  LI_Hosp_Dr
Property LIHospDr As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = LI_Hosp_Dr ];

/// 配送任务类型  LI_TypeAdd_Dr
Property LITypeAddDr As User.DHCDisTypeAdd [ SqlColumnNumber = 8, SqlFieldName = LI_TypeAdd_Dr ];

/// 接收科室是否必填 LI_RecDeptActiveFlag
Property LIRecDeptActiveFlag As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = LI_RecDeptActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISLI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LI_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LI_RecDeptActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LI_RecLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LI_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LI_TypeAdd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCDISLI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LI_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index">
<Global>^DHCDISLI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({LI_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisLocItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
