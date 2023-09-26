/// INC Item Manuf Ingred(1086)
Class User.INCItmRecIngr Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = INC_ItmRecIngr, StorageStrategy = SQLStorage ]
{

/// Childsub
Property INRINChildsub As %Float [ InitialExpression = {$i(^INCI($p(%d(0),"||"),"REC",$p(%d(0),"||",2),"ING",0))}, SqlColumnNumber = 2, SqlFieldName = INRIN_Childsub ];

/// Date Updated
Property INRINDateUpdated As %Date [ SqlColumnNumber = 6, SqlFieldName = INRIN_Date_Updated ];

/// Des Ref to INCI
Property INRININCIDR As INCItm [ Required, SqlColumnNumber = 3, SqlFieldName = INRIN_INCI_DR ];

/// INC_ItmRcp Parent Reference
Relationship INRINParRef As INCItmRcp [ Cardinality = parent, Inverse = ChildINCItmRecIngr, Required, SqlFieldName = INRIN_ParRef ];

/// Qty Required
Property INRINQty As %Float(MINVAL = .001) [ Required, SqlColumnNumber = 9, SqlFieldName = INRIN_Qty ];

/// Remarks
Property INRINRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 8, SqlFieldName = INRIN_Remarks, SqlListType = SUBNODE ];

/// Time Updated
Property INRINTimeUpdated As %Time [ SqlColumnNumber = 7, SqlFieldName = INRIN_Time_Updated ];

/// Des Ref to CTUOM
Property INRINUOMDR As CTUOM [ Required, SqlColumnNumber = 4, SqlFieldName = INRIN_UOM_DR ];

/// User Updated Des Ref to SSU
Property INRINUserUpdatedDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = INRIN_User_Updated_DR ];

Index RowIDBasedIDKeyIndex On INRINChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 5;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INCItmRecIngr).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmRecIngr","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INCItmRecIngr).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmRecIngr","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INCItmRecIngr).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmRecIngr","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INCItmRecIngr).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmRecIngr","OnBeforeInsert")
 
 d VALDEL^at1086
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
	d VALINS^at1086
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INCItmRecIngr).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmRecIngr","OnBeforeUpdate")
 
 d VALUPD^at1086
}

Storage SQLStorage
{
<ExtentSize>5</ExtentSize>
<Property name="INRINChildsub">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INRINDateUpdated">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INRININCIDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="INRINParRef">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INRINQty">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INRINRemarks">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INRINTimeUpdated">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="INRINUOMDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INRINUserUpdatedDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="INRIN_Date_Updated">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INRIN_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INRIN_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INRIN_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INRIN_Time_Updated">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INRIN_UOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INRIN_User_Updated_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^INCI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INC_ItmRcp.INREC_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>INRIN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INC_ItmRcp.INREC_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ING"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INRIN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INRIN_RowId</SqlRowIdName>
<StreamLocation>^User.INCItmRecIngrS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
