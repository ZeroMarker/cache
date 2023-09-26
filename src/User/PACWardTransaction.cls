/// WardTransaction(2125)
Class User.PACWardTransaction Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WardTransaction, StorageStrategy = SQLStorage ]
{

/// BM Comments
Property TRANSBMComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = TRANS_BMComments, SqlListType = SUBNODE ];

/// Childsub
Property TRANSChildsub As %Float [ InitialExpression = {$i(^PAWARDA($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"TRANS",0))}, SqlColumnNumber = 2, SqlFieldName = TRANS_Childsub ];

/// Comments
Property TRANSComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = TRANS_Comments, SqlListType = SUBNODE ];

/// Date From
Property TRANSDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = TRANS_DateFrom ];

/// Date To
Property TRANSDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = TRANS_DateTo ];

/// PAC_Ward Parent Reference
Relationship TRANSParRef As PACWard [ Cardinality = parent, Inverse = ChildPACWardTransaction, Required, SqlFieldName = TRANS_ParRef ];

/// Update Date
Property TRANSUpdDate As %Date [ SqlColumnNumber = 6, SqlFieldName = TRANS_UpdDate ];

/// Update Time
Property TRANSUpdTime As %Time [ SqlColumnNumber = 7, SqlFieldName = TRANS_UpdTime ];

/// Des Ref User
Property TRANSUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = TRANS_User_DR ];

/// Ward Staff Comments
Property TRANSWSComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = TRANS_WSComments, SqlListType = SUBNODE ];

Index RowIDBasedIDKeyIndex On TRANSChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 19;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWardTransaction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardTransaction","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWardTransaction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardTransaction","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWardTransaction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardTransaction","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWardTransaction).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardTransaction","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWardTransaction).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardTransaction","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>19</ExtentSize>
<Property name="TRANSBMComments">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSComments">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSUpdDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSUpdTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSWSComments">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="TRANS_BMComments">
<Node>"BM"</Node>
</Data>
<Data name="TRANS_Comments">
<Node>"REM"</Node>
</Data>
<Data name="TRANS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRANS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRANS_UpdDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRANS_UpdTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TRANS_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRANS_WSComments">
<Node>"WS"</Node>
</Data>
<Global>^PAWARDA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TRANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRANS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRANS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TRANS_RowId</SqlRowIdName>
<StreamLocation>^User.PACWardTransactionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
