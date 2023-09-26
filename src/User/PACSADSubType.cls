/// SADSubType(2802)
Class User.PACSADSubType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SADSubType, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SADSTChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_DocumentType Parent Reference
Relationship SADSTParRef As PACDocumentType [ Cardinality = parent, Inverse = ChildPACSADSubType, Required, SqlFieldName = SADST_ParRef ];

/// Childsub
Property SADSTChildsub As %Float [ InitialExpression = {$i(^PAC("DOCTYPE",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SADST",0))}, SqlColumnNumber = 2, SqlFieldName = SADST_Childsub ];

/// Des Ref ScanAdmDocSubType
Property SADSTScanAdmDocSubTypeDR As PACScanAdminDocSubType [ SqlColumnNumber = 3, SqlFieldName = SADST_ScanAdmDocSubType_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACSADSubType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSADSubType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACSADSubType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSADSubType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACSADSubType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSADSubType","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACSADSubType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSADSubType","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSADSubType","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACSADSubType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSADSubType","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="SADST_ScanAdmDocSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_DocumentType.DOCTYPE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SADST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DOCTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_DocumentType.DOCTYPE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SADST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SADST_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSubType">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_DocumentType.DOCTYPE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>SADST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DOCTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_DocumentType.DOCTYPE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SADST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SubType"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SADST_ScanAdmDocSubType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SADST_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SADST_RowId</SqlRowIdName>
<StreamLocation>^User.PACSADSubTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
