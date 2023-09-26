Class User.DHCDocCureLocExpand Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = DDCLE_RowID, SqlTableName = DHC_DocCureLocExpand, StorageStrategy = SQLStorage ]
{

Property DDCLELocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DDCLE_LocDr ];

/// 启用报到
Property DDCLEReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = DDCLE_ReportFlag ];

/// 启用分诊
Property DDCLETriageFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DDCLE_TriageFlag ];

/// 治疗执行启用双签
Property DDCLEReconfirmFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DDCLE_ReconfirmFlag ];

/// 预约允许直接执行
Property DDCLEAppointAllowExecFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DDCLE_AppointAllowExecFlag ];

/// 按单次数量预约
Property DDCLEAppDoseQtyFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DDCLE_AppDoseQtyFlag ];

/// 不允许预约非本人的实名预约排程
Property DDCLEAppHiddenOtherUserFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = DDCLE_AppHiddenOtherUserFlag ];

/// 仅显示预约到本人的记录
Property DDCLECureWorkQrySelfFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = DDCLE_CureWorkQrySelfFlag ];

/// 关联的评估模板
Property DDCLERelateAssTemp As %String(MAXLEN = 9999) [ SqlColumnNumber = 10, SqlFieldName = DDCLE_RelateAssTemp ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDocCureLE(0))</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="DDCLE_AppDoseQtyFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DDCLE_AppHiddenOtherUserFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DDCLE_AppointAllowExecFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDCLE_CureWorkQrySelfFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DDCLE_LocDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCLE_ReconfirmFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDCLE_RelateAssTemp">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DDCLE_ReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDCLE_TriageFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCureLE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DDCLE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DDCLE_RowID}</Expression>
<StartValue>0</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="LocIndex">
<Global>^DHCDocCureLEi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DDCLE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCLE_LocDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCLE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DDCLE_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocCureLocExpandS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
