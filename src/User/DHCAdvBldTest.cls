Class User.DHCAdvBldTest Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BLDT_RowID, SqlTableName = DHC_AdvBldTest, StorageStrategy = SQLStorage ]
{

//输血报告ID

Property BLDTRepDr As User.DHCAdvBloodReport [ SqlColumnNumber = 2, SqlFieldName = BLDT_Rep_Dr ];

//检验源 

Property BLDTTestSource As %Library.String [ SqlColumnNumber = 3, SqlFieldName = BLDT_TestSource ];

//血型

Property BLDTBldGroup As %Library.String [ SqlColumnNumber = 4, SqlFieldName = BLDT_BldGroup ];

//Rh血型

Property BLDTRhGroup As %Library.String [ SqlColumnNumber = 5, SqlFieldName = BLDT_RhGroup ];

//抗体筛查

Property BLDTAntyScreening As %Library.String [ SqlColumnNumber = 6, SqlFieldName = BLDT_AntyScreening ];

//直抗

Property BLDTDirantTest As %Library.String [ SqlColumnNumber = 7, SqlFieldName = BLDT_DirantTest ];

//自抗

Property BLDTAutTest As %Library.String [ SqlColumnNumber = 8, SqlFieldName = BLDT_AutTest ];

//间抗

Property BLDResistence As %Library.String [ SqlColumnNumber = 9, SqlFieldName = BLD_Resistence ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVBLDTEST)</SqlIdExpression>
<SQLMap name="BRepDrIndex">
<Global>^DHCADVBLDTEST</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BLDT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BRepDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BLDT_Rep_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLDT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="BLDT_AntyScreening">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BLDT_AutTest">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BLDT_BldGroup">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BLDT_DirantTest">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BLDT_Rep_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BLDT_RhGroup">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BLDT_TestSource">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BLD_Resistence">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCADVBLDTEST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BLDT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BLDT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvBldTestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
