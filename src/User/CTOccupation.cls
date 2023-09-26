/// 职业字典           (CTOCC,683)
Class User.CTOccupation Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Occupation, StorageStrategy = SQLStorage ]
{

/// 职业代码
Property CTOCCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTOCC_Code ];

/// 职业名称
Property CTOCCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTOCC_Desc ];

/// 开始日期
Property CTOCCDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = CTOCC_DateFrom ];

/// 结束日期
Property CTOCCDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = CTOCC_DateTo ];

/// 职业大类-外键
Property OCCUOCCUCCode As CT.BDP.CT.HOSOccuCategory [ SqlColumnNumber = 6, SqlFieldName = OCCU_OCCUCCode ];

/// 是否有效(Y/N)
Property OCCUSCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 7, SqlFieldName = OCCUSC_Activity ];

/// 系统创建日期
Property OCCUSCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = OCCUSC_CreateDate ];

/// 系统创建时间
Property OCCUSCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = OCCUSC_CreateTime ];

/// 系统创建人
Property OCCUSCCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = OCCUSC_CreateUser ];

/// 系统排序号
Property OCCUSCSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = OCCUSC_SeqNo ];

/// 系统最后更新日期
Property OCCUSCLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = OCCUSC_LastUpdateDate ];

/// 系统最后更新时间
Property OCCUSCLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = OCCUSC_LastUpdateTime ];

/// 系统最新更新人
Property OCCUSCLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = OCCUSC_LastUpdateUser ];

/// 拼音码
Property OCCUSCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = OCCUSC_PYCode ];

/// 五笔码
Property OCCUSCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = OCCUSC_WBCode ];

/// 备注
Property OCCUSCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = OCCUSC_Mark ];

Index CTOCCCodeUnqIdx1 On CTOCCCode [ Unique ];

Index CTOCCDescUnqIdx2 On CTOCCDesc [ Unique ];

/// 索引-职业大类-外键
Index IndexCategory On OCCUOCCUCCode;

Parameter EXTENTSIZE = 252;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTOccupation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTOccupation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTOccupation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTOccupation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTOccupation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTOccupation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTOccupation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTOccupation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTOccupation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTOccupation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>252</ExtentSize>
<Property name="CTOCCCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="CTOCCDateFrom">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CTOCCDateTo">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CTOCCDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("OCC",0))</SqlIdExpression>
<SQLMap name="DataMasterCTOCC">
<Data name="CTOCC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTOCC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTOCC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTOCC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OCCUSC_Activity">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OCCUSC_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OCCUSC_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OCCUSC_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OCCUSC_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OCCUSC_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OCCUSC_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OCCUSC_Mark">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OCCUSC_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OCCUSC_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OCCUSC_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OCCU_OCCUCCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTOCC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"OCC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTOCC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTOCC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"OCC"</Expression>
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
<Expression>$$ALPHAUP({CTOCC_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTOCC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTOCC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"OCC"</Expression>
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
<Expression>$$ALPHAUP({CTOCC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{CTOCC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOCCUCCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"OCC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OCCUCCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OCCU_OCCUCCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTOCC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTOCC_RowId</SqlRowIdName>
<StreamLocation>^User.CTOccupationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
