/// PHC FormDose Equivalent(1339)
Class User.PHCFormDoseEquiv Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_FormDoseEquiv, StorageStrategy = SQLStorage ]
{

/// Des Ref CTUOM
Property EQCTUOMDR As CTUOM [ SqlColumnNumber = 3, SqlFieldName = EQ_CTUOM_DR ];

/// Childsub
Property EQChildsub As %Float [ InitialExpression = {$i(^PHCD($p(%d(0),"||"),"DF",$p(%d(0),"||",2),"EQ",0))}, SqlColumnNumber = 2, SqlFieldName = EQ_Childsub ];

/// Default Dose
Property EQDefaultDose As %Float [ SqlColumnNumber = 5, SqlFieldName = EQ_DefaultDose ];

/// PHC_DrgForm Parent Reference
Relationship EQParRef As PHCDrgForm [ Cardinality = parent, Inverse = ChildPHCFormDoseEquiv, Required, SqlFieldName = EQ_ParRef ];

/// Quantity
Property EQQty As %Float [ SqlColumnNumber = 4, SqlFieldName = EQ_Qty ];

/// 默认等效单位,开医嘱用
Property EQDefaultFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = EQ_DefaultFlag ];

/// 等量计算用
Property EQCalcFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = EQ_CalcFlag ];

Index RowIDBasedIDKeyIndex On EQChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 13392;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCFormDoseEquiv).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCFormDoseEquiv","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCFormDoseEquiv).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCFormDoseEquiv","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCFormDoseEquiv).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCFormDoseEquiv","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCFormDoseEquiv).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCFormDoseEquiv","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCFormDoseEquiv).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCFormDoseEquiv","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>13392</ExtentSize>
<Property name="EQCTUOMDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="EQChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="EQDefaultDose">
<Selectivity>1</Selectivity>
</Property>
<Property name="EQParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="EQQty">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="EQ_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EQ_CalcFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EQ_DefaultDose">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EQ_DefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EQ_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PHCD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHC_DrgForm.PHCDF_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>EQ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHC_DrgForm.PHCDF_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EQ_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>EQ_RowId</SqlRowIdName>
<StreamLocation>^User.PHCFormDoseEquivS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
