/// PA Adm Drug Approval(1782)
Class User.PAAdmDrugApproval Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmDrugApproval, StorageStrategy = SQLStorage ]
{

/// Approval Id
Property DRUGApprovalId As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DRUG_ApprovalId ];

/// Childsub
Property DRUGChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DRUG",0))}, SqlColumnNumber = 2, SqlFieldName = DRUG_Childsub ];

/// Date
Property DRUGDate As %Date [ SqlColumnNumber = 4, SqlFieldName = DRUG_Date ];

/// Des Ref PHCDF
Property DRUGPHCDFDR As PHCDrgForm [ SqlColumnNumber = 3, SqlFieldName = DRUG_PHCDF_DR ];

/// PA_Adm Parent Reference
Relationship DRUGParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmDrugApproval, Required, SqlFieldName = DRUG_ParRef ];

/// Qty
Property DRUGQty As %Float [ SqlColumnNumber = 6, SqlFieldName = DRUG_Qty ];

Index RowIDBasedIDKeyIndex On DRUGChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 19;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmDrugApproval).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDrugApproval","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmDrugApproval).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDrugApproval","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmDrugApproval).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDrugApproval","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmDrugApproval).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDrugApproval","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmDrugApproval).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDrugApproval","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>19</ExtentSize>
<Property name="DRUGApprovalId">
<Selectivity>1</Selectivity>
</Property>
<Property name="DRUGChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="DRUGDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="DRUGPHCDFDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="DRUGParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="DRUGQty">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DRUG_ApprovalId">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRUG_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRUG_PHCDF_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRUG_Qty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DRUG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DRUG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRUG_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DRUG_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmDrugApprovalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
