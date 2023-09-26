Class User.DHCAdvBldAddInfo Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BLDAI_RowID, SqlTableName = DHC_AdvBldAddInfo, StorageStrategy = SQLStorage ]
{

//输血报告ID

Property BLDAIRepDr As User.DHCAdvBloodReport [ SqlColumnNumber = 2, SqlFieldName = BLDAI_Rep_Dr ];

//诊断原因及分析 

Property BLDAIDiagReson As %Library.String(MAXLEN = 500) [ SqlColumnNumber = 3, SqlFieldName = BLDAI_DiagReson ];

//输血科操作者

Property BLDAIOperateUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = BLDAI_OperateUserDr ];

//输血科操作日期 

Property BLDAIOperateDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = BLDAI_OperateDate ];

//输血科操作时间 

Property BLDAIOperateTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = BLDAI_OperateTime ];

//预防及改进措施 

Property BLDAIPrevImpTxt As %Library.String(MAXLEN = 500) [ SqlColumnNumber = 7, SqlFieldName = BLDAI_PrevImpTxt ];

//输血科审核者

Property BLDAIAuditUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = BLDAI_AuditUserDr ];

//输血科审核日期 

Property BLDAIAuditDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = BLDAI_AuditDate ];

//输血科审核时间 

Property BLDAIAuditTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = BLDAI_AuditTime ];

// 	失效日期

Property BLDAIInvalidDate As %Library.Date [ SqlColumnNumber = 11, SqlFieldName = BLDAI_InvalidDate ];

// 	失效时间 

Property BLDAIInvalidTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = BLDAI_InvalidTime ];

// 	处理后结果

Property BLDAIDisResult As %String [ SqlColumnNumber = 13, SqlFieldName = BLDAI_DisResult ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVBLDADDINFO)</SqlIdExpression>
<SQLMap name="BRepDr">
<Global>^DHCADVBLDADDINFO</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BLDAI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BRepDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BLDAI_Rep_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLDAI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="BLDAI_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BLDAI_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BLDAI_AuditUserDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BLDAI_DiagReson">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BLDAI_DisResult">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BLDAI_InvalidDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BLDAI_InvalidTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BLDAI_OperateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BLDAI_OperateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BLDAI_OperateUserDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BLDAI_PrevImpTxt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BLDAI_Rep_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCADVBLDADDINFO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BLDAI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BLDAI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvBldAddInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
