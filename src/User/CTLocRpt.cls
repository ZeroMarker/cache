/// CT Location Report      (LOCRP,640)
Class User.CTLocRpt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_LocRpt, StorageStrategy = SQLStorage ]
{

/// LOCRP Parent Reference
Relationship LOCRPCTLOCParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocRpt, Required, SqlFieldName = LOCRP_CTLOC_ParRef ];

/// ChildSub
Property LOCRPChildSub As %Float [ InitialExpression = {$i(^CTLOC($p(%d(0),$c(1),1),"LOCRP",0))}, SqlColumnNumber = 4, SqlFieldName = LOCRP_ChildSub ];

/// Des Ref to CT_Device
Property LOCRPDEVDR As SSDevice [ SqlColumnNumber = 3, SqlFieldName = LOCRP_DEV_DR ];

/// Not Used Format
Property LOCRPFMTDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = LOCRP_FMT_DR ];

/// Not Used Des Ref to CT_LP
Property LOCRPLPDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = LOCRP_LP_DR ];

/// Not Used Des Ref to CT_LPFormat
Property LOCRPLPFMTDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = LOCRP_LPFMT_DR ];

/// Des Ref to CTRP(CT_Modules)
Property LOCRPRPDR As CTModules [ Required, SqlColumnNumber = 2, SqlFieldName = LOCRP_RP_DR ];

Index RowIDBasedIDKeyIndex On LOCRPChildSub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocRpt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocRpt","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocRpt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocRpt","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocRpt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocRpt","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocRpt).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocRpt","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocRpt).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocRpt","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="LOCRPCTLOCParRef">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LOCRPChildSub">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="LOCRPDEVDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LOCRPFMTDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LOCRPLPDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LOCRPLPFMTDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LOCRPRPDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="DataMasterLOCRP">
<Data name="LOCRP_DEV_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LOCRP_FMT_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LOCRP_LPFMT_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LOCRP_LP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LOCRP_RP_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LOCRP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOCRP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{LOCRP_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LOCRP_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocRptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
