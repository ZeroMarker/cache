/// 基础数据平台-临床知识库-诊断与HIS诊断对照
Class User.DHCExtIcdContrast Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = ICON_RowId, SqlTableName = DHC_ExtIcdContrast, StorageStrategy = SQLStorage ]
{

// ^DHCEXTICON

Property ICONCode As %String [ SqlColumnNumber = 2, SqlFieldName = ICON_Code ];

Property ICONHisCode As %String [ SqlColumnNumber = 3, SqlFieldName = ICON_HisCode ];

Property ICONHisDesc As %String [ SqlColumnNumber = 4, SqlFieldName = ICON_HisDesc ];

Property ICONType As %String(DISPLAYLIST = ",ICD9,ICD10,非ICD", VALUELIST = ",9,10,99") [ SqlColumnNumber = 5, SqlFieldName = ICON_Type ];

Property ICONHospDr As %String [ SqlColumnNumber = 6, SqlFieldName = ICON_Hosp_Dr ];

Property ICONActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ICON_ActiveFlag ];

Property ICONSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ICON_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEXTICON(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEXTICON</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICON_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICON_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICON_HisCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICON_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHisCode">
<Global>^DHCEXTICON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICON_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICON_HisCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICON_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ICON_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICON_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICON_HisCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICON_HisDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICON_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICON_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICON_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEXTICON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ICON_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ICON_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ICON_RowId</SqlRowIdName>
<StreamLocation>^User.DHCExtIcdContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
