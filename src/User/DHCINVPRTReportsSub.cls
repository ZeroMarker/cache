Class User.DHCINVPRTReportsSub Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = HisSub_RowId, SqlTableName = DHC_INVPRTReportsSub, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HisSubChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVPRTReports Parent Reference
Relationship HisSubParRef As User.DHCINVPRTReports [ Cardinality = parent, Inverse = ChildDHCINVPRTReportsSub, Required, SqlFieldName = HisSub_ParRef ];

/// HisSub_ChildSub
Property HisSubChildSub As %Library.Float [ InitialExpression = {$i(^DHCOPInsFoot($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"C",0))}, SqlColumnNumber = 2, SqlFieldName = HisSub_ChildSub ];

/// HisSub_Cat_DR 大类指针
Property HisSubCatDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HisSub_Cat_DR ];

/// HisSub_InsType_DR 费别指针
Property HisSubInsTypeDR As User.PACAdmReason [ SqlColumnNumber = 4, SqlFieldName = HisSub_InsType_DR ];

/// HisSub_SubCat_DR 子分类指针
Property HisSubSubCatDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = HisSub_SubCat_DR ];

/// HisSub_TarSubjectType 子分类类型
Property HisSubTarSubjectType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = HisSub_TarSubjectType ];

/// HisSub_PaySum 子分类收费金额
Property HisSubPaySum As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = HisSub_PaySum ];

/// HisSub_RefundSum 子分类退费金额
Property HisSubRefundSum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = HisSub_RefundSum ];

/// HisSub_DiscSum 子分类折扣金额
Property HisSubDiscSum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = HisSub_DiscSum ];

/// HisSub_PayorShareSum 子分类记账金额
Property HisSubPayorShareSum As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = HisSub_PayorShareSum ];

/// HisSub_PatShareSum 子分类自付金额
Property HisSubPatShareSum As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = HisSub_PatShareSum ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DHCINVRepSub">
<Data name="HisSub_Cat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HisSub_DiscSum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HisSub_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HisSub_PatShareSum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HisSub_PaySum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HisSub_PayorShareSum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HisSub_RefundSum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HisSub_SubCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HisSub_TarSubjectType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCOPInsFoot</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVPRTReports.HIS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HisSub_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_INVPRTReports.HIS_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"C"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HisSub_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCINVPRTReportsSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
