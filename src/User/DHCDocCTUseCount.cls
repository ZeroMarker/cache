/// 医生站基础代码表数据使用次数记录表
Class User.DHCDocCTUseCount Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = UC_RowId, SqlTableName = DHC_DocCTUseCount, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCDocCTUseCountDetail As DHCDocCTUseCountDetail [ Cardinality = children, Inverse = DHCDocCTUseCountParRef ];

/// 代码表类名(格式:包.类名)不包含cls后缀
Property UCCodeTableClsName As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = UC_CodeTableClsName ];

/// 关联代码表ID
Property UCCodeTableID As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = UC_CodeTableID ];

/// 使用用户/创建用户
Property UCUserDR As User.SSUser [ Required, SqlColumnNumber = 6, SqlFieldName = UC_User_DR ];

/// 创建日期,默认系统当前日期
Property UCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = UC_CreateDate ];

/// 创建时间,默认系统当前时间
Property UCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = UC_CreateTime ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCDOCCTUC(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UC_CodeTableClsName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UC_CodeTableID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UC_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UC_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UC_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDOCCTUC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{UC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCreateDT">
<Global>^DHCDOCCTUCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CreateDT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UC_CreateDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UC_CreateTime}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserCT">
<Global>^DHCDOCCTUCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UserCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UC_User_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UC_CodeTableClsName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UC_CodeTableID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>UC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocCTUseCountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
