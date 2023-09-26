/// 配送请假
Class User.DHCDisLeave Extends (%Persistent, %XML.Adaptor) [ SqlRowIdName = Lev_RowID, SqlTableName = DHC_DisLeave, StorageStrategy = NewStorage ]
{

/// 请假日期  REQ_ExeDate	
Property LevDate As %Date [ SqlColumnNumber = 2, SqlFieldName = Lev_Date ];

/// 创建日期  Create_Date	
Property CreateDate As %Date [ InitialExpression = {+$p($h,",",1)}, SqlColumnNumber = 3, SqlFieldName = Create_Date ];

/// 创建时间  Create_Time	
Property CreateTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 4, SqlFieldName = Create_Time ];

/// 请假说明  Lev_Content
Property LevContent As %String [ SqlColumnNumber = 5, SqlFieldName = Lev_Content ];

/// 请假人  Lev_User
Property LevUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = Lev_User ];

/// 状态  Lev_Status
/// W 待审批/Y 审批通过/ N 审批拒绝 
Property LevStatus As %String [ InitialExpression = "W", SqlColumnNumber = 7, SqlFieldName = Lev_Status ];

/// 审批日期  Lev_AuditDate 
Property LevAuditDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Lev_AuditDate ];

/// 审批时间  Lev_AuditTime 
Property LevAuditTime As %Time [ SqlColumnNumber = 9, SqlFieldName = Lev_AuditTime ];

/// 审批人  Lev_AuditUser
Property LevAuditUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = Lev_AuditUser ];

/// 原因  Lev_Reason
Property LevReason As %String [ SqlColumnNumber = 11, SqlFieldName = Lev_Reason ];

Storage NewStorage
{
<SqlIdExpression>$i(^DHCDISLEAVE)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="Create_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Create_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Lev_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Lev_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Lev_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Lev_Content">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Lev_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Lev_Reason">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Lev_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Lev_User">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DISLEAVE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Lev_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Lev_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DateINdex">
<Global>^DISLEAVE</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Create_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Lev_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisLeaveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
