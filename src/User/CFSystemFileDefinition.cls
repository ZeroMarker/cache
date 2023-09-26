/// CF System File Definition(1567)
Class User.CFSystemFileDefinition Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_SystemFileDefinition, StorageStrategy = SQLStorage ]
{

Relationship ChildCFSystemFilePath As CFSystemFilePath [ Cardinality = children, Inverse = PATHParRef ];

/// Description
Property FILEDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = FILE_Desc ];

/// Type
Property FILEType As %String(DISPLAYLIST = ",Read/Write,Archive,Cache", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",RW,A,C") [ Required, SqlColumnNumber = 3, SqlFieldName = FILE_Type ];

/// File Extension
Property FILEFileExtension As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = FILE_FileExtension ];

/// Counter
Property FILECounter As %Float [ SqlColumnNumber = 5, SqlFieldName = FILE_Counter ];

/// Label Prefix
Property FILELabelPrefix As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = FILE_LabelPrefix ];

/// WEB Server Virtual Directory
Property FILEVirtualDirectory As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = FILE_VirtualDirectory ];

/// New Counter
Property FILENewCounter As %Float [ SqlColumnNumber = 8, SqlComputeCode = { s {FILE_NewCounter}=$$CO8^at1567({FILE_RowId})
}, SqlComputed, SqlFieldName = FILE_NewCounter, Transient ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFSystemFileDefinition).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSystemFileDefinition","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFSystemFileDefinition).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSystemFileDefinition","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFSystemFileDefinition).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSystemFileDefinition","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFSystemFileDefinition).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSystemFileDefinition","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFSystemFileDefinition).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSystemFileDefinition","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFSystemFileDefinition","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CF("FILE",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="FILE_Counter">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FILE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FILE_FileExtension">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FILE_LabelPrefix">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FILE_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FILE_VirtualDirectory">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^COUNT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>FILE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FILE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{FILE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^COUNT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>FILE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FILE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({FILE_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FILE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FILE_RowId</SqlRowIdName>
<StreamLocation>^User.CFSystemFileDefinitionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
