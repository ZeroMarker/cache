/// Adm Comments(2398)
Class User.PAAdmComments Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmComments, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CMTChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Adm Parent Reference
Relationship CMTParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmComments, Required, SqlFieldName = CMT_ParRef ];

/// Childsub
Property CMTChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"COMMENTS",0))}, SqlColumnNumber = 2, SqlFieldName = CMT_Childsub ];

/// Date
Property CMTDate As %Date [ SqlColumnNumber = 3, SqlFieldName = CMT_Date ];

/// Time
Property CMTTime As %Time [ SqlColumnNumber = 4, SqlFieldName = CMT_Time ];

/// Des Ref User
Property CMTUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = CMT_User_DR ];

/// Des Ref Hospital
Property CMTHospitalDR As CTHospital [ SqlColumnNumber = 6, SqlFieldName = CMT_Hospital_DR ];

/// Comments
Property CMTComments As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = CMT_Comments, SqlListType = SUBNODE ];

/// Future Date
Property CMTFutureDate As %Date [ SqlColumnNumber = 8, SqlFieldName = CMT_FutureDate ];

/// Des Ref ARPBL
Property CMTARPBLDR As ARPatientBill [ SqlColumnNumber = 9, SqlFieldName = CMT_ARPBL_DR ];

/// LastUpateDate
Property CMTLastUpateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = CMT_LastUpateDate ];

/// LastUpdateTime
Property CMTLastUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = CMT_LastUpdateTime ];

/// Des Ref LastUpdateUser
Property CMTLastUpdateUserDR As SSUser [ SqlColumnNumber = 12, SqlFieldName = CMT_LastUpdateUser_DR ];

/// Des Ref LastUpdateHospital
Property CMTLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 13, SqlFieldName = CMT_LastUpdateHospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmComments).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmComments","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmComments).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmComments","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmComments).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmComments","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmComments).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmComments","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmComments).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmComments","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CMT_ARPBL_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CMT_Comments">
<Node>"CMT"</Node>
</Data>
<Data name="CMT_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CMT_FutureDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CMT_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CMT_LastUpateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CMT_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CMT_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CMT_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CMT_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CMT_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CMT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"COMMENTS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CMT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFutureaDate">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CMT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CMTFutDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CMT_FutureDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CMT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CMT_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmCommentsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
