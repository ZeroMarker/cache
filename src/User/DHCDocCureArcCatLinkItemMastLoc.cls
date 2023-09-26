/// 治疗分类-医嘱项-治疗科室
Class User.DHCDocCureArcCatLinkItemMastLoc Extends %Persistent [ SqlRowIdName = DCACLIMLOC_RowID, SqlTableName = DHC_DocCureArcCatLinkItemMast_Loc, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DCACLIMLOCChildSub [ IdKey, PrimaryKey, Unique ];

Relationship DCACLIMLOCParRef As User.DHCDocCureArcCatLinkItemMast [ Cardinality = parent, Inverse = ChildDHCDocCureArcCatLinkItemMastLoc, Required, SqlFieldName = DCACLIMLOC_ParRef ];

/// DCACLIC_ChildSub
Property DCACLIMLOCChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCureArcCat(+$s($d(initvalue):initvalue,1:%d(0)),"LIM",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"L",0))}, SqlColumnNumber = 2, SqlFieldName = DCACLIMLOC_ChildSub ];

/// DCACLICLOC_Dept_Dr
Property DCACLIMLOCDeptDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DCACLIMLOC_Dept_Dr ];

/// DCACLIM_CfgType 权限类型
Property DCACLIMCfgType As %String(DISPLAYLIST = ",Loc,User,CareProv", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",L,U,CP") [ SqlColumnNumber = 4, SqlFieldName = DCACLIM_CfgType ];

/// DCACLIM_CfgValue 权限值
Property DCACLIMCfgValue As %String [ SqlColumnNumber = 5, SqlFieldName = DCACLIM_CfgValue ];

Storage SQLStorage
{
<SQLMap name="DataMap">
<Data name="DCACLIMLOC_Dept_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCACLIM_CfgType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCACLIM_CfgValue">
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
<Field>DHC_DocCureArcCatLinkItemMast.DCACLIM_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DCACLIMLOC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureArcCat.DCAC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LIM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocCureArcCatLinkItemMast.DCACLIM_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"L"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCACLIMLOC_ChildSub}</Expression>
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
<Field>DHC_DocCureArcCatLinkItemMast.DCACLIM_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>DCACLIMLOC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LIMCFG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocCureArcCat.DCAC_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureArcCatLinkItemMast.DCACLIM_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCACLIM_CfgType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DCACLIM_CfgValue}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DCACLIMLOC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDept">
<Condition>{DCACLIMLOC_Dept_Dr}'=""</Condition>
<ConditionFields>DCACLIMLOC_Dept_Dr</ConditionFields>
<Global>^DHCDocCureArcCat</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_DocCureArcCat.DCAC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_DocCureArcCatLinkItemMast.DCACLIM_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>DCACLIMLOC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LIMMASTLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocCureArcCat.DCAC_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureArcCatLinkItemMast.DCACLIM_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCACLIMLOC_Dept_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DCACLIMLOC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCACLIMLOC_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocCureA87C2S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
