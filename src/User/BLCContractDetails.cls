/// BLC Contract Details(1489)
Class User.BLCContractDetails Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_ContractDetails, StorageStrategy = SQLStorage ]
{

/// Department Based
Property CONTRDepartmentBased As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = CONTR_DepartmentBased ];

/// CONTR_Desc
Property CONTRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CONTR_Desc ];

/// Episode Based
Property CONTREpisodeBased As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = CONTR_EpisodeBased ];

/// Inclusive/Exclusive
Property CONTRInclExcl As %String(DISPLAYLIST = ",Inclusive,Exclusive", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",I,E") [ SqlColumnNumber = 3, SqlFieldName = CONTR_InclExcl ];

/// Selection Method
Property CONTRSelectionMethod As %String(DISPLAYLIST = ",Billing Group,Government Classification,Order Category", MAXLEN = 25, TRUNCATE = 1, VALUELIST = ",B,G,C") [ SqlColumnNumber = 6, SqlFieldName = CONTR_SelectionMethod ];

Relationship ChildBLCContractDetailsDate As BLCContractDetailsDate [ Cardinality = children, Inverse = DATEParRef ];

Parameter EXTENTSIZE = 40;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCContractDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetails","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCContractDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetails","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCContractDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetails","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCContractDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetails","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCContractDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetails","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>40</ExtentSize>
<Property name="CONTRDepartmentBased">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CONTRDesc">
<Selectivity>2.5641%</Selectivity>
</Property>
<Property name="CONTREpisodeBased">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CONTRInclExcl">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CONTRSelectionMethod">
<Selectivity>25.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^BLC("CONTR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CONTR_DepartmentBased">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CONTR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CONTR_EpisodeBased">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CONTR_InclExcl">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CONTR_SelectionMethod">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CONTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CONTR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CONTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CONTR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CONTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CONTR_RowId</SqlRowIdName>
<StreamLocation>^User.BLCContractDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
