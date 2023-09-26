Class User.DHCEmWaitToHos Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EW_RowID, SqlTableName = DHC_EmWaitToHos, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCEMWAITTOHOSITM As User.DHCEmWaitToHosItm [ Cardinality = children, Inverse = EWParRefDr ];

/// 病人Adm   EW_Adm_Dr
Property EWAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = EW_Adm_Dr ];

/// 申请科室  EW_RLoc_Dr
Property EWRLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = EW_RLoc_Dr ];

/// 申请日期  EW_RDate
Property EWRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = EW_RDate ];

/// 申请时间  EW_RTime
Property EWRTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = EW_RTime ];

/// 申请医生  EW_RUser_Dr
Property EWRUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = EW_RUser_Dr ];

/// 登记状态  EW_Enabled
Property EWEnabled As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = EW_Enabled ];

/// 删除理由  EW_DelReason
Property EWDelReason As %Library.String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EW_DelReason ];

/// 呼吸类型  EW_ResType 有创/无创/鼻导管/无
Property EWResType As %Library.String [ SqlColumnNumber = 9, SqlFieldName = EW_ResType ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMWH)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EW_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EW_DelReason">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EW_Enabled">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EW_RDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EW_RLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EW_RTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EW_RUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EW_ResType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEMWH</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EW_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCEMWH</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EW_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCEMWH</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EW_RDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmWaitToHosS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
