Class User.DHCICUParaItemDetail Extends %Library.Persistent [ ProcedureBlock, SqlRowIdName = ICUPID_RowId, SqlTableName = DHC_ICU_ParaItemDetail, StorageStrategy = CacheSQLStorage ]
{

Relationship ICUPIDParref As User.DHCICUParaItem [ Cardinality = parent, Inverse = ChildDHCICUParaItemDetail, SqlFieldName = ICUPID_Parref ];

Index ICUPIDChildSubIndex On ICUPIDChildSub [ IdKey, PrimaryKey, Unique ];

/// For P5 ///Property ICUPIDChildSub As %Numeric [ InitialExpression = {$i(^DHCICUPara(+$s($d(p1):p1,1:%d(0)),"I",$p($p($s($d(p1):p1,1:%d(0)),$c(1)),"||",2),"D",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUPID_ChildSub ];
Property ICUPIDChildSub As %Numeric [ InitialExpression = {$i(^DHCICUPara(+$s($d(initvalue):initvalue,1:%d(0)),"I",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"D",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUPID_ChildSub ];

Property ICUPIDICUCPDr As User.DHCICUCProperty [ SqlColumnNumber = 3, SqlFieldName = ICUPID_ICUCP_Dr ];

Property ICUPIDValue As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = ICUPID_Value ];

Storage CacheSQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ICUPID_ICUCP_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUPID_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCICUPara</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ICU_Para.ICUP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_ICU_ParaItem.ICUPI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ICUPID_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_ICU_Para.ICUP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_ICU_ParaItem.ICUPI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"D"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUPID_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ICUPID_RowId</SqlRowIdName>
<StreamLocation>^User.DHCICUParaItemDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
