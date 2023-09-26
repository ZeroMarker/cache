/// PatMasComments(2759)
Class User.PAPatMasComments Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PatMasComments, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CMTChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_PatMas Parent Reference
Relationship CMTParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPAPatMasComments, Required, SqlFieldName = CMT_ParRef ];

/// Childsub
Property CMTChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"COMMENTS",0))}, SqlColumnNumber = 2, SqlFieldName = CMT_Childsub ];

/// Date
Property CMTDate As %Date [ SqlColumnNumber = 3, SqlFieldName = CMT_Date ];

/// Time
Property CMTTime As %Time [ SqlColumnNumber = 4, SqlFieldName = CMT_Time ];

/// Des Ref User
Property CMTUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = CMT_User_DR ];

/// Des Ref Hospital
Property CMTHospitalDR As CTHospital [ SqlColumnNumber = 6, SqlFieldName = CMT_Hospital_DR ];

/// Comments
Property CMTComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CMT_Comments, SqlListType = subnode ];

/// Future Date
Property CMTFutureDate As %Date [ SqlColumnNumber = 8, SqlFieldName = CMT_FutureDate ];

/// LastUpdateDate
Property CMTLastUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = CMT_LastUpdateDate ];

/// LastUpdateTime
Property CMTLastUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = CMT_LastUpdateTime ];

/// Des Ref LastUpdateUser
Property CMTLastUpdateUserDR As SSUser [ SqlColumnNumber = 11, SqlFieldName = CMT_LastUpdateUser_DR ];

/// Des Ref LastUpdateHospital
Property CMTLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 12, SqlFieldName = CMT_LastUpdateHospital_DR ];

/// Short Description
Property CMTShortDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CMT_ShortDesc ];

/// OnHold
Property CMTOnHold As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = CMT_OnHold ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAPatMasComments).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPatMasComments","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAPatMasComments).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPatMasComments","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAPatMasComments).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPatMasComments","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAPatMasComments).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPatMasComments","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAPatMasComments).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPatMasComments","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPatMasComments","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>11</ExtentSize>
<Property name="CMTChildsub">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="CMTComments">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="CMTDate">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CMTFutureDate">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="CMTHospitalDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CMTLastUpdateDate">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CMTLastUpdateHospitalDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CMTLastUpdateTime">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="CMTLastUpdateUserDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CMTOnHold">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CMTParRef">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CMTShortDesc">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="CMTTime">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="CMTUserDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
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
<Data name="CMT_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CMT_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CMT_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CMT_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CMT_OnHold">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CMT_ShortDesc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CMT_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CMT_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CMT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
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
<SqlRowIdName>CMT_RowId</SqlRowIdName>
<StreamLocation>^User.PAPatMasCommentsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
