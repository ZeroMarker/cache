/// MR Objective Findings   (MROBJ,307)
Class User.MRObjFind Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_ObjFind, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MROBJChildsub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to MRADM
Relationship MROBJMRADMParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRObjFind, Required, SqlFieldName = MROBJ_MRADM_ParRef ];

/// MROBJ Childsub (NewKey)
Property MROBJChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"OBJ",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MROBJ_Childsub ];

/// Description of Objective Finding
Property MROBJDesc As list Of %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MROBJ_Desc, SqlListType = subnode ];

/// Objective Status
Property MROBJStatus As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MROBJ_Status ];

/// Des Ref to CTPCP
Property MROBJDocCodeDR As CTCareProv [ SqlColumnNumber = 5, SqlFieldName = MROBJ_DocCode_DR ];

/// Date
Property MROBJDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = MROBJ_Date ];

/// Time
Property MROBJTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 7, SqlFieldName = MROBJ_Time ];

/// Des Ref User
Property MROBJUpdateUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = MROBJ_UpdateUser_DR ];

/// RTF Notes
Property MROBJRTFNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = MROBJ_RTFNotes, SqlListType = subnode ];

/// Update Date
Property MROBJUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = MROBJ_UpdateDate ];

/// Update Time
Property MROBJUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = MROBJ_UpdateTime ];

/// Des Ref UpdateHospital
Property MROBJUpdateHospitalDR As CTHospital [ SqlColumnNumber = 13, SqlFieldName = MROBJ_UpdateHospital_DR ];

/// Des Ref EditCP_DR
Property MROBJEditCPDR As CTCareProv [ SqlColumnNumber = 14, SqlFieldName = MROBJ_EditCP_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRObjFind).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObjFind","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRObjFind).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObjFind","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRObjFind).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObjFind","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRObjFind).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObjFind","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObjFind","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRObjFind).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObjFind","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="MROBJDataMasterMap">
<Data name="MROBJ_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MROBJ_Desc">
<Node>"DESC"</Node>
</Data>
<Data name="MROBJ_DocCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MROBJ_EditCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MROBJ_RTFNotes">
<Node>"RTF"</Node>
</Data>
<Data name="MROBJ_Status">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MROBJ_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MROBJ_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MROBJ_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MROBJ_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MROBJ_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MROBJ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OBJ"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MROBJ_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MROBJ_RowId</SqlRowIdName>
<StreamLocation>^User.MRObjFindS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
