/// E Mail Messages        (EMAIL,1121)
Class User.SSElectronicMail Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_ElectronicMail, StorageStrategy = SQLStorage ]
{

/// Date the Message was sent
Property EMAILDateSent As %Date [ SqlColumnNumber = 5, SqlFieldName = EMAIL_DateSent ];

/// Hospital Location for the Message
Property EMAILLocationDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = EMAIL_Location_DR ];

/// Message text
Property EMAILMessage As list Of %String(COLLATION = "Exact", MAXLEN = 70, TRUNCATE = 1) [ Required, SqlColumnNumber = 7, SqlFieldName = EMAIL_Message, SqlListType = SUBNODE ];

/// Has the Message been sent
Property EMAILSent As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlComputeCode = { s {EMAIL_Sent}="Y" i {EMAIL_DateSent}="" s {EMAIL_Sent}="N"
}, SqlComputed, SqlFieldName = EMAIL_Sent, Transient ];

/// Subject of the Message
Property EMAILSubject As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = EMAIL_Subject ];

/// Time the Message was sent
Property EMAILTimeSent As %Time [ SqlColumnNumber = 6, SqlFieldName = EMAIL_TimeSent ];

/// User
Property EMAILUserDR As SSUser [ Required, SqlColumnNumber = 2, SqlFieldName = EMAIL_User_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSElectronicMail).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSElectronicMail","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSElectronicMail).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSElectronicMail","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSElectronicMail).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSElectronicMail","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSElectronicMail).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSElectronicMail","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSElectronicMail).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSElectronicMail","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^EMAIL(0))</SqlIdExpression>
<SQLMap name="EMailMaster">
<Data name="EMAIL_DateSent">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EMAIL_Location_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EMAIL_Message">
<Node>"MSG"</Node>
</Data>
<Data name="EMAIL_Subject">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EMAIL_TimeSent">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EMAIL_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^EMAIL</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EMAIL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"EMAIL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{EMAIL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>EMAIL_RowID</SqlRowIdName>
<StreamLocation>^User.SSElectronicMailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
