/// ItemPregnBrfeedAlert(2746)
Class User.ARCItemPregnBrfeedAlert Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemPregnBrfeedAlert, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PBAChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_ItmMast Parent Reference
Relationship PBAParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemPregnBrfeedAlert, Required, SqlFieldName = PBA_ParRef ];

/// Childsub
Property PBAChildsub As %Float [ InitialExpression = {$i(^ARCIM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"PBA",0))}, SqlColumnNumber = 2, SqlFieldName = PBA_Childsub ];

/// Options
Property PBAOptions As %String(DISPLAYLIST = ",Breastfeeding,Pregnant", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",B,P") [ SqlColumnNumber = 3, SqlFieldName = PBA_Options ];

/// Message
Property PBAMessage As %String(DISPLAYLIST = ",Warning,Fatal", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",W,F") [ SqlColumnNumber = 4, SqlFieldName = PBA_Message ];

/// DateFrom
Property PBADateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = PBA_DateFrom ];

/// DateTo
Property PBADateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = PBA_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemPregnBrfeedAlert).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemPregnBrfeedAlert","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemPregnBrfeedAlert).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemPregnBrfeedAlert","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemPregnBrfeedAlert).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemPregnBrfeedAlert","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemPregnBrfeedAlert).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemPregnBrfeedAlert","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemPregnBrfeedAlert","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemPregnBrfeedAlert).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemPregnBrfeedAlert","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="PBA_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PBA_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PBA_Message">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PBA_Options">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ARCIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>PBA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PBA"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBA_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PBA_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemPregnBrfeedAlertS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
