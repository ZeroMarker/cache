/// CF System File Path(1568)
Class User.CFSystemFilePath Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_SystemFilePath, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PATHChildsub [ IdKey, PrimaryKey, Unique ];

/// CF_SystemFileDefinition Parent Reference
Relationship PATHParRef As CFSystemFileDefinition [ Cardinality = parent, Inverse = ChildCFSystemFilePath, Required, SqlFieldName = PATH_ParRef ];

/// Childsub
Property PATHChildsub As %Float [ InitialExpression = {$i(^CF("FILE",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PATH",0))}, SqlColumnNumber = 2, SqlFieldName = PATH_Childsub ];

/// Path
Property PATHPath As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PATH_Path ];

/// UNIXPath
Property PATHUNIXPath As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PATH_UNIXPath ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFSystemFilePath).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSystemFilePath","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFSystemFilePath).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSystemFilePath","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFSystemFilePath).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSystemFilePath","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFSystemFilePath).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSystemFilePath","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFSystemFilePath).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSystemFilePath","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSystemFilePath","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PATH_Path">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PATH_UNIXPath">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^COUNT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CF_SystemFileDefinition.FILE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PATH_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FILE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CF_SystemFileDefinition.FILE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PATH"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PATH_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PATH_RowId</SqlRowIdName>
<StreamLocation>^User.CFSystemFilePathS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
