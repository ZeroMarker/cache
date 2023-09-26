/// 处方点评基础数据子表
Class User.DHCPHCNTSORDERITM Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCOI_RowId, SqlTableName = DHC_PHCNTSORDERITM, StorageStrategy = CacheSQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHCOIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PHCOIPHCOPARREF As User.DHCPHCNTSORDER [ Cardinality = parent, Inverse = ChildDHCPHCNTSORDERITM, Required, SqlFieldName = PHCOI_PHCO_PARREF ];

Property PHCOIChildSub As %Numeric(SCALE = 0) [ Required, SqlColumnNumber = 2, SqlFieldName = PHCOI_ChildSub ];

/// 开单日期
Property PHCOIOrdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PHCOI_OrdDate ];

/// 医嘱项Id
Property PHCOIArcimDr As User.ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = PHCOI_Arcim_Dr ];

/// 管制分类
Property PHCOIPoisonDr As User.PHCPoison [ SqlColumnNumber = 5, SqlFieldName = PHCOI_Poison_Dr ];

/// 新药学分类
Property PHCOIPhcCatDr As User.DHCPHCCat [ SqlColumnNumber = 6, SqlFieldName = PHCOI_PhcCat_Dr ];

/// 剂型
Property PHCOIFormDr As User.PHCForm [ SqlColumnNumber = 7, SqlFieldName = PHCOI_Form_Dr ];

/// 国家基本药物
Property PHCOIBasicFlag As %Library.String(DISPLAYLIST = ",Y,N", MAXLEN = 4, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PHCOI_BasicFlag ];

/// 医嘱Id
Property PHCOIOeoriDr As User.OEOrdItem [ SqlColumnNumber = 9, SqlFieldName = PHCOI_Oeori_Dr ];

/// 院区Id
Property PHCOIHospDr As User.CTHospital [ SqlColumnNumber = 10, SqlFieldName = PHCOI_Hosp_Dr ];

/// 就诊类型
Property PHCOIAdmType As %Library.String(DISPLAYLIST = ",I,O,H,E", MAXLEN = 4, VALUELIST = ",I,O,H,E") [ SqlColumnNumber = 11, SqlFieldName = PHCOI_AdmType ];

/// 医嘱金额
Property PHCOISpAmt As %Library.Double [ SqlColumnNumber = 12, SqlFieldName = PHCOI_SpAmt ];

Storage CacheSQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexArcim">
<Global>^DHCPHCNTSORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DHC_PHCNTSORDER.PHCO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>PHCOI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arcim"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCOI_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCOI_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCOI_OrdDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHCOI_Arcim_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHC_PHCNTSORDER.PHCO_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{PHCOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBasicFlag">
<Global>^DHCPHCNTSORDER</Global>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DHC_PHCNTSORDER.PHCO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>PHCOI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BasicFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCOI_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCOI_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCOI_OrdDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHCOI_BasicFlag}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHC_PHCNTSORDER.PHCO_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{PHCOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexForm">
<Global>^DHCPHCNTSORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DHC_PHCNTSORDER.PHCO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>PHCOI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Form"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCOI_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCOI_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCOI_OrdDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHCOI_Form_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHC_PHCNTSORDER.PHCO_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{PHCOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOeori">
<Global>^DHCPHCNTSORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHCNTSORDER.PHCO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHCOI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Oeori"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCOI_Oeori_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHCNTSORDER.PHCO_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPhcCat">
<Global>^DHCPHCNTSORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DHC_PHCNTSORDER.PHCO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>PHCOI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PhcCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCOI_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCOI_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCOI_OrdDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHCOI_PhcCat_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHC_PHCNTSORDER.PHCO_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{PHCOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPoison">
<Global>^DHCPHCNTSORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DHC_PHCNTSORDER.PHCO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>PHCOI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Poison"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCOI_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCOI_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCOI_OrdDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHCOI_Poison_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHC_PHCNTSORDER.PHCO_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{PHCOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="PHCOI_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHCOI_Arcim_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCOI_BasicFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHCOI_Form_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHCOI_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHCOI_Oeori_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHCOI_OrdDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCOI_PhcCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHCOI_Poison_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHCOI_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCPHCNTSORDER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHCNTSORDER.PHCO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHCOI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHCNTSORDER.PHCO_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCOI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>User.DHCPHCNTSORDERITMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
