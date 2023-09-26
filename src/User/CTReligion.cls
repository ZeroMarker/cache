/// 宗教信仰            (CTRLG,535)
Class User.CTReligion Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Religion, StorageStrategy = SQLStorage ]
{

/// 信仰代码
Property CTRLGCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTRLG_Code ];

/// 信仰名称
Property CTRLGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTRLG_Desc ];

/// 开始日期
Property CTRLGDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = CTRLG_DateFrom ];

/// 结束日期
Property CTRLGDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = CTRLG_DateTo ];

/// 是否有效(Y/N)
Property CTRLGActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 7, SqlFieldName = CTRLG_Activity ];

/// 系统创建日期
Property CTRLGCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = CTRLG_CreateDate ];

/// 系统创建时间
Property CTRLGCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = CTRLG_CreateTime ];

/// 系统创建人
Property CTRLGCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = CTRLG_CreateUser ];

/// 系统排序号
Property CTRLGSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = CTRLG_SeqNo ];

/// 系统最后更新日期
Property CTRLGLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = CTRLG_LastUpdateDate ];

/// 系统最后更新时间
Property CTRLGLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = CTRLG_LastUpdateTime ];

/// 系统最新更新人
Property CTRLGLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = CTRLG_LastUpdateUser ];

/// 拼音码
Property CTRLGPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CTRLG_PYCode ];

/// 五笔码
Property CTRLGWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CTRLG_WBCode ];

/// 备注
Property CTRLGMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = CTRLG_Mark ];

Index CTRLGCodeUnqIdx1 On CTRLGCode [ Unique ];

Index CTRLGDescUnqIdx2 On CTRLGDesc [ Unique ];

Parameter EXTENTSIZE = 115;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTReligion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTReligion","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTReligion).OnTrigger($g(%d(1)))             
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTReligion","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTReligion).OnTrigger($g(%d(1))) 
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTReligion","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTReligion).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTReligion","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTReligion).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTReligion","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>115</ExtentSize>
<Property name="CTRLGCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="CTRLGDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CTRLGDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CTRLGDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("RLG",0))</SqlIdExpression>
<SQLMap name="DataMasterCTRLG">
<Data name="CTRLG_Activity">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTRLG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTRLG_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTRLG_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTRLG_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTRLG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTRLG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTRLG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTRLG_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTRLG_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTRLG_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTRLG_Mark">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CTRLG_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CTRLG_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTRLG_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTRLG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RLG"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTRLG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTRLGCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTRLG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RLG"</Expression>
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
<Expression>$$ALPHAUP({CTRLG_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTRLG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTRLGDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTRLG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RLG"</Expression>
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
<Expression>$$ALPHAUP({CTRLG_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTRLG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTRLG_RowId</SqlRowIdName>
<StreamLocation>^User.CTReligionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
