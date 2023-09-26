Class User.DHCStkCatGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SCG_Rowid, SqlTableName = DHC_StkCatGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCSTScgBookCat As User.DHCSTScgBookCat [ Cardinality = children, Inverse = SCGBCSCGParref ];

Relationship ChildDHCStkCatGrpRelations As User.DHCStkCatGrpRelations [ Cardinality = children, Inverse = SCGRSCGParref ];

Relationship ChildDHCStkCatSubGrp As User.DHCStkCatSubGrp [ Cardinality = children, Inverse = SCSGSCGParRef ];

/// SCG_Code
Property SCGCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SCG_Code ];

/// SCG_Desc
Property SCGDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SCG_Desc ];

/// SCG_Type
Property SCGType As %Library.String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 4, SqlFieldName = SCG_Type ];

/// SCG_CATGRP_DR
Property SCGCATGRPDR As User.DHCStkCatGroup [ SqlColumnNumber = 5, SqlFieldName = SCG_CATGRP_DR ];

/// SCG_Set 2015-05-19 类组集合(M:医用材料,后勤材料,试剂,固定资产,;G:西药,中成药,草药)
Property SCGSet As %Library.String(DISPLAYLIST = ",MMedical,MOffice,MReagent,MFixedAssets,GXY,GZY,GCY", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",MM,MO,MR,MF,GX,GZ,GC") [ SqlColumnNumber = 6, SqlFieldName = SCG_Set ];

/// SCG_SpReq  维护是否需要维护售价
Property SCGSpReq As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = SCG_SpReq ];

/// SCG_StruModeFlag  结构模式
Property SCGStruModeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = SCG_StruModeFlag ];

// Index SCGCodeUnqIdx1 On SCGCode [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSCG)</SqlIdExpression>
<SQLMap name="DataMasterDHCSCG">
<Data name="SCG_CATGRP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SCG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SCG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SCG_Set">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SCG_SpReq">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SCG_StruModeFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SCG_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSCG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SCG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SCG_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexParent">
<Global>^DHCSCG</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Parent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SCG_CATGRP_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SCG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCSCG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SCG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SCG_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SCG_Desc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SCG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkCatGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSCG)
	s oldI = +$g(^mdata("DHCSTKCATGROUP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSCG = maxI
	s ^mdata("DHCSTKCATGROUP") = maxI
}

}
