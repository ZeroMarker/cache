/// 治疗分类-子类-治疗科室
Class User.DHCDocCureArcCatLinkItemCatLoc Extends %Persistent [ SqlRowIdName = DCACLICLOC_RowID, SqlTableName = DHC_DocCureArcCatLinkItemCat_Loc, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DCACLICLOCChildSub [ IdKey, PrimaryKey, Unique ];

Relationship DCACLICLOCParRef As User.DHCDocCureArcCatLinkItemCat [ Cardinality = parent, Inverse = ChildDHCDocCureArcCatLinkItemCatLoc, Required, SqlFieldName = DCACLICLOC_ParRef ];

/// DCACLIC_ChildSub
Property DCACLICLOCChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCureArcCat(+$s($d(initvalue):initvalue,1:%d(0)),"LIC",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"L",0))}, SqlColumnNumber = 2, SqlFieldName = DCACLICLOC_ChildSub ];

/// DCACLICLOC_Dept_Dr
Property DCACLICLOCDeptDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DCACLICLOC_Dept_Dr ];

/// DCACLIC_CfgType 权限类型
Property DCACLICCfgType As %String(DISPLAYLIST = ",Loc,User,CareProv", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",L,U,CP") [ SqlColumnNumber = 4, SqlFieldName = DCACLIC_CfgType ];

/// DCACLIC_CfgValue 权限值
Property DCACLICCfgValue As %String [ SqlColumnNumber = 5, SqlFieldName = DCACLIC_CfgValue ];

Storage SQLStorage
{
<SQLMap name="DataMap">
<Data name="DCACLICLOC_Dept_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCACLIC_CfgType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCACLIC_CfgValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCureArcCat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureArcCat.DCAC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_DocCureArcCatLinkItemCat.DCACLIC_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DCACLICLOC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureArcCat.DCAC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocCureArcCatLinkItemCat.DCACLIC_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"L"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCACLICLOC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCFG">
<Global>^DHCDocCureArcCat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_DocCureArcCat.DCAC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_DocCureArcCatLinkItemCat.DCACLIC_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>DCACLICLOC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LICCFG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocCureArcCat.DCAC_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureArcCatLinkItemCat.DCACLIC_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCACLIC_CfgType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DCACLIC_CfgValue}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DCACLICLOC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDept">
<Condition>{DCACLICLOC_Dept_Dr}'=""</Condition>
<ConditionFields>DCACLICLOC_Dept_Dr</ConditionFields>
<Global>^DHCDocCureArcCat</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_DocCureArcCat.DCAC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_DocCureArcCatLinkItemCat.DCACLIC_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>DCACLICLOC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LICCATLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocCureArcCat.DCAC_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureArcCatLinkItemCat.DCACLIC_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCACLICLOC_Dept_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DCACLICLOC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCACLICLOC_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocCureArcCatLinkItemCatLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
