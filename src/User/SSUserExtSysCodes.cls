/// UserExtSysCodes(2501)
Class User.SSUserExtSysCodes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserExtSysCodes, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EXTChildsub [ IdKey, PrimaryKey, Unique ];

/// SS_User Parent Reference
Relationship EXTParRef As SSUser [ Cardinality = parent, Inverse = ChildSSUserExtSysCodes, Required, SqlFieldName = EXT_ParRef ];

/// Childsub
Property EXTChildsub As %Float [ InitialExpression = {$i(^SSU("SSUSR",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"EXT",0))}, SqlColumnNumber = 2, SqlFieldName = EXT_Childsub ];

/// Code
Property EXTCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EXT_Code ];

/// Des Ref CTLOC
Property EXTCTLOCDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = EXT_CTLOC_DR ];

/// Interface
Property EXTInterface As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = EXT_Interface ];

/// DefaultSend
Property EXTDefaultSend As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = EXT_DefaultSend ];

/// Date From
Property EXTDateFrom As %Date [ SqlColumnNumber = 7, SqlFieldName = EXT_DateFrom ];

/// DateTo
Property EXTDateTo As %Date [ SqlColumnNumber = 8, SqlFieldName = EXT_DateTo ];

/// Des Ref to CT_Hospital
Property EXTHospitalDR As CTHospital [ SqlColumnNumber = 9, SqlFieldName = EXT_Hospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserExtSysCodes).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserExtSysCodes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserExtSysCodes).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserExtSysCodes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserExtSysCodes).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserExtSysCodes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserExtSysCodes).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserExtSysCodes","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserExtSysCodes).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserExtSysCodes","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="EXT_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EXT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EXT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EXT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EXT_DefaultSend">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EXT_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EXT_Interface">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>EXT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EXT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EXT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInterface">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>EXT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ExtInt"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EXT_Interface}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({EXT_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EXT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>EXT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ExtLoc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EXT_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({EXT_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EXT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EXT_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserExtSysCodesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
