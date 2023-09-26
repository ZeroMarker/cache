/// DHC_ICUC_ShiftItem
Class User.DHCICUCShiftItem Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ICUCSI_RowId, SqlTableName = DHC_ICUC_ShiftItem, StorageStrategy = CacheSQLStorage ]
{

Property ICUCSICode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = ICUCSI_Code ];

Property ICUCSIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ICUCSI_Desc ];

Property ICUCSIType As %String [ SqlColumnNumber = 4, SqlFieldName = ICUCSI_Type ];

Property ICUCSIComOrdDr As %String [ SqlColumnNumber = 5, SqlFieldName = ICUCSI_ComOrd_Dr ];

Property ICUCSIViewCatDr As User.DHCICUCViewCat [ SqlColumnNumber = 6, SqlFieldName = ICUCSI_ViewCat_Dr ];

Property ICUCSIActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ICUCSI_Active ];

Property ICUCSICtlocDr As %String [ SqlColumnNumber = 8, SqlFieldName = ICUCSI_Ctloc_Dr ];

Property ICUCSIAttrib As %String [ SqlColumnNumber = 9, SqlFieldName = ICUCSI_Attrib ];

Property ICUCSIConncatStr As %String [ SqlColumnNumber = 10, SqlFieldName = ICUCSI_ConncatStr ];

Storage CacheSQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCICUC("SItem",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICUCSI_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUCSI_Attrib">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ICUCSI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUCSI_ComOrd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUCSI_ConncatStr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ICUCSI_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICUCSI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUCSI_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUCSI_ViewCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCICUC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ICUCSI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ICUCSI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCICUCShiftItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
