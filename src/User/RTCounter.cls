/// RT System Counter        (RTSC,677)
Class User.RTCounter Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RT_Counter, StorageStrategy = SQLStorage ]
{

/// MR No
Property RTSCMRNo As %Float [ SqlColumnNumber = 2, SqlFieldName = RTSC_MRNo ];

/// MRNo Length
Property RTSCMRNoLength As %Float [ SqlColumnNumber = 3, SqlFieldName = RTSC_MRNo_Length ];

/// MRNo Prefix
Property RTSCMRNoPrefix As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = RTSC_MRNo_Prefix ];

/// MRNO Suffix
Property RTSCMRNoSuffix As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = RTSC_MRNo_Suffix ];

/// RT_Counter Row ID
Property RTSCRowId As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ InitialExpression = 1, Required, SqlFieldName = RTSC_RowId ];

Index RowIDBasedIDKeyIndex On RTSCRowId [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTCounter).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCounter","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTCounter).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCounter","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTCounter).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCounter","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTCounter).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCounter","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTCounter).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCounter","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="RTSCMRNo">
<Selectivity>1</Selectivity>
</Property>
<Property name="RTSCMRNoLength">
<Selectivity>1</Selectivity>
</Property>
<Property name="RTSCMRNoPrefix">
<Selectivity>1</Selectivity>
</Property>
<Property name="RTSCMRNoSuffix">
<Selectivity>1</Selectivity>
</Property>
<Property name="RTSCRowId">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>1</SqlIdExpression>
<SQLMap name="DataMasterRTCF">
<Data name="RTSC_MRNo">
<Node>"MR_No"</Node>
</Data>
<Data name="RTSC_MRNo_Length">
<Node>"MR_Len"</Node>
</Data>
<Data name="RTSC_MRNo_Prefix">
<Node>"MR_Pre"</Node>
</Data>
<Data name="RTSC_MRNo_Suffix">
<Node>"MR_Suf"</Node>
</Data>
<Global>^RTC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RTSC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CN"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RTSC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RTSC_RowId</SqlRowIdName>
<StreamLocation>^User.RTCounterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
