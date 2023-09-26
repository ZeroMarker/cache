/// MR Pictures            (MRPIC,1134)
Class User.MRPictures Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_Pictures, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PICChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildMRPictLine As MRPictLine [ Cardinality = children, Inverse = MRPLParRef ];

Relationship ChildMRPictText As MRPictText [ Cardinality = children, Inverse = MRPTParRef ];

Relationship ChildMRPictOrdItem As MRPictOrdItem [ Cardinality = children, Inverse = ORDParRef ];

Relationship ChildMRPictConsRef As MRPictConsRef [ Cardinality = children, Inverse = REFParRef ];

Relationship ChildMRPictResults As MRPictResults [ Cardinality = children, Inverse = RESParRef ];

/// MR_Adm Parent Reference
Relationship PICParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRPictures, Required, SqlFieldName = PIC_ParRef ];

/// Childsub
Property PICChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PIC",0))}, SqlColumnNumber = 2, SqlFieldName = PIC_Childsub ];

/// Des Ref to MRCPict
Property PICMRCPictDR As MRCPictureCode [ SqlColumnNumber = 3, SqlFieldName = PIC_MRCPict_DR ];

/// Top Coord
Property PICTopCoord As %Float [ SqlColumnNumber = 4, SqlFieldName = PIC_TopCoord ];

/// Left Coord
Property PICLeftCoord As %Float [ SqlColumnNumber = 5, SqlFieldName = PIC_LeftCoord ];

/// Visible
Property PICVisible As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PIC_Visible ];

/// Type
Property PICType As %String(DISPLAYLIST = ",Prescanned,Scanned,Dicom,Scanned Request", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",P,S,D,R") [ SqlColumnNumber = 7, SqlFieldName = PIC_Type ];

/// Description
Property PICDesc As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PIC_Desc ];

/// Path
Property PICPath As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PIC_Path ];

/// Date Created
Property PICDateCreated As %Date [ SqlColumnNumber = 10, SqlFieldName = PIC_DateCreated ];

/// Time Created
Property PICTimeCreated As %Time [ SqlColumnNumber = 11, SqlFieldName = PIC_TimeCreated ];

/// User Created
Property PICUserCreated As SSUser [ SqlColumnNumber = 12, SqlFieldName = PIC_UserCreated ];

/// UpdateDate
Property PICUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = PIC_UpdateDate ];

/// UpdateTime
Property PICUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = PIC_UpdateTime ];

/// Des Ref UpdateUser
Property PICUpdateUserDR As SSUser [ SqlColumnNumber = 15, SqlFieldName = PIC_UpdateUser_DR ];

/// Des Ref UpdateHospital
Property PICUpdateHospitalDR As CTHospital [ SqlColumnNumber = 16, SqlFieldName = PIC_UpdateHospital_DR ];

/// Inactive
Property PICInactive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = PIC_Inactive ];

/// des ref to PAC_DocumentType
Property PICDocTypeDR As PACDocumentType [ SqlColumnNumber = 21, SqlFieldName = PIC_DocType_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRPictures).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictures","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRPictures).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictures","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRPictures).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictures","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRPictures).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictures","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictures","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRPictures).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictures","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PIC_DateCreated">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PIC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PIC_DocType_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PIC_Inactive">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PIC_LeftCoord">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIC_MRCPict_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIC_Path">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PIC_TimeCreated">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PIC_TopCoord">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIC_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PIC_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PIC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PIC_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PIC_UserCreated">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PIC_Visible">
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
<Field>PIC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PIC_RowId</SqlRowIdName>
<StreamLocation>^User.MRPicturesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
