/// AppealType(2634)
Class User.PACAppealType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_AppealType, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On APPTYPEChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_Appeal Parent Reference
Relationship APPTYPEParRef As PACAppeal [ Cardinality = parent, Inverse = ChildPACAppealType, Required, SqlFieldName = APPTYPE_ParRef ];

/// Childsub
Property APPTYPEChildsub As %Float [ InitialExpression = {$i(^PAC("APPEAL",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"TYPE",0))}, SqlColumnNumber = 2, SqlFieldName = APPTYPE_Childsub ];

/// Code
Property APPTYPECode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = APPTYPE_Code ];

/// Description
Property APPTYPEDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = APPTYPE_Desc ];

/// DateFrom
Property APPTYPEDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = APPTYPE_DateFrom ];

/// DateTo
Property APPTYPEDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = APPTYPE_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACAppealType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAppealType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACAppealType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAppealType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACAppealType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAppealType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACAppealType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAppealType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACAppealType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAppealType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="APPTYPE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APPTYPE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APPTYPE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APPTYPE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_Appeal.APPEAL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>APPTYPE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"APPEAL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_Appeal.APPEAL_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APPTYPE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>APPTYPE_RowId</SqlRowIdName>
<StreamLocation>^User.PACAppealTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
