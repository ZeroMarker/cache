Class User.DHCINVPRTReportsINSUType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = HisInsu_RowId, SqlTableName = DHC_INVPRTReportsINSUType, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HisInsuChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVPRTReports Parent Reference
Relationship HisInsuParRef As User.DHCINVPRTReports [ Cardinality = parent, Inverse = ChildDHCINVPRTReportsINSUType, Required, SqlFieldName = HisInsu_ParRef ];

/// HisInsu_ChildSub
Property HisInsuChildSub As %Library.Float [ InitialExpression = {$i(^DHCOPInsFoot($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"INSU",0))}, SqlColumnNumber = 2, SqlFieldName = HisInsu_ChildSub ];

/// HisInsu_DicCode 统筹区编码
Property HisInsuDicCode As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HisInsu_DicCode ];

/// HisInsu_PaySum 医保支付金额
Property HisInsuPaySum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = HisInsu_PaySum ];

/// HisInsu_PayNum 医保支付数量
Property HisInsuPayNum As %Library.Integer [ SqlColumnNumber = 5, SqlFieldName = HisInsu_PayNum ];

/// HisInsu_RefundSum 医保退费金额
Property HisInsuRefundSum As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = HisInsu_RefundSum ];

/// HisInsu_RefundNum 医保退费数量
Property HisInsuRefundNum As %Library.Integer [ SqlColumnNumber = 7, SqlFieldName = HisInsu_RefundNum ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="HisInsu_DicCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HisInsu_PayNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HisInsu_PaySum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HisInsu_RefundNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HisInsu_RefundSum">
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
<Field>HisInsu_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_INVPRTReports.HIS_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INSU"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HisInsu_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCINVPRTReportsINSUTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
