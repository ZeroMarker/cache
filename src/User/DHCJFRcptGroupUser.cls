Class User.DHCJFRcptGroupUser Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = grpuser_rowid, SqlTableName = DHC_JFRcptGroupUser, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On grpuserchildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_JFRcptGroupSet Parent Reference
Relationship grpuserparref As User.DHCJFRcptGroupSet [ Cardinality = parent, Inverse = ChildDHCJFRcptGroupUser, Required, SqlFieldName = grpuser_parref ];

/// grpuser_childsub
Property grpuserchildsub As %Float [ InitialExpression = {$i(^DHCJFRcptGroupSet($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"Sub",0))}, SqlColumnNumber = 2, SqlFieldName = grpuser_childsub ];

/// grpuser_ssgrp_dr
Property grpuserssgrpdr As User.SSGroup [ SqlColumnNumber = 3, SqlFieldName = grpuser_ssgrp_dr ];

/// grpuser_ssusr_dr
Property grpuserssusrdr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = grpuser_ssusr_dr ];

/// grpuser_hosp_dr
Property grpuserhospdr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = grpuser_hosp_dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="dataMaster">
<Data name="grpuser_childsub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="grpuser_hosp_dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="grpuser_parref">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="grpuser_ssgrp_dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="grpuser_ssusr_dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCJFRcptGroupSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_JFRcptGroupSet.grp_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>grpuser_childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_JFRcptGroupSet.grp_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Sub"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{grpuser_childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCJFRcptGroupUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
