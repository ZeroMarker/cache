/// DepartmentGroupHead(2584)
Class User.RBCDepartmentGroupHead Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_DepartmentGroupHead, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CPChildsub [ IdKey, PrimaryKey, Unique ];

/// RBC_DepartmentGroup Parent Reference
Relationship CPParRef As RBCDepartmentGroup [ Cardinality = parent, Inverse = ChildRBCDepartmentGroupHead, Required, SqlFieldName = CP_ParRef ];

/// Childsub
Property CPChildsub As %Float [ InitialExpression = {$i(^RBC("DEP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CP",0))}, SqlColumnNumber = 2, SqlFieldName = CP_Childsub ];

/// Des Ref Hospital
Property CPHospitalDR As CTHospital [ SqlColumnNumber = 3, SqlFieldName = CP_Hospital_DR ];

/// Des REf CareProv
Property CPCareProvDR As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = CP_CareProv_DR ];

/// Date From
Property CPDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = CP_DateFrom ];

/// Date To
Property CPDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = CP_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBCDepartmentGroupHead).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCDepartmentGroupHead","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBCDepartmentGroupHead).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCDepartmentGroupHead","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBCDepartmentGroupHead).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCDepartmentGroupHead","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBCDepartmentGroupHead).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCDepartmentGroupHead","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBCDepartmentGroupHead).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCDepartmentGroupHead","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="CP_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CP_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RBC_DepartmentGroup.DEP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBC_DepartmentGroup.DEP_RowId}</Expression>
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
<SqlRowIdName>CP_RowId</SqlRowIdName>
<StreamLocation>^User.RBCDepartmentGroupHeadS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
