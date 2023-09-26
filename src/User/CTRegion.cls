/// CT Region                (CTRG,419)
Class User.CTRegion Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Region, StorageStrategy = SQLStorage ]
{

/// Region Code
Property CTRGCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CTRG_Code ];

/// Des REf Country
Property CTRGCountryDR As CTCountry [ SqlColumnNumber = 5, SqlFieldName = CTRG_Country_DR ];

/// Description
Property CTRGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CTRG_Desc ];

/// Archived Flag
Property CTRGRcFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 4, SqlFieldName = CTRG_RcFlag ];

Index CTRGCodeUnqIdx1 On CTRGCode [ Unique ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTRegion).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTRegion","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTRegion).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTRegion","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTRegion).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTRegion","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTRegion).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTRegion","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTRegion).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTRegion","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="CTRGCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="CTRGCountryDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CTRGDesc">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CTRGRcFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("RG",0))</SqlIdExpression>
<SQLMap name="DataMasterMapCTRG">
<Data name="CTRG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTRG_Country_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTRG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTRG_RcFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RG"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTRG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTRGCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RG"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTRG_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTRG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTRGDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RG"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTRG_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTRG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTRG_RowId</SqlRowIdName>
<StreamLocation>^User.CTRegionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
