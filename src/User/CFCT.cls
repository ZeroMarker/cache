/// CF Common Table          (CTCF,587)
Class User.CFCT Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_CT, StorageStrategy = SQLStorage ]
{

/// CTCF Row ID
/// Property CTCFRowId As %Float [ Required, SqlFieldName = CTCF_RowId ];
/// Des Ref to CTCUR (Base Currency)
Property CTCFCTCURDR As CTCurrency [ SqlColumnNumber = 5, SqlFieldName = CTCF_CTCUR_DR ];

/// Description
Property CTCFDescription As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CTCF_Description ];

/// Last Update Date
Property CTCFUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = CTCF_UpdateDate ];

/// Last Update Time
Property CTCFUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = CTCF_UpdateTime ];

/// Last Update User
Property CTCFUpdateUserDR As SSUser [ InitialExpression = {$g(XCONF("DPUSR",3))}, SqlColumnNumber = 9, SqlFieldName = CTCF_UpdateUser_DR ];

/// Working temp. Directory for write print file
Property CTCFTempDir As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CTCF_TempDir ];

/// Des Ref CTPayMode
Property CTCFPayMode As CTPayMode [ SqlColumnNumber = 11, SqlFieldName = CTCF_PayMode ];

/// Allow Multiple Currency
Property CTCFMultipleCurr As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = CTCF_MultipleCurr ];

/// Display Cheque Date
Property CTCFChequeDate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = CTCF_ChequeDate ];

/// Index RowIDBasedIDKeyIndex On CTCFRowId [ IdKey, PrimaryKey, Unique ];
Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFCT).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFCT","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFCT).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFCT","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFCT).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFCT","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFCT).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFCT","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFCT).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFCT","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFCT","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterCTCF">
<Data name="CTCF_CTCUR_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTCF_ChequeDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTCF_Description">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTCF_MultipleCurr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTCF_PayMode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTCF_TempDir">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTCF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTCF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTCF_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^CF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTCF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTCF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CTCF_RowId</SqlRowIdName>
<StreamLocation>^User.CFCTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
