/// OE Ord Item Res Archive File(1462)
Class User.OEOrdItmResArchiveFile Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdItmResArchiveFile, StorageStrategy = SQLStorage ]
{

/// File Name
Property OEARFFileName As %String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = OEARF_FileName ];

/// Des Ref OE OrdResult
Property OEARFOEOrdResultDR As OEOrdResult [ SqlColumnNumber = 3, SqlFieldName = OEARF_OEOrdResult_DR ];

/// OE_OrdItmResArchive Parent Reference
Relationship OEARFParRef As OEOrdItmResArchive [ Cardinality = parent, Inverse = ChildOEOrdItmResArchiveFile, Required, SqlFieldName = OEARF_ParRef ];

Index RowIDBasedIDKeyIndex On OEARFFileName [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdItmResArchiveFile).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdItmResArchiveFile","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdItmResArchiveFile).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdItmResArchiveFile","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdItmResArchiveFile).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdItmResArchiveFile","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdItmResArchiveFile).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdItmResArchiveFile","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdItmResArchiveFile).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdItmResArchiveFile","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="OEARFFileName">
<Selectivity>1</Selectivity>
</Property>
<Property name="OEARFOEOrdResultDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="OEARFParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="OEARF_OEOrdResult_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OEARC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_OrdItmResArchive.OEARC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OEARF_FileName</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_OrdItmResArchive.OEARC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FIL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEARF_FileName}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OEARF_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdItmResArchiveFileS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
