/// 煎药子表 2019-06-10 hulihua 
/// d ##Class(User.PHADECPreItem).%BuildIndices()
Class User.PHADECPreItem Extends (%Persistent, %XML.Adaptor, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = PDPI_RowId, SqlTableName = PHA_DECPreItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// sub做索引，对sub做约束
Index RowIDBasedIDKeyIndex On PDPIChildSub [ IdKey, PrimaryKey, Unique ];

/// 关联主表
Relationship PDPIParrefDr As User.PHADECPreMain [ Cardinality = parent, Inverse = ChildPHADECPreItem, Required, SqlFieldName = PDPI_Parref_Dr ];

/// 子表计数器
Property PDPIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^BS.PHA.DEC.PM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PDPI_ChildSub ];

/// 操作人
Property PDPIProUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = PDPI_ProUser_Dr ];

/// 操作日期
Property PDPIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PDPI_Date ];

/// 操作时间
Property PDPITime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PDPI_Time ];

/// 对应流程
Property PDPIPstDr As User.PHADECProSto [ SqlColumnNumber = 6, SqlFieldName = PDPI_Pst_Dr ];

/// 发放顺序号
Property PDPIFFSeqNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PDPI_FFSeqNo ];

/// 煎药设备
Property PDPIEquiDr As User.PHADECEquiMai [ SqlColumnNumber = 8, SqlFieldName = PDPI_Equi_Dr ];

/// 备注
Property PDPIRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PDPI_Remarks ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PDPI_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDPI_Equi_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDPI_FFSeqNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDPI_ProUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDPI_Pst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDPI_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDPI_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^BS.PHA.DEC.PM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHA_DECPreMain.PDPM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PDPI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHA_DECPreMain.PDPM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDPI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDStDr">
<Global>^BS.PHA.DEC.PMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHA_DECPreMain.PDPM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PDPI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DECSTDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDPI_Pst_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHA_DECPreMain.PDPM_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDPI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDatePSt">
<Global>^BS.PHA.DEC.PMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHA_DECPreMain.PDPM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PDPI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DATEPSTDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDPI_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDPI_Pst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHA_DECPreMain.PDPM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDPI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHADECPreItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
