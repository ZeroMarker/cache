Class User.DHCAdvBldInspect Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BLDI_RowID, SqlTableName = DHC_AdvBldInspect, StorageStrategy = SQLStorage ]
{

//输血报告ID

Property BLDIRepDr As User.DHCAdvBloodReport [ SqlColumnNumber = 2, SqlFieldName = BLDI_Rep_Dr ];

//代码 

Property BLDICode As %Library.String [ SqlColumnNumber = 3, SqlFieldName = BLDI_Code ];

//描述

Property BLDIDesc As %Library.String [ SqlColumnNumber = 4, SqlFieldName = BLDI_Desc ];

//检查结果

Property BLDIResult As %Library.String [ SqlColumnNumber = 5, SqlFieldName = BLDI_Result ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVBLDINSPECT)</SqlIdExpression>
<SQLMap name="BRepDrIndex">
<Global>^DHCADVBLDINSPECT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BLDI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BRepDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BLDI_Rep_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLDI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="BLDI_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BLDI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BLDI_Rep_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BLDI_Result">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCADVBLDINSPECT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BLDI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BLDI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvBldInspectS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
