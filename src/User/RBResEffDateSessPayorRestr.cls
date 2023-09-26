/// RB Res Eff Date Sess Payor(1938)
Class User.RBResEffDateSessPayorRestr Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ResEffDateSessPayorRestr, StorageStrategy = SQLStorage ]
{

/// Childsub
Property RESTRChildsub As %Float [ InitialExpression = {$i(^RB("RES",$p(%d(0),"||"),"DATE",$p(%d(0),"||",2),"SESS",$p(%d(0),"||",3),"RESTR",0))}, SqlColumnNumber = 2, SqlFieldName = RESTR_Childsub ];

/// DateFrom
Property RESTRDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = RESTR_DateFrom ];

/// DateTo
Property RESTRDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = RESTR_DateTo ];

/// Des Ref InsType
Property RESTRInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 5, SqlFieldName = RESTR_InsType_DR ];

/// Des Ref NFMIDep
Property RESTRNFMIDepDR As CTNFMICategDepart [ SqlColumnNumber = 7, SqlFieldName = RESTR_NFMIDep_DR ];

/// RB_ResEffDateSession Parent Reference
Relationship RESTRParRef As RBResEffDateSession [ Cardinality = parent, Inverse = ChildRBResEffDateSessPayorRestr, Required, SqlFieldName = RESTR_ParRef ];

/// Des Ref RestrReason
Property RESTRRestrReasonDR As RBCReasonForRestriction [ SqlColumnNumber = 6, SqlFieldName = RESTR_RestrReason_DR ];

Index RowIDBasedIDKeyIndex On RESTRChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessPayorRestr).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResEffDateSessPayorRestr","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessPayorRestr).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResEffDateSessPayorRestr","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessPayorRestr).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResEffDateSessPayorRestr","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBResEffDateSessPayorRestr).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResEffDateSessPayorRestr","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBResEffDateSessPayorRestr).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResEffDateSessPayorRestr","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="RESTRChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="RESTRDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="RESTRDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="RESTRInsTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RESTRNFMIDepDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RESTRParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="RESTRRestrReasonDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="RESTR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RESTR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RESTR_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RESTR_NFMIDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RESTR_RestrReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>RESTR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"RESTR"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RESTR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPayor">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L12}</Expression>
<Field>RESTR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"RESTR"</Expression>
</Subscript>
<Subscript name="8">
<Expression>0</Expression>
</Subscript>
<Subscript name="9">
<Expression>"Ins"</Expression>
</Subscript>
<Subscript name="10">
<Expression>{RESTR_InsType_DR}</Expression>
</Subscript>
<Subscript name="11">
<Expression>{RESTR_DateFrom}</Expression>
</Subscript>
<Subscript name="12">
<Expression>{RESTR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResReason">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>RESTR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Restr"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RESTR_RestrReason_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RESTR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RESTR_RowId</SqlRowIdName>
<StreamLocation>^User.RBResEffDateSessPayorRestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
