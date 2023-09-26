/// APC Vendor Category     (APCVC,235)
Class User.APCVendCat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = APC_VendCat, StorageStrategy = SQLStorage ]
{

/// Des Ref to CTCO
Property APCVCCoCodeDR As CTCompany [ SqlColumnNumber = 2, SqlFieldName = APCVC_CoCode_DR ];

/// APCVC Code
Property APCVCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = APCVC_Code ];

/// APCVC Description
Property APCVCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = APCVC_Desc ];

/// Archived Flag
Property APCVCRcFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 5, SqlFieldName = APCVC_RcFlag ];

/// APCVC StkType
Property APCVCStkType As %String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 6, SqlFieldName = APCVC_StkType ];

Parameter EXTENTSIZE = 0;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.APCVendCat).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.APCVendCat","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.APCVendCat).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.APCVendCat","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.APCVendCat).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.APCVendCat","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.APCVendCat).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.APCVendCat","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.APCVendCat).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.APCVendCat","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>0</ExtentSize>
<Property name="APCVCCoCodeDR"/>
<SqlIdExpression>$i(^APC("APCVC",0))</SqlIdExpression>
<SQLMap name="APCVCDATAMasterMap">
<Data name="APCVC_CoCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APCVC_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APCVC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APCVC_RcFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APCVC_StkType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^APC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>APCVC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"APCVC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{APCVC_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="APCVCIndexAPCVCCode">
<Data name="APCVC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^APC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>APCVC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"APCVC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"APCVC_Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({APCVC_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{APCVC_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="APCVCIndexAPCVCDesc">
<Data name="APCVC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^APC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>APCVC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"APCVC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"APCVC_Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({APCVC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{APCVC_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>APCVC_RowId</SqlRowIdName>
<StreamLocation>^User.APCVendCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
