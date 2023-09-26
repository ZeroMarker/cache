/// OrdCatPregnBrFdAlert(2748)
Class User.OECOrdCatPregnBrFdAlert Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_OrdCatPregnBrFdAlert, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PBAChildsub [ IdKey, PrimaryKey, Unique ];

/// OEC_OrderCategory Parent Reference
Relationship PBAParRef As OECOrderCategory [ Cardinality = parent, Inverse = ChildOECOrdCatPregnBrFdAlert, Required, SqlFieldName = PBA_ParRef ];

/// Childsub
Property PBAChildsub As %Float [ InitialExpression = {$i(^OEC("ORCAT",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PBA",0))}, SqlColumnNumber = 2, SqlFieldName = PBA_Childsub ];

/// Options
Property PBAOptions As %String(DISPLAYLIST = ",Breastfeeding,Pregnant", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",B,P") [ SqlColumnNumber = 3, SqlFieldName = PBA_Options ];

/// Message
Property PBAMessage As %String(DISPLAYLIST = ",Warning,Fatal", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",W,F") [ SqlColumnNumber = 4, SqlFieldName = PBA_Message ];

/// DateFrom
Property PBADateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = PBA_DateFrom ];

/// DateTo
Property PBADateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = PBA_DateTo ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.OECOrdCatPregnBrFdAlert).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatPregnBrFdAlert","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.OECOrdCatPregnBrFdAlert).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatPregnBrFdAlert","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.OECOrdCatPregnBrFdAlert).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatPregnBrFdAlert","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.OECOrdCatPregnBrFdAlert).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatPregnBrFdAlert","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.OECOrdCatPregnBrFdAlert).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatPregnBrFdAlert","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatPregnBrFdAlert","OnBeforeInsert")
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
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_OrderCategory.ORCAT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PBA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ORCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_OrderCategory.ORCAT_RowId}</Expression>
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
<StreamLocation>^User.OECOrdCatPregnBrFdAlertS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
