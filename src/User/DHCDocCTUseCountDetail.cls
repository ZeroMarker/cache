/// 基础代码表数据使用次数记录明细,按不同的权限级别记录
Class User.DHCDocCTUseCountDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_DocCTUseCountDetail, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On UCDChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to User.DHCDocCTUseCount
Relationship DHCDocCTUseCountParRef As DHCDocCTUseCount [ Cardinality = parent, Inverse = ChildDHCDocCTUseCountDetail, Required, SqlFieldName = UCD_ParRef ];

/// User.DHCDocCTUseCountDetail KEY
Property UCDChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCDOCCTUC(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = UCD_ChildSub ];

/// 权限类型(Group(安全组),Dept(科室),User(用户))
Property UCDAuthType As %String(DISPLAYLIST = ",Group,Dept,User", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",G,D,U") [ Required, SqlColumnNumber = 3, SqlFieldName = UCD_AuthType ];

/// 权限类型对应的关联表RowId
Property UCDAuthID As %Integer [ Required, SqlColumnNumber = 4, SqlFieldName = UCD_AuthID ];

/// 使用次数
Property UCDCount As %Integer [ Required, SqlColumnNumber = 5, SqlFieldName = UCD_Count ];

/// 最后使用日期
Property UCDLastUseDate As %Date [ SqlColumnNumber = 6, SqlFieldName = UCD_LastUseDate ];

/// 最后使用时间
Property UCDLastUseTime As %Time [ SqlColumnNumber = 7, SqlFieldName = UCD_LastUseTime ];

/// 最后使用机器IP
Property UCDLastUseIP As %String(COLLATION = "AlphaUp", MAXLEN = 12, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = UCD_LastUseIP ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="UCD_AuthID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UCD_AuthType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UCD_Count">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UCD_LastUseDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UCD_LastUseIP">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UCD_LastUseTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCDOCCTUC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCTUseCount.UC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>UCD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCTUseCount.UC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UCD_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuthData">
<Global>^DHCDOCCTUCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocCTUseCount.UC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>UCD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Auth"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UCD_AuthType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UCD_AuthID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCTUseCount.UC_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UCD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParAuthData">
<Global>^DHCDOCCTUCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_DocCTUseCount.UC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>UCD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ParAuth"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_DocCTUseCount.UC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UCD_AuthType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UCD_AuthID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UCD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>UCD_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocCTUseCountDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
