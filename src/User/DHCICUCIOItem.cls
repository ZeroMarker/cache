/// DHC_ICUC_IOItem
Class User.DHCICUCIOItem Extends %Persistent [ ClassType = persistent, OdbcType = INTEGER, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = ICUCIOI_RowId, SqlTableName = DHC_ICUC_IOItem, StorageStrategy = CacheSQLStorage ]
{

Property ICUCIOICode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ICUCIOI_Code ];

Property ICUCIOIDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ICUCIOI_Desc ];

Property ICUCIOIType As %String(DISPLAYLIST = ",Input,Output,Summary", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,O,S") [ SqlColumnNumber = 4, SqlFieldName = ICUCIOI_Type ];

Property ICUCIOIComOrdDr As User.DHCICUCRecordItem [ SqlColumnNumber = 5, SqlFieldName = ICUCIOI_ComOrd_Dr ];

Property ICUCIOIViewCatDr As User.DHCICUCViewCat [ SqlColumnNumber = 6, SqlFieldName = ICUCIOI_ViewCat_Dr ];

Property ICUCIOIInstructDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ICUCIOI_Instruct_Dr ];

Property ICUCIOIActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ICUCIOI_Active ];

Property ICUCIOICtlocDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ICUCIOI_Ctloc_Dr ];

Property ICUCIOIMainICUCIOIDr As User.DHCICUCIOItem [ SqlColumnNumber = 10, SqlFieldName = ICUCIOI_MainICUCIOI_Dr ];

Property ICUCIOIStrategy As %String(MAXLEN = 30) [ SqlColumnNumber = 11, SqlFieldName = ICUCIOI_Strategy ];

Property ICUCIOIMultiple As %Float [ SqlColumnNumber = 12, SqlFieldName = ICUCIOI_Multiple ];

Property ICUCIOIValueField As %String [ SqlColumnNumber = 13, SqlFieldName = ICUCIOI_ValueField ];

Storage CacheSQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCICUC("IOItem",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICUCIOI_Active">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICUCIOI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUCIOI_ComOrd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUCIOI_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ICUCIOI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUCIOI_Instruct_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUCIOI_MainICUCIOI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ICUCIOI_Multiple">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ICUCIOI_Strategy">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ICUCIOI_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUCIOI_ValueField">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ICUCIOI_ViewCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCICUC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ICUCIOI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"IOItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ICUCIOI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCtloc">
<Global>^DHCICUC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICUCIOI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"IOItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Ctloc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUCIOI_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUCIOI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCICUCIOItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
