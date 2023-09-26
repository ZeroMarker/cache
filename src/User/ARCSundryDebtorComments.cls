/// SundryDebtorComments(2760)
Class User.ARCSundryDebtorComments Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_SundryDebtorComments, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CMTChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_SundryDebtor Parent Reference
Relationship CMTParRef As ARCSundryDebtor [ Cardinality = parent, Inverse = ChildARCSundryDebtorComments, Required, SqlFieldName = CMT_ParRef ];

/// Childsub
Property CMTChildsub As %Float [ InitialExpression = {$i(^ARC("SUNDEB",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"COMMENTS",0))}, SqlColumnNumber = 2, SqlFieldName = CMT_Childsub ];

/// Date
Property CMTDate As %Date [ SqlColumnNumber = 3, SqlFieldName = CMT_Date ];

/// Time
Property CMTTime As %Time [ SqlColumnNumber = 4, SqlFieldName = CMT_Time ];

/// Des Ref User
Property CMTUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = CMT_User_DR ];

/// Des Ref Hospital
Property CMTHospitalDR As CTHospital [ SqlColumnNumber = 6, SqlFieldName = CMT_Hospital_DR ];

/// Comments
Property CMTComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CMT_Comments, SqlListType = SUBNODE ];

/// FutureDate
Property CMTFutureDate As %Date [ SqlColumnNumber = 8, SqlFieldName = CMT_FutureDate ];

/// LastUpateDate
Property CMTLastUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = CMT_LastUpdateDate ];

/// LastUpdateTime
Property CMTLastUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = CMT_LastUpdateTime ];

/// Des Ref LastUpdateUser
Property CMTLastUpdateUserDR As SSUser [ SqlColumnNumber = 11, SqlFieldName = CMT_LastUpdateUser_DR ];

/// Des Ref LastUpdateHospital
Property CMTLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 12, SqlFieldName = CMT_LastUpdateHospital_DR ];

/// ShortDesc
Property CMTShortDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CMT_ShortDesc ];

/// OnHold
Property CMTOnHold As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = CMT_OnHold ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCSundryDebtorComments).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSundryDebtorComments","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCSundryDebtorComments).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSundryDebtorComments","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCSundryDebtorComments).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSundryDebtorComments","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCSundryDebtorComments).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSundryDebtorComments","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCSundryDebtorComments).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSundryDebtorComments","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSundryDebtorComments","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="CMTChildsub">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CMTComments">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CMTDate">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CMTFutureDate">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CMTHospitalDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CMTLastUpdateDate">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CMTLastUpdateHospitalDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CMTLastUpdateTime">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="CMTLastUpdateUserDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CMTOnHold">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CMTParRef">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CMTShortDesc">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="CMTTime">
<Selectivity>25.0000%</Selectivity>
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
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_SundryDebtor.DEB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CMT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SUNDEB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_SundryDebtor.DEB_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"COMMENTS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CMT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CMT_RowId</SqlRowIdName>
<StreamLocation>^User.ARCSundryDebtorCommentsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
