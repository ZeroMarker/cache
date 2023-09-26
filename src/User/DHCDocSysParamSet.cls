Class User.DHCDocSysParamSet Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = DSPS_RowId, SqlTableName = DHC_DocSysParamSet, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DSPSChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to User.DHCDocSysParamApp
Relationship DHCDocSysParamAppParRef As DHCDocSysParamApp [ Cardinality = parent, Inverse = ChildDHCDocSysParamSet, Required, SqlFieldName = DSPS_ParRef ];

/// User.DHCDocSysParamSet KEY
Property DSPSChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCDocSYS("ParamSet",+$s($d(initvalue):initvalue,1:%d(0)),"S",0))}, Required, SqlColumnNumber = 2, SqlFieldName = DSPS_ChildSub ];

/// 权限范围类型(全院,安全组,科室,人员)
Property DSPSRangeType As %String(DISPLAYLIST = ",All,Group,Loc,User", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",ALL,GRP,LOC,USER") [ InitialExpression = "ALL", Required, SqlColumnNumber = 3, SqlFieldName = DSPS_RangeType ];

/// 权限范围值(全院固定为ALL,安全组|科室|人员 存储的是对应的数据记录RowId)
Property DSPSRangeValue As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = DSPS_RangeValue ];

/// 参数值
Property DSPSParamValue As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 5, SqlFieldName = DSPS_ParamValue ];

/// 参数描述
Property DSPSParamDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 6, SqlFieldName = DSPS_ParamDesc ];

/// 医院
Property DSPSHospitalDR As CTHospital [ SqlColumnNumber = 7, SqlFieldName = DSPS_Hospital_DR ];

/// 本地化
Property DSPSLocalFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = DSPS_LocalFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCDocSYS("ParamSet",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DSPS_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSPS_LocalFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DSPS_ParamDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSPS_ParamValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSPS_RangeType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSPS_RangeValue">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocSYS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_DocSysParamApp.DSPA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DSPS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ParamSet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_DocSysParamApp.DSPA_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"S"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSPS_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexParam">
<Global>^DHCDocSYSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocSysParamApp.DSPA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DSPS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocSysParamApp.DSPA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Range"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSPS_RangeType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSPS_RangeValue}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSPS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DSPS_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocSysParamSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
