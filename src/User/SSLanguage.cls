/// SS Languange             (SSLAN,43)
Class User.SSLanguage Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_Language, StorageStrategy = SQLStorage ]
{

/// Language Code
Property CTLANCode As %String(COLLATION = "AlphaUp", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CTLAN_Code ];

/// Language Description
Property CTLANDesc As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTLAN_Desc ];

/// 是否有效(Y/N)
Property CTLANActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = CTLAN_Activity ];

/// 开始日期
Property CTLANStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = CTLAN_StartDate ];

/// 结束日期
Property CTLANEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = CTLAN_EndDate ];

/// 系统创建日期
Property CTLANCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = CTLAN_CreateDate ];

/// 系统创建时间
Property CTLANCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = CTLAN_CreateTime ];

/// 系统创建人
Property CTLANCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = CTLAN_CreateUser ];

/// 系统排序号
Property CTLANSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = CTLAN_SeqNo ];

/// 系统最后更新日期
Property CTLANLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = CTLAN_LastUpdateDate ];

/// 系统最后更新时间
Property CTLANLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = CTLAN_LastUpdateTime ];

/// 系统最新更新人
Property CTLANLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = CTLAN_LastUpdateUser ];

/// 拼音码
Property CTLANPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = CTLAN_PYCode ];

/// 五笔码
Property CTLANWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CTLAN_WBCode ];

/// 备注
Property CTLANMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CTLAN_Mark ];

Index CTLANDescUnqIdx1 On CTLANDesc [ Unique ];

Parameter EXTENTSIZE = 6;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSLanguage).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSLanguage","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSLanguage).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSLanguage","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSLanguage).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSLanguage","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSLanguage).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSLanguage","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSLanguage).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSLanguage","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="CTLANCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="CTLANDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^SS("LAN",0))</SqlIdExpression>
<SQLMap name="DateMasterCTLAN">
<Data name="CTLAN_Activity">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTLAN_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTLAN_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTLAN_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTLAN_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTLAN_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTLAN_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTLAN_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTLAN_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTLAN_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTLAN_Mark">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CTLAN_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CTLAN_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTLAN_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTLAN_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^SS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTLAN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"LAN"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTLAN_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLANCode">
<Condition>{CTLAN_Code}'=""</Condition>
<Global>^SS</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTLAN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"LAN"</Expression>
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
<Expression>$$ALPHAUP({CTLAN_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTLAN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTLANDesc">
<Global>^SS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTLAN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"LAN"</Expression>
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
<Expression>$$ALPHAUP({CTLAN_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTLAN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTLAN_RowId</SqlRowIdName>
<StreamLocation>^User.SSLanguageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
