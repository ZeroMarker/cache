/// 描述：医呼通设备发放
/// 创建人：陈莹-基础数据平台
/// 创建日期：2020-12-15
/// 修改日期；2022-08-18
Class User.CTHCCSEquipLinkContList Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlTableName = CT_HCCSEquipLinkContList, StorageStrategy = SQLStorage ]
{

/// 医呼通设备-指针
Property ELCLEquipmentDR As User.CTHCCSEquipment [ Required, SqlColumnNumber = 2, SqlFieldName = ELCL_Equipment_DR ];

/// 科室领用人（指向个人通讯录）
Property ELCLContactListDR As User.CTHCCSContactList [ Required, SqlColumnNumber = 3, SqlFieldName = ELCL_ContactList_DR ];

/// 关联开始日期-这个字段不用了
Property ELCLDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ELCL_DateFrom ];

/// 关联结束日期-这个字段不用了
Property ELCLDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ELCL_DateTo ];

/// 领用科室（指向 医呼通科室）
Property ELCLAcceptLocationDR As User.CTHCCSLocation [ SqlColumnNumber = 6, SqlFieldName = ELCL_AcceptLocation_DR ];

/// 发放时间（日期 时间 $zdt($h,3) ） 
Property ELCLDeliverTime As %TimeStamp [ SqlColumnNumber = 7, SqlFieldName = ELCL_DeliverTime ];

/// 状态（Y启用，N停用）
Property ELCLStatus As %String [ SqlColumnNumber = 8, SqlFieldName = ELCL_Status ];

/// 科室是否接收(Y/N)
Property ELCLIsAcceptedByLoc As %String [ SqlColumnNumber = 9, SqlFieldName = ELCL_IsAcceptedByLoc ];

/// 设备接收时间（日期 时间 $zdt($h,3) ）
Property ELCLAcceptTime As %TimeStamp [ SqlColumnNumber = 10, SqlFieldName = ELCL_AcceptTime ];

/// 设备接收人
Property ELCLAcceptUserDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = ELCL_AcceptUser_DR ];

/// 使用模式（全科共用A、单人专用U）
Property ELCLUseMode As %String [ SqlColumnNumber = 12, SqlFieldName = ELCL_UseMode ];

/// 使用人(单人专用时必须维护此字段， 个人通讯录)
Property ELCLEquipUserDR As User.CTHCCSContactList [ SqlColumnNumber = 13, SqlFieldName = ELCL_EquipUser_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("HCCSELCL",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ELCL_AcceptLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ELCL_AcceptTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ELCL_AcceptUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ELCL_ContactList_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ELCL_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ELCL_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ELCL_DeliverTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ELCL_EquipUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ELCL_Equipment_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ELCL_IsAcceptedByLoc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ELCL_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ELCL_UseMode">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ELCL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"HCCSELCL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ELCL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquipment">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ELCL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"HCCSELCL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"Equipment"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ELCL_Equipment_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ELCL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ELCL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"HCCSELCL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"CL"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ELCL_ContactList_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ELCL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ELCL_RowId</SqlRowIdName>
<StreamLocation>^User.CTHCCSEquipLinkContListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
