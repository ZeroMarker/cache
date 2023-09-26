Class User.DHCDischargeHistory Extends %Persistent [ SqlRowIdName = DHCDis_RowId, SqlTableName = DHC_DischargeHistory, StorageStrategy = SQLStorage ]
{

Relationship DHCDisPAADMEXTParRef As User.PAAdmExt [ Cardinality = parent, Inverse = ChildDHCDisHistory, Required, SqlFieldName = DHCDis_PAAdmExt_ParRef ];

Index RowIDBasedIDKeyIndex On DisChildsub [ IdKey, PrimaryKey, Unique ];

Property DisChildsub As %Float [ InitialExpression = {$i(^DHCDischargeHistory($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),0))}, SqlColumnNumber = 2, SqlFieldName = DHCDis_Childsub ];

/// 操作日期
Property DisUpdateDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = DHCDis_UpdateDate ];

/// 操作时间
Property DisUpdateTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DHCDis_UpdateTime ];

/// 操作用户
Property DisUpdateUserDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = DHCDis_UpdateUserDr ];

/// 类型 E:医生出院  C:医生撤销出院 F:护士出院 R:护士召回病人  B:费用调整   T:结束费用调整
Property DisUpdateType As %String(MAXLEN = 2, TRUNCATE = 1, VALUELIST = ",E,C,F,R,B,T") [ SqlColumnNumber = 6, SqlFieldName = DHCDis_UpdateType ];

/// 出院日期
Property DisDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = DHCDis_Date ];

/// 出院时间
Property DisTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = DHCDis_Time ];

/// 关联医嘱ID
Property DisOEOrderDr As User.OEOrdItem [ SqlColumnNumber = 9, SqlFieldName = DHCDis_OEOrderDr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="IndexDisDate">
<Global>^DHCDischargeHistory</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_AdmExt.PAADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHCDis_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DisDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCDis_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCDis_UpdateType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_AdmExt.PAADM_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCDis_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDate">
<Global>^DHCDischargeHistory</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_AdmExt.PAADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHCDis_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UpdateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCDis_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCDis_UpdateType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_AdmExt.PAADM_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCDis_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DHCDis_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCDis_OEOrderDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCDis_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCDis_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCDis_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCDis_UpdateType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCDis_UpdateUserDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDischargeHistory</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_AdmExt.PAADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCDis_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PA_AdmExt.PAADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"History"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCDis_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DHCDis_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDischargeHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
