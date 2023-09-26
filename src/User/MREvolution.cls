/// MR Evolution(1606)
Class User.MREvolution Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_Evolution, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EVOChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Adm Parent Reference
Relationship EVOParRef As MRAdm [ Cardinality = parent, Inverse = ChildMREvolution, Required, SqlFieldName = EVO_ParRef ];

/// Childsub
Property EVOChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"EVO",0))}, SqlColumnNumber = 2, SqlFieldName = EVO_Childsub ];

/// Text
Property EVOText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EVO_Text, SqlListType = subnode ];

/// Des Ref CTCP
Property EVOCTCPDR As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = EVO_CTCP_DR ];

/// Date
Property EVODate As %Date [ SqlColumnNumber = 5, SqlFieldName = EVO_Date ];

/// Time
Property EVOTime As %Time [ SqlColumnNumber = 6, SqlFieldName = EVO_Time ];

/// Des Ref Update User
Property EVOUpdateUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = EVO_UpdateUser_DR ];

/// Des Ref UpdateHospital
Property EVOUpdateHospitalDR As CTHospital [ SqlColumnNumber = 8, SqlFieldName = EVO_UpdateHospital_DR ];

/// Update Date
Property EVOUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = EVO_UpdateDate ];

/// Update Time
Property EVOUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = EVO_UpdateTime ];

/// Des Ref EditCP
Property EVOEditCPDR As CTCareProv [ SqlColumnNumber = 11, SqlFieldName = EVO_EditCP_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MREvolution).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MREvolution","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MREvolution).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MREvolution","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MREvolution).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MREvolution","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MREvolution).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MREvolution","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MREvolution","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MREvolution).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MREvolution","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="EVO_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EVO_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EVO_EditCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EVO_Text">
<Node>"REM"</Node>
</Data>
<Data name="EVO_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EVO_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EVO_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EVO_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EVO_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EVO_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EVO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EVO_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>EVO_RowId</SqlRowIdName>
<StreamLocation>^User.MREvolutionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
