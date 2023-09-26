Class User.DHCPAAdmSheetsLog Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = SL_RowId, SqlTableName = DHC_PAAdmSheetsLog, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SLChildsub [ IdKey, PrimaryKey, Unique ];

Property SLChildsub As %Float [ InitialExpression = {$i(^DHCPAADMS($p($s($d(p1):p1,1:%d(0)),$c(1),1),"L",0))}, Required, SqlColumnNumber = 2, SqlFieldName = SL_Childsub ];

/// 日志
Property SLLog As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SL_Log ];

Relationship SLSheetParRef As DHCPAAdmSheets [ Cardinality = parent, Inverse = ChildSheetsLog, Required, SqlFieldName = SL_Sheet_ParRef ];

/// 修改日期
Property SLUpdateDate As %Date [ SqlColumnNumber = 4, SqlFieldName = SI_AddDate ];

/// 修改时间
Property SLUpdateTime As %Time [ SqlColumnNumber = 5, SqlFieldName = SI_AddTime ];

/// 修改人
Property SLUpdateUserDr As SSUser [ SqlColumnNumber = 6, SqlFieldName = SI_AddUser_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SI_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SI_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SI_AddUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SL_Log">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPAADMS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PAAdmSheets.PAADMS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SL_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PAAdmSheets.PAADMS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"L"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPAAdmSheetsLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
