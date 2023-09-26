/// 病人信息更新日志子表
Class User.DHCUPPERSONDETAIL Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCUPPERSONDETAIL, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On UPDChildsub [ IdKey, PrimaryKey, Unique ];

Relationship UPDParRef As User.DHCUPPERSON [ Cardinality = parent, Inverse = ChildDHCUPPERSONDETAIL, Required, SqlFieldName = UPD_ParRef ];

Property UPDChildsub As %Float [ InitialExpression = {$i(^User.DHCUPPERSOND($p(%d(0),$c(1)),"D",0))}, SqlColumnNumber = 2, SqlFieldName = UPD_Childsub ];

Property UPDClassName As %String [ SqlColumnNumber = 3, SqlFieldName = UPD_ClassName ];

Property UPDClassProperty As %String [ SqlColumnNumber = 4, SqlFieldName = UPD_ClassProperty ];

Property UPDOldValue As %String [ SqlColumnNumber = 5, SqlFieldName = UPD_OldValue ];

Property UPDNewValue As %String [ SqlColumnNumber = 6, SqlFieldName = UPD_NewValue ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMap">
<Data name="UPD_ClassName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UPD_ClassProperty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UPD_NewValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UPD_OldValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^User.DHCUPPERSOND</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCUPPERSON.UP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>UPD_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCUPPERSON.UP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPD_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>UPD_RowId</SqlRowIdName>
<StreamLocation>^User.DHCUPPERSONS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
