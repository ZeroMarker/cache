Class User.DHCItmReVendor Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IRV_Rowid, SqlTableName = DHC_ItmReVendor, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On IRVChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_ItmRemark Parent Reference
Relationship IRVParref As User.DHCItmRemark [ Cardinality = parent, Inverse = ChildDHCItmReVendor, Required, SqlFieldName = IRV_Parref ];

/// IRV_Childsub
Property IRVChildsub As %Library.Float [ InitialExpression = {$i(^ITMREK($p(%d(0),$c(1),1),"V",0))}, Required, SqlColumnNumber = 2, SqlFieldName = IRV_Childsub ];

/// IRV_ProvCert_Dr
Property IRVProvCertDr As User.APCVendor [ SqlColumnNumber = 3, SqlFieldName = IRV_ProvCert_Dr ];

/// IRV_ProvCertExpDate
Property IRVProvCertExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = IRV_ProvCertExpDate ];

/// IRV_MC_DR  - User.DHCItmManfCert 保存历史的注册证信息
Property IRVMCDR As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IRV_MC_DR ];

/// IRV_MC_Date   --  保存日期
Property IRVMCDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = IRV_MC_Date ];

/// IRV_MC_Time   --  保存时间
Property IRVMCTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = IRV_MC_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="dataMaster">
<Data name="IRV_MC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IRV_MC_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IRV_MC_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IRV_ProvCertExpDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IRV_ProvCert_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ITMREK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ItmRemark.IR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IRV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_ItmRemark.IR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"V"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{IRV_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCItmReVendorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
