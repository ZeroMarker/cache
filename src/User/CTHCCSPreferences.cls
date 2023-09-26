/// 描述：医呼通-通讯录授权
/// 创建人：陈莹-基础数据平台
/// 创建日期：2020-12-15
Class User.CTHCCSPreferences Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlTableName = CT_HCCSPreferences, StorageStrategy = SQLStorage ]
{

/// 通讯录-指针
Property PREContactListDR As User.CTHCCSContactList [ Required, SqlColumnNumber = 2, SqlFieldName = PRE_ContactList_DR ];

/// 授权类型（群组G)
Property PREAuthorizeType As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PRE_AuthorizeType ];

/// 授权数据（群组ID)
Property PREAuthorizeData As %String [ Required, SqlColumnNumber = 4, SqlFieldName = PRE_AuthorizeData ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("HCCSPRE",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PRE_AuthorizeData">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PRE_AuthorizeType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRE_ContactList_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PRE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"HCCSPRE"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PRE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexContactList">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{PRE_RowId}</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"HCCSPRE"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CL"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PRE_ContactList_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PRE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexContactListPre">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>{PRE_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HCCSPRE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRE_ContactList_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PRE_AuthorizeType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PRE_AuthorizeData}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PRE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PRE_RowId</SqlRowIdName>
<StreamLocation>^User.CTHCCSPreferencesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
