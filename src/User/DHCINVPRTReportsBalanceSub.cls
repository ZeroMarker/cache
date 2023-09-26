Class User.DHCINVPRTReportsBalanceSub Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = HBS_RowId, SqlTableName = DHC_INVPRTReportsBalanceSub, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HBSChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVPRTReports Parent Reference
Relationship HBSParRef As User.DHCINVPRTReports [ Cardinality = parent, Inverse = ChildDHCINVPRTReportsBalanceSub, Required, SqlFieldName = HBS_ParRef ];

/// HBS_ChildSub
Property HBSChildSub As %Library.Float [ InitialExpression = {$i(^DHCOPInsFoot($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"B",0))}, SqlColumnNumber = 2, SqlFieldName = HBS_ChildSub ];

/// HBS_CustomText 自定义描述
Property HBSCustomText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = HBS_CustomText ];

/// HBS_CustomVal 自定义值
Property HBSCustomVal As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = HBS_CustomVal ];

/// HBS_CustomNote 字段计算方式备注
Property HBSCustomNote As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = HBS_CustomNote ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="HBS_CustomNote">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HBS_CustomText">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HBS_CustomVal">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCOPInsFoot</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVPRTReports.HIS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HBS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_INVPRTReports.HIS_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"B"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HBS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCINVPRTReportsBalanceSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
