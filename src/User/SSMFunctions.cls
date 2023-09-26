/// M Functions available   (SSMFS,775)
Class User.SSMFunctions Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_MFunctions, StorageStrategy = SQLStorage ]
{

/// Function Code
Property SSMFSCode As %String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 1) [ Required, SqlFieldName = SSMFS_Code ];

/// Description of the M Function
Property SSMFSDescription As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = SSMFS_Description ];

/// Function Type
Property SSMFSType As %String(DISPLAYLIST = ",Form,Report,Menu", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",F,R,M") [ Required, SqlColumnNumber = 3, SqlFieldName = SSMFS_Type ];

Index RowIDBasedIDKeyIndex On SSMFSCode [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 113;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSMFunctions).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMFunctions","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSMFunctions).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMFunctions","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSMFunctions).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMFunctions","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSMFunctions).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMFunctions","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSMFunctions).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMFunctions","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>113</ExtentSize>
<Property name="SSMFSCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="SSMFSDescription">
<Selectivity>1</Selectivity>
</Property>
<Property name="SSMFSType">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="SSFMSMaster">
<Data name="SSMFS_Description">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSMFS_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^SS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SSMFS_Code</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SSMFS"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{SSMFS_Code}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SSMFS_Code</SqlRowIdName>
<StreamLocation>^User.SSMFunctionsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
