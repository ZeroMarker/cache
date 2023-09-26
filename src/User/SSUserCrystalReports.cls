/// SS User Crystal Reports(1496)
Class User.SSUserCrystalReports Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserCrystalReports, StorageStrategy = SQLStorage ]
{

/// Childsub
Property CRYSTChildsub As %Float [ InitialExpression = {$i(^SSU("SSUSR",$p(%d(0),$c(1)),"CRYST",0))}, SqlColumnNumber = 2, SqlFieldName = CRYST_Childsub ];

/// Crystal Report Name
Property CRYSTCrystalReportName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CRYST_CrystalReportName ];

/// ActiveX Object Reference
Property CRYSTObjectReference As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CRYST_ObjectReference ];

/// SS_User Parent Reference
Relationship CRYSTParRef As SSUser [ Cardinality = parent, Inverse = ChildSSUserCrystalReports, Required, SqlFieldName = CRYST_ParRef ];

/// Print Preview
Property CRYSTPrintPreview As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = CRYST_PrintPreview ];

/// Prompt For Parameters
Property CRYSTPromptForParameters As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = CRYST_PromptForParameters ];

/// Des Ref Report
Property CRYSTReportDR As CTReport [ SqlColumnNumber = 3, SqlFieldName = CRYST_Report_DR ];

Index RowIDBasedIDKeyIndex On CRYSTChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserCrystalReports).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserCrystalReports","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserCrystalReports).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserCrystalReports","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserCrystalReports).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserCrystalReports","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserCrystalReports).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserCrystalReports","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserCrystalReports).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserCrystalReports","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CRYST_CrystalReportName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CRYST_ObjectReference">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CRYST_PrintPreview">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CRYST_PromptForParameters">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CRYST_Report_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CRYST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CRYST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CRYST_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CRYST_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserCrystalReportsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
