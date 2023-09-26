/// OrdRefDoctor(2511)
Class User.OEOrdRefDoctor Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdRefDoctor, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On REFDChildsub [ IdKey, PrimaryKey, Unique ];

/// OE_OrdItem Parent Reference
Relationship REFDParRef As OEOrdItem [ Cardinality = parent, Inverse = ChildOEOrdRefDoctor, Required, SqlFieldName = REFD_ParRef ];

/// Childsub
Property REFDChildsub As %Float [ InitialExpression = {$i(^OEORD($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"I",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"REFD",0))}, SqlColumnNumber = 2, SqlFieldName = REFD_Childsub ];

/// Des Ref RefDoc
Property REFDRefDocDR As PACRefDoctor [ SqlColumnNumber = 3, SqlFieldName = REFD_RefDoc_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdRefDoctor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdRefDoctor","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdRefDoctor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdRefDoctor","OnAfterInsert")
}

/// The <var>EXTENTSIZE</var> parameter is used to inform the <i>Cach&eacute; SQL Query Optimizer</i> 
/// of the approximate number of instances in the extent containing instances of this class.
/// 
/// <p>For example, a class that expects to have about 1,000,000 instances should define:
/// <EXAMPLE LANGUAGE=NONE>
/// parameter EXTENTSIZE &#123 default = 1000000; &#125
/// </EXAMPLE>
Parameter EXTENTSIZE As INTEGER = 1000000;

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdRefDoctor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdRefDoctor","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdRefDoctor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdRefDoctor","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdRefDoctor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdRefDoctor","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="REFD_RefDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>REFD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REFD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>REFD_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdRefDoctorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
