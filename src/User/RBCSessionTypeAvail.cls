/// SessionTypeAvail(2539)
Class User.RBCSessionTypeAvail Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_SessionTypeAvail, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On AVLChildsub [ IdKey, PrimaryKey, Unique ];

/// RBC_SessionType Parent Reference
Relationship AVLParRef As RBCSessionType [ Cardinality = parent, Inverse = ChildRBCSessionTypeAvail, Required, SqlFieldName = AVL_ParRef ];

/// Childsub
Property AVLChildsub As %Float [ InitialExpression = {$i(^RBC("SESS",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"AVL",0))}, SqlColumnNumber = 2, SqlFieldName = AVL_Childsub ];

/// Des Ref ServiceGroup
Property AVLServiceGroupDR As RBCServiceGroup [ SqlColumnNumber = 3, SqlFieldName = AVL_ServiceGroup_DR ];

/// ReleaseDays
Property AVLReleaseDays As %Float [ SqlColumnNumber = 4, SqlFieldName = AVL_ReleaseDays ];

/// ReleaseTime
Property AVLReleaseTime As %Time [ SqlColumnNumber = 5, SqlFieldName = AVL_ReleaseTime ];

/// Des Ref DOW
Property AVLDOWDR As CTDayOfWeek [ SqlColumnNumber = 6, SqlFieldName = AVL_DOW_DR ];

/// Date From
Property AVLDateFrom As %Date [ SqlColumnNumber = 7, SqlFieldName = AVL_DateFrom ];

/// Date To
Property AVLDateTo As %Date [ SqlColumnNumber = 8, SqlFieldName = AVL_DateTo ];

/// Generate On Day
Property AVLGenerateOnDay As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = AVL_GenerateOnDay ];

/// Generate Until Day
Property AVLGenerateUntilDay As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = AVL_GenerateUntilDay ];

/// Number Of Months
Property AVLNumberOfMonths As %Float [ SqlColumnNumber = 11, SqlFieldName = AVL_NumberOfMonths ];

/// ConversionRules
Property AVLConversionRules As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = AVL_ConversionRules ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.RBCSessionTypeAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCSessionTypeAvail","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.RBCSessionTypeAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCSessionTypeAvail","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.RBCSessionTypeAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCSessionTypeAvail","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.RBCSessionTypeAvail).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCSessionTypeAvail","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.RBCSessionTypeAvail).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCSessionTypeAvail","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCSessionTypeAvail","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AVL_ConversionRules">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AVL_DOW_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AVL_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AVL_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AVL_GenerateOnDay">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AVL_GenerateUntilDay">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AVL_NumberOfMonths">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AVL_ReleaseDays">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AVL_ReleaseTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AVL_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RBC_SessionType.SESS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>AVL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBC_SessionType.SESS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AVL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AVL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>AVL_RowId</SqlRowIdName>
<StreamLocation>^User.RBCSessionTypeAvailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
