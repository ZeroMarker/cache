/// ResponsibleUnitCP(2344)
Class User.CTResponsibleUnitCP Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_ResponsibleUnitCP, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CPChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_ResponsibleUnit Parent Reference
Relationship CPParRef As CTResponsibleUnit [ Cardinality = parent, Inverse = ChildCTResponsibleUnitCP, Required, SqlFieldName = CP_ParRef ];

/// Childsub
Property CPChildsub As %Float [ InitialExpression = {$i(^CT("RU",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CP",0))}, SqlColumnNumber = 2, SqlFieldName = CP_Childsub ];

/// Des Ref CareProv
Property CPCareProvDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = CP_CareProv_DR ];

/// Hospital DR
Property CPHospitalDR As CTHospital [ SqlColumnNumber = 4, SqlFieldName = CP_HospitalDR ];

/// Date From
Property CPDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = CP_DateFrom ];

/// DateTo
Property CPDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = CP_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTResponsibleUnitCP).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTResponsibleUnitCP","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTResponsibleUnitCP).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTResponsibleUnitCP","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTResponsibleUnitCP).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTResponsibleUnitCP","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTResponsibleUnitCP).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTResponsibleUnitCP","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTResponsibleUnitCP).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTResponsibleUnitCP","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CP_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CP_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_ResponsibleUnit.RU_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_ResponsibleUnit.RU_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCP">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_ResponsibleUnit.RU_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>CP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_ResponsibleUnit.RU_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Doc"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CP_CareProv_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CP_RowId</SqlRowIdName>
<StreamLocation>^User.CTResponsibleUnitCPS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
