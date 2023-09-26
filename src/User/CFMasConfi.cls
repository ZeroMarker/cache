/// Master Config           (MACF,5001)
Class User.CFMasConfi Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_MasConfi, StorageStrategy = SQLStorage ]
{

/// Active
Property MACFActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "No", SqlColumnNumber = 6, SqlFieldName = MACF_Active ];

/// Des Ref to CFCT
Property MACFCTDR As CFCT [ SqlColumnNumber = 12, SqlFieldName = MACF_CT_DR ];

/// Desc
Property MACFDescription As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MACF_Description ];

/// Inventory
Property MACFINDR As CFInventory [ SqlColumnNumber = 9, SqlFieldName = MACF_IN_DR ];

/// User Logon Attempts
Property MACFLogonAttempts As %Float(MAXVAL = 999, MINVAL = 0) [ SqlColumnNumber = 13, SqlFieldName = MACF_LogonAttempts ];

/// Des Ref To OECF
Property MACFOEDR As CFOEConfig [ SqlColumnNumber = 4, SqlFieldName = MACF_OE_DR ];

/// Des Ref To PHCF
Property MACFPHDR As CFPharmCon [ SqlColumnNumber = 3, SqlFieldName = MACF_PH_DR ];

/// Patient Config
Property MACFPatCnfDR As CFPatConf [ SqlColumnNumber = 7, SqlFieldName = MACF_PatCnfDR ];

/// Resource Booking
Property MACFRBDR As CFRB [ SqlColumnNumber = 10, SqlFieldName = MACF_RB_DR ];

/// Record Tracking
Property MACFRTDR As CFRT [ SqlColumnNumber = 11, SqlFieldName = MACF_RT_DR ];

Index MACFDescriptionUnqIdx1 On MACFDescription [ Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFMasConfi).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFMasConfi","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFMasConfi).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFMasConfi","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFMasConfi).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFMasConfi","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFMasConfi).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFMasConfi","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFMasConfi).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFMasConfi","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="MACFActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MACFCTDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MACFDescription">
<Selectivity>1</Selectivity>
</Property>
<Property name="MACFINDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MACFLogonAttempts">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MACFOEDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MACFPHDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MACFPatCnfDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MACFRBDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MACFRTDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^CF("MACF",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MACF_Active">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MACF_CT_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MACF_Description">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MACF_IN_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MACF_LogonAttempts">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MACF_OE_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MACF_PH_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MACF_PatCnfDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MACF_RB_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MACF_RT_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^CF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MACF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MACF"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>{MACF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^CF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MACF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MACF_Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MACF_Active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MACF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MACF_RowID</SqlRowIdName>
<StreamLocation>^User.CFMasConfiS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
