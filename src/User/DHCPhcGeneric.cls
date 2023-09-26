/// 药房药库-处方通用名-扩展
Class User.DHCPhcGeneric Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCGE_RowId, SqlTableName = DHC_PhcGeneric, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PHCGEPHCGEDR [ IdKey, PrimaryKey, Unique ];

/// PHCGE_PHCGE_DR
Property PHCGEPHCGEDR As User.PHCGeneric [ Required, SqlColumnNumber = 2, SqlFieldName = PHCGE_PHCGE_DR ];

/// PHCGE_RECADT_Flag
Property PHCGERecAdtFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = PHCGE_RecAdt_Flag ];

/// 化学通用名
Property PHCGEPHCMDr As User.DHCPHChemical [ SqlColumnNumber = 4, SqlFieldName = PHCGE_PHCM_Dr ];

/// 库存分类
Property PHCGEINCSCDR As User.INCStkBin [ SqlColumnNumber = 5, SqlFieldName = PHCGE_INCSC_DR ];

/// 剂型
Property PHCGEPHCFDr As User.PHCForm [ SqlColumnNumber = 6, SqlFieldName = PHCGE_PHCF_Dr ];

/// 药学分类
Property PHCGEPHCCDR As User.DHCPHCCat [ SqlColumnNumber = 7, SqlFieldName = PHCGE_PHCC_DR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^PHCGE("DHC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHCGE_INCSC_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="PHCGE_PHCC_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="PHCGE_PHCF_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="PHCGE_PHCGE_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="PHCGE_PHCM_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="PHCGE_RecAdt_Flag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Global>^PHCGE</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHCGE_PHCGE_DR</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHCGE_PHCGE_DR}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexIncCat">
<Global>^PHCGE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHCGE_PHCGE_DR</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"IncCat"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCGE_INCSC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCGE_PHCGE_DR}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCC">
<Global>^PHCGE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHCGE_PHCGE_DR</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PHCC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCGE_PHCC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCGE_PHCGE_DR}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCM">
<Global>^PHCGE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHCGE_PHCGE_DR</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PHCM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCGE_PHCM_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCGE_PHCGE_DR}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHCGE_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPhcGenericS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
