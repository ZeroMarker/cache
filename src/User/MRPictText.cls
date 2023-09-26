/// MR PictureText          (MRPT,1206)
Class User.MRPictText Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_PictText, StorageStrategy = SQLStorage ]
{

/// Childsub
Property MRPTChildsub As %Float [ InitialExpression = {$i(^MR($p(%d(0),"||"),"PIC",$p(%d(0),"||",2),"TEXT",0))}, SqlColumnNumber = 2, SqlFieldName = MRPT_Childsub ];

/// Text Height
Property MRPTHeight As %Float [ SqlColumnNumber = 3, SqlFieldName = MRPT_Height ];

/// MR_Pictures Parent Reference
Relationship MRPTParRef As MRPictures [ Cardinality = parent, Inverse = ChildMRPictText, Required, SqlFieldName = MRPT_ParRef ];

/// Text
Property MRPTText As list Of %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = MRPT_Text, SqlListType = SUBNODE ];

/// Text X Coord
Property MRPTTextXCoord As %Float [ SqlColumnNumber = 5, SqlFieldName = MRPT_TextXCoord ];

/// TextYCoord
Property MRPTTextYCoord As %Float [ SqlColumnNumber = 6, SqlFieldName = MRPT_TextYCoord ];

/// Width
Property MRPTWidth As %Float [ SqlColumnNumber = 4, SqlFieldName = MRPT_Width ];

Index RowIDBasedIDKeyIndex On MRPTChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 14;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRPictText).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRPictText","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRPictText).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRPictText","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRPictText).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRPictText","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRPictText).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRPictText","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRPictText).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRPictText","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>14</ExtentSize>
<Property name="MRPTChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRPTHeight">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRPTParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRPTText">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRPTTextXCoord">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRPTTextYCoord">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRPTWidth">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="MRPT_Height">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRPT_Text">
<Node>"TX"</Node>
</Data>
<Data name="MRPT_TextXCoord">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRPT_TextYCoord">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRPT_Width">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MR_Pictures.PIC_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>MRPT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Pictures.PIC_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TEXT"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRPT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MRPT_RowId</SqlRowIdName>
<StreamLocation>^User.MRPictTextS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
