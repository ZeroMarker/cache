/// 科室物资维修记录子表
Class User.DHCLocMaintainItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = DHCLMI_Rowid, SqlTableName = DHC_LocMaintainItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHCLMIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship DHCLMParref As User.DHCLocMaintain [ Cardinality = parent, Inverse = ChildDHCLocMaintainItm, Required, SqlFieldName = DHCLMI_DHCLM_Parref ];

Property DHCLMIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DHCLMI_ChildSub ];

Property DHCLMIType As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCLMI_Type ];

/// 责任人
Property DHCLMIObliUser As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = DHCLMI_ObliUser ];

/// 维修供应商
Property DHCLMIAPCVMDR As User.APCVendor [ SqlColumnNumber = 5, SqlFieldName = DHCLMI_APCVM_DR ];

/// 维修费用
Property DHCLMIFee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DHCLMI_Fee ];

/// 接收科室
Property DHCLMIToLocDR As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = DHCLMI_ToLoc_DR ];

Property DHCLMIRemarks As list Of %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCLMI_Remarks, SqlListType = SUBNODE ];

/// 操作日期
Property DHCLMIOperDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = DHCLMI_OperDate ];

/// 操作时间
Property DHCLMIOperTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DHCLMI_OperTime ];

/// 操作人
Property DHCLMIOperUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = DHCLMI_OperUser ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexType">
<Global>^DHCLM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_LocMaintain.DHCLM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCLMI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCLMI_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_LocMaintain.DHCLM_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHCLMI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DHCLMI_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCLMI_Fee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCLMI_ObliUser">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCLMI_OperDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCLMI_OperTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCLMI_OperUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCLMI_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="DHCLMI_ToLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCLMI_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_LocMaintain.DHCLM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCLMI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_LocMaintain.DHCLM_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCLMI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DHCLMI_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCLocMaintainItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
