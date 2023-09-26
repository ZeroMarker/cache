/// CMC Bank Master          (CMCBM,17)
Class User.CMCBankMas Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CMC_BankMas, StorageStrategy = SQLStorage ]
{

/// Bank Master Code
Property CMCBMCode As %String(COLLATION = "AlphaUp", MAXLEN = 10, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CMCBM_Code ];

/// Bank Master Description
Property CMCBMDesc As %String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CMCBM_Desc ];

/// Archived Flag
Property CMCBMRcFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 4, SqlFieldName = CMCBM_RcFlag ];

/// Des Ref to CTCO
Property CMCBMCompDR As CTCompany [ SqlColumnNumber = 5, SqlFieldName = CMCBM_Comp_DR ];

/// Date From
Property CMCBMDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = CMCBM_DateFrom ];

/// Date To
Property CMCBMDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = CMCBM_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CMCBankMas).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CMCBankMas","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CMCBankMas).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CMCBankMas","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CMCBankMas).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CMCBankMas","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CMCBankMas).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CMCBankMas","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CMCBankMas).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CMCBankMas","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CMC("CMCBM",0))</SqlIdExpression>
<SQLMap name="CMCBMDataMasterMap">
<Data name="CMCBM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CMCBM_Comp_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CMCBM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CMCBM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CMCBM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CMCBM_RcFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CMC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CMCBM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CMCBM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CMCBM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="CMCBMIndexCode">
<Data name="CMCBM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CMC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CMCBM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CMCBM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CMCBM_Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CMCBM_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CMCBM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="CMCBMIndexDesc">
<Data name="CMCBM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CMC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CMCBM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CMCBM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CMCBM_Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CMCBM_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CMCBM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CMCBM_RowId</SqlRowIdName>
<StreamLocation>^User.CMCBankMasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
