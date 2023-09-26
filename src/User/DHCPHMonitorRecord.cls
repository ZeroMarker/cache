Class User.DHCPHMonitorRecord Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMR_Rowid, SqlTableName = DHC_PHMonitorRecord, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCPHMonitorRecItm As User.DHCPHMonitorRecItm [ Cardinality = children, Inverse = PHMRIParRefDr ];

Relationship ChildDHCPHMonitorRecLabel As User.DHCPHMonitorRecLabel [ Cardinality = children, Inverse = PHMRLParRefDr ];

/// PHMR_Adm 就诊id
Property PHMRAdm As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = PHMR_Adm ];

/// PHMR_Oeori_Dr 医嘱id
Property PHMROeoriDr As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = PHMR_Oeori_Dr ];

/// PHMR_CreateDate 监测日期
Property PHMRCreateDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = PHMR_CreateDate ];

/// PhMR_CreateTime 监测时间
Property PhMRCreateTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PhMR_CreateTime ];

/// PHMR_DocUser_Dr 就诊医生
Property PHMRDocUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PHMR_DocUser_Dr ];

/// PHMR_DocLoc_Dr 就诊科室
Property PHMRDocLocDr As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = PHMR_DocLoc_Dr ];

/// PHMR_DocGrp_Dr	安全组
Property PHMRDocGrpDr As User.SSGroup [ SqlColumnNumber = 8, SqlFieldName = PHMR_DocGrp_Dr ];

/// PHMR_Arc_Dr	医嘱项id
Property PHMRArcDr As User.ARCItmMast [ SqlColumnNumber = 9, SqlFieldName = PHMR_Arc_Dr ];

/// PHMR_Level	管理级别
Property PHMRLevel As %String [ SqlColumnNumber = 10, SqlFieldName = PHMR_Level ];

/// PHMR_Label_Dr	目录id(弃用 2017-8-1)
Property PHMRLabelDr As User.DHCPHInstLabel [ SqlColumnNumber = 11, SqlFieldName = PHMR_Label_Dr ];

/// PHMR_ErrFlag	错误标志(弃用 2017-8-1)
Property PHMRErrFlag As %String [ SqlColumnNumber = 12, SqlFieldName = PHMR_ErrFlag ];

/// PHMR_ErrMsg	错误原因(弃用 2017-8-1)
Property PHMRErrMsg As %String [ SqlColumnNumber = 13, SqlFieldName = PHMR_ErrMsg ];

/// PHMR_TrueMsg 正确提示(弃用 2017-8-1)
Property PHMRTrueMsg As %String [ SqlColumnNumber = 14, SqlFieldName = PHMR_TrueMsg ];

/// PHMR_LinkOeor_Dr 关联医嘱id(弃用 2017-8-1)
Property PHMRLinkOeorDr As User.OEOrdItem [ SqlColumnNumber = 15, SqlFieldName = PHMR_LinkOeor_Dr ];

/// PHMR_SeqNo 医嘱序号
Property PHMRSeqNo As %String [ SqlColumnNumber = 16, SqlFieldName = PHMR_SeqNo ];

/// PHMR_Para 入参
Property PHMRPara As %String [ SqlColumnNumber = 17, SqlFieldName = PHMR_Para ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHMREC)</SqlIdExpression>
<SQLMap name="Master">
<Data name="PHMR_Adm">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMR_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHMR_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMR_DocGrp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHMR_DocLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHMR_DocUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHMR_ErrFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHMR_ErrMsg">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHMR_Label_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHMR_Level">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHMR_LinkOeor_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHMR_Oeori_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMR_Para">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHMR_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHMR_TrueMsg">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PhMR_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHMREC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMR_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHMR_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexAdm">
<Global>^DHCPHMREC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHMR_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMR_Adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexCreate">
<Global>^DHCPHMREC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHMR_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMR_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOeori">
<Global>^DHCPHMREC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{PHMR_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Oeori"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMR_Oeori_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMonitorRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
