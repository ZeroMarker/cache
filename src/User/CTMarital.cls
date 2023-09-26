/// CT Marital Status       (CTMAR,539)
Class User.CTMarital Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Marital, StorageStrategy = SQLStorage ]
{

/// 婚姻状况代码
Property CTMARCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTMAR_Code ];

/// 婚姻状况名称
Property CTMARDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTMAR_Desc ];

/// PRS2
Property CTMARPRS2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CTMAR_PRS2 ];

/// 开始日期
Property CTMARDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = CTMAR_DateFrom ];

/// 结束日期
Property CTMARDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = CTMAR_DateTo ];

/// 是否有效(Y/N)
Property CTMARActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 8, SqlFieldName = CTMAR_Activity ];

/// 系统创建日期
Property CTMARCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = CTMAR_CreateDate ];

/// 系统创建时间
Property CTMARCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = CTMAR_CreateTime ];

/// 系统创建人
Property CTMARCreateUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = CTMAR_CreateUser ];

/// 系统排序号
Property CTMARSeqNo As %Float [ SqlColumnNumber = 12, SqlFieldName = CTMAR_SeqNo ];

/// 系统最后更新日期
Property CTMARLastUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = CTMAR_LastUpdateDate ];

/// 系统最后更新时间
Property CTMARLastUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = CTMAR_LastUpdateTime ];

/// 系统最新更新人
Property CTMARLastUpdateUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = CTMAR_LastUpdateUser ];

/// 拼音码
Property CTMARPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CTMAR_PYCode ];

/// 五笔码
Property CTMARWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = CTMAR_WBCode ];

/// 备注
Property CTMARMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = CTMAR_Mark ];

Index CTMARCodeUnqIdx1 On CTMARCode [ Unique ];

Index CTMARDescUnqIdx2 On CTMARDesc [ Unique ];

Parameter EXTENTSIZE = 15;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTMarital).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTMarital","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTMarital).OnTrigger($g(%d(1)))             
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTMarital","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTMarital).OnTrigger($g(%d(1))) 
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTMarital","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTMarital).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTMarital","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTMarital).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTMarital","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>15</ExtentSize>
<Property name="CTMARCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="CTMARDateFrom">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CTMARDateTo">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CTMARDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="CTMARPRS2">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("MAR",0))</SqlIdExpression>
<SQLMap name="DataMasterCTMAR">
<Data name="CTMAR_Activity">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTMAR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTMAR_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTMAR_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTMAR_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTMAR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTMAR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTMAR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTMAR_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTMAR_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTMAR_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CTMAR_Mark">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CTMAR_PRS2">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTMAR_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CTMAR_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTMAR_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTMAR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"MAR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTMAR_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTMARCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTMAR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"MAR"</Expression>
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
<Expression>$$ALPHAUP({CTMAR_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTMAR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTMARDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTMAR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"MAR"</Expression>
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
<Expression>$$ALPHAUP({CTMAR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTMAR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTMAR_RowId</SqlRowIdName>
<StreamLocation>^User.CTMaritalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
